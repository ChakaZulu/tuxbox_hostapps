VERSION 5.00
Object = "{EAB22AC0-30C1-11CF-A7EB-0000C05BAE0B}#1.1#0"; "shdocvw.dll"
Begin VB.Form songtext_download 
   ClientHeight    =   7185
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   8790
   LinkTopic       =   "Form1"
   ScaleHeight     =   7185
   ScaleWidth      =   8790
   StartUpPosition =   3  'Windows-Standard
   Begin SHDocVwCtl.WebBrowser WebBrowser1 
      Height          =   4815
      Left            =   1200
      TabIndex        =   0
      Top             =   1080
      Width           =   5535
      ExtentX         =   9763
      ExtentY         =   8493
      ViewMode        =   0
      Offline         =   0
      Silent          =   0
      RegisterAsBrowser=   0
      RegisterAsDropTarget=   1
      AutoArrange     =   0   'False
      NoClientEdge    =   0   'False
      AlignLeft       =   0   'False
      NoWebView       =   0   'False
      HideFileNames   =   0   'False
      SingleClick     =   0   'False
      SingleSelection =   0   'False
      NoFolders       =   0   'False
      Transparent     =   0   'False
      ViewID          =   "{0057D0E0-3573-11CF-AE69-08002B2E1262}"
      Location        =   ""
   End
End
Attribute VB_Name = "songtext_download"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Public Function songt(ByVal band As String, ByVal songname As String) As String
    Dim songtext As String, position As Long, backtit As String
    
    backtit = songname
    songt = vbNullString
    
    'Leerzeichen mit "+" ersetzten
    songname = Replace(songname, " ", "+")
    band = Replace(band, " ", "+")
    
    songtext_download.WebBrowser1.Tag = "Load"
    songtext_download.WebBrowser1.Navigate "http://www.lyricsdot.ru/search.html?band=" + band + "&album=&song=" + songname + "&match=perfect" 'HP anw�hlen

    'Warten bis fertiggeladen
    While songtext_download.WebBrowser1.Tag = "Load"
        DoEvents
    Wend
    
    'Quelltext auslesen
    songtext = songtext_download.WebBrowser1.Document.documentElement.outerhtml
    songtext_download.WebBrowser1.Refresh
    
    'Wenn mehrere identische Songtexte vorhanden sind
    If InStr(1, songtext, "<TD vAlign=top align=left><SPAN class=text><BR>", vbTextCompare) = 0 Then
        position = InStrRev(songtext, backtit, , vbTextCompare)
        
        If position = 0 Then
            backtit = Replace$(backtit, "�", "'")
            backtit = Trim$(Replace$(backtit, "?", " "))
            position = InStrRev(songtext, backtit, , vbTextCompare)
            If position = 0 Then Exit Function
        End If
        
        songtext = Mid$(songtext, 1, position - 3)
        
        position = InStrRev(songtext, "id", , vbTextCompare)
        If position = 0 Then Exit Function
        songtext = Mid$(songtext, position)
        
        
        WebBrowser1.Tag = "Load"
        
        'Letzten Songtext ausw�hlen
        songtext_download.WebBrowser1.Navigate "http://www.lyricsdot.ru/lyrics/" + songtext
        
        While songtext_download.WebBrowser1.Tag = "Load"
            DoEvents
        Wend
        
        'Quelltext erneut auslesen
        songtext = WebBrowser1.Document.documentElement.outerhtml
    End If
    
    'Ungef�hre Position des Songtextanfangs wird bestimmt (Einmalige Kombination im Quelltext)
    position = InStr(1, songtext, "<TD vAlign=top align=left><SPAN class=text><BR>", vbTextCompare)
    songtext = Mid$(songtext, position + 2, Len(songtext)) 'Songtext (Quelltext) schneiden
    songtext = songtext_download.HTML2Text(songtext) 'Songtext (HTML) in TXT konvertieren
    position = InStr(songtext, Chr(13)) '"Enter" suchen
    songtext = Mid$(songtext, position + 2, Len(songtext)) 'Endg�ltiger Anfang des Sontextes wird bestimmt
    If InStr(songtext, "Nothing found") <> 0 Then Exit Function  '�berpr�fung, ob kein Songtext vorhanden, sondern "Nothing" HP
    position = InStrRev(songtext, "Rating", , vbTextCompare) 'Ende des Songtextes wird bestimmt (ungef�hr)
    songtext = Mid$(songtext, 1, position) 'Schneiden
    position = InStrRev(songtext, Chr(13)) 'Endg�ltiges Ende
    If position = 0 Then Exit Function
    songtext = Mid$(songtext, 1, position - 1) 'schneiden
    songt = songtext
