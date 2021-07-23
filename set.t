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
				 PeerPort => 11555,
				 Proto => "tcp",
				 Type => SOCK_STREAM)
			 	or die "connect failed";

my $cmd;
my $val;
my $rst;
my $key;

$cmd = "set foo 0 0 6"; $val = "fooval"; $rst = "STORED";
mem_cmd_is($sock, $cmd, $val, $rst);

$cmd = "set foo1 0 0 6"; $val = "fooval"; $rst = "STORED";
mem_cmd_is($sock, $cmd, $val, $rst);

$cmd = "set foo2 0 0 6"; $val = "fooval"; $rst = "STORED";
mem_cmd_is($sock, $cmd, $val, $rst);

$cmd = "set foo3 0 0 6"; $val = "fooval"; $rst = "STORED";
mem_cmd_is($sock, $cmd, $val, $rst);

$cmd = "set foo4 0 0 6"; $val = "fooval"; $rst = "STORED";
mem_cmd_is($sock, $cmd, $val, $rst);

$cmd = "set foo5 0 0 6"; $val = "fooval"; $rst = "STORED";
mem_cmd_is($sock, $cmd, $val, $rst);

$cmd = "set foo6 0 0 6"; $val = "fooval"; $rst = "STORED";
mem_cmd_is($sock, $cmd, $val, $rst);

$cmd = "set foo7 0 0 6"; $val = "fooval"; $rst = "STORED";
mem_cmd_is($sock, $cmd, $val, $rst);


# after test
close($sock);
