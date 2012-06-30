#!/bin/bash
# Robbie Folder Action in SH form. Changed file is passed as a parameter
if [ ! -d /tmp/Robbie ]
then
   mkdir /tmp/Robbie
fi

for f in "$@"
do
#	echo "$f" >>~/Desktop/folder_action.txt
	file=`basename "$f"`
	dir=`dirname "$f"`
	dir=`basename "$dir"`
#	echo "<tr><td>" $file "</td><td>" `date` "<td></tr>">~/Desktop/$dir.row.html
	echo `date +%s` >/tmp/Robbie/$dir.time
done
Robbie.sh
