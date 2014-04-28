package SecApp::Controller::Root;
use Moose;
use namespace::autoclean;
use Captcha::reCAPTCHA;

BEGIN { extends 'Catalyst::Controller' }

__PACKAGE__->config(namespace => '');

# this method will be called everytime
sub auto :Private {
    my ($self, $c) = @_;

    # 404 unless https and request method is GET/HEAD/POST or we're testing
    unless( ( $c->req->secure or $c->config->{testing} == 1 )
            && grep /^(?:GET|HEAD|POST)$/, $c->req->method )
        {
            $c->detach('default');
        }

    # user must be authenticated if using Admin
    if ($c->controller eq $c->controller('Admin')
        && !$c->user_exists)
    {
        $c->detach('default');
    }
    return 1;
}

# this is the default response - 404
sub default :Path {
    my ( $self, $c ) = @_;
    $c->stash( error_msg => 'Page not found' );
    $c->response->status(404);
    $c->stash(template => 'error.tt');
}

# this is splash page
sub index :Path :Args(0) { }

# the login function
sub login :Chained('/') PathPart('login') CaptureArgs(0) {}

sub login_auth :Chained('login') PathPart('') Args(0) POST {
    my ($self, $c) = @_;
    my $captcha_response  = $c->request->params->{recaptcha_response_field};
    my $captcha_challenge = $c->request->params->{recaptcha_challenge_field};

    # if config has switched off CAPTCHA, or if the submission is valid, proceed
    if ($c->config->{Captcha}->{enabled} == 0
        || Captcha::reCAPTCHA->new->check_answer($c->config->{Captcha}->{private_key},
                                                 $c->request->address,
                                                 $captcha_challenge,
                                                 $captcha_response)->{is_valid})
    {
        my $username = $c->req->params->{username};
        my $password = $c->req->params->{password};

        # if username and passwords were supplied, authenticate
        if ($username && $password) {
            if ($c->authenticate({ username => $username,
                                   password => $password  } ))
            {
                # authentication success, check user active and redirect to the secure landing page
                if ($c->user->get_object->active) {
                    $c->response->redirect($c->uri_for($c->controller('Admin')->action_for('landing')));
                    return;
                }
            }
            else {
                $c->stash(error_msg => "Bad username or password.");
            }
        }
    }
    $c->forward('login_form');
}

sub login_form :Chained('login') PathPart('') Args(0) GET {
    my ($self, $c) = @_;

    # load the login template
    $c->stash(template => 'login.tt');

    # only load captcha if enabled in config
    if ($c->config->{Captcha}->{enabled} == 1) {
        $c->stash(captcha => Captcha::reCAPTCHA->new->get_html($c->config->{Captcha}->{public_key}, {}, 1));
    }
}

sub end : ActionClass('RenderView') {
    my ($self, $c) = @_;

    # don't require TLS for testing
    unless ($c->config->{testing} == 1) {
        $c->response->header('Strict-Transport-Security' => 'max-age=3600');
    }

    $c->response->header(
            'X-Frame-Options'           => 'DENY',
            'Content-Security-Policy'   => "default-src 'self' http://www.google.com https://www.google.com 'unsafe-eval' 'unsafe-inline'",
            'X-Content-Type-Options'    => 'nosniff',
            'X-Download-Options'        => 'noopen',
            'X-XSS-Protection'          => "1; 'mode=block'",
    );
}

__PACKAGE__->meta->make_immutable;
1;
