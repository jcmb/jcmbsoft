#!/bin/bash
#download_SPS_FTP.sh

if [ -z $1 ]
then
   echo "Usage: Download_SPS_FTP.sh "
   exit;
fi
hash lftp 2>&- || { echo >&2 "I require lftp but it's not installed.  Aborting."; exit 1; }

mkdir ~/Data/GNSS/$1

lftp << EOF
open -u anonymous,Geoffrey_Kirk@Trimble.com $1
lcd ~/Data/GNSS/$1
cd /Internal
mget *.T02
EOF
