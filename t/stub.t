#!/usr/bin/env perl -w

use strict;
use Test::More;
use Test::Deep;
use Test::Mountebank::Stub;
use Mojo::JSON qw(decode_json);

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

my $expect_json = {
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
};

cmp_deeply( decode_json($stub->as_json), $expect_json );

done_testing();
