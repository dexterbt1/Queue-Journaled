package Queue::Persistent::Item;
use strict;
use Carp ();

sub new {
    my ($class, %args) = @_;
    my $self = bless(\%args, $class);
    (exists $args{data})
        or Carp::croak("expected 'data' parameter");
    return $self;
}


sub pack {
    my ($self) = @_;
    $self->{data};
}


1;

__END__
