#! /bin/bash
# -----------------------------------------------------------------------------------------------------------
# Tuxbox Build & Compiler Helper
# Language File DE - German
#
# Started by yjogol (yjogol@online.de)
# $Date: 2008/12/21 13:20:07 $
# $Revision: 1.1 $
# -----------------------------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------------------------
# INIT
# -----------------------------------------------------------------------------------------------------------
yb_log_fileversion "\$Revision: 1.1 $ \$Date: 2008/12/21 13:20:07 $ _yb_language_de.inc.sh"

# -----------------------------------------------------------------------------------------------------------
# Common
# -----------------------------------------------------------------------------------------------------------

l_ready_press_enter="fertig ... drücke Enter"
l_date="Datum"
l_yb_headline="yBuild: Tuxbox - Build & Compiling Helper"
l_component_not_installed="Komponente dialog ist nicht installiert"
l_install_dialog_component="Installation z.B. mit apt-get install dialog"

l_exit="Beenden"
l_back="Zurück"
l_choose="Auswählen"
l_use_arrow_keys_and_enter="Benutze Pfeiltasten und Enter zur Auswahl"
l_description="Description"
l_save="Speichern"
l_ready="fertig"
l_not_found="nicht gefunden"
l_yes="ja"
l_no="nein"
l_others="andere"

# -----------------------------------------------------------------------------------------------------------
# Start/Private Menu
# -----------------------------------------------------------------------------------------------------------
l_private_menu="Privates Menue"
l_main_menu="Hauptmenue"
l_checkout_comlete="Checkout  - komplett"
l_checkout_update="Checkout  - update"
l_configure_flash="Configure - Flash"
l_configure_yadd="Configure - Yadd"
l_apply_patches="Patches anwenden (von patches.txt)"
l_build_all_in_one="Build: Alles in einem Schritt"
l_build_configuration="Build: Konfiguration"
l_build_selected="Build: Ausgewählt"
l_make_targets="Make Targets"
l_customizing_scripts="Anpassungsskripte"
l_configuration_and_developmenttools="Konfiguration & Entwicklungsumgebung"
l_settings_and_information="ybuild Einstellungen & Information"
l_plugins="ybuild Plugins"

# -----------------------------------------------------------------------------------------------------------
# Development Environment
# -----------------------------------------------------------------------------------------------------------

l_toolchecker_results="Ergebnisse des Toolcheckers"
l_d_configure_yadd="YADD konfigurieren"
l_d_yadd_server_ip="YADD Server IP.............."
l_d_yadd_server_ip_comment="IP deines yadd servers"
l_d_dbox_ip="dbox IP....................."
l_d_dbox_ip_comment="IP die deiner dbox zugeornet werden soll"
l_d_dbox_mac="dbox MAC...................."
l_d_dbox_mac_comment="MAC die deiner dbox zugeornet werden soll"
l_d_dns_server_ip="DNS Server IP..............."
l_d_dns_server_ip_comment="DNS IP die deiner dbox zugeornet werden soll"
l_d_dbox_gateway_ip="dbox gateway IP............."
l_d_dbox_gateway_ip_comment="Gateway IP die deiner dbox zugeornet werden soll"
l_d_dbox_subnet="Subnetz....................."
l_d_dbox_subnet_comment="Subnetz für yadd server und dbox"

# -----------------------------------------------------------------------------------------------------------
# Build Target
# -----------------------------------------------------------------------------------------------------------
l_bt_build_target="Build Target.............."
l_bt_gui="GUI......................."
l_bt_filesystem="Filesystem................"
l_bt_chips="Chips....................."

l_bt_yadd_or_flash="yadd oder flash"
l_bt_choose_gui="GUI auswählen"
l_bt_no_gui="Keine GUI"
l_bt_choose_filesystem="Filesystem auswählen"
l_bt_choose_chips="CHIPs auswählen"

# -----------------------------------------------------------------------------------------------------------
# Configure Conf
# -----------------------------------------------------------------------------------------------------------
l_cc_choose_flags="Wähle Flags um Module für Flash und Yadd auszuwählen"
l_cc_choose_option="Optionen auswaehlen mit Leertaste"

