#! /bin/bash
# -----------------------------------------------------------------------------------------------------------
# Tuxbox Build & Compiler Helper
# bootstraping, first checkout to get full ybuild
#
# Started by yjogol (yjogol@online.de)
# $Date: 2008/12/22 09:56:00 $
# $Revision: 1.1 $
# -----------------------------------------------------------------------------------------------------------


	CVSNAME="anoncvs"
	ybuildDIR=`pwd`
	ybuildDIR="$ybuildDIR/yuild"
	mkdir -p $ybuildDIR

	clear
	echo "=============================================================="
	echo "Start CVS Checkout to $ybuildDIR"
	echo "=============================================================="
	echo "start / abort (s/a)?"
	read yesno
	if [ "$yesno" == "s" ]; then 
		# Checkout if CVS-User is anonymous
		cd "$ybuildDIR"
		set CVS_RSH=ssh && cvs $cvs_debug -d anoncvs@cvs.tuxbox.org:/cvs/tuxbox -z3 co -f  -P hostapps/ybuild
	
		# rearrage directories
		mv ./hostapps/ybuild/* .
		rm -r hostapps

		echo "ready ... press enter to start ybuild"
		read dummy
		./ybstart.sh	
	fi
	
			
