use Mojolicious::Lite;

get '/' => { text => 'Hello' };

app->start;
