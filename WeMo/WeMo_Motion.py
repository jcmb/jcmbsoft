#!/usr/bin/env python -u
from ouimeaux.environment import Environment
from pprint import pprint
import logging
import datetime
import sys
import time

def help():
   print "WeMo_Motion <Motion>"
   print ""
   print "Waits for the Motion Detector to detect motion and then exits with a result of 0"
   quit(10)

if len(sys.argv) != 2:
   help()
   
Motion_Name=sys.argv[1]
print "Monitoring: ", Motion_Name
   
logging.basicConfig(level=logging.CRITICAL)
#def on_switch(switch):
#    print "Switch found!", switch.name

def on_motion(motion):
    print "Motion sensor found!", motion.name

env = Environment(motion_callback=on_motion,with_cache=False,with_subscribers=False)

env.start()

env.discover(seconds=3)

#pprint(env.list_switches())
#pprint(env.list_motions())
Motion=env.get_motion(Motion_Name)
#Motion.explain()
while 1:
   State = Motion.get_state()
#   print datetime.datetime.now()
#   print State
   if State != 0:
      print "Motion Detected"
      quit()
   time.sleep (0.25)
#env.wait()

