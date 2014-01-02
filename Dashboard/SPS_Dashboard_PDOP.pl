#!/usr/bin/perl
while (<>) {
    chomp;
    $s=$_;
    if ($s =~ /PdopMask mask=(.*)/) {
       print "$1"
    }
}
