Attribute VB_Name = "Verriegelung"
Option Explicit
Public Function verriegelungein() As Boolean
    Dim tempzeichen As String, i As Integer, mdir As String, oggtemp As Boolean, mp2temp As Boolean, mp3temp As Boolean, notemp As Boolean
    
    i = 1
    
    '�berpr�fung ob quellpfad vorhanden
    If LenB(Dir$(frmMain.Quelle.Text, vbDirectory)) = 0 Or frmMain.Quelle.Text = frmMain.Ziel.Text Or frmMain.work.Text = frmMain.Ziel.Text Or frmMain.Quelle.Text = frmMain.work.Text Then 'wenn Quelle nicht vorhanden, oder ident mit Ziel dann abbrechen
        verriegelungein = "1"
        Exit Function
    End If
    
    '�berpr�fung ob pfad korrekt
    frmMain.Quelle.Text = Trim$(frmMain.Quelle.Text)
    frmMain.Ziel.Text = Trim$(frmMain.Ziel.Text)
    frmMain.work.Text = Trim$(frmMain.work.Text)
    If Right$(frmMain.Quelle.Text, 1) <> "\" Then frmMain.Quelle.Text = frmMain.Quelle.Text + "\"
    If Right$(frmMain.Ziel.Text, 1) <> "\" Then frmMain.Ziel.Text = frmMain.Ziel.Text + "\"
    If Right$(frmMain.work.Text, 1) <> "\" Then frmMain.work.Text = frmMain.work.Text + "\"
    
    'Zielverzeichnis erstellen
    While i <= Len(frmMain.Ziel.Text) 'Hier wird das Zielverzeichnis erstelle falls noch nicht vorhanden
        tempzeichen = Left$(frmMain.Ziel.Text, i) 'ein zeichen wird nach dem anderen ausgelesen
        tempzeichen = Right$(tempzeichen, 1)
        i = i + 1
        
        If tempzeichen = "\" Then 'wenn zeichen ein "\" ist ist ein ordner gefunden
            mdir = Left$(frmMain.Ziel.Text, i - 1) 'kompletter pfad wird st�ck f�r st�ck zerlegt
            'z.b.  pfad "c:\aufnahme\audio\" wird in "c:\aufnahme\" als erten teil und "c:\aufnahme\audio"
            'als 2.teil zerlegt (durch while schleife) [Das geht auch einfacher, hab ich sp�ter erfahren]
            If LenB(Dir$(mdir, vbDirectory)) = 0 And Len(mdir) > 3 Then MkDir (mdir) 'wenn dir nicht vorhanden dann erstellen
        End If
    Wend
    
    i = 1
    
    'Workverzeichnis erstellen
    While i <= Len(frmMain.work.Text) 'Hier wird das Zielverzeichnis erstelle falls noch nicht vorhanden
        tempzeichen = Left$(frmMain.work.Text, i) 'ein zeichen wird nach dem anderen ausgelesen
        tempzeichen = Right$(tempzeichen, 1)
        i = i + 1
        
        If tempzeichen = "\" Then 'wenn zeichen ein "\" ist ist ein ordner gefunden
            mdir = Left$(frmMain.work.Text, i - 1) 'kompletter pfad wird st�ck f�r st�ck zerlegt
            'z.b.  pfad "c:\aufnahme\audio\" wird in "c:\aufnahme\" als erten teil und "c:\aufnahme\audio"
            'als 2.teil zerlegt (durch while schleife) [Das geht auch einfacher, hab ich sp�ter erfahren]
            If LenB(Dir$(mdir, vbDirectory)) = 0 And Len(mdir) > 3 Then MkDir (mdir) 'wenn dir nicht vorhanden dann erstellen
        End If
    Wend
    
    If LenB(Dir$(frmMain.work.Text + "MP3-Sort", vbDirectory)) = 0 Then MkDir frmMain.work.Text + "MP3-Sort"
    
    With frmMain
        .Timer1.Enabled = "0"
        .qsuchen.Enabled = "0"
        .qsuchen.ForeColor = &H80000015 'Buttonfarbe �ndern
        .zsuchen.Enabled = "0"
        .zsuchen.ForeColor = &H80000015 'Buttonfarbe �ndern
        .wsuchen.Enabled = "0"
        .wsuchen.ForeColor = &H80000015 'Buttonfarbe �ndern
        .start.Enabled = "0"
        .start.ForeColor = &H80000015 'Buttonfarbe �ndern
        .untaggedtaggen.Enabled = "0"
        .untaggedtaggen.ForeColor = &H80000015 'Buttonfarbe �ndern
        .Nachsortierung.Enabled = "0"
        .Nachsortierung.ForeColor = &H80000015 'Buttonfarbe �ndern
        .aktivir_menu.Enabled = "0"
        .command1.Enabled = "0"
        .command1.ForeColor = &H80000015 'Buttonfarbe �ndern
        .Quelle.Enabled = "0" 'Button abschalten
        .Ziel.Enabled = "0" 'Button abschalten
        .work.Enabled = "0" 'Button abschalten
        .Sortstatus.value = 0   'R�cksetzten des Anzeigebalkens
        .statuscon.value = 0 'R�cksetzten des Anzeigebalkens
        .statusnachtag.value = 0 'R�cksetzten des Anzeigebalkens
        .allgemein_menu.Enabled = "0" 'Allgemeine Men� sperren
        .oggextension.Enabled = 0
        .mp2extension.Enabled = 0
        .mp3extension.Enabled = 0
        .noextension.Enabled = 0
        .mnu_db.Enabled = "0"
    End With
    
    timeSeconds = 0 'R�cksetzten
    timeMinutes = 0 'R�cksetzten
    timehours = 0 'R�cksetzten
    timedays = 0 'R�cksetzten
    Werkzeuge.DisableClose (frmMain.hWnd)
