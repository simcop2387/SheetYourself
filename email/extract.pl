#!/home/ryan/perl5/perlbrew/perls/perl-5.16.0/bin/perl
# /home/ryan/perl5/perlbrew/perls/perl-5.16.3/bin/perl
# 
use strict;
use warnings;

use Data::Dumper;
use MIME::Parser;
use JSON;
use autodie;
use v5.10;

umask 0;

my $destination = '/var/www/kobolds/';

#open(STDOUT, ">/tmp/extract.log");
#open(STDERR, ">/tmp/extracterr.log");

my $parser = MIME::Parser->new( );
$parser->output_to_core(1);      # don't write attachments to disk

my $message  = $parser->parse(\*STDIN);      # die( )s if can't parse
my $head = $message->head();

my $from_head = $head->get("From");
my ($from) = ($from_head =~ /([A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]+)/ig);

my $mangled = ($from =~ s/[.+%@]/_/gr);

my $num_parts = $message->parts;
for (my $i=0; $i < $num_parts; $i++) {
  my $part         = $message->parts($i);
  my $content_type = $part->mime_type;

  if ($content_type eq 'application/octet-stream') {
     my $body         = $part->bodyhandle;
     open(my $fh, ">", $destination."/".$mangled.".sheet.gz");
     print $fh $body->as_string if $body;
     close($fh);
     system("gunzip", $destination."/".$mangled.".sheet.gz");

     my $sheets_data;

     eval {
       # update the sheets file
       open(my $sheets_fh, "<", $destination."/sheets.json");
       {local $/; $sheets_data = eval {decode_json <$sheets_fh>} || {};}
       close($sheets_fh);

       for (@{$sheets_data->{sheets}}) {
          exit if ($_ eq $mangled.".sheet"); # no need to update
       }
     };
     push @{$sheets_data->{sheets}}, $mangled.".sheet";

     open (my $sheets_fh, ">", $destination."/sheets.json");
     print $sheets_fh encode_json $sheets_data;
     close($sheets_fh);
  }
}
