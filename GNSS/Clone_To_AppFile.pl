#!/usr/bin/perl -w
$|=1;
use strict;

use XML::LibXML;
use Data::Dumper;

my $clone_name=$ARGV[0];

if ( !defined $clone_name ) {
    print "Usage: <clone file name>\n";
    exit;
}

my $parser = XML::LibXML->new();
print "Checking: $clone_name\n";
my $clone = $parser->parse_file ($clone_name);
die "Invalid XML File" if ($@);

print Dumper( $clone );
#die "Invalid Clone File" unless defined ( $clone-> { APP_RECORD });
#$State=$FW_Status-> { fw_status } -> { status } -> { mode } ;
my $i;
foreach $i ($clone) {
    print "*";
   print Dumper( $i );
   print "**\n";
}
print "\n";





