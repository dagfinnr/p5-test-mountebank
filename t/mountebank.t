#!/usr/bin/env perl -w

use strict;
use Test::More;
use Test::Mocha;
use Test::Mountebank::Client;

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
    $client->create_imposter('{ "dummy":"json" }');
    called_ok { $mock_ua->post('http://example.com:2525/imposters', 'json', '{ "dummy":"json" }') };
};

done_testing();
