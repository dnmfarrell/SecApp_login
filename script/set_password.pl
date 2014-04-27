use SecApp::Schema;

my $schema = SecApp::Schema->connect('dbi:SQLite:secapp.db');
my $user = $schema->resultset('User')->find(1);
$user->password('Hfa *-£(&&%HBbWqpV%"_=asd');
$user->update;
