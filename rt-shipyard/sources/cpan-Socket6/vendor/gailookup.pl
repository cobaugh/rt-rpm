#! /usr/bin/perl

;# Copyright (C) 2000-2005 Hajimu UMEMOTO <ume@mahoroba.org>.
;# All rights reserved.
;#
;# Copyright (C)2000 Hideaki YOSHIFUJI <yoshfuji@ecei.tohoku.ac.jp>
;# All rights reserved.
;#
;# Redistribution and use in source and binary forms, with or without
;# modification, are permitted provided that the following conditions
;# are met:
;# 1. Redistributions of source code must retain the above copyright
;#    notice, this list of conditions and the following disclaimer.
;# 2. Redistributions in binary form must reproduce the above copyright
;#    notice, this list of conditions and the following disclaimer in the
;#    documentation and/or other materials provided with the distribution.
;# 3. Neither the name of the project nor the names of its contributors
;#    may be used to endorse or promote products derived from this software
;#    without specific prior written permission.
;# 
;# THIS SOFTWARE IS PROVIDED BY THE PROJECT AND CONTRIBUTORS ``AS IS'' AND
;# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
;# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
;# ARE DISCLAIMED.  IN NO EVENT SHALL THE PROJECT OR CONTRIBUTORS BE LIABLE
;# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
;# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
;# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
;# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
;# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
;# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
;# SUCH DAMAGE.

;# $Id: gailookup.pl.in,v 1.12 2005/10/11 06:57:21 ume Exp $

use Getopt::Std;
use Socket;
use Socket6;
use strict;

my $inet6 = defined(eval 'PF_INET6');

my %opt;
getopts(($inet6 ? 'achpsnNqS46' : 'chpsnNqS4'), \%opt);

if ($opt{'h'}){
    print STDERR ("Usage: $0 [-h | [-a] [-c] [-n] [-N] [-p] [-q] [-s] [-S] [-4" .
		  ($inet6 && "|-6") . "] [host [serv]]]\n" .
		  "-h   : help\n" .
		  "-a   : AI_ADDRCONFIG flag\n" .
		  "-c   : AI_CANONNAME flag\n" .
		  "-n   : AI_NUMERICHOST flag\n" .
		  "-N   : AI_NUMERICSERV flag\n" .
		  "-p   : AI_PASSIVE flag\n" .
		  "-q   : only show IP address\n" .
		  "-s   : NI_WITHSCOPEID flag\n" .
		  "-S   : suppress scopeid\n" .
		  ($inet6 ? "-4|-6: PF_INET | PF_INET6" : "-4   : PF_INET") . 
		  "\n");
    exit(4);
}

my $host = shift(@ARGV) if (@ARGV);
my $serv = shift(@ARGV) if (@ARGV);
die("Too many arguments\n") if (@ARGV);
die("Either -4 or -6, not both should be specified\n") if ($opt{'4'} && $opt{'6'});

my $af = PF_UNSPEC;
$af = PF_INET if ($opt{'4'});
$af = PF_INET6 if ($inet6 && $opt{'6'});

my $flags = 0;
eval('$flags |= AI_ADDRCONFIG') if ($opt{'a'});
$flags |= AI_PASSIVE if ($opt{'p'});
$flags |= AI_NUMERICHOST if ($opt{'n'});
$flags |= AI_NUMERICSERV if ($opt{'N'});
$flags |= AI_CANONNAME if ($opt{'c'});

my $nflags = NI_NUMERICHOST | NI_NUMERICSERV;
eval('$nflags |= NI_WITHSCOPEID') if ($opt{'s'});


my $socktype = SOCK_STREAM;
my $protocol = 0;

my @tmp = getaddrinfo($host, $serv, $af, $socktype, $protocol, $flags);
if ($#tmp < 1) {
    print(STDERR "${host}: @tmp[0]\n");
    exit 1;
}
while (my($family,$socktype,$protocol,$sin,$canonname) = splice(@tmp, $[, 5)){
    if ($opt{'S'} && $family == AF_INET6) {
	my($port, $flowinfo, $addr, $scopeid) = unpack_sockaddr_in6_all($sin);
	$sin = pack_sockaddr_in6_all($port, $flowinfo, $addr, 0);
    }
    my($addr, $port) = getnameinfo($sin, $nflags);
    if ($opt{'q'}) {
	print("$addr");
    } else {
	print("family=$family, socktype=$socktype, protocol=$protocol, addr=$addr, port=$port");
	print(" canonname=$canonname") if ($opt{'c'});
    }
    print("\n");
}
