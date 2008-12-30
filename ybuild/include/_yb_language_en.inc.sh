#! /bin/bash
# -----------------------------------------------------------------------------------------------------------
# Tuxbox Build & Compiler Helper
# Language File EN - English
#
# Started by yjogol (yjogol@online.de)
# Translated by PT-1 (pt-1@gmx.net)
# $Date: 2008/12/30 15:59:17 $
# $Revision: 1.4 $
# -----------------------------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------------------------
# INIT
# -----------------------------------------------------------------------------------------------------------
yb_log_fileversion "\$Revision: 1.4 $ \$Date: 2008/12/30 15:59:17 $ _yb_language_en.inc.sh"

# -----------------------------------------------------------------------------------------------------------
# Common
# -----------------------------------------------------------------------------------------------------------
# Common
# -----------------------------------------------------------------------------------------------------------

l_ready_press_enter="ready ... please press enter"
l_date="Date"
l_yb_headline="yBuild: Tuxbox - Build & Compiling Helper"
l_component_not_installed="Component dialog is not installed"
l_install_dialog_component="Installation via apt-get install dialog"

l_exit="Exit"
l_back="Back"
l_choose="Select"
l_use_arrow_keys_and_enter="Use Arrow Keys and Enter to select"
l_description="Description"
l_save="Save"
l_ready="Ready"
l_not_found="not found"
l_yes="yes"
l_no="no"
l_others="others"

# -----------------------------------------------------------------------------------------------------------
# Start/Private Menu
# -----------------------------------------------------------------------------------------------------------
l_private_menu="Private Menu"
l_main_menu="Main Menu"
l_checkout_comlete="Checkout  - complete"
l_checkout_update="Checkout  - update"
l_configure_flash="Configure - Flash"
l_configure_yadd="Configure - Yadd"
l_apply_patches="apply Patches (from patches.txt)"
l_build_all_in_one="Build: Everything in one go"
l_build_configuration="Build: Configuration"
l_build_selected="Build: selected"
l_make_targets="Make Targets"
l_customizing_scripts="Customizing scripts"
l_configuration_and_developmenttools="Configuration & Development Environment"
l_settings_and_information="Setting & Information"
l_plugins="ybuild Plugins"


# -----------------------------------------------------------------------------------------------------------
# Development Environment
# -----------------------------------------------------------------------------------------------------------

l_toolchecker_results="Toolcheckers results"
l_d_configure_yadd="Configure YADD"
l_d_yadd_server_ip="YADD Server IP.............."
l_d_yadd_server_ip_comment="IP of your yadd servers"
l_d_dbox_ip="dbox IP....................."
l_d_dbox_ip_comment="IP that should be assigned to your Dbox"
l_d_dbox_mac="dbox MAC...................."
l_d_dbox_mac_comment="MAC that should be assigned to your Dbox"
l_d_dns_server_ip="DNS Server IP..............."
l_d_dns_server_ip_comment="DNS IP that should be assigned to your Dbox"
l_d_dbox_gateway_ip="dbox gateway IP............."
l_d_dbox_gateway_ip_comment="Gateway IP that should be assigned to your Dbox"
l_d_dbox_subnet="Subnetz....................."
l_d_dbox_subnet_comment="Subnetz for yadd server and dbox"

# -----------------------------------------------------------------------------------------------------------
# Build Target
# -----------------------------------------------------------------------------------------------------------
l_bt_build_target="Build Target.............."
l_bt_gui="GUI......................."
l_bt_filesystem="Filesystem................"
l_bt_chips="Chips....................."

l_bt_yadd_or_flash="yadd oder flash"
l_bt_choose_gui="select GUI"
l_bt_no_gui="No GUI"
l_bt_choose_filesystem="select Filesystem"
l_bt_choose_chips="select CHIPs"

# -----------------------------------------------------------------------------------------------------------
# Configure Conf
# -----------------------------------------------------------------------------------------------------------
l_cc_choose_flags="Select Flags to choose Module for Flash and Yadd"
l_cc_choose_option="Select Options using the spacebar"

