package PhotoFilterProcessor::Model::Filter::Remover;
use strict;
use warnings;
use File::Find;
use File::Basename qw/basename dirname/;
use Jcode;
use File::Path qw/rmtree/;
use Data::Dumper;

my $BASE_DIR = './public/docs';

sub new {
    my ($class) = @_;
    return bless {}, $class;
}

sub remove {
    my ($self, $filter_name) = @_;
    my $filter_dir = Jcode::convert("$BASE_DIR/$filter_name\-filter", 'utf-8');
    rmtree $filter_dir or die "[ERROR] : Cannot remove directory [$filter_dir]. $!";
}

1;
