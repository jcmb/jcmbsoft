#DCOL_Decls

Bit15 = 1 << 15;
Bit14 = 1 << 14;
Bit13 = 1 << 13;
Bit12 = 1 << 12;
Bit11 = 1 << 11;
Bit10 = 1 << 10;
Bit9  = 1 << 9;
Bit8  = 1 << 8;
Bit7  = 1 << 7;
Bit6  = 1 << 6;
Bit5  = 1 << 5;
Bit4  = 1 << 4;
Bit3  = 1 << 3;
Bit2  = 1 << 2;
Bit1  = 1 << 1;
Bit0  = 1;


# TDump_Level
Dump_None=0
Dump_ID=1
Dump_Summary=2
Dump_Full=3
Dump_Verbose=4


STX = 2;
ETX = 3;
ENQ = 0x5;
ACK = 0x06;
NACK = 0x15;



TrimComm_Start           = STX;
TrimComm_End             = ETX;

# Locations are zero based
TrimComm_First_Checksum_Location = 1;  #{First location that is included in the checksum}
TrimComm_Checksum_Location = 4;
TrimComm_End_Location    = 5; #{# Within 'header'}
TrimComm_First_Data_Location = 4;
TrimComm_Status_Byte_Location = 1;
Trimcomm_Type_Location = 2;
TrimComm_Length_Location = 3;
TrimComm_Min_Size      = 6;


#HH command numbers}
GETSERIAL_TrimComm_Command = 0x06; #Get Receiver & Antenna Serial Numbers}
RETSERIAL_TrimComm_Command = 0x07; #Receiver & Antenna Serial Numbers}
GETSTAT1_TrimComm_Command  = 0x08;
RECSTAT1_TrimComm_Command  = 0x09;

GENOUT_TrimComm_Command    = 0x40; #GSOF}

SETCOMMS_TrimComm_Command  = 0x48; #SETCOMMS}



class Trimcomm_Command_Names:
    def __init__ (self):
        self.Command_Names={};

        for B in range(0,256) :
           self.Command_Names[B] ='Unknown packet ID: ' + hex(B);


        self.Command_Names[GETSERIAL_TrimComm_Command] = 'GetSerial'; #BD970 manual
        self.Command_Names[RETSERIAL_TrimComm_Command] = 'RetSerial'; #BD970 manual
        self.Command_Names[GETSTAT1_TrimComm_Command]  = 'GetStat1';  #4000 RS-232 Manual
        self.Command_Names[RECSTAT1_TrimComm_Command]  = 'RecStat1';  #4000 RS-232 Manual
        self.Command_Names[SETCOMMS_TrimComm_Command]  = 'SetComms';  #4000 RS-232 Manual


    def name (self,packet_ID):
        return self.Command_Names[packet_ID]

    def add_name (self,packet_ID,name):
        self.Command_Names[packet_ID]=name;


Trimcomm_Names = Trimcomm_Command_Names()


from DCOL_Internal import *