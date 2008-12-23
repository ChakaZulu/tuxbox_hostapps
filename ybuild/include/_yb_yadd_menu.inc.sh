#! /bin/bash
# -----------------------------------------------------------------------------------------------------------
# Tuxbox Build & Compiler Helper
# Enter configuration for yadd-server
#
# Started by yjogol (yjogol@online.de)
# $Date: 2008/12/23 09:00:00 $
# $Revision: 1.2 $
# -----------------------------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------------------------
# INIT
# -----------------------------------------------------------------------------------------------------------
yb_log_fileversion "\$Revision: 1.2 $ \$Date: 2008/12/23 09:00:00 $ _yb_add_menu.inc.sh"

# -----------------------------------------------------------------------------------------------------------
# Menu
# -----------------------------------------------------------------------------------------------------------
setup_menu()
{
	[ "$SDEBUG" != "0" ] && echo "DEBUG: Enter for next Menu" && read dummy

	dialog --backtitle "$prgtitle" --title " $l_d_configure_yadd "\
		--cancel-label "$l_back"\
		--ok-label "$l_choose"\
		--menu "$l_use_arrow_keys_and_enter" 15 66 10\
		y "${l_d_yadd_server_ip}: $cSetupServerIP"\
		i "${l_d_dbox_ip}: $cSetupDboxIP"\
		m "${l_d_dbox_mac}: $cSetupDboxMAC"\
		d "${l_d_dns_server_ip}: $cSetupDNSIP"\
		g "${l_d_dbox_gateway_ip}: $cSetupDboxGatewayIP"\
		s "${l_d_dbox_subnet}: $cSetupServerSubnet"\
		"" ""\
		z "$l_back" 2>$_temp
}

# -----------------------------------------------------------------------------------------------------------
# Menu Loop
# -----------------------------------------------------------------------------------------------------------
setup()
{
	setup_editvalue=""
	setup_doquit=false
	while [ "$setup_doquit" == "false" ]
	do
		setup_menu
		opt=${?}
	 	if [ $opt == 0 ]; then 
			cmd=`cat $_temp`
			case "$cmd" in
				y)	config_editvariable "cSetupServerIP" "192.168.0.37" "$l_d_yadd_server_ip_comment"  ;;
				i)	config_editvariable "cSetupDboxIP" "192.168.0.15" "$l_d_dbox_ip_comment" ;;
				m)	config_editvariable "cSetupDboxMAC" "00:50:9c:42:00:00" "$l_d_dbox_mac_comment" ;;
				d)	config_editvariable "cSetupDNSIP" "192.168.0.1" "$l_d_dns_server_ip_comment" ;;
				g)	config_editvariable "cSetupDboxGatewayIP" "192.168.0.1" "$l_d_dbox_gateway_ip_comment" ;;
				s)	config_editvariable "cSetupServerSubnet" "00:50:9c:42:00:00" "$l_d_dbox_subnet_comment" ;;
				z)	setup_doquit="true" ;;
			esac
		else
			setup_doquit="true"
		fi
	done
}
