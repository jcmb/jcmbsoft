from binascii import hexlify
from DCOL_Decls import *

from ENUM import enum

Need_More=0
Got_ACK=1
Got_NACK=2
Got_Undecoded=3
Got_Packet=4
Got_Sub_Packet=5
Missing_Sub_Packet=6



class Dcol:
    def __init__ (self,internal,default_output_level):
        self.undecoded=bytearray("");
        self.buffer=bytearray("");
        self.internal=internal;
        self.default_output_level=default_output_level;
        self.last_packet_valid=False
        self.packet_ID=-1
        self.Handlers={}
        for B in range(0,256) :
           self.Handlers[B]=None

        self.add_handlers(internal)


    def add_data (self,data):
        self.buffer+=data
#        print len(self.buffer)
#       print hexlify(self.buffer)



    def process_data (self):
#        print len (self.buffer)

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
#                        print "undecoded: " + hexlify(self.undecoded);
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
                                self.last_packet_valid = True;
                                self.packet = self.buffer[0:packet_length + TrimComm_End_Location+1];
                                if (packet_length != 0) :
                                    self.data = self.buffer [TrimComm_First_Data_Location : TrimComm_First_Data_Location + packet_length]
                                else :
                                    self.data = bytearray("");

                                del self.buffer[0:packet_length + TrimComm_End_Location+1]
                                if self.Handlers[self.packet_ID] :
#                                    print "have a handler for packet: " + hex (self.packet_ID)
#                                    print "packet: " + hexlify(self.packet)
                                    Result = self.Handlers[self.packet_ID].decode(self.data);
                                    return Result;
                                else :
#                                    print "dont have a handler for packet: " + hex (self.packet_ID)
                                    return Got_Packet

                            else:
#                                print "Did get an invalid TrimComm packet"
                                return Got_Undecoded

                        else:
                            return Got_Undecoded
#                            print "Did not get a valid TrimComm End"

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

        if internal :
            self._add_Handler(RTKSTAT_TrimComm_Command,RTKStat.RTKStat());
            self._add_Handler(RETRTKSTAT_TrimComm_Command,RetRTKStat.RetRTKStat());
            self._add_Handler(OmniStar_TrimComm_Command,OmniSTAR.OmniSTAR());
            self._add_Handler(Funnel_TrimComm_Command,Funnel.Funnel(internal));
            self._add_Handler(Radio_Pipe_TrimComm_Command,RadioPipe.RadioPipe());
            self._add_Handler(GENOUT_TrimComm_Command,GSOF.GSOF());

    def dump (self,dump_undecoded=False):
        if self.default_output_level :
            print self.name() + ': '
        if self.packet_ID in Zero_Length_Commands :
            print " No Extra Information in Command, as expected"
            print ""
        else:
            if self.Handlers[self.packet_ID] :
#                print "dump have a handler for packet: " + hex (self.packet_ID)
                self.Handlers[self.packet_ID].dump(self.default_output_level);
                print ""
            else :
    #            print "dont have a handler for packet: " + hex (self.packet_ID)
                if dump_undecoded :
                    print hexlify (self.packet)


import RetStat1
import RetSerial
import RTKStat
import RetRTKStat
import OmniSTAR
import SetComms
import Funnel;
import RadioPipe
import GSOF
