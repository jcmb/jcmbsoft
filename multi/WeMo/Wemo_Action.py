#!/usr/bin/env python -u

print "Content-Type: text/html"     # HTML is following
print                               # blank line, end of headers
print "<head><title>Wemo Action</title></head>"
print "<body><h1>Wemo Action</h1>"

import pprint
from collections import defaultdict
import sys
import subprocess
import string
import cgitb
import urllib

cgitb.enable()

form = cgi.FieldStorage()
switch=unquote_plus(form["Switch"])
action=form["Action"]
wemo_action=subprocess.check_output(["wemo","switch",switch,action])
wemo_action=subprocess.check_output(["wemo","switch",switch,"Status"])
if wemo_action == "1"
   print "Switch {0} is now on<p/>"
else:
   print "Switch {0} is now off<p/>"
   
print "</body></html>"
