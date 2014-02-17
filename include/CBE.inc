%{?!cbe_prefix:%define cbe_prefix /opt/dtbld}
%define _prefix %{cbe_prefix}
%define _mandir %{_datadir}/man

%define cc_is_gcc %(test "x`basename ${CC:-gcc}`" = xgcc && echo 1 || echo 0)

%if %cc_is_gcc
%define optflags           -O2 -Xlinker -i
%define cxx_optflags           -O2 -Xlinker -i
%define c99flag            -std=c99
%else
%define optflags           -i -xO4 -xspace -xstrconst -mr
%define cxx_optflags           -i -xO3 -xspace -mr -norunpath
%define c99flag            -xc99
%endif

%define ldflags	   -Wl,-zignore -Wl,-zcombreloc -Wl,-Bdirect

%if %(test -x /usr/bin/gmake -o -x /usr/sfw/bin/gmake && echo 1 || echo 0)
%define make_dep SUNWgmake
%else
%define make_dep CBEmake
%endif
