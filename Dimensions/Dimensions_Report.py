#!/usr/bin/env python
import sys, re, base64, httplib
from collections import defaultdict


print ("<html><head><title>Bootcamp registration Report</title></head><body>")

#print ("<caption>BootCamp registration information</caption>")
#print ("<tr><th>Serial</th><th>Version</th><th>Base Org</th><th>Device ID</th><th>Device Org</th><th>Date</th><th>IP Address</th><th>Agent</th><th>NTRIP Version</th><th>F/w Version</th><th>Serial</th><th>Type</th><th>Warranty</th></tr>")


Attendee_Type=defaultdict(int)
#Company=defaultdict(int)
Company={}
Country=defaultdict(int)
Role=defaultdict(int)
Session=defaultdict(int)
Software_Request=0

Session_names=[
   "CONNECTED SITE IN ACTION",
   "SOFTWARE OVERVIEW",
   "SETTING UP CONNECTED SITE",
   "LARGE SITES",
   "ROADING",
   "SMALL SITES",
   "NEW PRODUCTS",
   "SELLING",
   "TROUBLE SHOOTING",
   "MINES AND QUARRIES",
   "SPECIALIST"]

lines=0
for line in sys.stdin:
    file_fields = line.split(",")
    lines+=1
    if lines == 1 :
#        print "Skipping first"
        continue
    Attendee_Type[file_fields[0]]+=1
    if not file_fields[3] in Company:
        Company[file_fields[3]]=defaultdict(int)
    Company[file_fields[3]]["Total"]+=1
    Company[file_fields[3]][file_fields[12]]+=1
#        Company[file_fields[3]][0]=1
#        Company[file_fields[3]][1]=0

#    Company[file_fields[3]]+=1
    Country[file_fields[10]]+=1
    Role[file_fields[12]]+=1
    for i in range(16,27) :
        if file_fields [i] :
            Session[i-16]+=1
    if file_fields[28] == "Yes" :
        Software_Request +=1


print '<table border="1" width="600px">'
print "<caption><h2>Attendee Type information</h2></caption>"
print "<tr><th>Attendee</th><th>Total</th></tr>"

Keys = list(Attendee_Type.keys())
Keys.sort();
for Type in Keys:
    print "<tr><td>"+Type+"<td>" + str(Attendee_Type[Type]) + "</td>"
    print "</tr>"
print "</table>"
print "<p/>"


print "<hr/>"
print "<p/>"
print '<table border="1" width="600px">'
print "<caption><h2>Role information</h2></caption>"
print "<tr><th>Role</th><th>Total</th><th>% Boot Camp</th><th>% All</th></tr>"


Keys = list(Role.keys())
Keys.sort();

Total_Attendees=Role["Sales"]+Role["Software"]+Role["Technical"]
All_Attendees=Role["Sales"]+Role["Software"]+Role["Technical"]+Role["Management"]

for Type in Keys:
    if Type :
        print "<tr><td>"+Type+"</td>"
        print "<td>" + str(Role[Type]) + "</td>"
        if Type == "Management" :
            print "<td>N/A</td>"
        else :
            print "<td>" + str(Role[Type]*100/Total_Attendees) + "</td>"
        print "<td>" + str(Role[Type]*100/All_Attendees) + "</td>"

        print "</tr>"
print "</table>"

Total_Attendees=Role["Sales"]+Role["Software"]+Role["Technical"]
print "<br/>"
print "Total Bootcamp Attendees: " + str(Total_Attendees);
print "<p/>"



print "<hr/>"
print "<p/>"
print '<table border="1" width="600px">'
print "<caption><h2>Session information</h2></caption>"
print "<tr><th>Session</th><th>Total</th><th>% attending</th><th>Expected Total #<br>250 attendees</th></tr>"

for i in range(0,11) :
    print "<tr><td>"+Session_names[i]+"</td>"
    print "<td>" + str(Session[i]) + "</td>"
    print "<td>" + str(Session[i]*100/Total_Attendees) + "</td>"
    print "<td>" + str(250 * Session[i]/Total_Attendees) + "</td>"
    print "</tr>"
print "<tr><td>SOFTWARE IN DEPTH</td>"
print "<td>" + str(Role["Software"]) + "</td>"
print "<td>" + str(Role["Software"]*100/Total_Attendees) + "</td>"
print "<td>" + str(250 * Role["Software"]/Total_Attendees) + "</td>"
print "</tr>"

print "<tr><td>SOFTWARE IN DEPTH<br> With Requests</td>"
print "<td>" + str(Role["Software"]+Software_Request) + "</td>"
print "<td>" + str((Role["Software"]+Software_Request)*100/Total_Attendees) + "</td>"
print "<td>" + str(250 * (Role["Software"]+Software_Request)/Total_Attendees) + "</td>"
print "</tr>"
Software_Request
print "</table>"
print "<p/>"
print "<hr/>"
print "<p/>"
print '<table border="1" width="600px">'
print "<caption><h2>Company information</h2></caption>"
print "<tr><th>Company</th><th>Total</th><th>Management</th><th>Sales</th><th>Software</th><th>Techincal</th></tr>"

Keys = list(Company.keys())
Keys.sort();
Total_Companys=0

for Type in Keys:
    if (Type != "Trimble") and (Type != "CTCT")  :
       print "<tr><td>"+Type + "</td>"
       print "<td>" + str(Company[Type]["Total"]) + "</td>"
       print "<td>" + str(Company[Type]["Management"]) + "</td>"
       print "<td>" + str(Company[Type]["Sales"]) + "</td>"
       print "<td>" + str(Company[Type]["Software"]) + "</td>"
       print "<td>" + str(Company[Type]["Technical"]) + "</td>"
       print "</tr>"
       Total_Companys+=1

print "<tr><td></td>"
print "<td>" + str(Role["Management"]+Total_Attendees) + "</td>"
print "<td>" + str(Role["Management"]) + "</td>"
print "<td>" + str(Role["Sales"]) + "</td>"
print "<td>" + str(Role["Software"]) + "</td>"
print "<td>" + str(Role["Technical"]) + "</td>"
print "</tr>"

print "</table>"

print "<br/>"
print "Total Companies: " + str(Total_Companys);
print "<p/>"

print "<hr/>"
print "<p/>"
print '<table border="1" width="600px">'
print "<caption><h2>Country information</h2></caption>"
print "<tr><th>Country</th><th>Total</th></tr>"


Keys = list(Country.keys())
Keys.sort();
Total_Countrys=0

for Type in Keys:
    print "<tr><td>"+Type+"<td>" + str(Country[Type]) + "</td>"
    print "</tr>"
    Total_Countrys+=1
print "</table>"

print "<br/>"
print "Total Countries: " + str(Total_Countrys);
print "<p/>"


print "</body></html>"
