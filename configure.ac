AC_INIT(Makefile.am)
AM_INIT_AUTOMAKE(tuxbox-hostapps, 0.0.1)
#AM_CONFIG_HEADER(config.h)
#AM_MAINTAINER_MODE
##
#AC_CANONICAL_BUILD
#AC_CANONICAL_HOST
#
#AC_PROG_CC
AC_PROG_CXX
#AC_PROG_INSTALL
#
#AC_DISABLE_STATIC
##
#AM_PROG_LIBTOOL
#
#AC_HEADER_STDC
#
#AC_CHECK_LIB(crypto,PEM_write_bio,[HAVE_LIBCRYPTO="yes"],[AC_MSG_WARN([*argh*])])
#AC_CHECK_HEADER(openssl/bio.h,[HAVE_LIBCRYPTO="yes"],[AC_MSG_WARN([*argh*])])

#######################################
#AC_INIT(Makefile.am)
AC_PREREQ(2.50)
#AM_INIT_AUTOMAKE(tuxbox-cdk, 0.0.1)
AM_MAINTAINER_MODE

AC_PROG_CC

AC_CANONICAL_BUILD
AC_SUBST(build)
if test "$target_alias" = "" ; then
	target_alias="powerpc-tuxbox-linux-gnu"
fi
AC_CANONICAL_TARGET
AC_SUBST(target)

AC_ARG_WITH(hardwareruleset,
	[  --with-hardwareruleset=NAME  hardware ruleset [[dbox2,dreambox]]],
	[HARDWARERULESET="$withval"],[HARDWARERULESET="dbox2"])

if test "$HARDWARERULESET" = "dbox2"; then
	true
elif test "$HARDWARERULESET" = "dreambox"; then
	true
else
	AC_MSG_ERROR([invalid hardwareruleset "$hardwareruleset", choose on from dbox2 or dreambox]);
fi

AC_SUBST(HARDWARERULESET)
AM_CONDITIONAL(HARDWARERULESET_DBOX2,test "$HARDWARERULESET" = "dbox2")
AM_CONDITIONAL(HARDWARERULESET_DREAMBOX,test "$HARDWARERULESET" = "dreambox")

AC_ARG_WITH(hostruleset,
	[  --with-hostruleset=NAME host ruleset [[standard,cygwin]]],
	[HOSTRULESET="$withval"],[HOSTRULESET="NULL"])

if test "$HOSTRULESET" = "NULL"; then
	if test "$host_os" = "cygwin"; then
		HOSTRULESET="cygwin"
	else
		HOSTRULESET="standard"
	fi
fi

if test "$HOSTRULESET" = "standard"; then
	MAKERULESETFILE=""
elif test "$HOSTRULESET" = "cygwin"; then
	MAKERULESETFILE="-cygwin"
else
	AC_MSG_ERROR([invalid hostruleset "$HOSTRULESET", choose on from standard or cygwin]);
fi

AC_SUBST(HOSTRULESET)
AM_CONDITIONAL(HOSTRULESET_STANDARD,test "$HOSTRULESET" = "standard")
AM_CONDITIONAL(HOSTRULESET_CYGWIN,test "$HOSTRULESET" = "cygwin")

AC_ARG_WITH(targetruleset,
	[  --with-targetruleset=NAME target ruleset [[standard,flash]]],
	[TARGETRULESET="$withval"],[TARGETRULESET="standard"])

if test "$TARGETRULESET" = "standard"; then
	INSTALLRULESETFILE=""
elif test "$TARGETRULESET" = "flash"; then
	INSTALLRULESETFILE="-flash"
else
	AC_MSG_ERROR([invalid targetruleset "$TARGETRULESET", choose on from standard or flash]);
fi

AC_SUBST(TARGETRULESET)
AM_CONDITIONAL(TARGETRULESET_STANDARD,test "$TARGETRULESET" = "standard")
AM_CONDITIONAL(TARGETRULESET_FLASH,test "$TARGETRULESET" = "flash")

if test -z "$CFLAGS" ; then
	CFLAGS="-O2"
fi

