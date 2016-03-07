#!/usr/bin/perl
use v5.12;

=pod
Get list of all package name macros referred to by BuildRequires in all
SFE specs, removing the leading "pnm_buildrequires_" from the symbols.
=cut

my @matches = `ggrep '^\\(Build\\)\\?Requires:[[:space:]]\\+%{pnm_' *.spec encumbered/*.spec`;
my %pkg_names;

for (@matches) {
    # Most of these start with "pnm_buildrequires_".
    # Do not treat ones that start with "pnm_requires_" differently.
    if (/%{pnm_(?:build)?requires_(\w+)}/) {
	$pkg_names{$1} = undef;
    } else {
	die "Symbol does not start with \"pnm_(build)requires_\": $_";
    }
}

for (sort keys %pkg_names) { say $_ }
