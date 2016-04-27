#!/usr/bin/env perl -w

use strict;
use Test::More;
use Test::Mocha;
use Test::Deep;
use Test::Mountebank::Client;
use Mojo::JSON qw(decode_json encode_json);
use Types::Standard qw(Any StrMatch);

my $mock_ua = mock();

my $client = Test::Mountebank::Client->new(
    base_url => 'http://example.com',
    ua       => $mock_ua,
);

subtest 'can construct URL' => sub  {
    is($client->mb_url, 'http://example.com:2525');
};

subtest 'can check Mountebank available' => sub  {
    my $mock_tx = mock();
    stub { $mock_tx->error() } returns 0;
    stub { $mock_ua->head('http://example.com:2525') } returns $mock_tx;
    ok( $client->is_available() );
    stub { $mock_tx->error() } returns 1;
    ok( !$client->is_available() );
};

subtest 'can delete imposters' => sub  {
    $client->delete_imposters(4545, 4546);
    called_ok { $mock_ua->delete('http://example.com:2525/imposters/4545') };
    called_ok { $mock_ua->delete('http://example.com:2525/imposters/4546') };
};

subtest 'can create imposter' => sub  {

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
    $client->save_imposter($imposter);
    my $expect_json = {
        port => 4546,
        protocol => 'http',
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

    my ($call) = inspect { $mock_ua->post(Any, Any, Any ) };
    cmp_deeply([$call->args()]->[2], $expect_json);
};

done_testing();
