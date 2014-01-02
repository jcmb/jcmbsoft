#!/usr/bin/env python -u


from xml.etree.ElementTree import parse, dump
import pprint
from collections import defaultdict
import sys


#print 'Number of arguments:', len(sys.argv), 'arguments.'
#print 'Argument List:', str(sys.argv)

def help():
   sys.stderr.write ("Usage: RTX_XML <File> [ARP to APC Offset]")
   sys.stderr.write ("\n")
   sys.stderr.write ("Where\n")
   sys.stderr.write ("  File: Is the file name of the RTX XML report\n")
   sys.stderr.write ("\n")
   quit(10)

if len(sys.argv) <= 1 :
   help()

if len(sys.argv) == 3 :
   ARP_APC=float(sys.argv[2])
   sys.stderr.write("APC to APC Offset: {}\n".format(ARP_APC))
else:
   ARP_APC=0.0


XML = parse(sys.argv[1])

#dump(XML)
Lat=(XML.find("./POSITION[@TYPE='INTERNAL']/COORD_SET/ELLIP_COORD/LAT"))
Lat_Deg=int(Lat.find("DEGREES").text)
Lat_Min=Lat.find("MINUTES").text
Lat_Secs=Lat.find("SECONDS").text

if Lat_Deg <0 :
   Lat_Hemi="S"
   Lat_Deg*=-1
else:
   Lat_Hemi="N"

Long=(XML.find("./POSITION[@TYPE='INTERNAL']/COORD_SET/ELLIP_COORD/EAST_LONG"))
Lon_Deg=int(Long.find("DEGREES").text)
Lon_Min=Long.find("MINUTES").text
Lon_Secs=Long.find("SECONDS").text

if Lon_Deg <0 :
   Lon_Hemi="S"
   Lon_Deg*=-1
else:
   Lon_Hemi="N"


Height=float(XML.find("./POSITION[@TYPE='INTERNAL']/COORD_SET/ELLIP_COORD/EL_HEIGHT").text)
Arp_Height=float(XML.find("./DATA_SOURCES/ANTENNA/ARP_HEIGHT").text)
#pprint.pprint(Arp_Height)
#dump(Position)

print "roverPositionLat={0}d{1}m{2}s{3}".format(Lat_Deg,Lat_Min,Lat_Secs,Lat_Hemi)
print "roverPositionLon={0}d{1}m{2}s{3}".format(Lon_Deg,Lon_Min,Lon_Secs,Lon_Hemi)
print "roverPositionHgt={0}".format(Height)
print "roverHeightOffsetFromAPC={0}".format(Arp_Height+ARP_APC)
