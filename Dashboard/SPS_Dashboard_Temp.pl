#!/usr/bin/perl
while (<>) {
    chomp;
    $s=$_;
    if ($s =~ /Temperature temp=(.*)/) {
       print "$1"
    }
}
