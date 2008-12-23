#! /bin/bash
# -----------------------------------------------------------------------------------------------------------
# Tuxbox Build & Compiler Helper
# Settings for "configure"
#
# Started by yjogol (yjogol@online.de)
# $Date: 2008/12/23 09:00:00 $
# $Revision: 1.2 $
# -----------------------------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------------------------
# INIT
# -----------------------------------------------------------------------------------------------------------
yb_log_fileversion "\$Revision: 1.2 $ \$Date: 2008/12/23 09:00:00 $ _yb_configureconfinc.sh"

# -----------------------------------------------------------------------------------------------------------
# Menu: Configure Values
# -----------------------------------------------------------------------------------------------------------
configureconf_menu()
{
	dialog --backtitle "$prgtitle" --title " $l_de_configure_configuration "\
		--ok-label "$l_save"\
		--cancel-label "$l_back"\
		--form "$l_cc_choose_flags" 20 60 10\
			"RootPartitionSize:" 1 1 "$ROOTPARTSIZE" 1 20 10 0\
			"Update http URL..:" 2 1 "$UPDATEHTTPPREFIX" 2 20 20 255\
			2>$_temp
}
# -----------------------------------------------------------------------------------------------------------
configureconf_menu_loop()
{
		configureconf_menu
		opt=${?}
		dcmd=`cat $_temp`
		if [ "$opt" == "0" ]; then
			j=1
			echo "$dcmd"| \
			while read i
			do
				case "$j" in
					1) vn="ROOTPARTSIZE" ;;
					2) vn="UPDATEHTTPPREFIX" ;;
				esac
				config_varset "$vn" "$i"
				eval ${vn}="$i"
				j=`expr $j + 1`
			done
		fi
}
# -----------------------------------------------------------------------------------------------------------
# Menu: Configure Flags
# -----------------------------------------------------------------------------------------------------------
configureconf_menu_flags()
{
 	[ "$SDEBUG" != "0" ] && echo "DEBUG: Enter for next Menu" && read dummy

	dialog --clear \
		--backtitle "$prgtitle" --title " $l_de_configure_configuration "\
		--ok-label "$l_save"\
		--cancel-label "$l_back"\
 		--extra-button\
		--extra-label "$l_others"\
		--separate-output\
		--checklist "$l_cc_choose_option" 30 50 26 \
		if "Flash: IDE support" $confide_FLASH\
		ef "Flash: ext2/3 Filesystem" $confext3_FLASH\
		xf "Flash: XFS Filesystem" $confxfs_FLASH\
		nf "Flash: nfs-server" $confnfsserver_FLASH\
		sf "Flash: Samba Server" $confsambaserver_FLASH\
		df "Flash: DOSFS tools" $confdosfstools_FLASH\
		lf "Flash: lirc" $conflirc_FLASH\
		vf "Flash: cdkVcInfo" $confcdkVcInfo_FLASH\
		gf "Flash: german-keymaps" $confgermankeymaps_FLASH\
		uf "Flash: upnp client" $confupnp_FLASH\
		ff "Flash: flac" $confflac_FLASH\
		af "Flash: patch before configure (autom.)" $confautopatch_FLASH\
		"" "" off\
		iy "YADD: IDE support" $confide_YADD\
		ey "YADD: ext2/3 Filesystem" $confext3_YADD\
		xy "YADD: XFS Filesystem" $confxfs_YADD\
		ny "YADD: nfs-server" $confnfsserver_YADD\
		sy "YADD: Samba Server" $confsambaserver_YADD\
		dy "YADD: DOSFS tools" $confdosfstools_YADD\
		ly "YADD: lirc" $conflirc_YADD\
		vy "YADD: cdkVcInfo" $confcdkVcInfo_YADD\
		gy "YADD: german-keymaps" $confgermankeymaps_YADD\
		uy "YADD: upnp client" $confupnp_YADD\
		fy "YADD: flac" $confflac_YADD\
		ay "YADD: patch before configure (autom.)" $confautopatch_YADD\
		"" "" off\
		c "use ccache" $confccache\
		1 "use uclibc" $confuclibc\
		6 "Build kernel 2.6"  $confkernel26\
		2 "Build Image LZMA" $conflzma\
		2>$_temp
}
# -----------------------------------------------------------------------------------------------------------
# Menu Loop
# -----------------------------------------------------------------------------------------------------------
configureconf_loop()
{
	configureconf_doquit=false
	while [ "$configureconf_doquit" == "false" ]
	do
		configureconf_menu_flags
		opt=${?}
		dcmd=`cat $_temp`
		if [ "$opt" == "0" -a "$dcmd" != "z" ]; then
			dialog --backtitle "$prgtitle" --title " $l_save "\
				--infobox "$l_save" 5 20 
			for i in "if" "ef" "xf" "nf" "sf" "df" "lf" "vf" "gf" "af" "uf" "ff"\
					"iy" "ey" "xy" "ny" "sy" "dy" "ly" "vy" "gy" "ay" "uy" "fy"\
					"c" "1" "6" "2" 
			do
				first=${i:0:1}
				second=${i:1:1}
				setting=""
				setting2=""
				case "$first" in
					i)	setting="confide" ;;
					l)	setting="conflirc" ;;
					v)	setting="confcdkVcInfo" ;;
					g)	setting="confgermankeymaps" ;;
					e)	setting="confext3" ;;
					x)	setting="confxfs" ;;
					n)	setting="confnfsserver" ;;
					s)	setting="confsambaserver" ;;
					d)	setting="confdosfstools" ;;
					a)	setting="confautopatch" ;;
					u)	setting="confupnp" ;;
					f)	setting="confflac" ;;
					c)	setting2="confccache" ;;
					1)	setting2="confuclibc" ;;
					6)	setting2="confkernel26" ;;
					2)	setting2="conflzma" ;;
				esac
				val="off"
				for y in $dcmd
				do
					if [ $i == $y ]; then
						val="on"
					fi
				done
				if [ "$setting" != "" ]; then
					if [ "$second" == "y" ]; then
						config_varset "$setting"_YADD "$val"
					fi
					if [ "$second" == "f" ]; then
						config_varset "$setting"_FLASH "$val"
					fi
				fi
				if [ "$setting2" != "" ]; then
					config_varset "$setting2" "$val"
				fi
			done
		else
			if [ "$opt" == "3" ]; then
				configureconf_menu_loop
			else
				configureconf_doquit=true
			fi 
		fi
	done
}
