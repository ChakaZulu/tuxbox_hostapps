Attribute VB_Name = "modDBox2"
'-----------------------------------------------------------------------
' <DOC>
' <MODULE>
'
' <NAME>
'   modDBox2.bas
' </NAME>
'
' <DESCRIPTION>
'   Allgemeine Funktionen für NGrab
' </DESCRIPTION>
'
' <NOTES>
' </NOTES>
'
' <COPYRIGHT>
'   Copyright (c) Reinhard Eidelsburger
' </COPYRIGHT>
'
' <AUTHOR>
'   RE
' </AUTHOR>
'
' <HISTORY>
'   04.07.2002 - RE Hinzufügen der Dokumentation
'   26.07.2002 - LYNX Funktionen zur Zeitsyncronisation hinzugefügt
'   31.07.2002 - LYNX OpenURL Funktion und entsprechendes Modul ausgelagert in neue NGrabWinInetFct10.dll
' </HISTORY>
'
' </MODULE>
' </DOC>
'-----------------------------------------------------------------------
Option Explicit

'-----------------------------------------------------------------------
' <DOC>
' <PROCEDURE>
'
' <NAME>
'   GetPid
' </NAME>
'
' <DESCRIPTION>
'   Auslesen der Video und Audio Pid
' </DESCRIPTION>
'
' <AUTHOR>
'   RE
' </AUTHOR>
'
' </PROCEDURE>
' </DOC>
'-----------------------------------------------------------------------

Public Sub getpid(ByVal CHANID As Double, vpid As Integer, apid As Integer)
    
    ' Kanal zappen
    Dim kanal As String
    kanal = gsURLOpen("http://" & goSettings.sItem(NLSDBoxIPAdress) & "/control/zapto?" & CHANID)
    ' Pids
    Dim pid_feld() As String
    Dim pid As String
    Dim x1 As Integer
    
    pid = gsURLOpen("http://" & goSettings.sItem(NLSDBoxIPAdress) & "/control/zapto?getpids")
    pid_feld = Split(pid, vbLf)
       
    If pid <> "" Then
        vpid = pid_feld(0)
        apid = pid_feld(1)
    Else
        MsgBox "Keine vpid + apid vorhanden!!!"
        
    End If
   
End Sub

'-----------------------------------------------------------------------
' <DOC>
' <PROCEDURE>
'
' <NAME>
'   Wait
' </NAME>
'
' <DESCRIPTION>
'   Beliebige Zeiten warten
' </DESCRIPTION>
'
' <AUTHOR>
'   RE
' </AUTHOR>
'
' </PROCEDURE>
' </DOC>
'-----------------------------------------------------------------------
Public Function Wait(aintZeit As Integer, astrInterval As String) As Boolean

' Info         :       astrInterval können folgende Argumente übergeben werden
'
'                      yyyy Jahr
'                      q Quartal
'                      m Monat
'                      y Tag des Jahres
'                      d Tag
'                      w Wochentag
'                      ww Woche
'                      h Stunde
'                      n Minute
'                      s Sekunde

    Dim zeit As Date
    
    On Error GoTo ErrHandler
    
    zeit = Now
    
    While DateDiff(astrInterval, zeit, Now) <= aintZeit
        
        DoEvents
        
    Wend
    
    Wait = True
    
Exit Function

ErrHandler:

Wait = False
    
End Function

