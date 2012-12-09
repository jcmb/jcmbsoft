#! /bin/bash

Dir=`dirname $0`;
pushd . &>/dev/null
normalDir=`cd "${Dir}";pwd`
PATH=${normalDir}:$PATH
export PATH

if [ -z $1 ] ;
then
   echo Update_Lab User Password [Wamel_Firmware [Gamel_Firmware]]
   echo ""
   echo "Upgrades all the receivers in the lab, if the firmware is given. List firmware otherwise."
   exit 1;
fi

if ! type upgrade_with_clone.sh &> /dev/null ; then
   echo "${0##*/} Required upgrade_with_clone.sh not found in $PATH" >&2
   exit 2
fi



if [ -z $3 ] ;
then
   upgrade_with_clone.sh  -i sps855.info -n
   upgrade_with_clone.sh  -i sps852.info:81 -n
#   upgrade_with_clone.sh  -i sps852.info:83 -n
   exit
fi

upgrade_with_clone.sh -i sps855.info -c Lab-1 -f $3 -p $1:$2
upgrade_with_clone.sh -i sps852.info:81 -c Lab-1 -f $3 -p $1:$2
#upgrade_with_clone.sh -i sps852.info:83 -c Lab-2 -f $3 -p $1:$2

