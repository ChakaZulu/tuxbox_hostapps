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

### makeinfo (texinfo) ###
MAKEINFO=`which makeinfo`
if ( test -e $MAKEINFO ) then
	echo "makeinfo:                 "`$MAKEINFO --version | $GREP makeinfo | $CUT -f4 -d " "`
	else
	echo -e "\033[37;41mmakeinfo nicht installiert\033[37;40m"
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

### mksquashfs ###
MKSQUASHFS=`which mksquashfs`
if ( test -e $MKSQUASHFS)
        then
        echo "mksquashfs 2.1            "`$MKSQUASHFS -version | $GREP mksquashfs | cut -d" " -f3`
        else
        echo -e "\033[37;41mksquashfs nicht installiert\033[37;40m"
        exit 1
fi


echo ""
echo ""
