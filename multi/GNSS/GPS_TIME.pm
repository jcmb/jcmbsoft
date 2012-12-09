use Time::Local;

use constant Seconds_In_A_Hour => 3600;
use constant Seconds_In_A_Day  => 24 * Seconds_In_A_Hour;
use constant Seconds_In_A_Week => 7 * Seconds_In_A_Day;

sub  Week_Seconds_To_Time { #Week, Secs : CARDINAL

	my $Week=$_[0];
	my $Secs=$_[1];
	
	
	my $The_Date; #  DateTime;
	my $GPS_Start;
	
	$GPS_Start = timegm (0,0,0,6,0,1980); # 6th of Jan 1980 is GPS 0
	
	$The_Date = ($Week * Seconds_In_A_Week) + $Secs + $GPS_Start;

   
	
#	$Days = int ($Secs / $Seconds_In_A_Day);
#	$Secs = $Secs % $Seconds_In_A_Day;
	
#	$Hours = int ($Secs / $Seconds_In_A_Hour);
#	$Secs  = $Secs % $Seconds_In_A_Hour;
	
#	$Minutes = int ($Secs / 60);
#	$Secs    = $Secs % 60;
	
#	$Sec := $Secs;
	
#	$The_Date = timegm($Sec,$Minutes,$Hours,$
#	The_Date := EncodeDate(1980,1,6); {GPS week 0, Day 0}
#	The_Date := The_Date + (Week * 7) + Days;
#	The_Time := EncodeTime(Hours,Minutes,Sec,0);
#	The_Date := The_Date + The_Time;
#	Week_Seconds_To_Time := The_Date;
  
   }
 
return TRUE;