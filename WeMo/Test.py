#!/usr/bin/env python -u
from ouimeaux.environment import Environment
from pprint import pprint
import logging
import datetime

def help:
   print "WeMo_Motion <Motion>"
   print ""
   print "Waits for the Motion Detector to detect motion and then exits with a result of 0
   quit(10)

if len(argv) != 2:
   help()
   
Motion_Name=argv[1]
print Motion_Name
   
logging.basicConfig(level=logging.CRITICAL)
#def on_switch(switch):
#    print "Switch found!", switch.name

def on_motion(motion):
    print "Motion found!", motion.name

env = Environment(motion_callback=on_motion,with_cache=False,with_subscribers=False)

env.start()

env.discover(seconds=2)

#pprint(env.list_switches())
pprint(env.list_motions())
Motion=env.get_motion('Motion')
Motion.explain()
while 1:
   print datetime.datetime.now(),Motion.get_state()
env.wait()

