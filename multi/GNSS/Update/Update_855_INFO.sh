#! /bin/bash

Dir=`dirname $0`;
pushd . &>/dev/null
normalDir=`cd "${Dir}";pwd`
PATH=${normalDir}:$PATH
export PATH

if [ -z $1 ] ;
then
   echo "Update_855_Info User Password [Wamel_Firmware [Gamel_Firmware]]"
   echo ""
   echo "Upgrades all the receivers at home, if the firmware is given. List firmware otherwise."
   exit 1;
fi

command -v upgrade_with_clone.sh &>/dev/null || {  echo  "${0##*/} Unknown - I require upgrade_with_clone.sh but it's not installed.  Aborting."; exit 3; }

if [ -z $3 ] ;
then
   echo "Current Firmware: "
   # Base
   upgrade_with_clone.sh  -i sps855.info:81 -n -p $1:$2 -c 855BASE -z
   # Rover
   upgrade_with_clone.sh  -i sps852.info -n -p $1:$2 -c 855ROVE -z
   exit
fi

upgrade_with_clone.sh  -i sps855.info:81 -p $1:$2 -c 855BASE -f $3 -z
upgrade_with_clone.sh  -i sps852.info -p $1:$2 -c 855ROVE -f $3 -z


