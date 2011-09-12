use strict;
use Test::More qw/no_plan/;
use Test::Exception;
use File::Spec;

BEGIN {
    use_ok 'Queue::Journaled';
}

my $journal_filename = File::Spec->catdir(File::Spec->tmpdir, $$.'.aof'),
my $q;

$q = Queue::Journaled->new( journal_filename => $journal_filename );

is $q->items_count, 0;
$q->enqueue( 'hello' );
$q->enqueue( 'world' );
is $q->items_count, 2;

# simulate crash
undef $q;

$q = Queue::Journaled->new( journal_filename => $journal_filename );
is $q->items_count, 2;
is $q->dequeue, 'hello';
is $q->dequeue, 'world';
is $q->items_count, 0;
is $q->dequeue, undef;


END {
    if (-e $journal_filename) { unlink $journal_filename; }
}

__END__
