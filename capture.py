import sqlite3
import pandas as pd

conn = sqlite3.connect("network_data.db")
c = conn.cursor()
c.execute('''CREATE TABLE IF NOT EXISTS connections (timestamp float, source_ip text, dest_ip text)''')
connections = pd.read_csv('packet_summary.txt', delimiter=' ', names=['timestamp', 'source_ip', 'dest_ip'])
connections.to_sql('connections', conn, if_exists='replace', index=False)
print(connections)
c.execute('''SELECT * FROM connections LIMIT 1''')
print(c.fetchall())

# def capture_and_store_packet(packet):
#     timestamp = datetime.datetime.now()
#     src_ip = packet[1].src
#     dst_ip = packet[1].dst
#     protocol = packet[1].proto

#     # Process or send the data to a database
#     print(timestamp, src_ip, dst_ip, protocol)
# print("hi")
# sniff(iface="wlan0", filter="tcp or udp", prn=capture_and_store_packet, store=False)

# import os
# print(os.sys.path)