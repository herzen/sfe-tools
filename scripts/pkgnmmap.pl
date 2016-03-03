#!/usr/bin/perl
use v5.10;

use constant PKGBUILD_ROOT => '/opt/dtbld/';
use lib PKGBUILD_ROOT . 'lib/pkgbuild-1.3.105';

# These are defined in spectool.pl.  Defining them here does not affect that,
# unless we make these "our" variables.
#my $build_engine = PKGBUILD_ROOT . 'bin/pkgbuild';
#my $_pkgbuild_path = PKGBUILD_ROOT . 'lib/pkgbuild-1.3.105';

# Setting this variable inhibits init and main being called in spectool.pl
our $run_from_pkgnmmap = 1;
require 'spectool.pl';


sub mymain {
    process_defaults ();

    read_spec("pkgnmmap_pnm.spec");

    process_specs ();
    do_get_buildrequires ();

    exit ($exit_val);
}

# Ignore any arguments that were supplied on the command line for now
#$pkgbuild_path = shift (@ARGV);

init;
mymain;
