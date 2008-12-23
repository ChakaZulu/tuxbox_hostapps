#! /bin/bash
# -----------------------------------------------------------------------------------------------------------
# Tuxbox Build & Compiler Helper
# Startmenue
#
# Started by yjogol (yjogol@online.de)
# $Date: 2008/12/23 09:00:00 $
# $Revision: 1.3 $
# -----------------------------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------------------------
# INIT
# -----------------------------------------------------------------------------------------------------------
yb_log_fileversion "\$Revision: 1.3 $ \$Date: 2008/12/23 09:00:00 $ _yb_start_menu.inc.sh"

# -----------------------------------------------------------------------------------------------------------
# Main Menu
# -----------------------------------------------------------------------------------------------------------
start_menu()
{
	[ "$SDEBUG" != "0" ] && echo "DEBUG: Enter for next Menu" && read dummy
	
	# build info
	if [ "$cBuildTARGET" == "flash" ]; then
		target=$cBuildTARGET-$cBuildGUI-$cBuildFS-$cBuildCHIPS
	else
		target=$cBuildTARGET-$cBuildGUI
	fi

	# dialog
	dialog --backtitle "$prgtitle" --title " $l_main_menu "\
		--cancel-label "$l_exit"\
		--ok-label "$l_choose"\
		--menu "$l_use_arrow_keys_and_enter" 24 66 19 \
		c "$l_checkout_comlete" \
		u "$l_checkout_update" \
		f "$l_configure_flash" \
		y "$l_configure_yadd" \
		"" ""\
		p "$l_apply_patches" \
		g "$l_build_all_in_one"\
		i "$l_build_configuration ..."\
		s "$l_build_selected (make $target)"\
		m "$l_make_targets ..."\
		a "$l_customizing_scripts ..."\
		"" ""\
		d "$l_configuration_and_developmenttools ..." \
		e "${l_settings_and_information} ..."\
		0 "${l_plugins} ..."\
		"" ""\
		x "$l_exit" 2>$_temp
}

# -----------------------------------------------------------------------------------------------------------
# MAIN loop, key handling
# -----------------------------------------------------------------------------------------------------------
start()
{
	init_variables
	doquit=false
	while [ "$doquit" == "false" ]
	do
		start_menu
		opt=${?}
		if [ $opt != 0 ]; then rm $_temp; exit; fi
		cmd=`cat $_temp`
		case "$cmd" in
			c)	cvs_checkout_all ;;
			u)	cvs_checkout_update ;;
			f)	do_configure_flash ;;
			y)	do_configure_yadd ;;
			p)	patchmgr_patch
				echo "$l_ready_press_enter"
				read dummy
				;;
			g)	cvs_checkout_update
				do_configure_flash
				do_build $cBuildTARGET $cBuildGUI $cBuildFS $cBuildCHIPS
				;;
			i)	buildconf
				init_variables
				;;
			s)	do_build $cBuildTARGET $cBuildGUI $cBuildFS $cBuildCHIPS ;;
			m)	maketargets	;;
			a)	customizeconf ;;
			d)	devconf	;;
			b)	ybuildconf ;;
			e)	settings ;;
			0)	yb_plugins ;;
			x)	doquit="true" ;;
		esac
	done
}
