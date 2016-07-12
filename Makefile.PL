use inc::Module::Install;

name 'Test-Mountebank';

perl_version '5.010001';
license 'perl';

all_from 'lib/Test/Mountebank.pm';

requires 'File::Slurper';
requires 'HTTP::Message' => '6.11';
requires 'Method::Signatures';
requires 'JSON::Tiny';
requires 'HTTP::Tiny';
requires 'MIME::Types';
requires 'Moose';
requires 'MooseX::Types';
requires 'MooseX::Types::HTTPMethod';
requires 'MooseX::Types::Moose';

test_requires 'Test::Deep';
test_requires 'Test::Mocha';
test_requires 'Test::More';
test_requires 'Types::Standard';
test_requires 'Test::Exception';
test_requires 'File::Temp';

WriteAll;
