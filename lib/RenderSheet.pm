package RenderSheet;

use strict;
use warnings;
use Data::Dumper;

use Template;

sub render {
    my $sheet = shift;
    print Dumper([keys %$sheet]);
    
    my $output = "";
    
    my $tt = Template->new(INCLUDE_PATH => 'templates');
    print "OUTPUT: ";
    $tt->process('sheet.tt', $sheet, \$output);
    print $output;
    
    return $output;
}

1;