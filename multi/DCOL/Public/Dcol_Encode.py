# DCOL_Encoder
# A simple class for encoding DCOL packet.

from DCOL_Decls import *

class Dcol_Encode:
    def encode (self, packet_Id, data) :
        packet=bytearray()
        packet.append(STX)
        packet.append(0) # Status Byte
        packet.append(packet_Id)
        packet.append(len(data))
        if len(data):
            packet.append(data)

        Checksum = 0;
        for i  in range (TrimComm_First_Checksum_Location,len(packet)):
             Checksum += packet[i];

        Checksum = Checksum % 256
        packet.append(Checksum)
        packet.append(ETX)

        return packet
