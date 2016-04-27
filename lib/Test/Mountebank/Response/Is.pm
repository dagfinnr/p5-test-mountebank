package Test::Mountebank::Response::Is;

use Moose;
use Method::Signatures;

use Mojo::JSON qw(encode_json);

use Mojo::JSON qw(encode_json);

has statusCode => ( is => 'ro', isa => 'Int' );
has body       => ( is => 'ro', isa => 'Str | HashRef' );
has headers    => ( is => 'ro', isa => 'HTTP::Headers');

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
