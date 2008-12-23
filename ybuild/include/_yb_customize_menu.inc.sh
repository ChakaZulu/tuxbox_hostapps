#! /bin/bash
# -----------------------------------------------------------------------------------------------------------
# Tuxbox Build & Compiler Helper
# Customizing Scripts
#
# Started by yjogol (yjogol@online.de)
# $Date: 2008/12/23 15:11:34 $
# $Revision: 1.4 $
# -----------------------------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------------------------
# INIT
# -----------------------------------------------------------------------------------------------------------
yb_log_fileversion "\$Revision: 1.4 $ \$Date: 2008/12/23 15:11:34 $ _yb_customize_menu.inc.sh"
inx="0123456789abcdefghijklmnopqrstuvwxyABCDEFGHIJKLMNOPQRSTUVWXYZ"

# -----------------------------------------------------------------------------------------------------------
# Menu
# -----------------------------------------------------------------------------------------------------------
customizeconf_menu()
{
	[ "$SDEBUG" != "0" ] && echo "DEBUG: Enter for next Menu" && read dummy

	dia='dialog --backtitle "$prgtitle" --title " $l_customizing_scripts "\
		--cancel-label "$l_back"\
		--ok-label "$l_choose"\
		--menu "$l_use_arrow_keys_and_enter\n$locales_count $l_cm_scripts_found" 20 66 15\
		"" ""'
	# build locale menu
	i=0
	while [ $i -lt $locales_count ]
	do
		nr=${inx:$i:1}
		eval pn=locale_${nr}
		bn=`basename ${!pn}`
		dia="$dia $nr \"$bn\""
		i=`expr $i + 1`
	done
	dia="$dia \"z\" \"$l_back\" 2>$_temp"
	
	eval "$dia"
}

# -----------------------------------------------------------------------------------------------------------
# Menu Loop
# -----------------------------------------------------------------------------------------------------------
customizeconf()
{
	c="$MyLOCALSDIR"
	customizeconf_refresh
	customizeconf_doquit=false
	while [ "$customizeconf_doquit" == "false" ]
	do
		customizeconf_menu
		opt=${?}
		if [ $opt == 0 ]; then 
			cmd=`cat $_temp`
			if [ "$cmd" != "z" ]; then
				eval pn=locale_${cmd}
				dialog --backtitle "$prgtitle" --title " $l_customizing_scripts " \
				--textbox "${!pn}" 30 80
			else
				customizeconf_doquit="true"
			fi
		else
			customizeconf_doquit=true
		fi
	done
}
# -----------------------------------------------------------------------------------------------------------
customizeconf_refresh()
{
	locales_count=0
	find "$MyLOCALSDIR" -name "*-local.sh" >/tmp/locals.txt
	while read alocal
	do
		nr=${inx:$locales_count:1}
		eval locale_${nr}='$alocal'
		locales_count=`expr $locales_count + 1`
	done < /tmp/locals.txt
}
