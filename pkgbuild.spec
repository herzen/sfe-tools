# To build, enter the directory containing this file (sfe-tools/pkgbuild)
# and give this command:
#	pkgtool build-only --download --patches=. pkgbuild.spec
# After that, install with
#	pkg uninstall pkgbuild
#	pkg install pkg://<your repository name>/package/pkgbuild
# This assumes that you already have pkgbuild installed and have a build
# environment and a local IPS repository set up.

# Vanilla pkgbuild.spec's default install prefix is /opt/pkgbuild.
# We follow the SFE convention of installing in /usr.
# Use pkgbuild --define 'pkgbuild_prefix /path/to/dir'
# to define a different install prefix.

%{?!pkgbuild_prefix:%define pkgbuild_prefix /usr}
%define _prefix %{pkgbuild_prefix}

Name:         pkgbuild
IPS_Package_Name: package/pkgbuild
License:      GPLv2
Group:        Development/Tools/Other
URL:	      http://pkgbuild.sourceforge.net/
Version:      1.3.105
Release:      1
BuildArch:    noarch
Vendor:	      OpenSolaris Community
Summary:      rpmbuild-like tool for building Solaris packages
Source:       http://prdownloads.sourceforge.net/pkgbuild/pkgbuild-%{version}.tar.bz2
BuildRoot:    %{_tmppath}/%{name}-%{version}-build
# OpenSolaris IPS Package Manifest Fields
Meta(info.upstream):	 	Laszlo (Laca) Peter <laszlo.peter@oracle.com>
Meta(info.maintainer):	 	Laszlo (Laca) Peter <laca@opensolaris.org>
Meta(info.repository_url):	http://pkgbuild.cvs.sourceforge.net/viewvc/pkgbuild/pkgbuild/
Meta(info.classification):	org.opensolaris.category.2008:System/Packaging
Requires:     SUNWbash
BuildRequires: runtime/perl-512
Requires:     SUNWgpch

Patch1:		configure-sed.patch
Patch2:		pkgbuild.pl.in-facets.patch


%description
A tool for building Solaris SVr4 packages based on RPM spec files.
Most features and some extensions of the spec format are implemented.

%prep
%setup -q -n pkgbuild-%version
%patch1 -p1
%patch2 -p1

%build
./configure --prefix=%{pkgbuild_prefix}
make

%install
make DESTDIR=$RPM_BUILD_ROOT install

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr (-, root, bin)
%doc COPYING AUTHORS NEWS
%dir %attr (0755, root, sys) %{_datadir}
%dir %attr (0755, root, other) %{_datadir}/doc
%attr (0755, root, bin) %{_bindir}
%attr (0755, root, bin) %{_libdir}
%{_datadir}/%{name}
%{_mandir}

%changelog
* Sat Sep 28 2013 - Alex Viskovatoff
- install by default in /usr; process devel and doc tags as facets
* Tue Jun 22 2010 - laca@sun.com
- updated %files for new doc and man pages
* Fri Apr 17 2009 - laca@sun.com
- add IPS Meta tags
* Fri Aug 11 2006 - <laca@sun.com>
- delete topdir stuff, we have per-user topdirs now
* Mon Aug 08 2005 - <laca@sun.com>
- add GNU Patch dependency
* Thu Dec 09 2004 - <laca@sun.com>
- Remove %topdir/* from the pkgmap and create these directories in %post
* Fri Mar 05 2004 - <laca@sun.com>
- fix %files
* Wed Jan 07 2004 - <laszlo.peter@sun.com>
- initial version of the spec file
