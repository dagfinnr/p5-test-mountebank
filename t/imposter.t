#!/usr/bin/env perl -w

use strict;
use Test::More;
use Test::Deep;
use Test::Mountebank::Imposter;
use Mojo::JSON qw(decode_json);

my $imposter = Test::Mountebank::Imposter->new( port => 4546 );

my $stub = Test::Mountebank::Stub->new();

$stub->add_predicate(
    Test::Mountebank::Predicate::Equals->new(
        path => "/test",
    )
);

$stub->add_response(
    Test::Mountebank::Response::Is->new(
        statusCode => 404,
        headers => HTTP::Headers->new(
            Content_Type => "text/html"
        ),
        body => 'ERROR'
    )
);


$imposter->add_stub($stub);

my $expect_json = {
    stubs => [
        {
            responses => [
                {
                    is => {
                        statusCode => 404,
                        headers => {
                            "Content-Type" => "text/html"
                        },
                        body => 'ERROR'
                    }
                }
            ],
            predicates => [
                {
                    equals => {
                        path => "/test",
                    }
                }
            ]
        }
    ]
};
ok(1);

done_testing();
