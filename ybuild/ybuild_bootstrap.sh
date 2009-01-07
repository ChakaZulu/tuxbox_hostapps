#! /bin/bash
# -----------------------------------------------------------------------------------------------------------
# Tuxbox Build & Compiler Helper
# bootstraping, first checkout to get full ybuild
#
# Started by yjogol (yjogol@online.de)
# $Date: 2009/01/07 16:53:21 $
# $Revision: 1.3 $
# -----------------------------------------------------------------------------------------------------------


	CVSNAME="anoncvs"
	ybuildDIR=`pwd`
	ybuildDIR="$ybuildDIR/ybuild"
	mkdir -p $ybuildDIR

	clear
	echo "=============================================================="
	echo "Start CVS Checkout to $ybuildDIR"
	echo "=============================================================="
	echo "start / abort (s/a)?"
	read yesno
	if [ "$yesno" == "s" ]; then 
		# Checkout if CVS-User is anonymous
		t=`which cvs`
		if [ "$t" == "" ]; then
			echo "Install cvs needed. Install now. Password needed!"
			sudo apt-install cvs
		fi
		cd "$ybuildDIR"
		export CVS_RSH=ssh
		cvs -d anoncvs@cvs.tuxbox.org:/cvs/tuxbox -z3 co -f  -P hostapps/ybuild

		# rearrage directories
		mv ./hostapps/ybuild/* .
		rm -r hostapps

		echo "after complete checkout of ybuild, please use ybuild in tuxbox-cvs/hostapps/ybuild"
		echo "ready ... press enter to start ybuild"
		read dummy
		./ybstart.sh	
	fi

