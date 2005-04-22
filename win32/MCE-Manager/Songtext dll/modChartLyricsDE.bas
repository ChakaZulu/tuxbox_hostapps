Attribute VB_Name = "modChartLyricsDE"
Option Explicit

Public Function fbasGetSongtextFromChartLyricsDE(ByVal strArtist As String, _
                                                 ByVal strTitle As String, _
                                        Optional ByVal bolAppendLyricsSiteInfo As Boolean = True) As String
Dim strURL As String
Dim strHTML As String
Dim arrSongIDs As Variant, lngID As Long
Dim strSongtext As String
Dim strTemp As String

  strURL = "http://www.williger-online.de/search.php?"
  strURL = strURL & "Interpret=" & fbasUrlEnc(strArtist) & "&"
  strURL = strURL & "Titel=" & fbasUrlEnc(strTitle)
  
  strHTML = fbasHttpGet(strURL)
  
  arrSongIDs = pfbasGetSongIDs(strHTML)
  
  strSongtext = ""
  For lngID = 0 To UBound(arrSongIDs)
    
    If IsNumeric(arrSongIDs(lngID)) Then
      strURL = "http://www.williger-online.de/textzeigen.php?SongID=" & arrSongIDs(lngID)
      strHTML = fbasHttpGet(strURL)
      strTemp = pfbasGetSongtextFromHtml(strHTML)
      If Len(strTemp) > Len(strSongtext) Then strSongtext = strTemp
    End If
    
  Next
  
  strSongtext = Trim(strSongtext)
  If Len(strSongtext) > 0 Then
    If bolAppendLyricsSiteInfo Then strSongtext = strSongtext & vbCrLf & vbCrLf & "-----------------------------------" & vbCrLf & "--- Songtext von ChartLyrics.de ---"
    fbasGetSongtextFromChartLyricsDE = strSongtext
  Else
    fbasGetSongtextFromChartLyricsDE = ""
  End If

End Function


Private Function pfbasGetSongIDs(strHTML As String) As Variant
Dim lngPos1 As Long, lngPos2 As Long
Dim strTemp As String, strRes As String

  lngPos1 = InStr(strHTML, "SongID=")
  Do While lngPos1 > 0
  
    lngPos1 = lngPos1 + 7
    lngPos2 = InStr(lngPos1, strHTML, Chr(34))
    strTemp = Mid(strHTML, lngPos1, lngPos2 - lngPos1)
    If IsNumeric(strTemp) Then strRes = strRes & strTemp & ";"
  
    lngPos1 = InStr(lngPos2, strHTML, "SongID=")
  
  Loop
  
  pfbasGetSongIDs = Split(strRes, ";")

End Function


Private Function pfbasGetSongtextFromHtml(ByVal strHTML As String) As String
Dim lngPos1 As Long, lngPos2 As Long

  lngPos1 = InStr(strHTML, "<!--  Seiteninhalt  -->")
  If lngPos1 > 0 Then
  
    strHTML = Mid(strHTML, lngPos1)
    lngPos1 = InStr(strHTML, "<table")
    lngPos1 = InStr(lngPos1, strHTML, "<td>") + 4
    lngPos2 = InStr(lngPos1, strHTML, "</td>")
    
    If lngPos2 > lngPos1 Then
    
      strHTML = Mid(strHTML, lngPos1, lngPos2 - lngPos1)
      strHTML = Replace(strHTML, "<b>", "")
      strHTML = Replace(strHTML, "</b>", "")
      strHTML = Replace(strHTML, Chr(10), "")
      strHTML = Replace(strHTML, Chr(13), "")
      strHTML = Replace(strHTML, "<br>", vbCrLf)
      strHTML = Replace(strHTML, "<br/>", vbCrLf)
      strHTML = Replace(strHTML, "<br />", vbCrLf)
      
      pfbasGetSongtextFromHtml = strHTML
    
    End If
  
  End If

End Function
