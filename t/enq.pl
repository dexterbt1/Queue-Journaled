#!/usr/bin/perl
use strict;
use Queue::Persistent;
my $q = Queue::Persistent->new(
    path => '/home/dexter/tmp/q',
    name => 'foo',
);
$q->enqueue( data => 'hello' );

my $item = $q->dequeue;
print STDERR $item->{data},"\n";

__END__
