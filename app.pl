#!/usr/bin/env perl

use Mojolicious::Lite;

# filter的な物
under sub {
    print "Under !!\n";
};

group {
    under '/admin' => sub {
        print "Admin Area\n";
    };

    # /admin
    get '/' => sub {
        my $self = shift;
        $self->render('admin/index');
    };
};

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

# /bar.html
# /bar.txt
# /bar.json
get '/bar' => [ format => [qw(html json txt)] ] => sub {
    my $self = shift;
    return $self->render(json => {name => 'Bar'}) if $self->stash('format') eq 'json';
    $self->render('bar');
};

get '/piyo' => sub {
    my $self = shift;
    $self->respond_to(
        json => { json => {hoge => 200} },
        txt  => { text => 'piyopiyo-----' },
        # any  => { html => $self->render('piyo') },
    );
};

# ブロッキング
get '/headers' => sub {
  my $self = shift;
  my $url  = $self->param('url') || 'http://mojolicio.us';
  my $dom  = $self->ua->get($url)->res->dom;
  $self->render(json => [$dom->find('h1, h2, h3')->pluck('text')->each]);
};

# ノンブロッキング
get '/title' => sub {
  my $self = shift;
  $self->ua->get('mojolicio.us' => sub {
    my ($ua, $tx) = @_;
    $self->render(data => $tx->res->dom->at('title')->text);
  });
};

# Websocket
get '/echo' => sub {
    $_[0]->render('echo');
};
websocket '/echo-socket' => sub {
    my $self = shift;
    $self->on(
        json => sub {
            my ($self, $hash) = @_;
            $hash->{msg} = "echo: $hash->{msg}";
            $self->send({ json => $hash });
        }
    );
};

app->start;
