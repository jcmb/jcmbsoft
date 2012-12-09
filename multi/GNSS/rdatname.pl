#!/usr/bin/perl
use strict;
use GPS_TIME;
use File::Basename;

my $First_Time;
my $Last_Time;
my $Last;
my $week;
my $seconds;

my $current_name  = $ARGV[0];
my $prefix = $ARGV[1];


if (!defined $prefix) {
   print STDERR "\n";
   print STDERR "rdatname.pl File Prefix <X29 Data\n\n";
   print STDERR "Takes a file name, that must exist that will be renamed\nbased on the the X29 data from STDIN\n\n";
   print STDERR "E.g rdatname.pl 1234H123A.T01 B <1234H123A.X29";
   exit 100;
   }

my $base;
my $dir;
my $ext;

($base, $dir, $ext) = fileparse($current_name,'\..*');

# print "$base $dir $ext\n";


$ARGV[1]="";
$ARGV[0]="";
@ARGV=();

my $found=0;

while (<>) {
   chomp;
   if ($. == 4) {
#      print "First: $_\n";
      ($week,$seconds) = split(/,/,$_);
       $found=$week; #Say found if non zero
       last;

#      print "$week $seconds\n";
      }

   $Last = $_;
   }
   
if ($found==0) {die ("Did Not find start of week information for $current_name")}

my $year; 
my $mon;
my $mday;
my $hour;
my $min;
my $sec;   

($sec,$min,$hour,$mday,$mon,$year) = gmtime(Week_Seconds_To_Time($week,$seconds));   
$year%=10; # convert to just one digit
$mon++;

my $new_name = sprintf("%s%01u%02u%02u%02u",$prefix,$year,$mon,$mday,$hour);   


rename($current_name, $dir.$new_name.$ext) or die ("Could not rename $current_name to $dir$new_name$ext");
print "Renamed  $current_name to $dir$new_name$ext\n";

#print "Last: $Last\n";
#($week,$seconds) = split(/,/,$Last);
#print "$week $seconds\n";
