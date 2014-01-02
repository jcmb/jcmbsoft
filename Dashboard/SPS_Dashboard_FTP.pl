#! /usr/bin/perl
# nagios: -epn

use strict;

use WWW::Mechanize;
use File::Basename;
use Data::Dumper;
use XML::Simple;
use Getopt::Long;

my $xs = XML::Simple->new();


my $host = '';# option variable with default value (false)
GetOptions ('hostname=s' => \$host);

#print "Host: $host";
die ("ERROR: You must provide a host name parameter") unless $host;
die ("ERROR: You must provide a host name") if $host =="1";


use constant VERSION => "0.1.0";
use constant URL => "http://jcmbsoft.dyndns.info";
use constant BLURB => "NAGIOS Plug in for montitoring Trimble SPS receivers, will with any modern high precision GNSS receiver with web interface with the programatic interface enabled";
use constant EXTRA => "Extra";

my $np = WWW::Mechanize->new();
$np->env_proxy();
$np->timeout(10);

if (open (PROXY, 'proxy.perl')) {

   if (my $proxy = <PROXY>) {
      chomp($proxy);
      $np->proxy(['http', 'ftp'], $proxy);
      }
   close PROXY;
}



$np->get("http://$host/xml/dynamic/dataLogger.xml");
my $ref = $xs->XMLin($np->content);
#  print Dumper($ref);

my $logging_active = $ref->{'session'}->{'enabled'};
my $ftppush_active = $ref->{'ftpPushEnabled'};
#print Dumper($logging_active);
#print Dumper($ftppush_active);

$np->get("http://$host/xml/dynamic/ftpPush.xml");
my $ref = $xs->XMLin($np->content);
my $dir = $ref->{'server'}->{'dir'};

#print Dumper($ref);
#print Dumper($dir);
#print ref ($dir);

if (!(defined($logging_active) && ($logging_active eq '1'))) {
    print "Logging Disabled";
   }
else {
   if (!(defined($ftppush_active) && ($ftppush_active eq '1'))) {
       print "ftppush Disabled"; }
   else {
       if ( ref($dir)) {
	   print "blank dir"; }
       else {
	   if (index($dir,"/pub/to_tac/gkirk/") != -1) {
	       print substr($dir, length("/pub/to_tac/gkirk/"));
	   }
	   else { 
    	      print $dir;
	   }
       }
   }   
#      print "failed";
#  print "Battery";
#}
#else {
#      print "worked";
#  print "AC"
#
}
