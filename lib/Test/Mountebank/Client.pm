package Test::Mountebank::Client;
use Moose;
use Method::Signatures;
use Mojo::UserAgent;

has ua => (
    is      => 'ro',
    default => sub { Mojo::UserAgent->new() },
);
has base_url => ( is => 'ro', isa => 'Str', required => 1 );
has port => ( is => 'rw', isa => 'Int', default => 2525 );

method mb_url() {
    return $self->base_url . ":" . $self->port;
}

method is_available() {
    return ! $self->ua->head($self->mb_url)->error;
}

method delete_imposters(@on_ports) {
    $self->ua->delete($self->mb_url . "/imposters/$_") for @on_ports;
}

method create_imposter($json) {
    $self->ua->post($self->mb_url . "/imposters" => json => $json);
}

1;