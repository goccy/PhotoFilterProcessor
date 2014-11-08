package PhotoFilterProcessor::Router;
use strict;
use warnings;

sub dispatch {
    my $routes = shift;
    $routes->get('/')->to('home#index');
    $routes->post('/upload_filter')->to('home#upload_filter');
    $routes->get('/filters')->to('home#filters');
    $routes->post('/download')->to('home#download');
    $routes->post('/delete')->to('home#delete_filters');
}

1;
