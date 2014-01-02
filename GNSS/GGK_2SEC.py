#!/usr/bin/env python -u

import sys
import csv
from datetime import datetime, time
from pprint import pprint

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
