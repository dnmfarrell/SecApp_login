#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use Test::WWW::Mechanize::Catalyst 'SecApp';
use LWP::Protocol::https;

ok(my $mech = Test::WWW::Mechanize::Catalyst->new, 'Create new browser');

# login referral to /landing
ok($mech->post( 'https://localhost/login', [ username => 'admin',
                                             password => 'Hfa *-£(&&%HBbWqpV%"_=asd' ] ), 'login');
ok($mech->success, 'Referred to /landing success');
ok($mech->content =~ /<p>Welcome to the secure admin page \(<a href="https:\/\/localhost\/logout">logout<\/a>\)<\/p>/,
   '/landing content displayed');
ok('https://localhost/landing' eq $mech->uri, 'Referred to /landing URI');

# landing
ok($mech->get('https://localhost/landing'), '/landing');
ok($mech->success, '/landing success');
ok($mech->content =~ /<p>Welcome to the secure admin page \(<a href="https:\/\/localhost\/logout">logout<\/a>\)<\/p>/,
   '/landing content displayed');
ok('https://localhost/landing' eq $mech->uri, '/landing URI');

# logout
ok($mech->get('https://localhost/logout'), 'logout');
ok($mech->success, '/logout success');
ok('https://localhost/' eq $mech->uri, '/logout should refer to index');
ok($mech->get('https://localhost/landing')->code == 404, '/landing should fail as logged out');

done_testing();
