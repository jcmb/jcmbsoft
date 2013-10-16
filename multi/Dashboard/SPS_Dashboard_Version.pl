#!/usr/bin/perl
while (<>) {
    chomp;
    $s=$_;
    if ($s =~ /FirmwareVersion version=(.*) date=(.*)/) {
       print "$1"
    }
}
