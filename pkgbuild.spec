# To build, enter the directory containing this file (sfe-tools/pkgbuild)
# and give this command:
#	pkgtool build-only --download pkgbuild.spec
# After that, install with
#	pkg uninstall pkgbuild
#	pkg install pkg://<your repository name>/package/pkgbuild
# This assumes that you already have pkgbuild installed and have a build
# environment and a local IPS repository set up.

# Install in /opt/dtbld to avoid conflict with system pkgbuild
# Use pkgbuild --define 'pkgbuild_prefix /path/to/dir'
# to define a different install prefix.

%{?!pkgbuild_prefix:%define pkgbuild_prefix /opt/dtbld}
%define _prefix %pkgbuild_prefix
%define branch_name maint

Name:         pkgbuild
IPS_Package_Name: sfe/package/pkgbuild
License:      GPLv2
Group:        Development/Tools/Other
URL:	      http://github.com/herzen/pkgbuild
Version:      1.3.105
Release:      1
BuildArch:    noarch
Vendor:	      OpenSolaris Community
Summary:      rpmbuild-like tool for building Solaris packages
Source:       http://github.com/herzen/pkgbuild/archive/%branch_name.zip
# OpenSolaris IPS Package Manifest Fields
Meta(info.upstream):	 	Laszlo (Laca) Peter <laszlo.peter@oracle.com>
Meta(info.maintainer):	 	Laszlo (Laca) Peter <laca@opensolaris.org>
Meta(info.repository_url):	http://pkgbuild.cvs.sourceforge.net/viewvc/pkgbuild/pkgbuild/
Meta(info.classification):	org.opensolaris.category.2008:System/Packaging
Requires:     SUNWbash
BuildRequires: runtime/perl-512
Requires:     SUNWgpch

%description
A tool for building Solaris SVr4 packages based on RPM spec files.
Most features and some extensions of the spec format are implemented.

%prep
%setup -q -n pkgbuild-%branch_name

%build
./autogen.sh
./configure --prefix=%_prefix
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
