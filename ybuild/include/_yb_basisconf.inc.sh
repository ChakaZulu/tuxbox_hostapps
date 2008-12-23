#! /bin/bash
# -----------------------------------------------------------------------------------------------------------
# Tuxbox Build & Compiler Helper
# Some basis configuration of ybuild
#
# Started by yjogol (yjogol@online.de)
# $Date: 2008/12/23 09:00:00 $
# $Revision: 1.4 $
# -----------------------------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------------------------
# INIT
# -----------------------------------------------------------------------------------------------------------
yb_log_fileversion "\$Revision: 1.4 $ \$Date: 2008/12/23 09:00:00 $ _yb_basisconf.inc.sh"

# -----------------------------------------------------------------------------------------------------------
# Menu
# -----------------------------------------------------------------------------------------------------------
basisconf_menu()
{
	[ "$SDEBUG" != "0" ] && echo "DEBUG: Enter for next Menu" && read dummy

	dialog --backtitle "$prgtitle" --title " $l_de_basis_configuration "\
		--cancel-label "$l_back"\
		--ok-label "$l_choose"\
		--menu "$l_use_arrow_keys_and_enter" 23 80 17\
	0 "Working Directory.....: $cWORKINGDIR" \
	1 "Custom Directory......: $cMYFILESDIR  ($cWORKINGDIR/$cMYFILESDIR)"\
	2 "  Logos  Directory....: $cLOGOSDIR  ($cWORKINGDIR/$cMYFILESDIR/$cLOGOSDIR)"\
	3 "  Ucodes Directory....: $cUCODESDIR  ($cWORKINGDIR/$cMYFILESDIR/$cUCODESDIR)"\
	4 "  locals Directory....: $cMyLOCALSDIR  ($cWORKINGDIR/$cMYFILESDIR/$cMyLOCALSDIR)"\
	5 "  Patches Directory...: $cMyPATCHESDIR  ($cWORKINGDIR/$cMYFILESDIR/$cMyPATCHESDIR)"\
	6 "  dbox-Files Directory: $cMyDBOXFILESDIR  ($cWORKINGDIR/$cMYFILESDIR/$cMyDBOXFILESDIR)"\
	7 "DBOX Directory........: $cDBOX_PREFIX  ($cWORKINGDIR/$cDBOX_PREFIX)"\
	8 "ARCHIVE Directory.....: $cARCHIVEDIR  ($cWORKINGDIR/$cARCHIVEDIR)"\
	9 "CVS Directory.........: $cCVSDIR  ($cWORKINGDIR/$cCVSDIR)"\
	u "CVS Username..........: $CVSNAME (for anonymous: anoncvs)"\
	c "ccache path...........: $cCCACHEDIR ($cWORKINGDIR/$cDBOX_PREFIX/$cCCACHEDIR)"\
	"" ""\
	z "$l_back" 2>$_temp
}

