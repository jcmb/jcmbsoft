#!/usr/bin/env python -u
import sys

sys.path.append("/Users/gkirk/Dropbox/Develop/Python/TCP Test/")
#Hack for getting pynmea in

import socket
import select
import errno
from pynmea.streamer import NMEAStream
import pynmea
import pprint
import base64
import urllib2
from datetime import datetime, time


def NMEA_Seconds_Of_Day (NMEA_Time):
   Base_Date=datetime(1900,1,1)
   Time=datetime.strptime(NMEA_Time,"%H%M%S.%f")
   return ((Time-Base_Date).total_seconds())


print "Type,Time,R1 Age, R2 Age, Age Matchs,R1 Q, R2 Q, Q Matches,R1 Cont,R2 Cont,R1 Total,R2 Total"

#create an INET, STREAMing socket
s1 = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
# - the normal http port
s1.connect(("192.168.128.31", 28001))
s1.setblocking(0)

s2 = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s2.connect(("192.168.128.35", 28002))
s2.setblocking(0)
#s2.settimeout(2)

streamer1 = NMEAStream()
streamer2 = NMEAStream()
data_obs =[]
run_main_loop = True

s1_time=None
s1_age=None
s1_quaility=None
s1_radio=0
s1_total_radio=0

s2_time=None
s2_age=None
s2_quaility=None
s2_radio=0
s2_total_radio=0


Waiting_For_Fixed=0
Waiting_For_Both_Fixed=1
Waiting_For_Solid_Radio=2
Got_Solid_Radio=3
Waiting_For_Auton=4

server="http://192.168.128.8"
turn_on_cmr_cmd= server + "/cgi-bin/io.xml?port=3&type=Radio&datatype=cmr&CMR=1&CMRDelay=0&OK=1"
turn_off_cmr_cmd=server + "/cgi-bin/io.xml?port=3&type=Radio&datatype=cmr&CMR=0&CMRDelay=0&OK=1"

opener = urllib2.build_opener()
username="admin"
password="testsite"



if username:
   authheader =  "Basic %s" % base64.encodestring('%s:%s' % (username, password))
   opener.addheaders=[("Authorization", authheader)]

State=Waiting_For_Fixed

while run_main_loop :
   read_ready, _, error_socket = select.select([s1,s2], [],[s1,s2],30)
   if read_ready == []:
      sys.stderr.write("No Data for 30 seconds, aborting\n")
      quit(10)

   for sock in (s1,s2):
      if sock in error_socket:
         if sock==s1 :
            print "Error: s1"
            run_main_loop = False
         if sock==s2 :
            print "Error: s2"
            run_main_loop = False

      if sock in read_ready:
         # The socket have data ready to be received
         buffer = ''
         continue_recv = True
         while continue_recv:
            try:
       # Try to receive som data
               s = sock.recv(2000)
               if not s:
                  continue_recv = False
                  run_main_loop = False
               else :
                  buffer += s
            except socket.error, e:
               if e.errno != errno.EWOULDBLOCK:
                  # Error! Print it and tell main loop to stop
                  print 'Error: %r' % e
                  run_main_loop = False
               else :
                  pass
                  #                       print "Would Block"
                # If e.errno is errno.EWOULDBLOCK, then no more data
            continue_recv = False


         if sock==s1 :
#            print "s1 Buffer", buffer
            data_obs = streamer1.get_objects(data=buffer)
            data_obs = streamer1.get_objects(data="")
            # The "" is to make us get the object straight away
            for obs in data_obs:
                if isinstance(obs,pynmea.nmea.GPGGA):
                   s1_time=NMEA_Seconds_Of_Day(obs.timestamp)
                   if obs.age_gps_data:
                      s1_age=float(obs.age_gps_data)
#                      print "S1",s1_age
                   else:
                      s1_age=0
#                      print "S1 No Time"

                   s2_quaility=int(obs.gps_qual)
                   s1_quaility=int(obs.gps_qual)
   # Remember to make sure you feed some empty data to flush the last of the data out
         if sock==s2 :
