#!/usr/bin/env python
import sys, re, base64, httplib, apachelog

format = r'%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"'
print format
p = apachelog.parser(format)

for line in sys.stdin:
    try:
       data = p.parse(line)
       print data
    except:
       sys.stderr.write("Unable to parse %s" % line)
