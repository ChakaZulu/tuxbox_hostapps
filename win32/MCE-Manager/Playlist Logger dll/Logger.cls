VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Logger"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
Private playlistname(0 To 20) As String
Private playlistzeit(0 To 20) As String
Private playlistdate(0 To 20) As String
Private kennungid(0 To 20) As String
Private tempaddline(0 To 20) As String
Private ziel_pfad As String
Private buffer As String
Private verriegel As Integer
Public Event Newsongid(Newsongidint As String, Newsongidtit As String, Newsongidalb As String, Newsongidlab As String, Newsongidjah As String, id As Integer)
Private WithEvents Dataform As Form1
Attribute Dataform.VB_VarHelpID = -1
Private ipd As String
Private portd As String
Sub plstart(IP As String, Port As String)
    Set Dataform = New Form1
    verriegel = 0
    ipd = IP
    portd = Port
    Dataform.WS.Connect IP, Port
    
    While Dataform.WS.State <> sckConnected
        If Dataform.WS.State = sckError Then Exit Sub
        DoEvents
    Wend
    
    Dataform.WS.SendData "GET /12 HTTP/1.0" & vbLf & vbLf
    Dataform.Timer.Enabled = "1"
End Sub
Sub plstop()
    Dim i As Integer
    
    Set Dataform = New Form1
    Dataform.WS.Close
    
    For i = 0 To 20
        playlistname(i) = vbNullString
        playlistzeit(i) = vbNullString
        kennungid(i) = vbNullString
        tempaddline(i) = vbNullString
    Next i
    
    Set Dataform = Nothing
End Sub
Private Sub Dataform_Timer()
    If verriegel < 2 Then
        verriegel = 0
        Dataform.WS.Close
        
        Do While Dataform.WS.State <> sckClosed
            If Dataform.WS.State = sckError Then Exit Sub
            DoEvents
        Loop
        
        Dataform.WS.Connect ipd, portd
    
        Do While Dataform.WS.State <> sckConnected
            If Dataform.WS.State = sckError Then Exit Sub
            DoEvents
        Loop
        
        Dataform.WS.SendData "GET /12 HTTP/1.0" & vbLf & vbLf
    Else
        Dataform.Timer.Enabled = "0"
    End If
End Sub
Sub daten(playlistna() As String, playlistkennung() As String, Ziel As String)
    Dim i As Integer
    
    For i = 0 To 20
        playlistname(i) = playlistna(i)
        kennungid(i) = playlistkennung(i)
    Next i
    
    ziel_pfad = Ziel
End Sub
Private Sub Dataform_Loggerdata()
    Dim F As Integer, pos1 As Long, pos2 As Long, Paket As String, Interpret As String, titel As String, album As String, label As String, jahr As String, position As Long, kennung As String, addline As String, backuppos As Integer
    
    If verriegel < 4 Then verriegel = verriegel + 1
    Dataform.WS.GetData buffer
    pos2 = 1
