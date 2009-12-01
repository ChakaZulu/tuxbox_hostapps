#!/bin/sh
# $Id: toolchecker.sh,v 1.7 2009/12/01 10:59:15 dbt Exp $
#
#
# Copyright (c) 2004 dietmarw Germany. All rights reserved.
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
# Mit diesem Programm koennen Images fuer DBox2 erstellt werden
#
# -------------------------------------------------------
#
echo "Tool Checker for CVS - $Revision: 1.7 $ dw - by horsti666 and dietmarw - modified by mourice"
echo ""
CUT=`which cut`
GREP=`which grep`
 
# automake
AUTOMAKE=`which automake`
if [ $AUTOMAKE ] && [ $AUTOMAKE != " " ]; then
        echo "automake    >=1.7    : "`$AUTOMAKE --version | grep automake | cut -f4 -d " "`
else
        echo "automake    >=1.7    : \033[37;41mnot installed\033[0m - use: sudo apt-get install automake"
fi
#---------------------------------------------#
# autoconf
AUTOCONF=`which autoconf`
if [ $AUTOCONF ] && [ $AUTOCONF != " " ]; then
        echo "autoconf    >=2.50   : "`$AUTOCONF --version | grep autoconf | cut -f4 -d " "`
else
        echo "autoconf    >=2.50   : \033[37;41mnot installed\033[0m - use: sudo apt-get install autoconf"
fi
#---------------------------------------------#
# cvs
MYCVS=`which cvs`
if [ $MYCVS ] && [ $MYCVS != " " ]; then
        echo "cvs                  : "`$MYCVS --version | grep Concurrent | cut -f5 -d " "`
else
        echo "cvs                  : \033[37;41mnot installed\033[0m - use: sudo apt-get install cvs"
fi
#---------------------------------------------#
# libtool
LIBTOOL=`which libtool`
if [ $LIBTOOL ] && [ $LIBTOOL != " " ]; then
        echo "libtool     >=1.4.2  : "`$LIBTOOL --version | $GREP libtool | $CUT -f4 -d " "`
else
        echo "libtool     >=1.4.2  : \033[37;41mnot installed\033[0m - use: sudo apt-get install libtool"
fi
#---------------------------------------------#
# make
MAKE=`which make`
if [ $MAKE ] && [ $MAKE != " " ]; then
        echo "make        >=3.79   : "`$MAKE --version | $GREP Make | $CUT -f3 -d " "`
else
        echo "make        >=3.79   : \033[37;41mnot installed\033[0m - use: sudo apt-get install make"
fi
#---------------------------------------------#
# gettext
GETTEXT=`which gettext`
if [ $GETTEXT ] && [ $GETTEXT != " " ]; then
        echo "gettext     >=0.12.1 : "`$GETTEXT --version | $GREP gettext | $CUT -f4 -d " "`
else
        echo "gettext     >=0.12.1 : \033[37;41mnot installed\033[0m - use: sudo apt-get install gettext"
fi
#---------------------------------------------#
# makeinfo
MAKEINFO=`which makeinfo`
if [ $MAKEINFO ] && [ $MAKEINFO != " " ]; then
        echo "makeinfo             : "`$MAKEINFO --version | $GREP makeinfo | $CUT -f4 -d " "`
else
        echo "makeinfo             : \033[37;41mnot installed\033[0m - use: sudo apt-get install texinfo"
fi
#---------------------------------------------#
# tar
TAR=`which tar`
if [ $TAR ] && [ $TAR != " " ]; then
        echo "tar                  : "`$TAR --version | $GREP tar | $CUT -f4 -d " "`
        else
        echo "tar                  : \033[37;41mnot installed\033[0m - use: sudo apt-get install tar"
fi
#---------------------------------------------#
# bunzip2
BUNZIP2=`which bunzip2`
if [ $BUNZIP2 ] && [ $BUNZIP2 != " " ]; then
        echo "bunzip2              : "`$BUNZIP2 --help 2>&1 >/dev/null | $GREP Version | $CUT -f8 -d " " | $CUT -f1 -d ","`
else
        echo "bunzip2              : \033[37;41mnot installed\033[0m - use: sudo apt-get install bunzip2"
