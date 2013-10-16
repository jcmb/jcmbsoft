#!/usr/bin/perl
while (<>) {
    chomp;
    $s=$_;
    if ($s =~ /RtkControls mode=.* motion=(.*)/) {
       print "$1"
    }

}
