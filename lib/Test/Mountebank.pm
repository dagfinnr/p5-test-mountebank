package Test::Mountebank;

=head1 NAME

Test::Mountebank - Perl client library for mountebank

=head1 SYNOPSIS

    use Test::Mountebank;

    # Create mountebank client with default port 2525
    my $mb = Test::Mountebank::Client->new(
        base_url => 'http://127.0.0.1'
    );

    # Create an imposter that answers on port 4546
    my $imposter = $mb->create_imposter( port => 4546 );

    # Adds a stub to the imposter with a predicate and a response
    # (Responds to URL /foobar.json, returns JSON content '{"foo":"bar"}')
    $imposter->stub->predicate(
        path => "/foobar.json",
        method => "GET",
    )->response(
        statusCode => 200,
        headers => { Content_Type => "application/json" },
        body => { foo => "bar" },
        # Equivalent:
        # body => '{ "foo":"bar" }',
    );

    # Adds a stub for a non-existent resource
    $imposter->stub->predicate(
        path => "/qux/999/json",
        method => "GET",
    )->response(
        statusCode => 404,
        headers => { Content_Type => "application/json" },
        body => '{ "error": "No such qux: 999" }',
    );

    # Clear existing imposter
    $mb->delete_imposters(4546); # Takes more than one port number, if desired

    # Send the new imposter to mountebank
    $mb->save_imposter($imposter);

=head1 DESCRIPTION

# longer description...


=head1 INTERFACE


=head1 DEPENDENCIES


=head1 SEE ALSO

=cut

use Test::Mountebank::Client;


=head1 AUTHOR

Dagfinn Reiersøl dagfinn@reiersol.com

=head1 COPYRIGHT

Copyright (C) 2016, Dagfinn Reiersøl.

=cut

1;
