import DCOL

# Documentation Source: BD970 Manual

from struct import *
from binascii import hexlify
from ENUM import enum
from DCOL_Decls import *
import math

GSOF_POSITION_TIME = 1
GSOF_LAT_LONG_HEIGHT = 2
GSOF_ECEF_POSITION = 3
GSOF_LOCAL_DATUM_POSITION = 4
GSOF_LOCAL_ZONE_POSITION = 5
GSOF_ECEF_DELTA = 6
GSOF_TANGENT_PLANE_DELTA = 7
GSOF_VELOCITY_DATA = 8
GSOF_PDOP_INFO = 9
GSOF_CLOCK_INFO = 10
GSOF_POSITION_VCV_INFO = 11
GSOF_POSITION_SIGMA_INFO = 12
GSOF_SV_BRIEF_INFO = 13
GSOF_SV_DETAILED_INFO = 14
GSOF_RECEIVER_SERIAL_NUMBER = 15
GSOF_CURRENT_TIME_INFORMATION = 16

GSOF_POSITION_TIME_UTC = 26
GSOF_ATTITUDE_INFO = 27
GSOF_BriefAllSVInfo = 33 #// * 33 Brief satellite information */
GSOF_DetailedAllSVInfo = 34 #// * 34 Detailed satellite information */
GSOF_ReceivedBaseInfo = 35 #// * 35 Received base information */

GSOF_Base_Position_Quaility= 41;


GSOF_Message_Names=  ('Unknown',
    'POSITION TIME',
    'LAT LONG HEIGHT',
    'ECEF POSITION',
    'LOCAL DATUM POSITION',
    'LOCAL ZONE POSITION',
    'ECEF DELTA',
    'TANGENT PLANE DELTA',
    'VELOCITY DATA',
    'PDOP INFO',
    'CLOCK INFO',
    'POSITION VCV INFO',
    'POSITION SIGMA INFO',
    'SV BRIEF INFO',
    'SV DETAILED GPS INFO',
    'RECEIVER SERIAL NUMBER',
    'CURRENT TIME INFORMATION',
    'Reserved 17',
    'Reserved 18',
    'Reserved 19',
    'Reserved 20',
    'Reserved 21',
    'Reserved 22',
    'Reserved 23',
    'Reserved 24',
    'Reserved 25',
    'POSITION TIME UTC',
    'ATTITUDE INFO',
    'Reserved 28',
    'Reserved 29',
    'Reserved 30',
    'Reserved 31',
    'Reserved 32',
    'Brief All SV Info',
    'Detailed All Constellation SV Info',
    'Received Base Info',
    'Reserved 36',
    'Reserved 37',
    'Reserved 38',
    'Reserved 39',
    'Reserved 40',
    'BASE POSITION AND QUALITY INDICATOR',
    'Reserved 42',
    'Reserved 43',
    'Reserved 44',
    'Reserved 45',
    'Reserved 46'
    );


class GSOF (DCOL.Dcol) :
    def __init__ (self):
        self.last_page=-2
        self.max_page=-1
        self.GSOF_Buffer=bytearray("")
        self.seq_number=-1
        self.seen_pages=set([])
        self.seen_subrecords=set([])



    def decode(self,data):
        unpacked=unpack_from('> B B B',str(data))
        del data[0:3]
        if unpacked[0] != self.seq_number:
            self.seq_number=unpacked[0]
            self.seen_pages=set([])
            self.GSOF_Buffer=bytearray("")
            self.seen_subrecords=set([])


        self.last_page=unpacked[1]
        self.max_page=unpacked[2]
        self.seen_pages |=set([self.last_page])
        self.GSOF_Buffer+=data

#        print " Buffer {:02X} {}".format(len(self.GSOF_Buffer),len(self.GSOF_Buffer))
#        print " GSOF: " + hexlify(self.GSOF_Buffer)
#        print " PACKET: " + hexlify(data)


