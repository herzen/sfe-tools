#!/usr/bin/perl
use v5.16;

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
my @filtered = grep (/-r\Z/, @lines);
my $max_length = 0;

printf ("Number of renamed packages: %d\n\n", scalar(@filtered));

foreach(@filtered) {
    (my $old_name) = $_ =~ /\A([^:\s]+)/;
    my $new_name = &get_new_name($old_name);
    my $length = length($old_name);
    if ($length > $max_length) { $max_length = $length; }
}

say "\nMax old name length: $max_length";

sub get_new_name {
    my $info = `pkg info -r $_[0]`;
    $info =~ m{Renamed to: (?|(\S+)@|\S+\n\s*pkg:/(\S+)@)};
    $1;
}
