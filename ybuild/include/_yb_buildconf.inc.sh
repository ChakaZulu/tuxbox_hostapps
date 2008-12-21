#! /bin/bash
# -----------------------------------------------------------------------------------------------------------
# Tuxbox Build & Compiler Helper
# configure standard build (build selected)
#
# Started by yjogol (yjogol@online.de)
# $Date: 2008/12/21 14:00:58 $
# $Revision: 1.2 $
# -----------------------------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------------------------
# INIT
# -----------------------------------------------------------------------------------------------------------
yb_log_fileversion "\$Revision: 1.2 $ \$Date: 2008/12/21 14:00:58 $ _yb_buildconf.inc.sh"

# -----------------------------------------------------------------------------------------------------------
# Menu
# -----------------------------------------------------------------------------------------------------------
buildconf_menu()
{
	[ "$SDEBUG" != "0" ] && echo "DEBUG: Enter for next Menu" && read dummy

    dialog --backtitle "$prgtitle" --title " $l_build_configuration "\
       	--cancel-label "$l_back"\
    	--ok-label "$l_choose"\
		--menu "$l_use_arrow_keys_and_enter" 13 66 7\
		0 "${l_bt_build_target}: $cBuildTARGET"\
		1 "${l_bt_gui}: $cBuildGUI"\
		2 "${l_bt_filesystem}: $cBuildFS"\
		3 "${l_bt_chips}: $cBuildCHIPS"\
		"" ""\
		z "$l_back" 2>$_temp
}

# -----------------------------------------------------------------------------------------------------------
# Menu Loop, key handling
# -----------------------------------------------------------------------------------------------------------
buildconf()
{
	buildconf_editvalue=""
	buildconf_doquit=false
	while [ "$buildconf_doquit" == "false" ]
	do
		buildconf_menu
		opt=${?}
    	if [ $opt == 0 ]; then 
		    dcmd=`cat $_temp`		

			case "$dcmd" in
				0)	dialog --backtitle "$prgtitle" --title "$l_bt_yadd_or_flash"  --no-cancel --default-item "$cBuildTARGET"\
						--menu "$l_use_arrow_keys_and_enter" 12 40 7 \
						flash "flash"\
						yadd "yadd" 2>$_temp
					cBuildTARGET=`cat $_temp`
					config_set_value_direct $yb_configfile cBuildTARGET "$cBuildTARGET"
					;;
	
				1)	dialog --backtitle "$prgtitle" --title "$l_bt_choose_gui" --no-cancel --default-item "$cBuildGUI"\
						--menu "$l_use_arrow_keys_and_enter" 13 40 8 \
						neutrino "neutrino"\
						enigma "enigma"\
						lcars "lcars"\
						radiobox "radiobox"\
						all "all"\
						null "$l_bt_no_gui"\
						2>$_temp
					cBuildGUI=`cat $_temp`
					config_set_value_direct $yb_configfile cBuildGUI "$cBuildGUI"
					;;

				2)	dialog --backtitle "$prgtitle" --title "$l_bt_choose_filesystem" --no-cancel --default-item "$cBuildFS"\
						--menu "$l_use_arrow_keys_and_enter" 13 40 8 \
						jffs2 "jffs2"\
						squashfs "squashfs"\
						cramfs "cramfs"\
						all "all"\
						2>$_temp
					cBuildFS=`cat $_temp`
					config_set_value_direct $yb_configfile cBuildFS "$cBuildFS"
					;;	
	
				3)	dialog --backtitle "$prgtitle" --title "$l_bt_choose_chips" --no-cancel --default-item "$cBuildCHIPS"\
						--menu "$l_use_arrow_keys_and_enter" 13 40 8 \
						1x "1x"\
						2x "2x"\
						all "all"\
						2>$_temp
					cBuildCHIPS=`cat $_temp`
					config_set_value_direct $yb_configfile cBuildCHIPS "$cBuildCHIPS"
					;;	
				z)	buildconf_doquit="true" ;;
			esac
    	else
			buildconf_doquit="true"
    	fi
	done
}
