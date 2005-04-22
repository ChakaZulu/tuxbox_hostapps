Attribute VB_Name = "modAbsoluteLyric"
Option Explicit

Private Const conSearchURL As String = "http://www.absolutelyric.com/lyrics/search/"
Private Const conSearchParam As String = "q"
Private Const conParamAdd As String = "&type=as&op=and&sort=s"
'
Private Const conSongIDNoMatch As String = "No result found."
Private Const conSongIDSearchFrom1 As String = "Search Result for"
Private Const conSongIDSearchFrom2 As String = "href=""/lyrics/view/"
Private Const conSongIDSearchTo As String = """"
'
Private Const conSongtextURL As String = "http://www.absolutelyric.com/lyrics/print/"
'

Public Function fbasGetSongtextFromAbsoluteLyric(ByVal strArtist As String, _
                                                 ByVal strTitle As String, _
                                        Optional ByVal bolAppendLyricsSiteInfo As Boolean = True) As String

Dim strURL As String
Dim strHTML As String
Dim arrSongIDs As Variant, lngID As Long
Dim strSongtext As String
Dim strTemp As String
Dim lngPos As Long

  strURL = conSearchURL & "?"
  strURL = strURL & conSearchParam & "=" & fbasUrlEnc(strArtist) & "+" & fbasUrlEnc(strTitle)
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
      lngPos = InStr(strSongtext, "By www.absolutelyric.com")
      If lngPos > 0 Then strSongtext = Left(strSongtext, lngPos - 1)
    End If
    fbasGetSongtextFromAbsoluteLyric = strSongtext
  Else
    fbasGetSongtextFromAbsoluteLyric = ""
  End If

End Function


Private Function pfbasGetSongID(strHTML As String) As String
Dim lngPos1 As Long
Dim lngPos2 As Long

  If InStr(strHTML, "conSongIDNoMatch") = 0 Then
  
    lngPos1 = InStr(strHTML, conSongIDSearchFrom1)
    If lngPos1 > 0 Then lngPos1 = InStr(strHTML, conSongIDSearchFrom2)
    If lngPos1 > 0 Then
      
      lngPos1 = lngPos1 + Len(conSongIDSearchFrom2)
      lngPos2 = InStr(lngPos1, strHTML, conSongIDSearchTo)
      If lngPos2 > lngPos1 Then
        pfbasGetSongID = Mid(strHTML, lngPos1, lngPos2 - lngPos1)
      Else
        pfbasGetSongID = ""
      End If
    
    Else
      pfbasGetSongID = ""
    End If
  
  Else
    pfbasGetSongID = ""
  End If
  
  

End Function

Public Function pfbasGetSongtextFromHtml(ByVal strHTML As String) As String
Dim lngPos1 As Long, lngPos2 As Long

  lngPos1 = InStr(strHTML, "<body>")
  If lngPos1 > 0 Then
  
    lngPos1 = lngPos1 + 6
    lngPos2 = InStr(lngPos1, strHTML, "</body>")
    If lngPos2 > lngPos1 Then
    
      strHTML = Mid(strHTML, lngPos1, lngPos2 - lngPos1)
    
      strHTML = Replace(strHTML, Chr(13), "")
      strHTML = Replace(strHTML, Chr(10), "")
      strHTML = Replace(strHTML, "<br>", vbCrLf)
      strHTML = Replace(strHTML, "<br/>", vbCrLf)
      strHTML = Replace(strHTML, "<br />", vbCrLf)
      
      strHTML = Replace(strHTML, "<hr ", vbCrLf & String(20, "-") & vbCrLf & "<")
    
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





