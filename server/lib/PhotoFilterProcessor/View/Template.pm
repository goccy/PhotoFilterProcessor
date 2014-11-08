package PhotoFilterProcessor::View::Template;
use strict;
use warnings;
use Text::Xslate;
use Encode qw/encode decode/;
use utf8;
use Mojolicious::Controller;
use base qw/Class::Accessor::Fast/;

__PACKAGE__->mk_accessors(qw/
    tmpl
    controller
/);

my $base_path = './tmpl';

*Mojolicious::Controller::tmpl = sub {
    my ($self, $path) = @_;
    my $tx = Text::Xslate->new(
        cache_dir => '.xslate_cache',
        path      => [ $base_path ],
        syntax    => 'Kolon'
    );
    return __PACKAGE__->SUPER::new({
        tmpl => $tx,
        controller => $self,
        path => $path
    });
};

sub assign {
    my ($self, %params) = @_;
    $self->{params} = \%params;
    return $self;
}

sub rendered_text {
    my ($self) = @_;
    return $self->tmpl->render($self->{path}, $self->{params});
}

sub render {
    my ($self) = @_;
    my $rendered_txt = $self->tmpl->render($self->{path}, $self->{params});
    return $self->controller->render(text => $rendered_txt);
}

1;
