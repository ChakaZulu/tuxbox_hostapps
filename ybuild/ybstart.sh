#! /bin/bash
# -----------------------------------------------------------------------------------------------------------
# Tuxbox Build & Compiler Helper
# Start Script
#
# Started by yjogol (yjogol@online.de)
# $Date: 2008/12/22 16:32:06 $
# $Revision: 1.2 $
# -----------------------------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------------------------
# $1: Versioninformation
# -----------------------------------------------------------------------------------------------------------
yb_log_fileversion()
{
	FILEVERSIONLOG=`echo "$FILEVERSIONLOG $1\n"`
	echo "$1" >>"$LOGYBUILDFILE"
}
# -----------------------------------------------------------------------------------------------------------
# $1: Information
# -----------------------------------------------------------------------------------------------------------
yb_debug()
{
	echo "DEBUG: $1"
	echo "DEBUG: $1" >>"$LOGYBUILDFILE"
}
# -----------------------------------------------------------------------------------------------------------
# Globals
# -----------------------------------------------------------------------------------------------------------
	SDEBUG=${1:-0} 		# Script debug: use yb_start 1 to start in debug mode
	DEBUG=0				# DEBUG: debug configure and cvs using cvs simulation
	FILEVERSIONLOG=""	# Log of ybuild-Fileversions	

	if [ -e ./yb_globals.conf ]; then
		SCRIPTDIR=`pwd`
	else
		SCRIPTDIR=$HOME/tuxbox/ybuild
	fi
	export SCRIPTDIR
	[ "$SDEBUG" != "0" ] && echo "SCRIPTDIR: $SCRIPTDIR"
	
	# define filenames & directories
	yb_configfile=$SCRIPTDIR/yb_globals.conf
	LOGFILE=$SCRIPTDIR/build.log
	LOGCVSFILE=$SCRIPTDIR/checkout.log
	LOGDISTFILE=$SCRIPTDIR/distribution.log
	LOGCONFFILE=$SCRIPTDIR/configure.log
	LOGPATCHFILE=$SCRIPTDIR/patching.log
	LOGYBUILDFILE=$SCRIPTDIR/ybuild.log
	yb_templatedir=$SCRIPTDIR/templates
	complete_diff="all.diff"
	yb_plugindir=$SCRIPTDIR/plugins
	yb_plugin_count=0
	cLANG=${lang:=de}
	
	## TODO: Change ccache handling
	if [ "`which ccache`" == "" ]; then
		HAVE_CCACHE="ccache not installed"
	else
		HAVE_CCACHE="ccache installed"
	fi
	_temp="/tmp/answer.$$"
	dialog 2>$_temp
	echo "yBuild " >$LOGYBUILDFILE

# -----------------------------------------------------------------------------------------------------------
# Inculde Settings & modules
# -----------------------------------------------------------------------------------------------------------
	. $yb_configfile
	. $SCRIPTDIR/include/_yb_language_${cLANG}.inc.sh
	. $SCRIPTDIR/include/_yb_configfile.inc.sh
	. $SCRIPTDIR/include/_yb_build.inc.sh
	. $SCRIPTDIR/include/_yb_start_menu.inc.sh
	. $SCRIPTDIR/include/_yb_basisconf.inc.sh
	. $SCRIPTDIR/include/_yb_buildconf.inc.sh
	. $SCRIPTDIR/include/_yb_yadd_menu.inc.sh
	. $SCRIPTDIR/include/_yb_configureconf.inc.sh
	. $SCRIPTDIR/include/_yb_maketargets.inc.sh
	. $SCRIPTDIR/include/_yb_patchmgr.inc.sh
	. $SCRIPTDIR/include/_yb_dev_menu.inc.sh
	. $SCRIPTDIR/include/_yb_dev_func.inc.sh
	. $SCRIPTDIR/include/_yb_customize_menu.inc.sh
	. $SCRIPTDIR/include/_yb_settings.inc.sh
	. $SCRIPTDIR/include/_yb_plugins.inc.sh
	# include plugins
	if [ -e $yb_plugindir ]; then
		find "$yb_plugindir" -name "*.plugin.sh" >/tmp/plugins.txt
		while read plugin
		do
			. $plugin
		done < /tmp/plugins.txt
	fi

# -----------------------------------------------------------------------------------------------------------
# MAIN
# -----------------------------------------------------------------------------------------------------------
	init_variables
	prgtitle="$l_yb_headline"

	dia=`which dialog`
	if [ "$dia" == "" ]; then
		echo "$l_component_not_installed"
		echo "$l_install_dialog_component"
		check_inst_pkg "dialog" "dialog" "dialog"
	else
		start
	fi
