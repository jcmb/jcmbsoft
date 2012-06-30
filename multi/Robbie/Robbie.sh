#!/bin/bash

ROBBIE_CONF=/etc/Robbie.d/

if [ -e /tmp/Robbie.Run ]
then
   logger "Robbie.sh not run as it is already running, delete /tmp/Robbie.Run if it is not"
   echo "Robbie.sh not run as it is already running, delete /tmp/Robbie.Run if it is not"
   exit 2
else
   touch /tmp/Robbie.Run
fi

if [ ! -d /tmp/Robbie ]
then
   mkdir /tmp/Robbie
fi

cd /tmp/Robbie

rm Robbie.table &>/dev/null
now=`date +%s`
let now=now-300
#let now=now-3000
#let now=now+30000
#echo $now
for f in "*.time"
do
#   echo $f
   filename=`basename $f .time`
   if [ ! -s $ROBBIE_CONF$filename.interval ]
   then
      echo -n "<tr><td>$filename</td><td></td><td>No Interval File</td></tr>" >>Robbie.table
      logger "Internal Error: No interval file for $filename"
      echo "Internal Error: No interval file for $filename"
   else
      last_update=`cat $filename.time`
      let expected_update=now-updatetime
      echo -n "<tr><td>$filename</td><td> " `date -j -f%s $last_update` " </td><td>" >>Robbie.table
    #  echo $expected_update
      if [ $last_update -lt $expected_update ]
      then
         if [ -e $filename.not_working ]
         then
            echo "Not Working" >>Robbie.table
         else
            rm $filename.working &>/dev/null
            echo $last_update >$filename.not_working
            echo -n "<b>Not Working</b>">>Robbie.table
         fi
      else
         if [ -e $filename.working ]
         then
            echo "Working" >>Robbie.table
         else
            rm $filename.not_working &>/dev/null
            echo $last_update >$filename.working
            echo -n "<b>Working</b>" >>Robbie.table
         fi
      fi
   echo "</td></tr>" >>Robbie.table
   fi
done

echo "<html><head><title>Robbie the Robot Status</title></head><body><table border="1">" >/Library/WebServer/Documents/Robbie/index.html
echo "Last Status Update:" `date`  "<p>" >>/Library/WebServer/Documents/Robbie/index.html
echo "<tr><th>Base</th><th>Last Update</th><th>Status</th></tr>" >>/Library/WebServer/Documents/Robbie/index.html
sort Robbie.table >> /Library/WebServer/Documents/Robbie/index.html
echo "</table></html>" >>/Library/WebServer/Documents/Robbie/index.html

rm /tmp/Robbie.Run &>/dev/null
