#! /bin/bash
export http_proxy=http://wpad.am.trimblecorp.net:3128
echo -e "Content-type: text/html\r\n\r\n"

command -v Caster_Logs_html.py &>/dev/null || {  echo  "${0##*/} Unknown - I require Caster_Logs_html.py but it's not installed.  Aborting."; exit 3; }

DATE=`date -u "+%Y-%m-%d-%H"`

curl  -u admin.tcc:PASSWD_here http://ibss.ibss.trimbleos.com:8088/getauditlog?datetime=$DATE | Caster_Logs_html.py
