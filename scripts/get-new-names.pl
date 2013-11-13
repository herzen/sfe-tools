#!/usr/bin/perl
use v5.12;

=pod
Get list of all packages using pkg(1).
Filter out packages that have not been renamed
Strip the lines down to a string just containing the package name
For each SUNW package name
  run "pkg info -r <name>"
  get the new name from the output
  print the old and new names
=cut

my @lines = `pkg list -n SUNW\*`;
my @filtered = grep (/-[ro]\Z/, @lines);
my $count = 0;

printf ("Number of renamed or obsolete packages: %d\n\n", scalar(@filtered));
open FILE, ">$ARGV[0]" or die $!;

foreach(@filtered) {
    (my $old_name) = $_ =~ /\A([^:\s]+)/;
    my $new_name = get_new_name($old_name);
    printf (FILE "%-30s %s\n", $old_name, $new_name);
    $count = $count + 1;
    printf ("%5d", $count);
    if ($count % 15 == 0) { print "\n"; }
}

close FILE;


sub get_new_name {
    my $info;

    # OpenIndiana's pkg server sometimes produces the error
    # pkg: http protocol error: code: 503 reason: Service Unavailable
    while (1) {
	$info = `pkg info -r $_[0]`;
	unless ($?) { last; }
	say "Retrying...";
	sleep 5;
    }

    $info =~ m{(?|(\(Obsolete\))\n|Renamed to: (?|(\S+)@|\S+\n\s*pkg:/(\S+)@|\S+\n\s*(\S+)@|\S+\n\s*pkg:/(\S+)\n|s*pkg:/(\S+)\n|\S+\n\s*(\S+)\n))};
    $1;
}
