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



# tcpdump -nn -r packets.pcap | awk '{print $1, $3, $5}' > packet_summary.txt



# command works for most packets (use UDP on google search) - but not capture length position inconsistent - maybe can use regex later on
# sudo tcpdump -nn -i wlan0 | awk '/IP/ {split($3, src, "."); split($5, dst, "."); gsub(":", "", dst[5]); print $1, src[1] "." src[2] "." src[3] "." src[4], src[5], dst[1] "." dst[2] "." dst[3] "." dst[4], dst[5], $8}'


'''
$1 - timestamp
$3 - src IP address split by .
$5 - dst IP address split by .
    - allows to store IP addr and port no. separate
    src[5], dst[5] - src and dst port no'''
# sudo tcpdump -nn -i wlan0 | awk '/IP/ {split($3, src, "."); split($5, dst, "."); gsub(":", "", dst[5]); print $1, src[1] "." src[2] "." src[3] "." src[4], src[5], dst[1] "." dst[2] "." dst[3] "." dst[4], dst[5]}' > packet_summary.txt


