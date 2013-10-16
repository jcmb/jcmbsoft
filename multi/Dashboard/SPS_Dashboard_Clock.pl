#!/usr/bin/perl
while (<>) {
    chomp;
    $s=$_;
    if ($s =~ /ClockSteering enable=(.*)/) {
       print "$1"
    }
}
