package Parse;

use strict;
use warnings;
use autodie;

use JSON qw/decode_json/;

sub parse_file {
    my $file = shift;
    
    open(my $fh, "<", $file);
    my $data;

    {local $/; $data = <$fh>;}

    # TODO take in gziped files too.
    
    my $stuff = decode_json($data);

    my @sheets = @{$stuff->{sheets}};
    my @links = @{$stuff->{'sheet-links'}};

    # To match the App, I MIGHT have to sort these by the position attribute.  I don't think it matters
    for my $link (@links) {
        push @{$sheets[$link->{'parent-position'}]->{_links}}, $sheets[$link->{'child-position'}];
    }
    
    return @sheets;
}

1;