#!/bin/bash
if [ -z $2 ]
then
   echo "Usage: Set_Test_Mode.sh Host_IP state";
   exit 1
fi

command -v curl &>/dev/null || {  echo  "Unknown - I require curl but it's not installed.  Aborting."; exit 3; }

HOST=$1
ENABLE=$2

if [ $ENABLE == no ]
then
   curl "http://$HOST/prog/set?testmode&enable=no"
else
   curl "http://$HOST/prog/set?testmode&enable=yes&password="`cat TM_PASSWORD`
fi
