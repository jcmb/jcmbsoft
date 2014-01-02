#!/bin/bash 
#source ./configuration
#echo "Hello" > /tmp/ibss_data.$$
#echo "There" >> /tmp/ibss_data.$$
#echo "ibss_data_check Called with">> /tmp/ibss_data.$$
#echo "$1">> /tmp/ibss_data.$$ 
#echo "$2">> /tmp/ibss_data.$$ 
#echo "$3">> /tmp/ibss_data.$$ 
#echo "$4">> /tmp/ibss_data.$$ 
#echo "$5">> /tmp/ibss_data.$$ 
#echo "$6">> /tmp/ibss_data.$$ 
#echo "$7">> /tmp/ibss_data.$$ 
#echo "OK - Test";
#exit 1

if [ -z $7 ] 
then
    echo "Unknown - Usage: Test_Time server port USER PASS BASE FORMAT"
    exit 3
fi

command -v DCOL_count &>/dev/null || {  echo  "Unknown - I require DCOL_count but it's not installed.  Aborting."; exit 3; }


TEST_TIME=$1
TEST_OK=`expr $TEST_TIME \* 9 / 10`
TEST_WARN=`expr $TEST_TIME \* 7 / 10`
#echo $TEST_OK
#echo $TEST_WARN

SERVER=$2
PORT=$3
USER=$4
PASS=$5
BASE=$6
FORMAT=$7
NTRIP_SERVER=$SERVER:$PORT


BEFORE="$(date +%s)"
curl --silent -f -o /tmp/ntrip_$$.bin --connect-timeout 10 -m $TEST_TIME  -H "Ntrip-Version: Ntrip/1.0" -H "User-Agent: NTRIP CURL_NTRIP_TEST/0.1" -u $USER:$PASS  http://$NTRIP_SERVER/$BASE 
Result=$?
AFTER="$(date +%s)"
elapsed_seconds="$(expr $AFTER - $BEFORE)"

filename=/tmp/ntrip_$$.bin
st_size=$(stat -c%s /tmp/ntrip_$$.bin)

#echo $Result,$st_size, $(expr $AFTER - $BEFORE),$CONNECTIONS >>ntrip_results.txt
RECORDS=$(DCOL_count -i /tmp/ntrip_$$.bin --$FORMAT)
#echo $RECORDS

text="Received $RECORDS in format $FORMAT during test of $TEST_TIME ($Result:$st_size::$$)"
if [ $RECORDS -ge  $TEST_OK ] 
then
   text="OK - $text"
   rc=0
   if [ $FORMAT = "CMR" ]
   then
   BASE_RECORDS=$(DCOL_count -i /tmp/ibss_$$.bin --CMRb)
   if [ $BASE_RECORDS -eq 0 ]
      then
      text="ERROR - Base is not sending base informatio records"
      rc=2
      fi
   fi
else
   if [ $RECORDS -ge $TEST_WARN ] 
   then
      text="WARNING - $text"
      rc=1
   else
      text="ERROR - $text"
      rc=2
   fi
fi
echo $text
rm /tmp/ntrip_$$.bin
exit $rc
