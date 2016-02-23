#!/usr/bin/perl
use v5.12;

=pod
Get list of all package name macros referred to by BuildRequires in all
SFE specs, removing the leading "pnm_buildrequires_" from the symbols.
=cut

my @matches = `ggrep '^BuildRequires:[[:space:]]\\+%{pnm_' *.spec encumbered/*.spec`;
my %pkg_names;

for (@matches) {
    /%{pnm_buildrequires_(\w+)}/;
    $pkg_names{$1} = undef;
}

for (sort keys %pkg_names) { say $_ }
