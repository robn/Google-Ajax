package Google::Ajax::Mail;

use warnings;
use strict;

use base qw(Google::Ajax);

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

sub _fetch_data {
    my ($self, %args) = @_;

    $args{ui} = 1 if !exists $args{ui};

    my $mech = $self->get_mech;

    my $query = join '&', map { $_.'='.$args{$_} } keys %args;
    $mech->get($self->get_service_url.'&'.$query);

    # XXX check errors
    
    my $data = {};

    my $content = $mech->content;
    $content =~ m/<!--/sg;
    while ($content =~ m/\G\s*D\((.*?)\);/sg) {
        my $item = $1;
        $item =~ s/([\$\@])/\\$1/mg;
        my $args = eval $item;  # XXX this is just a little too trusting. replace with a real parser
        my $code = shift @$args;
        $data->{$code} = $args;
    }

    return $data;
}

sub _get_cached_data {
    my ($self, $code) = @_;

    # XXX add timestamps to cache and check age
    return $self->{cache}->{$code} if exists $self->{cache}->{$code};

    # XXX set up tables to map return codes to ajax requests
    $self->{cache} = $self->_fetch_data(
        view   => "tl",
        search => "inbox",
    );

    return $self->{cache}->{$code} if exists $self->{cache}->{$code};

    return;
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
