package PhotoFilterProcessor::Util;
use strict;
use warnings;
use File::Path qw/make_path/;
use parent 'Exporter';
use JSON::XS;

our @EXPORT_OK = qw/
    move_prepare
/;

sub move_prepare($) {
    my $dirname = shift;
    unless (-d $dirname) {
        make_path $dirname or die "[ERROR] : Cannot create directory. [$dirname]";
    }
}

1;
