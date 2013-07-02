use Mojolicious::Lite;

# /
get '/' => sub {
    my $self = shift;
    my @hoge = $self->param('hoge');
    $self->render(text => "Hello, World. @hoge");
};

# /foo
get '/foo' => sub {
    my $self = shift;
    $self->render(text => "Foo");
};
# /foo/id
get '/foo/:id' => { name => "Hoge男" } => sub { # デフォルト値
    my $self = shift;
    print $self->stash('id'). "\n";
    $self->render('foo');
};

# /hoge
get '/hoge' => sub {
    my $self = shift;
    $self->stash(stash_data => "StashData");
    $self->stash(req_data => {
        HOST        => $self->req->url->to_abs->host,
        URL         => $self->req->url->to_abs,
        UserAgent   => $self->req->headers->user_agent,
    });
    $self->render("hoge", val => "Value");
};


app->start;
