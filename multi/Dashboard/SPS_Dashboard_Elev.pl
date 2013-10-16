#!/usr/bin/perl
while (<>) {
    chomp;
    $s=$_;
    if ($s =~ /ElevationMask mask=(.*)/) {
       print "$1"
    }
}
