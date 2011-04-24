package Queue::Persistent;
use strict;
use warnings;
use File::Spec;
use Carp ();
use Queue::Persistent::Item;

sub new {
    my ($class, %args) = @_;
    my $self = bless(\%args, $class);
    $self->BUILD(%args);
    return $self;
}

sub BUILD {
    my ($self, %args) = @_;
    $self->{_q} = [ ];
    $self->{_size_bytes} = [ ];
}


sub enqueue {
    my ($self, %args) = @_;
    (exists $args{data})
        or Carp::croak("enqueue expects 'data' parameter");
    my $i = Queue::Persistent::Item->new(
        data => $args{data},
    );
    no warnings 'uninitialized';
    $self->{_size_bytes} += length($args{data});
    push @{$self->{_q}}, $i;
}


sub dequeue {
    my ($self, %args) = @_;
    return shift(@{$self->{_q}});
}


1;

__END__ 
