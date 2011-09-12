#!/usr/bin/perl
use strict;
use Data::Dumper;
use Queue::Persistent;

my $q = Queue::Persistent->new(
    journal_filename => "$ENV{HOME}/tmp/q/foo.aof",
);
#sleep 1;
print Dumper($q);
for (1..100) { $q->enqueue($_); }
#$q->enqueue( data => 'world' );
#my $item = $q->dequeue;
#print STDERR $item->{data},"\n";



__END__
