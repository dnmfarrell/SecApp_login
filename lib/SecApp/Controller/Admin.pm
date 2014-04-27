package SecApp::Controller::Admin;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

__PACKAGE__->config(namespace => '');

sub landing :Local Args(0) {
    my ($self, $c,) = @_;
    $c->stash( template => 'admin.tt');
}

sub logout :Local Args(0) {
    my ($self, $c,) = @_;
    $c->logout;
    $c->response->redirect($c->uri_for('/'));
}

__PACKAGE__->meta->make_immutable;

1;
