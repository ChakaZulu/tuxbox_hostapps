Attribute VB_Name = "Werkzeuge"
Option Explicit
Option Compare Text
Type IP_OPTION_INFORMATION
    TTL As Byte
    Tos As Byte
    flags As Byte
    OptionsSize As Long
    OptionsData As String * 128
End Type

Type IP_ECHO_REPLY
    Address(0 To 3) As Byte
    Status As Long
    RoundTripTime As Long
    DataSize As Integer
    Reserved As Integer
    data As Long
    Options As IP_OPTION_INFORMATION
End Type

Type FILETIME
     dwLowDateTime As Long
     dwHighDateTime As Long
End Type

Type WIN32_FIND_DATA
     dwFileAttributes As Long
     ftCreationTime As FILETIME
     ftLastAccessTime As FILETIME
     ftLastWriteTime As FILETIME
     nFileSizeHigh As Long
     nFileSizeLow As Long
     dwReserved0 As Long
     dwReserved1 As Long
     cFileName As String * 259
     cAlternate As String * 14
End Type

Type SystemTime
     wYear      As Integer
     wMonth     As Integer
     wDayOfWeek As Integer
     wDay       As Integer
     wHour      As Integer
     wMinute    As Integer
     wSecond    As Integer
     wMillisecs As Integer
End Type

