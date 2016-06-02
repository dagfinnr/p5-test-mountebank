package Test::Mountebank::Response::Is;

use Moose;
use Method::Signatures;
use Test::Mountebank::Types qw( HTTPHeaders );
use JSON::Tiny qw(encode_json);
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

method _read_body_from_file(@args) {
    my $body = read_text($self->body_from_file);
    croak ("Empty response body read from file: " . $self->body_from_file) if length($body) < 1;
    $self->body($body);
}

method as_hashref() {
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

method as_json() {
    return encode_json( $self->as_hashref() );
}

1;
