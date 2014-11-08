package PhotoFilterProcessor::Model::Filter::Archive;
use strict;
use warnings;
use Archive::Zip;
use File::Find;
use DateTime;
use File::Basename qw/basename dirname/;
use Jcode;
use File::Slurp;
use File::Path qw/make_path/;
use Data::Dumper;

my $BASE_DIR    = './public/docs';
my $ARCHIVE_DIR = "$BASE_DIR/archive";

sub new {
    my ($class) = @_;
    return bless {}, $class;
}

sub archive {
    my ($self, $filter_names) = @_;
    my $now      = DateTime->now(time_zone => 'local');
    my $prefix   = $now->ymd('') . $now->hms('');
    my $zip_name = "$prefix\_filters.zip";
    my $zip_path = "$ARCHIVE_DIR/$zip_name";
    my $zip = Archive::Zip->new;

    unless (-d $ARCHIVE_DIR) {
        make_path $ARCHIVE_DIR or die "[ERROR] : Cannot create directory. [$ARCHIVE_DIR]";
    }

    my @json_files;
    foreach my $filter_name (@$filter_names) {
        my $filter_dirname = Jcode::convert("$BASE_DIR/$filter_name\-filter", 'utf-8');
        find(sub {
            my $filename = $File::Find::name;
            if ($filename =~ /\.json$/) {
                push @json_files, $filename;
            }
        }, $filter_dirname);
    }

    my @archive_target_files;
    foreach my $json_filename (@json_files) {
        my $json    = read_file $json_filename;
        my $dirname = dirname $json_filename;
        my @images  = $json =~ /"inputBackgroundImage":"([^"]+)"/g;
        push @archive_target_files, $json_filename;
        push @archive_target_files, map {
            ( "$dirname/thumbnail-$_\.png",
              "$dirname/fullScreen-$_\.png",
              "$dirname/fullResolution-$_\.png"
            );
        } @images;
    }

    $zip->addFile($_, basename $_) foreach @archive_target_files;
    unless ($zip->writeToFileNamed($zip_path) == Archive::Zip::AZ_OK) {
        die "[ERROR] : Cannot create archive";
    }
    $zip_path =~ s|\./public||;
    return $zip_path;
}

1;
