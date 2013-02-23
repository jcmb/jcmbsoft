from binascii import hexlify
from DCOL_Decls import *

from ENUM import enum
from array import array


Need_More=0
Got_ACK=1
Got_NACK=2
Got_Undecoded=3 # This is not really an undecoded packet but bytes that are not part of a packet
Got_Packet=4
Got_Sub_Packet=5
Missing_Sub_Packet=6


# ByteToHex From http://code.activestate.com/recipes/510399-byte-to-hex-and-hex-to-byte-string-conversion/

def ByteToHex( byteStr ):
    """
    Convert a byte string to it's hex string representation e.g. for output.
    """

    hex = []
    for aChar in byteStr:
        hex.append( "%02X " % aChar )

    return ''.join( hex ).strip()




class Dcol:
    def __init__ (self,internal,default_output_level):
        self.undecoded=bytearray("");
        self.buffer=bytearray("");
        self.internal=internal;
        self.default_output_level=default_output_level;
        self.last_packet_valid=False
        self.packet_ID=-1
        self.Handlers={}
        self.Status_Byte=0
        for B in range(0,256) :
           self.Handlers[B]=None

        self.add_handlers(internal)
        self.Dump_Levels=array("B");

        for i in range (0,255):
            self.Dump_Levels.append(default_output_level)


    def add_data (self,data):
        self.buffer+=data
#        print len(self.buffer)
#       print hexlify(self.buffer)



    def process_data (self):
#        print len (self.buffer)
        self.packet_ID = 0;

        if len (self.buffer) > 0 :
            self.undecoded=bytearray("");

            if self.buffer[0] != TrimComm_Start :
                if self.buffer[0] == ACK :
#                    print "ACK"
                    del self.buffer[0];
                    return Got_ACK
                else:
                    if self.buffer[0] == NACK :
#                        print "NACK"
                        del self.buffer[0];
                        return Got_NACK
                    else :
#                        print "Did not get a STX: " + str(len(self.buffer)-1 if len(self.buffer) >1 else 1)
                        for i  in range (0,len(self.buffer)):
#                            print "in Did not get a STX: " + str(i)
                            if (self.buffer[0] != TrimComm_Start) : # and (self.buffer[0] != ACK) and (self.buffer[0] != NACK) :
                                self.undecoded.append(self.buffer[0]);
                                del self.buffer[0];
                            else:
                                break;
 #                       print "undecoded: " + hexlify(self.undecoded);
                        return Got_Undecoded
            else :
#                print "Did get a 2"
                if len (self.buffer) >= TrimComm_Min_Size :
                    packet_length=self.buffer[TrimComm_Length_Location];
                    if len (self.buffer) >= (packet_length + TrimComm_Min_Size) :
#                        print "Have a STX with enough data in the buffer for the packet"
                        if (self.buffer[packet_length + TrimComm_End_Location] == TrimComm_End) :
#                            print "have valid end of packet"
                            Checksum = 0;
#                            print TrimComm_First_Checksum_Location,packet_length + TrimComm_Checksum_Location;
                            for i  in range (TrimComm_First_Checksum_Location,packet_length + TrimComm_Checksum_Location):
                                 Checksum += self.buffer[i];
#                                 print "i: " + str(i) + " " + hex(self.buffer[i]) + " " + str(Checksum);

                            Checksum = Checksum % 256
#                            print "Checksum: " + hex(Checksum)

                            Checksum_In_Packet = self.buffer[packet_length + TrimComm_Checksum_Location];
#                            print "Expected: " + hex(Checksum_In_Packet)

                            if (Checksum == Checksum_In_Packet) :
#                                print "Did get a valid TrimComm packet"
#                                 Decode_Status_Byte;
                                self.packet_ID = self.buffer[Trimcomm_Type_Location];
                                self.Status_Byte=self.buffer[TrimComm_Status_Byte_Location]
                                self.last_packet_valid = True;
                                self.packet = self.buffer[0:packet_length + TrimComm_End_Location+1];
                                if (packet_length != 0) :
                                    self.data = self.buffer [TrimComm_First_Data_Location : TrimComm_First_Data_Location + packet_length]
                                else :
                                    self.data = bytearray("");

                                del self.buffer[0:packet_length + TrimComm_End_Location+1]
                                if self.Handlers[self.packet_ID] :
 #                                   print "have a handler for packet: " + hex (self.packet_ID)
#                                    print "packet: " + str(len(self.packet)) + " " + hexlify(self.packet)
                                    Result = self.Handlers[self.packet_ID].decode(self.data,self.internal);
                                    return Result;
                                else :
#                                    print "dont have a handler for packet: " + hex (self.packet_ID)
                                    return Got_Packet

                            else:
