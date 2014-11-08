package PhotoFilterProcessor::Model::Filter::Factory;
use strict;
use warnings;
use File::Find;
use File::Basename qw/basename dirname/;
use JSON::XS;
use Data::Dumper;
use utf8;
use Encode;

my $BASE_DIR = './public/docs';

sub new {
    my ($class) = @_;
    return bless {}, $class;
}

sub make_all {
    my ($self) = @_;
    my @filter_packages;
    find(sub {
        my $file = $File::Find::name;
        if ($file =~ /\.json$/) {
            my ($filter_name_path) = $file =~ /(.*)-filter\.json/;
            my $filter_name    = basename $filter_name_path;
            my $filter_dirpath = dirname $filter_name_path;
            $filter_dirpath =~ s/public//;
            my $filtered_name = "$filter_name\-filtered-image.jpg";
            push @filter_packages, {
                name      => decode('utf8', $filter_name),
                thumbnail => decode('utf8', "$filter_dirpath/$filtered_name"),
                json      => $file,
            };
        }
    }, $BASE_DIR);
    foreach my $filter_package (@filter_packages) {
        my $json_filename = $filter_package->{json};
        open my $fh, '<', $json_filename or die "Cannot open file : [$json_filename]";
        my $json = do { local $/; <$fh> };
        close $fh;
        $filter_package->{json} = $json;
    }
    return \@filter_packages;
}


1;