End Function
Public Sub verriegelungaus()
    Dim i As Integer, files() As String
    
    With frmMain
        .start.Enabled = "1"
        .untaggedtaggen.Enabled = "1"
        .Nachsortierung.Enabled = "1"
        .aktivir_menu.Enabled = "1"
        .Ziel.Enabled = "1" 'r�cksetzten
        .work.Enabled = "1" 'r�cksetzten
        .start.Appearance = 15 'Buttonschema wechseln
        .start.ForeColor = &H80000018 'Buttonfarbe �ndern
        .untaggedtaggen.Appearance = 15 'Buttonschema wechseln
        .untaggedtaggen.ForeColor = &H80000018
        .Nachsortierung.Appearance = 15  'Buttonschema wechseln
        .Nachsortierung.ForeColor = &H80000018
        .allgemein_menu.Enabled = "1" 'Allgemeine Men� freigeben
        .Abbrechen.Appearance = 15 'Buttonschema wechseln
        .Abbrechen.ForeColor = &H80000018 'Buttonfarbe �ndern
        .Abbrechen.Enabled = "1"
        .command1.ForeColor = &H80000018 'Buttonfarbe �ndern
        .command1.Enabled = "1"
        
        If frmMain.aufnahmestart.Enabled = "1" Then
            .Quelle.Enabled = "1" 'r�cksetzten
            .qsuchen.Enabled = "1"
            .qsuchen.ForeColor = &H80000018 'Buttonfarbe �ndern
        End If
        
        .zsuchen.Enabled = "1"
        .zsuchen.ForeColor = &H80000018 'Buttonfarbe �ndern
        .wsuchen.Enabled = "1"
        .wsuchen.ForeColor = &H80000018 'Buttonfarbe �ndern
        .oggextension.Enabled = "1"
        .mp2extension.Enabled = "1"
        .mp3extension.Enabled = "1"
        .noextension.Enabled = "1"
        .mnu_db.Enabled = "1"
    End With
    
    If Aktivierauswahl.scan_aktiv.value = "1" Then frmMain.Timer1.Enabled = "1"
    i = 0
    If LenB(Dir$(frmMain.work.Text + "temp.wav", vbDirectory)) <> 0 Then Kill (frmMain.work.Text + "temp.wav")
    Call Werkzeuge.suche("TXT", frmMain.work.Text, files(), "1")
    
    While i < UBound(files) - 1
        i = i + 1
        If LenB(Dir$(files(i), vbDirectory)) <> 0 Then Kill files(i)
    Wend
    
    Werkzeuge.enableClose (frmMain.hWnd)
End Sub
