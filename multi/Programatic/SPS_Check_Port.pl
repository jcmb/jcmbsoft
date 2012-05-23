#! /usr/bin/perl
use strict;
use warnings;

use Nagios::Plugin;
use Nagios::Plugin::WWW::Mechanize;
use WWW::Mechanize;
use File::Basename;
use Data::Dumper;

use constant VERSION => "0.1.0";
use constant URL => "http://jcmbsoft.dyndns.info";
use constant BLURB => "NAGIOS Plug in for montitoring Trimble SPS receivers, will with any modern high precision GNSS receiver with web interface with the programatic interface enabled";
use constant EXTRA => "Extra";

my $np = Nagios::Plugin::WWW::Mechanize->new(
    usage => "Usage: %s [ -v|--verbose ]  [-H <host>] [-t <timeout>] [-U|--User User:Pass] [-h|--Help]" .
    "[--CMR:format] [--RTCM] [--NMEA:format,rate] ".
    "[[-t|--TCP] [-u|--UDP] [--outputOnly]] ".
    "[[-s|--serial] [--Baud=baud] [--Flow=flow] [--Parity=parity]]",
    version => VERSION,
    blurb   => BLURB,
    extra   => EXTRA,
    url     => URL,
    plugin  => basename $0,
    timeout => 15,
);

if (open (PROXY, '/usr/lib/nagios/plugins/proxy.perl')) {

    if (my $proxy = <PROXY>) {
	chomp($proxy);
	$np->mech->proxy(['http', 'ftp'], $proxy);
    }
    close PROXY;
}

$np->add_arg(
    spec       => 'hostname|H=s',
    help       => [
    "Hostname to query",
    "IP address to query",
    ],
    label      => [ 'HOSTNAME', 'IP' ],
    required   => 1,
);


$np->add_arg(
    spec       => 'User|U=s',
    help       => [
    "User name and password, if security is enabled. Format user:password"
    ],
    label      => [ 'User_Password'],
    required  => 0
);

 $np->add_arg(
     spec => 'TCP|t',
     help => 'If the port is a TCP port, the default',
    );

 $np->add_arg(
     spec => 'UDP|u',
     help => 'If the port is a UDP port',
    );

 $np->add_arg(
     spec => 'Serial|s',
     help => 'If the port is a Serial port',
    );

 $np->add_arg(
     spec => 'Port|P=s',
     help => '-P --Port=INTEGER the Port ',
     required  => 1
    );

 $np->add_arg(
     spec => 'Baud=s',
     help => 'Baud Rate of the Serial Port',
    );

 $np->add_arg(
    spec => 'Parity=s',
    help => 'Parity of the Serial Port',
    );

 $np->add_arg(
    spec => 'Flow=s',
    help => 'Flow Control of the Serial Port',
    );


 $np->add_arg(
     spec => 'outputOnly',
     help => 'If the port is output only, IP Streams only',
    );

 $np->add_arg(
     spec => 'Input',
     help => 'If the port is Input and Output, TCP or Input only UDP. IP Streams only',
    );

 $np->add_arg(
     spec => 'remotePort:s',
     help => 'If the port in client mode IP Streams only',
    );

 $np->add_arg(
     spec => 'CMR:s',
     help => 'If the stream has CMR enabled, optionally what type of CMR. '.
     'Options are: standard cmrPlus cmrX cmr5Hz cmr10Hz cmr20Hz' ,
     required  => 0
    );

 $np->add_arg(
     spec => 'RTCM',
     help => 'If the stream has RTCM enabled ',
     required  => 0
    );

 $np->add_arg(
     spec => 'NMEA:s',
     help => 'If the stream has NMEA enabled. Optional Parameter is TYPE,Rate',
     required  => 0
    );

$np->getopts;
my $opts=$np->opts;
my $host=$opts->hostname();
my $user=$opts->User();
if ($user) {
   $host=$user."@".$host;
   }

my $verbose=$opts->verbose();

my $port_type="Tcp";
$port_type="Udp" if $opts->UDP();
$port_type="Serial" if $opts->Serial();

my $Port= $port_type."Port".$opts->Port();


print "Port:$Port\n" if $opts->verbose();

my $code;
my $message;

