#! /bin/bash
# -----------------------------------------------------------------------------------------------------------
# Tuxbox Build & Compiler Helper
# Install and configure develoment tools/packages
#
# Started by yjogol (yjogol@online.de)
# $Date: 2008/12/21 13:20:07 $
# $Revision: 1.1 $
# -----------------------------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------------------------
# INIT
# -----------------------------------------------------------------------------------------------------------
yb_log_fileversion "\$Revision: 1.1 $ \$Date: 2008/12/21 13:20:07 $ _yb_dev_func.inc.sh"

# -----------------------------------------------------------------------------------------------------------
# Install all needed Packages for YADD booting. configure xinetd
# -----------------------------------------------------------------------------------------------------------
install_yadd()
{
	yabort=false
    dialog --backtitle "$prgtitle" --title " $l_de_install_yadd_server "\
		--yesno "$l_de_really_install_yadd_server" 10 40
	opt=${?}
	if [ $opt == 0 ];then
		clear
		echo "=============================================================="
		echo "$l_de_install_yadd_server"
		echo "=============================================================="
		init_variables
		tmpd="$SCRIPTDIR/tmp"
		mkdir -p "$tmpd"
		echo "$l_de_ask_for_password_installing_packages"
		echo ""
		#------------------------------------------------------------------------------------------------
		# inst & conf xinet.d
		#------------------------------------------------------------------------------------------------
		check_inst_pkg "tftp Daemon" "in.tftpd" "tftpd"
		tftp=$?		

		check_inst_pkg "xinetd Daemon" "xinetd" "xinetd"
		xinetd=$?		
		
		x=`which xinetd`
		if [ "$xinetd" == 1 ]; then
			echo "xinetd.............: ${l_cm_create} tftp-configfile (${l_cm_password_needed})"
			tftpbootpath="$DBOX_PREFIX/tftpboot"
			cat "$yb_templatedir/tfpd"|sed -e s:{=ymod=}:$tftpbootpath:g >"$tmpd/tfpd"
			sudo cp "$tmpd/tfpd" /etc/xinetd.d/tfpd
			echo "xinetd.............: xinetd restart"
			sudo kill -HUP `pidof xinetd`
			echo "xinetd.............: ${l_ready}!"
		else
			yabort=true
		fi
		#------------------------------------------------------------------------------------------------
		# nfsd
		# TODO: The creation of the nfs-share makes often trouble
		#------------------------------------------------------------------------------------------------
		if [ "$yabort" != "true" ]; then
			check_inst_pkg "NFS Server" "exportfs" "nfs-kernel-server"  #customize your package here
			nfsd=$?		
			if [ "$nfsd" == 1 ]; then
				echo "nsfd...............: Command: sudo exportfs -o sync -o rw -o no_root_squash $cSetupDboxIP:$DBOX_PREFIX/cdkroot"
				sudo exportfs -o sync -o rw -o no_root_squash "$cSetupDboxIP:$DBOX_PREFIX/cdkroot"
				echo "nfsd...............: nfsd restart"
				sudo exportfs -a
				sudo /etc/init.d/nfs-kernel-server restart
			else
				yabort=true
			fi
		fi
		#------------------------------------------------------------------------------------------------
		# dhcp3
		#------------------------------------------------------------------------------------------------
		if [ "$yabort" != "true" ]; then
			check_inst_pkg "NFS Server" "dhcpd3" "dhcp3-server"  #customize your package here
			dhcpd=$?		
			if [ "$dhcpd" == 1 ]; then
				echo "dhcpd..............: ${l_cm_create} configfile (${l_cm_password_needed})"

				dc=`cat "$yb_templatedir/dhcpd.conf"`
				dc=`echo "$dc"|sed -e s:{=gateway=}:$cSetupDboxGatewayIP:g`
				dc=`echo "$dc"|sed -e s:{=dns=}:$cSetupDNSIP:g`
				dc=`echo "$dc"|sed -e s:{=subnet=}:$cSetupServerSubnet:g`
				dc=`echo "$dc"|sed -e s:{=dboxip=}:$cSetupDboxIP:g`
				dc=`echo "$dc"|sed -e s/{=dboxmac=}/$cSetupDboxMAC/g`
				dc=`echo "$dc"|sed -e s:{=serverip=}:$cSetupServerIP:g`
				dc=`echo "$dc"|sed -e s:{=cdkroot=}:$DBOX_PREFIX/cdkroot:g`
				echo "$dc" > "$tmpd/dhcpd.conf"
				sudo cp "$tmpd/dhcpd.conf" /etc/dhcp3/
				echo "dhcpd..............: dhcp restart"
 				sudo  /etc/init.d/dhcp3-server restart
				echo "dhcpd..............: ${l_ready}!"
			else
				yabort=true
			fi
		fi
		
		#------------------------------------------------------------------------------------------------
		# seversupport: create uboot in tftpboot
		#------------------------------------------------------------------------------------------------
		do_make serversupport

#		echo "$l_ready_press_enter"
#		read dummy
	fi
}
# -----------------------------------------------------------------------------------------------------------
# Check if package ist installed otherwise install it
# $1 = Displayname
# $2 = program name to check
# $3 = packagename
# $4 = if not empty: check if file exists
# -----------------------------------------------------------------------------------------------------------
check_inst_pkg()
{
#set +x
	echo "======================================================================"
	echo "${l_cm_check_and_install}: $1"
	echo "======================================================================"
	if [ "$4" == "" ]; then	
		d=`which $2`
	else
		d=`find $2`
	fi
	
	if [ "$d" == "" ]; then
		echo "$1..............: $l_not_found"
		echo "$1..............: ${l_cm_install} $3 (${l_cm_password_needed})"
#		sudo apt-get -s -y install $3
		sudo apt-get install $3
	fi
	if [ "$4" == "" ]; then	
		d=`which $2`
	else
		d=`find $2`
	fi
	if [ "$d" == "" ]; then
		echo "$1..............: $l_cm_not_right_installed"
		return 0
	else
		echo "$1..............: $l_cm_right_installed"
		return 1
	fi
}

