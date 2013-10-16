#!/usr/bin/perl
my $got_result=0;

while (<>) {
    chomp;
    $s=$_;
    if ($s =~ /SerialNumber sn=.* *rxType=\"\d*,TRIMBLE (.*)\"/) {
       print "$1";
       $got_result=1
       }
    }

if ( $got_result == 0) {
   print "N/A"
}
