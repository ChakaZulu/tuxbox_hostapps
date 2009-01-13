#! /bin/bash
# -----------------------------------------------------------------------------------------------------------
# Tuxbox Build & Compiler Helper
# Development Environment
#
# Started by yjogol (yjogol@online.de)
# $Date: 2009/01/13 20:02:06 $
# $Revision: 1.3 $
# -----------------------------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------------------------
# INIT
# -----------------------------------------------------------------------------------------------------------
yb_log_fileversion "\$Revision: 1.3 $ \$Date: 2009/01/13 20:02:06 $ _yb_dev_menu.inc.sh"

# -----------------------------------------------------------------------------------------------------------
# Menu
# -----------------------------------------------------------------------------------------------------------
devconf_menu()
{
	[ "$SDEBUG" != "0" ] && echo "DEBUG: Enter for next Menu" && read dummy

	dialog --backtitle "$prgtitle" --title " $l_de_development_environment "\
		--cancel-label "$l_back"\
		--ok-label "$l_choose"\
		--menu "$l_use_arrow_keys_and_enter" 21 66 16\
		0 "${l_de_basis_configuration} ..." \
		1 "${l_de_configure_configuration} ..."\
		"" ""\
		s "${l_de_configure_yadd_server} ..." \
		e "${l_de_install_development_tools}"\
		i "${l_de_install_yadd_server}"\
		p "${l_de_patch_manager} ..."\
		t "$l_de_toolchecker"\
		"" ""\
		x "$l_de_dhcp_start"\
		y "$l_de_dhcp_stop"\
		c "${l_de_clear_compiler_cache} ($HAVE_CCACHE)"\
		"" ""\
		z "$l_back" 2>$_temp
}

# -----------------------------------------------------------------------------------------------------------
# Menu Loop
# -----------------------------------------------------------------------------------------------------------
devconf()
{
	devconf_doquit=false
	while [ "$devconf_doquit" == "false" ]
	do
		devconf_menu
		opt=${?}
		if [ $opt == 0 ]; then 
			cmd=`cat $_temp`
			case "$cmd" in
				0)	basisconf
					init_variables
					;;
				1)	configureconf_loop
					init_variables
					;;
				s)	setup ;;
				p)	patchmgr ;;
				y)	cd /etc/init.d
					sudo /etc/init.d/dhcp3-server stop
					echo "$l_ready_press_enter"
					read dummy
					;;
				x)	cd /etc/init.d
					sudo /etc/init.d/dhcp3-server start
					echo "$l_ready_press_enter"
					read dummy
					;;
				c)	$CCACHEPAPTH -c
					echo "$l_ready_press_enter"
					read dummy
					;;
				t)	$CVSDIR/hostapps/toolchecker/toolchecker.sh >/tmp/toolcheck.txt
					dialog --title "$l_toolchecker_results" --textbox "/tmp/toolcheck.txt" 40 80
					;;
				i)	install_yadd ;;
				e)	install_devtools ;;
				z)	devconf_doquit="true"	;;
			esac
		else
			devconf_doquit=true
		fi
	done
}
