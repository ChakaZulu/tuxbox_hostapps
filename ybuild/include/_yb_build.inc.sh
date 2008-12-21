#! /bin/bash
# -----------------------------------------------------------------------------------------------------------
# Tuxbox Build & Compiler Helper
# Build/Make, Configure, CVS functions
#
# Started by yjogol (yjogol@online.de)
# $Date: 2008/12/21 13:20:07 $
# $Revision: 1.1 $
# -----------------------------------------------------------------------------------------------------------

#============================================================================================================
# yBuild V3 working note (delete after release)
# languagefile:	partitial
# updated:		ok
# tested:		ok
# issues:		no
#============================================================================================================

# -----------------------------------------------------------------------------------------------------------
# INIT
# -----------------------------------------------------------------------------------------------------------
yb_log_fileversion "\$Revision: 1.1 $ \$Date: 2008/12/21 13:20:07 $ _yb_build.inc.sh"

#============================================================================================================
# CONFIGURE
#============================================================================================================

# -----------------------------------------------------------------------------------------------------------
# Build Configure String for Options
# $1=var-prefix $2=FLASH|YADD $3=feature
# -----------------------------------------------------------------------------------------------------------
_do_configure_build_features()
{
	varname="conf$1"_"$2"
	val=${!varname}
	if [ "$val" == "on" ]; then
		flag="--enable-$3"
	else
		flag="--disable-$3"
	fi
}
# -----------------------------------------------------------------------------------------------------------
# Build Configure String for Options
# $1=var-prefix $3=feature
# -----------------------------------------------------------------------------------------------------------
_do_configure_build_features2()
{
	varname="conf$1"
	val=${!varname}
	if [ "$val" == "on" ]; then
		flag="--enable-$3"
	else
		flag="--disable-$3"
	fi
}
# -----------------------------------------------------------------------------------------------------------
# Build Configure String for Options
# $1=FLASH | YADD
# -----------------------------------------------------------------------------------------------------------
do_configure_build_features()
{
	flags=""
	# Build option individually for Flash or Yadd
	for f in "ide" "lirc" "ext3" "xfs" "nfsserver" "sambaserver" "cdkVcInfo" "dosfstools" "upnp" "flac"
	do
		_do_configure_build_features $f $1 $f
		flags="$flags $flag"
	done
	# general Build options
	for f in "uclibc" "lzma" "kernel26"
	do
		_do_configure_build_features2 $f $1 $f
		flags="$flags $flag"
	done
	_do_configure_build_features germankeymaps $1 "german-keymaps"
	flags="$flags $flag"
	if [ "$UPDATEHTTPPREFIX" != "" ]; then
		flags="$flags --with-updatehttpprefix=$UPDATEHTTPPREFIX"
	fi
	if [ "$confccache" == "on" ]; then
		flags="$flags --enable-ccache"
		if [ "$cCCACHEPATH" != "" ]; then
			flags="$flags --with-ccachedir=$CCACHEDIR"
		fi
	fi
}

# -----------------------------------------------------------------------------------------------------------
# Configure Flash
# -----------------------------------------------------------------------------------------------------------
do_configure_flash()
{
	_do_configure_flash $* | tee $LOGCONFFILE
}
# -----------------------------------------------------------------------------------------------------------
_do_configure_flash()
{
	if [ "$confautopatch_FLASH" == "y" ];then
		m="$l_cb_really_patch_and_configure"
	else
		m="$l_cb_really_configure"
	fi
    dialog --backtitle "$prgtitle" --title " $l_configure_flash "\
		--yesno "$m" 10 40
	opt=${?}
	if [ $opt == 0 ];then
		clear
		echo "=============================================================="
		echo "$l_configure_flash"
		echo "=============================================================="
		if [ "$confautopatch_FLASH" == "on" ];then
			patchmgr_patch
		fi
		init_variables
		cd "$CVSDIR/cdk"
		/bin/ln -sf $ARCHIVEDIR $CVSDIR/cdk/Archive
		./autogen.sh

		# build configure parameters for settings
		do_configure_build_features FLASH
		if [ "$ROOTPARTSIZE" != "" ]; then
			flags="$flags --with-rootpartitionsize=$ROOTPARTSIZE"
		fi
		echo "FLAGS generated = $flags"

		# start configure
		./configure --prefix="$DBOX_PREFIX" --with-cvsdir="$CVSDIR" --enable-flashrules \
			--with-logosdir="$LOGOSDIR" \
			--with-ucodesdir=$UCODESDIR \
			--with-checkImage=rename \
			--enable-maintainer-mode \
			--with-customizationsdir="$MyLOCALSDIR" \
			$flags
		echo "$l_ready_press_enter"
		read dummy
	fi
}

