#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use Catalyst::Test 'SecApp';
use HTTP::Request::Common qw/GET POST HEAD PUT DELETE/;

# default
ok(request(GET      ( 'http://localhost/not_exist' ))->code  == 404, 'Invalid URL should 404');
ok(request(GET      ( 'http://localhost/not_exist' ))->decoded_content =~ /Page not found/, 'invalid URL content');
ok(request(PUT      ( 'http://localhost/' ))->code           == 404, 'PUT should 404');
ok(request(DELETE   ( 'http://localhost/' ))->code           == 404, 'DELETE should 404');
ok(request(PUT      ( 'http://localhost/login' ))->code      == 404, 'PUT /login should 404');
ok(request(DELETE   ( 'http://localhost/login' ))->code      == 404, 'DELETE /login should 404');
ok(request(HEAD     ( 'http://localhost/login' ))->code      == 404, 'HEAD /login should 404');
ok(request(GET      ( 'http://localhost/landing' ))->code    == 404, 'GET /landing should 404');
ok(request(POST     ( 'http://localhost/landing' ))->code    == 404, 'POST /landing should 404');
ok(request(GET      ( 'http://localhost/logout' ))->code     == 404, 'GET /logout should 404');
ok(request(POST     ( 'http://localhost/logout' ))->code     == 404, 'POST /logout should 404');

# index
ok( request(GET ( 'http://localhost/'))->is_success, 'GET index');
ok( request(GET ( 'http://localhost/'))->decoded_content =~ /Welcome to SecApp!/, 'GET index content');
ok( request(POST( 'http://localhost/'))->is_success, 'POST index');
ok( request(POST( 'http://localhost/'))->decoded_content =~ /Welcome to SecApp!/, 'POST index content');
ok( request(HEAD( 'http://localhost/'))->is_success, 'HEAD index');


# login page - expected content
my $login_content_default = <<'END';
<form method="POST" action="http://localhost/login">
<table>
    <tr>
        <td>Username:</td>
        <td><input type="text" name="username" size="40" autofocus /></td>
    </tr>
    <tr>
        <td>Password:</td>
        <td><input type="password" name="password" size="40" /></td>
    </tr>
    
    <tr>
        <td colspan="2"><input type="submit" name="submit" value="Login" /></td>
    </tr>
    <tr>
        <td colspan="2"></td>
    </tr>
</table>
</form>
END

my $login_content_bad_username_password = <<'END';
<form method="POST" action="http://localhost/login">
<table>
    <tr>
        <td>Username:</td>
        <td><input type="text" name="username" size="40" autofocus /></td>
    </tr>
    <tr>
        <td>Password:</td>
        <td><input type="password" name="password" size="40" /></td>
    </tr>
    
    <tr>
        <td colspan="2"><input type="submit" name="submit" value="Login" /></td>
    </tr>
    <tr>
        <td colspan="2">Bad username or password.</td>
    </tr>
</table>
</form>
END

# login - acceptable HTTP requests
ok( request(GET ( 'http://localhost/login' ))->is_success, 'GET /login');
ok( request(POST( 'http://localhost/login' ))->is_success, 'POST /login');
ok( request(GET  ( 'http://localhost/login' ))->decoded_content =~ /$login_content_default/, 'GET login content');
ok( request(POST ( 'http://localhost/login' ))->decoded_content =~ /$login_content_default/, 'POST login content');

# login - login requests missing parameters
ok( request(POST ( 'http://localhost/login', [ username => 'admin' ] ))->decoded_content =~ /$login_content_default/,
    'POST /login no password param content');
ok( request(POST ( 'http://localhost/login', [ password => 'admin' ] ))->decoded_content =~ /$login_content_default/,
    'POST /login no username param content');
ok( request(POST ( 'http://localhost/login', [ username => 'admin',
                                               password => undef ] ))->decoded_content =~ /$login_content_default/,
    'POST /login password undef content');
ok( request(POST ( 'http://localhost/login', [ username => undef, 
                                               password => 'password' ] ))->decoded_content =~ /$login_content_default/,
    'POST /login username undef content');
ok( request(POST ( 'http://localhost/login', [ username => undef, 
                                               password => undef ] ))->decoded_content =~ /$login_content_default/,
    'POST /login username password both undef content');
ok( request(POST ( 'http://localhost/login', [ username => '',
                                               password => '' ] ))->decoded_content =~ /$login_content_default/,
    'POST /login zero length username password content');

# login - login requests incorrect parameters should display error message
ok( request(POST ( 'http://localhost/login', [ username => 'playerone',
                                               password => 'Hfa *-£(&&%HBbWqpV%"_=asd' ] ))->decoded_content =~ /$login_content_bad_username_password/,
    'POST /login incorrect username param content');
ok( request(POST ( 'http://localhost/login', [ username => 'admin',
                                               password => 'default' ] ))->decoded_content =~ /$login_content_bad_username_password/,
    'POST /login incorrect password param content');

# login - login request correct parameters
ok( request(POST ( 'http://localhost/login', [ username => 'admin',
                                               password => 'Hfa *-£(&&%HBbWqpV%"_=asd' ] ))->is_redirect,
    'POST login redirects');


done_testing();
