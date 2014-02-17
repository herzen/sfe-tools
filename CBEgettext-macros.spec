#
# spec file for package CBEgettext
#
# Copyright 2008 Sun Microsystems, Inc.
# This file and all modifications and additions to the pristine
# package are under the same license as the package itself.
#

%{?!cbe_prefix:%define cbe_prefix /usr}
%include CBE.inc

Name:			CBEgettext-macros
IPS_Package_Name:       cbe/desktop/gettext-macros
Version:		0.16.1
License:		GPL
Group:			system/cbe
Distribution:		Desktop CBE
Vendor:			Sun Microsystems, Inc.
Summary:		Desktop CBE: GNU gettext
Source:			http://dlc.sun.com/osol/jds/downloads/cbe/gettext-macros.tar.bz2
URL:			http://www.gnu.org/software/gettext/
BuildRoot:		%{_tmppath}/%{name}-%{version}-build
SUNW_BaseDir:		%{_prefix}
SUNW_Category:          CBE,application
SUNW_Rev:		%{?cbe_version}%{?!cbe_version:0.0}
%include default-depend.inc
BuildRequires:          %make_dep

%description
GNU gettext macros for building the OpenSolaris Desktop
%include default-depend.inc

%prep
%setup -q -c -n %name-%version

%install
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT%{_datadir}/aclocal
cp share/aclocal/*.m4 $RPM_BUILD_ROOT%{_datadir}/aclocal

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-, root, bin)
%dir %attr (0755, root, sys) %{_datadir}
%dir %attr (0755, root, other) %{_datadir}/aclocal
%{_datadir}/aclocal/*.m4


%changelog
* Sat Jun 28 2008 - laca@sun.com
- move autoconf m4 files to macros pkg
* Wed Jun 11 2008  <laca@sun.com>
- update rev, make depedency
* Mon Apr 14 2008 - laca@sun.com
- update deps
- use CBE.inc
* Mon Mar  3 2008 - laca@sun.com
- bump to 0.16.1
* Mon Aug 21 2006  <laca@sun.com>
- move to /opt/jdsbld by default
* Wed Aug 16 2006  <laca@sun.com>
- add missing deps
* Fri Sep 02 2004  <laca@sun.com>
- remove unpackaged files
* Sat Oct 02 2004  <laca@sun.com>
- add %_datadir/gettext to %files
* Sun Sep 05 2004  <laca@sun.com>
- update to 0.14.1
- build and package the tools
- enable parallel build
* Fri Mar 05 2004  <laca@sun.com>
- fix %files
- change the pkg category
