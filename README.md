# pids
a (not really) IDS made in Perl that triggers when a tcp pkt contains /hack/i

## what does it do
Simply listening on `lo` interface 'loopback' and print a packet if it
match `/hack/i` (case insensitive).

> must be run as root
