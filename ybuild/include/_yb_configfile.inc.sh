# -----------------------------------------------------------------------------------------------------------
# Tuxbox Build & Compiler Helper
# Manage config file
#
# Started by yjogol (yjogol@online.de)
# $Date: 2008/12/21 13:20:07 $
# $Revision: 1.1 $
# -----------------------------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------------------------
# INIT
# -----------------------------------------------------------------------------------------------------------
yb_log_fileversion "\$Revision: 1.1 $ \$Date: 2008/12/21 13:20:07 $ _yb_configfile.inc.sh"

# ===========================================================
# config-files - read / write
# (row layout: VarName=VarValue)
# ===========================================================
# -----------------------------------------------------------------------------------------------------------
# variable given by varname ($1) prompt for value, update var and write to conffile 
# $1=Variable name, $2=Default value, $3=Description
# Return in $basisconf_editvalue
# -----------------------------------------------------------------------------------------------------------
config_editvariable()
{
	varname=$1
	val=${!varname}
    dialog --inputbox "Variable...: $1,\nDescription: $3\nDefault....: $2\nActual.....: $val" 10 52 2>$_temp
    opt=${?}
    if [ $opt != 0 ]; then rm $_temp; exit; fi
	val=`cat $_temp`
	if [ "$val" != "" ]; then
		config_set_value_direct $yb_configfile $1 "$val"
		eval $varname=$val
	fi
}
# -----------------------------------------------------------------------------------------------------------
# Variable (varname = $1,val=$2)  and write it to configfile
# -----------------------------------------------------------------------------------------------------------
config_varset()
{
	varname=$1
	val=$2
	config_set_value_direct $yb_configfile $varname "$val"
	eval $varname=$val
}
# -----------------------------------------------------------------------------------------------------------
# Variable (name = $1) to by toggled ("y" to "n" or otherwise) and write it to configfile
# -----------------------------------------------------------------------------------------------------------
config_togglevariable()
{
	varname=$1
	val=${!varname}
	if  [ "$val" == "on" ]; then val="off"; else val="on"
	fi
	config_set_value_direct $yb_configfile $varname "$val"
	eval $varname=$val
}
# -----------------------------------------------------------
cfg=""
# -----------------------------------------------------------
# config-file read/cached (content in $cfg)
# $1=config-Filename
# -----------------------------------------------------------
config_open()
{
	cfg=""
	cfg=`cat $1`
}
# -----------------------------------------------------------
# config-file write (content in $cfg)
# $1=config-Filename
# -----------------------------------------------------------
config_write()
{
	echo "$cfg" >$1
}
# -----------------------------------------------------------
# return variable value (need to be open)
# $1=VarName
# -----------------------------------------------------------
config_get_value()
{
	cmd="sed -n /^$1=/p"
	tmp=`echo "$cfg" | $cmd`
	cmd="sed -e s/^$1=//1"
	tmp=`echo "$tmp" | $cmd`
	echo $tmp
}
# -----------------------------------------------------------
# return variable value (no need to be open)
# $1=config-Filename
# $2=VarName
# -----------------------------------------------------------
config_get_value_direct()
{
	config_open $1
	config_get_value $2
}
# -----------------------------------------------------------
# set variable value (need to be open)
# $1=VarName
# $2=VarValue
# -----------------------------------------------------------
config_set_value()
{
	tmp=`echo "$cfg" | sed -n "/^$1=.*/p"`
	if [ "$tmp" = "" ]
	then
		cfg=`echo -e "$cfg\n$1=$2"`
	else
		cmd="sed -e s:^$1=.*:$1=$2:g"
		cfg=`echo "$cfg" | $cmd`
	fi
}
# -----------------------------------------------------------
# set variable value (no need to be open)
# $1=config-Filename
# $2=VarName
# $3=VarValue
# -----------------------------------------------------------
config_set_value_direct()
{
	config_open $1
	config_set_value $2 $3
	config_write $1
}
