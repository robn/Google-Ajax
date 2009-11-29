package Google::Ajax;

use warnings;
use strict;

use base qw(Class::Accessor);
__PACKAGE__->follow_best_practice;
__PACKAGE__->mk_ro_accessors(qw(service service_url mech));

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
            can      => qw(set_application login),
        },
        mech => {
            isa      => "WWW::Mechanize",
            optional => 1,
        },
    });

    my $self = bless \%args, $class;

    if (!exists $self->{mech}) {
        $self->{mech} = WWW::Mechanize->new;
    }

    if (!$self->{mech}->default_header("User-Agent")) {
        $self->{mech}->default_header("User-Agent" => "Mozilla/5.0 (compatible; Google::Ajax/$VERSION)");
    }

    $self->{auth}->set_application($self);

    return $self;
}

sub login {
    my $self = shift;

    return $self->{auth}->login;
}

1;
