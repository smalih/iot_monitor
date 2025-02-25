import os
import psycopg2
import psycopg2.extras
from dotenv import load_dotenv
from fastapi import FastAPI
from pydantic import BaseModel
from enum import Enum

from scripts.devices import get_lease_device_info

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
    

load_dotenv()
app = FastAPI()


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
             "Phone")
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

# this doesn't make sense - app is simply an interface
# does not add any devices - all data comes from server
@app.post("/addDevice/")
def add_device(device_info: DeviceInfo):
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("INSERT INTO devices (mac_addr, ip_addr, name, type)"
                "VALUES (%s, %s, %s, %s)",
                (device_info['macAddr'],
                device_info['ipAddr'],
                device_info['name'],
                device_info['type'])
                )
    conn.commit()
    cur.close()
    conn.close()



# @app.route("/mockInsert")
# def insert_mock_device():
#     conn = get_db_connection()
#     cur = conn.cursor()
#     cur.execute("INSERT INTO devices (mac_addr, ip_addr, name, type, status)"
#             "VALUES (%s, %s, %s, %s, %s)",
#             ("01:24:45:67:89:AB",
#              "192.168.0.5",
#              "Test Phone 8",
#              "Phone",
#              "DEFAULT")
#             )
#     conn.commit()
#     cur.close()
#     conn.close()
#     return redirect(url_for("get_devices"))

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
        return "Update successful"
    except Exception:
        return "An error occurred. Please try again later."



@app.get("/temp")
def update_device_names():
    lease_device_info = get_lease_device_info()
    if lease_device_info is not None:
        conn = get_db_connection()
        cur = conn.cursor()

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
        return "Update successful"

# id SERIAL PRIMARY KEY,"
#                                     "mac_addr macaddr UNIQUE NOT NULL,"
#                                     "ip_addr inet UNIQUE NOT NULL,"
#                                     "name varchar (60),"
#                                     "type varchar (60) DEFAULT 'OTHER',"
#                                     "status varchar (8) DEFAULT 'SECURE')