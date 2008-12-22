#! /bin/bash
# -----------------------------------------------------------------------------------------------------------
# Tuxbox Build & Compiler Helper
# yBuild Plugins
#
# Started by yjogol (yjogol@online.de)
# $Date: 2008/12/22 16:32:47 $
# $Revision: 1.2 $
# -----------------------------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------------------------
# INIT
# -----------------------------------------------------------------------------------------------------------
yb_log_fileversion "\$Revision: 1.2 $ \$Date: 2008/12/22 16:32:47 $ _yb_plugins.inc.sh"

# -----------------------------------------------------------------------------------------------------------
# Menu
# -----------------------------------------------------------------------------------------------------------
yb_plugins_menu()
{
	[ "$SDEBUG" != "0" ] && echo "DEBUG: Enter for next Menu" && read dummy

	dia='dialog --backtitle "$prgtitle" --title " $l_plugins "\
		--cancel-label "$l_back"\
		--ok-label "$l_choose"\
		--menu "$l_use_arrow_keys_and_enter" 14 66 9\
		"" ""'
	# build plugin menu
	i=0
	echo "count:$yb_plugin_count"
	while [ $i -lt $yb_plugin_count ]
	do
		eval pn=plugin_name_${i}
		dia="$dia $i \"${!pn}\""
		i=`expr $i + 1`
	done
	dia="$dia \"z\" \"$l_back\" 2>$_temp"
	eval "$dia"
}

# -----------------------------------------------------------------------------------------------------------
# Menu Loop
# -----------------------------------------------------------------------------------------------------------
yb_plugins()
{
	yb_plugins_doquit=false
	while [ "$yb_plugins_doquit" == "false" ]
	do
		yb_plugins_menu
		opt=${?}
		if [ $opt == 0 ]; then 
			cmd=`cat $_temp`
			if [ $cmd -lt $yb_plugin_count ]; then
				eval func=plugin_start_${cmd}
				eval ${!func}
			fi
		else
			yb_plugins_doquit=true
		fi
	done
}

# -----------------------------------------------------------------------------------------------------------
# plugin library
# -----------------------------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------------------------
# add a plugin to list
# $1: Name of Plugin, $2: pluginfile, $3: function to start for plugin
# -----------------------------------------------------------------------------------------------------------
yb_plugin_add()
{
	eval plugin_name_${yb_plugin_count}='$1'
	eval plugin_file_${yb_plugin_count}='$2'
	eval plugin_start_${yb_plugin_count}='$3'
	yb_plugin_count=`expr $yb_plugin_count + 1`
}

