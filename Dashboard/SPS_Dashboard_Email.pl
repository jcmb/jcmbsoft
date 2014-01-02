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



$np->get("http://$host/xml/dynamic/email.xml");
my $ref = $xs->XMLin($np->content);
#print Dumper($ref);
my $alerts_active = $ref->{'enable'};


if (defined($alerts_active) && ($alerts_active eq '1')) {
#      print "failed";
  print "Enabled";
}
else {
#      print "worked";
  print "Disabled"
}
