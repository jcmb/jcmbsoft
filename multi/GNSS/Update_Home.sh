#!/bin/bash

Dir=`dirname $0`;
pushd . &>/dev/null
normalDir=`cd "${Dir}";pwd`
PATH=${normalDir}:$PATH
export PATH

if [ -z $1 ] ;
then
   echo Update_Home User Password [Wamel_Firmware [Gamel_Firmware]]
   echo ""
   echo "Upgrades all the receivers at home, if the firmware is given. List firmware otherwise."
   exit 1;
fi

command -v upgrade_with_clone.sh &>/dev/null || {  echo  "Unknown - I require upgrade_with_clone.sh but it's not installed.  Aborting."; exit 3; }

if [ -z $3 ] ;
then
   echo "Current Firmware: "
   #28000
   upgrade_with_clone.sh  -i 192.168.253.46 -n -p $1:$2 -c Home-46
   # 28005
   upgrade_with_clone.sh  -i 192.168.253.47 -n -p $1:$2 -c Home-47
   # 2100
   #upgrade_with_clone.sh  -i 192.168.253.48 -n -p $1:$2 -c Home-48
   # 28010
   upgrade_with_clone.sh  -i 192.168.253.49 -n -p $1:$2 -c Home-49
   exit
fi

upgrade_with_clone.sh  -i 192.168.253.46 -c Home-46 -p $1:$2 -f $3
upgrade_with_clone.sh  -i 192.168.253.47 -c Home-47 -p $1:$2 -f $3
#upgrade_with_clone.sh  -i 192.168.253.48 -c Home-48 -p $1:$2 -f $3
upgrade_with_clone.sh  -i 192.168.253.49 -c Home-49 -p $1:$2 -f $3