#        print "last: {}  Max: {}  Seen: {}".format(self.last_page,self.max_page,len(self.seen_pages))
        if self.last_page == self.max_page:
            if self.max_page == len(self.seen_pages) - 1: # Have all the pages
#                print " Buffer Final Buffer {}".format(len(self.GSOF_Buffer))
#                print hexlify(self.GSOF_Buffer)
                while self.GSOF_Buffer :
                    unpacked=unpack_from('> B B',str(self.GSOF_Buffer))
                    subrecord=unpacked[0];
                    self.seen_subrecords|=set([subrecord])
                    length=unpacked[1]

#                    print "sub: {} Length: {:02X}".format (unpacked[0],unpacked[1]);
#                    print "GSOF Buffer Length: " + str(len(self.GSOF_Buffer))
#                    print hexlify(self.GSOF_Buffer)

                    del self.GSOF_Buffer [0:2]
 #                   print "GSOF Buffer Length after delete length: " + str(len(self.GSOF_Buffer))

                    if subrecord == GSOF_POSITION_TIME :
                        unpacked=unpack_from('>L H B B B B',str(self.GSOF_Buffer))
                        self.GPS_Time=unpacked[0]
                        self.GPS_Week=unpacked[1]
                        self.SVs_Used=unpacked[2]
                        self.Flags1=unpacked[3]
                        self.Flags2=unpacked[4]
                        self.Init_Counter=unpacked[5]

                    elif subrecord == GSOF_LAT_LONG_HEIGHT :
                        unpacked=unpack_from('>d d d',str(self.GSOF_Buffer))
                        self.Lat=unpacked[0]
                        self.Long=unpacked[1]
                        self.Height=unpacked[2]

                    elif subrecord == GSOF_ECEF_POSITION :
                        unpacked=unpack_from('>d d d',str(self.GSOF_Buffer))
                        self.X=unpacked[0]
                        self.Y=unpacked[1]
                        self.Z=unpacked[2]

                    elif subrecord == GSOF_LOCAL_DATUM_POSITION :
                        unpacked=unpack_from('> 8S d d d',str(self.GSOF_Buffer))
                        self.Datum_ID=unpacked[0]
                        self.Local_Lat=unpacked[1]
                        self.Local_Long=unpacked[2]
                        self.Local_Height=unpacked[3]

                    elif subrecord == GSOF_LOCAL_ZONE_POSITION :
                        unpacked=unpack_from('> 8S d d d',str(self.GSOF_Buffer))
                        self.Datum_ID=unpacked[0]
                        self.Zone_ID=unpacked[1]
                        self.Local_Lat=unpacked[2]
                        self.Local_Long=unpacked[3]
                        self.Local_Height=unpacked[4]

                    elif subrecord == GSOF_ECEF_DELTA :
                        unpacked=unpack_from('>d d d',str(self.GSOF_Buffer))
                        self.dX=unpacked[0]
                        self.dY=unpacked[1]
                        self.dZ=unpacked[2]

                    elif subrecord == GSOF_TANGENT_PLANE_DELTA :
                        unpacked=unpack_from('>d d d',str(self.GSOF_Buffer))
                        self.dE=unpacked[0]
                        self.dN=unpacked[1]
                        self.dU=unpacked[2]


                    elif subrecord == GSOF_VELOCITY_DATA :
                        unpacked=unpack_from('>B f f f f',str(self.GSOF_Buffer))
                        self.Velocity_Flags=unpacked[0]
                        self.Velocity=unpacked[1]
                        self.Heading=unpacked[2]
                        self.Vertical_Velocity=unpacked[3]
                        self.Local_Heading=unpacked[4]

                    elif subrecord == GSOF_PDOP_INFO :
                        unpacked=unpack_from('>f f f f',str(self.GSOF_Buffer))
                        self.PDOP=unpacked[0]
                        self.HDOP=unpacked[1]
                        self.TDOP=unpacked[2]
                        self.VDOP=unpacked[3]

                    elif subrecord == GSOF_CLOCK_INFO :
                        unpacked=unpack_from('>B d d',str(self.GSOF_Buffer))
                        self.clock_flags=unpacked[0]
                        self.clock_offset=unpacked[1]
                        self.frequency_offset=unpacked[2]

                    elif subrecord == GSOF_POSITION_VCV_INFO :
                        unpacked=unpack_from('>f f f f f f f f H',str(self.GSOF_Buffer))
                        POSITION_RMS=unpacked[0]
                        VCV_xx=unpacked[1]
                        VCV_xy=unpacked[2]
                        VCV_xz=unpacked[3]
                        VCV_yy=unpacked[4]
                        VCV_yz=unpacked[5]
                        VCV_zz=unpacked[6]
                        UNIT_VARIANCE=unpacked[7]
                        NUMBER_OF_EPOCHS=unpacked[8]


                    elif subrecord == GSOF_POSITION_SIGMA_INFO :
                        unpacked=unpack_from('>f f f f f f f f f  H',str(self.GSOF_Buffer))
                        self.POSITION_RMS = unpacked[0]
                        self.SIGMA_EAST = unpacked[1]
                        self.SIGMA_NORTH = unpacked[2]
                        self.COVAR_EAST_NORTH = unpacked[3]
                        self.SIGMA_UP = unpacked[4]
                        self.SEMI_MAJOR_AXIS = unpacked[5]
                        self.SEMI_MINOR_AXIS = unpacked[6]
                        self.ORIENTATION = unpacked[7]
                        self.UNIT_VARIANCE = unpacked[8]
                        self.NUMBER_EPOCHS = unpacked[9]

                    elif subrecord == GSOF_SV_BRIEF_INFO:
