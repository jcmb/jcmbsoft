#! /bin/bash

Dir=`dirname $0`;
pushd . &>/dev/null
normalDir=`cd "${Dir}";pwd`
PATH=${normalDir}:$PATH
export PATH

if [ -z $1 ] ;
then
   echo "Update_Claudes User Password [Gamel_Firmware]"
   echo ""
   echo "Upgrades all the receivers at claudes, if the firmware is given. List firmware otherwise."
   exit 1;
fi

command -v upgrade_with_clone.sh &>/dev/null || {  echo  "${0##*/} Unknown - I require upgrade_with_clone.sh but it's not installed.  Aborting."; exit 3; }

if [ -z $3 ] ;
then
   echo "Current Firmware: "
   # Base
   upgrade_with_clone.sh -z  -i claudes.dyndns.info -n -p $1:$2 -c Claude
   exit
fi

upgrade_with_clone.sh -z  -i claudes.dyndns.info -p $1:$2 -c Claude -f $3


