Attribute VB_Name = "Ausgabe"
Option Explicit
Public Sub textbox(filen As String, Optional mark As String)
    If mark = "Rec" Then ' Recording Box aktiv
        With frmMain.RichTextBox2
            If .Text = vbNullString Then
                .Text = filen
            Else
                .Text = .Text + vbCrLf + filen
            End If
            
            .SelLength = Len(.Text)
            .SelColor = &H80000018
            .SelStart = .SelLength - 1
        End With
    Else 'normal
        With frmMain.RichTextBox1
            If .Text = vbNullString Then
                .Text = filen
            Else
                .Text = .Text + vbCrLf + filen
            End If
            
            .SelLength = Len(.Text)
            .SelColor = &H80000018
            .SelStart = .SelLength - 1
        End With
    End If
End Sub
Public Sub info_loeschen()
    With frmMain
        .interprettag.Caption = vbNullString
        .titeltag.Caption = vbNullString
        .Albumtag.Caption = vbNullString
        .genretag.Caption = vbNullString
        .yeartag.Caption = vbNullString
        .Labeltag.Caption = vbNullString
        .mp2size.Caption = vbNullString
        .mp3size.Caption = vbNullString
        .encoderset.Caption = vbNullString
        .akttime.Caption = vbNullString
        .aktdate.Caption = vbNullString
        .mp2zeit.Caption = vbNullString
        .normset.Caption = vbNullString
        .infocount.Caption = vbNullString
        .infoplaylist = vbNullString
    End With
End Sub

