#!/usr/bin/perl
while (<>) {
    chomp;
    $s=$_;
    if ($s =~ /Antenna type=.* name=\"(.*)\" height/) {
       print "$1"
    }

}
