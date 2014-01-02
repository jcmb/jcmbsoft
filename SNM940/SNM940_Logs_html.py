#!/usr/bin/env python
import sys, re, base64, httplib, apachelog
from collections import defaultdict


print ("<html><head><title>SNM940 Log view</title></head><body>")
print ('<a href="#summary">Goto Summary Information</a>')
print ('<table border="1">')
#print ("<caption>SNM940 Device information</caption>")
#print ("<tr><th>Serial</th><th>Version</th><th>Base Org</th><th>Device ID</th><th>Device Org</th><th>Date</th><th>IP Address</th><th>Agent</th><th>NTRIP Version</th><th>F/w Version</th><th>Serial</th><th>Type</th><th>Warranty</th></tr>")

#base_org_connections=defaultdict(int)
#rover_org_connections=defaultdict(int)
device_firmware={}
device_first_time={}
device_last_time={}
device_ip={}
firmware_totals=defaultdict(int)
ips={}

result_names={
   200:"OK",
   401:"Unauthorized",
   403:"Forbidden",
   501:"Not Implemented"}

format = r'%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"'
#print format
log = apachelog.parser(format)

for line in sys.stdin:
    try:
       file_fields = log.parse(line)
       url=file_fields["%r"]
       fields=re.match('GET //DeviceExceptions/(.*)\?(.*) HTTP',url)
       if fields :
#            print "match"
            device_last_time[fields.group(1)]=file_fields["%t"]
            if not fields.group(1) in device_first_time :
                device_first_time[fields.group(1)]=file_fields["%t"]

            device_ip[fields.group(1)]=file_fields["%h"]

            if fields.group(1) in device_firmware :
                if device_firmware[fields.group(1)] != fields.group(2) : # have changed firmware_totals
                    firmware_totals[device_firmware[fields.group(1)]]-=1;
                    firmware_totals[fields.group(2)]+=1
            else:
                device_firmware[fields.group(1)]=fields.group(2)
                firmware_totals[fields.group(2)]+=1
#       else:
#           fields=re.match('GET //(.*)/(.*)/firmwareControl.txt HTTP"',url)
    except:
       sys.stderr.write("Unable to parse %s" % line)

print '<table border="1">'
print "<tr><th>Serial</th><th>Firmware</th><th>Last Contact</th><th>First Contact</th><th>Last IP</th><th>Country</th><th>State</th><th>City</th></tr>"

Keys = list(device_firmware.keys())
Keys.sort();
Total_Devices=0

Country=0;
State=1;
City=2;

for device in Keys:
    print "<tr><td>"+device+"<td>" + str(device_firmware[device]) + "</td>"
    print "<td>"+device_last_time[device].strip("][")+"</td>"
    print "<td>"+device_first_time[device].strip("][")+"</td>"
    print "<td>"+device_ip[device]+"</td>"

    if not device_ip[device] in ips :
	ips[device_ip[device]]=['','',''] 
#[Country] = "";
	ips[device_ip[device]][State] = "";
	ips[device_ip[device]][City] = "";

	servername = 'wpad.am.trimblecorp.net:3128'
    	server = httplib.HTTPConnection(servername);
    	server.request('GET', 'http://freegeoip.net/csv/' + device_ip[device])
    	reply = server.getresponse()

    	if reply.status != 200:
            print('Error sending request', reply.status, reply.reason)
    	else:
    # 200 means success
            data = reply.read()
            ip_fields=data.split(",")
            ips[device_ip[device]][Country]= ip_fields[2].strip('"');         
            ips[device_ip[device]][State] = ip_fields[4].strip('"');
            ips[device_ip[device]][City] = ip_fields[5].strip('"');
            reply.close()

    print "<td>" , ips[device_ip[device]][Country] , "</td>"

    ip_fields=data.split(",")
    print "<td>" , ips[device_ip[device]][State] , "</td>"

    ip_fields=data.split(",")
    print "<td>" , ips[device_ip[device]][City] , "</td>"

    print "</tr>"
    Total_Devices+=1
print "</table>"

print "<br/>"
print "Total Devices: " + str(Total_Devices);
print "<p/>"

print '<a name="summary">'
print '<table border="1">'
print "<tr><th>Firmware</th><th>Total</th></tr>"

Total_Devices=0
Keys = list(firmware_totals.keys())
Keys.sort();
for firmware in Keys:
    print "<tr><td>"+firmware+"<td>" + str(firmware_totals[firmware]) + "</td></tr>"
    Total_Devices+=firmware_totals[firmware]

print "</table>"

print "<br/>"
print "Total Devices: " + str(Total_Devices);
print "<p/>"

print "</table>"

print "</body></html>"