Private Declare Function DrawMenuBar Lib "user32" (ByVal hWnd As Long) As Long
Private Declare Function FindFirstFile Lib "kernel32" Alias "FindFirstFileA" (ByVal lpFileName As String, lpFindFileData As WIN32_FIND_DATA) As Long
Private Declare Function FindNextFile Lib "kernel32" Alias "FindNextFileA" (ByVal hFindFile As Long, lpFindFileData As WIN32_FIND_DATA) As Long
Private Declare Function FindClose Lib "kernel32" (ByVal hFindFile As Long) As Long
Private Declare Function CloseHandle Lib "kernel32" (ByVal hObject As Long) As Long
Private Declare Function CreateFile Lib "kernel32" Alias "CreateFileA" (ByVal lpFileName As String, ByVal dwDesiredAccess As Long, ByVal dwShareMode As Long, ByVal lpSecurityAttributes As Long, ByVal dwCreationDisposition As Long, ByVal dwFlagsAndAttributes As Long, ByVal hTemplateFile As Long) As Long
Private Declare Function LocalFileTimeToFileTime Lib "kernel32" (lpLocalFileTime As FILETIME, lpFileTime As FILETIME) As Long
Private Declare Function SetFileTime Lib "kernel32" (ByVal hFile As Long, ByVal MullP As Long, ByVal NullP2 As Long, lpLastWriteTime As FILETIME) As Long
Private Declare Function SystemTimeToFileTime Lib "kernel32" (lpSystemTime As SystemTime, lpFileTime As FILETIME) As Long
Private Declare Function inet_addr Lib "wsock32.dll" (ByVal cp As String) As Long
Private Declare Function GetSystemMenu Lib "user32" (ByVal hWnd As Long, ByVal bRevert As Long) As Long
Private Declare Function RemoveMenu Lib "user32" (ByVal hMenu As Long, ByVal nPosition As Long, ByVal wFlags As Long) As Long
Private Declare Function IcmpCreateFile Lib "icmp.dll" () As Long
Private Declare Function IcmpSendEcho Lib "ICMP" (ByVal IcmpHandle As Long, ByVal DestAddress As Long, ByVal RequestData As String, ByVal RequestSize As Integer, RequestOptns As IP_OPTION_INFORMATION, ReplyBuffer As IP_ECHO_REPLY, ByVal ReplySize As Long, ByVal timeout As Long) As Boolean
Public Function id3v1_genre(genrenr As String) As String 'ID3v1-Genre wird zum Klartext zugeordnet
    Select Case genrenr
        Case Is = "0"
            id3v1_genre = "Blues"
        Case Is = "1"
            id3v1_genre = "Classic Rock"
        Case Is = "2"
            id3v1_genre = "Country"
        Case Is = "3"
            id3v1_genre = "Dance"
        Case Is = "4"
            id3v1_genre = "Disco"
        Case Is = "5"
            id3v1_genre = "Funk"
        Case Is = "6"
            id3v1_genre = "Grunge"
        Case Is = "7"
            id3v1_genre = "HipHop"
        Case Is = "8"
            id3v1_genre = "Jazz"
        Case Is = "9"
            id3v1_genre = "Meta"
        Case Is = "10"
            id3v1_genre = "NewAge"
        Case Is = "11"
            id3v1_genre = "Oldies"
        Case Is = "12"
            id3v1_genre = "Other"
        Case Is = "13"
            id3v1_genre = "Pop"
        Case Is = "14"
            id3v1_genre = "R_B"
        Case Is = "15"
            id3v1_genre = "Rap"
        Case Is = "16"
            id3v1_genre = "Reggae"
        Case Is = "17"
            id3v1_genre = "Rock"
        Case Is = "18"
            id3v1_genre = "Techno"
        Case Is = "19"
            id3v1_genre = "Industrial"
        Case Is = "20"
            id3v1_genre = "Alternative"
        Case Is = "21"
            id3v1_genre = "Ska"
        Case Is = "22"
            id3v1_genre = "DeathMetal"
        Case Is = "23"
            id3v1_genre = "Pranks"
        Case Is = "24"
            id3v1_genre = "Soundtrack"
        Case Is = "25"
            id3v1_genre = "EuroTechno"
        Case Is = "26"
            id3v1_genre = "Ambient"
        Case Is = "27"
            id3v1_genre = "TripHop"
        Case Is = "28"
            id3v1_genre = "Vocal"
        Case Is = "29"
            id3v1_genre = "JazzFunk"
        Case Is = "30"
            id3v1_genre = "Fusion"
        Case Is = "31"
            id3v1_genre = "Trance"
        Case Is = "32"
            id3v1_genre = "Classical"
        Case Is = "33"
            id3v1_genre = "Instrumental"
        Case Is = "34"
            id3v1_genre = "Acid"
        Case Is = "35"
            id3v1_genre = "House"
        Case Is = "36"
            id3v1_genre = "Game"
        Case Is = "37"
            id3v1_genre = "SoundClip"
        Case Is = "38"
            id3v1_genre = "Gospel"
        Case Is = "39"
            id3v1_genre = "Noise"
        Case Is = "40"
            id3v1_genre = "AltRock"
        Case Is = "41"
            id3v1_genre = "Bas"
        Case Is = "42"
            id3v1_genre = "Soul"
        Case Is = "43"
            id3v1_genre = "Punk"
        Case Is = "44"
            id3v1_genre = "Space"
        Case Is = "45"
            id3v1_genre = "Meditative"
        Case Is = "46"
            id3v1_genre = "InstrumentalPop"
        Case Is = "47"
            id3v1_genre = "InstrumentalRock"
        Case Is = "48"
            id3v1_genre = "Ethnic"
        Case Is = "49"
            id3v1_genre = "Gothic"
        Case Is = "50"
            id3v1_genre = "Darkwave"
        Case Is = "51"
            id3v1_genre = "TechnoIndustrial"
        Case Is = "52"
            id3v1_genre = "Electronic"
        Case Is = "53"
            id3v1_genre = "PopFolk"
        Case Is = "54"
            id3v1_genre = "Eurodance"
        Case Is = "55"
            id3v1_genre = "Dream"
        Case Is = "56"
            id3v1_genre = "SouthernRock"
        Case Is = "57"
            id3v1_genre = "Comedy"
        Case Is = "58"
            id3v1_genre = "Cult"
        Case Is = "59"
            id3v1_genre = "Gangsta"
        Case Is = "60"
            id3v1_genre = "Top40"
        Case Is = "61"
            id3v1_genre = "ChristianRap"
        Case Is = "62"
            id3v1_genre = "Pop_Funk"
        Case Is = "63"
            id3v1_genre = "Jungle"
        Case Is = "64"
            id3v1_genre = "NativeAmerican"
        Case Is = "65"
            id3v1_genre = "Cabaret"
        Case Is = "66"
            id3v1_genre = "NewWave"
        Case Is = "67"
            id3v1_genre = "Psychadelic"
        Case Is = "68"
            id3v1_genre = "Rave"
        Case Is = "69"
            id3v1_genre = "Showtunes"
        Case Is = "70"
            id3v1_genre = "Trailer"
        Case Is = "71"
            id3v1_genre = "LoFi"
        Case Is = "72"
            id3v1_genre = "Tribal"
        Case Is = "73"
            id3v1_genre = "AcidPunk"
        Case Is = "74"
            id3v1_genre = "AcidJazz"
        Case Is = "75"
            id3v1_genre = "Polka"
        Case Is = "76"
            id3v1_genre = "Retro"
        Case Is = "77"
            id3v1_genre = "Musical"
        Case Is = "78"
            id3v1_genre = "RockNRoll"
        Case Is = "79"
            id3v1_genre = "HardRock"
        Case Is = "80"
            id3v1_genre = "Folk"
        Case Is = "81"
            id3v1_genre = "Folk_Rock"
        Case Is = "82"
            id3v1_genre = "NationalFolk"
        Case Is = "83"
            id3v1_genre = "Swing"
        Case Is = "84"
            id3v1_genre = "Fusion1"
        Case Is = "85"
            id3v1_genre = "Bebob"
        Case Is = "86"
            id3v1_genre = "Latin"
        Case Is = "87"
            id3v1_genre = "Revival"
        Case Is = "88"
            id3v1_genre = "Celtic"
        Case Is = "89"
            id3v1_genre = "Bluegrass"
        Case Is = "90"
            id3v1_genre = "Avantgarde"
        Case Is = "91"
            id3v1_genre = "GothicRock"
        Case Is = "92"
            id3v1_genre = "ProgressiveRock"
        Case Is = "93"
            id3v1_genre = "PsychedelicRock"
        Case Is = "94"
            id3v1_genre = "SymphonicRock"
        Case Is = "95"
            id3v1_genre = "SlowRock"
        Case Is = "96"
            id3v1_genre = "BigBand"
        Case Is = "97"
            id3v1_genre = "Chorus"
        Case Is = "98"
            id3v1_genre = "EasyListening"
        Case Is = "99"
            id3v1_genre = "Acoustic"
        Case Is = "100"
            id3v1_genre = "Humour"
        Case Is = "101"
            id3v1_genre = "Speech"
        Case Is = "102"
            id3v1_genre = "Chanson"
        Case Is = "103"
            id3v1_genre = "Opera"
        Case Is = "104"
            id3v1_genre = "ChamberMusic"
        Case Is = "105"
            id3v1_genre = "Sonata"
        Case Is = "106"
            id3v1_genre = "Symphony"
        Case Is = "107"
            id3v1_genre = "BootyBass"
        Case Is = "108"
            id3v1_genre = "Primus"
        Case Is = "109"
            id3v1_genre = "PornGroove"
        Case Is = "110"
            id3v1_genre = "Satire"
        Case Is = "111"
            id3v1_genre = "SlowJam"
        Case Is = "112"
            id3v1_genre = "Club"
        Case Is = "113"
            id3v1_genre = "Tango"
        Case Is = "114"
            id3v1_genre = "Samba"
        Case Is = "115"
            id3v1_genre = "Folklore"
    End Select
