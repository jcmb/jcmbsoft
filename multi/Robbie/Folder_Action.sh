#!/bin/bash
# Robbie Folder Action in SH form. Changed file is passed as a parameter
if [ ! -d /tmp/Robbie ]
then
   mkdir /tmp/Robbie
fi

logger "Robbie Folder Action Started: $@"
for f in "$@"
do
#	echo "$f" >>~/Desktop/folder_action.txt
	file=`basename "$f"`
	dir=`dirname "$f"`
	dir=`basename "$dir"`
#	echo "<tr><td>" $file "</td><td>" `date` "<td></tr>">~/Desktop/$dir.row.html
	echo `date +%s` >/tmp/Robbie/$dir.time
    logger created /tmp/Robbie/$dir.time
done
#logger "Robbie Folder Action Calling Robbie"
Robbie.sh
logger "Robbie Folder Action $@ Finished"
