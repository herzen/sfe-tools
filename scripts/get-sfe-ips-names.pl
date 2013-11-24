#!/usr/bin/perl
use v5.12;

for ( `grep -i '^ips_package_name' *.spec encumbered/*.spec` ) {
    m{(SFE[a-zA-Z_0-9\-\.]+\.spec):\w+:\s+(\S+)\s+};
    printf "%-50s %s\n", $2, $1;
}
