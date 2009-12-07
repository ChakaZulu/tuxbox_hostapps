#!/bin/sh
# $Id: toolchecker.sh,v 1.9 2009/12/07 10:25:53 striper Exp $
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

echo "Tool Checker for Tuxbox-CVS"
echo ""

CUT=`which cut`
GREP=`which grep`

#---------------------------------------------#
AUTOMAKE=`which automake 2>/dev/null`
if [ $AUTOMAKE ] && [ $AUTOMAKE != " " ]; then
	echo "automake    >=1.7    : Installed! (Version: `$AUTOMAKE --version | grep automake | cut -f4 -d " "`)"
else
	echo "automake    >=1.7    : Missing!"
fi
#---------------------------------------------#
AUTOCONF=`which autoconf 2>/dev/null`
if [ $AUTOCONF ] && [ $AUTOCONF != " " ]; then
	echo "autoconf    >=2.50   : Installed! (Version: `$AUTOCONF --version | grep autoconf | cut -f4 -d " "`)"
else
	echo "autoconf    >=2.50   : Missing!"
fi
#---------------------------------------------#
MYCVS=`which cvs 2>/dev/null`
if [ $MYCVS ] && [ $MYCVS != " " ]; then
	echo "cvs                  : Installed!"
else
	echo "cvs                  : Missing!"
fi
#---------------------------------------------#
MYSVN=`which svn 2>/dev/null`
if [ $MYSVN ] && [ $MYSVN != " " ]; then
	echo "svn                  : Installed!"
else
	echo "svn                  : Missing! (only needed for Coolstream build)"
fi
#---------------------------------------------#
LIBTOOL=`which libtool 2>/dev/null`
if [ $LIBTOOL ] && [ $LIBTOOL != " " ]; then
	echo "libtool     >=1.4.2  : Installed! (Version: `$LIBTOOL --version | $GREP libtool | $CUT -f4 -d " "`)"
else
	echo "libtool     >=1.4.2  : Missing!"
fi
#---------------------------------------------#
MAKE=`which make 2>/dev/null`
if [ $MAKE ] && [ $MAKE != " " ]; then
	echo "make        >=3.79   : Installed! (Version: `$MAKE --version | $GREP Make | $CUT -f3 -d " "`)"
else
	echo "make        >=3.79   : Missing!"
fi
#---------------------------------------------#
GETTEXT=`which gettext 2>/dev/null`
if [ $GETTEXT ] && [ $GETTEXT != " " ]; then
	echo "gettext     >=0.12.1 : Installed! (Version: `$GETTEXT --version | $GREP gettext | $CUT -f4 -d " "`)"
else
	echo "gettext     >=0.12.1 : Missing!"
fi
#---------------------------------------------#
MAKEINFO=`which makeinfo 2>/dev/null`
if [ $MAKEINFO ] && [ $MAKEINFO != " " ]; then
	echo "makeinfo             : Installed!"
else
	echo "makeinfo             : Missing!"
fi
#---------------------------------------------#
TAR=`which tar 2>/dev/null`
if [ $TAR ] && [ $TAR != " " ]; then
	echo "tar                  : Installed!"
else
	echo "tar                  : Missing!"
fi
#---------------------------------------------#
BUNZIP2=`which bunzip2 2>/dev/null`
if [ $BUNZIP2 ] && [ $BUNZIP2 != " " ]; then
	echo "bunzip2              : Installed!"
else
	echo "bunzip2              : Missing!"
fi
#---------------------------------------------#
GUNZIP=`which gunzip 2>/dev/null`
if [ $GUNZIP ] && [ $GUNZIP != " " ]; then
	echo "gunzip               : Installed!"
else
	echo "gunzip               : Missing!"
fi
#---------------------------------------------#
PATCH=`which patch 2>/dev/null`
if [ $PATCH ] && [ $PATCH != " " ]; then
	echo "patch                : Installed!"
else
	echo "patch                : Missing!"
fi
#---------------------------------------------#
INFOCMP=`which infocmp 2>/dev/null`
if [ $INFOCMP ] && [ $INFOCMP != " " ]; then
	echo "infocmp              : Installed!"
else
	echo "infocmp              : Missing!"
fi
#---------------------------------------------#
CCC=`which g++ 2>/dev/null`
if [ $CCC ] && [ $CCC != " " ]; then
	echo "g++         >=3.0    : Installed! (Version: `$CCC -dumpversion`)"
else
	echo "g++         >=3.0    : Missing!"
fi
#---------------------------------------------#
BISON=`which bison 2>/dev/null`
if [ $BISON ] && [ $BISON != " " ]; then
	echo "bison                : Installed!"
else
	echo "bison                : Missing!"
fi
#---------------------------------------------#
FLEX=`which flex 2>/dev/null`
if [ $FLEX ] && [ $FLEX != " " ]; then
	echo "flex                 : Installed!"
else
	echo "flex                 : Missing!"
fi
#---------------------------------------------#
PKGCONFIG=`which pkg-config 2>/dev/null`
if [ $PKGCONFIG ] && [ $PKGCONFIG != " " ]; then
	echo "pkg-config           : Installed!"
else
	echo "pkg-config           : Missing!"
fi
#---------------------------------------------#
PYTHON=`which python 2>/dev/null`
if [ $PYTHON ] && [ $PYTHON != " " ]; then
	echo "python               : Installed!"
else
	echo "python               : Missing!"
fi
#---------------------------------------------#
WGET=`which wget 2>/dev/null`
if [ $WGET ] && [ $WGET != " " ]; then
	echo "wget                 : Installed!"
else
	echo "wget                 : Missing!"
fi
#---------------------------------------------#
YACC=`which yacc 2>/dev/null`
if [ $YACC ] && [ $YACC != " " ]; then
	echo "yacc                 : Installed!"
else
	echo "yacc                 : Missing!"
fi
#---------------------------------------------#
if [ -e "/usr/include/zlib.h" ]; then
	echo "zlib-devel           : Installed!"
else
	echo "zlib-devel           : Missing!"
fi
#---------------------------------------------#
echo ""
echo "In case of missing packages use your package manager (eg. apt, yum or yast) to install them!"
echo "Otherwise your build will most likely fail."
echo ""
exit
