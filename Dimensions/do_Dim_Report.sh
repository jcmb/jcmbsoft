#!/bin/bash
rm registrants.csv
wget http://USER:PASSWD@trbc-re.com/bootcamp2012/registrants.csv &>/dev/null
if [ -s registrants.csv ]
then
  ./Dimensions_Report.py <registrants.csv >Dimensions_Reg.html
fi
