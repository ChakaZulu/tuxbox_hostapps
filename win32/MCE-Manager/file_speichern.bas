Attribute VB_Name = "file_speichern"
Option Explicit
Public Sub taggedspeichern(Quelle As String, Ziel As String, akttime As Date, aktdate As Date, Optional Sortierung As Boolean)
    Dim filename As String, posit As Integer
    
    posit = InStrRev(Ziel, "\")
    filename = Mid$(Ziel, posit + 1, Len(Ziel) - (posit + 4))
    
    If Quelle = Ziel Then
        Call Ausgabe.textbox(filename + "......tagged")
        GoTo err
    End If
    
    If LenB(Dir$(Quelle, vbDirectory)) <> 0 Then 'Überprüfung
        If LenB(Dir$(Ziel, vbDirectory)) <> 0 Then Kill (Ziel)  'Wenn schon vorhanden, dann löschen
        If Quelle = vbNullString Or Ziel = vbNullString Then GoTo err
        If Sortierung = "0" Then Call Ausgabe.textbox(filename + "......tagged")
        If Sortierung = "1" Then Call Ausgabe.textbox(filename + "......sorted")
        If akttime <> "00:00:00" And aktdate <> "00:00:00" Then Call Werkzeuge.SetFileDateTime(Quelle, aktdate, akttime)
        Call Werkzeuge.IsFileOpen(Quelle)
        Name Quelle As Ziel
    End If
err:
    If Sortierung <> "1" Then Call datab(Ziel) 'Datenbank aktualisieren
End Sub
Public Sub untaggedspeichern(Quelle As String, verzeichnis As String, akttime As Date, aktdate As Date)
    Dim Ziel As String, filename As String
    
    'Verzeichnisse werden erstellt
    If LenB(Dir$(frmMain.work.Text + "untagged", vbDirectory)) = 0 Then MkDir frmMain.work.Text + "untagged"
    If LenB(Dir$(frmMain.work.Text + "untagged\" + verzeichnis, vbDirectory)) = 0 Then MkDir frmMain.work.Text + "untagged\" + verzeichnis
    filename = Mid$(Quelle, InStrRev(Quelle, "\") + 1)
    Ziel = frmMain.work.Text + "untagged\" + verzeichnis + "\" + filename
    Call Werkzeuge.SetFileDateTime(Quelle, aktdate, akttime)
    Call Ausgabe.textbox(filename + "......untagged")
    If Quelle = Ziel Then GoTo err
    If LenB(Dir$(Ziel, vbDirectory)) <> 0 Then Kill (Ziel)  'Wenn schon vorhanden, dann löschen
    If Quelle = vbNullString Or Ziel = vbNullString Then GoTo err
    
    If LenB(Dir$(Quelle, vbDirectory)) <> 0 Then
        Call Werkzeuge.IsFileOpen(Quelle)
        Name Quelle As Ziel
    End If
err:
End Sub