#                                print "Did get an invalid TrimComm checksum"
#                               Scan for the next STX character since this packet is invalid
                                self.undecoded.append(self.buffer[0]);
                                del self.buffer[0];
                                for i  in range (0,len(self.buffer)):
#                                    print "in looking a STX: " + str(i)
                                    if (self.buffer[0] != TrimComm_Start) : # and (self.buffer[0] != ACK) and (self.buffer[0] != NACK) :
                                        self.undecoded.append(self.buffer[0]);
                                        del self.buffer[0];
                                    else:
                                        break;
                                return Got_Undecoded
                        else:
#                           Scan for the next STX character since this packet is invalid
                            self.undecoded.append(self.buffer[0]);
                            del self.buffer[0];
                            for i  in range (0,len(self.buffer)):
#                                print "in Did not get a STX: " + str(i)
                                if (self.buffer[0] != TrimComm_Start) : # and (self.buffer[0] != ACK) and (self.buffer[0] != NACK) :
                                    self.undecoded.append(self.buffer[0]);
                                    del self.buffer[0];
                                else:
                                    break;
#                            print "Did not get a valid TrimComm End"
                            return Got_Undecoded

                    else:
#                        print "Have a STX with not enough data in the buffer for the packet"
                        return Need_More;

                else :
#                    print "Have a STX with not enough data in the buffer for a packet"
                    return Need_More;
        else :
            return Need_More;

    def name (self):
        return Trimcomm_Names.name(self.packet_ID)

    def _add_Handler(self,packet_ID,handler):
        self.Handlers[packet_ID]=handler;


    def zero_length_packet(self):
        pass

    def add_handlers (self,internal):
        self._add_Handler(RECSTAT1_TrimComm_Command,RetStat1.RetStat1());
        self._add_Handler(RETSERIAL_TrimComm_Command,RetSerial.RetSerial());
        self._add_Handler(SETCOMMS_TrimComm_Command,SetComms.SetComms());
        self._add_Handler(GENOUT_TrimComm_Command,GSOF.GSOF());
        self._add_Handler(CMR_Type_TrimComm_Command,CMR.CMR());

        if internal :
            self._add_Handler(RTKSTAT_TrimComm_Command,RTKStat.RTKStat());
            self._add_Handler(RETRTKSTAT_TrimComm_Command,RetRTKStat.RetRTKStat());
            self._add_Handler(OmniStar_TrimComm_Command,OmniSTAR.OmniSTAR());
            self._add_Handler(Funnel_TrimComm_Command,Funnel.Funnel(internal));
            self._add_Handler(Radio_Pipe_TrimComm_Command,RadioPipe.RadioPipe());
            self._add_Handler(Get_Base_TrimComm_Command,GetBase.GetBase());
            self._add_Handler(Ret_Base_TrimComm_Command,RetBase.RetBase());



    def dump (self,dump_undecoded=False,dump_decoded=False,dump_status=False):
        if self.Dump_Levels[self.packet_ID] :
            print self.name() + ' ( ' +  hex(self.packet_ID) +" ) : "

            if dump_status:
                if (self.Dump_Levels[self.packet_ID] > Dump_ID) and (not (self.packet_ID in Non_Reply_Commands)) :
                    print " Status Byte: :{:02X} ".format (
                        self.Status_Byte
                        )
                    print "  Low Battery: {}  Low Memory: {}  Roving: {}".format (
                        (self.Status_Byte & Bit1 <> 0),
                        (self.Status_Byte & Bit0 <> 0),
                        (self.Status_Byte & Bit3 <> 0)
                        )

                    print "  Synced: {}  Inited: {}  Inited: {}".format (
                        (self.Status_Byte & Bit6 <> 0),
                        (self.Status_Byte & Bit5 <> 0),
                        (self.Status_Byte & Bit7 <> 0)
                        )
                    print ""


            if self.packet_ID in Zero_Length_Commands :
                print " No Extra Information in Command, as expected"
                print ""
            else:
                if self.Handlers[self.packet_ID] :
    #                print "dump have a handler for packet: " + hex (self.packet_ID)
                    self.Handlers[self.packet_ID].dump(self.Dump_Levels[self.packet_ID]);
                    if dump_decoded :
                        print " Packet Data: " + ByteToHex (self.packet)
                    print ""
                else :
                    print " Dont have a decoder for packet: " + hex (self.packet_ID)
                    if dump_undecoded :
                        print " Packet Data: " + ByteToHex (self.packet)
                    print ""


import RetStat1
import RetSerial
import RTKStat
import RetRTKStat
import OmniSTAR
import SetComms
import Funnel;
import RadioPipe
import GSOF
import CMR
import GetBase
import RetBase
