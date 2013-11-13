#!/usr/bin/perl
use v5.12;

=pod
print_distro_differences.pl
    distro1_mapping_filename distro2_mapping_filename differences_report_filename

Read in old to new name mappings of both distros
For both disros, create both an array of old names and a dictionary
    of the mapping
Merge the arrays to get an array of old names defined in either or both distros
Filter his array to get two new arrays:
    @packages_distros_same and @packages_distros_different
Print out the old and new names of packages that are handled the same
Do the same where they are different, printing new name used by each distro
Print out these totals: distros_same, distros_different, renamed for both
    distros, obsolete for both distros
Print date
=cut


my $distro1_renames; my $distro2_renames; my @all_pkgs;

{
    (my $distro1_pkgs, $distro1_renames) = process_mapping_file($ARGV[0]);
    (my $distro2_pkgs, $distro2_renames) = process_mapping_file($ARGV[1]);
    my %union; my $e;
    foreach $e (@$distro1_pkgs) { $union{$e} = 1 }
    foreach $e (@$distro2_pkgs) { $union{$e} = 1 }
    @all_pkgs = keys %union;
}

my @identical_renames; my @differing_renames; my $p;

foreach $p (@all_pkgs) {
    my $s1 = $distro1_renames->{$p}; my $s2 = $distro2_renames->{$p};
    if ($s1 eq $s2) {
# The following doesn't work for some odd reason
#    if ($distro2_renames->{$p} eq $distro1_renames>{$p}) {
	push @identical_renames, ($p)
    }
    else { push @differing_renames, ($p) }
}

say "Packages for which both distributions give the same new name:\n";
foreach $p (@identical_renames) { printf "%-30s%s\n", $p, $distro1_renames->{$p}; }

say "\nPackages which are given a different new name:\n";
foreach $p (@differing_renames) {
#    printf "%-20s%30s %s\n", $p, $distro1_renames->{$p}, $distro2_renames->{$p};
    printf "%-30s %-40s %s\n", $p, $distro1_renames->{$p}, $distro2_renames->{$p};
#    printf "%s %s %s\n", $p, $distro1_renames->{$p}, $distro2_renames->{$p};
}

print "\n";
printf "Packages renamed identically by the two distributions: %d\n",
    scalar(@identical_renames);
printf "Packages not renamed identically: %d\n", scalar(@differing_renames);


sub process_mapping_file {
    my @pkgs; my %mapping;
    open PKGS, "<$_[0]" or die $!;
    while (my $line = <PKGS>) {
	my ($old_name, $new_name) = split(/\s+/, $line);
	push @pkgs, $old_name;
	$mapping{$old_name} = $new_name;
    }
    close PKGS;
    (\@pkgs, \%mapping)
}
