#! /bin/bash
# -----------------------------------------------------------------------------------------------------------
# Tuxbox Build & Compiler Helper
# Settings & Info
#
# Started by yjogol (yjogol@online.de)
# $Date: 2008/12/30 15:59:17 $
# $Revision: 1.4 $
# -----------------------------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------------------------
# INIT
# -----------------------------------------------------------------------------------------------------------
yb_log_fileversion "\$Revision: 1.4 $ \$Date: 2008/12/30 15:59:17 $ _yb_settings.inc.sh"

# -----------------------------------------------------------------------------------------------------------
# Menu
# -----------------------------------------------------------------------------------------------------------
settings_menu()
{
	[ "$SDEBUG" != "0" ] && echo "DEBUG: Enter for next Menu" && read dummy

	dialog --backtitle "$prgtitle" --title " $l_settings_and_information "\
		--cancel-label "$l_back"\
		--ok-label "$l_choose"\
		--menu "$l_use_arrow_keys_and_enter" 22 66 17\
		v "$l_se_version_information"\
		d "${l_de_switch_debug} $DEBUG ${l_de_switch_debug_comment}"\
		"" ""\
		b "$l_de_show_build_logfile"\
		c "$l_de_show_configure_logfile"\
		o "$l_de_show_checkout_logfile"\
		p "$l_de_show_patch_logfile"\
		"" ""\
		l "${l_yb_choose_language} ..."\
		n "$l_se_displayname ... ($cYBUILDNAME)"\
		"" ""\
		z "$l_back" 2>$_temp
}

# -----------------------------------------------------------------------------------------------------------
# Menu Loop
# -----------------------------------------------------------------------------------------------------------
settings()
{
	settings_doquit=false
	while [ "$settings_doquit" == "false" ]
	do
		settings_menu
		opt=${?}
		if [ $opt == 0 ]; then
			cmd=`cat $_temp`
			case "$cmd" in
				v)	dialog --title "$l_se_version_information" --msgbox "Version of files:\n$FILEVERSIONLOG" 40 80 ;;
				l)	dialog --backtitle "$prgtitle" --title "$l_yb_choose_language"  --no-cancel --default-item "$cLANG"\
						--menu "$l_use_arrow_keys_and_enter" 12 40 7 \
						de "Deutsch"\
						en "English" 2>$_temp
					cLANG=`cat $_temp`
					config_set_value_direct $yb_configfile cLANG "$cLANG"
					. $SCRIPTDIR/include/_yb_language_${cLANG}.inc.sh
					;;
				b)	dialog --title "Build Logfile" --textbox $LOGFILE 40 80 ;;
				c)	dialog --title "Configure Logfile" --textbox $LOGCONFFILE 40 80 ;;
				o)	dialog --title "CVS Logfile" --textbox $LOGCVSFILE 40 80 ;;
				p)	dialog --title "Patch Logfile" --textbox $LOGPATCHFILE 40 80 ;;

				d)	if [ "$DEBUG" == "0" ]
					then
						DEBUG=1
					else
						DEBUG=0
					fi
					;;
				n)	config_editvariable "cYBUILDNAME" "Standard" "$l_se_displayname_comment" ;;

				z)	settings_doquit="true"	;;
			esac
		else
			settings_doquit=true
		fi
	done
}
