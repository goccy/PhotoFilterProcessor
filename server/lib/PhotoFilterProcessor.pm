package PhotoFilterProcessor;
use Mojo::Base 'Mojolicious';
use PhotoFilterProcessor::Router;
use PhotoFilterProcessor::View::Template;

sub startup {
    my $self = shift;
    $self->plugin('PODRenderer');
    $self->routes->namespaces(['PhotoFilterProcessor::Controller']);
    PhotoFilterProcessor::Router::dispatch($self->routes);
}

1;