#                        print "GSOF Buffer Length Brief start : " + str(len(self.GSOF_Buffer))
                        SV_Brief_Buffer=bytearray()
                        SV_Brief_Buffer[:]=self.GSOF_Buffer #Force to get a copy not a reference
#                        print "  {:02X}".format(len(SV_Brief_Buffer))
#                        print hexlify(SV_Brief_Buffer)
                        self.Brief_Num_SVs=SV_Brief_Buffer[0]
                        del SV_Brief_Buffer[0]
#                        print "***Num SV's: " + str(self.Brief_Num_SVs)
                        self.SV_Brief={}
                        if self.Brief_Num_SVs:
                            for SV in range(0,self.Brief_Num_SVs):
                                unpacked=unpack_from('>B B B',str(SV_Brief_Buffer))
                                del SV_Brief_Buffer[0:calcsize('>B B B')]
                                self.SV_Brief[SV]=unpacked
#                                print "  {:02X}".format(len(SV_Brief_Buffer))
#                                print hexlify(SV_Brief_Buffer)
#                        print "GSOF Buffer Length brief end: " + str(len(self.GSOF_Buffer))


                    elif subrecord == GSOF_SV_DETAILED_INFO:

#                        print "Start of decode"
                        SV_Detail_Buffer=bytearray()
                        SV_Detail_Buffer[:]=self.GSOF_Buffer #Force to get a copy not a reference
                        self.Detailed_Num_SVs=SV_Detail_Buffer[0]
                        del SV_Detail_Buffer[0]
#                        print "***Num SV's: " + str(self.Detailed_Num_SVs)
                        self.SV_Detailed={}
                        if self.Detailed_Num_SVs:
                            for SV in range(0,self.Detailed_Num_SVs):
 #                               print "SV: " + str(SV) + " " + str(1+(calcsize('>B B B B H B B')*SV))
 #                               print len(SV_Detail_Buffer)
 #                               print hexlify(SV_Detail_Buffer)
                                unpacked=unpack_from('>B B B b H B B',str(SV_Detail_Buffer))
                                del SV_Detail_Buffer[0:calcsize('>B B B b H B B')]
                                self.SV_Detailed[SV]=unpacked
#                                print unpacked

#GSOF_RECEIVER_SERIAL_NUMBER = 15
#GSOF_CURRENT_TIME_INFORMATION = 16

