#!/usr/bin/env perl

use strict;
use warnings;

use Data::Dumper;
use MIME::Parser;
use autodie;
use v5.10;

#open(STDOUT, ">/tmp/extract.log");
#open(STDERR, ">/tmp/extracterr.log");

my $parser = MIME::Parser->new( );
$parser->output_to_core(1);      # don't write attachments to disk

my $message  = $parser->parse(\*STDIN);      # die( )s if can't parse
my $head = $message->head();

my $from_head = $head->get("From");
my ($from) = ($from_head =~ /([A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]+)/ig);

my $mangled = ($from =~ s/[+%@]/_/gr);

print Dumper([$mangled]);
