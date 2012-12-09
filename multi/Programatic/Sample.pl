#!/usr/bin/perl -w
use strict;
use LWP::Simple;

if (ARGC == 1) {
   print "Programatic Sample Application"
   }

print get( "http://192.168.253.49/prog/show?SystemName" ) ;
print get( "http://192.168.253.49/prog/show?gpstime" ) ;
print get( "http://192.168.253.49/prog/show?position" ) ;