# -----------------------------------------------------------------------------------------------------------
# Menu Loop
# -----------------------------------------------------------------------------------------------------------
basisconf()
{
	basisconf_doquit=false
	while [ "$basisconf_doquit" == "false" ]
	do
		basisconf_menu
		opt=${?}
		if [ $opt == 0 ]; then
			cmd=`cat $_temp`
			case "$cmd" in
				0)	config_editvariable "cWORKINGDIR" "[/home/<username>/tuxbox]" "Working Directory" ;;
				1)	config_editvariable "cMYFILESDIR" "Private" "Custom Files Directory" ;;
				2)	config_editvariable "cLOGOSDIR" "Logos" "Logos Directory" ;;
				3)	config_editvariable "cUCODESDIR" "Ucodes" "Ucodes Directory" ;;
				4)	config_editvariable "cMyLOCALSDIR" "locals" "local-scripts Directory" ;;
				5)	config_editvariable "cMyPATCHESDIR" "patches" "patches Directory" ;;
				6)	config_editvariable "cMyDBOXFILESDIR" "files" "dbox-files Directory" ;;
				7)	config_editvariable "cDBOX_PREFIX" "dbox2" "Dbox Directory" ;;
				8)	config_editvariable "cARCHIVEDIR" "Archive" "Archive Directory" ;;
				9)	config_editvariable "cCVSDIR" "tuxbox-cvs" "CVS Directory" ;;
				u)	config_editvariable "CVSNAME" "anoncvs" "CVS Username" ;;
				c)	config_editvariable "cCCACHEDIR" "cdk/bin" "where is ccache relative to dbox2-dir" ;;
				z)	basisconf_doquit="true" ;;
			esac
		else
			basisconf_doquit=true
		fi
	done
}
# -----------------------------------------------------------------------------------------------------------
# Initialize used configuration variables
# -----------------------------------------------------------------------------------------------------------
init_variables()
{
	#------------------------------------------
	# Default Directory Structure 
	#------------------------------------------
	SCRIPTDIR=$cWORKINGDIR/$cSCRIPTDIR
	MYFILESDIR=$cWORKINGDIR/$cMYFILESDIR
	LOGOSDIR=$cWORKINGDIR/$cMYFILESDIR/$cLOGOSDIR
	UCODESDIR=$cWORKINGDIR/$cMYFILESDIR/$cUCODESDIR
	MyLOCALSDIR=$cWORKINGDIR/$cMYFILESDIR/$cMyLOCALSDIR
	MyPATCHESDIR=$cWORKINGDIR/$cMYFILESDIR/$cMyPATCHESDIR
	MyDBOXFILESDIR=$cWORKINGDIR/$cMYFILESDIR/$cMyDBOXFILESDIR
	CVSDIR=$cWORKINGDIR/$cCVSDIR
	DBOX_PREFIX=$cWORKINGDIR/$cDBOX_PREFIX
	ARCHIVEDIR=$cWORKINGDIR/$cARCHIVEDIR
	CCACHEDIR=$cWORKINGDIR/$cDBOX_PREFIX/$cCCACHEDIR

	#------------------------------------------
	# other Settings
	#------------------------------------------
	export CVS_RSH=ssh
}
# -----------------------------------------------------------------------------------------------------------
# Show variables (for debug issues)
# -----------------------------------------------------------------------------------------------------------
show_variables()
{
	echo " - Working Directory.......: $cWORKINGDIR"
	echo " -- Script Directory.......: $cSCRIPTDIR  (cWORKINGDIR/$cSCRIPTDIR)"
	echo " -- Custom Directory.......: $cMYFILESDIR  ($cWORKINGDIR/$cMYFILESDIR)"
	echo " ---   Logos  Directory....: $cLOGOSDIR  ($cWORKINGDIR/$cMYFILESDIR/$cLOGOSDIR)"
	echo " ---   Ucodes Directory....: $cUCODESDIR  ($cWORKINGDIR/$cMYFILESDIR/$cUCODESDIR)"
	echo " ---   locals Directory....: $cMyLOCALSDIR  ($cWORKINGDIR/$cMYFILESDIR/$cMyLOCALSDIR)"
	echo " ---   Patches Directory...: $cMyPATCHESDIR  ($cWORKINGDIR/$cMYFILESDIR/$cMyPATCHESDIR)"
	echo " ---   dbox-Files Directory: $cMyDBOXFILESDIR  ($cWORKINGDIR/$cMYFILESDIR/$cMyDBOXFILESDIR)"
	echo " -- DBOX Directory.........: $cDBOX_PREFIX  ($cWORKINGDIR/$cDBOX_PREFIX)"
	echo " -- ARCHIVE Directory......: $cARCHIVEDIR  ($cWORKINGDIR/$cARCHIVEDIR)"
	echo " -- CVS Directory..........: $cCVSDIR  ($cWORKINGDIR/$cCVSDIR)"
	echo " CVS Username..............: $CVSNAME (for anonymous: anoncvs)"
	echo " ccache path...............: $cCCACHEDIR ($cWORKINGDIR/$cDBOX_PREFIX/$cCCACHEDIR)"
}

# -----------------------------------------------------------------------------------------------------------
# Clean Directoty Structure
# -----------------------------------------------------------------------------------------------------------
clean_dirs()
{
	rm -frdv $CVSDIR/*
	rm -frdv $DBOX_PREFIX/cdk
	rm -frdv $DBOX_PREFIX/cdkflash
	rm -frdv $DBOX_PREFIX/cdkroot
}

# -----------------------------------------------------------------------------------------------------------
# Build Directoty Structure if not exists
# -----------------------------------------------------------------------------------------------------------
build_dirs()
{
	mkdir -p $DBOX_PREFIX
	mkdir -p $CVSDIR
	mkdir -p $LOGOSDIR
	mkdir -p $UCODESDIR
	mkdir -p $ARCHIVEDIR
	mkdir -p $MyLOCALSDIR
	mkdir -p $MyPATCHESDIR
	mkdir -p $MyDBOXFILESDIR
}
