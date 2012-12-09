#!/bin/bash
path=/opt/local/bin:$path
logger get_alm.sh started
http_proxy="http://wpad.am.trimblecorp.net:3128"
export http_proxy
https_proxy="http://wpad.am.trimblecorp.net:3128"
export https_proxy
cd /tmp
rm almanac.alm 2> /dev/null
wget -q http://www.sps855.com/xml/dynamic/almanac.alm 
mv almanac.alm /Volumes/GPS_MYSQL/Almanacs/`date +%F`.alm 2>/dev/null
if [ -s /Volumes/GPS_MYSQL/Almanacs/`date +%F`.alm ]
then
   logger "get_alm.sh created `date +%F`.alm"
   mail -s "Get_Alm.sh working" Geoffrey_Kirk@Trimble.com </dev/null >/dev/null
else
   logger "Error: get_alm.sh not not create `date +%F`.alm"
   mail -s "Get_Alm.sh failed to create file" Geoffrey_Kirk@Trimble.com </dev/null >/dev/null
fi
exit 0
