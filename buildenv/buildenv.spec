#
# spec file for package buildenv
#
# This file and all modifications and additions to the pristine
# package are under the same license as the package itself.
#

%include CBE.inc

Name:			buildenv
IPS_Package_Name:	developer/build/buildenv
Group:			Development/Distribution Tools
Version:		%{?cbe_version}%{?!cbe_version:0.0}
Summary:		environment setup scripts for building Spec Files Extra packages
Source:			env.sh
Source1:                env.csh
Source2:                env_include.sh
Source3:                ld-wrapper
Source4:                gendiff
SUNW_BaseDir:		%_prefix
SUNW_Category:          CBE,application

Requires:	group/feature/developer-gnu
Requires:	web/wget, archiver/gnu-tar, text/gnu-patch
Requires:	text/gnu-sed, text/gawk, text/gnu-grep, file/gnu-findutils
Requires:	compress/xz, developer/documentation-tool/gtk-doc
Requires:	package/pkgbuild 
Requires:	system/library/math

%prep
mkdir -p %name-%version

%define relroot %(echo %_bindir | sed -e 's,[^/][^/]*,..,g' | cut -c2-)

%install
rm -rf %buildroot
mkdir -p %buildroot%_bindir
cp %SOURCE0 %buildroot%_bindir
cp %SOURCE1 %buildroot%_bindir
cp %SOURCE2 %buildroot%_bindir
cp %SOURCE3 %buildroot%_bindir
cp %SOURCE4 %buildroot%_bindir

pushd %buildroot%_bindir
sed -e "s|@CBE_PREFIX@|%cbe_prefix|" \
	-e "s|@CBE_VERSION@|%version|" \
        -e "s|@BUILD_INFO@||" \
	env.sh > env.sh.new
mv env.sh.new env.sh
popd

chmod 755 %buildroot%{_bindir}/*

%if %(pkginfo -q CBEmake && echo 0 || echo 1)
# create the "make" symlink to gmake when using SUNWgmake
GMAKE=xx
for f in /usr/gnu/bin/make /usr/bin/gmake /usr/sfw/bin/gmake; do
    test -f %{?altroot}$f && {
	GMAKE=$f
	break
    }
done
if [ "x$GMAKE" == xxx ]; then
    echo 'GNU make not found, please install SUNWgmake or CBEmake'
    exit 1
fi
cd %buildroot%_bindir
ln -s %relroot$GMAKE make
%endif

%if %(pkginfo -q CBEcoreutils && echo 0 || echo 1)
# create the "install" symlink to ginstall when using SUNWgnu-coreutils
cd %buildroot%_bindir
# break if ginstall is not found
test -x /usr/bin/ginstall
ln -s %relroot/usr/bin/ginstall install
%endif

%if %(pkginfo -q CBEdiff && echo 0 || echo 1)
# create the "diff" symlink to gdiff when using SUNWgnu-diffutils
cd %buildroot%_bindir
# break if gdiff is not found
test -x /usr/bin/gdiff
ln -s %relroot/usr/bin/gdiff diff
%endif

%if %(pkginfo -q CBEm4 && echo 0 || echo 1)
# create the "m4" symlink to gm4 when using SUNWgm4
GM4=xx
for f in /usr/gnu/bin/m4 /usr/bin/gm4 /usr/sfw/bin/gm4; do
    test -f %{?altroot}$f && {
	GM4=$f
	break
    }
done
if [ "x$GM4" == xxx ]; then
    echo 'GNU m4 not found, please install SUNWgm4 or CBEm4'
    exit 1
fi
cd %buildroot%_bindir
ln -s %relroot$GM4 m4
%endif


# GNU grep 
%if %(pkginfo -q CBEgnugrep && echo 0 || echo 1)
# create the "grep" symlink to ggrep when using SUNWggrp
GGREP=xx
for f in /usr/gnu/bin/grep /usr/bin/ggrep /usr/sfw/bin/ggrep; do
    test -f %{?altroot}$f && {
	GGREP=$f
	break
    }
done
if [ "x$GGREP" == xxx ]; then
    echo 'GNU grep not found, please install SUNWggrp or CBEgnugrep'
    exit 1
fi
cd %buildroot%_bindir
ln -s %relroot$GGREP grep
%endif


%clean
rm -rf %buildroot

%files
%defattr(-, root, bin)
%_bindir

%changelog
* Thu Jul 23 2009 - oboril.lukas@gmail.com
- create symlink for GNU grep
* Thu Jun 26 2008 - laca@sun.com
- add env_include.sh
* Mon Jun 16 2008  <laca@sun.com>
- move gendiff here from CBEdiff.spec
* Thu Jun 12 2008  <laca@sun.com>
- add cbe-env dir and preun script for deleting the env files
* Wed Jun 11 2008  <laca@sun.com>
- update version, create symlinks for [Open]Solaris gnu make, automake, aclocal
* Mon Apr 14 2008 - laca@sun.com
- update deps
- use CBE.inc
* Fri Oct 14 2005  <laca@sun.com>
- add ld-wrapper
* Mon Sep 06 2004  <laca@sun.com>
- update version, fix Summary
* Mon May 24 2004  <laca@sun.com>
- initial version