# -----------------------------------------------------------------------------------------------------------
# Install all needed Development packages
# -----------------------------------------------------------------------------------------------------------
install_devtools()
{
	yabort=false
    dialog --backtitle "$prgtitle" --title " $l_cm_install_development_tools "\
		--yesno "$l_cm_really_install_development_tools" 10 40
	opt=${?}
	if [ $opt == 0 ];then
		clear
		echo "=============================================================="
		echo "$l_cm_install_development_tools"
		echo "=============================================================="
		init_variables
		tmpd="$SCRIPTDIR/tmp"
		mkdir -p "$tmpd"
		echo "$l_de_ask_for_password_installing_packages"
		echo ""
		#------------------------------------------------------------------------------------------------
		# inst & conf xinet.d
		#------------------------------------------------------------------------------------------------
		check_inst_pkg "gcc" "gcc" "gcc"
		gcc=$?
		check_inst_pkg "g++" "g++" "g++"
		gpp=$?
		check_inst_pkg "Bison" "bison" "bison"
		bison=$?
		check_inst_pkg "Flex" "flex" "flex"
		flex=$?
		check_inst_pkg "CVS" "cvs" "cvs"
		cvs=$?
		check_inst_pkg "tar" "tar" "tar"
		tar=$?
		check_inst_pkg "Texinfo/Makeinfo" "makeinfo" "texinfo"
		makeinfo=$?
		check_inst_pkg "Make" "make" "make"
		make=$?
		check_inst_pkg "Autoconf" "autoconf" "autoconf"
		autoconf=$?
		check_inst_pkg "Automake" "automake" "automake"
		automake=$?
		check_inst_pkg "Libtool" "libtool" "libtool"
		libtool=$?
		check_inst_pkg "gettext" "gettext" "gettext"
		gettext=$?
		check_inst_pkg "bzip2" "bzip2" "bzip2"
		bzip2=$?
		check_inst_pkg "gzip" "gzip" "gzip"
		gzip=$?
		check_inst_pkg "patch" "patch" "patch"
		patch=$?
		check_inst_pkg "wget" "wget" "wget"
		wget=$?
		check_inst_pkg "ncurses/infocmp" "infocmp" "ncurses-bin"
		infocmp=$?
		check_inst_pkg "pkg-config" "pkg-config" "pkg-config"
		pkgconfig=$?
		check_inst_pkg "libpng3" "/usr/lib/libpng.so.3" "libpng3" "y"
		libpng3=$?
		check_inst_pkg "zlib1g-dev" "/usr/include/zlib.h" "zlib1g-dev" "y"
		zlib=$?

		echo "=============================================================="
		echo "$l_cm_summary"
		echo "=============================================================="
		echo "gcc.......: $gcc"
		echo "gpp.......: $gpp"
		echo "bison.....: $bison"
		echo "cvs.......: $cvs"
		echo "flex......: $flex"
		echo "tar.......: $tar"
		echo "makeinfo..: $makeinfo"
		echo "make......: $make"
		echo "autoconf..: $autoconf"
		echo "automake..: $automake"
		echo "libtool...: $libtool"
		echo "gettext...: $gettext"
		echo "bzip2.....: $bzip2"
		echo "gzip......: $gzip"
		echo "patch.....: $patch"
		echo "wget......: $wget"
		echo "infocmp...: $infocmp"
		echo "pkgconfig.: $pkgconfig"
		echo "libpng3...: $libpng3"
		echo "zlib......: $zlib"
		echo "=============================================================="
		echo "$l_cm_end_of_installation"
		echo "=============================================================="
		
		echo "$l_ready_press_enter"
		read dummy
	fi
}
