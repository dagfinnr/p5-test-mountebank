package Test::Mountebank::Response::Is;

use Moose;
use Test::Mountebank::Types qw( HTTPHeaders );
use Mojo::JSON qw(encode_json);
use File::Slurper qw/read_text/;
use Carp;

has statusCode     => ( is => 'ro', isa => 'Int' );
has body           => ( is => 'rw', isa => 'Str | HashRef' );
has headers        => ( is => 'ro', isa => HTTPHeaders, coerce => 1);

has body_from_file => (
    is         => 'ro',
    isa        => 'Str',
    trigger    => \&_read_body_from_file,
);

sub _read_body_from_file {
    my $self = shift;
    my $body = read_text($self->body_from_file);
    croak ("Empty response body read from file: " . $self->body_from_file) if length($body) < 1;
    $self->body($body);
}

sub as_hashref {
    my $self = shift;
    my $hashref = ();
    for (qw/ body statusCode /) {
        $hashref->{$_} = $self->$_, if $self->$_;
    }
    if ($self->headers) {
        my %headers = $self->headers->flatten;
        $hashref->{headers} = \%headers;
    }
    return { is => $hashref };
}

sub as_json {
    return encode_json( $_[0]->as_hashref() );
}

1;
