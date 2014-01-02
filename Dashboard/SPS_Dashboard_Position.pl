#!/usr/bin/perl
while (<>) {
    chomp;
    $s=$_;
    if ($s =~ /Qualifiers *(.*)/) {
       print "$1"
    }
}
