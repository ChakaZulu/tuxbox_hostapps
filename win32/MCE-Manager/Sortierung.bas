Attribute VB_Name = "Sortierung"
Option Explicit
Public Function sortier(ByVal Interpret As String, ByVal titel As String, ByVal album As String, ByVal year As String, ByVal genreinfo As String) As String
'Sortierung wird durchgeführt
    Dim temppath As String
            
    temppath = frmMain.Ziel.Text
            
    'Verzeichnis-Sonder-Filter ("..." Problem)
    While Left$(Interpret, 1) = "."
        Interpret = Mid$(Interpret, 2)
        Interpret = Trim$(Interpret)
    Wend
            
    While Right$(Interpret, 1) = "."
        Interpret = Mid$(Interpret, 1, Len(Interpret) - 1)
        Interpret = Trim$(Interpret)
    Wend
            
    While Left$(titel, 1) = "."
        titel = Mid$(titel, 2)
        titel = Trim$(titel)
    Wend
            
    While Right$(titel, 1) = "."
        titel = Mid$(titel, 1, Len(titel) - 1)
        titel = Trim$(titel)
    Wend
            
    While Left$(genreinfo, 1) = "."
        genreinfo = Mid$(genreinfo, 2)
        genreinfo = Trim$(genreinfo)
    Wend
            
    While Right$(genreinfo, 1) = "."
        genreinfo = Mid$(genreinfo, 1, Len(genreinfo) - 1)
        genreinfo = Trim$(genreinfo)
    Wend
            
    While Left$(album, 1) = "."
        album = Mid$(album, 2)
        album = Trim$(album)
    Wend
            
    While Right$(album, 1) = "."
        album = Mid$(album, 1, Len(album) - 1)
        album = Trim$(album)
    Wend
    
    album = Trim$(album)
    titel = Trim$(titel)
    Interpret = Trim$(Interpret)
    genreinfo = Trim$(genreinfo)
            
    '1.Verzeichnis wird erstellt
    Select Case sort.v1.ListIndex
        Case Is = 1
            If Interpret = vbNullString Then Interpret = "No Info"
            If LenB(Dir$(temppath + Interpret + "\", vbDirectory)) = 0 Then MkDir (temppath + Interpret) 'wenn dir nicht vorhanden dann erstellen
            temppath = temppath + Interpret + "\"
        Case Is = 2
            If titel = vbNullString Then titel = "No Info"
            If LenB(Dir$(temppath + titel + "\", vbDirectory)) = 0 Then MkDir (temppath + titel) 'wenn dir nicht vorhanden dann erstellen
            temppath = temppath + titel + "\"
        Case Is = 3
            If album = vbNullString Then album = "No Info"
            If LenB(Dir$(temppath + album + "\", vbDirectory)) = 0 Then MkDir (temppath + album) 'wenn dir nicht vorhanden dann erstellen
            temppath = temppath + album + "\"
        Case Is = 4
            If year = vbNullString Then year = "No Info"
            If LenB(Dir$(temppath + year + "\", vbDirectory)) = 0 Then MkDir (temppath + year) 'wenn dir nicht vorhanden dann erstellen
            temppath = temppath + year + "\"
        Case Is = 5
            If genreinfo = vbNullString Then genreinfo = "No Info"
            If LenB(Dir$(temppath + genreinfo + "\", vbDirectory)) = 0 Then MkDir (temppath + genreinfo) 'wenn dir nicht vorhanden dann erstellen
            temppath = temppath + genreinfo + "\"
    End Select
  
    '2.Verzeihnis wird erstellt
    Select Case sort.V2.ListIndex
        Case Is = 1
            If Interpret = vbNullString Then Interpret = "No Info"
            If LenB(Dir$(temppath + Interpret + "\", vbDirectory)) = 0 Then MkDir (temppath + Interpret)  'wenn dir nicht vorhanden dann erstellen
            temppath = temppath + Interpret + "\"
        Case Is = 2
            If titel = vbNullString Then titel = "No Info"
            If LenB(Dir$(temppath + titel + "\", vbDirectory)) = 0 Then MkDir (temppath + titel) 'wenn dir nicht vorhanden dann erstellen
            temppath = temppath + titel + "\"
        Case Is = 3
            If album = vbNullString Then album = "No Info"
            If LenB(Dir$(temppath + album + "\", vbDirectory)) = 0 Then MkDir (temppath + album) 'wenn dir nicht vorhanden dann erstellen
            temppath = temppath + album + "\"
        Case Is = 4
            If year = vbNullString Then year = "No Info"
            If LenB(Dir$(temppath + year + "\", vbDirectory)) = 0 Then MkDir (temppath + year) 'wenn dir nicht vorhanden dann erstellen
            temppath = temppath + year + "\"
        Case Is = 5
            If genreinfo = vbNullString Then genreinfo = "No Info"
            If LenB(Dir$(temppath + genreinfo + "\", vbDirectory)) = 0 Then MkDir (temppath + genreinfo) 'wenn dir nicht vorhanden dann erstellen
            temppath = temppath + genreinfo + "\"
    End Select
    
    '3.Verzeichnis wird erstellt
    Select Case sort.V3.ListIndex
        Case Is = 1
            If Interpret = vbNullString Then Interpret = "No Info"
            If LenB(Dir$(temppath + Interpret + "\", vbDirectory)) = 0 Then MkDir (temppath + Interpret)  'wenn dir nicht vorhanden dann erstellen
            temppath = temppath + Interpret + "\"
        Case Is = 2
            If titel = vbNullString Then titel = "No Info"
            If LenB(Dir$(temppath + titel + "\", vbDirectory)) = 0 Then MkDir (temppath + titel) 'wenn dir nicht vorhanden dann erstellen
            temppath = temppath + titel + "\"
        Case Is = 3
            If album = vbNullString Then album = "No Info"
            If LenB(Dir$(temppath + album + "\", vbDirectory)) = 0 Then MkDir (temppath + album) 'wenn dir nicht vorhanden dann erstellen
            temppath = temppath + album + "\"
        Case Is = 4
            If year = vbNullString Then year = "No Info"
            If LenB(Dir$(temppath + year + "\", vbDirectory)) = 0 Then MkDir (temppath + year) 'wenn dir nicht vorhanden dann erstellen
            temppath = temppath + year + "\"
        Case Is = 5
            If genreinfo = vbNullString Then genreinfo = "No Info"
            If LenB(Dir$(temppath + genreinfo + "\", vbDirectory)) = 0 Then MkDir (temppath + genreinfo) 'wenn dir nicht vorhanden dann erstellen
            temppath = temppath + genreinfo + "\"
    End Select
    
    '4.Verzeichnis wird erstellt
    Select Case sort.V4.ListIndex
        Case Is = 1
            If Interpret = vbNullString Then Interpret = "No Info"
            If LenB(Dir$(temppath + Interpret + "\", vbDirectory)) = 0 Then MkDir (temppath + Interpret)  'wenn dir nicht vorhanden dann erstellen
            temppath = temppath + Interpret + "\"
        Case Is = 2
            If titel = vbNullString Then titel = "No Info"
            If LenB(Dir$(temppath + titel + "\", vbDirectory)) = 0 Then MkDir (temppath + titel) 'wenn dir nicht vorhanden dann erstellen
            temppath = temppath + titel + "\"
        Case Is = 3
            If album = vbNullString Then album = "No Info"
            If LenB(Dir$(temppath + album + "\", vbDirectory)) = 0 Then MkDir (temppath + album) 'wenn dir nicht vorhanden dann erstellen
            temppath = temppath + album + "\"
        Case Is = 4
            If year = vbNullString Then year = "No Info"
            If LenB(Dir$(temppath + year + "\", vbDirectory)) = 0 Then MkDir (temppath + year) 'wenn dir nicht vorhanden dann erstellen
            temppath = temppath + year + "\"
        Case Is = 5
            If genreinfo = vbNullString Then genreinfo = "No Info"
            If LenB(Dir$(temppath + genreinfo + "\", vbDirectory)) = 0 Then MkDir (temppath + genreinfo) 'wenn dir nicht vorhanden dann erstellen
            temppath = temppath + genreinfo + "\"
    End Select
            
    sortier = temppath
End Function
