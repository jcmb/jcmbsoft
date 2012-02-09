#! /bin/bash

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
   #Base 900
   upgrade_with_clone.sh  -i site.co-test-site.com:2105 -n -p $1:$2 -c TS_B_9
   #Base 450
#   upgrade_with_clone.sh  -i site.co-test-site.com:2105 -n -p $1:$2 -c TS_B_4
   #Rover 1
   upgrade_with_clone.sh  -i site.co-test-site.com:28001 -n -p $1:$2 -c TS_R_1
   #Rover 2
   upgrade_with_clone.sh  -i site.co-test-site.com:28002 -n -p $1:$2 -c TS_R_2
   #Rover 3
   upgrade_with_clone.sh  -i site.co-test-site.com:28003 -n -p $1:$2 -c TS_R_3
   exit
fi

#Base 900
upgrade_with_clone.sh  -i site.co-test-site.com:2105 -p $1:$2 -c TS_B_9 -f $3
#Base 450
#upgrade_with_clone.sh  -i site.co-test-site.com:2105 -p $1:$2 -c TS_B_4 -f $4
#Rover 1
upgrade_with_clone.sh  -i site.co-test-site.com:28001 -p $1:$2 -c TS_R_1 -f $3
#Rover
upgrade_with_clone.sh  -i site.co-test-site.com:28002 -p $1:$2 -c TS_R_2 -f $4
#Rover 3
upgrade_with_clone.sh  -i site.co-test-site.com:28003 -p $1:$2 -c TS_R_3 -f $3