End Function
Public Sub scantimer()
    Dim Ausgabe As Date
    
    If Aktivierauswahl.scan_aktiv.Value = "0" Then
        frmMain.Label23.Caption = deaktlng
        frmMain.Timer1.Enabled = "0"
        Exit Sub
    End If
    
    timeSeconds = timeSeconds + 1
    
    If timeSeconds >= 60 Then
        timeSeconds = 0
        timeMinutes = timeMinutes + 1
    End If

    If timeMinutes >= 60 Then
        timeMinutes = 0
        timehours = timehours + 1
    End If

    If timehours >= 24 Then
        timehours = 0
        timedays = timedays + 1
    End If

    If timedays >= 30 Then timedays = 0

    If Scannen.sec_wahl.Value = "1" Then
        Ausgabe = "00:00:" + Str$(Scannen.Slider_takt.CurPosition - timeSeconds)
        frmMain.tage.Caption = vbNullString
    End If

    If Scannen.min_wahl.Value = "1" Then
        Ausgabe = "00:" + Str$(Scannen.Slider_takt.CurPosition - 1 - timeMinutes) + ":" + Str$(59 - timeSeconds)
        frmMain.tage.Caption = vbNullString
    End If

    If Scannen.hour_wahl.Value = "1" Then
        Ausgabe = Str$(Scannen.Slider_takt.CurPosition - 1 - timehours) + ":" + Str$(59 - timeMinutes) + ":" + Str$(59 - timeSeconds)
        frmMain.tage.Caption = vbNullString
    End If

    If Scannen.day_wahl.Value = "1" Then
        Ausgabe = Str$(23 - timehours) + ":" + Str$(59 - timeMinutes) + ":" + Str$(59 - timeSeconds)
        frmMain.tage.Caption = Str$(Scannen.Slider_takt.CurPosition - 1 - timedays) + " Tage"
    End If
    
    frmMain.countdo.Caption = Ausgabe
    
    If frmMain.countdo.Caption = "00:00:00" And timedays = 0 Then
        Call frmMain.Start_Click
        timeSeconds = 0
        timeMinutes = 0
        timehours = 0
        timedays = 0
    End If
