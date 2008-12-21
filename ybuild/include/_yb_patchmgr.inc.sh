#! /bin/bash
# -----------------------------------------------------------------------------------------------------------
# Tuxbox Build & Compiler Helper
# Patch Management
#
# Started by yjogol (yjogol@online.de)
# $Date: 2008/12/21 13:20:07 $
# $Revision: 1.1 $
# -----------------------------------------------------------------------------------------------------------

#============================================================================================================
# yBuild V3 working note (delete after release)
# languagefile:	partitial
# updated:		
# tested:		
# issues:		complete usage of dialog-GUI
#============================================================================================================

# -----------------------------------------------------------------------------------------------------------
# INIT
# -----------------------------------------------------------------------------------------------------------
yb_log_fileversion "\$Revision: 1.1 $ \$Date: 2008/12/21 13:20:07 $ _yb_patchmgr.inc.sh"

# -----------------------------------------------------------------------------------------------------------
# Menu
# -----------------------------------------------------------------------------------------------------------
patchmgr_menu()
{
	[ "$SDEBUG" != "0" ] && echo "DEBUG: Enter for next Menu" && read dummy

	if [ -e "$MyPATCHESDIR/backup" ]; then
		isback="$l_yes"
	else
		isback="$l_no"
	fi
    dialog --backtitle "$prgtitle" --title " $l_de_patch_manager "\
       	--cancel-label "$l_back"\
    	--ok-label "$l_choose"\
		--menu "$l_use_arrow_keys_and_enter\nPatch Directory:$MyPATCHESDIR\n${l_pm_backup_directory_exists}: $isback" 20 80 15\
		s "$l_pm_list_all_patches"\
		a "$l_pm_apply_all_patches"\
		p "${l_pm_apply_choosen_patch} ..."\
		c "$l_pm_create_complete_diff"\
		f "${l_pm_create_diff_for_given_file} ..."\
		r "$l_pm_restore_files_before_patching"\
		d "$l_pm_delete_patched_files"\
		"" ""\
		z "$l_back" 2>$_temp
}
# -----------------------------------------------------------------------------------------------------------
# Menu Loop
# -----------------------------------------------------------------------------------------------------------
patchmgr()
{
	patchmgr_doquit=false
	while [ "$patchmgr_doquit" == "false" ]
	do
		patchmgr_menu
	    opt=${?}
    	if [ $opt == 0 ]; then 
		    cmd=`cat $_temp`
			case "$cmd" in
				s)	dialog --title "$l_pm_list_of_patches" --textbox $MyPATCHESDIR/patches.txt 40 80 ;;
				a)	patchmgr_patch
					echo "$l_ready_press_enter"
					read dummy
					;;
				p)	patchmgr_patch_choose ;;
				c)	patchmgr_create_complete_cvs_diff ;;
				f)  dialog --backtitle "$prgtitle\nMit Pfeiltasten und Tab bewegen. Mit Leertaste Verzeichnis auswählen. Mit Enter fertig"\
						--title "$l_pm_choose_file_to_patch" --fselect "$CVSDIR" 25 66 2>$_temp
					fn=`cat $_temp`
					fnx=`echo "$fn"|sed s#\/#_#g`
					patchmgr_create_cvs_diff $fn $fnx
					echo "${l_pm_created_diff}: $MyPATCHESDIR/$fnx.diff"
					echo "$l_pm_add_diff_to_patchlist"
					read yesno
					if [ "$yesno" == "j" ]; then
						echo ".;$fnx.diff;1" >>$MyPATCHESDIR/patches.txt
					fi
					echo "$l_ready_press_enter"
					read dummy
					;;
				r)	patchmgr_restore_files
					echo "$l_ready_press_enter"
					read dummy
					;;
				d)	patchmgr_delete_files
					echo "$l_ready_press_enter"
					read dummy
					;;
				z)	patchmgr_doquit="true"	;;
