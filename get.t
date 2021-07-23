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
				 PeerPort => 11500,
				 Proto => "tcp",
				 Type => SOCK_STREAM)
			 	or die "connect failed";

my $cmd;
my $val;
my $rst;
my $key;

# KEY_MAX_LENGTH = 32000: long key test
$key = "B" x 32000;
mem_cmd_is($sock, "get $key $key $key", "", "END");

# after test
close($sock);
