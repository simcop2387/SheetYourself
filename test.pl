#!/usr/bin/env perl

use strict;
use warnings;
use lib './lib';

use JSON qw(decode_json);
use Data::Dumper;
use autodie;

use RenderSheet;
use Parse;

my @sheets = Parse::parse_file("pope.json");

for my $sheet (@sheets) {
    my $output = RenderSheet::render($sheet);
    
    print $output;
}
