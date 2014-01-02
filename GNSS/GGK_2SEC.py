#!/usr/bin/env python -u

import sys
import csv
from datetime import datetime, time
from pprint import pprint


if len(sys.argv) != 1 :
    sys.stderr.write(sys.argv[0]+"\n")
    sys.stderr.write("\n")
    sys.stderr.write("USAGE: GGK_2SEC <GGK/GGA File\n")
    sys.stderr.write("\n")
    sys.stderr.write("Converts times in a GGK/GGA file to be seconds of date instead of the HHMMSS format\n")
    sys.stderr.write("Removes the checksum, you can use AddCheck to put them back on if required\n")
    sys.stderr.write("Replacement for the orignal windows only ggk_2sec http://www.trimbletools.com/jcmbsoft/html/ggk_2sec.html\n")
    sys.stderr.write("\n")
    exit(1)

# Code from http://stackoverflow.com/questions/6556078/how-to-read-a-csv-file-from-a-stream-and-process-each-line-as-it-is-written
class ReadlineIterator(object):
    """An iterator that calls readline() to get its next value."""
    def __init__(self, f): self.f = f
    def __iter__(self): return self
    def next(self):
        line = self.f.readline()
        if line: return line
        else: raise StopIteration


def NMEA_Seconds_Of_Day (NMEA_Time):
   Base_Date=datetime(1900,1,1)
   Time=datetime.strptime(NMEA_Time,"%H%M%S.%f")
   return ((Time-Base_Date).total_seconds())


#reader = csv.reader(sys.stdin)
reader = csv.reader(ReadlineIterator(sys.stdin))
writer = csv.writer(sys.stdout)

for row in reader:
#   When the File has a header
#   if reader.line_num == 1:
#      writer.writerow(row)
#      continue

#   print  row
   if row:
      Seconds=NMEA_Seconds_Of_Day(row[1])
#      print NMEA_Str, Seconds
      row[1]=Seconds
      row[-1]=row[-1][0:-2]
      writer.writerow(row)
