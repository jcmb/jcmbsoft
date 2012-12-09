#! /bin/bash
source ./pos_cycle.cfg
host=$1
echo "Position Cycling $host"
while [ 1 ]
do
   echo "Disabling SV tracking for $off seconds"
   curl "http://$host/prog/set?elevationMask&mask=90"
   sleep $off
   echo "Enabling SV tracking with an elevation mask of $mask for $on seconds"
   curl "http://$host/prog/set?elevationMask&mask=$mask"
   sleep $on
done