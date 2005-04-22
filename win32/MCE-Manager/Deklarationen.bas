Attribute VB_Name = "Deklarationen"
Option Explicit

Public OGGparameter As String
Public MP2vbrparameter As String
Public MP2cbrparameter As String
Public MP3cbrparameter As String
Public MP3vbrparameter As String
Public MP3abrparameter As String
Public normoptions As String
Public shell_prio As String
Public mp3gainstring As String
Public timeSeconds As Integer
Public timeMinutes As Integer
Public timehours As Integer
Public timedays As Integer
Public aktlng As String
Public deaktlng As String
Public RS
Public db As DAO.Database
Public extension As String
Public cinter As String
Public calbum As String
Public ctitel As String
Public cgenre As String
Public bufsize(1 To 8) As Long

Public Const Sondercheck = "*?""/\<>|:" 'Sonderzeichen Defintion
Sub Main() 'Programmstart
    If App.PrevInstance Then End 'Mehrfach Start verhindern
    
    Call Comboladen.comboboxladen 'Comboboxen werden geladen
    Call Einstellungen_laden.laden  'Paramerter laden
    
    If allgemeine.spshow.value = "1" Then
        frmSplash.Show
        record.sptimer.Enabled = "1"
    End If

    Call sprache.sprach 'Sprache wird initialisiert
    
    While record.sptimer.Enabled = "1"
        DoEvents
    Wend
    
    Call Einstellungen_setzen.set_settings 'Übernehmen der Einstellungen

    If allgemeine.autostart.value = "1" Then
        Call frmMain.minim_Click
    Else
        frmMain.WindowState = 0
    End If
    
    frmMain.Label29.Caption = deaktlng 'dbox aufnahme abgeschaltet (standart)
    frmMain.AudioGenie.DisablePopupKey "0586fe1d504f30c3" 'Disable Audiogenie Popup
    Call Aktivierauswahl.OK_Click 'Dient zur Sprachunterstützung
End Sub
