Attribute VB_Name = "Taggen"
Option Explicit
Public Function Tagschreiben(Ziel As String, verzeichnis As String, Zeit As Date, datum As Date, aktplaylist As String, ByRef filetagged As Boolean, ByRef artint As String, Optional mp2dauer As Date) As String
    Dim i As Integer, F As Integer, akttime As Date, maxtime As Date, mintime As Date, timedrift As Date, filesize As Long, filestring As String, NewLine As String, PosStart As Long, PosEnd As Long, position1 As Integer, position2 As Integer, rline As Variant, dauer As Date, trennzei As String, sinterpret As String, stitel As String, genie As Object
    
    Call Werkzeuge.IsFileOpen(aktplaylist)
    F = FreeFile
    
    Open aktplaylist For Binary As #F
        filesize = LOF(F)
        If filesize = 0 Then filesize = 1 'Verhindert Fehler
        filestring = Space$(filesize)
        Get #F, , filestring
    Close #F

    NewLine = NewlineString(filestring)
    PosStart = 1 'Startposition setzen

    Do
        If frmMain.turbo.Value = "0" Then DoEvents
        PosEnd = InStr(PosStart, filestring, NewLine) 'Nächste Zeile rausschneiden:
        
        If PosEnd Then
            rline = Mid$(filestring, PosStart, PosEnd - PosStart)
            PosStart = PosEnd + Len(NewLine)
        Else
            Exit Do
        End If

        If tagging.zeitauswahl.ListIndex = 0 And Mid$(rline, 14, 1) = ":" Then akttime = Mid$(rline, 12, 8) 'Zeitauswahl 'Start Zeit
        If tagging.zeitauswahl.ListIndex = 1 And Mid$(rline, 23, 1) = ":" Then akttime = Mid$(rline, 21, 8) 'Zeitauswahl End Zeit

        'Timedrift wird ins Date-Format gewandelt
        Select Case tagging.drift.CurPosition
            Case 0 To 59
                timedrift = "00:00:" + Str$(tagging.drift.CurPosition) 'Driftrate wird ins "Date" Format umgewandelt
            Case 60 To 119
                timedrift = "00:01:" + Str$(tagging.drift.CurPosition - 60) 'Driftrate wird ins "Date" Format umgewandelt
        End Select

        mintime = Zeit - timedrift
        mintime = Right$(mintime, 8) 'Right ist nötig, falls Playlist am nächsten Tag (Formatwechsel)
        maxtime = Zeit + timedrift
        maxtime = Right$(maxtime, 8) 'Right ist nötig, falls Playlist am nächsten Tag (Formatwechsel)
        
        If mintime < akttime And akttime < maxtime Then 'Wenn extension Date in Driftbereich, dann weiter machen
            
            'Längenabfrage des mp2 files
            dauer = CDate(Mid$(rline, 12, 8)) - CDate(Mid$(rline, 21, 8))
            If (CDate(Str$(dauer)) - CDate(Str$(tagging.dauerslider(1).CurPosition))) >= CDate(Str$(mp2dauer)) And CDate(dauer) + CDate(Str$(tagging.dauerslider(1).CurPosition)) <= CDate(Str$(mp2dauer)) Then Exit Do

            filetagged = "1" 'Marke setzten

            'Infos auslesen
            position1 = InStr(30, rline, ";")
            frmMain.interprettag.Caption = Mid$(rline, 30, position1 - 30) 'Interprettag auslesen
            position2 = InStr(position1 + 1, rline, ";")
            frmMain.titeltag.Caption = Mid$(rline, position1 + 1, position2 - position1 - 1) 'Titel auslesen
            position1 = InStr(position2 + 1, rline, ";")
            frmMain.Albumtag.Caption = Mid$(rline, position2 + 1, position1 - position2 - 1) 'Albumtag auslesen
            position2 = InStr(position1 + 1, rline, ";")
            frmMain.Labeltag.Caption = Mid$(rline, position1 + 1, position2 - position1 - 1) 'Labeltag auslesen
            frmMain.yeartag.Caption = Right$(rline, 4) 'Jahr auslesen
            If frmMain.yeartag.Caption = "0000" Then frmMain.yeartag.Caption = vbNullString
            artint = frmMain.interprettag.Caption 'Interpret mit Artikel
        
            'Genre wird bestimmt
            For i = 0 To 20
                If verzeichnis = plbezeichnung.plID(i).Text Then frmMain.genretag.Caption = Genre.genreID(i).Text
            Next i
            
            If InStr(frmMain.interprettag.Caption, "   ") Then frmMain.interprettag.Caption = Left(frmMain.interprettag.Caption, Len(frmMain.interprettag.Caption) - InStr(frmMain.interprettag.Caption, "   "))
            frmMain.interprettag.Caption = Trim$(frmMain.interprettag.Caption)
            If InStr(frmMain.titeltag.Caption, "   ") Then frmMain.titeltag.Caption = Left(frmMain.titeltag.Caption, Len(frmMain.titeltag.Caption) - InStr(frmMain.titeltag.Caption, "   "))
            frmMain.titeltag.Caption = Trim$(frmMain.titeltag.Caption)
            If InStr(frmMain.Albumtag.Caption, "   ") Then frmMain.Albumtag.Caption = Left(frmMain.Albumtag.Caption, Len(frmMain.Albumtag.Caption) - InStr(frmMain.Albumtag.Caption, "   "))
            frmMain.Albumtag.Caption = Trim$(frmMain.Albumtag.Caption)
            If InStr(frmMain.yeartag.Caption, "   ") Then frmMain.yeartag.Caption = Left(frmMain.yeartag.Caption, Len(frmMain.yeartag.Caption) - InStr(frmMain.yeartag.Caption, "   "))
            frmMain.yeartag.Caption = Trim$(frmMain.yeartag.Caption)
            Set genie = frmMain.AudioGenie
            genie.ID3v2Length = mp2dauer
            genie.ID3v2RecordingTime = Str$(Date) + " - " + Str$(Zeit)
            genie.ID3v2Comment 1, "Deu", vbNullString, frmMain.Labeltag.Caption 'Label setzen
            Set genie = Nothing
            
            'Interprettag nach "," abschneiden
            If sort.komma.Value = "1" And InStr(frmMain.interprettag.Caption, ",") <> 0 Then frmMain.interprettag.Caption = Mid$(frmMain.interprettag.Caption, 1, InStr(frmMain.interprettag.Caption, ",") - 1)
            
            'Artikel abschneiden
            If sort.artikel.Value = "1" Then If Mid$(frmMain.interprettag.Caption, 1, 4) = "The " Or Mid$(frmMain.interprettag.Caption, 1, 4) = "Die " Or Mid$(frmMain.interprettag.Caption, 1, 4) = "Das " Or Mid$(frmMain.interprettag.Caption, 1, 4) = "Der " Then frmMain.interprettag.Caption = Mid$(frmMain.interprettag.Caption, 5, Len(frmMain.interprettag.Caption) - 4)
            
            'Trennzeichen wird bestimmt
            If tagging.korrsymbol.Text = "Line:         ""-""" Then trennzei = "-"
            If tagging.korrsymbol.Text = "Underline: ""_""" Then trennzei = "_"
            If tagging.korrsymbol.Text = "Space:      "" """ Then trennzei = " "
                    
            'Sonderzeichen Filter
            sinterpret = frmMain.interprettag.Caption
            stitel = frmMain.titeltag.Caption
            
            For i = 1 To Len(Sondercheck)
                sinterpret = Replace(sinterpret, Mid$(Sondercheck, i, 1), trennzei) 'Sonderzeichen durch Leerzeichen ersetzten
                stitel = Replace(stitel, Mid$(Sondercheck, i, 1), trennzei) 'Sonderzeichen durch Leerzeichen ersetzten
            Next i
            
            Exit Do
        End If
    Loop While PosEnd
    
    Tagschreiben = Trim$(sinterpret) + " - " + Trim$(stitel) + "." + extension
