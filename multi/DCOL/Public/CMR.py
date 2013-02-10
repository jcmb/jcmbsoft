import DCOL

# Documentation Source: CMR Paper

from struct import *
from binascii import hexlify
from ENUM import enum
from DCOL_Decls import *



class CMR (DCOL.Dcol) :
    def __init__ (self):
        pass



    def decode(self,data,internal=False):
        unpacked=unpack_from('> B B',str(data))
        self.version_number=unpacked[0]>>5
        self.station_ID=unpacked[0] & 0x1F
        self.message_type=unpacked[1]>>5
        self.Flags=unpacked[1] & 0x1F
        return DCOL.Got_Packet

    def dump(self,Dump_Level):

        if Dump_Level >= Dump_Summary :
            print "   Type: {}  ID: {}  Version: {}".format(
              self.message_type,
              self.station_ID,
              self.version_number);

