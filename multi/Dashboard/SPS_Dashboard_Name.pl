#!/usr/bin/perl
while (<>) {
    chomp;
    $s=$_;
    if ($s =~ /SystemName name=(.*)/) {
       print "$1"
    }
}
