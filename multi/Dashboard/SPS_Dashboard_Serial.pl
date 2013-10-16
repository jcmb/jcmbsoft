#!/usr/bin/perl
while (<>) {
    chomp;
    $s=$_;
    if ($s =~ /SerialNumber sn=(.*) *rxType=(.*)/) {
       print "$1"
       }
    else {
       if ($s =~ /SerialNumber sn=(.*)/) {
	  print "$1"
       }
    }
}
