'''
SCRIPT TO RETRIEVE LATEST ENTRIES FROM DNSMASQ LEASES
'''
import sys
from pydantic import BaseModel

leases_path = "/var/lib/NetworkManager/dnsmasq-wlan0.leases"

# example: '1740068091 ee:37:46:31:58:d7 10.42.0.52 iPad 01:ee:37:46:31:58:d7'
# format: 'lease_time client_mac, client_ip, client_name
class LeaseDeviceInfo(BaseModel):
    mac_addr: str
    ip_addr: str
    name: str

def get_lease_device_info():
    try:
        with open(leases_path, 'r') as leases_file:
            devices = leases_file.read().splitlines()
            for i in range(len(devices)):
                device_arr = devices[i].split()
                mac_addr, ip_addr, name = device_arr[1:4]
                if name == '*':
                    name='UKNOWN'
                devices[i] = LeaseDeviceInfo(mac_addr=mac_addr, ip_addr=ip_addr, name=name)
            return devices
    except FileNotFoundError:
        print("File not found", file=sys.stderr)
    except IOError as e:
        print(f"An error occured while reading leases file. Please try again ({e})")

get_lease_device_info()