# -----------------------------------------------------------------------------------------------------------
# Configure YADD
# -----------------------------------------------------------------------------------------------------------
do_configure_yadd()
{
	_do_configure_yadd $* | tee $LOGCONFFILE
}
# -----------------------------------------------------------------------------------------------------------
_do_configure_yadd()
{
	if [ "$confautopatch_YADD" == "y" ];then
		m="$l_cb_really_patch_and_configure"
	else
		m="$l_cb_really_configure"
	fi
    dialog --backtitle "$prgtitle" --title " $l_configure_yadd "\
		--yesno "$m" 10 40
	opt=${?}
	if [ $opt == 0 ];then
		clear
		echo "=============================================================="
		echo "$l_configure_yadd"
		echo "=============================================================="
		if [ "$confautopatch_YADD" == "on" ];then
			patchmgr_patch
		fi
		init_variables
		cd "$CVSDIR/cdk"
		/bin/ln -sf $ARCHIVEDIR $CVSDIR/cdk/Archive
		./autogen.sh

		# build configure parameters for settings
		do_configure_build_features YADD
		echo "FLAGS generated = $flags"

		# start configure
		./configure --prefix="$DBOX_PREFIX" --with-cvsdir="$CVSDIR" \
			--with-logosdir="$LOGOSDIR" \
			--with-ucodesdir=$UCODESDIR \
			--enable-maintainer-mode \
			--with-customizationsdir="$MyLOCALSDIR" \
			$flags
		echo "$l_ready_press_enter"
		read dummy
	fi
}

#============================================================================================================
# MAKE & BUILD
#============================================================================================================

# -----------------------------------------------------------------------------------------------------------
# execute MAKE $1=target $2=options
# enable logfile
# -----------------------------------------------------------------------------------------------------------
do_make()
{
	_do_make $* | tee $LOGFILE
	echo "$l_ready_press_enter"
	read dummy
}
# -----------------------------------------------------------------------------------------------------------
_do_make()
{
	echo "=============================================================="
	echo "Make $2 $1"
	date
	echo "=============================================================="
	cd $CVSDIR/cdk
	if [ "$DEBUG" == "1" ];then
		echo "--------------------------------------------------------------"
		echo " ${l_cb_debug_is_on}"
		echo "--------------------------------------------------------------"
		make -n $2 $1
		echo "--------------------------------------------------------------"
		echo " ${l_cb_debug_is_on}"
		echo "--------------------------------------------------------------"
	else
		make $2 $1
	fi
}

# -----------------------------------------------------------------------------------------------------------
# Build $1=Target $2=GUI, $3=Filesystem, $4=Chips
# enable logfile
# -----------------------------------------------------------------------------------------------------------
do_build()
{
	_do_build $* | tee $LOGFILE
	echo "$l_ready_press_enter"
	read dummy
}
# -----------------------------------------------------------------------------------------------------------
_do_build()
{
	echo "=============================================================="
	echo "Build $1 / $2 / $3 / $4"
	date
	echo "=============================================================="
	cd "$CVSDIR/cdk"
	if [ "$1" == "flash" ]; then
		make $1-$2-$3-$4
	elif [ "$1" == "yadd" ]; then
		make $1-$2
  fi
}

#============================================================================================================
# CVS Checkout & Update
#============================================================================================================

