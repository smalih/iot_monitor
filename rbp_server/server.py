import os
import psycopg2
import psycopg2.extras
from dotenv import load_dotenv

import time
from datetime import datetime

import pandas as pd
import numpy as np

import threading 

import subprocess

from apscheduler.schedulers.asyncio import AsyncIOScheduler
from contextlib import asynccontextmanager

from fastapi import FastAPI

from pydantic import BaseModel
from enum import Enum

import uvicorn

from scripts.devices import get_lease_device_info
from scripts.ids import classify_data
# from scripts.analyse import run_cicflowmeter





class DeviceType(Enum):
    PHONE = "PHONE"
    SPEAKER = "SPEAKER"
    OTHER = "OTHER"

class DeviceInfo(BaseModel):
    id: str
    name: str
    type: DeviceType
    ipAddr: str
    macAddr: str
    
@asynccontextmanager
async def lifespan(app: FastAPI):
    scheduler = AsyncIOScheduler()
    scheduler.add_job(func=update_from_lease_info, trigger="interval", seconds=10)
    scheduler.start()
    yield

load_dotenv()
app = FastAPI(lifespan=lifespan)


def get_db_connection():
    conn = psycopg2.connect(host="localhost",
                            database="flask_db",
                            user=os.environ["DB_USERNAME"],
                            password=os.environ["DB_PASSWORD"])
    return conn

conn = get_db_connection()
cur = conn.cursor()

# print(os.environ["DB_PASSWORD"])

# Execute a command: this creates a new table
cur.execute("DROP TABLE IF EXISTS devices, packets;")

cur.execute("CREATE TABLE devices (id SERIAL PRIMARY KEY,"
                                    "mac_addr macaddr UNIQUE NOT NULL,"
                                    "ip_addr inet NOT NULL,"
                                    "name varchar (60) DEFAULT 'UNKNOWN',"
                                    "type varchar (60) DEFAULT 'OTHER',"
                                    "status varchar (8) DEFAULT 'SECURE');"
                                    )

cur.execute("CREATE TABLE packets (id serial PRIMARY KEY,"
                                    "source_ip_addr inet NOT NULL,"
                                    "dest_ip_addr inet NOT NULL);")
# Insert data into the table
cur.execute("INSERT INTO devices (mac_addr, ip_addr, name, type)"
            "VALUES (%s, %s, %s, %s)",
            ("01:23:45:67:89:AB",
             "192.168.0.1",
             "Test Phone 2",
             "PHONE")
            )
 
conn.commit()

cur.close()
conn.close()



@app.get("/devices")
async def get_devices():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("SELECT json_agg(row_to_json(t)) FROM (SELECT * FROM devices) t;")
    devices = cur.fetchone()[0]
    cur.close()
    conn.close()
    print(devices)
    return devices


@app.put("/update")
def update_device(device_info: DeviceInfo):
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("UPDATE devices "
                    "SET name = %s,"
                    "type = %s "
                    "WHERE id = %s;",
                    (device_info['name'],
                    device_info['type'],
                    device_info['id'])
                    )
        
        conn.commit()
        cur.close()
        conn.close()
    except Exception:
        return "An error occurred. Please try again later."


async def update_from_lease_info():
    lease_device_info = get_lease_device_info()
    if lease_device_info is not None:
        conn = get_db_connection()
        cur = conn.cursor()

        # may change to batch update later on
        for device_info in lease_device_info:

            # insert full information if mac_addr not previously recognised
            cur.execute("INSERT INTO devices (mac_addr, ip_addr, name) "
                        "VALUES (%s, %s, %s) "
                        "ON CONFLICT (mac_addr) DO NOTHING;",
                        (device_info.mac_addr,
                        device_info.ip_addr,
                        device_info.name)
                        )
            
            # update device ip_addr and name
            cur.execute("UPDATE devices SET "
                        "ip_addr = %s, "
                        "name = CASE  "
                        "WHEN name = 'UNKNOWN' THEN %s "
                        "ELSE name "
                        "END "
                        "WHERE mac_addr = %s;",
                        (device_info.ip_addr,
                        device_info.name,
                        device_info.mac_addr)
                        )
            
        conn.commit()
        cur.close()
        conn.close()


def alert_attack(classification, attack_datetime):
    classification['dst_ip'].startswith("10.")
    classification['datetime'] = attack_datetime

    return classification.to_json(date_unit='s')



def read_logs(log_file_name):
    print(f"Monitoring {log_file_name} for updates")
    log_path = os.path.join("/home/smalih/iot_monitor/rbp_server/cicflowmeter", log_file_name)
    print(f"read_logs file path: {log_path}")
    while not os.path.exists(log_path):
        time.sleep(10) # initial wait whilst cicflowmeter tool loads up
    while True:
        classifications = classify_data(log_path)
        if classifications is not None:
            attack_datetime = datetime.now()
            for classification in classifications:
                alert_attack(classification, attack_datetime)


        time.sleep(10)


class ThreadTaskRunner:
    def __init__(self, name, target, command_args=None):
        self.name = name
        self.target = target
        self.process = None
        self.thread = None
        self.running = True
        self.command_args = command_args

    def start(self):
        self.thread = threading.Thread(target=self.target, args=self.command_args)
        self.thread.start()
        print(f"Started {self.name} in background")


    def stop(self):
        self.running = False
        print(f"{self.name} stopped successfully")

class CLIToolRunner:
    def __init__(self, name, cli_command, command_args=None):
        self.name = name
        self.cli_command = cli_command
        self.process = None
        self.thread = None
        self.running = True
        self.command_args = command_args

    def start(self):
        self.thread = threading.Thread(target=self.run_cli, args=self.command_args)
        self.thread.start()
        print(f"Started {self.name} in background")

    def run_cli(self, log_file_name):
        self.process = subprocess.Popen(f'{self.cli_command} {log_file_name}', shell=True)

    def stop(self):
        self.running = False
        if self.process:
            self.process.terminate()
            self.process.wait()
            print(f"{self.name} stopped successfully")


if __name__ == '__main__':
    log_file_name = f"{time.strftime('%Y%m%d-%H%M')}.csv"
    t1 = CLIToolRunner('cicflowmeter_runner', 'cd /home/smalih/iot_monitor/rbp_server/cicflowmeter && poetry run cicflowmeter -i wlan0 -c ', (log_file_name, ))
    t2 = ThreadTaskRunner('read_logs_func', read_logs, (log_file_name, ))

    t1.start()
    time.sleep(1)
    t2.start()
    uvicorn.run(app, host='0.0.0.0', port=8000)
    t1.stop()
    t2.stop()