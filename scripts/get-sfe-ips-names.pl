#!/usr/bin/perl
use v5.12;

my @lines = `grep -i ips_package_name *.spec encumbered/*.spec`;

for (@lines) {
    m{^(SFE[a-zA-Z_0-9\-]+\.spec):\w+:\s+(\S+)\n};
    printf "%-50s %s\n", $2, $1;
}
