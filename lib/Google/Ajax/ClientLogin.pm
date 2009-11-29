package Google::Ajax::ClientLogin;

use warnings;
use strict;

use Params::Validate qw(validate validate_pos SCALAR);

sub new {
    my $class = shift;

    my %args = validate(@_, {
        email => {
            type => SCALAR,
        },
        password => {
            type => SCALAR,
        },
    });

    my $self = \%args;

    return bless $self, $class;
}

sub set_application {
    my $self = shift;

    my @args = validate_pos(@_,
        { isa => "Google::Ajax" },
    );

    $self->{app} = shift @args;

    return;
}

sub login {
    my $self = shift;

    $self->{app}->get_mech->post("https://www.google.com/accounts/ClientLogin", {
                                 Email       => $self->{email},
                                 Passwd      => $self->{password},
                                 accountType => "HOSTED",
                                 service     => "apps",
    });

    # XXX error check

    my ($token) = $self->{app}->get_mech->content =~ m/^Auth=(.+?)$/mg;
    $self->{app}->get_mech->default_header("Authorization" => "GoogleLogin auth=$token");
   
    $self->{app}->get_mech->get($self->{app}->get_service_url);

    # XXX error check

    return;
}

1;