End Sub
Public Sub DownLoad(sender As String, datum As Date, playlistname As String)
    If Werkzeuge.plvergleich(sender, "online") Then
        If datum = Date Then
            Call Werkzeuge.DownloadFile("http://217.110.1.50/Playlisten/Heute/" + sender + ".Wri", playlistname)
        Else
            Call Werkzeuge.DownloadFile("http://217.110.1.50/Playlisten/" + sender + "/" + Right$(datum, 4) + "/" + Mid$(datum, 4, 2) + "/" + Right$(datum, 4) + "-" + Mid$(datum, 4, 2) + "-" + Left$(datum, 2) + "-" + sender + ".Wri", playlistname)
        End If
    End If
End Sub
Public Sub DownloadFile(URL As String, savepfad As String)
    frmMain.DownL.URL = URL
    frmMain.DownL.SaveLocation = savepfad
    frmMain.DownL.GetFileInformation
    If frmMain.DownL.timeo = "1" Then Exit Sub
    If frmMain.DownL.filesize <= 0 Then Exit Sub
    frmMain.DownL.DownLoad
End Sub
Public Function GetMP3Length(ByVal strFileName As String) As Date
    Dim iMin As Integer, iSec As Integer, istd As Integer, genie As Object
    
    Set genie = frmMain.AudioGenie
    
    If Right$(strFileName, 3) = "mp3" Or Right$(strFileName, 3) = "mp2" Then
        genie.ReadMPEGFromFile (strFileName)
        iSec = genie.GetMPEGDuration
    End If
    
    If Right$(strFileName, 3) = "ogg" Then
        genie.ReadOggFromFile (strFileName)
        iSec = genie.GetOggDuration  'Songdauer
    End If
    
    Set genie = Nothing
    iMin = Int(iSec / 60)
    iSec = iSec - (iMin * 60)
    istd = iMin / 60
    If iMin > 60 Then iMin = iMin - 60
    GetMP3Length = Format(istd, "00") & ":" & Format(iMin, "00") & ":" & Format(iSec, "00")
End Function
Public Sub suche(suchparameter As String, suchpfad As String, ByRef files() As String, Optional subsearch As Boolean) 'Dateisuche
    ReDim files(1 To 1)
    Call GetAllFiles(suchpfad, suchparameter, files, subsearch)
End Sub
Public Sub GetAllFiles(ByVal Root As String, ByVal such As String, ByRef Field() As String, Optional subsearch As Boolean) 'Dateisuche
    Dim file As String, hFile As String, FD As WIN32_FIND_DATA

    If Right$(Root, 1) <> "\" Then Root = Root + "\"
    hFile = FindFirstFile(Root + "*.*", FD)
    
    If hFile = 0 Then
        FindClose hFile
        Exit Sub
    End If
    
    Do
        If frmMain.turbo.Value = "0" Then DoEvents
        file = Left$(FD.cFileName, InStr(FD.cFileName, Chr(0)) - 1)
        
        If (FD.dwFileAttributes And &H10) = &H10 Then
            If (file <> ".") And (file <> "..") And subsearch = "1" Then
                Call GetAllFiles(Root + file, such, Field, subsearch)
            End If
        Else
            If such = Right$(UCase(file), Len(such)) Or such = "*" Then
                Database.Songanzahl.Caption = UBound(Field)
                Field(UBound(Field)) = Root + file
                ReDim Preserve Field(1 To UBound(Field) + 1)
            End If
        End If
    Loop While FindNextFile(hFile, FD)
    
    FindClose hFile
