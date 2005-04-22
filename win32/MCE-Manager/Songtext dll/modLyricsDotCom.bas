Attribute VB_Name = "modLyricsDotCom"
Option Explicit

Private Const conSearchURL As String = "http://lyricsdot.com/search.html"
Private Const conParamArtist As String = "band"
Private Const conParamTitle As String = "song"
Private Const conParamAdd As String = "&match=perfect"
'
Private Const conSongIDSearchFrom As String = "/id_"
Private Const conSongIDSearchTo As String = """"
'
Private Const conSongtextURL As String = "http://lyricsdot.com/text/id_"
'

Public Function fbasGetSongtextFromLyricsDotCom(ByVal strArtist As String, _
                                                ByVal strTitle As String, _
                                       Optional ByVal bolAppendLyricsSiteInfo As Boolean = True) As String

Dim strURL As String
Dim strHTML As String
Dim arrSongIDs As Variant, lngID As Long
Dim strSongtext As String
Dim strTemp As String
Dim lngPos As Long

  strURL = conSearchURL & "?"
  strURL = strURL & conParamArtist & "=" & fbasUrlEnc(strArtist) & "&"
  strURL = strURL & conParamTitle & "=" & fbasUrlEnc(strTitle)
  strURL = strURL & conParamAdd
  
  ' Suchergebnis laden
  strHTML = fbasHttpGet(strURL)
  ' SongID parsen
  strURL = pfbasGetSongID(strHTML)
  
  ' Songtext laden
  strSongtext = ""
  If Not strURL = "" Then
    strURL = conSongtextURL & strURL
    strHTML = fbasHttpGet(strURL)
    strSongtext = pfbasGetSongtextFromHtml(strHTML)
  End If

  If Not strSongtext = "" Then
    If Not bolAppendLyricsSiteInfo Then
      lngPos = InStr(strSongtext, "http://www.lyricsdot.com")
      If lngPos > 0 Then strSongtext = Left(strSongtext, lngPos - 1)
    End If
    fbasGetSongtextFromLyricsDotCom = strSongtext
  Else
    fbasGetSongtextFromLyricsDotCom = ""
  End If

End Function


Private Function pfbasGetSongID(strHTML As String) As String
Dim lngPos1 As Long
Dim lngPos2 As Long

  lngPos1 = InStr(strHTML, conSongIDSearchFrom)
  If lngPos1 > 0 Then
    
    lngPos1 = lngPos1 + Len(conSongIDSearchFrom)
    lngPos2 = InStr(lngPos1, strHTML, conSongIDSearchTo)
    If lngPos2 > lngPos1 Then
      pfbasGetSongID = Mid(strHTML, lngPos1, lngPos2 - lngPos1)
    Else
      pfbasGetSongID = ""
    End If
  
  Else
    pfbasGetSongID = ""
  End If
  

End Function

Public Function pfbasGetSongtextFromHtml(ByVal strHTML As String) As String
Dim lngPos1 As Long, lngPos2 As Long

  lngPos1 = InStr(strHTML, "<pre>")
  If lngPos1 > 0 Then
  
    lngPos1 = lngPos1 + 5
    lngPos2 = InStr(lngPos1, strHTML, "</pre>")
    If lngPos2 > lngPos1 Then
    
      strHTML = Mid(strHTML, lngPos1, lngPos2 - lngPos1)
    
      ' restliche HTML-Tags verwerfen
      lngPos1 = InStr(strHTML, "<")
      Do While lngPos1 > 0
        lngPos2 = InStr(lngPos1, strHTML, ">")
        If lngPos2 > lngPos1 Then
          strHTML = Left(strHTML, lngPos1 - 1) & Mid(strHTML, lngPos2 + 1)
        Else
          Exit Do
        End If
        lngPos1 = InStr(strHTML, "<")
      Loop
    
      pfbasGetSongtextFromHtml = strHTML
    
    End If
  
  End If

End Function



