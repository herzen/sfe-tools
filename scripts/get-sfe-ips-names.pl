#!/usr/bin/perl
use v5.12;

=pod
This script goes through SFE spec files and, if they declare an IPS package
name, prints out that name and the old SFE package name.
It expects to be run in the SFE directory.
=cut

for ( `grep -i '^ips_package_name' *.spec encumbered/*.spec` ) {
    m{(SFE[a-zA-Z_0-9\-\.]+)\.spec:\w+:\s+(\S+)\s+};
    printf "%-50s %s\n", $2, $1;
}
