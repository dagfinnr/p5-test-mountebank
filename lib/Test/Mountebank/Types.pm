package Test::Mountebank::Types;
use HTTP::Headers;

use MooseX::Types -declare => [
    qw( HTTPHeaders )
];

use MooseX::Types::Moose qw/Object HashRef/;

subtype HTTPHeaders,
    as 'HTTP::Headers';

coerce HTTPHeaders,
  from HashRef,
  via { HTTP::Headers->new(%$_) };

1;