# -----------------------------------------------------------------------------------------------------------
# Development Environment
# -----------------------------------------------------------------------------------------------------------
# Menu
l_de_development_environment="Development Environment"
l_de_basis_configuration="Base configuration"
l_de_configure_configuration="Configure configuration"
l_de_configure_yadd_server="configure Yadd Server"
l_de_install_development_tools="Install all needed Development tools"
l_de_install_yadd_server="Install configuriere the YADD Server"
l_de_patch_manager="Patch Manager"
l_de_toolchecker="Toolchecker"
l_de_clear_compiler_cache="clear Compiler Cache"
l_de_show_build_logfile="show Build-Logfile"
l_de_show_configure_logfile="show Configure-Logfile"
l_de_show_checkout_logfile="show Checkout-Logfile"
l_de_show_patch_logfile="show Patch-Logfile"
l_de_dhcp_start="dhcp on  (activate YADD booting)"
l_de_dhcp_stop="dhcp off (deactivate YADD booting)"
l_de_switch_debug="switch Debug:"
l_de_switch_debug_comment="(make & CVS are simulated)"

# functions
l_de_really_install_yadd_server="Do you really want to install and configure everything for the YADD-Server? ATTENTION configfiles are overwritten (/etc/xinet.d/tfpd, dhcp.conf, ...)"
l_de_ask_for_password_installing_packages="You may need the root password to install packages"
# -----------------------------------------------------------------------------------------------------------
# Configure & build
# -----------------------------------------------------------------------------------------------------------
l_cb_really_patch_and_configure="Do you really want to patch and then configure?"
l_cb_really_configure="Do you really want to configure?"
l_cb_debug_is_on="DEBUG is ON - MAKE is only simulated - nothing really done"
l_cb_really_checkout_updated_files="Do you really want to download the latest files?"

# -----------------------------------------------------------------------------------------------------------
# Customizing Menu
# -----------------------------------------------------------------------------------------------------------
l_cm_installed="installed"
l_cm_copy_scripts="copy scripts *-local.sh nach CDK .."
l_cm_create="create"
l_cm_password_needed="Passwort requested"
l_cm_check_and_install="check and/or install"
l_cm_install="install"
l_cm_not_right_installed="not correct installed - Cancel"
l_cm_right_installed="correct installed"
l_cm_install_development_tools="Install Development tools"
l_cm_really_install_development_tools="Do you really want to install all Development tools?"
l_cm_summary="Zusammenfassung : 1 = installed ok, 0 = not installed"
l_cm_end_of_installation="End of Installation. Checking for errors!!"
l_cm_scripts_found="Scripts found"


# -----------------------------------------------------------------------------------------------------------
# yBuild
# -----------------------------------------------------------------------------------------------------------
l_yb_choose_language="Select Language"

# -----------------------------------------------------------------------------------------------------------
# Patch Management
# -----------------------------------------------------------------------------------------------------------
l_pm_backup_directory_exists="Backup Directory excists"
l_pm_list_all_patches="Show list with Patches (patches.txt)"
l_pm_apply_all_patches="Apply all Patches"
l_pm_apply_choosen_patch="Apply Patch (Selection)"
l_pm_create_complete_diff="Create a complete Diff (all.diff) against the cvs"
l_pm_create_diff_for_given_file="Create a Diff against the cvs for a supplied single file or directory"
l_pm_restore_files_before_patching="Backup all files before applying patch"
l_pm_delete_patched_files="Delete all patched files"
l_pm_choose_file_to_patch="Select the File to be patched"
l_pm_add_diff_to_patchlist="add Diff to patches.txt inhzufügen? [j/n]"
l_pm_choose_a_patch="Select a Patch (empty to cancel)"
l_pm_restore_previously_patched_files="restore previously patched files from local cvs"
l_pm_delete_previously_patched_files="delete previously patched files from local cvs"
l_pm_patch_backup_does_not_exist="Patch backup does not exist"
l_pm_create_complete_diff_1="Generates a complete Diff"
l_pm_create_complete_diff_2="against the cvs"
l_pm_cvs_registered_user1="cvs Logon with USername"
l_pm_cvs_registered_user2="Password needed"
l_pm_create_diff="Generate a Diff against cvs"
l_pm_patching="Patching"
l_pm_list_of_patches="Patchlise"
l_pm_patch_result="Patch result"

# -----------------------------------------------------------------------------------------------------------
# Settings & Information
# -----------------------------------------------------------------------------------------------------------
l_se_version_information="Version Information"
l_se_displayname="Displayname"
l_se_displayname_comment="Displayname of this ybuild Instance"
