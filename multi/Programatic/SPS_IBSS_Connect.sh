#! /bin/bash -x
# SPS_IBSS_Connect
#
# Monitors the IBSS Server using a real receiver.
#


PATH=.:$PATH
if [ -z $8 ]
then
    echo "Unknown - Usage: SPS_IBSS_Connect server port recv_USER recv_PASS ibss_device ibss_org ibss_password   ibss_mount"
    exit 3
fi

command -v SPS_Monitor.pl &>/dev/null || {  echo  "Unknown - I require SPS_Monitor.pl but it's not installed.  Aborting."; exit 3; }


HOST=$1:$2
SPS_USER=$3:$4
USER=$5
ORG=$6
PASS=$7
BASE=$8

# Disable IBSS
#http://sps852.info:83/cgi-bin/io.xml?port=30&portType=NTripClient&useMices=on&casterAddr=trimblehh&micesOrg=trimblehh&fakePassword=1&password=%C2%8D%C2%8D%C2%8D%C2%8D%C2%8D%C2%8D&password2=%C2%8D%C2%8D%C2%8D%C2%8D%C2%8D%C2%8D&mountPoint=WESTMINSTER-%28ibss%29
# url -vv -x proxy.am.trimblecor admin:jcmsps850 http://sps852.info:83/cgi-bin/io.xml?port=30\&portType=NTripClient\&useMices=on\&casterAddr=trimblehh\&micesOrg=trimblehh\&fakePassword=1\&password=%C2%8D%C2%8D%C2%8D%C2%8D%C2%8D%C2%8D\&password2=%C2%8D%C2%8D%C2%8D%C2%8D%C2%8D%C2%8D\&mountPoint=WESTMINSTER-%28ibss%29
#enable
#http://sps852.info:83/cgi-bin/io.xml?port=30&portType=NTripClient&ntripEnable=1&useMices=on&casterAddr=trimblehh&micesOrg=trimblehh&fakePassword=1&password=%C2%8D%C2%8D%C2%8D%C2%8D%C2%8D%C2%8D&password2=%C2%8D%C2%8D%C2%8D%C2%8D%C2%8D%C2%8D&mountPoint=WESTMINSTER-%28ibss%29

#http_proxy=http://proxy.am.trimblecorp.net:3128
#export http_proxy
curl -u $SPS_USER http://$HOST/cgi-bin/io.xml?port=30\&ntripEnable
#ntripEnable=0 does not work, ntripEnable without parameters turns it off

#Work around the V4.4x bug of RTK going for 20 seconds without radio
sleep 30


SPS_Monitor.pl -v -H $HOST -U $SPS_USER -P RTK

if [ $? == 0 ]
then
   text="ERROR - Receiver stayed in RTK operation"
   rc=1
   echo $text
   exit $rc
fi

#http://sps852.info:83/cgi-bin/io.xml?port=30&portType=NTripClient&ntripEnable=1&useMices=on&casterAddr=trimblehh&micesOrg=trimblehh&fakePassword=0&password=trimble&password2=trimble&mountPoint=WESTMINSTER-%28ibss%29

curl -u $SPS_USER http://$HOST/cgi-bin/io.xml?port=30\&portType=NTripClient\&ntripEnable=1\&useMices=on\&casterAddr=$ORG\&micesOrg=$ORG\&fakePassword=0\&password=$PASS\&password2=$PASS\&mountPoint=$BASE

sleep 30

SPS_Monitor.pl -v -H $HOST -U $SPS_USER -P RTK

if [ $? == 0 ]
then
   text="OK - Receiver reconnected and is woking in RTK"
   rc=0
   echo $text
   exit $rc
else
   text="ERROR - Receiver is not doing RTK"
   rc=1
   echo $text
   exit $rc
fi

