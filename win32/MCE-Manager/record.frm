VERSION 5.00
Begin VB.Form record 
   ClientHeight    =   3195
   ClientLeft      =   5940
   ClientTop       =   4470
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   Begin VB.Timer sptimer 
      Enabled         =   0   'False
      Interval        =   5000
      Left            =   240
      Top             =   240
   End
End
Attribute VB_Name = "record"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private WithEvents Rec As Class
Attribute Rec.VB_VarHelpID = -1
Public Sub recstart()
    Dim filen As String, dirlaenge As Integer, tempzeichen As String, temp As String, i As Integer
        
    Set Rec = New Class
        
    If Werkzeuge.ping(d2set.IP.Text) Then 'Verbindungstest
        frmMain.aufnahmestart.Enabled = "0"
        frmMain.aufnahmestart.ForeColor = &H80000015
        frmMain.Label29.Caption = aktlng
        frmMain.senderauswahl.Enabled = "0"
            
        'playlistname wird bestimmt
        If d2set.db2.value = "1" Then
            For i = 0 To 20
                If frmMain.senderauswahl = d2set.SenderID(i).Text Then filen = plbezeichnung.plID(i).Text
            Next i
        Else
            filen = Mid$(frmMain.senderauswahl.Text, InStr(frmMain.senderauswahl.Text, "- ") + 2)
        End If
        
        If Right$(frmMain.Quelle.Text, 1) <> "\" Then frmMain.Quelle.Text = frmMain.Quelle.Text + "\"
        dirlaenge = Len(frmMain.Quelle.Text) 'länge des Zielpfades wird bestimmt
        i = 0
            
        While i <= dirlaenge 'Hier wird das Zielverzeichnis erstelle falls noch nicht vorhanden
            tempzeichen = Left$(frmMain.Quelle.Text, i) 'ein zeichen wird nach dem anderen ausgelesen
            tempzeichen = Right$(tempzeichen, 1)
            i = i + 1
                
            If tempzeichen = "\" Then 'wenn zeichen ein "\" ist ist ein ordner gefunden
                temp = Left$(frmMain.Quelle.Text, i - 1) 'kompletter pfad wird stück für stück zerlegt
                'z.b.  pfad "c:\aufnahme\audio\" wird in "c:\aufnahme\" als erten teil und "c:\aufnahme\audio"
                'als 2.teil zerlegt (durch while schleife) [Das geht auch einfacher, hab ich später erfahren]
                If LenB(Dir$(temp, vbDirectory)) = 0 And Len(temp) > 3 Then MkDir (temp) 'wenn dir nicht vorhanden dann erstellen
            End If
        Wend
            
        If LenB(Dir$(frmMain.Quelle.Text + "untagged", vbDirectory)) = 0 Then MkDir frmMain.Quelle.Text + "untagged"
        
        'Löschen der Tempsongs
        For i = 1 To 8
            If LenB(Dir$(App.Path + "\temp\tempsong" + Str$(i) + ".mp", vbDirectory)) <> 0 Then Kill App.Path + "\temp\tempsong" + Str$(i) + ".mp" 'temp-Files löschen
        Next i
        
        If d2set.db2.value = "1" Then
            If frmMain.senderauswahl.Text = "Multi-channel 1" Or frmMain.senderauswahl.Text = "Multi-channel 2" Or frmMain.senderauswahl.Text = "Multi-channel 3" Then
                Call transprec
                frmMain.aufnahmestop.Enabled = "1"
                frmMain.aufnahmestop.ForeColor = &H80000018
                Exit Sub
            End If
                
            Rec.init_socks
            Call Rec.daten(d2set.IP.Text, d2set.Port.Text, frmMain.Quelle.Text, frmMain.senderauswahl.Text, filen, d2set.Text45.Text, App.Path, d2set.pw, vbNullString)
            Call Rec.start("0", 1)
            If Aktivierauswahl.plloggeraktiv.value = "1" Then Call OnAir.loggerstart
            Call Rec.start("2", 1)
        Else
            Rec.init_socks
            Call Rec.daten(d2set.IP.Text, d2set.Port.Text, frmMain.Quelle.Text, frmMain.senderauswahl.Text, filen, d2set.Text45.Text, App.Path, d2set.pw, Left$(frmMain.senderauswahl.Text, 3))
            If Aktivierauswahl.plloggeraktiv.value = "1" Then Call OnAir.loggerstart
            Call Rec.start("0", 1)
        End If
        
        frmMain.Label16(0).Caption = frmMain.senderauswahl.Text + ":"
        frmMain.aufnahmestop.Enabled = "1"
        frmMain.aufnahmestop.ForeColor = &H80000018
    Else
        MsgBox "Connection failed"
        Exit Sub
    End If
