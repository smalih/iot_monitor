import subprocess
print("getting devices")
subprocess.call("~/iot_monitor/rbp_server/scripts/devices.sh", shell=True)
print("done")
