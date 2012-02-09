#!/bin/bash

if [ -z $2 ]
then
   echo "Usage: Programmatic_Test.sh Host_IP Test_ID";
   exit 1
fi

HOST=$1
mkdir -p $RESULTS_DIR$2
echo "Programmtic testing Host: $HOST" >$RESULTS_DIR$2/test
./Set_Test_Mode.sh $HOST no

curl --silent http://$HOST/prog/show?FirmwareVersion >>$RESULTS_DIR$2/test
curl --silent http://$HOST/prog/show?UtcTime >>$RESULTS_DIR$2/test
curl --silent http://$HOST/prog/show?SerialNumber >>$RESULTS_DIR$2/test

curl --silent http://$HOST/prog/show?ElevationMask >$RESULTS_DIR$2/general
curl --silent http://$HOST/prog/show?PdopMask >>$RESULTS_DIR$2/general
curl --silent http://$HOST/prog/show?ClockSteering >>$RESULTS_DIR$2/general
curl --silent http://$HOST/prog/show?MultipathReject >>$RESULTS_DIR$2/general
curl --silent http://$HOST/prog/show?TestMode >>$RESULTS_DIR$2/general
curl --silent http://$HOST/prog/show?Tracking >>$RESULTS_DIR$2/general
curl --silent http://$HOST/prog/show?PPS >>$RESULTS_DIR$2/general
curl --silent http://$HOST/prog/show?InstallFirmwareStatus >>$RESULTS_DIR$2/general
curl --silent http://$HOST/prog/show?GpsSatControls >> $RESULTS_DIR$2/general
curl --silent http://$HOST/prog/show?GlonassSatControls >>$RESULTS_DIR$2/general
curl --silent http://$HOST/prog/show?SbasSatControls >> $RESULTS_DIR$2/general
curl --silent http://$HOST/prog/show?WaasSatControls >> $RESULTS_DIR$2/general
curl --silent http://$HOST/prog/show?RefStation >> $RESULTS_DIR$2/general
curl --silent http://$HOST/prog/show?Antenna >>$RESULTS_DIR$2/general

curl --silent http://$HOST/prog/show?GpsHealth >$RESULTS_DIR$2/GPS_Health

curl --silent http://$HOST/prog/show?Temperature > $RESULTS_DIR$2/temp

curl --silent http://$HOST/prog/show?FirmwareWarranty > $RESULTS_DIR$2/warranty



curl --silent http://$HOST/prog/show?UtcTime >$RESULTS_DIR$2/time
curl --silent http://$HOST/prog/show?GpsTime >>$RESULTS_DIR$2/time



#curl --silent http://$HOST/prog/show?QzssSatControls
curl --silent http://$HOST/prog/show?Sessions >$RESULTS_DIR$2/sessions
curl --silent http://$HOST/prog/show?Commands >$RESULTS_DIR$2/commands
curl --silent http://$HOST/prog/show?IoPorts >$RESULTS_DIR$2/ports
curl --silent http://$HOST/prog/show?TrackingStatus >$RESULTS_DIR$2/tracking
curl --silent http://$HOST/prog/show?Position >$RESULTS_DIR$2/position
curl --silent http://$HOST/prog/show?Voltages >$RESULTS_DIR$2/voltages
curl --silent http://$HOST/prog/show?GpsUtcData >$RESULTS_DIR$2/gpsutc
curl --silent http://$HOST/prog/show?GpsIonoData >$RESULTS_DIR$2/Iono
curl --silent http://$HOST/prog/show?AntennaTypes>$RESULTS_DIR$2/Antennas

./Set_Test_Mode.sh $HOST yes

curl --silent http://$HOST/prog/show?ReferenceFrequency >$RESULTS_DIR$2/testmode
curl --silent http://$HOST/prog/show?Ethernet>>$RESULTS_DIR$2/testmode
curl --silent http://$HOST/prog/show?FtpPush>>$RESULTS_DIR$2/testmode
curl --silent http://$HOST/prog/show?Security>>$RESULTS_DIR$2/testmode
curl --silent http://$HOST/prog/show?EmailAlerts>>$RESULTS_DIR$2/testmode
curl --silent http://$HOST/prog/show?HttpPorts>>$RESULTS_DIR$2/testmode
curl --silent http://$HOST/prog/show?NtripClient>>$RESULTS_DIR$2/testmode
curl --silent http://$HOST/prog/show?NtripServer>>$RESULTS_DIR$2/testmode
curl --silent http://$HOST/prog/show?Bluetooth>>$RESULTS_DIR$2/testmode
curl --silent http://$HOST/prog/show?RtkControls>>$RESULTS_DIR$2/testmode
curl --silent http://$HOST/prog/show?Omnistar>>$RESULTS_DIR$2/testmode
curl --silent http://$HOST/prog/show?RaimPseudorangeSigma>>$RESULTS_DIR$2/testmode
curl --silent http://$HOST/prog/show?SystemMode>>$RESULTS_DIR$2/testmode
curl --silent http://$HOST/prog/show?HeadingControls>>$RESULTS_DIR$2/testmode

#curl http://$HOST/prog/show?Ephemeris
#curl http://$HOST/prog/show?Almanac
#curl http://$HOST/prog/show?IoPort
#curl --silent http://$HOST/prog/show?Logging
#curl --silent http://$HOST/prog/show?PPP
#curl --silent http://$HOST/prog/show?SecurityAccounts
#curl --silent http://$HOST/prog/show?SecurityAccount

./Set_Test_Mode.sh $HOST no

#./SPS_Monitor.pl -H $HOST --TestMode yes || ./Set_Test_Mode.sh $HOST yes
