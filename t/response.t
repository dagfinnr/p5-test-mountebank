#!/usr/bin/env perl -w

use strict;
use Test::More;
use Test::Deep;
use Test::Mountebank::Response::Is;
use Mojo::JSON qw(decode_json);
use HTTP::Headers;

subtest 'string body' => sub  {
    my $is = Test::Mountebank::Response::Is->new(
        statusCode => 201,
        headers => {
            Location => "http://localhost:4545/customers/123",
            Content_Type => "application/xml"
        },
        body => '<customer><email>customer@test.com</email></customer>'
    );

    my $expect_json = {
        is => {
            statusCode => 201,
            headers => {
                Location => "http://localhost:4545/customers/123",
                "Content-Type" => "application/xml"
            },
            body => '<customer><email>customer@test.com</email></customer>'
        }
    };
    cmp_deeply( decode_json($is->as_json), $expect_json );
};

subtest 'hashref/json body' => sub  {
    my $is = Test::Mountebank::Response::Is->new(
        statusCode => 201,
        headers => {
            Location => "http://localhost:4545/customers/123",
            Content_Type => "application/xml"
        },
        body => { foo => 'bar' },
    );

    my $expect_json = {
        is => {
            statusCode => 201,
            headers => {
                Location => "http://localhost:4545/customers/123",
                "Content-Type" => "application/xml"
            },
            body => { foo => 'bar' },
        }
    };
    cmp_deeply( decode_json($is->as_json), $expect_json );
};


done_testing();
