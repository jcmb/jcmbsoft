#!/usr/bin/env python

import sys

sys.path.append("Public"); # Gave up trying to work how to do this with a .pth file or using .
sys.path.append("../../../Internal");
sys.path.append("/Users/gkirk/Dropbox/git/jcmbsoft/multi/DCOL/")
sys.path.append("/Users/gkirk/Dropbox/git/jcmbsoft/multi/DCOL/Public")
sys.path.append("/Users/gkirk/Dropbox/git/internal")
sys.path.append("internal_stubs");

from DCOL import *
from DCOL_Decls import *
from binascii import hexlify
import sys
from datetime import datetime


Dump_Undecoded = False
Print_ACK_NAK  = False

dcol=Dcol(internal=False,default_output_level=Dump_Verbose);
dcol.Dump_Levels[GENOUT_TrimComm_Command]=Dump_Full
dcol.Dump_Levels[Get_Base_TrimComm_Command]=Dump_None


#with open ('DCOL.bin','rb') as input_file:
#   new_data = bytearray(input_file.read(255))
new_data = bytearray(sys.stdin.read(1))

while (new_data):

    dcol.add_data (data=new_data)
#    new_data = input_file.read(255)
#    if len(dcol.buffer):
#        print str(len(dcol.buffer)) + ' ' + hex(dcol.buffer[len(dcol.buffer)-1])
#        sys.stdout.flush()
    result = dcol.process_data (dump_decoded=False)

    while result != 0 :
#        print str(datetime.now())
        if result == Got_ACK :
            if Print_ACK_NAK:
                print "ACK"
                print ""
        elif result == Got_NACK :
            if Print_ACK_NAK:
                print "NACK"
                print ""
        elif result == Got_Undecoded :
            if Dump_Undecoded :
                print "Undecoded Data: " +hexlify(dcol.undecoded);
        elif result == Got_Packet :
            dcol.dump(dump_undecoded=True,dump_decoded=False);
            sys.stdout.flush()
        elif result == Got_Sub_Packet:
            if dcol.Dump_Levels[dcol.packet_ID] :
                print dcol.name() + ' ( ' +  hex(dcol.packet_ID) +" ) : "
                print " Sub packet of mutiple packet message"
                print ""
                sys.stdout.flush()
        elif result == Missing_Sub_Packet:
            if dcol.Dump_Levels[dcol.packet_ID] :
                print dcol.name() + ' ( ' +  hex(dcol.packet_ID) +" ) : "
                print " Final sub packet of mutiple packet message, missed a sub packet."
                print ""
                sys.stdout.flush()
        else :
                print "INTERNAL ERROR: Unknown result"
                sys.exit();
#        print "processing"
        result = dcol.process_data ()
#        print "processed: " + str(result)
    new_data = sys.stdin.read(1)

print "Bye"

