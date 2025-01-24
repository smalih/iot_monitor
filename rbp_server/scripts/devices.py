import os
import sys
import subprocess
import time

leases_path = "/var/lib/NetworkManager/dnsmasq-wlan0.leases"

def update_device_list(server_path):
    print(server_path)
    script_path = os.path.join(server_path, "scripts/devices.sh")
    try:
        with open(leases_path, 'r') as leases_file:
            devices = leases_file.readlines()
    except FileNotFoundError:
        print("File not found", file=sys.stderr)
    except IOError:
        print("An error while reading leases file. Please try again")

    print(script_path)
    print("getting devices...")
    start = time.time()
    subprocess.call(script_path, shell=True)
    stop = time.time()
    print(f"DONE ({(stop - start)*1000}ms)")


update_device_list("~/iot_monitor/rbp_server")