End Sub
Public Sub recstop()
    Dim i As Integer
    
    If Aktivierauswahl.plloggeraktiv.value = "1" Then Call OnAir.loggerstop
    Call Rec.sto
    frmMain.senderauswahl.Enabled = "1"
    If LenB(Dir$(App.Path + "\temp\tempsong.mp", vbDirectory)) <> 0 Then Kill App.Path + "\temp\tempsong.mp" 'temp-Files löschen
    
    For i = 1 To 8
        frmMain.Label18(i - 1).Caption = vbNullString
        frmMain.Label16(i - 1).Caption = vbNullString
        bufsize(i) = 0
    Next i
    
    frmMain.aufnahmestop.Enabled = "0"
    frmMain.aufnahmestop.ForeColor = &H80000015
    frmMain.aufnahmestart.Enabled = "1"
    frmMain.aufnahmestart.ForeColor = &H80000018
    frmMain.Label29.Caption = deaktlng
    Set Rec = Nothing
End Sub
Private Sub transprec()
    Dim i As Integer, z As Integer, ret As Boolean, z2 As Integer, z1 As Integer
    
    Rec.init_socks
    
    Select Case frmMain.senderauswahl.Text
        Case "Multi-channel 1"
            For i = 0 To 20
                If d2set.T1(i).value = "1" Then z = z + 1
            Next i
        Case "Multi-channel 2"
            For i = 0 To 20
                If d2set.T2(i).value = "1" Then z = z + 1
            Next i
        Case "Multi-channel 3"
            For i = 0 To 20
                If d2set.T3(i).value = "1" Then z = z + 1
            Next i
    End Select
    
    For i = 0 To 20
        If frmMain.senderauswahl.Text = "Multi-channel 1" And d2set.T1(i).value = "1" Or frmMain.senderauswahl.Text = "Multi-channel 2" And d2set.T2(i).value = "1" Or frmMain.senderauswahl.Text = "Multi-channel 3" And d2set.T3(i).value = "1" Then
            frmMain.Label16(z1).Caption = d2set.SenderID(i) + ":"
            z1 = z1 + 1
            
            Select Case z2
                Case Is = z - 1
                    Call Rec.daten(d2set.IP.Text, d2set.Port.Text, frmMain.Quelle.Text, d2set.SenderID(i), d2set.d2setPL(i), d2set.Text45.Text, App.Path, d2set.pw, vbNullString)
                    Call Rec.start("2", z)
                    If Aktivierauswahl.plloggeraktiv.value = "1" Then Call OnAir.loggerstart
                Case Is = 0
                    Call Rec.daten(d2set.IP.Text, d2set.Port.Text, frmMain.Quelle.Text, d2set.SenderID(i), d2set.d2setPL(i), d2set.Text45.Text, App.Path, d2set.pw, vbNullString)
                    Call Rec.start("0", z)
                    z2 = z2 + 1
                Case Is > 0 And z2 > z - 1
                    Call Rec.daten(d2set.IP.Text, d2set.Port.Text, frmMain.Quelle.Text, d2set.SenderID(i), d2set.d2setPL(i), d2set.Text45.Text, App.Path, d2set.pw, vbNullString)
                    Call Rec.start("1", z)
                    z2 = z2 + 1
            End Select
        End If
    Next i
End Sub
Private Sub rec_newsong(newsongfile As String)
    Call Ausgabe.textbox(newsongfile, "Rec")
End Sub
Private Sub sptimer_Timer()
    Unload frmSplash
    sptimer.Enabled = "0"
End Sub
Private Sub rec_addbuffer(size As Long, i As Integer, news As Boolean)
    If news = "1" Then bufsize(i) = 0
    bufsize(i) = bufsize(i) + size
    frmMain.Label18(i - 1).Caption = Str$(format$(bufsize(i) / 1024, "0")) + "kb"
End Sub
