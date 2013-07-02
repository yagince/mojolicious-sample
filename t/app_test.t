use Test::More;
use Test::Mojo;

use FindBin;
require "$FindBin::Bin/../app.pl";

my $t = Test::Mojo->new;
$t->get_ok('/')->status_is(200)->content_like(qr/Hello, World\./);
# $t->get_ok('/')->status_is(200)->content_like(qr/Hoge\./);

done_testing();
