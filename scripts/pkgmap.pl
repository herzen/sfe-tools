#!/usr/bin/perl

use v5.12;
use autodie;
use YAML::XS;

my $csv_filename = '../data/mapping.csv';
my $yaml_filename = '../data/mapping.yaml';
my @col_titles;
my @unames;
my %mappings;
my $monopkgs = 0;
my $multipkgs = 0;

sub read_csv_file {
    open CSVS, '<', shift;
    my $line = <CSVS>;
    chomp $line;
    @col_titles = split /,/, $line;
    chomp ($line = <CSVS>);
    @unames = split /,/, $line;
    # Discard first item of titles lists, which describes what the symbols mean
    shift @col_titles; shift @unames;
    while ($line = <CSVS>) {
	chomp $line;
	my ($key, @list) = split /,/, $line;
	if (members_eq(@list)) {
	    $mappings{$key} = $list[0];
	    $monopkgs++;
	} else {
	    $mappings{$key} = \@list;
	    $multipkgs++;
	}
    }
}

# We are all Haskell programmers now
sub members_eq {
    my ($head, @tail) = @_;
    if (!@tail) {
	return 1;
    }
    elsif ($head ne $tail[0]) {
	return 0;
    }
    else { members_eq (@tail); }
}

sub create_yaml_file {
    read_csv_file ($csv_filename);
    say "$multipkgs packages with different names; $monopkgs with the same name";

    open YAMLS, '>', $yaml_filename;
    print YAMLS Dump( \@col_titles, \@unames, \%mappings );
}

create_yaml_file();
