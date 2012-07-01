#!/bin/bash 
shopt -s failglob

ROBBIE_CONF=/etc/Robbie.d

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

if [ ! -d /var/Robbie ]
then
   mkdir /var/Robbie
fi

cd /tmp/Robbie

rm Robbie.table &>/dev/null
now=`date +%s`
let now=now-300
#let now=now-3000
#let now=now+30000
#echo $now

for f in $ROBBIE_CONF/*.interval
do
#   echo $f
   filename=`basename $f .interval`
   if [ ! -s $filename.time ]
   then
      echo -n "<tr><td>$filename</td><td></td><td>No Files since last restart</td></tr>" >>Robbie.table
      logger "Error: No time file for $filename"
   else
      last_update=`cat $filename.time`
      updatetime=`cat $f`
      let expected_update=now-updatetime
      echo $expected_update
      echo -n "<tr><td>$filename</td><td> " `date -j -f%s $last_update` " </td><td>" >>Robbie.table
      if [ $last_update -lt $expected_update ]
      then
         if [ -e /var/Robbie/$filename.not_working ]
         then
            echo "Not Working" >>Robbie.table
         else
            rm /var/Robbie/$filename.working &>/dev/null
            echo $last_update >/var/Robbie/$filename.not_working
            echo -n "<b>Not Working</b>">>Robbie.table
            mail -s "$filename Not Working" Geoffrey_Kirk@Trimble.com </dev/null &>/dev/null
         fi
      else
         if [ -e /var/Robbie/$filename.working ]
         then
            echo "Working" >>Robbie.table
         else
            rm /var/Robbie/$filename.not_working &>/dev/null
            echo $last_update >/var/Robbie/$filename.working
            echo -n "<b>Working</b>" >>Robbie.table
            mail -s "$filename Now Working" Geoffrey_Kirk@Trimble.com </dev/null &>/dev/null
         fi
      fi
   echo "</td></tr>" >>Robbie.table
   fi
done


for f in *.time
do
#   echo $f
   filename=`basename $f .time`
   if [ ! -s $ROBBIE_CONF/$filename.interval ]
   then
      echo -n "<tr><td>$filename</td><td></td><td>No Interval Files</td></tr>" >>Robbie.table
      logger "Internal Error: No intervale file for $filename"
   fi
done

echo "<html><head><title>Robbie the Robot Status</title></head><body><table border="1">" >/Library/WebServer/Documents/Robbie/index.html
echo "Last Status Update:" `date`  "<p>" >>/Library/WebServer/Documents/Robbie/index.html
echo "<tr><th>Base</th><th>Last Update</th><th>Status</th></tr>" >>/Library/WebServer/Documents/Robbie/index.html
sort Robbie.table >> /Library/WebServer/Documents/Robbie/index.html
echo "</table></html>" >>/Library/WebServer/Documents/Robbie/index.html

rm /tmp/Robbie.Run &>/dev/null
