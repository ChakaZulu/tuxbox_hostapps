Attribute VB_Name = "Einstellungen_setzen"
Option Explicit
Private Declare Function GetCurrentProcess Lib "kernel32" () As Long
Private Declare Function SetPriorityClass Lib "kernel32" (ByVal hProcess As Long, ByVal dwPriorityClass As Long) As Long
Public Sub set_settings()
    'Priorität setzten
    If allgemeine.Prio_mce.ListIndex = 0 Then SetPriorityClass GetCurrentProcess, &H80
    If allgemeine.Prio_mce.ListIndex = 1 Then SetPriorityClass GetCurrentProcess, &H20
    If allgemeine.Prio_mce.ListIndex = 2 Then SetPriorityClass GetCurrentProcess, &H40
    
    If allgemeine.prio_shell.ListIndex = 0 Then shell_prio = "4"
    If allgemeine.prio_shell.ListIndex = 1 Then shell_prio = "3"
    If allgemeine.prio_shell.ListIndex = 2 Then shell_prio = "0"
    
    'Format wählen
    If frmMain.mp3extension.Value = "1" Then extension = "mp3"
    If frmMain.mp2extension.Value = "1" Then extension = "mp2"
    If frmMain.oggextension.Value = "1" Then extension = "ogg"
    If frmMain.noextension.Value = "1" Then extension = "mp2"
    
    MP3vbrparameter = Mid$(MP3vbrparameter, 1, Len(MP3vbrparameter) - 13) + " --priority " + shell_prio
    MP3abrparameter = Mid$(MP3abrparameter, 1, Len(MP3abrparameter) - 13) + " --priority " + shell_prio
    MP3cbrparameter = Mid$(MP3cbrparameter, 1, Len(MP3cbrparameter) - 13) + " --priority " + shell_prio
    
    'Scannen aktivieren
    If Aktivierauswahl.scan_aktiv.Value = 0 Then frmMain.Timer1.Enabled = "0"  'Abfrage on scannen deaktiviert wurde

    If Aktivierauswahl.scan_aktiv.Value = "1" Then 'Abfrage on scannen aktiviert wurde
        allgemeine.quelldel.Value = "1" 'Quelldateien auto-löschen aktivieren
        frmMain.Timer1.Enabled = "1" 'scan-timer ein
    End If
    
    If frmMain.aufnahmestart.Enabled = "1" Then
        frmMain.Label29.Caption = deaktlng
    Else
        frmMain.Label29.Caption = aktlng
    End If
    
    If Aktivierauswahl.mp3normal_aktiv.Value = "1" Or Aktivierauswahl.mp3gain_aktiv = "1" Then
        frmMain.Label20.Caption = aktlng
    Else
        frmMain.Label20.Caption = deaktlng
    End If
    
    If Aktivierauswahl.scan_aktiv.Value = "1" Then
        frmMain.Label23.Caption = aktlng
    Else
        frmMain.Label23.Caption = deaktlng
    End If
    
    If Aktivierauswahl.sort_aktiv.Value = "1" Then
        frmMain.Label19.Caption = aktlng
    Else
        frmMain.Label19.Caption = deaktlng
    End If
    
    If allgemeine.cpuaktiv.Value = "1" Then
        frmMain.tmrUpdate.Enabled = "1"
    Else
        frmMain.tmrUpdate.Enabled = "0"
        frmMain.CPUmeter.Value = "0"
    End If
    
    If frmMain.mp3extension.Value = "1" Then
        If Aktivierauswahl.mp3_cbr_aktiv.Value = "1" Then frmMain.Label26.Caption = "CBR"
        If Aktivierauswahl.mp3_vbr_aktiv.Value = "1" Then frmMain.Label26.Caption = "VBR"
        If Aktivierauswahl.mp3_abr_aktiv.Value = "1" Then frmMain.Label26.Caption = "ABR"
    End If
    
    If frmMain.mp2extension.Value = "1" Then
        If Aktivierauswahl.mp2_cbr_aktiv.Value = "1" Then frmMain.Label26.Caption = "CBR"
        If Aktivierauswahl.mp2_vbr_aktiv.Value = "1" Then frmMain.Label26.Caption = "VBR"
    End If
    
    If frmMain.noextension.Value = "1" Then
        frmMain.Label26.Caption = "---"
        frmMain.Label20.Caption = deaktlng
    End If
    
    If frmMain.oggextension.Value = "1" Then frmMain.Label26.Caption = "VBR"
    
    If Aktivierauswahl.timec.Value = "1" Then
        Zeitsteuerung.Timer1.Enabled = "1"
        frmMain.Label11.Caption = aktlng
    Else
        Zeitsteuerung.Timer1.Enabled = "0"
        frmMain.Label11.Caption = deaktlng
    End If
    
    If Aktivierauswahl.scan_aktiv.Value = "1" Then
        allgemeine.quelldel.Enabled = "0"
    Else
        allgemeine.quelldel.Enabled = "1"
    End If
    
    Call d2set.OK_Click
End Sub
