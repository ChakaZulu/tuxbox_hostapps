#! /bin/bash
# -----------------------------------------------------------------------------------------------------------
# Tuxbox Build & Compiler Helper
# Start Script
#
# Started by yjogol (yjogol@online.de)
# $Date: 2008/12/25 07:53:42 $
# $Revision: 1.5 $
# -----------------------------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------------------------
# register each include-file. Should be first line ($1: Versioninformation)
# -----------------------------------------------------------------------------------------------------------
yb_log_fileversion()
{
	FILEVERSIONLOG=`echo "$FILEVERSIONLOG $1\n"`
	echo "$1" >>"$LOGYBUILDFILE"
}
# -----------------------------------------------------------------------------------------------------------
# Write Debuginformation ybuilg-log ($1: Information)
# -----------------------------------------------------------------------------------------------------------
yb_debug()
{
	echo "DEBUG: $1"
	echo "DEBUG: $1" >>"$LOGYBUILDFILE"
}

# -----------------------------------------------------------------------------------------------------------
# Globals
# -----------------------------------------------------------------------------------------------------------
	SDEBUG=${1:-0} 							# Script debug: use yb_start 1 to start in debug mode
	DEBUG=0									# DEBUG: debug configure and cvs using cvs simulation
	FILEVERSIONLOG=""						# Log of ybuild-Fileversions
	yb_plugin_count=0						# init number of plugins
	tmp_LD_LIBRARY_PATH=$LD_LIBRARY_PATH	# Backup LD_LIBRARY_PATH
	unset LD_LIBRARY_PATH					# Cleat LD_LIBRARY_PATH
	_temp="/tmp/answer.$$"					# name for return variable for dialog handling
	dialog 2>$_temp							# init return variable for dialog handling

	tmp=`dirname $0`						# determine foldername with ybuild scripts
	if [ "$tmp" == "." ]; then
		SCRIPTDIR=`pwd`
	else
		SCRIPTDIR=`pwd`"/$tmp"
	fi
	export SCRIPTDIR
	[ "$SDEBUG" != "0" ] && echo "SCRIPTDIR: $SCRIPTDIR"

	yb_configfile=$SCRIPTDIR/yb_globals.conf # define filenames & directories
	LOGFILE=$SCRIPTDIR/build.log
	LOGCVSFILE=$SCRIPTDIR/checkout.log
	LOGDISTFILE=$SCRIPTDIR/distribution.log
	LOGCONFFILE=$SCRIPTDIR/configure.log
	LOGPATCHFILE=$SCRIPTDIR/patching.log
	LOGYBUILDFILE=$SCRIPTDIR/ybuild.log
	yb_templatedir=$SCRIPTDIR/templates
	yb_plugindir=$SCRIPTDIR/plugins
	complete_diff="all.diff"				# name for diff against cvs 'all'

	## TODO: Change ccache handling
	if [ "`which ccache`" == "" ]; then
		HAVE_CCACHE="ccache not installed"
	else
		HAVE_CCACHE="ccache installed"
	fi
# -----------------------------------------------------------------------------------------------------------
# Initialization
# -----------------------------------------------------------------------------------------------------------
	cp $yb_configfile ${yb_configfile}.bak 	# make a backup of the conf-file
	echo "yBuild " >$LOGYBUILDFILE			# start ybuild-logfile
	yb_log_fileversion "\$Revision: 1.5 $ \$Date: 2008/12/25 07:53:42 $ ybstart.sh"

# -----------------------------------------------------------------------------------------------------------
# Inculde Settings & modules
# -----------------------------------------------------------------------------------------------------------
	. $yb_configfile
	cLANG=${lang:=de}						# set default language
	
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
	init_variables							# init directory name expansion

	# include plugins (*.plugin.sh)
	if [ -e $yb_plugindir ]; then
		find "$yb_plugindir" -name "*.plugin.sh" >/tmp/plugins.txt
		while read plugin
		do
			. $plugin
		done < /tmp/plugins.txt
	fi
	# view ybuild instance name (for multiple ybuilds)
	if [ "$cYBUILDNAME" != "" ]; then
		l_yb_headline="$l_yb_headline ($cYBUILDNAME)"
	fi
# -----------------------------------------------------------------------------------------------------------
# MAIN
# -----------------------------------------------------------------------------------------------------------
	prgtitle="$l_yb_headline"

	have_dash=`ls -al /bin/sh|grep "dash"`	# check for dash/bash
	if [ "$have_dash" != "" ]; then
		echo "Your Linux uses dash-shell for default."
		echo "This is not recommend for the tuxboy-project"
		echo "Correct this (y/n)"
		read yesno
		if [ "$yesno" == "y" ]; then
			echo "you may asked for the root-password"
			sudo ln -sf /bin/bash /bin/sh
		fi
	fi

	dia=`which dialog`						# check for package dialog
	if [ "$dia" == "" ]; then
		echo "$l_component_not_installed"
		echo "$l_install_dialog_component"
		check_inst_pkg "dialog" "dialog" "dialog"
	else
		start								# start ybuild dialogs
	fi

# -----------------------------------------------------------------------------------------------------------
# clean up
# -----------------------------------------------------------------------------------------------------------
	LD_LIBRARY_PATH=$tmp_LD_LIBRARY_PATH
	