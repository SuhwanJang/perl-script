#!/usr/bin/perl

use strict;
use IO::Socket;
use Test::More tests => 212;
use FindBin qw($Bin);
use lib "$Bin/lib";
use MemcachedTest;

my $engine = shift;
#my $server = get_memcached($engine);
my $sock = IO::Socket::INET->new(PeerAddr => 'localhost',
				 PeerPort => 6379,
				 Proto => "tcp",
				 Type => SOCK_STREAM)
			 	or die "connect failed";

my $cmd;
my $val;
my $rst;
my @source;

sub array_diff(\@\@) {
        my %e = map { $_ => undef } @{$_[1]};
        return @{[ ( grep { (exists $e{$_}) ? ( delete $e{$_} ) : ( 1 ) } @{ $_[0] } ), keys %e ] };
}

sub do_item_prepare {
    my $i;
    for ($i = 0; $i < 100000; $i += 1) {
        my $val   = "value_$i";
        my $vleng = length($val);
        $cmd = "set $i*$i*$i 0 0 $vleng"; $rst = "STORED";
        #mem_cmd_is($sock, $cmd, $val, $rst);
        push(@source, "$i*$i*$i"); 
    }
}

sub do_scan {
    my $line;
    my $resp = "";

    my $pat = "\\\\\\\\";
    my $cmd = "keyscan 0 count 400 match $pat";
    my @key_array = ();
    my @resp;
    my $key;
    my $keycount;
    my $cursor;
    my $len;
    while (1) {
        print $sock "$cmd\r\n";
        $line = scalar <$sock>;
        #print "$cmd $line\n";
        @resp = split ' ', $line;
        $keycount = $resp[1];
        $cursor = $resp[2];
        while (1) {
            #print "$cursor\n";
            $line = scalar <$sock>;
            if ($line =~ /^END/) {
                last;
            }
            #print $line;
            push(@key_array, (substr $line, 0, length($line)-2));
        }
        $cmd = "keyscan $cursor count 400 match $pat";
        if ($cursor eq "0") {
            print "end\n";
            last;
        }
    }
    my @diff = array_diff(@key_array, @source);
    my $length = scalar @key_array;
    #print "$length\n";
    foreach (@diff) {
        #print "DIFFERENCE !!  key = $_ ";
    }
}


# KEY_MAX_LENGTH = 250
do_item_prepare();
do_scan();

#$key = "B" x 250;
#do_btree_prepare($key);
#do_btree_efilter($key);

#mem_cmd_is($sock, "delete $key", "", "DELETED");

# KEY_MAX_LENGTH = 32000: long key test
#$key = "B" x 32000;
#do_btree_prepare($key);
#do_btree_efilter($key);
#mem_cmd_is($sock, "delete $key", "", "DELETED");

# after test
close($sock);