End Sub
Public Function SetFileDateTime(ByVal filename As String, ByVal TheDate As String, ByVal TheTime As String) As Boolean 'Auslesen der des "Änderungs-Datum-Zeit" aus file
    Dim lFileHnd As Long, lret As Long, typFileTime As FILETIME, typLocalTime As FILETIME, typSystemTime As SystemTime

    With typSystemTime
        .wYear = Year(TheDate)
        .wMonth = Month(TheDate)
        .wDay = Day(TheDate)
        .wDayOfWeek = Weekday(TheDate) - 1
        .wHour = Hour(TheTime)
        .wMinute = Minute(TheTime)
        .wSecond = Second(TheTime)
    End With

    lret = SystemTimeToFileTime(typSystemTime, typLocalTime)
    lret = LocalFileTimeToFileTime(typLocalTime, typFileTime)
    lFileHnd = CreateFile(filename, &H40000000, &H1 Or &H2, ByVal 0&, 3, 0, 0)
    lret = SetFileTime(lFileHnd, ByVal 0&, ByVal 0&, typFileTime)
    Call CloseHandle(lFileHnd)
End Function
Public Sub Browser(URL As String)
    Dim IE As Object
    
    Set IE = CreateObject("INTERNETEXPLORER.Application")
    IE.Navigate (URL)
    IE.Visible = "1"
    Set IE = Nothing
