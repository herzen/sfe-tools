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
    @identical_renames and @handled_differently
Print out the old and new names of packages that are handled in the same way
Do the same where they are different, printing new name used by each distro
Print out the totals

For each distro, there are three possibilities for its stance on a given package:
    renamed, obsoleted, and unknown.  This means that there are seven possibilities
    for packages that are handled differently by the two distributions: their using
    a different new name, and six others.  The cases are:

renamed/renamed		Two possibilities: renamed the same, or differently
renamed/obsoleted
renamed/unknown
obsoleted/renamed
obsoleted/obsoleted	Not a separate category: belongs with renamed the same
obsoleted/unknown
unknown/renamed
unknown/obsoleted
unknown/unknown		This would not end up in @all_pkgs
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

my @identical_renames; my @handled_differently;

foreach $p (@all_pkgs) {
    my $s1 = $distro1_renames->{$p}; my $s2 = $distro2_renames->{$p};
    if ($s1 eq $s2) {
# The following doesn't work for some odd reason
#   if ($distro2_renames->{$p} eq $distro1_renames>{$p}) {
	push @identical_renames, $p
    }
    else { push @handled_differently, $p }
}

my @renamed_obsoleted; my @renamed_unknown; my @obsoleted_renamed;
my @obsoleted_unknown; my @unknown_renamed; my @unknown_obsoleted;
my @differing_renames;

foreach $p (@handled_differently) {
    if ($distro1_renames->{$p} eq "(Obsolete)") {
	if ($distro2_renames->{$p} eq "") { push @obsoleted_unknown, $p }
	else { push @obsoleted_renamed, $p }
    } elsif ($distro1_renames->{$p} eq "") {
	if ($distro2_renames->{$p} eq "(Obsolete)") { push @unknown_obsoleted, $p }
	else { push @unknown_renamed, $p }
    } else {
	if ($distro2_renames->{$p} eq "(Obsolete)") { push @renamed_obsoleted, $p }
	elsif ($distro2_renames->{$p} eq "") { push @renamed_unknown, $p }
	else { push @differing_renames, $p; }
    }
}

say "Packages to which both distributions give the same new name:\n";
foreach $p (@identical_renames) { printf "%-29s %s\n", $p, $distro1_renames->{$p}; }

say "\nPackages which are renamed by $distro1 but are obsoleted by $distro2:\n";
foreach $p (@renamed_obsoleted) { say $p }
say "\nPackages which are renamed by $distro1 but are unknown to $distro2:\n";
foreach $p (@renamed_unknown) { say $p }
say "\nPackages which are obsoleted by $distro1 but are renamed by $distro2:\n";
foreach $p (@obsoleted_renamed) { say $p }
if (scalar(@obsoleted_unknown) > 0) {
    say "\nPackages which are obsoleted by $distro1 but unknown to $distro2:\n";
    foreach $p (@obsoleted_unknown) { say $p }
}
say "\nPackages which are unknown to $distro1 but are renamed by $distro2:\n";
foreach $p (@unknown_renamed) { say $p }
say "\nPackages which are unknown to $distro1 but are obsoleted by $distro2:\n";
foreach $p (@unknown_obsoleted) { say $p }

say "\nPackages which are given a different new name by the two distributions:\n";
foreach $p (@differing_renames) {
    printf "%-24s %-28s %s\n", $p, $distro1_renames->{$p}, $distro2_renames->{$p};
}

printf "\n\nSUNW packages marked as renamed or deleted identified on either distribution:  %u\n",
    scalar(@all_pkgs);
printf "Packages renamed identically by the two distributions (including obsoletions): %u\n",
    scalar(@identical_renames);
printf "Packages handled differently by the two distributions: %28u\n", scalar(@handled_differently);

printf "Packages renamed by $distro1 but obsoleted $distro2: %d\n",
    scalar(@renamed_obsoleted);
printf "Packages renamed by $distro1 but unknown to $distro2: %d\n",
    scalar(@renamed_unknown);
printf "Packages obsoleted by $distro1 but renamed by $distro2: %d\n",
    scalar(@obsoleted_renamed);
printf "Packages obsoleted by $distro1 but unknown to $distro2: %d\n",
    scalar(@obsoleted_unknown);
printf "Packages unknown to $distro1 but renamed by $distro2: %d\n",
    scalar(@unknown_renamed);
printf "Packages unknown to $distro1 but obsoleted by $distro2: %d\n",
    scalar(@unknown_obsoleted);

printf "Packages renamed differently, obsoleted by neither distribution, and known to both: %d\n",
    scalar(@differing_renames);


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
