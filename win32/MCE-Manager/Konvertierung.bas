Attribute VB_Name = "Konvertierung"
Option Explicit
Public Sub Konvert()
    Dim tempzeichen As String, filename As String, akttimedate As Date, akttime As Date, aktdate As Date, cmd As String, verzeichnis As String, F, temppfad As String, position As Integer, mp2zeit As Date, dbfilename As String, quellfile As String, eigeneplaylist As String, i As Integer, fso As Object, files() As String, filetagged As Boolean, artint As String
    
    If Verriegelung.verriegelungein = "1" Then Exit Sub 'Verriegelung
    frmMain.start.Appearance = 10 'Buttondesign ändern
    frmMain.start.ForeColor = &H0& 'Buttonfarbe ändern
    If allgemeine.timesync_konv.value = "1" Then Call Timesyncron.Command1_Click
    i = 0 'Rücksetzten
    Call Werkzeuge.suche("mp2", frmMain.Quelle.Text, files(), "1") 'Suche, nach mp2-files wird ausgeführt
    
    ' Hier werden Daten der gefundenen files ausgewertet (Verzeichnis und Filename)
    If UBound(files) = 1 Then Call Ausgabe.textbox("No source-files")
    
    While i < UBound(files) - 1 'Anzahl der gefundenen files
        If UBound(files) - 1 < Scannen.minfiles.CurPosition And Aktivierauswahl.scan_aktiv.value = "1" Then
            Call Ausgabe.textbox("Too few source-files..." + Str(UBound(files) - 1) + "/" + Str(Scannen.minfiles.CurPosition))
            Call Verriegelung.verriegelungaus
            Exit Sub
        End If
        
        If frmMain.turbo.value = "0" Then DoEvents
        Call Ausgabe.info_loeschen 'Infofenster löschen
        frmMain.infocount.Caption = Trim$(Str$(i + 1)) + "/" + Trim$(Str$(UBound(files) - 1))
        i = i + 1
        filetagged = "0" 'Rücksetzen der Marke
        calbum = vbNullString
        cinter = vbNullString
        ctitel = vbNullString
        cgenre = vbNullString
        artint = vbNullString
        tempzeichen = Mid$(files(i), Len(frmMain.Quelle.Text) + 1, Len(files(i)))
        position = InStr(tempzeichen, "\") 'Sucht das "\" und gibt Position zurück
        
        If position = 0 Then
            MsgBox "Error: Your sourcepath/sourcefile structure is wrong!"
            Exit Sub 'Quellfiles direkt im Quellordner
        End If
        
        verzeichnis = Left$(tempzeichen, position - 1) 'Verzeichnis wird herrausgelesen
        
        filename = Mid$(tempzeichen, position + 1, Len(tempzeichen) - 4 - position) 'Filename ohne Pfad und Extension
                
        'Wenn es sich um ein untagged file handelt, dann Verzeichnis von file auslesen
        If verzeichnis = "untagged" Or verzeichnis = "Untagged" Then
            tempzeichen = Right$(tempzeichen, Len(tempzeichen) - 9)
            position = InStr(1, tempzeichen, "-")
            verzeichnis = Trim$(Mid$(tempzeichen, position + 1, Len(tempzeichen) - position - 4))
        End If
        
        If Not Werkzeuge.sourcepathtest(verzeichnis) Then
            MsgBox "Error: Your sourcepath/sourcefile structure is wrong!"
            Exit Sub 'Quellfiles direkt im Quellordner
        End If
        
        'Kontrolle ob file "delsize" byte hat
        If LenB(Dir$(files(i), vbDirectory)) <> 0 Then
            frmMain.mp2size.Caption = format(FileLen(files(i)) / 1024, "0.0") + "kb"
        Else
            GoTo nextrun
        End If
        
        If FileLen(files(i)) < tagging.delsize(0).CurPosition Then
            If LenB(Dir$(files(i), vbDirectory)) <> 0 Then Kill files(i)
            GoTo nextrun
        End If
          
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
        If Not frmMain.Abbrechen.Enabled Then
            Call Ausgabe.info_loeschen 'Infofenster löschen
            Call Verriegelung.verriegelungaus 'Verriegelung
            Set fso = Nothing
            Exit Sub
        End If
        
        frmMain.infoplaylist.Caption = verzeichnis
        Excel_Statistik.AddDatagesamt 'Datenbank (Excel) Gesamtdata addieren
        
        ' hier wird die geloggte playliste kopiert
        If LenB(Dir$(App.Path + "\playlists\Logged Playlists\" + eigeneplaylist, vbDirectory)) <> 0 And Werkzeuge.plvergleich(verzeichnis, "offline") Then
            If LenB(Dir$(frmMain.work.Text + eigeneplaylist, vbDirectory)) <> 0 Then Kill (frmMain.work.Text + eigeneplaylist)
            fso.CopyFile App.Path + "\playlists\Logged Playlists\" + eigeneplaylist, frmMain.work.Text + eigeneplaylist
                
            'hier wird tag3 geschrieben
            dbfilename = Tagschreiben(frmMain.work.Text, verzeichnis, akttime, aktdate, frmMain.work.Text + eigeneplaylist, filetagged, artint, mp2zeit)
            
            If filetagged Then  'Wenn TagID Infos vorhanden sind
                If allgemeine.ueberschreiben.value And Werkzeuge.data_songexists(dbfilename, akttimedate, akttime, aktdate) Then
                    Kill (files(i))
                    Call Ausgabe.textbox(frmMain.interprettag.Caption + " - " + frmMain.titeltag.Caption + "......still existing / deleted") 'Wenn File existiert, dann löschen
                    frmMain.statuscon.value = (100 / (UBound(files) - 1)) * i 'statusbar wird aktualisiert
                    GoTo nextrun
                End If
                
                quellfile = konvertieren(files(i), filename, verzeichnis, eigeneplaylist) 'Konvertierung starten
                If quellfile = "error" Then GoTo nextrun
                temppfad = Taggen.tagsetzen(verzeichnis, frmMain.work.Text + filename + "." + extension, artint) 'TagID in konvertiertes File schreiben
                Call tagged(quellfile, temppfad, files(i), akttime, aktdate, i, (UBound(files) - 1)) 'File verschieben
                GoTo nextrun
            End If
        End If
        
        ' hier wird die Online playliste kopiert
        If LenB(Dir$(App.Path + "\playlists\Online Playlists\" + eigeneplaylist, vbDirectory)) <> 0 And Werkzeuge.plvergleich(verzeichnis, "online") Then
            If LenB(Dir$(frmMain.work.Text + eigeneplaylist, vbDirectory)) <> 0 Then Kill (frmMain.work.Text + eigeneplaylist)
            fso.CopyFile App.Path + "\playlists\Online Playlists\" + eigeneplaylist, frmMain.work.Text + eigeneplaylist
                
            'hier wird tag3 geschrieben
            dbfilename = Tagschreiben(frmMain.work.Text, verzeichnis, akttime, aktdate, frmMain.work.Text + eigeneplaylist, filetagged, artint, mp2zeit)
            
            If filetagged Then  'Wenn TagID Infos vorhanden sind
                If allgemeine.ueberschreiben.value And Werkzeuge.data_songexists(dbfilename, akttimedate, akttime, aktdate) Then
                    Kill (files(i))
                    Call Ausgabe.textbox(frmMain.interprettag.Caption + " - " + frmMain.titeltag.Caption + "......still existing / deleted") 'Wenn File existiert, dann löschen
                    frmMain.statuscon.value = (100 / (UBound(files) - 1)) * i 'statusbar wird aktualisiert
                    GoTo nextrun
                End If
                
                quellfile = konvertieren(files(i), filename, verzeichnis, eigeneplaylist) 'Konvertierung starten
                If quellfile = "error" Then GoTo nextrun
                temppfad = Taggen.tagsetzen(verzeichnis, frmMain.work.Text + filename + "." + extension, artint) 'TagID in konvertiertes File schreiben
                Call tagged(quellfile, temppfad, files(i), akttime, aktdate, i, (UBound(files) - 1)) 'File verschieben
                GoTo nextrun
            End If
        End If
        
        ' hier wird die Online playliste downgeloadet
        If LenB(Dir$(frmMain.work.Text + eigeneplaylist, vbDirectory)) <> 0 Then Kill (frmMain.work.Text + eigeneplaylist)
        Call Werkzeuge.DownLoad(verzeichnis, aktdate, frmMain.work.Text + eigeneplaylist)
                  
        If LenB(Dir$(frmMain.work.Text + eigeneplaylist, vbDirectory)) <> 0 Then
            
            'Playlist kopieren
            If LenB(Dir$(App.Path + "\playlists\Online Playlists\" + eigeneplaylist, vbDirectory)) <> 0 Then
                If FileLen(frmMain.work.Text + eigeneplaylist) > FileLen(App.Path + "\playlists\Online Playlists\" + eigeneplaylist) Then
                    Kill (App.Path + "\playlists\Online Playlists\" + eigeneplaylist)
                    fso.CopyFile frmMain.work.Text + eigeneplaylist, App.Path + "\playlists\Online Playlists\" + eigeneplaylist
                End If
            Else
                fso.CopyFile frmMain.work.Text + eigeneplaylist, App.Path + "\playlists\Online Playlists\" + eigeneplaylist
            End If
            
            'hier wird tag3 geschrieben
            dbfilename = Tagschreiben(frmMain.work.Text, verzeichnis, akttime, aktdate, frmMain.work.Text + eigeneplaylist, filetagged, artint, mp2zeit)
                
            If filetagged Then
                If allgemeine.ueberschreiben.value And Werkzeuge.data_songexists(dbfilename, akttimedate, akttime, aktdate) Then
                    Kill (files(i))
                    Call Ausgabe.textbox(frmMain.interprettag.Caption + " - " + frmMain.titeltag.Caption + "......still existing / deleted")
                    frmMain.statuscon.value = (100 / (UBound(files) - 1)) * i 'statusbar wird aktualisiert
                    GoTo nextrun
                End If
                    
                quellfile = konvertieren(files(i), filename, verzeichnis, eigeneplaylist)
                If quellfile = "error" Then GoTo nextrun
                temppfad = Taggen.tagsetzen(verzeichnis, frmMain.work.Text + filename + "." + extension, artint)
                Call tagged(quellfile, temppfad, files(i), akttime, aktdate, i, (UBound(files) - 1))
            Else
                quellfile = konvertieren(files(i), filename, verzeichnis, eigeneplaylist)
                If quellfile = "error" Then GoTo nextrun
                Call untagged(quellfile, verzeichnis, akttime, aktdate, files(i), i, (UBound(files) - 1))
            End If
        Else
            quellfile = konvertieren(files(i), filename, verzeichnis, eigeneplaylist)
            If quellfile = "error" Then GoTo nextrun
            Call untagged(quellfile, verzeichnis, akttime, aktdate, files(i), i, (UBound(files) - 1))
        End If
nextrun:
    Wend
    
    Set fso = Nothing
    Call Ausgabe.info_loeschen 'Infofenster löschen
    Call Verriegelung.verriegelungaus 'Verriegelung
End Sub
Private Function konvertieren(file As String, filename As String, verzeichnis As String, eigeneplaylist As String) As String
        Dim cmd As String, temppfad As String, quellfile As String, F As Integer, mp2test As String, addline As String, fso As Object, DShell As Object, genie As Object
        
        On Error GoTo fehler
        Set DShell = New Dos
        'MP2 Überprüfung
        If allgemeine.mp2test.value = "1" Then
            cmd = """" + App.Path + "\tools\besplit.exe""" + " -core( -input """ + file + """ -output """ + App.Path + "\temp\mp2test.mp2""" + " -type mp2 -logfile """ + App.Path + "\temp\mp2test.log""" + " )" 'Dos-Befehl bilden
            Call DShell.shellwait(cmd, allgemeine.showdos.value) 'Dos-Befehle ausführen
            If LenB(Dir$(App.Path + "\temp\mp2test.mp2", vbDirectory)) <> 0 Then Kill (App.Path + "\temp\mp2test.mp2")
            
            If LenB(Dir$(App.Path + "\temp\mp2test.log", vbDirectory)) <> 0 Then
                Call Werkzeuge.IsFileOpen(App.Path + "\temp\mp2test.log")
                F = FreeFile
                
                Open App.Path + "\temp\mp2test.log" For Binary As #F
                    mp2test = Space$(LOF(F))
                    Get #F, , mp2test
                Close F
                
                If InStr(mp2test, "Stream error") Then
                    Call Ausgabe.textbox(filename + ".mp2......MP2-Error / moved")
                    If LenB(Dir$(frmMain.work.Text + "Error", vbDirectory)) = 0 Then MkDir frmMain.work.Text + "Error"
                    If LenB(Dir$(frmMain.work.Text + "Error\" + verzeichnis, vbDirectory)) = 0 Then MkDir frmMain.work.Text + "Error\" + verzeichnis
                    Call Werkzeuge.IsFileOpen(file)
                    Name file As frmMain.work.Text + "Error\" + verzeichnis + "\" + filename + ".mp2"
                    Kill (App.Path + "\temp\mp2test.log")
                    konvertieren = "error"
                    Set DShell = Nothing
                    Exit Function
                End If
                
                Kill (App.Path + "\temp\mp2test.log")
            End If
        End If
        
        If extension = "mp2" Then
            If frmMain.noextension.value = "1" Then
                Set fso = CreateObject("Scripting.FileSystemObject")
                fso.CopyFile file, frmMain.work.Text + filename + ".mp2"
                Set fso = Nothing
            Else
                ' hier startet lame (mp2 in temp.wav)
                cmd = """" + App.Path + "\tools\lame.exe""" + " --decode --priority " + shell_prio + " """ + file + """ """ + frmMain.work.Text + "temp.wav""" 'Dos-Befehl bilden
                Call DShell.shellwait(cmd, allgemeine.showdos.value) 'Dos-Befehle ausführen
                
                If Aktivierauswahl.mp2normal_aktiv.value = "1" Then
                    frmMain.normset.Caption = " Normalize" 'Infofenster
                    
                    If normal.prozenable.value = "1" Then
                        frmMain.normset.Caption = frmMain.normset.Caption + " ,auto ," + Str$(normal.peakprozslider.CurPosition) + "%" 'Infofenster
                    Else
                        frmMain.normset.Caption = frmMain.normset.Caption + " ,constant ," + Str$(normal.peakdbslider.CurPosition) + "db" 'Infofenster
                    End If
                    
                    ' hier startet normalisierung
                    cmd = """" + App.Path + "\tools\" + "normalize.exe """ + normoptions + " """ + frmMain.work.Text + "temp.wav""" 'Dos-Befehl bilden
                    Call DShell.shellwait(cmd, allgemeine.showdos.value) 'Dos-Befehle ausführen
                End If
                
                'Rückkonvertierung
                If Aktivierauswahl.mp2_cbr_aktiv.value = "1" Then
                    frmMain.encoderset.Caption = "CBR " + MP2cbrmenu.cbrbitrate.Text 'Infofenster
                    cmd = """" + App.Path + "\tools\toolame.exe""" + " """ + frmMain.work.Text + "temp.wav"" " + """" + frmMain.work.Text + filename + ".mp2"" " + MP2cbrparameter
                    Call DShell.shellwait(cmd, allgemeine.showdos.value) 'Dos-Befehle ausführen
                Else
                    frmMain.encoderset.Caption = "VBR " + MP2cbrmenu.cbrbitrate.Text 'Infofenster
                    cmd = """" + App.Path + "\tools\toolame.exe""" + " """ + frmMain.work.Text + "temp.wav"" " + """" + frmMain.work.Text + filename + ".mp2"" " + MP2vbrparameter
                    Call DShell.shellwait(cmd, allgemeine.showdos.value) 'Dos-Befehle ausführen
                End If
            End If
        End If
        
        If extension = "ogg" Then
            ' hier startet lame (mp2 in temp.wav)
            cmd = """" + App.Path + "\tools\lame.exe""" + " --decode --priority " + shell_prio + " """ + file + """ """ + frmMain.work.Text + "temp.wav""" 'Dos-Befehl bilden
            Call DShell.shellwait(cmd, allgemeine.showdos.value) 'Dos-Befehle ausführen
                
            If Aktivierauswahl.oggnormal_aktiv.value = "1" Then
                frmMain.normset.Caption = " Normalize" 'Infofenster
                    
                If normal.prozenable.value = "1" Then
                    frmMain.normset.Caption = frmMain.normset.Caption + " ,auto ," + Str$(normal.peakprozslider.CurPosition) + "%" 'Infofenster
                Else
                    frmMain.normset.Caption = frmMain.normset.Caption + " ,constant ," + Str$(normal.peakdbslider.CurPosition) + "db" 'Infofenster
                End If
                    
                ' hier startet normalisierung
                cmd = """" + App.Path + "\tools\" + "normalize.exe """ + normoptions + " """ + frmMain.work.Text + "temp.wav""" 'Dos-Befehl bilden
                Call DShell.shellwait(cmd, allgemeine.showdos.value) 'Dos-Befehle ausführen
            End If
                
            'Rückkonvertierung
            cmd = """" + App.Path + "\tools\oggenc.exe""" + " """ + frmMain.work.Text + "temp.wav"" " + OGGparameter
            Call DShell.shellwait(cmd, allgemeine.showdos.value) 'Dos-Befehle ausführen
            Call Werkzeuge.IsFileOpen(frmMain.work.Text + "temp.ogg")
            Name frmMain.work.Text + "temp.ogg" As frmMain.work.Text + filename + ".ogg"
        End If
        
        If extension = "mp3" Then
            If Aktivierauswahl.mp3normal_aktiv.value = "1" Then 'wenn normalisierung (normalize) aktiviert
                frmMain.normset.Caption = " Normalize" 'Infofenster
                
                If normal.prozenable.value = "1" Then
                    frmMain.normset.Caption = frmMain.normset.Caption + " ,auto ," + Str$(normal.peakprozslider.CurPosition) + "%" 'Infofenster
                Else
                    frmMain.normset.Caption = frmMain.normset.Caption + " ,constant ," + Str$(normal.peakdbslider.CurPosition) + "db" 'Infofenster
                End If
                
                ' hier startet lame (mp2 in temp.wav)
                cmd = """" + App.Path + "\tools\lame.exe""" + " --decode --priority " + shell_prio + " """ + file + """ """ + frmMain.work.Text + "temp.wav""" 'Dos-Befehl bilden
                Call DShell.shellwait(cmd, allgemeine.showdos.value) 'Dos-Befehle ausführen
                
                ' hier startet normalisierung
                cmd = """" + App.Path + "\tools\" + "normalize.exe """ + normoptions + " """ + frmMain.work.Text + "temp.wav""" 'Dos-Befehl bilden
                Call DShell.shellwait(cmd, allgemeine.showdos.value) 'Dos-Befehle ausführen
                temppfad = """" + frmMain.work.Text + "temp.wav"" """ + frmMain.work.Text + filename + "." + extension + """ " 'wenn normalisierung aktiviert
            Else
                temppfad = """" + file + """ """ + frmMain.work.Text + filename + "." + extension + """ " 'wenn normalisierung (normalize) deaktiviert
            End If
            
            'Hier wird Lame gestartet
            If Aktivierauswahl.mp3_cbr_aktiv.value = "1" Then 'CBR verwenden
                frmMain.encoderset.Caption = "CBR " + MP3cbrmenu.cbrbitrate.Text 'Infofenster
                cmd = """" + App.Path + "\tools\lame.exe"" " + temppfad + MP3cbrparameter    'Dos-Befehl bilden
                Call DShell.shellwait(cmd, allgemeine.showdos.value) 'Dos-Befehle ausführen
            End If
            
            If Aktivierauswahl.mp3_vbr_aktiv.value = "1" Then 'VBR verwenden
                frmMain.encoderset.Caption = "VBR " + MP3vbrmenu.minbit.Text + "/" + MP3vbrmenu.maxbit.Text 'Infofenster
                cmd = """" + App.Path + "\tools\lame.exe"" " + temppfad + MP3vbrparameter  'Dos-Befehl bilden
                Call DShell.shellwait(cmd, allgemeine.showdos.value) 'Dos-Befehle ausführen
            End If
                
            If Aktivierauswahl.mp3_abr_aktiv.value = "1" Then 'ABR verwenden
                frmMain.encoderset.Caption = "ABR " + MP3abrmenu.abrbitrate.Text 'Infofenster
                cmd = """" + App.Path + "\tools\lame.exe"" " + temppfad + MP3abrparameter   'Dos-Befehl bilden
                Call DShell.shellwait(cmd, allgemeine.showdos.value) 'Dos-Befehle ausführen
            End If
            
            'MP3-Gain (mp3 normalisierung)
            If Aktivierauswahl.mp3gain_aktiv.value = "1" Then
                frmMain.normset.Caption = " MP3-Gain" 'Infofenster
    
                If mp3gain.auto.value = "1" Then
                    frmMain.normset.Caption = frmMain.normset.Caption + " ,auto" 'Infofenster
                Else
                    frmMain.normset.Caption = frmMain.normset.Caption + " ,constant ," + Str$(mp3gain.Slider1.CurPosition) + "db" 'Infofenster
                End If
                
                cmd = """" + App.Path + "\tools\mp3gain.exe""" + mp3gainstring + """" + frmMain.work.Text + filename + "." + extension + """" 'Dos-Befehl bilden
                Call DShell.shellwait(cmd, allgemeine.showdos.value) 'Dos-Befehle ausführen
            End If
        End If
        
        frmMain.mp3size.Caption = format(FileLen(frmMain.work.Text + filename + "." + extension) / 1024, "0.0") + "kb"
        quellfile = frmMain.work.Text + filename + "." + extension 'Tempquellfile wird bestimmt
        If LenB(Dir$(frmMain.work.Text + eigeneplaylist, vbDirectory)) <> 0 Then Kill (frmMain.work.Text + eigeneplaylist) 'wenn alte "normale" playlist dann löschen
        konvertieren = quellfile
        
        If extension = "mp2" Or extension = "mp3" Then
            Set genie = frmMain.AudioGenie
            genie.ID3v2EncodeSettings = frmMain.encoderset.Caption + frmMain.normset.Caption 'Encodersettings
            genie.SaveID3v2ToFile (konvertieren)
            Set genie = Nothing
        End If
        
        If FileLen(konvertieren) < tagging.delsize(0).CurPosition Then
            If LenB(Dir$(konvertieren, vbDirectory)) <> 0 Then Kill konvertieren
            Call Ausgabe.textbox(filename + ".mp2......Filesize problem / deleted")
            konvertieren = "error"
        End If
        
        Set DShell = Nothing
        
        Exit Function
fehler:
        Call Ausgabe.textbox("Unknown problem / trying next file")
        konvertieren = "error"
End Function
Private Sub untagged(quellfile As String, verzeichnis As String, akttime As Date, aktdate As Date, file As String, anzahl As Integer, upperlimit As Integer)
    Call file_speichern.untaggedspeichern(quellfile, verzeichnis, akttime, aktdate) 'File verschieben
    If allgemeine.quelldel.value = "1" And LenB(Dir$(file, vbDirectory)) <> 0 Then Kill (file) 'quelldateien werden gelöscht
    frmMain.statuscon.value = (100 / upperlimit) * anzahl 'statusbar wird aktualisiert
End Sub
Private Sub tagged(quellfile As String, temppfad As String, file As String, akttime As Date, aktdate As Date, anzahl As Integer, upperlimit As Integer)
    Call file_speichern.taggedspeichern(quellfile, temppfad, akttime, aktdate) 'File verschieben
    frmMain.statuscon.value = (100 / upperlimit) * anzahl 'statusbar wird aktualisiert
    If allgemeine.quelldel.value = "1" And LenB(Dir$(file, vbDirectory)) <> 0 Then Kill (file) 'quelldateien werden gelöscht
End Sub

