#!/usr/bin/perl

=pod

Delete "%include packagenamemacros.inc" and "%include osdistro.inc".

change
    BuildRequires:  %{pnm_buildrequires_SUNWzlib}
    Requires:       %{pnm_requires_SUNWzlib}
to
    (Build)RequiresM:  SUNWzlib
=cut

$^I = "";

while (<>) {
    s/^%include\s+(packagenamemacros|osdistro)\.inc.*\n//;
    s/^(Build)?Requires:(\s+)%{pnm_(?:build)?requires_(\w+)}/$1Requires:$2$3/;
    print;
}
