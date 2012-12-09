#!/bin/bash

export http_proxy=http://wpad.am.trimblecorp.net:3128
echo -e "Content-type: text/html\r\n\r\n"

curl --silent http://update.SERVER.com/logs/access.log | /usr/lib/cgi-bin/SNM940_Logs_html.py
