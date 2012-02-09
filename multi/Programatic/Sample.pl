#!/usr/bin/perl -w
use strict;
use LWP::Simple;

print get( "http://192.168.253.49/prog/show?SystemName" ) ;
print get( "http://192.168.253.49/prog/show?gpstime" ) ;
print get( "http://192.168.253.49/prog/show?position" ) ;
