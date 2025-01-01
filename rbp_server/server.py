import os
import psycopg2
from dotenv import load_dotenv
from flask import Flask, url_for, redirect, render_template, request


load_dotenv()
app = Flask(__name__)


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
# cur.execute("CREATE TABLE books (id serial PRIMARY KEY,"
#                                  "title varchar (150) NOT NULL,"
#                                  "author varchar (50) NOT NULL,"
#                                  "pages_num integer NOT NULL,"
#                                  "review text,"
#                                  "date_added date DEFAULT CURRENT_TIMESTAMP);"
#                                  )

cur.execute("CREATE TABLE devices (mac_addr macaddr PRIMARY KEY,"
                                    "ip_addr inet UNIQUE NOT NULL,"
                                    "name varchar (60) NOT NULL,"
                                    "type varchar (60) NOT NULL,"
                                    "status varchar (8) DEFAULT 'SECURE');"
                                    )

cur.execute("CREATE TABLE packets (id serial PRIMARY KEY,"
                                    "source_ip_addr inet NOT NULL,"
                                    "dest_ip_addr inet NOT NULL);")
# Insert data into the table

cur.execute("INSERT INTO devices (mac_addr, ip_addr, name)"
            "VALUES (%s, %s, %s)",
            ("01:23:45:67:89:AB",
             "192.168.0.1",
             "Test Phone 2")
            )

conn.commit()

cur.close()
conn.close()



@app.route("/devices")
def get_devices():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("SELECT mac_addr, ip_addr FROM devices;")
    devices = cur.fetchall()
    cur.close()
    conn.close()
    print(devices)
    return devices

@app.route("/add", methods=['POST'])
def add_device():
    device_info = request.json
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("INSERT INTO devices (mac_addr, ip_addr, name, type, status)"
                "VALUES (%s, %s, %s, %s)",
                (device_info['macAddr'],
                device_info['ipAddr'],
                device_info['name'],
                device_info['type'],
                device_info['status'])
                )
    
    cur.close()
    conn.close()
    return redirect(url_for("index"))




@app.route("/")
def index():
    return render_template("index.html")