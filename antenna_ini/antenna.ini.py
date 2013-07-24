#! /usr/bin/env python

import ConfigParser
import argparse
import string

# Application for parsing a Trimble Antenna.ini file
# Will display the version, groups, antennas in a group or antenna details
#
# when the --html flag is give it outputs the information in a format that can easily be used in a cgi program
#
# The system is running at http://linux.trimble-wco.com/cgi-bin/antenna_ini
#
#

parser = argparse.ArgumentParser(description='Display Information on antenna.ini.')

parser.add_argument('--version','-v',action="store_true", help='Display Version Information for the file')

parser.add_argument('--groups', '-s',action="store_true",
                   help='Display antenna group Information for the file')

parser.add_argument('--group', '-g',
                   help='Antennas in a group')

parser.add_argument('--html', '-H',action="store_true",
                   help='Output the information in a format for including into HTML')

parser.add_argument('--antenna', '-a',
                   help='Antenna Information')

args = parser.parse_args()
#print args.accumulate(args.integers)
#print args

config = ConfigParser.ConfigParser()
if  (config.read('antenna.ini') == []) :
   print "Could not open antenna.ini"
   quit(10)



if args.version :
   if args.html :
      print "Version:" , config.get("AntDatabaseInfo","Version") , "<br/>"
      print "Language:" ,config.get("AntDatabaseInfo","Language")
   else:
      print config.get("AntDatabaseInfo","Version")
      print config.get("AntDatabaseInfo","Language")



if args.groups :
   groups= config.items("AntennaGroup")
   if args.html :
      print "Antenna Group: <select name=group>"

   for group in groups:
      if args.html :
         try :
            if group[1] == "SCS900" :
               print '<option selected value="' + group[1] + '">' + config.get(group[1],"Name") + '</option>'
            else:
               print '<option value="' + group[1] + '">' + config.get(group[1],"Name") + '</option>'
         except ConfigParser.NoOptionError:
            print '<option value="' + group[1] + '">' + group[1] + '</option>'
      else:
         print group[1]

   if args.html :
      print "</select>"


if args.group:
   try :
      antennas= config.items(args.group)
   except :
      print "Group" , args.group, "does not exist"
      quit(2)

   if args.html :
      print "<h2>Antennas for group:"
      print config.get(args.group,"Name"),"</h2>"
      print "Antennas: <select name=antenna>"
   else :
      print "Group Name: " , config.get(args.group,"Name")
      print "Antennas:"

   antenna_index=1;
   antenna=config.get(args.group,"Ant"+str(antenna_index))

   while antenna:
      antenna_index+=1
      antenna_name=string.split(antenna,",")[0]
      if args.html:
          print '<option value="' + antenna_name + '">' + config.get(antenna_name,"Name") + '</option>'
      else:
          print string.split(antenna,",")[0]

      try:
         antenna=config.get(args.group,"Ant"+str(antenna_index))
      except ConfigParser.NoOptionError:
         antenna=""

   antenna_index-=1

   if args.html :
      print "</select>"
   else :
      print "Number of Antennas: ", antenna_index


