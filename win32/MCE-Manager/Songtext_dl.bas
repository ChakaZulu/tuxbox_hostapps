Attribute VB_Name = "Songtext_dl"
Option Explicit
Public Function songtextdl(ccinter As String, cctitel As String, artint As String)
    Dim songt As Object, pos As Long, F As Integer, Songtext As String
    
    If allgemeine.textdownload.Value = "1" Then
        If LenB(Dir$(App.Path & "\Datenbank\Lyrics\" + ccinter + " - " + cctitel + ".txt", vbDirectory)) = 0 Then
            Set songt = New songtextdl
            Songtext = songt.songtextdownload(artint, cctitel)
            If Songtext = vbNullString And cinter <> artint Then Songtext = songt.songtextdownload(ccinter, cctitel)
            Set songt = Nothing
        
            If Songtext <> vbNullString Then
                F = FreeFile
                                
                Open App.Path & "\Datenbank\Lyrics\" + ccinter + " - " + cctitel + ".txt" For Binary As #F
                    Put #F, , Songtext
                Close F
            End If
        Else
            F = FreeFile
            
            Open App.Path & "\Datenbank\Lyrics\" + ccinter + " - " + cctitel + ".txt" For Binary As #F
                Songtext = Space$(LOF(F))
                Get #F, , Songtext
            Close F
        End If
    End If
    
    songtextdl = Songtext
End Function
