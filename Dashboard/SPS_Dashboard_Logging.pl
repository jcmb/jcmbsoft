#!/usr/bin/perl
while (<>) {
    chomp;
    $s=$_;
    if ($s =~ /^.*enabled=(.*) schedule=(.*) durationMin=(.*) measInterval=(.*) posInterval=(.*) fileSystem/) {
       print "$1 $2=$3 $4,$5"
    }
}
