#!/usr/bin/perl
use v5.12;

my $distro1 = "OpenIndiana Hipster";
my $distro2 = "Solaris 11.1";

=pod
print_distro_differences.pl
    distro1_mapping_filename distro2_mapping_filename differences_report_filename

Print the date
Read in old to new name mappings of both distros
For both disros, create both an array of old names and a dictionary
    of the mapping
Merge the arrays to get an array of old names defined in either or both distros
Filter this array to get two new arrays:
    @identical_renames and @differing_renames
Print out the old and new names of packages that are handled the same
Do the same where they are different, printing new name used by each distro
Print out these totals: distros_same, distros_different, renamed for both
    distros, obsolete for both distros
=cut

printf "%s\n\n", `date -u`;


my $distro1_renames; my $distro2_renames; my @all_pkgs;
my $p;

{
    (my $distro1_pkgs, $distro1_renames) = process_mapping_file($ARGV[0]);
    (my $distro2_pkgs, $distro2_renames) = process_mapping_file($ARGV[1]);
    my %union;
    foreach $p (@$distro1_pkgs) { $union{$p} = 1 }
    foreach $p (@$distro2_pkgs) { $union{$p} = 1 }
    @all_pkgs = keys %union;
}

my @identical_renames; my @differing_renames;
my @distro1_obsoleted; my @distro2_obsoleted; my @not_obsoleted;
my @distro1_unknown; my @distro2_unknown;

foreach $p (@all_pkgs) {
    my $s1 = $distro1_renames->{$p}; my $s2 = $distro2_renames->{$p};
    if ($s1 eq $s2) {
# The following doesn't work for some odd reason
#   if ($distro2_renames->{$p} eq $distro1_renames>{$p}) {
	push @identical_renames, $p
    }
    else { push @differing_renames, $p }
}

foreach $p (@differing_renames) {
    if ($distro1_renames->{$p} eq "(Obsolete)") {
	push @distro1_obsoleted, $p;
    } elsif ($distro2_renames->{$p} eq "(Obsolete)") {
	push @distro2_obsoleted, $p;
    } elsif ($distro1_renames->{$p} eq "") {
	push @distro1_unknown, $p;
    } elsif ($distro2_renames->{$p} eq "") {
	push @distro2_unknown, $p;
    } else {
	push @not_obsoleted, $p;
    }
}

say "Packages for which both distributions give the same new name:\n";
foreach $p (@identical_renames) { printf "%-29s %s\n", $p, $distro1_renames->{$p}; }

say "\nPackages which are obsoleted by $distro1 but not by $distro2:\n";
foreach $p (@distro1_obsoleted) { say $p }
say "\nPackages which are obsoleted by $distro2 but not by $distro1:\n";
foreach $p (@distro2_obsoleted) { say $p }
say "\nPackages which are obsoleted by $distro1 but unknown to $distro2:\n";
foreach $p (@distro1_unknown) { say $p }
say "\nPackages which are obsoleted by $distro2 but unknown to $distro1:\n";
foreach $p (@distro2_unknown) { say $p }

say "\nPackages which are given a different new name by the two distributions:\n";
foreach $p (@not_obsoleted) {
    printf "%-24s %-28s %s\n", $p, $distro1_renames->{$p}, $distro2_renames->{$p};
}

printf "\n\nSUNW packages marked as renamed or deleted identified on either distribution:  %u\n",
    scalar(@all_pkgs);
printf "Packages renamed identically by the two distributions (including obsoletions): %u\n",
    scalar(@identical_renames);
printf "Packages renamed differently by the two distributions: %28u\n", scalar(@differing_renames);
printf "Packages obsoleted by $distro1 but not by $distro2: %d\n",
    scalar(@distro1_obsoleted);
printf "Packages obsoleted by $distro2 but not by $distro1: %d\n",
    scalar(@distro2_obsoleted);
printf "Packages renamed by $distro1 but unknown to $distro2: %d\n",
    scalar(@distro2_unknown);
printf "Packages renamed by $distro2 but unknown to $distro1: %d\n",
    scalar(@distro1_unknown);
printf "Packages renamed differently, obsoleted by neither distribution, and known to both: %d\n",
    scalar(@not_obsoleted);


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