#            print "s2 Buffer", buffer
#           print "s2"
            data_obs = streamer2.get_objects(data=buffer)
            data_obs = streamer2.get_objects(data="")
              # The "" is to make us get the object straight away
            for obs in data_obs:
                if isinstance(obs,pynmea.nmea.GPGGA):
                   s2_time=NMEA_Seconds_Of_Day(obs.timestamp)
                   if obs.age_gps_data:
                      s2_age=float(obs.age_gps_data)
#                      print "S2",s2_age
                   else:
                      s2_age=0
#                      print "S2 No Time"
                   s2_quaility=int(obs.gps_qual)
   # Remember to make sure you feed some empty data to flush the last of the data out

         if s1_time == s2_time:
            if (s1_age == 1.0):
               s1_radio+=1
               s1_total_radio+=1
            else:
               s1_radio=0

            if (s2_age == 1.0):
               s2_radio+=1
               s2_total_radio+=1
            else:
               s2_radio=0

            if State==Waiting_For_Auton:
               if (s1_quaility == 1) and (s2_quaility==1):
                  print "Auto,{},{},{},{},{},{},{},{},{},{},{}".format(s1_time,s1_age,s2_age,s1_age==s2_age,s1_quaility,s2_quaility,s1_quaility==s2_quaility,s1_radio,s2_radio,s1_total_radio,s2_total_radio)
 #                 print "Turn on Radio"
                  opener.open(turn_on_cmr_cmd)
                  State=Waiting_For_Fixed
                  s1_radio=0
                  s2_radio=0
                  s1_total_radio=-1 #since we always have 1 for the first fixed
                  s2_total_radio=-1


            if State==Waiting_For_Fixed :
               if (s1_quaility == 4) or (s2_quaility==4):
                  State=Waiting_For_Both_Fixed
                  print "One Fixed,{},{},{},{},{},{},{},{},{},{},{}".format(s1_time,s1_age,s2_age,s1_age==s2_age,s1_quaility,s2_quaility,s1_quaility==s2_quaility,s1_radio,s2_radio,s1_total_radio,s2_total_radio)



            if State==Waiting_For_Both_Fixed :
               if (s1_quaility == 4) and (s2_quaility==4):
                  State=Waiting_For_Solid_Radio
                  print "Both Fixed,{},{},{},{},{},{},{},{},{},{},{}".format(s1_time,s1_age,s2_age,s1_age==s2_age,s1_quaility,s2_quaility,s1_quaility==s2_quaility,s1_radio,s2_radio,s1_total_radio,s2_total_radio)
                  s1_radio=0
                  s2_radio=0

            if State==Waiting_For_Solid_Radio:

               if (s1_radio >= 10) and (s2_radio >= 10) :
                  State=Got_Solid_Radio
                  print "Solid,{},{},{},{},{},{},{},{},{},{},{}".format(s1_time,s1_age,s2_age,s1_age==s2_age,s1_quaility,s2_quaility,s1_quaility==s2_quaility,s1_radio,s2_radio,s1_total_radio,s2_total_radio)

            if State==Got_Solid_Radio:
#               print "Turn off Radio"
               opener.open(turn_off_cmr_cmd)
               State=Waiting_For_Auton
               s1_radio=0
               s2_radio=0
               s1_total_radio=-1 #since we always have 1 for the first fixed
               s2_total_radio=-1


            if s1_age!=s2_age:
#               print "Missed,{},{},{},{},{},{},{},{},{},{},{}".format(s1_time,s1_age,s2_age,s1_age==s2_age,s1_quaility,s2_quaility,s1_quaility==s2_quaility,s1_radio,s2_radio,s1_total_radio,s2_total_radio)
               if s1_age > s2_age :
                  s1_radio =0
               if s2_age > s1_age :
                  s2_radio =0
            else :
#               print "Normal,{},{},{},{},{},{},{},{},{},{},{}".format(s1_time,s1_age,s2_age,s1_age==s2_age,s1_quaility,s2_quaility,s1_quaility==s2_quaility,s1_radio,s2_radio,s1_total_radio,s2_total_radio)
               pass
#            print "{},{},{},{},{},{},{}".format(s1_time,s1_age,s2_age,s1_age==s2_age,s1_quaility,s2_quaility,s1_quaility==s2_quaility,s1_radio,s2_radio)