End Sub
Public Function datab(file As String) As Integer
    Dim Interpretdb As String, Albumdb As String, titeldb As String, yeardb As String, genreinfodb As String, commentdb As String, F, dauerdb As String, Encodersettingsdb As String, MPEGChannelModedb As String, it As String, fso As Object, genie As Object
    Dim ccinter As String, ccalbum As String, ccgenre As String, cctitel As String, Songtext As String
    
    datab = "0"
    it = Mid$(file, InStrRev(file, "\") + 1)
    If data_songexists(it) Then Exit Function 'Wenn Datensatz exisitiert, ist Song schon vorhanden
    it = Left$(it, Len(it) - 4)
    If LenB(Dir$(file, vbDirectory)) = 0 Then Exit Function
    Set db = OpenDatabase(App.Path + "\Datenbank\Musik-Datenbank.mdb") 'Öffnet Datenbank
    Set RS = db.OpenRecordset("select * from tracks Order by " + DBdurchsuchen.Auswahl.Text) 'Tabelle auswählen
    
    RS.AddNew 'Neuer Datensatz (Recordset)
    datab = "1"
    RS!Dateiname = it
    Set genie = frmMain.AudioGenie
    genie.ReadOggFromFile (file) 'Wenn vorhanden OGG auslesen
    
    If genie.OggIsValid Then    'Wenn vorhanden ID3v2 auslesen
        Interpretdb = Trim$(genie.OggArtist) 'Interpret auslesen
        Albumdb = Trim$(genie.OggAlbum) 'Album auslesen
        titeldb = Trim$(genie.OggTitle) 'Titel auslesen
        yeardb = Trim$(genie.OggDate) 'Jahr auslesen
        genreinfodb = genie.OggGenre 'Genre auslesen
        commentdb = genie.OggComment 'Comment auslesen
        RS!Kanalmode = genie.GetOggChannelMode
        RS!bitrate = genie.GetOggBitRateNominal
        RS!samplerate = genie.GetOggSampleRate
        RS!Format = extension
        GoTo erkannt
    End If
    
    genie.ReadID3v2FromFile (file) 'Lese TAGID Infos aus file
        
    If genie.ExistsID3v2 Then 'Wenn vorhanden ID3v2 auslesen
        Interpretdb = Trim$(genie.ID3v2Artist) 'Interpret auslesen
        Albumdb = Trim$(genie.ID3v2Album) 'Album auslesen
        titeldb = Trim$(genie.ID3v2Title) 'Titel auslesen
        yeardb = Trim$(genie.ID3v2Year) 'Jahr auslesen
        genreinfodb = genie.ID3v2Genre 'Genre auslesen
        commentdb = genie.ID3v2CommentText(1) 'Comment auslesen
        dauerdb = genie.ID3v2Length 'Songdauer
        
        ccinter = Interpretdb
        ccalbum = Albumdb
        ccgenre = genreinfodb
        cctitel = titeldb
        Call Werkzeuge.filter(ccinter, cctitel, ccalbum, ccgenre)
        If LenB(Dir$(App.Path & "\Datenbank\Covers\" + ccinter + " - " + ccalbum + "_Front." + "jpg", vbDirectory)) = 0 Then genie.ID3v2LoadPictureWithType App.Path & "\Datenbank\Covers\" + ccinter + " - " + ccalbum + "_Front.jpg", 3
        If LenB(Dir$(App.Path & "\Datenbank\Covers\" + ccinter + " - " + ccalbum + "_Back." + "jpg", vbDirectory)) = 0 Then genie.ID3v2LoadPictureWithType App.Path & "\Datenbank\Covers\" + ccinter + " - " + ccalbum + "_Back.jpg", 4
        If LenB(Dir$(App.Path & "\Datenbank\Covers\" + ccinter + " - " + ccalbum + "_Cd." + "jpg", vbDirectory)) = 0 Then genie.ID3v2LoadPictureWithType App.Path & "\Datenbank\Covers\" + ccinter + " - " + ccalbum + "_Cd.jpg", 0
        If LenB(Dir$(App.Path & "\Datenbank\Covers\" + ccinter + " - " + ccalbum + "_Inside." + "jpg", vbDirectory)) = 0 Then genie.ID3v2LoadPictureWithType App.Path & "\Datenbank\Covers\" + ccinter + " - " + ccalbum + "_Inside.jpg", 5
        Songtext = genie.ID3v2LyricText(1)
        If Songtext = vbNullString Then Songtext = Songtext_dl.songtextdl(ccinter, cctitel, ccinter)
        
        If LenB(Dir$(App.Path & "\Datenbank\Lyrics\" + ccinter + " - " + cctitel + ".txt", vbDirectory)) = 0 And Songtext <> vbNullString Then
            F = FreeFile
            
            Open App.Path & "\Datenbank\Lyrics\" + ccinter + " - " + cctitel + ".txt" For Binary As #F
                Put #F, , Songtext
            Close F
        End If
        
        Encodersettingsdb = genie.ID3v2EncodeSettings
        RS!Songtext = genie.ID3v2LyricText(1)
        genie.ReadMPEGFromFile (file)
        RS!Kanalmode = genie.GetMPEGChannelMode
        RS!bitrate = genie.GetMPEGBitRate
        RS!Encoder = genie.GetMPEGEncoder
        RS!layer = genie.GetMPEGLayer
        RS!samplerate = genie.GetMPEGSampleRate
        RS!version = genie.GetMPEGVersion
        RS!Format = extension
        GoTo erkannt
    End If
    
    genie.ReadID3v1FromFile (file) 'Wenn vorhanden ID3v1 auslesen
    
    If genie.ExistsID3v1 Then
        Interpretdb = Trim$(genie.ID3v1Artist) 'Interpret auslesen
        Albumdb = Trim$(genie.ID3v1Album) 'Album auslesen
        titeldb = Trim$(genie.ID3v1Title) 'Titel auslesen
        yeardb = Trim$(genie.ID3v1Year) 'Jahr auslesen
        genreinfodb = genie.ID3v1GenreID 'Genre auslesen
        If genreinfodb <> vbNullString Then genreinfodb = id3v1_genre(genreinfodb)
        commentdb = genie.ID3v1Comment
        genie.ReadMPEGFromFile (file)
        RS!Kanalmode = genie.GetMPEGChannelMode
        RS!bitrate = genie.GetMPEGBitRate
        RS!Encoder = genie.GetMPEGEncoder
        RS!layer = genie.GetMPEGLayer
        RS!samplerate = genie.GetMPEGSampleRate
        RS!version = genie.GetMPEGVersion
        RS!Format = extension
        GoTo erkannt
    End If
    
erkannt:
    Set genie = Nothing

    If Interpretdb = vbNullString Then
        datab = "2"
        RS.Close
        Set RS = Nothing
        Set db = Nothing
        Exit Function 'Wenn
    End If
    
    If dauerdb = vbNullString Then
        RS!abspieldauer = Werkzeuge.GetMP3Length(file)
    Else
        RS!abspieldauer = dauerdb
    End If
    
    Set fso = CreateObject("Scripting.FileSystemObject")
    Set F = fso.GetFile(file)
    RS!aufnahmezeit = F.DateLastModified 'original date,time, wird  ausgelesen
    If LenB(Dir$(App.Path & "\Datenbank\Covers\" + ccinter + " - " + ccalbum + "_Front." + "jpg", vbDirectory)) <> 0 Then RS!FrontPicture = "Front#Covers/" + ccinter + " - " + ccalbum + "_Front.jpg#"
    If LenB(Dir$(App.Path & "\Datenbank\Covers\" + ccinter + " - " + ccalbum + "_Back." + "jpg", vbDirectory)) <> 0 Then RS!BackPicture = "Back#Covers/" + ccinter + " - " + ccalbum + "_Back.jpg#"
    If LenB(Dir$(App.Path & "\Datenbank\Covers\" + ccinter + " - " + ccalbum + "_Cd." + "jpg", vbDirectory)) <> 0 Then RS!CdPicture = "CD#Covers/" + ccinter + " - " + ccalbum + "_Cd.jpg#"
    If LenB(Dir$(App.Path & "\Datenbank\Covers\" + ccinter + " - " + ccalbum + "_Inside." + "jpg", vbDirectory)) <> 0 Then RS!InsidePicture = "Inside#Covers/" + ccinter + " - " + ccalbum + "_Inside.jpg#"
    If LenB(Dir$(App.Path & "\Datenbank\Lyrics\" + ccinter + " - " + cctitel + ".txt", vbDirectory)) <> 0 Then RS!Lyrics = "Songtext#Lyrics/" + ccinter + " - " + cctitel + ".txt#"
    If Encodersettingsdb <> vbNullString Then RS!Encodereigenschaften = Encodersettingsdb
    If Interpretdb <> vbNullString Then RS!Interpret = Interpretdb
    If Albumdb <> vbNullString Then RS!album = Albumdb
    If titeldb <> vbNullString Then RS!titel = titeldb
    If yeardb <> vbNullString Then RS!jahr = yeardb
    If genreinfodb <> vbNullString Then RS!Genre = genreinfodb
    If commentdb <> vbNullString Then RS!kommentar = commentdb
    RS!Dateigrösse = Format((FileLen(file) / 1024), "0.0") 'Filegrösse
    RS.Update
    Set F = Nothing
    Set fso = Nothing
    RS.Close
    Set RS = Nothing
    Set db = Nothing
End Function
Public Function data_songexists(file As String, Optional akttimedate As Date, Optional akttime As Date, Optional aktdate As Date) As Boolean
    Dim dbtime As Date, it As String
  
    If akttimedate = "00:00:00" Then akttime = "10:00:00"
    Set db = OpenDatabase(App.Path + "\Datenbank\Musik-Datenbank.mdb") 'Öffnet Datenbank
    Set RS = db.OpenRecordset("select * from tracks Order by " + DBdurchsuchen.Auswahl.Text) 'Tabelle auswählen
    it = Left$(file, Len(file) - 4)
    RS.FindFirst "[Dateiname] = """ + it + """" 'Suche nach Daten
    
    If Not RS.NoMatch Then
        If allgemeine.igext.Value = "0" Then
            If RS.Format.Value = extension Then
                data_songexists = "1"  'Falls Daten vorhanden
                GoTo gefunden
            End If
        Else
            data_songexists = "1"  'Falls Daten vorhanden
            GoTo gefunden
        End If
    End If
    
    RS.FindNext "[Dateiname] = """ + it + """"  'Neue Suche nach Daten
    
    If Not RS.NoMatch Then
        If RS.Format.Value = extension Then
            data_songexists = "1"  'Falls Daten vorhanden
            GoTo gefunden
        End If
    End If
    
    RS.FindNext "[Dateiname] = """ + it + """"  'Neue Suche nach Daten
    
    If Not RS.NoMatch Then
        If RS.Format.Value = extension Then
            data_songexists = "1"  'Falls Daten vorhanden
            GoTo gefunden
        End If
    End If
    
    data_songexists = "0" 'Song nicht vorhanden
    RS.Close
    Set RS = Nothing
    Set db = Nothing
    Exit Function
    
gefunden:
    If allgemeine.bevorzugen.Value = "1" Then
        dbtime = Right$(RS.aufnahmezeit.Value, 8) 'Aufnahmezeit auslesen
            
        If akttime > "22:00:00" And akttime <= "00:00:00" Or akttime >= "00:00:00" And akttime < "06:00:00" Then 'And dbtime < "22:00:00" And dbtime > "06:00:00" Then 'Abfrage auf unzensierten Song
            If dbtime > "06:00:00" And dbtime < "22:00:00" Then
                RS.Delete 'Zensierten Song löschen
                data_songexists = "0" 'Song nicht vorhanden (nur zensiert)
            End If
        End If
    End If
    
    RS.Close
    Set RS = Nothing
    Set db = Nothing
End Function
Public Function ping(IPaddress As String) As Boolean
    Dim hFile As Long, Address As Long, OptInfo As IP_OPTION_INFORMATION, EchoReply As IP_ECHO_REPLY

    Address = inet_addr(IPaddress)
    hFile = IcmpCreateFile()
    OptInfo.TTL = 255
    ping = IcmpSendEcho(hFile, Address, String(32, "A"), 32, OptInfo, EchoReply, Len(EchoReply) + 8, 2000)
    Call CloseHandle(hFile)
End Function
Public Sub DisableClose(hWnd As Long) 'ist notwendig um das kleine kreuz(abbrechen) zu deaktivieren
    RemoveMenu GetSystemMenu(hWnd, 0), 6, &H400&
    DrawMenuBar hWnd
End Sub
Public Sub enableClose(hWnd As Long) 'ist notwendig um das kleine kreuz(abbrechen) zu aktivieren
    GetSystemMenu hWnd, 6
    DrawMenuBar hWnd
End Sub
Public Function plvergleich(vergleich As String, mode As String) As Boolean
    Dim i As Integer
    
    For i = 0 To 20
        If vergleich = PL_Verwendung.auswahlpl(i).Caption Then
            If mode = "offline" Then
                plvergleich = PL_Verwendung.uselogged(i).Value
            Else
                plvergleich = PL_Verwendung.useonline(i).Value
            End If
        End If
    Next i
End Function
Public Function sourcepathtest(sender As String) As Boolean
    Dim i As Integer
    
    For i = 0 To 20
        If sender = plbezeichnung.plID(i).Text Then sourcepathtest = "1"
    Next i
End Function
Public Sub IsFileOpen(ByRef Path As String, Optional xls As Boolean)
    Dim ErrorNr As Long, F As Integer

    Do
        On Error Resume Next
        F = FreeFile

        Open Path For Append Lock Write As #F
            ErrorNr = Err.Number
        Close #F
  
        DoEvents
        If ErrorNr <> 0 And xls = "1" Then MsgBox "Please close file"
    Loop While (ErrorNr <> 0)
End Sub
Public Sub filter(ByRef Interpret As String, ByRef titel As String, ByRef album As String, ByRef Genre As String)
    Dim trennzei As String, i As Integer
    
    If sort.komma.Value = "1" And InStr(Interpret, ",") <> 0 Then Interpret = Mid$(Interpret, 1, InStr(Interpret, ",") - 1) 'Wenn "Komma" aktiviert, dann Interpret nach "," abschneiden
    If sort.artikel.Value = "1" Then If Mid$(Interpret, 1, 4) = "The " Or Mid$(Interpret, 1, 4) = "Die " Or Mid$(Interpret, 1, 4) = "Das " Or Mid$(Interpret, 1, 4) = "Der " Then Interpret = Mid$(Interpret, 5, Len(Interpret) - 4)
            
    'Trennzeichen wird bestimmt
    If tagging.korrsymbol.Text = "Line:         ""-""" Then trennzei = "-"
    If tagging.korrsymbol.Text = "Underline: ""_""" Then trennzei = "_"
    If tagging.korrsymbol.Text = "Space:      "" """ Then trennzei = " "
        
    'Sonderzeichen Filter
    For i = 1 To Len(Sondercheck)
        Interpret = Replace(Interpret, Mid$(Sondercheck, i, 1), trennzei) 'Sonderzeichen durch Leerzeichen ersetzten
        titel = Replace(titel, Mid$(Sondercheck, i, 1), trennzei) 'Sonderzeichen durch Leerzeichen ersetzten
        album = Replace(album, Mid$(Sondercheck, i, 1), trennzei) 'Sonderzeichen durch Leerzeichen ersetzten
        Genre = Replace(Genre, Mid$(Sondercheck, i, 1), trennzei) 'Sonderzeichen durch Leerzeichen ersetzten
    Next i
        
    Interpret = Trim$(Interpret)
    titel = Trim$(titel)
    album = Trim$(album)
    Genre = Trim$(Genre)
End Sub
