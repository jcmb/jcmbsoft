#! /bin/bash

while [ 1 ] 
do
    curl http://192.168.253.46/prog/set?elevationMask\&mask=90
    curl http://192.168.253.47/prog/set?elevationMask\&mask=90
    sleep 5
    curl http://192.168.253.46/prog/set?elevationMask\&mask=10
    curl http://192.168.253.47/prog/set?elevationMask\&mask=10
    sleep 60
done