#GSOF_POSITION_TIME_UTC = 26
#GSOF_ATTITUDE_INFO = 27
#GSOF_BriefAllSVInfo = 33 #// * 33 Brief satellite information */
#GSOF_DetailedAllSVInfo = 34 #// * 34 Detailed satellite information */
#GSOF_ReceivedBaseInfo = 35 #// * 35 Received base information */


                    elif subrecord == GSOF_DetailedAllSVInfo:
#                        print "Start of decode"
                        SV_Detail_Buffer=self.GSOF_Buffer
                        self.Detailed_All_Num_SVs=SV_Detail_Buffer[0]
                        del SV_Detail_Buffer[0]
#                        print "***Num SV's: " + str(self.Detailed_Num_SVs)
                        self.SV_Detailed_All={}
                        if self.Detailed_All_Num_SVs:
                            for SV in range(0,self.Detailed_All_Num_SVs):
 #                               print "SV: " + str(SV) + " " + str(1+(calcsize('>B B B B H B B')*SV))
 #                               print len(SV_Detail_Buffer)
 #                               print hexlify(SV_Detail_Buffer)
                                unpacked=unpack_from('>B B B B b H B B B',str(SV_Detail_Buffer))
                                del SV_Detail_Buffer[0:calcsize('>B B B B b H B B B')]
                                self.SV_Detailed_All[SV]=unpacked
#                                print unpacked


                    elif subrecord == GSOF_Base_Position_Quaility :
                        unpacked=unpack_from('>L H d d d B',str(self.GSOF_Buffer))
                        self.Base_GPS_Time=unpacked[0]
                        self.Base_GPS_Week=unpacked[1]
                        self.Base_Lat=unpacked[2]
                        self.Base_Long=unpacked[3]
                        self.Base_Height=unpacked[4]
                        self.Base_Quaility=unpacked[5]

                    else:
                        pass # undecoded message

                    if length:
#                        print "GSOF Buffer Length: " + str(len(self.GSOF_Buffer))
#                        print "sub: {} Length: {:02X}".format (subrecord,length);
#                        print "About to remove: " + str(length)
#                        print len(self.GSOF_Buffer)
#                        print hexlify(self.GSOF_Buffer)
                        del self.GSOF_Buffer[0:length]
