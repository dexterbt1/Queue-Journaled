package Queue::Persistent::Journal;
use strict;
use warnings;
use IO::File;
use File::Spec;
use Carp ();
use Sub::Exporter -setup => {
    exports => [ qw/ CMD_ADD CMD_REMOVE / ],
};

sub CMD_ADD                 { 0x0100 }
sub CMD_REMOVE              { 0x0102 }

# ---

sub new {
    my ($class, %args) = @_;
    my $self = bless(\%args, $class);
    (defined $args{filename})
        or Carp::croak("new() expects 'filename' parameter");
    # TODO: replay logs
    $self->recreate;
    return $self;
}

sub recreate {
    my ($self) = @_;
    my $fh = IO::File->new($self->{filename}, ">")
        or Carp::croak("Unable to open journal file: $!");
    $fh->binmode(":utf8");
    $self->{_fh} = $fh;
}

sub fh { 
    return $_[0]->{_fh};
}

sub add {
    my ($self, $item_data) = @_;
    syswrite($self->{_fh}, pack("N", CMD_ADD), 4);
    syswrite($self->{_fh}, pack("N", length($item_data)), 4);
    syswrite($self->{_fh}, $item_data, length($item_data));
}

sub remove {
    my ($self, $item) = @_;
    syswrite($self->{_fh}, pack("N", CMD_REMOVE), 4);
}


sub replay_file {
    my ($class, $file, $cb) = @_;
    open my $fh, "<:utf8", $file
        or Carp::croak("Unable to open journal file for reading: $!");
    binmode($fh);
    while (1) {
        my $d;
        my @cb_args = ();
        # TODO: error checking
        read($fh, $d, 4)
            or last;
        my $cmd = unpack("N", $d);
        if ($cmd eq CMD_ADD) {
            read($fh, $d, 4)
                or last;
            my $data_length = unpack("N", $d);
            $d = '';
            if ($data_length > 0) {
                read($fh, $d, $data_length)
                    or last;
            }
            push @cb_args, $d;
        }
        elsif ($cmd eq CMD_REMOVE) {
        }
        
        $cb->($cmd, @cb_args);

    }
}


1;

__END__
