Attribute VB_Name = "Nachtaggen"
Option Explicit
Public Sub nachtag()
    Dim eigeneplaylist As String, aktdate As Date, akttime As Date, akttimedate As Date, filename As String, tempzeichen As String, cmd As String, verzeichnis As String, i As Integer, F, temppfad As String, position As Integer, mp2zeit As Date, dbfilename As String, fso As Object, files() As String, filetagged As Boolean, artint As String
    
    If Verriegelung.verriegelungein = "1" Then Exit Sub 'Verriegelung
    frmMain.untaggedtaggen.Appearance = 10 'Buttonfarbe ändern
    frmMain.untaggedtaggen.ForeColor = &H0&
    i = 0 'rücksetzten
    
    'Keine untagged files
    If LenB(Dir$(frmMain.work.Text + "untagged\", vbDirectory)) = 0 Then
        Call Verriegelung.verriegelungaus 'Verriegelung
        Exit Sub
    End If
    
    'Suche wird ausgeführt
    Call Werkzeuge.suche(extension, frmMain.work.Text + "untagged\", files(), "1")

    ' Hier wird nach extension dateien gesucht
    While i < UBound(files) - 1
        If frmMain.turbo.Value = "0" Then DoEvents
        Call Ausgabe.info_loeschen 'Infofenster löschen
        frmMain.infocount.Caption = Trim$(Str$(i + 1)) + "/" + Trim$(Str$(UBound(files) - 1))
        i = i + 1
        filetagged = "0"
        calbum = vbNullString
        cinter = vbNullString
        ctitel = vbNullString
        cgenre = vbNullString
        artint = vbNullString
        tempzeichen = Mid$(files(i), Len(frmMain.work.Text + "untagged\") + 1, Len(files(i)))
        position = InStr(tempzeichen, "\")
        
        If position = 0 Then
            MsgBox "Error: Your sourcepath/sourcefile structure is wrong!"
            Exit Sub 'Quellfiles direkt im Quellordner
        End If
        
        verzeichnis = Left$(tempzeichen, position - 1)
        
        If Not Werkzeuge.sourcepathtest(verzeichnis) Then
            MsgBox "Error: Your workpath/workfile structure is wrong!"
            Exit Sub 'Quellfiles direkt im Quellordner
        End If
        
        filename = Mid$(tempzeichen, position + 1, Len(tempzeichen) - 4 - position)
           
        ' Hier wird das datum und die uhrzeit bestimmt
        Set fso = CreateObject("Scripting.FileSystemObject")
        Set F = fso.GetFile(files(i))
        akttimedate = F.DateLastModified 'original date,time, wird von der mp2 ausgelesen
        Set F = Nothing
        
        If Len(Trim$(Str$(akttimedate))) = 10 Then
            akttime = "00:00:00"
        Else
            akttime = Right$(akttimedate, 8)
        End If
        
        frmMain.akttime.Caption = akttime
        
        'Mp2 Dauer wird ausgelesen
        mp2zeit = Werkzeuge.GetMP3Length(files(i))
        frmMain.mp2zeit.Caption = mp2zeit
        
        'Playlistumbruch Abfrage (Nur bei End-Zeit)
        If tagging.zeitauswahl.ListIndex = 1 Then akttimedate = CDate(akttimedate) - mp2zeit
        
        'Playlistname wird generiert
        aktdate = Left$(akttimedate, 10) 'akttimedate muss geteilt werden
        frmMain.aktdate.Caption = aktdate
        eigeneplaylist = Right$(aktdate, 4) + "-" + Mid$(aktdate, 4, 2) + "-" + Left$(aktdate, 2) + "-" + verzeichnis + ".txt"
        
        'Cancel Abfrage
        If frmMain.abbrechen.Enabled = "0" Then
            Call Ausgabe.info_loeschen 'Infofenster löschen
            Call Verriegelung.verriegelungaus 'Verriegelung
            Set fso = Nothing
            Exit Sub
        End If
        
        frmMain.infoplaylist.Caption = verzeichnis
        
        'wenn alte "normale" playlist dann löschen
        If LenB(Dir$(frmMain.work.Text + "untagged\" + verzeichnis + "\" + eigeneplaylist, vbDirectory)) <> 0 Then Kill (frmMain.work.Text + "untagged\" + verzeichnis + "\" + eigeneplaylist)
        
        ' hier wird die geloggte playliste kopiert
        If LenB(Dir$(App.Path + "\playlists\Logged Playlists\" + eigeneplaylist, vbDirectory)) <> 0 And Werkzeuge.plvergleich(verzeichnis, "offline") Then
            If LenB(Dir$(frmMain.work.Text + "untagged\" + verzeichnis + "\" + eigeneplaylist, vbDirectory)) <> 0 Then Kill (frmMain.work.Text + "untagged\" + verzeichnis + "\" + eigeneplaylist)
            fso.CopyFile App.Path + "\playlists\Logged Playlists\" + eigeneplaylist, frmMain.work.Text + "untagged\" + verzeichnis + "\" + eigeneplaylist
            
            'tagid unterprogramm aufrufen
            dbfilename = Tagschreiben(frmMain.work.Text, verzeichnis, akttime, aktdate, frmMain.work.Text + "untagged\" + verzeichnis + "\" + eigeneplaylist, filetagged, artint, mp2zeit)
            
            If filetagged Then
                If allgemeine.ueberschreiben.Value And Werkzeuge.data_songexists(dbfilename, akttimedate, akttime, aktdate) Then
                    Kill (files(i))
                    Call Ausgabe.textbox(frmMain.interprettag.Caption + " - " + frmMain.titeltag.Caption + "......still existing / deleted")
                    GoTo nextrun
                End If
                
                temppfad = Taggen.tagsetzen(verzeichnis, frmMain.work.Text + "untagged\" + verzeichnis + "\" + filename + "." + extension, artint)
                Call file_speichern.taggedspeichern(files(i), temppfad, akttime, aktdate)
                GoTo nextrun
            End If
        End If
        
        ' hier wird die online playliste kopiert
        If LenB(Dir$(App.Path + "\playlists\Online Playlists\" + eigeneplaylist, vbDirectory)) <> 0 And Werkzeuge.plvergleich(verzeichnis, "online") Then
            If LenB(Dir$(frmMain.work.Text + "untagged\" + verzeichnis + "\" + eigeneplaylist, vbDirectory)) <> 0 Then Kill (frmMain.work.Text + "untagged\" + verzeichnis + "\" + eigeneplaylist)
            fso.CopyFile App.Path + "\playlists\Online Playlists\" + eigeneplaylist, frmMain.work.Text + "untagged\" + verzeichnis + "\" + eigeneplaylist
            
            'tagid unterprogramm aufrufen
            dbfilename = Tagschreiben(frmMain.work.Text, verzeichnis, akttime, aktdate, frmMain.work.Text + "untagged\" + verzeichnis + "\" + eigeneplaylist, filetagged, artint, mp2zeit)
            
            If filetagged Then
                If allgemeine.ueberschreiben.Value And Werkzeuge.data_songexists(dbfilename, akttimedate, akttime, aktdate) Then
                    Kill (files(i))
                    Call Ausgabe.textbox(frmMain.interprettag.Caption + " - " + frmMain.titeltag.Caption + "......still existing / deleted")
                    GoTo nextrun
                End If
                
                temppfad = Taggen.tagsetzen(verzeichnis, frmMain.work.Text + "untagged\" + verzeichnis + "\" + filename + "." + extension, artint)
                Call file_speichern.taggedspeichern(files(i), temppfad, akttime, aktdate)
                GoTo nextrun
            End If
        End If
        
        'wenn alte "normale" playlist dann löschen
        If LenB(Dir$(frmMain.work.Text + "untagged\" + verzeichnis + "\" + eigeneplaylist, vbDirectory)) <> 0 Then Kill (frmMain.work.Text + "untagged\" + verzeichnis + "\" + eigeneplaylist)
        
        ' hier wird die amd playliste downgeloadet
        Call Werkzeuge.DownLoad(verzeichnis, aktdate, frmMain.work.Text + "untagged\" + verzeichnis + "\" + eigeneplaylist)
            
        'Wenn Download erfolgreich
        If LenB(Dir$(frmMain.work.Text + "untagged\" + verzeichnis + "\" + eigeneplaylist, vbDirectory)) <> 0 Then
                
            'Playlist kopieren
            If LenB(Dir$(App.Path + "\playlists\Online Playlists\" + eigeneplaylist, vbDirectory)) <> 0 Then
                If FileLen(frmMain.work.Text + "untagged\" + verzeichnis + "\" + eigeneplaylist) > FileLen(App.Path + "\playlists\Online Playlists\" + eigeneplaylist) Then
                    Kill (App.Path + "\playlists\Online Playlists\" + eigeneplaylist)
                    fso.CopyFile frmMain.work.Text + "untagged\" + verzeichnis + "\" + eigeneplaylist, App.Path + "\playlists\Online Playlists\" + eigeneplaylist
                End If
            Else
                fso.CopyFile frmMain.work.Text + "untagged\" + verzeichnis + "\" + eigeneplaylist, App.Path + "\playlists\Online Playlists\" + eigeneplaylist
            End If
            
            'tagid unterprogramm aufrufen
            dbfilename = Tagschreiben(frmMain.work.Text, verzeichnis, akttime, aktdate, frmMain.work.Text + "untagged\" + verzeichnis + "\" + eigeneplaylist, filetagged, artint, mp2zeit) 'hier wird tag3 geschrieben
                
            'getaggtes file verschieben
            If filetagged Then
                If allgemeine.ueberschreiben.Value And Werkzeuge.data_songexists(dbfilename, akttimedate, akttime, aktdate) Then
                    Kill (files(i))
                    Call Ausgabe.textbox(frmMain.interprettag.Caption + " - " + frmMain.titeltag.Caption + "......still existing / deleted")
                    GoTo nextrun
                End If
                
                temppfad = Taggen.tagsetzen(verzeichnis, frmMain.work.Text + "untagged\" + verzeichnis + "\" + filename + "." + extension, artint)
                Call file_speichern.taggedspeichern(files(i), temppfad, akttime, aktdate)
                GoTo nextrun
            Else
                'ungetaggtes file verschieben
                Call file_speichern.untaggedspeichern(files(i), verzeichnis, akttime, aktdate)
            End If
        Else
            'ungetaggtes file verschieben
            Call file_speichern.untaggedspeichern(files(i), verzeichnis, akttime, aktdate)
        End If
nextrun:
        frmMain.statusnachtag.Value = (100 / (UBound(files) - 1)) * i 'statusbar wird aktualisiert
    Wend
    
    Set fso = Nothing
    Call Ausgabe.info_loeschen 'Infofenster löschen
    Call Verriegelung.verriegelungaus 'Verriegelung
End Sub