#                        print "After Remove"
#                        print len(self.GSOF_Buffer)
#                        print hexlify(self.GSOF_Buffer)

                return DCOL.Got_Packet
            else:
                return DCOL.Missing_Sub_Packet
        else:
                return DCOL.Got_Sub_Packet

    def dump(self,Dump_Level):
        if Dump_Level >= Dump_ID :
            for subrecord in self.seen_subrecords :
                print " Subrecord: {}".format(subrecord);
                print " Subrecord: {}".format(GSOF_Message_Names[subrecord]);
                if Dump_Level >= Dump_Summary:

                    if subrecord == GSOF_POSITION_TIME :
                        print"  Time: {}:{:.2f}  SV's Used: {}  Flags1: {:08b}  Flags2: {:08b}  Init Counter: {}".format(
                        self.GPS_Week,
                        float(self.GPS_Time)/1000,
                        self.SVs_Used,
                        self.Flags1,
                        self.Flags2,
                        self.Init_Counter
                        )

                    if subrecord == GSOF_LAT_LONG_HEIGHT :
                        print "  Lat: {:0.8f}  Long: {:0.8f}  Height: {:0.3f}".format(
                        math.degrees(self.Lat),
                        math.degrees(self.Long),
                        self.Height
                        )

                    if subrecord == GSOF_ECEF_POSITION :
                        print "  X: {:0.3f}  Y: {:0.3f}  Z: {:0.3f}".format(
                        self.X,
                        self.Y,
                        self.Z
                        )

                    if subrecord == GSOF_LOCAL_DATUM_POSITION :
                        print "  Datum ID: {}  Lat: {:0.8f}  Long: {:0.8f}  Height: {:0.3f}".format(
                        self.Datum_ID,
                        self.Local_Lat,
                        self.Local_Long,
                        self.Local_Height
                        );

                    if subrecord == GSOF_LOCAL_ZONE_POSITION :
                        print "  Zone D: {}  Datum ID: {}  Lat: {:0.8f}  Long: {:0.8f}  Height: {:0.3f}".format(
                        self.Zone_ID,
                        self.Datum_ID,
                        self.Local_Lat,
                        self.Local_Long,
                        self.Local_Height
                        )

                    if subrecord == GSOF_ECEF_DELTA :
                        print "  dX: {:0.3f}  dY: {:0.3f}  dZ: {:0.3f}".format(
                        self.dX,
                        self.dY,
                        self.dZ
                        )

                    if subrecord == GSOF_TANGENT_PLANE_DELTA :
                        print "  dX: {:0.3f}  dY: {:0.3f}  dZ: {:0.3f}".format(
                        self.dE,
                        self.dN,
                        self.dU
                        )

                    if subrecord == GSOF_VELOCITY_DATA :
                        print "  Heading: {:0.6f}  Velocity: {:0.4f}  Vertical_Velocity: {:0.4f}  Local_Heading: {:0.6f}\n  Heading Valid: {}  Computed: {}".format(
                        math.degrees(self.Heading),
                        self.Velocity,
                        self.Vertical_Velocity,
                        self.Local_Heading,
                        self.Velocity_Flags & Bit0 !=0,
                        self.Velocity_Flags & Bit1 !=0
                        );

                    if subrecord == GSOF_PDOP_INFO :
                        print "  PDOP: {:0.1f}  HDOP: {:0.1f}  TDOP: {:0.1f}  VDOP: {:0.1f}".format(
                        self.PDOP,
                        self.HDOP,
                        self.TDOP,
                        self.VDOP
                        );

                    if subrecord == GSOF_CLOCK_INFO :
                        print "  Clock Offset: {} Frequency offset: {} Flags: {:02}".format(
                        self.clock_flags,
                        self.clock_offset,
                        self.frequency_offset
                        )

                    if subrecord == GSOF_POSITION_VCV_INFO :
                        unpacked=unpack_from('>f f f f f f f f H',str(self.GSOF_Buffer))
                        print "  RMS: {}  Unit Variance: {} Number of Epochs: {} ".format (
                            POSITION_RMS,
                            UNIT_VARIANCE,
                            NUMBER_OF_EPOCHS)

                        print "  xx: {}  xy: {} xz: {}  yy: {}  yz: {}  zz: {}".format (
                            VCV_xx,
                            VCV_xy,
                            VCV_xz,
                            VCV_yy,
                            VCV_yz,
                            VCV_zz
                            )

                    if subrecord == GSOF_POSITION_SIGMA_INFO :
                        print "  RMS: {:0.3f}  Sigma East: {:0.3f}  Sigma North: {:0.3f}  Sigma Up: {:0.3f}\n  Semi Major: {:0.3f}  Semi Minor: {:0.3f}  Orientaion: {:0.3f}\n  Covariance: {}  Unit Variance: {}  Number of Epochs: {}".format(
                        self.POSITION_RMS,
                        self.SIGMA_EAST,
                        self.SIGMA_NORTH,
                        self.SIGMA_UP,
                        self.SEMI_MAJOR_AXIS,
                        self.SEMI_MINOR_AXIS,
                        self.ORIENTATION,
                        self.COVAR_EAST_NORTH,
                        self.UNIT_VARIANCE,
                        self.NUMBER_EPOCHS
                        );

                    if subrecord == GSOF_SV_BRIEF_INFO:
                        print "  Number of SV's: " + str(self.Brief_Num_SVs)
                        if Dump_Level == Dump_Full :
                            for SV in range(0,self.Brief_Num_SVs):
        #                                print "SV: " + str(SV)
                                print "   SV: {:2}  Flags1: {:02X} Flags2: {:02X}".format(
                                        self.SV_Brief[SV][0],
                                        self.SV_Brief[SV][1],
                                        self.SV_Brief[SV][2]
                                        )

                        if Dump_Level >= Dump_Verbose :
                            for SV in range(0,self.Brief_Num_SVs):
        #                                print "SV: " + str(SV)
                                print "   SV: {:2}".format(
                                    self.SV_Brief[SV][0],
                                    )
                                print "    Above: {}  Channel Assigned: {}  Tracking L1: {}  Tracking L2: {}  Base Tracking L1: {}  Base Tracking L2: {}  Used in position: {}  Used in RTK: {}".format(
                                        self.SV_Brief[SV][1] & Bit0 != 0,
                                        self.SV_Brief[SV][1] & Bit1 != 0,
                                        self.SV_Brief[SV][1] & Bit2 != 0,
                                        self.SV_Brief[SV][1] & Bit3 != 0,
                                        self.SV_Brief[SV][1] & Bit4 != 0,
                                        self.SV_Brief[SV][1] & Bit5 != 0,
                                        self.SV_Brief[SV][1] & Bit6 != 0,
                                        self.SV_Brief[SV][1] & Bit7 != 0,
                                        )

                                print "    Tracking L1 P: {}  Tracking L2 P: {}  Tracking L1 CS: {}".format(
                                        self.SV_Brief[SV][2] & Bit0 != 0,
                                        self.SV_Brief[SV][2] & Bit1 != 0,
                                        self.SV_Brief[SV][2] & Bit2 != 0,
                                        )


                    if subrecord == GSOF_SV_DETAILED_INFO:
                        print "  Number of SV's: " + str(self.Detailed_Num_SVs)
                        if Dump_Level >= Dump_Full :
                            for SV in range(0,self.Detailed_Num_SVs):
        #                                print "SV: " + str(SV)
                                print "   SV: {:2}  Elevation: {:2}  Az: {:3}  L1 SNR: {:2}  L2 SNR: {:2}".format(
                                    self.SV_Detailed[SV][0],
                                    self.SV_Detailed[SV][3],
                                    self.SV_Detailed[SV][4],
                                    self.SV_Detailed[SV][5]/4,
                                    self.SV_Detailed[SV][6]/4,
                                    )

                                if Dump_Level >= Dump_Verbose :

                                    print "   Flags1: {:02X} Flags2: {:02X}".format(
                                        self.SV_Detailed[SV][1],
                                        self.SV_Detailed[SV][2]
                                        )

                    if subrecord == GSOF_DetailedAllSVInfo:
                        print "  Number of SV's: " + str(self.Detailed_All_Num_SVs)
                        if Dump_Level >= Dump_Full :
                            for SV in range(0,self.Detailed_All_Num_SVs):
                                print "   System: {}  SV: {:2}  Elevation: {:2}  Az: {:3}  L1 SNR: {:2}  L2 SNR: {:2}  L5 SNR: {:2}".format(
                                self.SV_Detailed_All[SV][1],
                                self.SV_Detailed_All[SV][0],
                                self.SV_Detailed_All[SV][4],
                                self.SV_Detailed_All[SV][5],
                                self.SV_Detailed_All[SV][6]/4,
                                self.SV_Detailed_All[SV][7]/4,
                                self.SV_Detailed_All[SV][8]/4
                                )

                            if Dump_Level >= Dump_Verbose :
                                print "   Flags1: {:02X} Flags2: {:02X}".format(
                                    self.SV_Detailed_All[SV][2],
                                    self.SV_Detailed_All[SV][3]
                                    )


                    if subrecord == GSOF_Base_Position_Quaility :
                        print"  Time: {}:{:.2f}  Lat: {:0.8f}  Long: {:0.8f}  Height: {:0.3f}  Quaility {}".format(
                        self.Base_GPS_Week,
                        float(self.Base_GPS_Time,)/1000,
                        math.degrees(self.Base_Lat),
                        math.degrees(self.Base_Long),
                        self.Base_Height,
                        self.Base_Quaility
                        )




