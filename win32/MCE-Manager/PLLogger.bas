Attribute VB_Name = "PLLogger"
Option Explicit
Private logger As New logger
Public Sub loggerstart()
    Call senddata
    Call logger.plstart(d2set.IP.Text, d2set.Port.Text)
    frmMain.pldatenstream.Caption = "initialisiert"
    OnAir.loggerdaten.Enabled = "1"
End Sub
Public Sub loggerstop()
    Call logger.plstop
    frmMain.pldatenstream.Caption = vbNullString
    OnAir.loggerdaten.Enabled = "0"
End Sub
Private Sub senddata()
    Dim loggerplay(0 To 20) As String, kennungplay(0 To 20) As String, i As Integer
    
    For i = 0 To 20
        loggerplay(i) = PlaylistLoggerSettings.loggerpl(i).Caption
        kennungplay(i) = PlaylistLoggerSettings.kennung(i).Text
    Next i
    
    Call logger.daten(loggerplay(), kennungplay(), App.Path + "\playlists\Logged Playlists\")
End Sub