# -----------------------------------------------------------------------------------------------------------
# CVS Checkout all
# first checkout "HEAD" then checkout newmake Makefiles
# So the CVS directories have the right tag. You will need this, if you have write access to cvs.
# -----------------------------------------------------------------------------------------------------------
cvs_checkout_all()
{
	patchmgr_restore_files
	_cvs_checkout_all $* | tee $LOGCVSFILE
}
_cvs_checkout_all()
{
	build_dirs
	cvs_debug=""
	if [ "$DEBUG" == "1" ];then
		cvs_debug="-n -t"
	fi

    dialog --backtitle "$prgtitle" --title " checkout "\
		--yesno "Wirklich ALLE files neu auschecken?" 10 40
	opt=${?}
	if [ $opt == 0 ];then
		clear
		echo "=============================================================="
		echo "Start CVS Checkout to $CVSDIR (DEBUG=$DEBUG)"
		echo "=============================================================="

		if [ "$CVSNAME" == "anoncvs" ];then
		# Checkout if CVS-User is anonymous
			echo "--------------------------------------------------------------"
			echo "Checkout newmake anonymous"
			echo "--------------------------------------------------------------"
			cd "$CVSDIR"
			set CVS_RSH=ssh && cvs $cvs_debug -d anoncvs@cvs.tuxbox.org:/cvs/tuxbox -z3 co -f -r newmake -P .
		else
		# Checkout if CVS-User is a registred user
			cd "$CVSDIR"
			echo "--------------------------------------------------------------"
			echo "Checkout HEAD registred"
			echo "--------------------------------------------------------------"
			echo "${l_pm_cvs_registered_user1}: $CVSNAME ${l_pm_cvs_registered_user2}"
			cvs -z3 $cvs_debug -d "$CVSNAME@cvs.tuxbox.org:/cvs/tuxbox" co -P .
			if ! [ -d "$CVSDIR/cdk" ];then
				echo "No cdk dir found in $CVSDIR. STOP"
				exit
			fi
			echo "--------------------------------------------------------------"
			echo "Checkout newmake registred"
			echo "--------------------------------------------------------------"
			cd "$CVSDIR"
			echo "${l_pm_cvs_registered_user1}: $CVSNAME ${l_pm_cvs_registered_user2}"
			cvs -z3 $cvs_debug -d "$CVSNAME@cvs.tuxbox.org:/cvs/tuxbox" co -r newmake -P cdk/newmake.files
			cd "$CVSDIR"
			echo "${l_pm_cvs_registered_user1}: $CVSNAME ${l_pm_cvs_registered_user2}"
			cvs -z3 $cvs_debug -d "$CVSNAME@cvs.tuxbox.org:/cvs/tuxbox" co -f -r newmake `cat cdk/newmake.files`
		fi
		rm $CVSDIR/cdk/root/etc/init.d/rcS $CVSDIR/cdk/root/etc/init.d/rcS.insmod
		echo "$l_ready_press_enter"
		read dummy
	fi
}

# -----------------------------------------------------------------------------------------------------------
# CVS Checkout Update
# -----------------------------------------------------------------------------------------------------------
cvs_checkout_update()
{
	patchmgr_restore_files
	_cvs_checkout_update $* | tee $LOGCVSFILE
}
_cvs_checkout_update()
{
	build_dirs
	cvs_debug=""
	if [ "$DEBUG" == "1" ]; then
		cvs_debug="-n -t"
	fi
    dialog --backtitle "$prgtitle" --title " checkout "\
		--yesno "$l_cb_really_checkout_updated_files" 10 40
	opt=${?}
	if [ $opt == 0 ];then
		clear
		echo "=============================================================="
		echo "Start CVS Checkout UPDATE to $CVSDIR (DEBUG=$DEBUG)"
		echo "=============================================================="
		if [ "$CVSNAME" == "anoncvs" ];then
		# Checkout if CVS-User is anonymous
			echo "--------------------------------------------------------------"
			echo "Checkout newmake anonymous"
			echo "--------------------------------------------------------------"
			cd "$CVSDIR"
			set CVS_RSH=ssh && cvs $cvs_debug -d anoncvs@cvs.tuxbox.org:/cvs/tuxbox -z3 co -f -r newmake -P .
		else
		# Checkout if CVS-User is a registred user
			cd "$CVSDIR"
			echo "--------------------------------------------------------------"
			echo "Checkout HEAD registred"
			echo "--------------------------------------------------------------"
			cvs -z3 $cvs_debug -d "$CVSNAME@cvs.tuxbox.org:/cvs/tuxbox" up -dP
			echo "--------------------------------------------------------------"
			echo "Checkout newmake registred"
			echo "--------------------------------------------------------------"
			cd "$CVSDIR"
			cvs -z3 $cvs_debug -d "$CVSNAME@cvs.tuxbox.org:/cvs/tuxbox" co -r newmake -P cdk/newmake.files
			cd "$CVSDIR"
			cvs -z3 $cvs_debug -d "$CVSNAME@cvs.tuxbox.org:/cvs/tuxbox" co -f -r newmake `cat cdk/newmake.files`
		fi
		rm $CVSDIR/cdk/root/etc/init.d/rcS $CVSDIR/cdk/root/etc/init.d/rcS.insmod
		echo "$l_ready_press_enter"
		read dummy
	fi
}
