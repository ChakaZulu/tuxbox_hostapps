#! /bin/bash
# -----------------------------------------------------------------------------------------------------------
# Tuxbox Build & Compiler Helper
# Settings for "configure"
#
# Started by yjogol (yjogol@online.de)
# $Date: 2009/03/03 16:31:16 $
# $Revision: 1.3 $
# -----------------------------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------------------------
# INIT
# -----------------------------------------------------------------------------------------------------------
yb_log_fileversion "\$Revision: 1.3 $ \$Date: 2009/03/03 16:31:16 $ _yb_configureconfinc.sh"

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
		mf "Flash: MMC support" $confmmc_FLASH\
		ef "Flash: Filesystem: ext2/3" $confextfs_FLASH\
		xf "Flash: Filesystem: XFS" $confxfs_FLASH\
		yf "Flash: Filesystem: nfs" $confnfs_FLASH\
		cf "Flash: Filesystem: cifs" $confcifs_FLASH\
		tf "Flash: Filesystem: vfat" $confvfat_FLASH\
		bf "Flash: Filesystem: smbfs" $confsmbfs_FLASH\
		uf "Flash: Filesystem: lufs" $conflufs_FLASH\
		nf "Flash: NFS Server" $confnfsserver_FLASH\
		sf "Flash: Samba Server" $confsambaserver_FLASH\
		df "Flash: DOSFS tools" $confdosfstools_FLASH\
		lf "Flash: lirc" $conflirc_FLASH\
		vf "Flash: cdkVcInfo" $confcdkVcInfo_FLASH\
		gf "Flash: german-keymaps" $confgermankeymaps_FLASH\
		pf "Flash: upnp client" $confupnp_FLASH\
		ff "Flash: flac" $confflac_FLASH\
		af "Flash: patch before configure (autom.)" $confautopatch_FLASH\
		"" "" off\
		iy "YADD: IDE support" $confide_YADD\
		my "YADD: MMC support" $confmmc_YADD\
		ey "YADD: Filesystem: ext2/3" $confextfs_YADD\
		xy "YADD: Filesystem: XFS" $confxfs_YADD\
		yy "YADD: Filesystem: nfs" $confnfs_YADD\
		cy "YADD: Filesystem: cifs" $confcifs_YADD\
		ty "YADD: Filesystem: vfat" $confvfat_YADD\
		by "YADD: Filesystem: smbfs" $confsmbfs_YADD\
		uy "YADD: Filesystem: lufs" $conflufs_YADD\
		ny "YADD: NFS Server" $confnfsserver_YADD\
		sy "YADD: Samba Server" $confsambaserver_YADD\
		dy "YADD: DOSFS tools" $confdosfstools_YADD\
		ly "YADD: lirc" $conflirc_YADD\
		vy "YADD: cdkVcInfo" $confcdkVcInfo_YADD\
		gy "YADD: german-keymaps" $confgermankeymaps_YADD\
		py "YADD: upnp client" $confupnp_YADD\
		fy "YADD: flac" $confflac_YADD\
		ay "YADD: patch before configure (autom.)" $confautopatch_YADD\
		"" "" off\
		0 "use ccache" $confccache\
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
		# init not defined variables
		for i in "ide" "mmc" "extfs" "xfs" "nfs" "cifs" "vfat" "smbfs" "lufs" "nfsserver" "sambaserver"\
		"dosfstools" "lirc" "cdkVcInfo" "germankeymaps" "upnp" "flac"
		do
			varname="conf${i}_FLASH"
			val=${!varname}
			if [ "$val" == "" ]; then
				eval $varname='off'
			fi
			varname="conf${i}_YADD"
			val=${!varname}
			if [ "$val" == "" ]; then
				eval $varname='off'
			fi
		done
		configureconf_menu_flags
		opt=${?}
		dcmd=`cat $_temp`
		if [ "$opt" == "0" -a "$dcmd" != "z" ]; then
			dialog --backtitle "$prgtitle" --title " $l_save "\
				--infobox "$l_save" 5 20 
			for i in "if" "ef" "xf" "nf" "sf" "df" "lf" "vf" "gf" "af" "uf" "ff" "yf" "cf" "tf" "bf" "pf"\
					"iy" "ey" "xy" "ny" "sy" "dy" "ly" "vy" "gy" "ay" "uy" "fy" "yy" "cy" "ty" "by" "py"\
					"0" "1" "6" "2" 
			do
				first=${i:0:1}
				second=${i:1:1}
				setting=""
				setting2=""
				case "$first" in
					i)	setting="confide" ;;
					m)	setting="confmmc" ;;
					l)	setting="conflirc" ;;
					v)	setting="confcdkVcInfo" ;;
					g)	setting="confgermankeymaps" ;;
					e)	setting="confextfs" ;;
					x)	setting="confxfs" ;;
					y)	setting="confnfs" ;;
					c)	setting="confcifs" ;;
					t)	setting="confvfat" ;;
					b)	setting="confsmbfs" ;;
					u)	setting="conflufs" ;;
					n)	setting="confnfsserver" ;;
					s)	setting="confsambaserver" ;;
					d)	setting="confdosfstools" ;;
					a)	setting="confautopatch" ;;
					p)	setting="confupnp" ;;
					f)	setting="confflac" ;;
					0)	setting2="confccache" ;;
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
