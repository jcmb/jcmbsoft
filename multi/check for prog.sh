#hash foo 2>&- || { echo >&2 "I require foo but it's not installed.  Aborting."; }
command -v SPS_Monitor.pl &>/dev/null || {  echo  "Unknown - I require SPS_Monitor.pl but it's not installed.  Aborting."; exit 3; }
