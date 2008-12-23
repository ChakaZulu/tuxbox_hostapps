#! /bin/bash
# -----------------------------------------------------------------------------------------------------------
# Tuxbox Build & Compiler Helper
# by yjogol (yjogol@online.de)
#
# Started Maketargets by Tommy
# $Date: 2008/12/23 09:00:00 $
# $Revision: 1.2 $
# -----------------------------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------------------------
# INIT
# -----------------------------------------------------------------------------------------------------------
yb_log_fileversion "\$Revision: 1.2 $ \$Date: 2008/12/23 09:00:00 $ _yb_maketargets.inc.sh"

# -----------------------------------------------------------------------------------------------------------
# Menu
# -----------------------------------------------------------------------------------------------------------
maketargets_menu()
{
	[ "$SDEBUG" != "0" ] && echo "DEBUG: Enter for next Menu" && read dummy

	dialog --backtitle "$prgtitle" --title " $l_make_targets "\
		--cancel-label "$l_back"\
		--ok-label "$l_choose"\
		--menu "$l_use_arrow_keys_and_enter" 36 66 31\
		0 "YADD  - Neutrino" \
		1 "YADD  - Enigma" \
		2 "YADD  - LCARS" \
		3 "YADD  - all" \
		"" ""\
		5 "Flash - Neutrino" \
		6 "Flash - Enigma" \
		7 "Flash - LCARS" \
		8 "Flash - all" \
		"" ""\
		c "make ccache"\
		p "make Plugins"\
		f "make Funstuff"\
		h "make Hostapps" \
		"" ""\
		a "make flash automount"\
		y "make yadd automount"\
		"" ""\
		q "Clean: make flash-semiclean"\
		r "Clean: make flash-mostlyclean"\
		s "Clean: make flash-clean"\
		"" ""\
		t "Clean: make mostlyclean"\
		u "Clean: make clean"\
		v "Clean: make distclean"\
		"" ""\
		w "Clean: Clean All (remove $cCVSDIR/* and $cDBOX_PREFIX/*)"\
		"" ""\
		z "$l_back" 2>$_temp
}

# -----------------------------------------------------------------------------------------------------------
# Menu Loop
# -----------------------------------------------------------------------------------------------------------
maketargets()
{
	maketargets_doquit=false
	while [ "$maketargets_doquit" == "false" ]
	do
		maketargets_menu
		opt=${?}
		if [ $opt == 0 ]; then 
			cmd=`cat $_temp`
			case "$cmd" in
				0)	do_build yadd neutrino "" "" ;;
				1)	do_make yadd-enigma ;;
				2)	do_make yadd-lcars ;;
				3) 	do_build flash all all all ;;
				5)	do_make flash-neutrino ;;
				6)	do_make flash-enigma ;;
				7)	do_make flash-lcars ;;
				8)  do_build flash all all all ;;
				p)	do_make plugins ;;
				f)	do_make funstuff ;;
				h)	do_make hostapps ;;
				c)	do_make ccache ;;
				a)  do_make flash-automount ;;
				y)  do_make automount ;;
				
				q)	do_make flash-semiclean ;;
				r)	do_make flash-mostlyclean ;;
				s)	do_make flash-clean ;;
				t)	do_make mostlyclean ;;
				u)	do_make clean ;;
				v)	do_make distclean ;;
				w)	clean_dirs
					build_dirs
					;;
				z)	maketargets_doquit="true" ;;
			esac
		else
			maketargets_doquit="true"
		fi
	done
}
