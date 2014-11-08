package PhotoFilterProcessor::Controller::Home;
use strict;
use warnings;
use Mojo::Base 'Mojolicious::Controller';
use Data::Dumper;
use PhotoFilterProcessor::Util qw/move_prepare/;
use File::Path qw/make_path/;
use File::Basename qw/dirname basename/;
use Archive::Zip;
use PhotoFilterProcessor::Model::Filter::Factory;
use PhotoFilterProcessor::Model::Filter::Archive;
use PhotoFilterProcessor::Model::Filter::Remover;
use Jcode;
use URI::Encode qw/uri_decode/;

my $BASE_DIR = './public/docs';

sub index {
    my ($self) = @_;
    $self->tmpl('home.tmpl')->render;
}

sub download {
    my ($self) = @_;
    my @filter_names = $self->param('download_filter_names[]');
    my $zip_path  = PhotoFilterProcessor::Model::Filter::Archive->new->archive(\@filter_names);
    return $self->render(json => { path => $zip_path, name => basename $zip_path });
}

sub delete_filters {
    my ($self) = @_;
    my @filter_names = $self->param('delete_filter_names[]');
    my $remover = PhotoFilterProcessor::Model::Filter::Remover->new;
    $remover->remove($_) foreach @filter_names;
    return $self->rendered(200);
}

sub filters {
    my ($self) = @_;
    my $filters = PhotoFilterProcessor::Model::Filter::Factory->new->make_all;
    return $self->render(json => $filters);
}

sub upload_filter {
    my ($self) = @_;
    my $uploaded_zip  = $self->param('file');
    my $filename      = $uploaded_zip->filename;
    my ($dirname)     = $filename =~ /(.*)\.zip$/;
    my ($filter_name) = $dirname =~ /(.*)-filter/;
    if (-d "$BASE_DIR/$dirname") {
        PhotoFilterProcessor::Model::Filter::Remover->new->remove($filter_name);
    }
    my $move_path     = "$BASE_DIR/$dirname/$filename";
    move_prepare "$BASE_DIR/$dirname";
    $uploaded_zip->move_to($move_path);
    my $zip = Archive::Zip->new();
    if ($zip->read($move_path) != Archive::Zip::AZ_OK) {
        warn "$move_path not in zip format";
        return $self->rendered(100);
    }
    my @members = $zip->memberNames();
    foreach (@members) {
        my $path = uri_decode Jcode::convert("$BASE_DIR/$dirname/$_", 'utf-8');
        $zip->extractMember($_, $path);
    }
    return $self->rendered(200);
}


1;