nextrun:
    Interpret = vbNullString
    titel = vbNullString
    album = vbNullString
    label = vbNullString
    jahr = vbNullString
    pos1 = 0
    backuppos = pos2
    position = InStr(pos2, buffer, "Interpret:")
    If position = 0 Then Exit Sub
    pos2 = InStr(position, buffer, Chr(255) + Chr(255) + Chr(255) + Chr(255) + Chr(255) + Chr(255) + Chr(255) + Chr(255) + Chr(255) + Chr(255))
    If pos2 = 0 Then Exit Sub
    Paket = Mid(buffer, backuppos, pos2)
    pos1 = InStrRev(Paket, Chr(255) + Chr(255) + Chr(255) + Chr(255) + Chr(255) + Chr(255) + Chr(255) + Chr(255) + Chr(255) + Chr(255) + Chr(0)) + 9
    Paket = Mid(Paket, pos1, pos2 - pos1) 'Ein Paket gefiltert
   
    If InStr(Paket, "Komponist:") Then
        position = InStr(Paket, "Komponist:")
        Interpret = Mid(Paket, position + 11)
        If position < 30 Then Exit Sub
        kennung = Asc(Mid(Paket, InStr(Paket, "Komponist:") - 28, 1))
        position = InStr(Interpret, vbNullChar + Chr(78)) - 1
        If position > 1 Then Interpret = Mid(Interpret, 1, position)            ' "4E"
        position = InStr(Paket, "Werk:")
        titel = Mid(Paket, position + 7)
        position = InStr(titel, Chr(10)) - 1
        If position > 1 Then titel = Mid(titel, 1, position)                ' "A0"
        position = InStr(Paket, "Interpret:")
        album = Mid(Paket, position + 11)
        position = InStr(album, Chr(10)) - 1
        
        If position > 1 Then
            album = Mid(album, 1, position)          ' "4E"
        Else
            album = vbNullString
        End If
        
        position = InStr(Paket, "Label:")
        label = Mid(Paket, position + 8)
        position = InStr(label, Chr(10)) - 1
        If position > 1 Then label = Mid(label, 1, position)   ' "4E"
        If InStr(1, label, "null", vbTextCompare) Then label = vbNullString
        If Len(jahr) <> 4 Or Val(jahr) = 0 Then jahr = "0000"
    Else
        position = InStr(1, Paket, "Interpret:")
        Interpret = Mid(Paket, position + 11)
        If position < 30 Then Exit Sub
        kennung = Asc(Mid(Paket, InStr(Paket, "Interpret:") - 28, 1))
        position = InStr(Interpret, vbNullChar + Chr(78)) - 1
        
        If position > 1 Then
            Interpret = Mid(Interpret, 1, position)         ' "4E"
            If InStr(Interpret, Chr(13)) Then GoTo nextrun
        Else
            GoTo nextrun
        End If
        
        position = InStr(Paket, "Titel:")
        titel = Mid(Paket, position + 8)
        position = InStr(titel, Chr(10)) - 1
        
        If position > 1 Then
            titel = Mid(titel, 1, position)          ' "A0"
            If InStr(titel, Chr(13)) Then GoTo nextrun
        Else
            GoTo nextrun
        End If
        
        If Len(titel) - 5 > 1 Then If Val(Mid(titel, Len(titel) - 5, 5)) <> 0 Or Mid(titel, Len(titel) - 5, 5) = "00000" Then titel = Trim(Left(titel, Len(titel) - 7))
            
        position = InStr(Paket, "Album:")
        album = Mid(Paket, position + 8)
        position = InStr(album, Chr(10)) - 1
        
        If position > 1 Then
            album = Mid(album, 1, position)          ' "4E"
            If InStr(album, Chr(13)) Then GoTo nextrun
        Else
            GoTo nextrun
        End If
        
        position = InStr(Paket, "Label:")
        label = Mid(Paket, position + 8)
        position = InStr(label, Chr(10)) - 1
        
        If position > 1 Then
            label = Mid(label, 1, position)          ' "4E"
            If InStr(label, Chr(13)) Then GoTo nextrun
        Else
            GoTo nextrun
        End If
        
        position = InStr(Paket, "Jahr:")
        jahr = Mid(Paket, position + 8)
        position = InStr(jahr, Chr(10)) - 1
        
        If position > 1 Then
            jahr = Mid(jahr, 1, position)          ' "4E"
            If Len(jahr) <> 4 Or Val(jahr) = 0 Then jahr = "0000"
            If InStr(jahr, Chr(13)) Then GoTo nextrun
        Else
            GoTo nextrun
        End If
    End If
    
    Interpret = Replace(Interpret, "'", "´")
    titel = Replace(titel, "'", "´")
    album = Replace(album, "'", "´")
    label = Replace(label, "'", "´")
    
    addline = Interpret + ";" + titel + ";" + album + ";" + label + ";" + jahr
    
    Select Case kennung
        Case Is = kennungid(0)
            verriegel = "0"
            
            If addline <> tempaddline(0) Then
                RaiseEvent Newsongid(Interpret, titel, album, label, jahr, 0)
                
                If tempaddline(0) <> vbNullString Then
                    If playlistzeit(0) <> vbNullString Then
                        F = FreeFile
                        
                        Open ziel_pfad + Right(playlistdate(0), 4) + "-" + Mid(playlistdate(0), 4, 2) + "-" + Left(playlistdate(0), 2) + "-" + playlistname(0) + ".txt" For Append As #F
                            Print #F, Str(Date) + ";" + playlistzeit(0) + ";" + Str(Time) + ";" + tempaddline(0)
                        Close #F
                    End If
                    
                    playlistzeit(0) = Time
                    playlistdate(0) = Date
                End If
                
                tempaddline(0) = addline
            End If
        Case Is = kennungid(1)
            If addline <> tempaddline(1) Then
                RaiseEvent Newsongid(Interpret, titel, album, label, jahr, 1)
                
                If tempaddline(1) <> vbNullString Then
                    If playlistzeit(1) <> vbNullString Then
                        F = FreeFile
                        
                        Open ziel_pfad + Right(playlistdate(1), 4) + "-" + Mid(playlistdate(1), 4, 2) + "-" + Left(playlistdate(1), 2) + "-" + playlistname(1) + ".txt" For Append As #F
                            Print #F, Str(Date) + ";" + playlistzeit(1) + ";" + Str(Time) + ";" + tempaddline(1)
                        Close #F
                    End If
                    
                    playlistzeit(1) = Time
                    playlistdate(1) = Date
                End If
                
                tempaddline(1) = addline
            End If
        Case Is = kennungid(2)
            If addline <> tempaddline(2) Then
                RaiseEvent Newsongid(Interpret, titel, album, label, jahr, 2)
                
                If tempaddline(2) <> vbNullString Then
                    If playlistzeit(2) <> vbNullString Then
                        F = FreeFile
                        
                        Open ziel_pfad + Right(playlistdate(2), 4) + "-" + Mid(playlistdate(2), 4, 2) + "-" + Left(playlistdate(2), 2) + "-" + playlistname(2) + ".txt" For Append As #F
                            Print #F, Str(Date) + ";" + playlistzeit(2) + ";" + Str(Time) + ";" + tempaddline(2)
                        Close #F
                    End If
                    
                    playlistzeit(2) = Time
                    playlistdate(2) = Date
                End If
                
                tempaddline(2) = addline
            End If
        Case Is = kennungid(3)
            If addline <> tempaddline(3) Then
                RaiseEvent Newsongid(Interpret, titel, album, label, jahr, 3)
                
                If tempaddline(3) <> vbNullString Then
                    If playlistzeit(3) <> vbNullString Then
                        F = FreeFile
                        
                        Open ziel_pfad + Right(playlistdate(3), 4) + "-" + Mid(playlistdate(3), 4, 2) + "-" + Left(playlistdate(3), 2) + "-" + playlistname(3) + ".txt" For Append As #F
                            Print #F, Str(Date) + ";" + playlistzeit(3) + ";" + Str(Time) + ";" + tempaddline(3)
                        Close #F
                    End If
                    
                    playlistzeit(3) = Time
                    playlistdate(3) = Date
                End If
                
                tempaddline(3) = addline
            End If
        Case Is = kennungid(4)
            If addline <> tempaddline(4) Then
                RaiseEvent Newsongid(Interpret, titel, album, label, jahr, 4)
                
                If tempaddline(4) <> vbNullString Then
                    If playlistzeit(4) <> vbNullString Then
                        F = FreeFile
                        
                        Open ziel_pfad + Right(playlistdate(4), 4) + "-" + Mid(playlistdate(4), 4, 2) + "-" + Left(playlistdate(4), 2) + "-" + playlistname(4) + ".txt" For Append As #F
                            Print #F, Str(Date) + ";" + playlistzeit(4) + ";" + Str(Time) + ";" + tempaddline(4)
                        Close #F
                    End If
                    
                    playlistzeit(4) = Time
                    playlistdate(4) = Date
                End If
                
                tempaddline(4) = addline
            End If
        Case Is = kennungid(5)
            If addline <> tempaddline(5) Then
                RaiseEvent Newsongid(Interpret, titel, album, label, jahr, 5)
                
                If tempaddline(5) <> vbNullString Then
                    If playlistzeit(5) <> vbNullString Then
                        F = FreeFile
                        
                        Open ziel_pfad + Right(playlistdate(5), 4) + "-" + Mid(playlistdate(5), 4, 2) + "-" + Left(playlistdate(5), 2) + "-" + playlistname(5) + ".txt" For Append As #F
                            Print #F, Str(Date) + ";" + playlistzeit(5) + ";" + Str(Time) + ";" + tempaddline(5)
                        Close #F
                    End If
                    
                    playlistzeit(5) = Time
                    playlistdate(5) = Date
                End If
                
                tempaddline(5) = addline
            End If
        Case Is = kennungid(6)
            If addline <> tempaddline(6) Then
                RaiseEvent Newsongid(Interpret, titel, album, label, jahr, 6)
                
                If tempaddline(6) <> vbNullString Then
                    If playlistzeit(6) <> vbNullString Then
                        F = FreeFile
                        
                        Open ziel_pfad + Right(playlistdate(6), 4) + "-" + Mid(playlistdate(6), 4, 2) + "-" + Left(playlistdate(6), 2) + "-" + playlistname(6) + ".txt" For Append As #F
                            Print #F, Str(Date) + ";" + playlistzeit(6) + ";" + Str(Time) + ";" + tempaddline(6)
                        Close #F
                    End If
                    
                    playlistzeit(6) = Time
                    playlistdate(6) = Date
                End If
                
                tempaddline(6) = addline
            End If
        Case Is = kennungid(7)
            If addline <> tempaddline(7) Then
                RaiseEvent Newsongid(Interpret, titel, album, label, jahr, 7)
                
                If tempaddline(7) <> vbNullString Then
                    If playlistzeit(7) <> vbNullString Then
                        F = FreeFile
                        
                        Open ziel_pfad + Right(playlistdate(7), 4) + "-" + Mid(playlistdate(7), 4, 2) + "-" + Left(playlistdate(7), 2) + "-" + playlistname(7) + ".txt" For Append As #F
                            Print #F, Str(Date) + ";" + playlistzeit(7) + ";" + Str(Time) + ";" + tempaddline(7)
                        Close #F
                    End If
                    
                    playlistzeit(7) = Time
                    playlistdate(7) = Date
                End If
                
                tempaddline(7) = addline
            End If
        Case Is = kennungid(8)
            If addline <> tempaddline(8) Then
                RaiseEvent Newsongid(Interpret, titel, album, label, jahr, 8)
                
                If tempaddline(8) <> vbNullString Then
                    If playlistzeit(8) <> vbNullString Then
                        F = FreeFile
                        
                        Open ziel_pfad + Right(playlistdate(8), 4) + "-" + Mid(playlistdate(8), 4, 2) + "-" + Left(playlistdate(8), 2) + "-" + playlistname(8) + ".txt" For Append As #F
                            Print #F, Str(Date) + ";" + playlistzeit(8) + ";" + Str(Time) + ";" + tempaddline(8)
                        Close #F
                    End If
                    
                    playlistzeit(8) = Time
                    playlistdate(8) = Date
                End If
                
                tempaddline(8) = addline
            End If
        Case Is = kennungid(9)
            If addline <> tempaddline(9) Then
                RaiseEvent Newsongid(Interpret, titel, album, label, jahr, 9)
                
                If tempaddline(9) <> vbNullString Then
                    If playlistzeit(9) <> vbNullString Then
                        F = FreeFile
                        
                        Open ziel_pfad + Right(playlistdate(9), 4) + "-" + Mid(playlistdate(9), 4, 2) + "-" + Left(playlistdate(9), 2) + "-" + playlistname(9) + ".txt" For Append As #F
                            Print #F, Str(Date) + ";" + playlistzeit(9) + ";" + Str(Time) + ";" + tempaddline(9)
                        Close #F
                    End If
                    
                    playlistzeit(9) = Time
                    playlistdate(9) = Date
                End If
                
                tempaddline(9) = addline
            End If
        Case Is = kennungid(10)
            If addline <> tempaddline(10) Then
                RaiseEvent Newsongid(Interpret, titel, album, label, jahr, 10)
                
                If tempaddline(10) <> vbNullString Then
                    If playlistzeit(10) <> vbNullString Then
                        F = FreeFile
                        
                        Open ziel_pfad + Right(playlistdate(10), 4) + "-" + Mid(playlistdate(10), 4, 2) + "-" + Left(playlistdate(10), 2) + "-" + playlistname(10) + ".txt" For Append As #F
                            Print #F, Str(Date) + ";" + playlistzeit(10) + ";" + Str(Time) + ";" + tempaddline(10)
                        Close #F
                    End If
                    
                    playlistzeit(10) = Time
                    playlistdate(10) = Date
                End If
                
                tempaddline(10) = addline
            End If
        Case Is = kennungid(11)
            If addline <> tempaddline(11) Then
                RaiseEvent Newsongid(Interpret, titel, album, label, jahr, 11)
                
                If tempaddline(11) <> vbNullString Then
                    If playlistzeit(11) <> vbNullString Then
                        F = FreeFile
                        
                        Open ziel_pfad + Right(playlistdate(11), 4) + "-" + Mid(playlistdate(11), 4, 2) + "-" + Left(playlistdate(11), 2) + "-" + playlistname(11) + ".txt" For Append As #F
                            Print #F, Str(Date) + ";" + playlistzeit(11) + ";" + Str(Time) + ";" + tempaddline(11)
                        Close #F
                    End If
                    
                    playlistzeit(11) = Time
                    playlistdate(11) = Date
                End If
                
                tempaddline(11) = addline
            End If
        Case Is = kennungid(12)
            If addline <> tempaddline(12) Then
                RaiseEvent Newsongid(Interpret, titel, album, label, jahr, 12)
                
                If tempaddline(12) <> vbNullString Then
                    If playlistzeit(12) <> vbNullString Then
                        F = FreeFile
                        
                        Open ziel_pfad + Right(playlistdate(12), 4) + "-" + Mid(playlistdate(12), 4, 2) + "-" + Left(playlistdate(12), 2) + "-" + playlistname(12) + ".txt" For Append As #F
                            Print #F, Str(Date) + ";" + playlistzeit(12) + ";" + Str(Time) + ";" + tempaddline(12)
                        Close #F
                    End If
                    
                    playlistzeit(12) = Time
                    playlistdate(12) = Date
                End If
                
                tempaddline(12) = addline
            End If
        Case Is = kennungid(13)
            If addline <> tempaddline(13) Then
                RaiseEvent Newsongid(Interpret, titel, album, label, jahr, 13)
                
                If tempaddline(13) <> vbNullString Then
                    If playlistzeit(13) <> vbNullString Then
                        F = FreeFile
                        
                        Open ziel_pfad + Right(playlistdate(13), 4) + "-" + Mid(playlistdate(13), 4, 2) + "-" + Left(playlistdate(13), 2) + "-" + playlistname(13) + ".txt" For Append As #F
                            Print #F, Str(Date) + ";" + playlistzeit(13) + ";" + Str(Time) + ";" + tempaddline(13)
                        Close #F
                    End If
                    
                    playlistzeit(13) = Time
                    playlistdate(13) = Date
                End If
                
                tempaddline(13) = addline
            End If
        Case Is = kennungid(14)
            If addline <> tempaddline(14) Then
                RaiseEvent Newsongid(Interpret, titel, album, label, jahr, 14)
                
                If tempaddline(14) <> vbNullString Then
                    If playlistzeit(14) <> vbNullString Then
                        F = FreeFile
                        
                        Open ziel_pfad + Right(playlistdate(14), 4) + "-" + Mid(playlistdate(14), 4, 2) + "-" + Left(playlistdate(14), 2) + "-" + playlistname(14) + ".txt" For Append As #F
                            Print #F, Str(Date) + ";" + playlistzeit(14) + ";" + Str(Time) + ";" + tempaddline(14)
                        Close #F
                    End If
                    
                    playlistzeit(14) = Time
                    playlistdate(14) = Date
                End If
                
                tempaddline(14) = addline
            End If
        Case Is = kennungid(15)
            If addline <> tempaddline(15) Then
                RaiseEvent Newsongid(Interpret, titel, album, label, jahr, 15)
                
                If tempaddline(15) <> vbNullString Then
                    If playlistzeit(15) <> vbNullString Then
                        F = FreeFile
                        
                        Open ziel_pfad + Right(playlistdate(15), 4) + "-" + Mid(playlistdate(15), 4, 2) + "-" + Left(playlistdate(15), 2) + "-" + playlistname(15) + ".txt" For Append As #F
                            Print #F, Str(Date) + ";" + playlistzeit(15) + ";" + Str(Time) + ";" + tempaddline(15)
                        Close #F
                    End If
                    
                    playlistzeit(15) = Time
                    playlistdate(15) = Date
                End If
                
                tempaddline(15) = addline
            End If
        Case Is = kennungid(16)
            If addline <> tempaddline(16) Then
                RaiseEvent Newsongid(Interpret, titel, album, label, jahr, 16)
                
                If tempaddline(16) <> vbNullString Then
                    If playlistzeit(16) <> vbNullString Then
                        F = FreeFile
                        
                        Open ziel_pfad + Right(playlistdate(16), 4) + "-" + Mid(playlistdate(16), 4, 2) + "-" + Left(playlistdate(16), 2) + "-" + playlistname(16) + ".txt" For Append As #F
                            Print #F, Str(Date) + ";" + playlistzeit(16) + ";" + Str(Time) + ";" + tempaddline(16)
                        Close #F
                    End If
                    
                    playlistzeit(16) = Time
                    playlistdate(16) = Date
                End If
                
                tempaddline(16) = addline
            End If
        Case Is = kennungid(17)
            If addline <> tempaddline(17) Then
                RaiseEvent Newsongid(Interpret, titel, album, label, jahr, 17)
                
                If tempaddline(17) <> vbNullString Then
                    If playlistzeit(17) <> vbNullString Then
                        F = FreeFile
                        
                        Open ziel_pfad + Right(playlistdate(17), 4) + "-" + Mid(playlistdate(17), 4, 2) + "-" + Left(playlistdate(17), 2) + "-" + playlistname(17) + ".txt" For Append As #F
                            Print #F, Str(Date) + ";" + playlistzeit(17) + ";" + Str(Time) + ";" + tempaddline(17)
                        Close #F
                    End If
                    
                    playlistzeit(17) = Time
                    playlistdate(17) = Date
                End If
                
                tempaddline(17) = addline
            End If
        Case Is = kennungid(18)
            If addline <> tempaddline(18) Then
                RaiseEvent Newsongid(Interpret, titel, album, label, jahr, 18)
                
                If tempaddline(18) <> vbNullString Then
                    If playlistzeit(18) <> vbNullString Then
                        F = FreeFile
                        
                        Open ziel_pfad + Right(playlistdate(18), 4) + "-" + Mid(playlistdate(18), 4, 2) + "-" + Left(playlistdate(18), 2) + "-" + playlistname(18) + ".txt" For Append As #F
                            Print #F, Str(Date) + ";" + playlistzeit(18) + ";" + Str(Time) + ";" + tempaddline(18)
                        Close #F
                    End If
                    
                    playlistzeit(18) = Time
                    playlistdate(18) = Date
                End If
                
                tempaddline(18) = addline
            End If
        Case Is = kennungid(19)
            If addline <> tempaddline(19) Then
                RaiseEvent Newsongid(Interpret, titel, album, label, jahr, 19)
                
                If tempaddline(19) <> vbNullString Then
                    If playlistzeit(19) <> vbNullString Then
                        F = FreeFile
                        
                        Open ziel_pfad + Right(playlistdate(19), 4) + "-" + Mid(playlistdate(19), 4, 2) + "-" + Left(playlistdate(19), 2) + "-" + playlistname(19) + ".txt" For Append As #F
                            Print #F, Str(Date) + ";" + playlistzeit(19) + ";" + Str(Time) + ";" + tempaddline(19)
                        Close #F
                    End If
                    
                    playlistzeit(19) = Time
                    playlistdate(19) = Date
                End If
                
                tempaddline(19) = addline
            End If
        Case Is = kennungid(20)
            If addline <> tempaddline(20) Then
                RaiseEvent Newsongid(Interpret, titel, album, label, jahr, 20)
                
                If tempaddline(20) <> vbNullString Then
                    If playlistzeit(20) <> vbNullString Then
                        F = FreeFile
                        
                        Open ziel_pfad + Right(playlistdate(20), 4) + "-" + Mid(playlistdate(20), 4, 2) + "-" + Left(playlistdate(20), 2) + "-" + playlistname(20) + ".txt" For Append As #F
                            Print #F, Str(Date) + ";" + playlistzeit(20) + ";" + Str(Time) + ";" + tempaddline(20)
                        Close #F
                    End If
                    
                    playlistzeit(20) = Time
                    playlistdate(20) = Date
                End If
                    
                tempaddline(20) = addline
            End If
    End Select
    
    GoTo nextrun
End Sub
