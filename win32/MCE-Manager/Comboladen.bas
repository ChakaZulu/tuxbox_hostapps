Attribute VB_Name = "Comboladen"
Option Explicit
Public Sub comboboxladen()
    Dim i As Integer, pfadlen As Integer, files() As String

    'Dbox2 combo-----------------------------------------------------
    If d2set.db2.Value = "1" Then
        For i = 0 To 20
            frmMain.senderauswahl.AddItem d2set.SenderID(i).Text
        Next i
    Else
        For i = 0 To 20
            frmMain.senderauswahl.AddItem d2set.APidID(i).Text + " - " + plbezeichnung.plID(i).Text
        Next i
        
        frmMain.senderauswahl.AddItem "Multi-channel 1"
        frmMain.senderauswahl.AddItem "Multi-channel 2"
        frmMain.senderauswahl.AddItem "Multi-channel 3"
    End If
    

    For i = 0 To 20
        Genre.genrepl(i) = plbezeichnung.plID(i).Text
        d2set.d2setPL(i) = plbezeichnung.plID(i).Text
        manpl.ManDLPL(i).Caption = plbezeichnung.plID(i).Text
    Next i
        
    'Suche nach lng
    Call Werkzeuge.suche("INI", App.Path + "\sprache\", files(), "1") 'Suchen nach lng files
    pfadlen = Len(App.Path + "\sprache\") 'Pfadlänge wird bestimmt
    
    For i = 1 To UBound(files) - 1 'schleif=Anzahl der gefundenen lng-files
        allgemeine.sprache.AddItem Mid$(files(i), pfadlen + 1, Len(files(i)) - pfadlen - 4) 'Sprachfile in Combobox anzeigen
    Next i
End Sub
