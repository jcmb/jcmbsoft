#!/bin/bash -x
#rm lftp.$1.txt
cd ~/data/GNSS
wget  -O $1.txt http://$1/download/Internal
~/DropBox/Develop/T02_From_Web_Page $1 $1.txt >$1.wget
wget -nc -i $1.wget
