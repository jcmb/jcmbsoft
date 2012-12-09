#!/usr/bin/env python
import sys, re, base64, httplib
from collections import defaultdict


print ("<html><head><title>IBSS Caster Log view</title></head><body>")
print ('<a href="#summary">Goto Summary Information</a>')
print ('<table border="1">')
print ("<caption>IBSS Caster information</caption>")
print ("<tr><th>Connection Type</th><th>Result</th><th>Base Org</th><th>Device ID</th><th>Device Org</th><th>Date (UTC)</th><th>IP Address</th><th>Agent</th><th>NTRIP Version</th><th>F/w Version</th><th>Serial</th><th>Type</th><th>Warranty</th></tr>")
#csv_file = csv.reader(open("audit.log","rb"),quoting=csv.QUOTE_ALL);

result_totals = defaultdict(int)
#base_org_connections=defaultdict(int)
#rover_org_connections=defaultdict(int)
device_totals = defaultdict(int)
device_good = defaultdict(int)
device_IP={}
device_time={}

result_names={
   200:"OK",
   401:"Unauthorized",
   403:"Forbidden",
   501:"Not Implemented"}

for line in sys.stdin:
#    print "loop"
#    print line
#    fields=re.match('"(.*)",',line)
    fields=re.match('"(.*?)","(.*?)","(.*?)","(.*?)","(.+?)","(.+?)","(.+?)","(.+?)","(.+)"',line)
    num_fields=9
    if  not fields :
        fields=re.match('"(.*?)","(.*?)","(.*?)","(.*?)","(.+?)","(.+?)","(.+?)","(.+?)"',line)
        num_fields=8
        if not fields :
            raise Exception ("Failed to Parse string")
#    else :
#        print "Got 9 fields"

#    print fields.group(1)

#    fields = line.split(",")
#    print fields
    headers=[]
#    print "1 " + fields.group(1)
#    print "5 " + fields.group(5)
#    print "8 " + fields.group(8)
#    if num_fields == 9:
#        print "9 " + fields.group(9)
    s = fields.group(6).strip('"')
#    print s
    header_list = s.split("\\n")
    headers={}
    for header_line in header_list:
        if header_line.find (":") != -1 :
            key,value = header_line.split(":",1)
#               print key,value
            headers[key]=value
        elif header_line.find ("=") != -1 :
            key,value = header_line.split("=",1)
#               print key,value
            headers[key]=value
#    print headers

    if headers["user-agent"].find("CURL") != -1 :
       continue;

    if headers["user-agent"].find("nagios") != -1 :
       continue;

    print "<tr>"

    url=fields.group(7).strip('"').upper();
    request="UNKNOWN"
    if url.find("GET / ") != -1 :
        request="Get Source Table"
    elif url.find("POST") != -1 :
        re_result=re.match("POST /(.*) HTTP",url)
        if re_result :
            request="Base Station: " + re_result.group(1)
        else :
            request="unknown POST: " + url;
    else :
        if url.find("GET /") != -1 :
            re_result=re.match("GET /(.*) HTTP",url)
            if re_result :
                request="Use " + re_result.group(1)
            else :
                request="unknown Get: " + url;

    print "<td>", request, "</td>"

    result=int(fields.group(8).strip());

    result_totals[result]+=1

    if result in result_names :
       print "<td>" + result_names[result] + "</td>"
    else :
       print "<td>", result, "</td>"

    re_result=re.match("(.*).ibss.trimbleos.com",headers["host"].lower())

    base_org="UNKNOWN"

    if re_result :
        base_org=re_result.group(1).strip()

    print "<td>" + base_org + "</td>"
#    print headers

    if  "authorization" in  headers :
        device_id=headers["authorization"];
    else :
#    print device_id
        device_id="Not Given";

 #   print device_id
    re_result=re.match(" *Basic *(.*)",device_id)

    if re_result :
        device_id=re_result.group(1)
#        print device_id
        device_id=base64.b64decode(device_id)
#        print device_id
        re_result=re.match("(.*)\.(.*):",device_id)

        if not re_result :
#            print "no org"
            re_result=re.match("(.*):",device_id)
            if not re_result :
                device_id="UNKNOWN"
                device_org="UNKNOWN"
            else :
                device_id=re_result.group(1)
                device_org=base_org;
        else:
            device_id=re_result.group(1)
            device_org=re_result.group(2)

    print "<td>" + device_id + "</td>"
    device_totals[device_id] +=1
    if result==200 :
        device_good[device_id] +=1

    print "<td>" + device_org + "</td>"

    print "<td>" + fields.group(1) + "</td>"
    device_time[device_id]=fields.group(1);

    print "<td>" + fields.group(2) + "</td>"
    device_IP[device_id]=fields.group(2);

    print "<td>" + headers["user-agent"] + "</td>"

    if "ntrip-version" in headers :
        print "<td>" + headers["ntrip-version"] + "</td>"
    else :
        print "<td>V1</td>"

    if "x-version" in headers :
        print "<td>" + headers["x-version"] + "</td>"
    else :
        print "<td></td>"

    if "x-serialnum" in headers :
        print "<td>" + headers["x-serialnum"].upper() + "</td>"
    else :
        print "<td></td>"

    if "x-device" in headers :
        print "<td>" + headers["x-device"].upper() + "</td>"
    else :
        print "<td></td>"

    if "x-warranty-date" in headers :
        print "<td>" + headers["x-warranty-date"] + "</td>"
    else :
        print "<td></td>"

    print "</tr>"

print "</table>"

print "<p/>"
print '<a name="summary">'
print '<table border="1">'
print "<tr><th>Result Type</th><th>Total</th></tr>"

for result in result_totals:
    print "<tr>"
    if result in result_names :
       print "<td>" + result_names[result] + "</td>"
    else :
       print "<td>", result, "</td>"
    print "<td>" + str(result_totals[result]) + "</td></tr>"
print "</table>"

print "<p/>"

print '<table border="1">'
print "<tr><th>Device ID</th><th>Total Connections</th><th>Good Connections</th><th>Last IP</th><th>Last Connection</th>";
print "<th>Country</th><th>State</th><th>City</th></tr>"

Keys = list(device_totals.keys())
Keys.sort();
for device in Keys:
    print "<tr><td>", device, "</td>"
    print "<td>" + str(device_totals[device]) + "</td>"
    print "<td>" + str(device_good[device]) + "</td>"
    print "<td>" + device_IP[device] + "</td>"
    print "<td>" + device_time[device] + "</td>"
    servername = 'wpad.am.trimblecorp.net:3128'
    server = httplib.HTTPConnection(servername);
    server.request('GET', 'http://freegeoip.net/csv/' + device_IP[device])
    reply = server.getresponse()

    if reply.status != 200:
       print('Error sending request', reply.status, reply.reason)
    else:
    # 200 means success
        data = reply.read()
        ip_fields=data.split(",")
        print "<td>" , ip_fields[2].strip('"') , "</td>"

        ip_fields=data.split(",")
        print "<td>" , ip_fields[4].strip('"') , "</td>"

        ip_fields=data.split(",")
        print "<td>" , ip_fields[5].strip('"') , "</td>"

    reply.close()
    print "</tr>"

print "</table>"

print "</body></html>"
