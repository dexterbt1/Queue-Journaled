package Queue::Persistent::Item;
use strict;

sub new {
    my ($class, %args) = @_;
    my $self = bless(\%args, $class);
    return $self;
}


1;

__END__
