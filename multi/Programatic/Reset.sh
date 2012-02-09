#!/bin/bash
if [ -z $2 ]
then
   echo "Usage: Reset_Reciever.sh Host_IP level Dont_Wait";
   echo ""
   echo "Where level is reboot default gnss appfiles factory"
   echo "Dont_Wait, if present means that the script will not wait for the receiver to restart"
   exit 1
fi

command -v curl &>/dev/null || {  echo  "Unknown - I require curl but it's not installed.  Aborting."; exit 3; }

HOST=$1

echo "Resetting: $HOST to $2"

case "$2" in
   reboot)
      curl --silent "http://$HOST/prog/reset?System" >/dev/null
      if [ -z $3 ]
         then
         sleep 30
         fi
      ;;
   default)
      curl --silent "http://$HOST/cgi-bin/resetPage.xml?doFactoryDefaults=1"  >/dev/null
      if [ -z $3 ]
         then
         sleep 5
         fi
      ;;
   gnss)
      curl --silent "http://$HOST/prog/reset?GnssData"  >/dev/null
      if [ -z $3 ]
         then
         sleep 30
         fi
      ;;
   appfiles)
      curl --silent "http://$HOST/cgi-bin/resetPage.xml?doClearAppfile=1"  >/dev/null
      if [ -z $3 ]
         then
         sleep 30
         fi      ;;
   factory)
      curl --silent "http://$HOST/cgi-bin/resetPage.xml?doClearEverything=1"  >/dev/null
      if [ -z $3 ]
         then
         sleep 60
         fi
      ;;
esac

exit 0
