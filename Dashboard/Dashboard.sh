#!/bin/bash
# Horribly hacky way of creating a dashboard of status of GNSS receivers. It really should be an app with a config file
# but it works today...

echo "Content-type: text/html"
echo ""
echo "<html><title>GNSS Dashboard</title><meta http-equiv=\"refresh\" content=\"300\"><head>"
echo "<style>"
echo "h1 {text-align:center}"
echo "h2 {text-align:center}"
echo "h3 {text-align:right}"
echo "</style>"
echo "<body>"


# We start all the receivers generating there output at the same time.
./Single_Dashboard.sh "Sunnyvale" SPS855.com admin:Password1@  > /tmp/SPS855.com.html&
./Single_Dashboard.sh "Westminster" base.trimble-wco.com admin:Password1@  > /tmp/wco_base.html&
# When we have a receiver which is known to be down we call the down script instead, the UI is a bit nicer and it is faster

./Single_Down.sh "XFill" xFill.trimble-wco.com admin:Password1@  > /tmp/xfill.html&

#Since we have fired off a bunch of scripts we need to wait for them all to come back.
wait
echo "<h1>GNSS Status</h1><h2> "
date
echo "</h2>"
echo "<table border=\"1\">"
echo "<tr><th>Receiver</th><th>Name</th><th>IP</th><th>Type</th><th>Serial</th><th>Version</th><th>Motion</th><th>Elev</th><th>PDOP</th><th>Clock</th><th>Temp</th><th>Power</th><th>Uptime</th><th>logging</th><th>FTP Push</th><th>Email</th><th>Position</th><th>Antenna</th><th>Warranty</th></tr>"

echo "<tr><th colspan=\"19\">Public</th></tr>"
cat /tmp/SPS855.com.html
cat /tmp/wco_base.html
echo "<tr><th colspan=\"19\">Westminster</th></tr>"
cat /tmp/xfill.html
echo "</table>"em all
echo "</body></html>"
