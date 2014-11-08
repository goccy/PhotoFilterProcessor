package PhotoFilterProcessor::Model::Filter::DB;
use strict;
use warnings;
use DBIx::Skinny;
use Data::Section::Simple qw(get_data_section);
use PhotoFilterProcessor::Config qw/dsn username password/;

sub new {
    my ($class) = @_;
    my $self = $class->SUPER::new({
        dsn      => dsn,
        username => username,
        password => password
    });
    my $filter_table = get_data_section('filter_table');
    $self->dbh->do($filter_table);
    return $self;
}

1;

__DATA__
@@ filter_table
CREATE TABLE IF NOT EXISTS `filter` (
    `id`     varchar(64) NOT NULL,
    `name`   varchar(16) NOT NULL,
    PRIMARY KEY(`name`),
    UNIQUE(`id`, `name`)
) ENGINE=InnoDB, CHARSET=utf8;

1;