if test -z "$TARGET_CFLAGS" -o -z "$TARGET_CXXFLAGS"; then
	if test "$HARDWARERULESET" = "dbox2"; then
		TARGET_CFLAGS="-mcpu=823"
	elif test "$HARDWARERULESET" = "dreambox"; then
		TARGET_CFLAGS="-mcpu=403 -Wa,-m405"
	fi
	TARGET_CFLAGS="$TARGET_CFLAGS -mmultiple -mstring -meabi"
	if test "$TARGETRULESET" = "standard"; then
		TARGET_CFLAGS="$TARGET_CFLAGS -O3 -g -pipe"
		TARGET_LDFLAGS=""
	elif test "$TARGETRULESET" = "flash"; then
		TARGET_CFLAGS="$TARGET_CFLAGS -Os -pipe"
		TARGET_LDFLAGS="-s"
	fi
	TARGET_CXXFLAGS="$TARGET_CFLAGS"
fi

AC_SUBST(CFLAGS)
AC_SUBST(TARGET_CFLAGS)
AC_SUBST(TARGET_CXXFLAGS)
AC_SUBST(TARGET_LDFLAGS)

AC_PREFIX_DEFAULT(/dbox2)

if test "$prefix" = "NONE"; then
	prefix=/dbox2
fi

AC_ARG_WITH(targetprefix,
	[  --with-targetprefix=DIR prefix for target files [[PREFIX/cdkroot]]],
	[targetprefix="$with_targetprefix"],[targetprefix="${prefix}/cdkroot"])

AC_ARG_WITH(hostprefix,
	[  --with-hostprefix=DIR   prefix for host files [[PREFIX/cdk]]],
	[hostprefix="$with_hostprefix"],[hostprefix="${prefix}/cdk"])

AC_ARG_WITH(bootprefix,
	[  --with-bootprefix=DIR   prefix for boot files [[PREFIX/tftpboot]]],
	[bootprefix="$with_bootprefix"],[bootprefix="${prefix}/tftpboot"])

AC_ARG_WITH(flashprefix,
	[  --with-flashprefix=DIR  prefix for flash files [[PREFIX/cdkflash]] (only used for flash building)],
	[flashprefix="$with_flashprefix"],[flashprefix="${prefix}/cdkflash"])

buildprefix=`pwd`
AC_SUBST(targetprefix)
AC_SUBST(hostprefix)
AC_SUBST(buildprefix)
AC_SUBST(bootprefix)
AC_SUBST(flashprefix)
flashprefix_ro=${flashprefix}/ro
AC_SUBST(flashprefix_ro)
flashprefix_rw=${flashprefix}/rw
AC_SUBST(flashprefix_rw)

AC_ARG_WITH(cvsdir,
	[  --with-cvsdir=DIR       where to find the cvs],
	[cvsdir="$with_cvsdir"],[cvsdir="NONE"])

AC_ARG_WITH(appsdir,
	[  --with-appsdir=DIR      apps dir from cvs [[[CVS/]apps/]]],
	[appsdir="$with_appsdir"],[appsdir="NONE"])

AC_ARG_WITH(bootdir,
	[  --with-bootdir=DIR      boot dir from cvs [[[CVS/]boot/]]],
	[bootdir="$with_bootdir"],[bootdir="NONE"])

AC_ARG_WITH(driverdir,
	[  --with-driverdir=DIR    driver dir from cvs [[[CVS/]driver]]],
	[driverdir="$with_driverdir"],[driverdir="NONE"])

AC_ARG_WITH(hostapsdir,
	[  --with-hostappsdir=DIR  hostapps dir from cvs [[[CVS/]hostapps]]],
	[hostappsdir="$with_driverdir"],[hostappsdir="NONE"])

