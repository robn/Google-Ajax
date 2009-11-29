package Google::Ajax::SSO;

use warnings;
use strict;

use Params::Validate qw(validate validate_pos SCALAR);
use Google::SAML::Request;
use Google::SAML::Response;
use URI::Escape;

sub new {
    my $class = shift;

    my %args = validate(@_, {
        user => {
            type => SCALAR,
        },
        domain => {
            type => SCALAR,
        },
        key => {
            type => SCALAR,
            callbacks => {
                "key file exists and is readable" => sub { -r $_[0] },
            },
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

    my $saml_request = Google::SAML::Request->new({
        'ProviderName'                => "google.com/a/$self->{domain}",
        'AssertionConsumerServiceURL' => "https://www.google.com/a/$self->{domain}/acs",
    });

    my $relay_state = "https://www.google.com/a/$self->{domain}/ServiceLogin?" . join("&",
                        "service=".$self->{app}->get_service,
                        "passive=true",
                        "rm=false",
                        "continue=".$self->{app}->get_service_url,
                      );

    my $saml_response = Google::SAML::Response->new({
        'key'     => $self->{key},
        'login'   => $self->{username},
        'request' => uri_unescape($saml_request->get_get_param()),
    });

    $self->get_mech->post($saml_response->{service_url},
        Content => {
            SAMLResponse => $saml_response->get_response_xml,
            RelayState => $relay_state,
        },
    );

    $self->get_mech->get($self->{app}->get_service_url);
   
    return;
}

1;
