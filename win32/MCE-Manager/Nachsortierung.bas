Attribute VB_Name = "Nachsortierung"
Option Explicit
Public Sub nachs()
    'Hier beginnt die nachsortierung
    Dim cmd As String, filename As String, i As Integer, temppfad As String, F, akttimedate As Date, akttime As Date, aktdate As Date, fso As Object, files() As String, filetagged As Boolean

    If Verriegelung.verriegelungein = "1" Then Exit Sub 'Verriegelung
    frmMain.Nachsortierung.Appearance = 10 'Buttonfarbe ändern
    frmMain.Nachsortierung.ForeColor = &H0&
    i = 0 'schleife rücksetzten
    Call Werkzeuge.suche(extension, frmMain.work.Text + "MP3-Sort\", files(), "0") 'suchunterprogramm wird aufgerufen

    ' Hier wird nach mp3 dateien gesucht
    While i < UBound(files) - 1 'Anzahl der gefundenen files (extension)
        If frmMain.turbo.value = "0" Then DoEvents
        Call Ausgabe.info_loeschen 'Infofenster löschen
        frmMain.infocount.Caption = Trim$(Str$(i)) + "/" + Trim$(Str$(UBound(files) - 1))
        i = i + 1
        filetagged = "0"
        filename = Mid$(files(i), Len(frmMain.work.Text + "MP3-Sort\") + 1, Len(files(i)) - 4 - Len(frmMain.work.Text + "MP3-Sort\"))
        
        'Cancel Abfrage
        If frmMain.Abbrechen.Enabled = "0" Then
            Call Verriegelung.verriegelungaus 'Verriegelung
            Exit Sub
        End If
        
        Set fso = CreateObject("Scripting.FileSystemObject")
        Set F = fso.GetFile(files(i))
        akttimedate = F.DateLastModified 'original date,time, wird von der mp2 ausgelesen
        Set F = Nothing
        Set fso = Nothing
        akttime = Right$(akttimedate, 8)
        aktdate = Left$(akttimedate, 10)
        
        'hier wird tag3 ausgelesen
        temppfad = Tagauslesen(frmMain.work.Text + "MP3-Sort\" + filename + "." + extension, filetagged)
                
        If filetagged Then
            If LenB(Dir$(temppfad + filename + "." + extension, vbDirectory)) <> 0 Or Werkzeuge.data_songexists(filename + "." + extension, "10:00:00 01.01.1990", "01.01.1990", "10:00:00") And allgemeine.ueberschreiben.value Then
                If files(i) <> temppfad + filename + "." + extension Then
                    Werkzeuge.datab (files(i)) 'In Datenbank aufnehmen
                    Kill (files(i))
                    Call Ausgabe.textbox(filename + "......still existing / deleted")
                Else
                    Call Ausgabe.textbox(filename + "......Source=Target")
                End If
            Else
                Werkzeuge.datab (files(i)) 'In Datenbank aufnehmen
                Call file_speichern.taggedspeichern(files(i), temppfad + filename + "." + extension, akttime, aktdate, "1")
            End If
        Else
            Call Ausgabe.textbox(filename + "......sorted / no Info")
        End If
                
        'ausgabe
        frmMain.Sortstatus.value = (100 / (UBound(files) - 1)) * i 'statusbar wird aktualisiert
    Wend
    
    Call Ausgabe.info_loeschen 'Infofenster löschen
    Call Verriegelung.verriegelungaus 'Verriegelung
End Sub
