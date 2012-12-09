#!/bin/bash

if [ -z $7 ] ;
then
   echo "${0##*/} IP_Address Client Caster Port user password mountpoint"
   echo ""
   echo "Where Client is the NTRIP Client number 1-3, note all parameters need to be value for a url"
   exit 10
fi

PORT=$(($2 + 29))

echo "Turning on NTRIP Client $1"

curl --silent  -f http://$1/cgi-bin/io.xml?port=$PORT\&portType=NTripClient\&ntripEnable=1\&casterAddr=$3%3A$4\&username=$5\&password=$6\&password2=$6\&mountPoint=$7 > /dev/null|| {  echo  "Could not enable NTRIP on $1"; exit 11; }