End Function
Private Sub WebBrowser1_DocumentComplete(ByVal pDisp As Object, URL As Variant)
    songtext_download.WebBrowser1.Tag = ""
End Sub
Public Function HTML2Text(ByVal OrigHTML As String, Optional ByVal ImgText As String = vbNullString) As String
    Dim CurrChar As String, NoHTML As String, hRef As String, x As Integer, z As Integer, imgFile As String, imgAlt As String, Params As String, BlockQuote As Boolean
  
    If InStr(LCase$(OrigHTML), "<body") > 0 Then
        OrigHTML = Mid$(OrigHTML, InStr(LCase$(OrigHTML), "<body"))
        OrigHTML = Mid$(OrigHTML, InStr(OrigHTML, ">") + 1)
    If InStr(LCase$(OrigHTML), "</body>") > 0 Then OrigHTML = Left$(OrigHTML, InStr(LCase$(OrigHTML), "</body>") - 1)
    End If

    ' HTML-Text zeichenweise "scannen"
    Do While Len(OrigHTML)
        DoEvents
        CurrChar = Left$(OrigHTML, 1)
        OrigHTML = Mid$(OrigHTML, 2)
        Select Case CurrChar
        Case " "
            OrigHTML = LTrim$(OrigHTML)
        Case vbCr, vbLf
            If Right$(NoHTML, 1) <> " " And Right$(NoHTML, 2) <> vbCrLf Then CurrChar = " " Else CurrChar = vbNullString
            If Left$(OrigHTML, 1) = vbLf Then OrigHTML = Mid$(OrigHTML, 2)
            OrigHTML = LTrim$(OrigHTML)
            
        ' HTML-Steuerzeichen
        Case "<"
        CurrChar = vbNullString
        If InStr(OrigHTML, ">") > 0 Then
            CurrChar = Left$(OrigHTML, InStr(OrigHTML, ">") - 1)
            OrigHTML = Mid$(OrigHTML, InStr(OrigHTML, ">") + 1)
    
            If InStr(CurrChar, " ") > 0 Then
                Params = ReplaceChars(Trim$(Mid$(CurrChar, InStr(CurrChar, " ") + 1)), vbCrLf, vbNullString)
                CurrChar = Left$(CurrChar, InStr(CurrChar, " ") - 1)
            Else
                    Params = vbNullString
            End If
            Dim ParamColl As Collection
    
            Select Case LCase$(CurrChar)
                Case "p"
                    If Right$(NoHTML, 4) <> vbCrLf & vbCrLf Then CurrChar = vbCrLf & vbCrLf Else CurrChar = vbNullString
                Case "/div"
                    If Right$(NoHTML, 2) <> vbCrLf Then CurrChar = vbCrLf Else CurrChar = vbNullString
                Case "br"
                    CurrChar = vbCrLf
                Case "ul", "/ul", "ol", "/ol"
                    CurrChar = vbCrLf
                Case "li"
                    CurrChar = vbCrLf & "   - "
                Case "blockquote"
                    BlockQuote = "1"
                    CurrChar = vbNullString
                Case "/blockquote"
                    BlockQuote = "0"
                    CurrChar = vbNullString
                Case "img"
              If Len(ImgText) > 0 Then
                Set ParamColl = StripByCharAndQuotes(Params, " ")
                imgAlt = vbNullString
                imgFile = vbNullString
                For z = 1 To ParamColl.Count
                  If LCase$(Left$(ParamColl(z), 4)) = "src=" Then
                    imgFile = StripQuotes(Mid$(ParamColl(z), 5))
                  ElseIf LCase$(Left$(ParamColl(z), 4)) = "alt=" Then
                    imgAlt = StripQuotes(Mid$(ParamColl(z), 5))
                  End If
                  If Len(imgAlt) > 0 And Len(imgFile) > 0 Then Exit For
                Next
                If Len(Trim$(imgAlt)) = 0 Then imgAlt = "Image " & imgFile
                ImgText = ReplaceChars(ImgText, "%imgalt", imgAlt)
                ImgText = ReplaceChars(ImgText, "%imgsrc", imgFile)

                CurrChar = " " & ImgText & " "
              Else
                CurrChar = vbNullString
              End If
            Case "a"
              Set ParamColl = StripByCharAndQuotes(Params, " ")
              hRef = vbNullString
              For z = 1 To ParamColl.Count
                If LCase$(Left$(ParamColl(z), 5)) = "href=" Then
                  hRef = StripQuotes(Mid$(ParamColl(z), 6))
                  Exit For
                End If
              Next
              CurrChar = vbNullString
            Case "/a"
              CurrChar = vbNullString
              If Len(Trim$(hRef)) > 0 Then
                If LCase$(Left$(hRef, 7)) = "mailto:" Then hRef = Mid$(hRef, 8)
                If LCase$(Right$(Trim$(NoHTML), Len(hRef))) <> LCase$(hRef) Then
                  If Not (LCase$(Left$(hRef, 7)) = "http://" And LCase$(Right$(Trim$(NoHTML), Len(hRef) - 7)) = LCase$(Mid$(hRef, 8))) Then
                    CurrChar = " [" & hRef & "]"
                    hRef = vbNullString
                  End If
                End If
              End If
            Case "hr"
              CurrChar = vbCrLf
              For x = 1 To 70
                CurrChar = CurrChar & "-"
              Next
              CurrChar = CurrChar & vbCrLf
            Case "sigboundary"
              CurrChar = vbCrLf & "-- " & vbCrLf
            Case "script"
              CurrChar = vbNullString
              If InStr(LCase$(OrigHTML), "</script>") > 0 Then OrigHTML = Mid$(OrigHTML, InStr(LCase$(OrigHTML), "</script>"))
            Case "pre"
              CurrChar = vbCrLf
              If InStr(LCase$(OrigHTML), "</pre>") > 0 Then
                CurrChar = CurrChar & Left$(OrigHTML, InStr(LCase$(OrigHTML), "</pre>") - 1)
                OrigHTML = Mid$(OrigHTML, InStr(LCase$(OrigHTML), "</pre>"))
              End If
              CurrChar = CurrChar & vbCrLf
            Case Else
              CurrChar = vbNullString
          End Select
        End If
      Case "&"
        If InStr(OrigHTML, ";") > 0 And (InStr(OrigHTML, ";") < InStr(OrigHTML, " ") Or InStr(OrigHTML, " ") = 0) Then
          CurrChar = Left$(OrigHTML, InStr(OrigHTML, ";") - 1)
          OrigHTML = Mid$(OrigHTML, InStr(OrigHTML, ";") + 1)

          Select Case CurrChar
            Case "amp"
              CurrChar = "&"
            Case "quot"
              CurrChar = """"
            Case "lt"
              CurrChar = "<"
            Case "gt"
              CurrChar = ">"
            Case "nbsp"
              CurrChar = " "
            Case "Auml"
              CurrChar = "�"
            Case "auml"
              CurrChar = "�"
            Case "iexcl"
              CurrChar = "�"
            Case "cent"
              CurrChar = "�"
            Case "pound"
              CurrChar = "�"
            Case "curren"
              CurrChar = "�"
            Case "yen"
              CurrChar = "�"
            Case "brvbar"
              CurrChar = "|"
            Case "sect"
              CurrChar = "�"
            Case "uml"
              CurrChar = "�"
            Case "copy"
              CurrChar = "�"
            Case "ordf"
              CurrChar = "�"
            Case "laquo"
              CurrChar = "�"
            Case "not"
              CurrChar = "�"
            Case "reg"
              CurrChar = "�"
            Case "macr"
              CurrChar = "�"
            Case "deg"
              CurrChar = "�"
            Case "plusm"
              CurrChar = "�"
            Case "sup2"
              CurrChar = "�"
            Case "sup3"
              CurrChar = "�"
            Case "acute"
              CurrChar = "�"
            Case "micro"
              CurrChar = "�"
            Case "para"
              CurrChar = "�"
            Case "middot"
              CurrChar = "�"
            Case "cedil"
              CurrChar = "�"
            Case "sup1"
              CurrChar = "�"
            Case "ordm"
              CurrChar = "�"
            Case "raquo"
              CurrChar = "�"
            Case "frac14"
              CurrChar = "�"
            Case "frac12"
              CurrChar = "�"
            Case "frac34"
              CurrChar = "�"
            Case "iquest"
              CurrChar = "�"
            Case "Agrave"
              CurrChar = "�"
            Case "Aacute"
              CurrChar = "�"
            Case "Acirc"
              CurrChar = "�"
            Case "Atilde"
              CurrChar = "�"
            Case "Aring"
              CurrChar = "�"
            Case "AElig"
              CurrChar = "�"
            Case "Ccedil"
              CurrChar = "�"
            Case "Egrave"
              CurrChar = "�"
            Case "Eacute"
              CurrChar = "�"
            Case "Ecirc"
              CurrChar = "�"
            Case "Euml"
              CurrChar = "�"
            Case "Igrave"
              CurrChar = "�"
            Case "Iacute"
              CurrChar = "�"
            Case "Icirc"
              CurrChar = "�"
            Case "Iuml"
              CurrChar = "�"
            Case "ETH"
              CurrChar = "�"
            Case "Ntilde"
              CurrChar = "�"
            Case "Ograve"
              CurrChar = "�"
            Case "Oacute"
              CurrChar = "�"
            Case "Ocirc"
              CurrChar = "�"
            Case "Otilde"
              CurrChar = "�"
            Case "Ouml"
              CurrChar = "�"
            Case "times"
              CurrChar = "�"
            Case "Oslash"
              CurrChar = "�"
            Case "Ugrave"
              CurrChar = "�"
            Case "Uacute"
              CurrChar = "�"
            Case "Ucirc"
              CurrChar = "�"
            Case "Uuml"
              CurrChar = "�"
            Case "Yacute"
              CurrChar = "�"
            Case "THORN"
              CurrChar = "�"
            Case "szlig"
              CurrChar = "�"
            Case "agrave"
              CurrChar = "�"
            Case "aacute"
              CurrChar = "�"
            Case "acirc"
              CurrChar = "�"
            Case "atilde"
              CurrChar = "�"
            Case "aring"
              CurrChar = "�"
            Case "aelig"
              CurrChar = "�"
            Case "ccedil"
              CurrChar = "�"
            Case "egrave"
              CurrChar = "�"
            Case "eacute"
              CurrChar = "�"
            Case "ecirc"
              CurrChar = "�"
            Case "euml"
              CurrChar = "�"
            Case "igrave"
              CurrChar = "�"
            Case "iacute"
              CurrChar = "�"
            Case "icirc"
              CurrChar = "�"
            Case "iuml"
              CurrChar = "�"
            Case "eth"
              CurrChar = "�"
            Case "ntilde"
              CurrChar = "�"
            Case "ograve"
              CurrChar = "�"
            Case "oacute"
              CurrChar = "�"
            Case "ocirc"
              CurrChar = "�"
            Case "otilde"
              CurrChar = "�"
            Case "ouml"
              CurrChar = "�"
            Case "divide"
              CurrChar = "�"
            Case "oslash"
              CurrChar = "�"
            Case "ugrave"
              CurrChar = "�"
            Case "uacute"
              CurrChar = "�"
            Case "ucirc"
              CurrChar = "�"
            Case "uuml"
              CurrChar = "�"
            Case "yacute"
              CurrChar = "�"
            Case "thorn"
              CurrChar = "�"
            Case "yuml"
              CurrChar = "�"
            Case Else
              CurrChar = "&" & CurrChar & ";"
          End Select
        End If
    End Select
    If Right$(CurrChar, 2) = vbCrLf And BlockQuote Then CurrChar = CurrChar & "> "
    NoHTML = NoHTML & CurrChar
  Loop

  NoHTML = Trim$(NoHTML)

  Do While Left$(NoHTML, 2) = vbCrLf
    NoHTML = Trim$(Mid$(NoHTML, 3))
  Loop
  Do While Right$(NoHTML, 2) = vbCrLf
    NoHTML = Trim$(Left$(NoHTML, Len(NoHTML) - 2))
  Loop
  
  HTML2Text = NoHTML
  Set ParamColl = Nothing
End Function
Public Function ReplaceChars(ByVal OrgString As String, ByVal ToReplace As String, ByVal ToInsert As String) As String
    Dim ST As Long, newst As Long
    
    ST = 0
    
    Do While InStr(ST + 1, LCase$(OrgString), LCase$(ToReplace)) <> 0
        newst = InStr(ST + 1, LCase$(OrgString), LCase$(ToReplace))
        OrgString = Left$(OrgString, InStr(ST + 1, LCase$(OrgString), LCase$(ToReplace)) - 1) & ToInsert & Mid$(OrgString, InStr(ST + 1, LCase$(OrgString), LCase$(ToReplace)) + Len(ToReplace))
        ST& = newst + Len(ToInsert) - 1
    Loop
    
    ReplaceChars = OrgString
End Function
Function StripByCharAndQuotes(ByVal OrgString As String, StripChar As String) As Collection
    Dim Scoll As Collection, x As Long, y As Long
  
    Set Scoll = New Collection
    
    Do
        x = InStr(OrgString, StripChar)
        y = InStr(OrgString, Chr(34))
    
        If y > 0 And y < x Then
            y = InStr(y + 1, OrgString, Chr(34))
            Do While y > x And y > 0 And x > 0
                x = InStr(x + 1, OrgString, StripChar)
            Loop
        End If
    
        If x > 0 Then
            Scoll.Add Left$(OrgString, x - 1)
            OrgString = Mid$(OrgString, x + 1)
        Else
            Scoll.Add OrgString
            OrgString = vbNullString
        End If
    Loop While Len(OrgString) > 0

    Set StripByCharAndQuotes = Scoll
    Set Scoll = Nothing
End Function
Private Function StripQuotes(ByVal sText As String) As String
    If Left$(sText, 1) = Chr(34) Then sText = Mid$(sText, 2)
    If Right$(sText, 1) = Chr(34) Then sText = Left$(sText, Len(sText) - 1)
End Function