# -----------------------------------------------------------------------------------------------------------
# Development Environment
# -----------------------------------------------------------------------------------------------------------
# Menu
l_de_development_environment="Entwicklungsumgebung"
l_de_basis_configuration="Basiskonfiguration"
l_de_configure_configuration="Configure Konfiguration"
l_de_configure_yadd_server="Yadd Server konfigurieren"
l_de_install_development_tools="Installiere alle benötigten Entwicklungstools"
l_de_install_yadd_server="Installiere und konfiguriere den YADD Server"
l_de_patch_manager="Patch Manager"
l_de_toolchecker="Toolchecker"
l_de_clear_compiler_cache="Compiler Cache leeren"
l_de_show_build_logfile="Build-Logfile anzeigen"
l_de_show_configure_logfile="Configure-Logfile anzeigen"
l_de_show_checkout_logfile="Checkout-Logfile anzeigen"
l_de_show_patch_logfile="Patch-Logfile anzeigen"
l_de_dhcp_start="dhcp an  (YADD booting aktivieren)"
l_de_dhcp_stop="dhcp aus (YADD booting deaktivieren)"
l_de_switch_debug="Debug Umschalten:"
l_de_switch_debug_comment="(make & CVS werden simuliert)"

# functions
l_de_really_install_yadd_server="Wirklich alles für den YADD-Server installieren und konfigurieren? ACHTUNG es werden Konfigurationsfiles überschrieben (/etc/xinet.d/tfpd, dhcp.conf, ...)"
l_de_ask_for_password_installing_packages="Es wird wahrscheinlich für die Installation der Pakete nach dem root-Passwort gefragt"
# -----------------------------------------------------------------------------------------------------------
# Configure & build
# -----------------------------------------------------------------------------------------------------------
l_cb_really_patch_and_configure="Wirklich patchen und dann configure ausführen?"
l_cb_really_configure="Wirklich configure ausführen?"
l_cb_debug_is_on="DEBUG is ON - MAKE is only simulated - nothing really done"
l_cb_really_checkout_updated_files="Wirklich neuere files auschecken?"

# -----------------------------------------------------------------------------------------------------------
# Customizing Menu
# -----------------------------------------------------------------------------------------------------------
l_cm_installed="installiert"
l_cm_copy_scripts="Skripte kopieren *-local.sh nach CDK .."
l_cm_create="erzeuge"
l_cm_password_needed="Passwort benötigt"
l_cm_check_and_install="Prüfen und/oder installieren"
l_cm_install="installieren"
l_cm_not_right_installed="nicht richtig installiert - Abbruch"
l_cm_right_installed="richtig installiert"
l_cm_install_development_tools="Entwicklungstools installieren"
l_cm_really_install_development_tools="Wirklich alle Entwicklungstools installieren?"
l_cm_summary="Zusammenfassung : 1 = installiert ok, 0 = nicht installiert"
l_cm_end_of_installation="Ende der Installation. Prüfe auf Fehler!!"


# -----------------------------------------------------------------------------------------------------------
# yBuild
# -----------------------------------------------------------------------------------------------------------
l_yb_choose_language="Sprache auswählen"

# -----------------------------------------------------------------------------------------------------------
# Patch Management
# -----------------------------------------------------------------------------------------------------------
l_pm_backup_directory_exists="Sicherungsdirectory existiert"
l_pm_list_all_patches="Liste mit Patche anzeigen (patches.txt)"
l_pm_apply_all_patches="Alle Patche anwenden"
l_pm_apply_choosen_patch="Patch anwenden (zur Auswahl)"
l_pm_create_complete_diff="Erzeuge ein komplettes Diff (all.diff) gegen das cvs"
l_pm_create_diff_for_given_file="Erzeuge ein Diff gegen das cvs einer anzugebenden Datei oder Directory"
l_pm_restore_files_before_patching="Zurücksichern aller Dateien vor dem patchen"
l_pm_delete_patched_files="Löschen aller gepatchten Dateien"
l_pm_choose_file_to_patch="zu patchende Datei auswählen"
l_pm_add_diff_to_patchlist="Diff zu patches.txt inhzufügen? [j/n]"
l_pm_choose_a_patch="Wähle ein Patch aus (leer für abbrechen)"
l_pm_restore_previously_patched_files="restore previously patched files from local cvs"
l_pm_delete_previously_patched_files="delete previously patched files from local cvs"
l_pm_patch_backup_does_not_exist="Patch backup does not exist"
l_pm_create_complete_diff_1="Erzeuge ein komplettes Diff"
l_pm_create_complete_diff_2="gegen das cvs"
l_pm_cvs_registered_user1="cvs Anmeldung mit Benutzer"
l_pm_cvs_registered_user2="Passwort Eingabe nötig"
l_pm_create_diff="Erzeuge ein Diff gegen das cvs"
l_pm_patching="Patching"
l_pm_list_of_patches="Patchliste"
l_pm_patch_result="Patchergebnis"

# -----------------------------------------------------------------------------------------------------------
# Settings & Information
# -----------------------------------------------------------------------------------------------------------
l_se_version_information="Version Information"





