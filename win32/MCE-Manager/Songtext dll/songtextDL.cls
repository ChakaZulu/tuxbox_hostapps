VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "songtextDL"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private Enum enumSongtextEngines
  seMin
  seChartLyricsDE
  seLyricsDotCom
  sePureLyrics
  seAbsoluteLyrics
  seMax
End Enum

Private Function pfbasGetSongtextFromEngine(enSongtextEngine As enumSongtextEngines, _
                                            strArtist As String, _
                                            strTitle As String, _
                                            bolAppendLyricsSiteInfo, _
                                      ByRef strEngineName As String) As String
Dim strRes As String

  Select Case enSongtextEngine
    
    Case seChartLyricsDE
         strRes = fbasGetSongtextFromChartLyricsDE(strArtist, strTitle, bolAppendLyricsSiteInfo)
         strEngineName = "ChartLyrics.de"
    
    Case seLyricsDotCom
         strRes = fbasGetSongtextFromLyricsDotCom(strArtist, strTitle, bolAppendLyricsSiteInfo)
         strEngineName = "LyricsDotCom"
    
    Case sePureLyrics
         strRes = fbasGetSongtextFromPureLyrics(strArtist, strTitle, bolAppendLyricsSiteInfo)
         strEngineName = "PureLyrics"
    
    Case seAbsoluteLyrics
         strRes = fbasGetSongtextFromAbsoluteLyric(strArtist, strTitle, bolAppendLyricsSiteInfo)
         strEngineName = "AbsoluteLyric"
         
    Case Else
         strRes = ""
         strEngineName = "unknown..."
  
  End Select
  
  pfbasGetSongtextFromEngine = strRes
                                            
End Function


Public Function songtextdownload(band As String, _
                                 songname As String, _
                        Optional bolAppendLyricsSiteInfo As Boolean = True)
Dim lngF As Long
Dim strSongtext As String
Dim strEngineName As String
Dim enSE As enumSongtextEngines
Dim dblTimer As Double

    dblTimer = Timer
    
    lngF = FreeFile
    Open App.Path & "\Songtext.log" For Append As #lngF

    For enSE = enumSongtextEngines.seMin + 1 To enumSongtextEngines.seMax - 1
      strSongtext = pfbasGetSongtextFromEngine(enSE, band, songname, bolAppendLyricsSiteInfo, strEngineName)
      If Not strSongtext = "" Then Exit For
    Next
    
    If Not strSongtext = "" Then
      Print #lngF, "" & band & " - " & songname & ": " & strEngineName & " (" & Fix(Timer - dblTimer) & "sec.)"
      strSongtext = Replace(strSongtext, Chr(10), vbLf)  'Korrigiert Zeilenumbrüche
      songtextdownload = strSongtext
    Else
      Print #lngF, "" & band & " - " & songname & ": NO SONGTEXT FOUND"
      songtextdownload = ""
    End If

    Close #lngF

End Function

