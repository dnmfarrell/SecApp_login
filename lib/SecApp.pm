package SecApp;
use Moose;
use namespace::autoclean;
use Catalyst::Runtime 5.90;

use Catalyst qw/
    Static::Simple
    Authentication
    Session
    Session::Store::File
    Session::State::Cookie
/;

extends 'Catalyst';

our $VERSION = '0.01';

__PACKAGE__->config(
    name => 'SecApp',
    disable_component_resolution_regex_fallback => 1,

    'View::HTML' => {
        # Set the location for TT files
        INCLUDE_PATH => [
            __PACKAGE__->path_to( 'root', 'templates' ),
        ],
        # Add a wrapperr template
        WRAPPER => 'wrapper.tt',
    },

    # Disable X-Catalyst header
    enable_catalyst_header => 0,

    # Check the command line args for TESTING, else set it false
    testing => $ENV{TESTING} || 0,

    # Configure SimpleDB Authentication
    'Plugin::Authentication' => {
        default => {
                class           => 'SimpleDB',
                user_model      => 'DB::User',
                password_type   => 'self_check',
            },
    },

    # Set the right headers for nginx
    using_frontend_proxy => 1,

    # Sessions will last an hour
    'Plugin::Session' => {
        expires => 3600,
    },

    # Captch::reCAPTCHA
    # Add your public and private key here, switch to enabled =>1 to turn on
    'Captcha' => {
        enabled => 0,
        private_key => '',
        public_key  => '',
    },
);

__PACKAGE__->setup();

1;
