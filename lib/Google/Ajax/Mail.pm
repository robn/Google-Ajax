package Google::Ajax::Mail;

use warnings;
use strict;

use Params::Validate qw(validate_pos SCALAR);

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

sub _fetch_and_update {
}

sub _get_cached_data {
}

sub get_usage {
    my $self = shift;

    return $self->_get_cached_data("qu")->[0];
}

sub get_quota {
    my $self = shift;

    return $self->_get_cached_data("qu")->[1];
}

sub get_unread {
    my $self = shift;

    my ($label) = validate_pos(@_,
        { type => SCALAR },
    );

    my $label_data = $self->_get_cached_data("ds");
    for my $item (@$label_data) {
        return $item->[1] if $item->[0] eq $label;
    }

    return;
}

1;