AC_ARG_WITH(gnuserver,
        [  --with-gnuserver=ADDRESS   the gnu server for gnu-stuff (without ftp://)],
        [gnuserver="$with_gnuserver"],[gnuserver="NONE"])

if test "$cvsdir" = "NONE"; then
	if test "$appsdir" = "NONE"; then
		appsdir="$buildprefix/apps"
	fi
	if test "$bootdir" = "NONE"; then
		bootdir="$buildprefix/boot"
	fi
	if test "$driverdir" = "NONE"; then
		driverdir="$buildprefix/driver"
	fi
	if test "$hostappsdir" = "NONE"; then
		hostappsdir="$buildprefix/hostapps"
	fi
else
	if test "$appsdir" = "NONE"; then
		appsdir="$cvsdir/apps"
	fi
	if test "$bootdir" = "NONE"; then
		bootdir="$cvsdir/boot"
	fi
	if test "$driverdir" = "NONE"; then
		driverdir="$cvsdir/driver"
	fi
	if test "$hostappsdir" = "NONE"; then
		hostappsdir="$cvsdir/hostapps"
	fi
fi

if test "$gnuserver" = "NONE"; then
	gnuserver="ftp.gwdg.de/pub/misc/gnu"
fi

AC_MSG_CHECKING([for apps directory])
if test ! -f "$appsdir/dvb/zapit/configure.ac" ; then
	appsdir=no
	AC_MSG_RESULT([no])
else
	AC_MSG_RESULT([yes])
fi

AC_MSG_CHECKING([for boot directory])
if test ! -f "$bootdir/u-boot/Makefile" ; then
	bootdir=no
	AC_MSG_RESULT([no])
else
	AC_MSG_RESULT([yes])
fi

AC_MSG_CHECKING([for driver directory])
if test ! -f "$driverdir/Makefile" ; then
	driverdir=no
	AC_MSG_RESULT([no])
else
	AC_MSG_RESULT([yes])
fi

AC_MSG_CHECKING([for hostapps directory])
if test ! -f "$hostappsdir/configure.ac" ; then
	hostappsdir=no
	AC_MSG_RESULT([no])
else
	AC_MSG_RESULT([yes])
fi

AC_SUBST(appsdir)
AC_SUBST(bootdir)
AC_SUBST(driverdir)
AC_SUBST(hostappsdir)
AC_SUBST(gnuserver)

if test "$TARGETRULESET" = "flash"; then
	AC_PATH_PROG(MKLIBS,mklibs,no)
	if test "$MKLIBS" = "no"; then
		AC_MSG_WARN(can't build libs)
		MKLIBS=/bin/false
	fi
	AC_PATH_PROG(FAKEROOT,fakeroot,no)
	if test "$FAKEROOT" = "no"; then
		AC_MSG_WARN(can't build images with uid 0 as non-root)
		FAKEROOT=
	fi
	AC_PATH_PROG(MKCRAMFS,mkcramfs,no)
	if test "$MKCRAMFS" = "no"; then
		AC_MSG_WARN(can't build cramfs)
		MKCRAMFS=/bin/false
	fi
	AC_PATH_PROG(MKJFFS2,mkjffs2,no)
	if test "$MKJFFS2" = "no"; then
		AC_PATH_PROG(MKFSJFFS2,mkfs.jffs2,no)
		if test "$MKFSJFFS2" = "no"; then
			AC_MSG_WARN(can't build jffs2)
			MKJFFS2=/bin/false
		else
			MKJFFS2=$MKFSJFFS2
		fi
	fi
fi

FONTDIR="/share/fonts"
AC_SUBST(FONTDIR)
UCODEDIR="/var/tuxbox/ucodes"
AC_SUBST(UCODEDIR)

CLEANUP="rm -rf"
AC_SUBST(CLEANUP)

#######################################################

#
# summary
#
AC_MSG_RESULT([
Summary:
Hardwareruleset:	$HARDWARERULESET
Hostruleset:		$HOSTRULESET
Targetruleset:		$TARGETRULESET
Targetprefix:		$targetprefix
Hostprefix:		$hostprefix
Bootprefix:		$bootprefix
Buildprefix:		$buildprefix
Appsdir:		$appsdir
Bootdir:		$bootdir
Driverdir:		$driverdir
Hostappsdir:		$hostappsdir
GNU-Server:		$gnuserver
])


AC_OUTPUT([
Makefile
bmp2raw/Makefile
flash/Makefile
ggrab/Makefile
grab/Makefile
libcrypto++/Makefile
libflashimage/Makefile
stream/Makefile
ucodex/Makefile
])

