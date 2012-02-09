#!/bin/bash

if [ "$2" == "" ];
then 
   echo
   echo "rdatname.sh <file Name> <Prefix for File>"
   echo 
   echo "JCMBSoft V1.00. GPL V3.0"
   exit 100;
fi

echo "Creating X29 file in /tmp"
TEMPFILE="/tmp/$$.X29"
viewdat -d29 -x $1 >$TEMPFILE
echo "Renaming file"
rdatname.pl $1 $2 <$TEMPFILE
rm $TEMPFILE
