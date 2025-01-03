import subprocess
print("getting devices")
subprocess.call(["sudo", "bash ./devices.sh"])
print("done")
