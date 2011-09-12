package Queue::Journaled;
use strict;
use Carp ();
use Queue::Journaled::Journal '-all';

sub new {
    my ($class, %args) = @_;
    my $self = bless(\%args, $class);

    (defined $args{journal_filename})
        or Carp::croak("expected 'journal_filename' parameter");

    $self->{_q} = [ ];

    if (-e $args{journal_filename}) {
        print STDERR "replaying journal ...";
        my $replayed_ops = 0;
        Queue::Journaled::Journal->replay_file( 
            $args{journal_filename},
            sub {
                my ($cmd, $i) = @_;
                if ($cmd == Queue::Journaled::Journal::CMD_ADD) {
                    $self->_enqueue($i);
                }
                elsif ($cmd == Queue::Journaled::Journal::CMD_REMOVE) {
                    $self->_dequeue($i);
                }
                $replayed_ops++;
            },
        );
        print STDERR $replayed_ops," operations\n";
    }
    $self->{_journal} = Queue::Journaled::Journal->new( filename => $args{journal_filename} );
    return $self;
}


sub items_count {
    my ($self) = @_;
    return (scalar @{$self->{_q}});
}


sub enqueue {
    my ($self, $i) = @_;
    (defined $i)
        or Carp::croak("enqueue() expects defined parameter");
    # TODO: check memory limit
    $self->{_journal}->add($i);
    $self->_enqueue($i);
}


sub _enqueue {
    my ($self, $i) = @_;
    push @{$self->{_q}}, $i;
}


sub dequeue {
    my ($self) = @_;
    # TODO: check rotate journal
    if (scalar @{$self->{_q}} > 0) {
        $self->{_journal}->remove;
    }
    return $self->_dequeue;
}

sub _dequeue {
    my ($self) = @_;
    my $i = shift(@{$self->{_q}});
    return $i;
}


1;

__END__ 
