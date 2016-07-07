#!/usr/bin/perl

print "%include packagenamemacros.inc\n";

while (<>) {
    chomp;
    print "BuildRequires: %{pnm_buildrequires_", $_, "}\n";
}
