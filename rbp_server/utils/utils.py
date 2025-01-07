import os

print(os.getcwd())

cwd = os.getcwd()

def get_devices(cur):
    cur.execute("SELECT * FROM devices;")
    devices = cur.fetchall()
    return devices