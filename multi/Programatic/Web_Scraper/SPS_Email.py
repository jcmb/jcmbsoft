#!/usr/bin/env python -u


from xml.etree.ElementTree import parse, dump
import pprint
from collections import defaultdict
import sys
import urllib2
import urllib
import base64


#print 'Number of arguments:', len(sys.argv), 'arguments.'
#print 'Argument List:', str(sys.argv)

def help():
   sys.stderr.write ("Usage: SPS_Email <Server> [Enable] [Email] [[-]Option]*\n")
   sys.stderr.write ("\n")
   sys.stderr.write ("Where\n")
   sys.stderr.write ("  Server: Is the SPS GNSS Receiver address\n")
   sys.stderr.write ("      for systems with user:password required use user:password@server\n")
   sys.stderr.write ("  Enable: is TRUE or FALSE\n")
   sys.stderr.write ("  Email: is the email address to send to, - if the email address should be unchanged\n")
   sys.stderr.write ("  Options: Email options to turn on, or off - in front\n")
   sys.stderr.write ("")
   quit(10)

if len(sys.argv) <= 1 :
   help()

if len(sys.argv) == 2 :
   Display_Status=True
else:
   Display_Status=False

server=sys.argv[1]
if server.find("@") == -1 :
   username=""
   password=""
   sys.stderr.write ("User and password not provided\n")
   sys.stderr.write ("GNSS Receiver: {0}\n".format(server))
else:
   username = server[0:server.find(":")]
   sys.stderr.write ("User: {0}\n".format(username))
   server=server[server.find(":")+1:]
   password = server[0:server.find("@")]
   sys.stderr.write ("Password: {0}\n".format(password))
   server=server[server.find("@")+1:]
   sys.stderr.write ("GNSS Receiver: {0}\n".format(server))

url="http://" + server + "/xml/dynamic/email.xml"

#password_mgr = urllib2.HTTPPasswordMgrWithDefaultRealm()
#password_mgr.add_password(None, "http://" + sys.argv[1], 'admin', 'jcmsps850')
#auth_handler = urllib2.HTTPBasicAuthHandler(password_mgr)

#print url

#proxy_handler = urllib2.ProxyHandler({'http': 'http://wpad.am.trimblecorp.net:3128/'})
#print authheader
#opener = urllib2.build_opener(proxy_handler)
# This time, rather than install the OpenerDirector, we use it directly:

opener = urllib2.build_opener()

if username:
   authheader =  "Basic %s" % base64.encodestring('%s:%s' % (username, password))
   opener.addheaders=[("Authorization", authheader)]
xml_raw = opener.open(url)

doc = parse(xml_raw)


if doc.find("enable").text == "1":
   Enabled=True
   if Display_Status :
      print "\nEmail Alerts: Enabled"
else:
   Enabled=False
   if Display_Status :
      print "\nEmail Alerts: Disabled"

To=doc.find("to").text
if Display_Status :
   print "To:", To
   print ""

max_id=-1
ids={}
enabled={}
names={}

for alert in doc.findall("alert"):
   id = int(alert.get("id"))
   if id > max_id :
      max_id = id

   if alert.get("name").find("EmailAlert") == 0 :
      name = alert.get("name")[len("EmailAlert"):]
      ids[name]=id
      names[id]=name

   if alert.get("enabled") :
      if Display_Status :
         print name.ljust(20),": Enabled"
      enabled[name]=True
   else:
      enabled[name]=False
      if Display_Status :
         print name.ljust(20),": Disabled"
#   dump(alert)
#   pprint.pprint (alert.get("enabled"))
#   pprint.pprint (alert.get("name"))

#pprint.pprint(ids)
#pprint.pprint(names)
#pprint.pprint(enabled)

# At this stage we have gone and got all of the details from the GNSS. If we only have a single parameter then we stop

if len(sys.argv) == 2 :
   quit(1)

if len(sys.argv) == 3 :
   help()

if sys.argv[2].upper() == "TRUE" :
   Enabled=True
   print "Enabling Email Alerts"

if sys.argv[2].upper() == "FALSE" :
   Enabled=False
   print "Disabling Email Alerts"

if sys.argv[3] != "-" :
   To=sys.argv[3]
   print "Updating Email to: ", To

for arg in range(4,len(sys.argv)) :
   option=sys.argv[arg]
   enable=True
   if option[0]=="-":
      enable=False
      option=option[1:]

   if option in ids:
      enabled[option]=enable
      if enable:
         print "Enable:", option
      else:
         print "Disable:", option

   else:
      print "Invalid Option:", option
      quit(9)


#http://sps855.com/CACHEDIR2857174610/cgi-bin/emailAlert.xml?emailAlertEnable=on&SMTPTo=Geoffrey_Kirk%40Trimble.com&emailAlert0=on&emailAlert1=on&emailAlert3=on&emailAlert4=on&emailAlert9=on&emailAlert10=on&emailAlert11=on&emailAlert13=on&emailAlert16=on&emailAlert17=on&emailAlert18=on&emailAlert19=on&request=0

request=""
if Enabled:
   request+="emailAlertEnable=on"
#else:
#   request+="emailAlertEnable=off"

request+="&"
request+=urllib.urlencode({"SMTPTo":To})
request+="&"

#print max_id

for option in range(0,max_id+1):
   if option in names :
#      print option, names[option]
      alert="emailAlert" + str(ids[names[option]])
      if enabled[names[option]]:
         request+=urllib.urlencode({alert:"on"})
         request+="&"

request+="request=0"

url="http://" + server + "/cgi-bin/emailAlert.xml?" + request


#print url
#pprint.pprint(enabled)
result=opener.open(url)
#print result.geturl()
#print result.info()

if result.getcode() == 200:
   print "Changes applied"
else:
   print "Error in applying changes"
   + str(result.getcode())

