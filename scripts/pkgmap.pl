use v5.12;
use autodie;
use YAML::XS;

my $csv_filename = '../data/mapping.csv';
my $yaml_filename = '../data/mapping.yaml';
my @col_titles;
my %mappings;
my $monopkgs = 0;
my $multipkgs = 0;
my $distro_names;
my $mappings;
# We will need to compute this
my $distro_num = 0;

sub read_csv_file {
    open CSVS, '<', shift;
    my $line = <CSVS>;
    chomp $line;
    @col_titles = split /,/, $line;
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
    print YAMLS Dump( \@col_titles, \%mappings );
}

sub distro_pkgname {
    my $key = shift;
    read_yaml_file();
    my $symb = $mappings->{$key};
    say ref $symb ? $symb->[$distro_num] : $symb;
}


sub read_yaml_file {
    my $data;
    $data = do {
	if( open my $fh, '<', $yaml_filename) { local $/; <$fh> }
	else { undef }
    };
    ( $distro_names, $mappings ) = Load( $data );
}

sub dump_keys {
    read_yaml_file ();
    print "@$distro_names\n";
    print keys %$mappings, "\n";
}

# This file can be called with:
#create_yaml_file();
#dump_keys();
#distro_pkgname(<key>);