if args.antenna:
   try :
      antenna=config.options(args.antenna)
   except :
      print "Antenna", args.antenna, "does not exist"
      quit(3)
   if args.html:
      print "<table border=\"1\"><thead><caption>Antenna Information:</caption></thead><tbody>"
      print "<tr><td>Antenna Section</td><td>" , args.antenna,"</td>"
      print "<tr><td>Antenna Name</td><td>" , config.get(args.antenna,"Name"),"</td>"
      print "<tr><td>Antenna Short (DC) Name</td><td>" , config.get(args.antenna,"DCName"),"</td>"
      print "<tr><td>Manufacturer</td><td>" , config.get(args.antenna,"Manufacturer"),"</td>"
      print "<tr><td>Part Number</td><td>" , config.get(args.antenna,"PartNumber"),"</td>"
      print "<tr><td>ID (Character Code)</td><td>" , config.get(args.antenna,"CharCode"),"</td>"
      print "<tr><td>ID (Type)</td><td>" , config.get(args.antenna,"Type"),"</td>"
      print "<tr><td>Freq</td><td>" , config.get(args.antenna,"Freq"),"</td>"
      print "<tr><td>Class</td><td>" , config.get(args.antenna,"Class"),"</td>"
      print "<tr><td>Added</td><td>" , config.get(args.antenna,"AddDate"),"</td>"

      print "</tbody>"
      print "</table><p/>"
   else:
      print "Antenna Information:"
      print "Antenna Section" , args.antenna
      print "Antenna Name: " , config.get(args.antenna,"Name")
      print "Antenna Short (DC) Name: " , config.get(args.antenna,"DCName")
      print "Manufacturer: " , config.get(args.antenna,"Manufacturer")
      print "Part Number: " , config.get(args.antenna,"PartNumber")
      print "ID (Character Code): " , config.get(args.antenna,"CharCode")
      print "ID (Type): " , config.get(args.antenna,"Type")
      print "Freq: " , config.get(args.antenna,"Freq")
      print "Class: " , config.get(args.antenna,"Class")
      print "Added: " , config.get(args.antenna,"AddDate")



   if args.html:
      print "<p/><table border=\"1\"><thead><caption>Antenna Measurement Methods:</caption>"
      print "<tr><th>ID</th><th>Method</th><th>Horizontal Offset (m)</th><th>Vertical Offset (m)</th></tr></thead><tbody>"
   else:
      print ""
      print "Measurement Methods:"

   method_index=0
   method=config.get(args.antenna,"MeasMethod"+str(method_index))
   while method:
      method_details=string.split(method,"=")[0]
      (H_Offset,V_Offset,Tape_Offset,Method_Name)=string.split(method_details,",",3) # Some of the methods may have , in them so we have to use a max splits
      Method_Name=Method_Name.strip("\"")

      if args.html:
         print "<tr><td>",method_index,"</td><td>",Method_Name,"</td><td>",H_Offset,"</td><td>",V_Offset,"</td></tr>"
      else:
         print " Method ID: " ,  method_index , "Name:", Method_Name
         print " Horizontal Offset:", H_Offset, "(m)    Vertical Offset:", V_Offset, "(m)"
      method_index+=1
      try:
         method=config.get(args.antenna,"MeasMethod"+str(method_index))
      except ConfigParser.NoOptionError:
         method=""

   if args.html:
      print "</tbody>"
      print "</table>"
   else :
      print "Number of measurment methods: ", method_index
      print "Rinex Method:" ,config.get(args.antenna,"RINEXMethod")


   if args.html:
      print "<p/><table border=\"1\"><thead><caption>Antenna Models:</caption></thead><tbody>"
      print "<tr><td>Trimble APC Model</td><td>" , config.get(args.antenna,"PhaseCorrTable"),"</td>"
      print "<tr><td>NGS APC Model</td><td>" , config.get(args.antenna,"NGSCorrTable"),"</td>"
      print "<tr><td>IFE APC Model</td><td>" , config.get(args.antenna,"IFECorrTable"),"</td>"
      print "</tbody>"
      print "</table>"
   else:
      print ""
      print "Antenna Models:"
      print "Trimble APC Model: " , config.get(args.antenna,"PhaseCorrTable")
      print "NGS APC Model: " , config.get(args.antenna,"NGSCorrTable")
      print "IFE APC Model: " , config.get(args.antenna,"IFECorrTable")


# The Rinex names section of the antenna.ini is nuts in that it has mutiple keys with the same name instead of a number like the methods
# The standard python parsers doesn't deal with this by default and since it is the Rinex names I am ignoreing this
#   print ""
#   print "Rinex Names:"
#   rinex=config.get(args.antenna,"RinexName")
#   print rinex

