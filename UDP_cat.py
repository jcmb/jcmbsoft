#!/usr/bin/env python
from __future__ import print_function

import socket
import sys
import pprint

UDP_IP = "0.0.0.0"
UDP_PORT = 2101



if len(sys.argv) == 2 :
   UDP_PORT=int(sys.argv[1])

sys.stderr.write("Port: {}\n".format(UDP_PORT))

if len(sys.argv) == 3 :
   UDP_IP=int(sys.argv[2])

sys.stderr.write("IP: {}\n".format(UDP_IP))

sock = socket.socket(socket.AF_INET, # Internet
                     socket.SOCK_DGRAM) # UDP
sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEPORT, 1)
sock.bind((UDP_IP, UDP_PORT))

packet_number=0
while True:
    data, addr = sock.recvfrom(1024) # buffer size is 1024 bytes
    packet_number+=1
    sys.stderr.write("Packet: {} From Address: {}:{}\n".format(packet_number,addr[0],addr[1]))

    print (data,end="")
    sys.stdout.flush()
