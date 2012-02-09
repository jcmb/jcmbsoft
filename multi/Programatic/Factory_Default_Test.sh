#!/bin/bash
RESULTS_DIR=~/Results/
TRUTH_DIR=~/Truth/
PATH=.:$PATH$
export RESULTS_DIR
if [ -z $3 ]
then
   echo "Usage: Factory_Default_Test.sh Host_IP truth Test_ID";
   exit 1
fi


command -v Reset.sh &>/dev/null || {  echo  "Unknown - I require Reset.sh but it's not installed.  Aborting."; exit 3; }
command -v Programmatic_Test.sh &>/dev/null || {  echo  "Unknown - I require Programmatic_Test.sh but it's not installed.  Aborting."; exit 3; }
command -v curl &>/dev/null || {  echo  "Unknown - I require curl but it's not installed.  Aborting."; exit 3; }

HOST=$1
#mkdir -p $RESULTS_DIR$3
Reset.sh $HOST factory
Programmatic_Test.sh $HOST $3
for F in Antennas commands general GPS_Health
do
   echo $F
   diff $TRUTH_DIR/$F $RESULTS_DIR/$3/$F
done