#				"?")	more ./help/_yb_patchmgr.help.txt 
#					;;
			esac
    	else
			patchmgr_doquit="true"
		fi
	done
}

# -----------------------------------------------------------------------------------------------------------
# apply patch choosed
# -----------------------------------------------------------------------------------------------------------
patchmgr_patch_choose()
{
	patchlist=`cat $MyPATCHESDIR/patches.txt`
	j=0
	while read i
	do
		if [ "$i" != "" ]; then
			patch_file=`echo $i|cut -d ";" -f 2`
			patch_comment=`echo $i|cut -d ";" -f 4`
			if [ "$patch_num_slashes" == "" ]; then
				patch_num_slashes="0"
			fi
			j=`expr $j + 1`
			echo "$j: patch $patch_file [$patch_comment]"
		else
			break;
		fi
	done <$MyPATCHESDIR/patches.txt
	echo "=============================================================="
	echo "$l_pm_choose_a_patch"
	read patchno
	if [ "$patchno" != "" ]; then
		patchmgr_patch $patchno
	fi
}
# -----------------------------------------------------------------------------------------------------------
# apply all patches given in patches.txt and log them
# -----------------------------------------------------------------------------------------------------------
patchmgr_patch()
{
	_patchmgr_patch $* | tee $LOGPATCHFILE
}
# -----------------------------------------------------------------------------------------------------------
# apply all patches given in patches.txt
# if $1 != "" then patch only be choosen patchnumber
# -----------------------------------------------------------------------------------------------------------
_patchmgr_patch()
{
	build_dirs
	echo "=============================================================="
	echo "$p_pm_patching"
	echo "=============================================================="
	mkdir -p $MyPATCHESDIR/backup
	j=0
	while read i
	do
		if [ "$i" != "" ]; then

			patch_file=`echo $i|cut -d ";" -f 2`
			patch_path=`echo $i|cut -d ";" -f 1`
			patch_num_slashes=`echo $i|cut -d ";" -f 3`
			if [ "$patch_num_slashes" == "" ]; then
				patch_num_slashes="0"
			fi
			j=`expr $j + 1`
			if [ "$1" == "" -o "$1" == "$j" ]; then
				echo "Info: patch $patch_file at path: $patch_path slashes: $patch_num_slashes"
				echo "Info: patch -d $CVSDIR/$patch_path -b -B $MyPATCHESDIR/backup/$patch_path/ -p$patch_num_slashes <$MyPATCHESDIR/$patch_file"
				patch -d $CVSDIR/$patch_path -b -B $MyPATCHESDIR/backup/$patch_path/ -p$patch_num_slashes <$MyPATCHESDIR/$patch_file				echo "$i" >>$MyPATCHESDIR/backup/done_patches.txt
			fi
		else
			break;
		fi
	done <$MyPATCHESDIR/patches.txt
	cd $SCRIPTDIR
}
# -----------------------------------------------------------------------------------------------------------
# restore previously patched files from local cvs and log it
# -----------------------------------------------------------------------------------------------------------
patchmgr_restore_files()
{
	_patchmgr_restore_files $* | tee $LOGPATCHFILE
}
# -----------------------------------------------------------------------------------------------------------
# restore previously patched files from local cvs
# this is important to get the original files again on cvs checkout or cvs update
# -----------------------------------------------------------------------------------------------------------
_patchmgr_restore_files()
{
	if [ -e $MyPATCHESDIR/backup ];then
		echo "=============================================================="
		echo "$l_pm_restore_previously_patched_files"
		echo "=============================================================="
		echo "Copy all backuped files $MyPATCHESDIR/backup $CVSDIR"
		cp -r -v $MyPATCHESDIR/backup/* $CVSDIR
		echo "Remove $CVSDIR/done_patches.txt and $MyPATCHESDIR/backup"
		rm -f $CVSDIR/done_patches.txt	
		rm -rf $MyPATCHESDIR/backup
	else
		echo "=============================================================="
		echo "$l_pm_patch_backup_does_not_exist"
		echo "=============================================================="
	fi
}

# -----------------------------------------------------------------------------------------------------------
# delete previously patched files from local cvs
# -----------------------------------------------------------------------------------------------------------
patchmgr_delete_files()
{
	_patchmgr_delete_files $* | tee $LOGPATCHFILE
}
# -----------------------------------------------------------------------------------------------------------
_patchmgr_delete_files()
{
	if [ -e $MyPATCHESDIR/backup ];then
		echo "=============================================================="
		echo "$l_pm_delete_previously_patched_files"
		echo "=============================================================="
		cd $MyPATCHESDIR/backup && find . -not -name done_patches.txt -type f -print0|xargs -0 rm -rf -v
		cd $SCRIPTDIR
		echo "Remove $CVSDIR/done_patches.txt and $MyPATCHESDIR/backup"
		rm -f $CVSDIR/done_patches.txt	
		rm -rf $MyPATCHESDIR/backup
	else
		echo "=============================================================="
		echo "$l_pm_patch_backup_does_not_exist"
		echo "=============================================================="
	fi
}

# -----------------------------------------------------------------------------------------------------------
# create complete diff against cvs
# -----------------------------------------------------------------------------------------------------------
patchmgr_create_complete_cvs_diff()
{
	cvs_debug=""
	if [ "$DEBUG" == "1" ]; then
		cvs_debug="-n -t"
	fi
	echo "=============================================================="
	echo "${l_pm_create_complete_diff_1} ($complete_diff) ${l_pm_create_complete_diff_2} (DEBUG=$DEBUG)"
	echo "=============================================================="

	if [ "$CVSNAME" == "anoncvs" ];then
	# Checkout if CVS-User is anonymous
		cd "$CVSDIR"
		cvs -z3 $cvs_debug -d anoncvs@cvs.tuxbox.org:/cvs/tuxbox diff -U 3 -R >$MyPATCHESDIR/$complete_diff
	else
	# Checkout if CVS-User is a registred user
		cd "$CVSDIR"
		echo "${l_pm_cvs_registered_user1}: $CVSNAME ${l_pm_cvs_registered_user2}"
		cvs -z3 $cvs_debug -d "$CVSNAME@cvs.tuxbox.org:/cvs/tuxbox"  diff -U 3 -R >$MyPATCHESDIR/$complete_diff
	fi
	echo "$l_ready_press_enter"
	read dummy
	dialog --title "$l_pm_patch_result" --textbox "$MyPATCHESDIR/$complete_diff" 40 80
}
# -----------------------------------------------------------------------------------------------------------
# create diff against cvs for a given filename ($1)
# -----------------------------------------------------------------------------------------------------------
patchmgr_create_cvs_diff()
{
	cvs_debug=""
	if [ "$DEBUG" == "1" ]; then
		cvs_debug="-n -t"
	fi
	echo "=============================================================="
	echo "${l_pm_create_diff} $2.diff (DEBUG=$DEBUG)"
	echo "=============================================================="

	if [ "$CVSNAME" == "anoncvs" ];then
	# Checkout if CVS-User is anonymous
		cd "$CVSDIR"
		cvs -z3 $cvs_debug -d anoncvs@cvs.tuxbox.org:/cvs/tuxbox diff -U 3 -R $1 >$MyPATCHESDIR/$2.diff
	else
	# Checkout if CVS-User is a registred user
		echo "${l_pm_cvs_registered_user1}: $CVSNAME ${l_pm_cvs_registered_user2}"
		cd "$CVSDIR"
		cvs -z3 $cvs_debug -d "$CVSNAME@cvs.tuxbox.org:/cvs/tuxbox"  diff -U 3 -R $1 >$MyPATCHESDIR/$2.diff
	fi
	echo "$l_ready_press_enter"
	read dummy
	dialog --title "$l_pm_patch_result" --textbox "$MyPATCHESDIR/$2.diff" 40 80 
}