End Function
Public Function tagsetzen(verzeichnis As String, tagfile As String, artint As String) As String
    Dim Songtext As String, temppfad As String, trennzei As String, i As Integer, genie As Object, F As Integer, filesize As Long, pos As Integer, cover_dl As Object
    
    'Trennzeichen wird bestimmt
    If tagging.korrsymbol.Text = "Line:         ""-""" Then trennzei = "-"
    If tagging.korrsymbol.Text = "Underline: ""_""" Then trennzei = "_"
    If tagging.korrsymbol.Text = "Space:      "" """ Then trennzei = " "
    
    'Coverdownload
    If allgemeine.coverdownload.Value = "1" Then
        Set cover_dl = New Cover
        If InStr(1, frmMain.Albumtag.Caption, "single", vbTextCompare) = 0 And InStr(1, frmMain.Albumtag.Caption, "venyl", vbTextCompare) = 0 And extension <> "ogg" Then Call cover_dl.cover_download(frmMain.interprettag.Caption, frmMain.Albumtag.Caption, tagging.korrsymbol.Text, Sondercheck)
        Set cover_dl = Nothing
    End If
    
    cinter = frmMain.interprettag.Caption
    calbum = frmMain.Albumtag.Caption
    ctitel = frmMain.titeltag.Caption
    cgenre = frmMain.genretag.Caption
    
    For i = 1 To Len(Sondercheck)
        cinter = Trim$(Replace(cinter, Mid$(Sondercheck, i, 1), trennzei)) 'Sonderzeichen durch Leerzeichen ersetzten
        calbum = Trim$(Replace(calbum, Mid$(Sondercheck, i, 1), trennzei)) 'Sonderzeichen durch Leerzeichen ersetzten
        ctitel = Trim$(Replace(ctitel, Mid$(Sondercheck, i, 1), trennzei)) 'Sonderzeichen durch Leerzeichen ersetzten
        cgenre = Trim$(Replace(cgenre, Mid$(Sondercheck, i, 1), trennzei)) 'Sonderzeichen durch Leerzeichen ersetzten
    Next i
    
    'Songtext download
    Songtext = Songtext_dl.songtextdl(cinter, ctitel, artint)
    
    Set genie = frmMain.AudioGenie
    Call Werkzeuge.IsFileOpen(tagfile)
    
    'Hier wird die tag geschrieben
    If frmMain.interprettag.Caption <> vbNullString Then
        If extension = "mp3" Or extension = "mp2" Then
            genie.ReadMPEGFromFile (tagfile)
            genie.ID3v2Encoder = genie.GetMPEGEncoder
            If Songtext <> vbNullString Then genie.ID3v2Lyric 1, "Deu", vbNullString, Songtext
            If LenB(Dir$(App.Path & "\Datenbank\Covers\" + cinter + " - " + calbum + "_Front." + "jpg", vbDirectory)) <> 0 Then genie.ID3v2SavePictureWithType App.Path & "\Datenbank\Covers\" + cinter + " - " + calbum + "_Front.jpg", 3
            If LenB(Dir$(App.Path & "\Datenbank\Covers\" + cinter + " - " + calbum + "_Back." + "jpg", vbDirectory)) <> 0 Then genie.ID3v2SavePictureWithType App.Path & "\Datenbank\Covers\" + cinter + " - " + calbum + "_Back.jpg", 4
            If LenB(Dir$(App.Path & "\Datenbank\Covers\" + cinter + " - " + calbum + "_Cd." + "jpg", vbDirectory)) <> 0 Then genie.ID3v2SavePictureWithType App.Path & "\Datenbank\Covers\" + cinter + " - " + calbum + "_Cd.jpg", 0
            If LenB(Dir$(App.Path & "\Datenbank\Covers\" + cinter + " - " + calbum + "_Inside." + "jpg", vbDirectory)) <> 0 Then genie.ID3v2SavePictureWithType App.Path & "\Datenbank\Covers\" + cinter + " - " + calbum + "_Inside.jpg", 5
            genie.ID3v2Artist = frmMain.interprettag.Caption 'Interprettag setzen
            genie.ID3v2Album = frmMain.Albumtag.Caption 'Album setzen
            genie.ID3v2Title = frmMain.titeltag.Caption ' titel setzen
            genie.ID3v2Year = frmMain.yeartag.Caption 'Jahr setzen
            genie.ID3v2Genre = frmMain.genretag.Caption 'Genre setzen
            genie.ID3v2Comment 1, "Deu", vbNullString, frmMain.Labeltag.Caption 'Label setzen
            genie.SaveID3v2ToFile (tagfile) 'wird sepeichert
        End If
        
        If extension = "ogg" Then
            genie.OggArtist = frmMain.interprettag.Caption 'Interprettag setzen
            genie.OggTitle = frmMain.titeltag.Caption ' titel setzen
            genie.OggAlbum = frmMain.Albumtag.Caption 'Album setzen
            genie.OggDate = frmMain.yeartag.Caption 'Jahr setzen
            genie.OggGenre = frmMain.genretag.Caption 'Genre setzen
            genie.OggComment = frmMain.Labeltag.Caption 'Label setzen
            genie.SaveOggtoFile tagfile 'wird sepeichert
        End If
    End If
    
    Set genie = Nothing
    
    'Interprettag nach "," abschneiden
    If sort.komma.Value = "1" And InStr(frmMain.interprettag.Caption, ",") <> 0 Then frmMain.interprettag.Caption = Mid$(frmMain.interprettag.Caption, 1, InStr(frmMain.interprettag.Caption, ",") - 1)
            
    'Artikel abschneiden
    If sort.artikel.Value = "1" Then If Mid$(frmMain.interprettag.Caption, 1, 4) = "The " Or Mid$(frmMain.interprettag.Caption, 1, 4) = "Die " Or Mid$(frmMain.interprettag.Caption, 1, 4) = "Das " Or Mid$(frmMain.interprettag.Caption, 1, 4) = "Der " Then frmMain.interprettag.Caption = Mid$(frmMain.interprettag.Caption, 5, Len(frmMain.interprettag.Caption) - 4)
                        
    'Sortierung wird ausgeführt
    If Aktivierauswahl.sort_aktiv.Value = "1" Then
        temppfad = Sortierung.sortier(ByVal cinter, ByVal ctitel, ByVal calbum, ByVal frmMain.yeartag.Caption, ByVal cgenre)
    Else
        temppfad = frmMain.Ziel.Text
    End If
    
    Excel_Statistik.AddData
    
    tagsetzen = temppfad + cinter + " - " + ctitel + "." + extension
End Function
Public Function NewlineString(ByRef Text As String, Optional ByRef Default As String = vbNewLine) As String
    Dim NL As Variant
    
    'Von Komplex nach Simpel prüfen:
    For Each NL In Array(vbCrLf, vbLf & vbCr, vbCr & vbCr, vbLf, vbCr)
        If InStr(Text, NL) Then
            NewlineString = NL
            Exit Function
        End If
    Next NL

    'Kein Treffer, also Default zurückgeben:
    NewlineString = Default
End Function
