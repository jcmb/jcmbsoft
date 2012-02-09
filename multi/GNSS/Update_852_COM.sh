#! /bin/bash

Dir=`dirname $0`;
pushd . &>/dev/null
normalDir=`cd "${Dir}";pwd`
PATH=${normalDir}:$PATH
export PATH

if [ -z $1 ] ;
then
   echo Update_852_Info User Password [Wamel_Firmware [Gamel_Firmware]]
   echo ""
   echo "Upgrades all the receivers at home, if the firmware is given. List firmware otherwise."
   exit 1;
fi

command -v upgrade_with_clone.sh &>/dev/null || {  echo  "Unknown - I require upgrade_with_clone.sh but it's not installed.  Aborting."; exit 3; }

if [ -z $3 ] ;
then
   echo "Current Firmware: "
   # Base
   upgrade_with_clone.sh  -i sps852.com -n -p $1:$2 -c 852_COM
   exit
fi

upgrade_with_clone.sh  -i sps852.com -p $1:$2 -c 852_COM -f $3


