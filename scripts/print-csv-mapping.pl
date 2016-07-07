#!/usr/bin/perl
use v5.12;
use autodie;

=pod

Read files, each containing package names, and merge the same line from each
file into one file with comma-separated columns.

Read each input file into an array, with refs to these arrays kept in a list.

The data is represented as an array of arrays, so the mappings for each pn
symbol can be printed as one array.
=cut

my @distros = qw( PNsymbol S11.3 OIhipster OmniOS );
my @uname_ver_regexs = qw( uname 11.3 illumos- omnios- );
my @input_file_names = ( '../data/pnm.list', '../../s11.result',
			 '../../oi.result', '../../omnios.result' );
my @pkgname_arrays = ();
my $filenum = 0;

for my $filename (@input_file_names) {
    my $i = 0;
    open NAMES, '<', $filename;
    for (<NAMES>) {
	chomp $_;
#	spectool returns what was given to Requires if it can't find a match
	$pkgname_arrays[$i++][$filenum] = /^%{pnm/ ? '__NOMATCH__' : $_ ;
    }
    $filenum++;
}

say join ',', @distros;
say join ',', @uname_ver_regexs;

for my $pkg (@pkgname_arrays) {
    say join ',', @$pkg;
}
