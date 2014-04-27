#!/usr/bin/env perl
use inc::Module::Install 1.02;
use Module::Install::Catalyst;
use 5.14.4;

name 'SecApp';
all_from 'lib/SecApp.pm';

license 'artistic';

requires 'Catalyst::Runtime' => '5.90061';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Action::RenderView';
requires 'Catalyst::Authentication::Realm::SimpleDB';
requires 'Catalyst::Component::InstancePerContext';
requires 'Catalyst::Model::DBIC::Schema';
requires 'Catalyst::Plugin::Authentication';
requires 'Catalyst::Authentication::Store::DBIx::Class';
requires 'Catalyst::Plugin::Captcha';
requires 'Catalyst::Plugin::Session';
requires 'Catalyst::Plugin::Session::Store::File';
requires 'Catalyst::Plugin::Session::State::Cookie';
requires 'Catalyst::Plugin::Session::State::Cookie';
requires 'Authen::Passphrase::BlowfishCrypt';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::View::TT';
requires 'CatalystX::Component::Traits';
requires 'Config::General';
requires 'DBIx::Class::PassphraseColumn';
requires 'DBIx::Class::Schema::Loader';
requires 'DBIx::Class::TimeStamp';
requires 'FCGI';
requires 'FCGI::ProcManager';
requires 'Moose';
requires 'MooseX::MarkAsMethods';
requires 'MooseX::NonMoose';
requires 'namespace::autoclean';
requires 'LWP::Protocol::https';
requires 'Captcha::reCAPTCHA';

test_requires 'Test::More' => '0.88';
test_requires 'Catalyst::Test';
test_requires 'Test::WWW::Mechanize::Catalyst';
test_requires 'HTTP::Request::Common';

catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
