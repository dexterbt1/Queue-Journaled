use strict;
use Test::More qw/no_plan/;
use Test::Exception;
use File::Spec;

BEGIN {
    use_ok 'Queue::Persistent';
}

my $journal_filename = File::Spec->catdir(File::Spec->tmpdir, $$.'.aof'),
my $q;

$q = Queue::Persistent->new( journal_filename => $journal_filename );

can_ok $q, 'enqueue', 'dequeue';

ok not(defined $q->dequeue);

dies_ok { $q->enqueue(); } 'empty enqueue';
lives_ok { $q->enqueue('hello'); } 'hello';


ok 1;

END {
    if (-e $journal_filename) { unlink $journal_filename; }
}

__END__
