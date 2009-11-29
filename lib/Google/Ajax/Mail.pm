package Google::Ajax::Mail;

use warnings;
use strict;

sub get_service {
    return "mail";
}

sub get_service_url {
    my $self = shift;

    if ($self->{domain}) {
        return "https://mail.google.com/a/$self->{domain}";
    }

    # XXX check this
    return "https://mail.google.com/";
}

1;