print "Host: $host\n" if $verbose>1;

$np->get("http://$host/prog/show?IoPort&port=$Port");


my $Stream = $np->content;
#print $Stream;
chomp($Stream);
if (!($Stream =~ /^IoPort/)) {
   $np->nagios_exit(CRITICAL, "Invalid Port Number, or port not configured: $Port");
   }

if ($port_type eq "Serial") {
   if ($opts->Flow()) {
      print "Checking Flow Control\n" if $opts->verbose();
      my $flow_setting=$opts->Flow();
      if (!($Stream =~ /flow=$flow_setting/)) {
         ($Stream =~ /flow=(\w*)/);
         $np->add_message('CRITICAL',"Flow Control is $1 not " . $flow_setting);
         }
      }

   if ($opts->Baud()) {
      print "Checking Baud Control\n" if $opts->verbose();
      my $Baud_setting=$opts->Baud();
      if (!($Stream =~ /baud=$Baud_setting/)) {
         ($Stream =~ /baud=(\w*)/);
         $np->add_message('CRITICAL',"Baud rate is $1 not " . $Baud_setting);
         }
      }

   if ($opts->Parity()) {
      print "Checking Parity \n" if $opts->verbose();
      my $Parity_setting=$opts->Parity();
      if (!($Stream =~ /parity=$Parity_setting/)) {
         ($Stream =~ /parity=(\w*)/);
         $np->add_message('CRITICAL',"Parity is $1 not " . $Parity_setting);
         }
      }
   }

if ($port_type eq "Tcp"  || $port_type eq "Udp") {
   if ($opts->outputOnly()) {
      print "Checking outputOnly \n" if $opts->verbose();
      if (!($Stream =~ /outputOnly/)) {
         $np->add_message('CRITICAL',"Stream is not outputOnly");
         }
      }

   if (defined ($opts->remotePort())) {
      print "Checking remotePort \n" if $opts->verbose();
      if (!($Stream =~ /remotePort=/)) {
         $np->add_message('CRITICAL',"Stream is not in remotePort mode");
         }
      else {
         if ($opts->remotePort()) {
            my $remote=$opts->remotePort();
            if (!($Stream =~ /remotePort=$remote/)) {
               ($Stream =~ /remotePort=([\.\:\w]*)/);
               $np->add_message('CRITICAL',"Stream is not remotePort to $remote, it is to $1");
               }
            }
         }
      }
   }

if ($opts->RTCM()) {
   print "Checking RTCM\n" if $opts->verbose();
   if (!($Stream =~ /rtcm/)) {
      $np->add_message('CRITICAL',"Stream is not RTCM");
      }
   }

if (defined ($opts->CMR())) {
   print "Checking CMR\n" if $opts->verbose();
   if (!($Stream =~ /Cmr=/)) {
      $np->add_message('CRITICAL',"Stream is not CMR");
      }
   else {
      if ($opts->CMR()) {
         my $CMR=$opts->CMR();
         if (!($Stream =~ /Cmr=$CMR/)) {
            ($Stream =~ /Cmr=(\w*)/);
            $np->add_message('CRITICAL',"Stream is not Cmr format $CMR it is  $1");
            }
         }
      }
   }

if (defined ($opts->NMEA())) {
   print "Checking NMEA\n" if $opts->verbose();
   if (!($Stream =~ /Nmea\w*=/)) {
      $np->add_message('CRITICAL',"Stream is not Nmea");
      }
   else {
      if ($opts->NMEA()) {
         my @NMEA=split(/,/,$opts->NMEA());
         $NMEA[1]="" unless defined $NMEA[1];
         if (!($Stream =~ /Nmea$NMEA[0]=/)) {
            $np->add_message('CRITICAL',"Stream is not NMEA format $NMEA[0]");
            }
         else
            {
            if (!($Stream =~ /Nmea$NMEA[0]=$NMEA[1]/)) {
               ($Stream =~ /Nmea$NMEA[0]=(\w*)/);
               $np->add_message('CRITICAL',"Stream is not NMEA format $NMEA[0] at $NMEA[1] it is at $1");
               }
            }
         }
      }
   }


($code,$message) = $np->check_messages;
$np->nagios_exit($code, $message);
