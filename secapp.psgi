use strict;
use warnings;

use SecApp;

my $app = SecApp->apply_default_middlewares(SecApp->psgi_app);
$app;

