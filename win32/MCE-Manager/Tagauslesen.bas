Attribute VB_Name = "TagID_auslesen"
Option Explicit
Private songt As New songtextdl
Private cover_dl As New Cover
Public Function Tagauslesen(tagfile As String, ByRef filetagged As Boolean) As String
    Dim year As String, titel As String, Interpret As String, album As String, i As Integer, genreinfo As String, trennzei As String, label As String, Songtext As String, genie As Object, F As Integer, pos As Long
    
    filetagged = "0"
    Set genie = frmMain.AudioGenie
    genie.ReadOggFromFile (tagfile) 'Wenn vorhanden OGG auslesen
    
    If genie.OggIsValid Then    'Wenn vorhanden ID3v2 auslesen
        Interpret = Trim$(genie.OggArtist) 'Interpret auslesen
        album = Trim$(genie.OggAlbum) 'Album auslesen
        titel = Trim$(genie.OggTitle) 'Titel auslesen
        year = Trim$(genie.OggDate) 'Jahr auslesen
        genreinfo = genie.OggGenre 'Genre auslesen
        GoTo erkannt
    End If
    
    genie.ReadID3v2FromFile (tagfile) 'Lese TAGID Infos aus file
        
    If genie.ExistsID3v2 Then 'Wenn vorhanden ID3v2 auslesen
        Interpret = Trim$(genie.ID3v2Artist) 'Interpret auslesen
        album = Trim$(genie.ID3v2Album) 'Album auslesen
        titel = Trim$(genie.ID3v2Title) 'Titel auslesen
        year = Trim$(genie.ID3v2Year) 'Jahr auslesen
        genreinfo = genie.ID3v2Genre 'Genre auslesen
        Call Werkzeuge.filter(Interpret, titel, album, genreinfo)
        If LenB(Dir$(App.Path & "\Datenbank\Covers\" + Interpret + " - " + album + "_Front." + "jpg", vbDirectory)) = 0 Then genie.ID3v2LoadPictureWithType App.Path & "\Datenbank\Covers\" + Interpret + " - " + album + "_Front.jpg", 3
        If LenB(Dir$(App.Path & "\Datenbank\Covers\" + Interpret + " - " + album + "_Back." + "jpg", vbDirectory)) = 0 Then genie.ID3v2LoadPictureWithType App.Path & "\Datenbank\Covers\" + Interpret + " - " + album + "_Back.jpg", 4
        If LenB(Dir$(App.Path & "\Datenbank\Covers\" + Interpret + " - " + album + "_Cd." + "jpg", vbDirectory)) = 0 Then genie.ID3v2LoadPictureWithType App.Path & "\Datenbank\Covers\" + Interpret + " - " + album + "_Cd.jpg", 0
        If LenB(Dir$(App.Path & "\Datenbank\Covers\" + Interpret + " - " + album + "_Inside." + "jpg", vbDirectory)) = 0 Then genie.ID3v2LoadPictureWithType App.Path & "\Datenbank\Covers\" + Interpret + " - " + album + "_Inside.jpg", 5
        Songtext = frmMain.AudioGenie.ID3v2LyricText(1)
        If Songtext = vbNullString Then Songtext = Songtext_dl.songtextdl(Interpret, titel, Interpret)
        
        If LenB(Dir$(App.Path & "\Datenbank\Lyrics\" + Interpret + " - " + titel + ".txt", vbDirectory)) = 0 And Songtext <> vbNullString Then
            F = FreeFile
            
            Open App.Path & "\Datenbank\Lyrics\" + Interpret + " - " + titel + ".txt" For Binary As #F
                Put #F, , Songtext
            Close F
        End If
        
        'Coverdownload
        If LenB(Dir$(App.Path & "\Datenbank\Covers\" + Interpret + " - " + album + "_Front." + "jpg", vbDirectory)) = 0 And allgemeine.coverdownload.Value = "1" Then
            Set cover_dl = New Cover
            If InStr(1, album, "single", vbTextCompare) = 0 And InStr(1, album, "venyl", vbTextCompare) = 0 And extension <> "ogg" Then Call cover_dl.cover_download(Interpret, album, tagging.korrsymbol.Text, Sondercheck)
            Set cover_dl = Nothing
        End If
        
        If LenB(Dir$(App.Path & "\Datenbank\Covers\" + Interpret + " - " + album + "_Front." + "jpg", vbDirectory)) <> 0 Then genie.ID3v2SavePictureWithType App.Path & "\Datenbank\Covers\" + Interpret + " - " + album + "_Front.jpg", 3
        If LenB(Dir$(App.Path & "\Datenbank\Covers\" + Interpret + " - " + album + "_Back." + "jpg", vbDirectory)) <> 0 Then genie.ID3v2SavePictureWithType App.Path & "\Datenbank\Covers\" + Interpret + " - " + album + "_Back.jpg", 4
        If LenB(Dir$(App.Path & "\Datenbank\Covers\" + Interpret + " - " + album + "_Cd." + "jpg", vbDirectory)) <> 0 Then genie.ID3v2SavePictureWithType App.Path & "\Datenbank\Covers\" + Interpret + " - " + album + "_Cd.jpg", 0
        If LenB(Dir$(App.Path & "\Datenbank\Covers\" + Interpret + " - " + album + "_Inside." + "jpg", vbDirectory)) <> 0 Then genie.ID3v2SavePictureWithType App.Path & "\Datenbank\Covers\" + Interpret + " - " + album + "_Inside.jpg", 5
        If Songtext <> vbNullString Then genie.ID3v2Lyric 1, "Deu", vbNullString, Songtext
        genie.SaveID3v2ToFile (tagfile) 'wird sepeichert
        GoTo erkannt
    End If
    
    genie.ReadID3v1FromFile (tagfile) 'Wenn vorhanden ID3v1 auslesen
    
    If genie.ExistsID3v1 Then
        Interpret = Trim$(genie.ID3v1Artist) 'Interpret auslesen
        album = Trim$(genie.ID3v1Album) 'Album auslesen
        titel = Trim$(genie.ID3v1Title) 'Titel auslesen
        year = Trim$(genie.ID3v1Year) 'Jahr auslesen
        genreinfo = genie.ID3v1GenreID 'Genre auslesen
        If genreinfo <> vbNullString Then genreinfo = id3v1_genre(genreinfo)
        label = genie.ID3v1Comment
        Call Werkzeuge.filter(Interpret, titel, album, genreinfo)
        Songtext = Songtext_dl.songtextdl(Interpret, titel, Interpret)
        
        If LenB(Dir$(App.Path & "\Datenbank\Lyrics\" + Interpret + " - " + titel + ".txt", vbDirectory)) = 0 And Songtext <> vbNullString Then
            F = FreeFile
            
            Open App.Path & "\Datenbank\Lyrics\" + Interpret + " - " + titel + ".txt" For Binary As #F
                Put #F, , Songtext
            Close F
        End If
        
        'Coverdownload
        If LenB(Dir$(App.Path & "\Datenbank\Covers\" + Interpret + " - " + album + "_Front." + "jpg", vbDirectory)) = 0 And allgemeine.coverdownload.Value = "1" Then
            Set cover_dl = New Cover
            If InStr(1, album, "single", vbTextCompare) = 0 And InStr(1, album, "venyl", vbTextCompare) = 0 And extension <> "ogg" Then Call cover_dl.cover_download(Interpret, album, tagging.korrsymbol.Text, Sondercheck)
            Set cover_dl = Nothing
        End If
        
        If LenB(Dir$(App.Path & "\Datenbank\Covers\" + Interpret + " - " + album + "_Front." + "jpg", vbDirectory)) <> 0 Then genie.ID3v2SavePictureWithType App.Path & "\Datenbank\Covers\" + Interpret + " - " + album + "_Front.jpg", 3
        If LenB(Dir$(App.Path & "\Datenbank\Covers\" + Interpret + " - " + album + "_Back." + "jpg", vbDirectory)) <> 0 Then genie.ID3v2SavePictureWithType App.Path & "\Datenbank\Covers\" + Interpret + " - " + album + "_Back.jpg", 4
        If LenB(Dir$(App.Path & "\Datenbank\Covers\" + Interpret + " - " + album + "_Cd." + "jpg", vbDirectory)) <> 0 Then genie.ID3v2SavePictureWithType App.Path & "\Datenbank\Covers\" + Interpret + " - " + album + "_Cd.jpg", 0
        If LenB(Dir$(App.Path & "\Datenbank\Covers\" + Interpret + " - " + album + "_Inside." + "jpg", vbDirectory)) <> 0 Then genie.ID3v2SavePictureWithType App.Path & "\Datenbank\Covers\" + Interpret + " - " + album + "_Inside.jpg", 5
        If Songtext <> vbNullString Then genie.ID3v2Lyric 1, "Deu", vbNullString, Songtext
        
        'Umwandeln von ID3V1 auf ID3V2
        genie.ID3v2Artist = Interpret 'Interprettag setzen
        genie.ID3v2Album = album 'Album setzen
        genie.ID3v2Title = titel ' titel setzen
        genie.ID3v2Year = year 'Jahr setzen
        genie.ID3v2Genre = genreinfo 'Genre setzen
        genie.ID3v2Comment 1, "Deu", vbNullString, label
        genie.SaveID3v2ToFile (tagfile) 'wird sepeichert
        GoTo erkannt
    End If
erkannt:
    Set genie = Nothing
    
    If Interpret <> vbNullString Then
        filetagged = "1"

        'Sortierung wird durchgeführt
        Tagauslesen = Sortierung.sortier(ByVal Interpret, ByVal titel, ByVal album, ByVal year, ByVal genreinfo)
    End If
End Function

