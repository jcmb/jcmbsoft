#!/bin/bash

if [ -z $2 ] ;
then
   echo "${0##*/} IP_Address Client "
   echo ""
   echo "Where Client is the NTRIP Client number 1-3, note all settings for the NTRIP Client are lost"
   exit 10
fi

PORT=$(($2 + 29))

echo "Turning off NTRIP Client $1"

curl --silent -f http://$1/cgi-bin/io.xml?port=$PORT\&portType=NTripClient >/dev/null || {  echo  "Could not set NTRIP off on $1"; exit 11; }
