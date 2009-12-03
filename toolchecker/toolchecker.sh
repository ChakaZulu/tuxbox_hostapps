#!/bin/sh
# $Id: toolchecker.sh,v 1.8 2009/12/03 20:43:45 dbt Exp $
#
#
#
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published
# by the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software Foundation,
# Inc., 675 Mass Ave, Cambridge MA 02139, USA.
#
#
# -------------------------------------------------------
#
#! /bin/bash

CUT=`which cut`
GREP=`which grep`

echo ""
echo ""

### cvs ###
CVS=`which cvs`
if ( test -e $CVS ) then
	echo "cvs:                      "`$CVS --version | $GREP Concurrent | $CUT -f5 -d " "`
	else
	echo -e "\033[37;41mcvs nicht installiert\033[37;40m"
fi;

### autoconf >= 2.57a ###
AUTOCONF=`which autoconf`
if ( test -e $AUTOCONF ) then
	echo "autoconf >= 2.57a:        "`$AUTOCONF --version | $GREP "autoconf " | $CUT -f4 -d " "`
	else
	echo -e "\033[37;41mautoconf nicht installiert\033[37;40m"
fi;

### automake >= 1.7 ###
AUTOMAKE=`which automake`
if ( test -e  $AUTOMAKE ) then
	echo "automake >= 1.8:          "`$AUTOMAKE --version | $GREP "automake " | $CUT -f4 -d " "`
	else
	echo -e "\033[37;41mautomake nicht installiert\033[37;40m"
fi;

### libtool >= 1.4.2 ###
LIBTOOL=`which libtool`
if ( test -e $LIBTOOL ) then
	echo "libtool >= 1.4.2:         "`$LIBTOOL --version | $GREP "libtool)" | $CUT -f4 -d " "`
	else
	echo -e "\033[37;41mlibtool nicht installiert\033[37;40m"
fi;

### gettext >= 0.12.1 ###
GETTEXT=`which gettext`
if ( test -e $GETTEXT ) then
	echo "gettext >= 0.12.1:        "`$GETTEXT --version | $GREP gettext | $CUT -f4 -d " "`
	else
	echo -e "\033[37;41mgettext nicht installiert\033[37;40m"
fi;

### make >= 3.79 ###
MAKE=`which make`
if ( test -e $MAKE ) then
	echo "make >= 3.79:             "`$MAKE --version | $GREP Make | $CUT -f3 -d " "`
	else
	echo -e "\033[37;41mmake nicht installiert\033[37;40m"
fi;

### tar ###
TAR=`which tar`
if ( test -e $TAR ) then
	echo "tar:                      "`$TAR --version | $GREP tar | $CUT -f4 -d " "`
	else
	echo -e "\033[37;41mtar nicht installiert\033[37;40m"
fi;

### bunzip2 (bzip2) ###
BUNZIP2=`which bunzip2`
if ( test -e $BUNZIP2 ) then
	echo "bunzip2:                  "`bunzip2 --help 2> btmp; $GREP Version < btmp | $CUT -c 50-54; rm btmp`
	else
	echo -e "\033[37;41mbunzip2 nicht installiert\033[37;40m"
fi;

### gunzip (gzip) ###
GUNZIP=`which gunzip`
if ( test -e $GUNZIP ) then
	echo "gunzip:                   "`$GUNZIP --version | $GREP gunzip | $CUT -f2 -d " "`
	else
	echo -e "\033[37;41mgunzip nicht installiert\033[37;40m"
fi;

### patch ###
PATCH=`which patch`
if ( test -e $PATCH ) then
	echo "patch:                    "`$PATCH --version | $GREP "patch " | $CUT -f2 -d " "`
	else
	echo -e "\033[37;41mpatch nicht installiert\033[37;40m"
fi;

### infocmp (ncurses-bin / ncurses-devel) ###
INFOCMP=`which infocmp`
if ( test -e $INFOCMP ) then
	echo "infocmp:                  "`$INFOCMP -V | $GREP ncurses | $CUT -f2 -d " "`
	else
	echo -e "\033[37;41minfocmp nicht installiert\033[37;40m"
fi;

### gcc 2.95 or >= 3.0 ###
GCC=`which gcc`
if ( test -e $GCC ) then
	echo "gcc 2.95 or >= 3.0:       "`$GCC --version | $GREP gcc | $CUT -f3 -d " "`
	else
	echo -e "\033[37;41mgcc nicht installiert\033[37;40m"
fi;

### g++ 2.95 or >= 3.0 ###
CCC=`which g++`
if ( test -e $CCC ) then
	echo "g++ 2.95 or >= 3.0:       "`$CCC --version | $GREP g++ | $CUT -f3 -d " "`
	else
	echo -e "\033[37;41mg++ nicht installiert\033[37;40m"
fi;

### flex ###
FLEX=`which flex`
if ( test -e $FLEX ) then
	echo "flex:                     "`$FLEX --version | $GREP flex | $CUT -f2 -d " "`
	else
	echo -e "\033[37;41mflex nicht installiert\033[37;40m"
fi;

### bison ###
BISON=`which bison`
if ( test -e $BISON ) then
	echo "bison:                    "`$BISON --version | $GREP Bison | $CUT -f4 -d " "`
	else
	echo -e "\033[37;41mbison nicht installiert\033[37;40m"
fi;

### pkg-config ###
PKGCONFIG=`which pkg-config`
if ( test -e $PKGCONFIG ) then
	echo "pkg-config:               "`$PKGCONFIG --version | $GREP .`
	else
	echo -e "\033[37;41mpkg-config nicht installiert\033[37;40m"
fi;

### wget ###
WGET=`which wget`
if ( test -e $WGET ) then
	echo "wget:                     "`$WGET --version | $GREP Wget | $CUT -f3 -d " "`
	else
	echo -e "\033[37;41wget nicht installiert\033[37;40m"
fi;

echo ""
echo ""
