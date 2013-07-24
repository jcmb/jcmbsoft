#!/bin/bash

if [ -z $4 ] ;
then
   echo "${0##*/} IP_Address <Meas Rate> <Pos Rate> Duration user:pass@"
   echo ""
   echo "Where IP_Address is the address of the GNSS, with user:pass@ if required"
   echo "user:pass@ is the user name password, with a @, admin:password@ for example"
   echo ""
   echo "Rate: Logging rate in ms, 1000 for 1 second, 200 for 5Hz"
   echo ""
   echo "Duration: In Minutes for the file roll over, 60 normally"
   exit 10
fi

echo "Turning on Data Logging  $1"

curl --silent  -f http://$5$1/xml/dynamic/dataLogger.xml?Name=DEFAULT\&Enabled=on\&Schedule=Continuous\&Duration=$4\&FileType=T02\&MeasInterval=$2\&PosInterval=$3\&logCorrections=on\&FileSystem=Internal\&PathStyle=Flat\&NameStyle=IGSH\&ftpPushCheckBox=on\&ftpPushConversionType=0  > /dev/null|| {  echo  "Could not enable Data Logging on $1"; exit 11; }
