package Google::Ajax;

use warnings;
use strict;

use Params::Validate qw(validate SCALAR);
use WWW::Mechanize;

our $VERSION = "0.01";

sub new {
    my $class = shift;

    my %args = validate(@_, {
        service => {
            type     => SCALAR,
        },
        auth => {
            can      => qw(set_mech login),
        },
        mech => {
            isa      => "WWW::Mechanize",
            optional => 1,
        },
    });

    my $self = \%args;

    if (!exists $self->{mech}) {
        $self->{mech} = WWW::Mechanize->new;
    }

    if (!$self->{mech}->default_header("User-Agent")) {
        $self->{mech}->default_header("User-Agent" => "Mozilla/5.0 (compatible; Google::Ajax/$VERSION)");
    }

    $self->{auth}->set_mech($self->{mech});

    return bless $self, $class;
}

sub login {
    my $self = shift;

    return $self->{auth}->login;
}

1;
