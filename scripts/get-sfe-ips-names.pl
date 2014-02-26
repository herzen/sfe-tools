#!/usr/bin/perl
use v5.12;

=pod
This script goes through SFE spec files and, if they declare an IPS package
name, prints out that name preceded by the old SFE package name.
It expects to be run in the SFE directory.
=cut

my @matches =  `grep -i '^ips_package_name' *.spec encumbered/*.spec`;
my @spec_names = map {m|([a-zA-Z_0-9\-\./]+\.spec):|; $1} @matches;

unshift @INC, "/usr/lib/pkgbuild-1.3.105";
require "spectool.pl";
process_defaults ();
for my $spec_name (@spec_names) { read_spec ($spec_name); }

do_get_package_names ();
