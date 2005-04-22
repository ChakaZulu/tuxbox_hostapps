Attribute VB_Name = "modTest"
Option Explicit

Public Function testSongtext(band As String, songname As String) As String
Dim o As New songtextDL

  testSongtext = o.songtextdownload(band, songname)

End Function
