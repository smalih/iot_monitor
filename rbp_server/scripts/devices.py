import os
import sys
import subprocess
import time

leases_path = "/var/lib/NetworkManager/dnsmasq-wlan0.leases"

def update_device_list(server_path):
    print(server_path)
    script_path = os.path.join(server_path, "scripts/devices.sh")
    print(script_path)
    # try:
    #     with open(leases_path, 'r') as leases_file:
    #         devices = leases_file.readlines()
    #         print("lines read")
    # except FileNotFoundError:
    #     print("File not found", file=sys.stderr)
    # except IOError as e:
    #     print(f"An error occured while reading leases file. Please try again ({e})")

    # print(script_path)
    print("getting devices...")
    start = time.time()
    subprocess.call(script_path, shell=True)
    stop = time.time()
    print(f"DONE ({(stop - start)*1000}ms)")


update_device_list("~/iot_monitor/rbp_server")