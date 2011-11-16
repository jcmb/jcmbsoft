#! /bin/bash
echo Starting NTRIP Connection $1
source ./configuration
rm $TMP_DATA_PATH/ntrip_$1.bin &> /dev/null
BEFORE="$(date +%s)"
CONNECTIONS=0
AFTER="$(date +%s)"
elapsed_seconds="$(expr $AFTER - $BEFORE)"
while [ $elapsed_seconds -lt $TEST_TIME ]
do
echo    curl -f -o $TMP_DATA_PATH/ntrip_$1.bin --connect-timeout 10 -m $TEST_TIME  -H "Ntrip-Version: Ntrip/2.0" -H "User-Agent: NTRIP CURL_NTRIP_TEST/0.1" -u $USER$2.$ORG:$PASS$2  http://$BASE_ORG.$IBSS_SERVER:2101/$BASE &>/dev/null
    curl -f -o $TMP_DATA_PATH/ntrip_$1.bin --connect-timeout 10 -m $TEST_TIME  -H "Ntrip-Version: Ntrip/2.0" -H "User-Agent: NTRIP CURL_NTRIP_TEST/0.1" -u $USER$2.$ORG:$PASS$2  http://$BASE_ORG.$IBSS_SERVER:2101/$BASE &>/dev/null
    Result=$?
    CONNECTIONS=$(expr $CONNECTIONS + 1)
    AFTER="$(date +%s)"
    elapsed_seconds="$(expr $AFTER - $BEFORE)"
done

filename=$TMP_DATA_PATH/ntrip_$1.bin
st_size=$(stat -c%s $TMP_DATA_PATH"/ntrip_"$1".bin")

echo $1,$Result,$st_size, $(expr $AFTER - $BEFORE),$CONNECTIONS >>ntrip_results.txt
echo NTRIP Connection $1 ended with a result of $Result
if [ $DELETE_FILES ]
then
   rm $TMP_DATA_PATH/ntrip_$1.bin
fi
