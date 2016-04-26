package Test::Mountebank::Predicate::Equals;

use Moose;
use MooseX::Types::HTTPMethod qw(HTTPMethod11);
use HTTP::Headers;

use Mojo::JSON qw(encode_json);

has method      => ( is => 'ro', isa => HTTPMethod11);
has path        => ( is => 'ro', isa => 'Str' );
has body        => ( is => 'ro', isa => 'Str' );
has requestFrom => ( is => 'ro', isa => 'Str' );
has query       => ( is => 'ro', isa => 'HashRef');
has query       => ( is => 'ro', isa => 'HashRef');
has headers     => ( is => 'ro', isa => 'HTTP::Headers');

sub as_hashref {
    my $self = shift;
    my $hashref = ();
    for (qw/ method path query body requestFrom /) {
        $hashref->{$_} = $self->$_, if $self->$_;
    }
    if ($self->headers) {
        my %headers = $self->headers->flatten;
        $hashref->{headers} = \%headers;
    }
    return $hashref;
}
sub as_json {
    return encode_json({ equals => $_[0]->as_hashref() });
}



=todo

Coercion for HTTP::Headers

=cut




1;
