#! /bin/bash
# -----------------------------------------------------------------------------------------------------------
# Tuxbox Build & Compiler Helper
# Plugin: hello World
#
# Started by yjogol (yjogol@online.de)
# $Date: 2008/12/22 16:33:00 $
# $Revision: 1.1 $
# -----------------------------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------------------------
# INIT
# -----------------------------------------------------------------------------------------------------------

yb_log_fileversion "\$Revision: 1.1 $ \$Date: 2008/12/22 16:33:00 $ _yb_helloworld.plugin.sh"
yb_plugin_add "HelloWorld" "_yb_helloworld.plugin.sh" "yb_plugin_helloworld"

# -----------------------------------------------------------------------------------------------------------
# Menu
# -----------------------------------------------------------------------------------------------------------
yb_plugin_helloworld_menu()
{
	[ "$SDEBUG" != "0" ] && echo "DEBUG: Enter for next Menu" && read dummy

	dialog --backtitle "$prgtitle" --title " Hello world "\
		--cancel-label "$l_back"\
		--ok-label "$l_choose"\
		--menu "$l_use_arrow_keys_and_enter" 14 66 9\
		0 "say hello"\
		"" ""\
		z "$l_back" 2>$_temp
}

# -----------------------------------------------------------------------------------------------------------
# Menu Loop
# -----------------------------------------------------------------------------------------------------------
yb_plugin_helloworld()
{
	yb_plugin_helloworld_doquit=false
	while [ "$yb_plugin_helloworld_doquit" == "false" ]
	do
		yb_plugin_helloworld_menu
		opt=${?}
		if [ $opt == 0 ]; then
			cmd=`cat $_temp`
			case "$cmd" in
				0)	dialog --backtitle "$prgtitle" --title " hello world "\
				--msgbox "this is the hello world msgbox" 5 50 ;;
				z)	yb_plugin_helloworld_doquit="true"	;;
			esac
		else
			yb_plugin_helloworld_doquit=true
		fi
	done
}
