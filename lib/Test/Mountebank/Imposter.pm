package Test::Mountebank::Imposter;

use Moose;
use Test::Mountebank::Stub;
use Mojo::JSON qw(encode_json);
use Carp;

has protocol => ( is => 'rw', isa => 'Str', default => 'http' );
has port     => ( is => 'rw', isa => 'Int', default => 4545 );

has stubs   => (
    traits  => ['Array'],
    is      => 'ro',
    isa     => 'ArrayRef',
    default => sub { [] },
    handles => {
        all_stubs    => 'elements',
        add_stub     => 'push',
        map_stubs    => 'map',
        filter_stubs => 'grep',
        has_stubs    => 'count',
        has_no_stubs => 'is_empty',
    },
);

sub as_hashref {
    my $self = shift;
    croak "An imposter must have at least one stub" if $self->has_no_stubs;
    return {
        stubs  => [ $self->map_stubs( sub { $_->as_hashref } ) ],
    };
}

sub as_json {
    return encode_json( $_[0]->as_hashref() );
}

1;
