#!/usr/bin/perl
while (<>) {
    chomp;
    $s=$_;
    if ($s =~ /FirmwareWarranty date=(.*)/) {
       print "$1"
    }
}
