#!/bin/env perl

use strict;
use warnings;
use Net::Pcap::Easy;
 
die "You must be root to run this script\n" if $> != 0;

my $npe = Net::Pcap::Easy->new(
    dev              => "lo",
    filter           => "host 127.0.0.1 and tcp",
    packets_per_loop => 10,
    bytes_to_capture => 1024,
    promiscuous      => 1, # true or false
 
    # call this sub on each tcp packet
    tcp_callback => sub {
        my ($npe, $ether, $ip, $tcp, $header ) = @_;
        my $xmit = localtime( $header->{tv_sec} );
        chomp $tcp->{data};
        
        # print the info of the packet if it matches /hack/
        # case insensitive
        print "$xmit TCP: $ip->{src_ip}:$tcp->{src_port}"
         . " -> $ip->{dest_ip}:$tcp->{dest_port}\n"
         . ($tcp->{data} ? "=> $tcp->{data}\n":"") if $tcp->{data} =~ /hack/i;
    },
);
 
print 'Capturing on ' . $npe->dev . "\n";

1 while $npe->loop;

END{ if($npe) {$npe->close, print "\rbye :)\n"}};
