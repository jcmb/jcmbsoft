#! /bin/bash
http_proxy=wpad.am.trimblecorp.net:3128
export http_proxy
version=`curl -m 3 --retry 2 -s http://$3$2/prog/show?firmwareVersion |./SPS_Dashboard_Version.pl`
antenna=`curl -m 3 --retry 2 -s http://$3$2/prog/show?antenna | ./SPS_Dashboard_Antenna.pl`
motion=`curl -m 3 --retry 2 -s http://$3$2/prog/show?rtkControls |./SPS_Dashboard_Motion.pl`
elev=`curl -m 3 --retry 2 -s http://$3$2/prog/show?elevationMask|./SPS_Dashboard_Elev.pl`
PDOP=`curl -m 3 --retry 2 -s http://$3$2/prog/show?pdopMask |./SPS_Dashboard_PDOP.pl`
clock=`curl -m 3 --retry 2 -s http://$3$2/prog/show?clockSteering |./SPS_Dashboard_Clock.pl`
serial=`curl -m 3 --retry 2 -s http://$3$2/prog/show?SerialNumber | ./SPS_Dashboard_Serial.pl`
type=`curl -m 3 --retry 2 -s http://$3$2/prog/show?SerialNumber | ./SPS_Dashboard_Type.pl`
temp=`curl -m 3 --retry 2 -s http://$3$2/prog/show?temperature |./SPS_Dashboard_Temp.pl`
pos=`curl -m 3 --retry 2 -s http://$3$2/prog/show?position |./SPS_Dashboard_Position.pl`
logging=`curl -m 3 --retry 2 -s http://$3$2/prog/show?sessions |./SPS_Dashboard_Logging.pl`
warranty=`curl -m 3 --retry 2 -s http://$3$2/prog/show?firmwareWarranty |./SPS_Dashboard_Warranty.pl`
name=`curl -m 3 --retry 2 -s http://$3$2/prog/show?SystemName |./SPS_Dashboard_Name.pl`
uptime=`./SPS_Dashboard_Uptime.pl -h $3$2`
power=`./SPS_Dashboard_Power.pl -h $3$2`
FTP=`./SPS_Dashboard_FTP.pl -h $3$2`
email=`./SPS_Dashboard_Email.pl -h $3$2`
#set
echo "<tr><td>$1</td><td>$name</td><td><a target=\"_window\" href=\"http://$2\">$2</a></td><td>$type</td><td>$serial</td><td>$version</td><td>$motion</td><td>$elev</td><td>$PDOP</td><td>$clock</td><td>$temp</td><td>$power</td><td>$uptime</td><td>$logging</td><td>$FTP</td><td>$email</td><td>$pos</td><td>$antenna</td><td>$warranty</td></tr>"
