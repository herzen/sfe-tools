#!/usr/bin/perl
use v5.10;

use constant PKGBUILD_ROOT => '/opt/dtbld/';
use lib PKGBUILD_ROOT . 'lib/pkgbuild-1.3.105';

our @specs = ();

# Setting this variable inhibits init and main being called in spectool.pl
our $run_from_pkgnmmap = 1;
require 'spectool.pl';

sub get_buildrequires () {
    my $spec = $specs[0];
    if (defined $spec->{error}) {
	msg_error ($spec->get_base_file_name () . ": " . $spec->{error});
	$exit_val++;
    } else {
	my @pkgs = $spec->get_packages ();
	my @buildreqs = ();
	my $pkg = $pkgs[0];
	my @pkg_breqs = $pkg->get_array ('buildrequires');
	if (@pkg_breqs) {
	    push(@buildreqs, @pkg_breqs);
	}
	for (@buildreqs) { say $_ ; }
    }
}

sub mymain {
    process_defaults ();

    read_spec("pkgnmmap.pnms");

    process_specs ();
    get_buildrequires ();

    exit ($exit_val);
}

init;
mymain;
