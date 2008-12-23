#! /bin/bash
# -----------------------------------------------------------------------------------------------------------
# Tuxbox Build & Compiler Helper
# Customizing Scripts
#
# Started by yjogol (yjogol@online.de)
# $Date: 2008/12/23 08:28:16 $
# $Revision: 1.2 $
# -----------------------------------------------------------------------------------------------------------

#============================================================================================================
# yBuild V3 working note (delete after release)
# languagefile:	ok
# updated:		ok
# tested:		
# issues:		expand for all cust files
#============================================================================================================

# -----------------------------------------------------------------------------------------------------------
# INIT
# -----------------------------------------------------------------------------------------------------------
yb_log_fileversion "\$Revision: 1.2 $ \$Date: 2008/12/23 08:28:16 $ _yb_customize_menu.inc.sh"

# -----------------------------------------------------------------------------------------------------------
# Menu
# -----------------------------------------------------------------------------------------------------------
customizeconf_menu()
{
	c="$CVSDIR/cdk"

	[ "$SDEBUG" != "0" ] && echo "DEBUG: Enter for next Menu" && read dummy

	dialog --backtitle "$prgtitle" --title " $l_customizing_scripts "\
		--cancel-label "$l_back"\
		--ok-label "$l_choose"\
		--menu "$l_use_arrow_keys_and_enter" 20 66 15\
		0 "$l_cm_copy_scripts." \
		"" ""\
		1 "yadd-neutrino-local ($yne)"\
		2 "yadd-none-local ($yno)"\
		3 "yadd-enigma-local ($ye)"\
		4 "root-local.sh ($r)"\
		5 "root-neutrino.jffs2-local.sh ($rnj)"\
		6 "root-neutrino.squashfs-local.sh ($rns)"\
		7 "neutrino-jffs2.img2x-local.sh ($nj2)"\
		"" ""\
		z "$l_back" 2>$_temp
}

# -----------------------------------------------------------------------------------------------------------
# Menu Loop
# -----------------------------------------------------------------------------------------------------------
customizeconf()
{
	c="$CVSDIR/cdk"
	customizeconf_doquit=false
	while [ "$customizeconf_doquit" == "false" ]
	do
		[ -e "$c/yadd-neutrino-local.sh" ] && yne="$l_cm_installed"
		[ -e "$c/yadd-none-local.sh" ] && yno="$l_cm_installed"
		[ -e "$c/yadd-enigma-local" ] && ye="$l_cm_installed"
		[ -e "$c/root-local.sh" ] && r="$l_cm_installed"
		[ -e "$c/root-neutrino.jffs2-local.sh" ] && rnj="$l_cm_installed"
		[ -e "$c/root-neutrino.squashfs-local.sh" ] && rns="$l_cm_installed"
		[ -e "$c/neutrino-jffs2.img2x-local.sh" ] && nj2="$l_cm_installed"
		[ -e "$c/my-customizing.inc" ] && mc="$l_cm_installed"
		[ -e "$c/my-delete-files.inc" ] && mdf="$l_cm_installed"
		customizeconf_menu
		opt=${?}
		if [ $opt == 0 ]; then 
			cmd=`cat $_temp`
			case "$cmd" in
			0)
				cp -v $MyLOCALSDIR/*local.sh $CVSDIR/cdk
				chmod -v u+x $CVSDIR/cdk/*local.sh
				cp -v $MyLOCALSDIR/mkversion $CVSDIR/cdk
				chmod -v u+x $CVSDIR/cdk/mkversion
				echo "$l_ready_press_enter"
				read dummy
				;;
			1)	[ "$yne" != "" ] && dialog --backtitle "$prgtitle" --title " $l_customizing_scripts " --textbox "$c/yadd-neutrino-local.sh" 30 80 ;;
			2)	[ "$yno" != "" ] && dialog --backtitle "$prgtitle" --title " $l_customizing_scripts " --textbox "$c/yadd-none-local.sh" 30 80 ;;
			3)	[ "$ye" != "" ] && dialog --backtitle "$prgtitle" --title " $l_customizing_scripts " --textbox "$c/yadd-enigma-local" 30 80 ;;
			4)	[ "$r" != "" ] && dialog --backtitle "$prgtitle" --title " $l_customizing_scripts " --textbox "$c/root-local.sh" 30 80 ;;
			5)	[ "$rnj" != "" ] && dialog --backtitle "$prgtitle" --title " $l_customizing_scripts " --textbox "$c/root-neutrino.jffs2-local.sh" 30 80 ;;
			6)	[ "$rns" != "" ] && dialog --backtitle "$prgtitle" --title " $l_customizing_scripts " --textbox "$c/root-neutrino.squashfs-local.sh" 30 80 ;;
			7)	[ "$nj2" != "" ] && dialog --backtitle "$prgtitle" --title " $l_customizing_scripts " --textbox "$c/neutrino-jffs2.img2x-local.sh" 30 80 ;;
			8)	[ "$mc" != "" ] && dialog --backtitle "$prgtitle" --title " $l_customizing_scripts " --textbox "$c/my-customizing.inc" 30 80 ;;
			9)	[ "$mdf" != "" ] && dialog --backtitle "$prgtitle" --title " $l_customizing_scripts " --textbox "$c/my-delete-files.inc" 30 80 ;;
			z)	customizeconf_doquit="true"	;;
			esac
		else
			customizeconf_doquit=true
		fi
	done
}