fi
#---------------------------------------------#
# gunzip
GUNZIP=`which gunzip`
if [ $GUNZIP ] && [ $GUNZIP != " " ]; then
        echo "gunzip               : "`$GUNZIP --version | $GREP gzip | $CUT -f2 -d " "`
else
        echo "gunzip               : \033[37;41mnot installed\033[0m - use: sudo apt-get install gunzip"
fi
#---------------------------------------------#
# patch
PATCH=`which patch`
if [ $PATCH ] && [ $PATCH != " " ]; then
        echo "patch                : "`$PATCH --version | $GREP patch | $CUT -f2 -d " "`
else
        echo "patch                : \033[37;41mnot installed\033[0m - use: sudo apt-get install patch"
fi
#---------------------------------------------#
# infocmp
INFOCMP=`which infocmp`
if [ $INFOCMP ] && [ $INFOCMP != " " ]; then
        echo "infocmp              : "`$INFOCMP -V | $GREP ncurses | $CUT -f2 -d " "`
else
        echo "infocmp              : \033[37;41mnot installed\033[0m - use: sudo apt-get install infocmp"
fi
#---------------------------------------------#
# gcc
GCC=`which gcc`
if [ $GCC ] && [ $GCC != " " ]; then
        echo "gcc         >=3.0    : "`$GCC -dumpversion`
else
        echo "gcc         >=3.0    : \033[37;41mnot installed\033[0m - use: sudo apt-get install gcc"
fi
#---------------------------------------------#
# c++
CCC=`which g++`
if [ $CCC ] && [ $CCC != " " ]; then
        echo "g++         >=3.0    : "`$CCC -dumpversion`
else
        echo "g++         >=3.0    : \033[37;41mnot installed\033[0m - use: sudo apt-get install g++"
fi
#---------------------------------------------#
# yacc
YACC=`which yacc`
if [ $YACC ] && [ $YACC != " " ]; then
        echo "yacc                 : "`$YACC --version | $GREP Bison | $CUT -f4 -d " "`
else
        echo "yacc                 : \033[37;41mnot installed\033[0m - use: sudo apt-get install bison"
fi
#---------------------------------------------#
# bison
BISON=`which bison`
if [ $BISON ] && [ $BISON != " " ]; then
        echo "bison                : "`$BISON --version | $GREP Bison | $CUT -f4 -d " "`
else
        echo "bison                : \033[37;41mnot installed\033[0m - use: sudo apt-get install bison"
fi
#---------------------------------------------#
# flex
FLEX=`which flex`
if [ $FLEX ] && [ $FLEX != " " ]; then
        echo "flex                 : "`$FLEX --version | $GREP flex | $CUT -f2 -d " "`
else
        echo "flex                 : \033[37;41mnot installed\033[0m - use: sudo apt-get install flex"
fi
#---------------------------------------------#
# pkg-config
PKGCONFIG=`which pkg-config`
if [ $PKGCONFIG ] && [ $PKGCONFIG != " " ]; then
        echo "pkg-config           : "`$PKGCONFIG --version | $GREP .`
else
        echo "pkg-config           : \033[37;41mnot installed\033[0m - use: sudo apt-get install pkg-config"
fi
#---------------------------------------------#
# python
PYTHON=`which python`
if [ $PYTHON ] && [ $PYTHON != " " ]; then
        echo "python               : "`$PYTHON --version 2>&1 >/dev/null | $GREP Python | $CUT -f2 -d " "`
else
        echo "python               : \033[37;41mnot installed\033[0m - use: sudo apt-get install python"
fi
#---------------------------------------------#
# wget
WGET=`which wget`
if [ $WGET ] && [ $WGET != " " ]; then
        echo "wget                 : "`$WGET --version | $GREP Wget | $CUT -f3 -d " "`
else
        echo "wget                 : \033[37;41mnot installed\033[0m - use: sudo apt-get install wget"
fi
#---------------------------------------------#
# zlib1g
ZLIB1G=`apt-cache showsrc zlib1g-dev | $GREP ^Version | $CUT -f2 -d " "`
if [ "$ZLIB1G" ] && [ "$ZLIB1G" != " " ]; then
        echo "zlib1g-dev           : $ZLIB1G"
else
        echo "zlib1g-dev           : \033[37;41mnot installed\033[0m - use as root: apt-get install zlib1g-dev"
fi
#---------------------------------------------#
exit
