VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Class"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
Private WithEvents Dataform As Form1
Attribute Dataform.VB_VarHelpID = -1
Public Event newsong(newsongfile As String)
Public Event addbuffer(size As Long, i As Integer, news As Boolean)

Private SNr As Integer
Private first(1 To 8) As Boolean
Private F(1 To 8) As Integer
Private hilfsmarke(1 To 8) As Long
Private buffer(1 To 8) As String
Private apid(1 To 8) As String
Private apidset(1 To 8) As String
Private Connect As String
Private pw As String
Private filena(1 To 8) As String
Private IP As String
Private Ziel As String
Private login As String
Private Quelle As String
Private Port As String
Private plname(1 To 8) As String
Private sender(1 To 8) As String
Private Verriegelung As Boolean
Private verriegel(1 To 8) As Integer
Sub start(Optional last As String, Optional sanzahl As Integer)
    Dim i As Integer
    
    Verriegelung = "0"
    
    If apidset(SNr) <> vbNullString Then
        F(SNr) = FreeFile
        Open Ziel + "\temp\tempsong" + Str(SNr) + ".mp" For Binary As #F(SNr)
        hilfsmarke(SNr) = 1 'Für Audioheadersuche die Startposition setzten
        Dataform.Radiosender(SNr).Connect IP, Port 'Telnetverbindung aufbauen für Streamempfang
        
        Do While Dataform.Radiosender(SNr).State <> sckConnected
            If Dataform.Radiosender(SNr).State = sckError Then Exit Sub
            DoEvents
        Loop
            
        Dataform.Radiosender(SNr).SendData "GET /" + apidset(SNr) + " HTTP/1.0" & vbCrLf        'Aufnahme starten
        Exit Sub
    End If
    
    If last = "0" Then Dataform.Telnet.Connect (IP), (23)        'Telnet aktivieren
    
    While Connect <> "1"
        DoEvents
    Wend
    
    Dataform.Telnet.SendData ("pzapit -n """ + sender(SNr) + """ -ra" & vbCrLf)
    
    While apid(SNr) = vbNullString
        DoEvents
    Wend
    
    If last = "2" Then
        Dataform.Telnet.Close 'Telnet beenden
        
        For i = 1 To sanzahl
            F(i) = FreeFile
            Open Ziel + "\temp\tempsong" + Str(i) + ".mp" For Binary As #F(i) 'Audiopaket in tempsong schreiben
            hilfsmarke(i) = 1 'Für Audioheadersuche die Startposition setzten
            Dataform.Radiosender(i).Connect IP, Port 'Telnetverbindung aufbauen für Streamempfang
            verriegel(i) = "0"
            
            If apid(i) <> "Error" Then
            
                Do While Dataform.Radiosender(i).State <> sckConnected
                    If Dataform.Radiosender(i).State = sckError Then Exit Sub
                    DoEvents
                Loop
                
                Dataform.Radiosender(i).SendData "GET /" + apid(i) + " HTTP/1.0" & vbCrLf
                Dataform.Timer(i).Enabled = "1"
            End If
        Next i
    End If
End Sub
Sub sto()
    Dim i As Integer
    
    SNr = 0
    
    For i = 1 To 8
        Close #F(i)
        Connect = "False"
        filena(i) = vbNullString
        Dataform.Radiosender(i).Close 'Telnet beenden
        
        Do While Form1.Radiosender(i).State <> sckClosed
            DoEvents
        Loop
        
        buffer(i) = vbNullString
        If Dir(Ziel + "\temp\tempsong" + Str(i) + ".mp", vbDirectory) <> vbNullString Then Kill Ziel + "\temp\tempsong" + Str(i) + ".mp" 'temp-Files löschen
        first(i) = "0"
    Next i
End Sub
Private Sub dataform_inittest(i As Integer)
    If verriegel(i) < 3 Then
        verriegel(i) = 0
        Form1.Radiosender(i).Close
                
        Do While Form1.Radiosender(i).State <> sckClosed
            If Form1.Radiosender(i).State = sckError Then Exit Sub
            DoEvents
        Loop
                
        Form1.Radiosender(i).Connect IP, Port
            
        Do While Form1.Radiosender(i).State <> sckConnected
            If Form1.Radiosender(i).State = sckError Then Exit Sub
            DoEvents
        Loop
                
        Form1.Radiosender(i).SendData "GET /" + apid(i) + " HTTP/1.0" & vbCrLf
    Else
        Form1.Timer(i).Enabled = "0"
    End If
End Sub
Sub Daten(ipd As String, portd As String, Quelled As String, Senderd As String, plnamed As String, logind As String, zield As String, pwd As String, audiopidd As String)
    SNr = SNr + 1
    filena(SNr) = vbNullString 'Rücksetzen
    apid(SNr) = vbNullString 'Rücksetzen
    hilfsmarke(SNr) = 0 'Rücksetzen
    pw = pwd 'Rücksetzen
    IP = ipd 'Rücksetzen
    Port = portd 'Rücksetzen
    Quelle = Quelled 'Rücksetzen
    sender(SNr) = Senderd 'Rücksetzen
    plname(SNr) = plnamed 'Rücksetzen
    login = logind 'Rücksetzen
    Ziel = zield 'Rücksetzen
    apidset(SNr) = audiopidd 'Rücksetzen
End Sub
Private Sub dataform_streamdata(i As Integer)
    Dim inBuf As String, filesize As Long, temposition As Long, ascvalue As Integer, headerlen As Long, tempmp2 As String, pos1 As Long, paketlen As Long
    
    If verriegel(i) < 6 Then verriegel(i) = verriegel(i) + 1
    On Error GoTo fehler
    Dataform.Radiosender(i).GetData inBuf
    buffer(i) = buffer(i) + inBuf
    If Len(buffer(i)) > 40000 Then GoTo fehler 'ca 3 Pakete
    temposition = InStr(hilfsmarke(i), buffer(i), vbNullChar + vbNullChar + Chr(1)) 'Wenn 00 00 01 gefunden
    If temposition < 1 Then Exit Sub 'Wenn nich gefunden dann exit
    If Len(buffer(i)) < temposition + 100 Then Exit Sub 'Zu wenig Daten (Header könnte abgeschnitten sein)
    ascvalue = Asc(Mid$(buffer(i), temposition + 3, 1)) 'Byte nach 00 00 01 wird ausgelesen
    
    If ascvalue >= &HC0 And ascvalue <= &HDF Then  'Header gefunden 00 00 01 "C0"
        hilfsmarke(i) = 1 'Hilfsmarke rücksetzten
        paketlen = Val("&H" & Hex(Asc(Mid$(buffer(i), temposition + 4, 1))) + Hex(Asc(Mid$(buffer(i), temposition + 5, 1)))) 'Paketlänge bestimmen
        headerlen = Asc(Mid$(buffer(i), temposition + 8, 1)) 'Headerlänge bestimmen
        If temposition + 100 + paketlen > Len(buffer(i)) Then Exit Sub 'Wenn noch Daten im buffer.pes fehlen, dann exit
        pos1 = paketlen - headerlen - 3
        If pos1 < 1 Then Exit Sub
        tempmp2 = Mid$(buffer(i), temposition + 9 + headerlen, pos1) 'Audiopaket bestimmen (ascvalue)
        
        If Asc(Mid$(tempmp2, 1, 1)) = &HFF And Asc(Mid$(tempmp2, 2, 1)) = &HFD And Asc(Mid$(tempmp2, 3, 1)) = &HA0 Then
            Call Verschieben(i) 'Neuer Song gefunden
            RaiseEvent addbuffer(0, i, "1")
        End If
        
        filesize = LOF(F(i)) + 1
        Put #F(i), filesize, tempmp2
        RaiseEvent addbuffer(Len(tempmp2), i, "0")
        buffer(i) = Mid$(buffer(i), temposition + 4 + paketlen, Len(buffer(i))) 'Vollständiges Paket rausschneiden
    Else
        hilfsmarke(i) = temposition + 1 'Nötig um nachzurutschen, falls 00 00 01 gefunden, aber kein Header ist
    End If
    
    Exit Sub
fehler: 'Box hat Müll-Daten geliefert
    Close F(i)
    If LenB(Dir$(App.Path + "\temp\tempsong" + Str$(i) + ".mp", vbDirectory)) <> 0 Then Kill App.Path + "\temp\tempsong" + Str$(i) + ".mp"
    Open Ziel + "\temp\tempsong" + Str(i) + ".mp" For Binary As #F(i)
    first(i) = "0"
    buffer(i) = vbNullString
    hilfsmarke(i) = 1
End Sub
Private Sub dataform_Telnetdata()
    Dim inBuf As String, pos1 As Integer, pos2 As Integer, tempbuf As String

    If Verriegelung = "1" Then Exit Sub
    Dataform.Telnet.GetData inBuf
    If InStr(inBuf, "login") <> 0 Then Dataform.Telnet.SendData login & vbCrLf 'Benutzername
    If InStr(inBuf, "Password") <> 0 Then Dataform.Telnet.SendData pw & vbCrLf 'Passwort
    
    If InStr(inBuf, "audio") <> 0 Then
        apid(SNr) = Mid(inBuf, InStr(1, inBuf, "audio") + 11, 3)         'Audiopid auslesen
        Verriegelung = "1"
    End If
    
    If InStr(inBuf, "channel not found") <> 0 Then
        apid(SNr) = "Error"
        Verriegelung = "1"
    End If
    
    If InStr(inBuf, "#") <> 0 And InStr(inBuf, "/") <> 0 Or InStr(inBuf, ">") <> 0 And InStr(inBuf, "~") <> 0 Then
        Dataform.Telnet.SendData "killall streampes" & vbCrLf
        Connect = "1"
    End If
End Sub
Public Sub Verschieben(SN As Integer)
    Close #F(SN)
    
    If first(SN) = "1" Then
        filena(SN) = Str(Date) + "_" + Left(Str(Time), 2) + "'" + Mid(Str(Time), 4, 2) + "'" + Right(Str(Time), 2) + " - " + plname(SN) + ".mp2"
        If Dir(Ziel + "\Temp\tempsong" + Str(SN) + ".mp", vbDirectory) <> vbNullString Then Name Ziel + "\Temp\tempsong" + Str(SN) + ".mp" As Quelle + "untagged\" + filena(SN) 'Fertigen Song verschieben
        RaiseEvent newsong(filena(SN))
    Else
        If Dir(Ziel + "\temp\tempsong" + Str(SN) + ".mp", vbDirectory) <> vbNullString Then Kill Ziel + "\temp\tempsong" + Str(SN) + ".mp" 'Wenn Song nicht vollständig, dann löschen
    End If
    
    first(SN) = "1"
    F(SN) = FreeFile
    Open Ziel + "\temp\tempsong" + Str(SN) + ".mp" For Binary As #F(SN)
End Sub
Sub init_socks()
    Set Dataform = New Form1
End Sub
