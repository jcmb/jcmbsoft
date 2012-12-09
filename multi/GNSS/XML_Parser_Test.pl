#!/usr/bin/perl -w
use strict;
use warnings;

use XML::LibXML;
use Data::Dumper;
my $clone_name=$ARGV[0];

my $parser = XML::LibXML->new(suppress_errors=>1, suppress_warnings=>1);
my $xmldoc = eval{$parser->parse_file($clone_name)};
die "Invalid XML File" if ($@);
print Dumper($xmldoc);

my $record;
my $record_name;
my $record_length;
my $app_file_records;

for my $sample ( $xmldoc->findnodes('/CloneConfigData') ) {
#    print $sample->nodeName(), "\n";
   foreach my $child ( $sample->getChildnodes ) {
      if ( $child->nodeType() == XML_ELEMENT_NODE ) {
         if ($child->nodeName() eq "APP_RECORD") {
            print $child->nodeName();
            $record="";
            $record_name="";
#            undefine $record if defined $record;
#            undefine $record_name if defined $record_name;
            my @attr=$child->attributes();
            foreach my $i (@attr) {
               if ($i->nodeName() eq "id") {$record=$i->getValue()};
               if ($i->nodeName() eq "name") {$record_name=$i->getValue()};
               if ($i->nodeName() eq "len") {$record_length=$i->getValue()};
               }
            print $record_name.  $record . "\n";
            }
            # $child->textContent(), "\n";
         }
     }
   }


#for my $sample ($xmldoc->findnodes('/CloneConfigData')) {
#    print Dumper($sample);
#    for my $property ($sample->findnodes('./*')) {
#        print $property->nodeName(), ": ", $property->textContent(), "\n";
#    }
#    print "\n";
#}
