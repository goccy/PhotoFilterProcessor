#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;

BEGIN { unshift @INC, "$FindBin::Bin/lib" }

use Plack::Builder;
require Mojolicious::Commands;

my $app = Mojolicious::Commands->start_app('PhotoFilterProcessor');

builder {
    enable 'Auth::Basic', authenticator => sub {
        my ($username, $password) = @_;
        return $username eq 'username' && $password eq 'password';
    };
    $app;
};
