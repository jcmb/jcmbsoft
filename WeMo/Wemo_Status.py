#!/usr/bin/env python -u

print "Content-Type: text/html"     # HTML is following
print                               # blank line, end of headers
print "<head><title>Wemo Status</title></head>"
print "<body><h1>Wemo status</h1>"

import pprint
from collections import defaultdict
import sys
import subprocess
import string
import cgitb
import urllib

cgitb.enable()

debug=len(sys.argv) == 2 
if debug:
   sys.stderr.write ("Running Wemo List\n")
wemo_output=subprocess.check_output(["wemo","list"])
wemo_output=wemo_output.split('\n') 
print '<form action="Wemo_Action2.asp" method="get">'
print "<table><thead><th>Switch</th><th>Status</th><th>Action</th></thead><tbody>"
for line in wemo_output:
   if debug:
      sys.stderr.write (line+"\n")
#   print line.find("Switch: ")
   if line.find("Switch: ") == 0:
      switch=line[len("Switch: ")+1:]
      if debug :
         sys.stderr.write ("Geting status for switch: {0}".format(switch))

      wemo_status=subprocess.check_output(["wemo","switch",switch,"status"])
      if debug :
         sys.stderr.write ("Status: {0}".format(wemo_status))

      if wemo_status == "0" :
         print '<tr><td>{0}</td><td>Off</td><td><a href="Wemo_Action.py?Switch={1}&Action=On">Turn On</a></td></tr>'.format(switch,urllib.quote_plus(switch))
      else:
         print '<tr><td>{0}</td><td>On</td><td><a href="Wemo_Action.py?Switch={1}&Action=Off">Turn Off</a></td></tr>'.format(switch,urllib.quote_plus(switch))
      
print "</table></form></html>"
