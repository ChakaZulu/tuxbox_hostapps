VERSION 5.00
Object = "{EAB22AC0-30C1-11CF-A7EB-0000C05BAE0B}#1.1#0"; "shdocvw.dll"
Begin VB.Form songtext_download 
   Caption         =   "Form1"
   ClientHeight    =   3195
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows-Standard
   Begin SHDocVwCtl.WebBrowser WebBrowser1 
      Height          =   2535
      Left            =   480
      TabIndex        =   0
      Top             =   360
      Width           =   3495
      ExtentX         =   6165
      ExtentY         =   4471
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
Option Compare Text
Public Function songt(band As String, titel As String)
Dim band As String
Dim titel As String
titel = Replace(titel, " ", "+")
band = Replace(band, " ", "+")
Dim Songtext As String
Dim position As Long

WebBrowser1.tag = "Load"
WebBrowser1.Navigate "http://www.lyricsdot.ru/search.html?band=" + band + "&album=&song=" + titel + "&match=perfect"

While WebBrowser1.tag = "Load"
    DoEvents
Wend

Songtext = WebBrowser1.Document.documentElement.outerHTML
If InStr(Songtext, "Page 1") <> 0 Then
    position = InStrRev(Songtext, Text1.Text)
    Songtext = Mid(Songtext, 1, position - 3)
    position = InStrRev(Songtext, "id")
    Songtext = Mid(Songtext, position)
    
    WebBrowser1.tag = "Load"
    
    
    
    WebBrowser1.Navigate "http://www.lyricsdot.ru/search.html?" + Songtext
    
    While WebBrowser1.tag = "Load"
        DoEvents
    Wend
    
    Songtext = WebBrowser1.Document.documentElement.outerHTML
End If

position = InStr(Songtext, "<TD vAlign=top align=left><SPAN class=text><BR>")
Songtext = Mid(Songtext, position + 2, Len(Songtext))
Songtext = HTML2Text(Songtext)
position = InStr(Songtext, Chr(13))
Songtext = Mid(Songtext, position + 2, Len(Songtext))
If InStr(Songtext, "Nothing found") <> 0 Then Exit Function
position = InStrRev(Songtext, "Rating")
Songtext = Mid(Songtext, 1, position)
position = InStrRev(Songtext, Chr(13))
Songtext = Mid(Songtext, 1, position - 1)

Open "c:\1.txt" For Output As #1
    Print #1, Songtext
Close #1

End Function

Private Sub WebBrowser1_DocumentComplete(ByVal pDisp _
  As Object, URL As Variant)
  On Error Resume Next
  WebBrowser1.tag = ""
End Sub



Public Function HTML2Text(ByVal OrigHTML As String, _
  Optional ByVal ImgText As String = "") As String

  ' ImgText: Text, der statt Bildern eingefügt wird.
  '         Sonderinhalte: %imgsrc für Bilddateiname
  '                        %imgalt für Alt-Text

  Dim CurrChar As String
  Dim NoHTML As String
  Dim hRef As String
  Dim x As Integer
  Dim z As Integer
  Dim imgFile As String
  Dim imgAlt As String
  Dim Params As String
  Dim BlockQuote As Boolean
  
  On Error Resume Next
  
  ' Prüfen, ob -Tag vorhanden
  ' wenn ja befindet sich der relevante HTML-Teil
  ' zwischen <BODY> und </BODY>
  If InStr(LCase$(OrigHTML), "<body") > 0 Then
    OrigHTML = Mid$(OrigHTML, InStr(LCase$(OrigHTML), "<body"))
    OrigHTML = Mid$(OrigHTML, InStr(OrigHTML, ">") + 1)
    If InStr(LCase$(OrigHTML), "</body>") > 0 Then _
      OrigHTML = Left$(OrigHTML, InStr(LCase$(OrigHTML), _
      "</body>") - 1)
  End If

  ' HTML-Text zeichenweise "scannen"
  Do While Len(OrigHTML)
    CurrChar = Left$(OrigHTML, 1)
    OrigHTML = Mid$(OrigHTML, 2)
    Select Case CurrChar
      Case " "
        OrigHTML = LTrim$(OrigHTML)
      Case vbCr, vbLf
        If Right$(NoHTML, 1) <> " " And _
          Right$(NoHTML, 2) <> vbCrLf Then _
          CurrChar = " " Else CurrChar = ""
        If Left$(OrigHTML, 1) = vbLf Then _
          OrigHTML = Mid$(OrigHTML, 2)
        OrigHTML = LTrim$(OrigHTML)
        
      ' HTML-Steuerzeichen
      Case "<"
        CurrChar = ""
        If InStr(OrigHTML, ">") > 0 Then
          CurrChar = Left$(OrigHTML, InStr(OrigHTML, ">") - 1)
          OrigHTML = Mid$(OrigHTML, InStr(OrigHTML, ">") + 1)

          If InStr(CurrChar, " ") > 0 Then
            Params = ReplaceChars(Trim$(Mid$(CurrChar, _
              InStr(CurrChar, " ") + 1)), vbCrLf, "")
            CurrChar = Left$(CurrChar, InStr(CurrChar, " ") - 1)
          Else
            Params = ""
          End If
          Dim ParamColl As Collection

          Select Case LCase$(CurrChar)
            Case "p"
              If Right$(NoHTML, 4) <> vbCrLf & vbCrLf Then _
                CurrChar = vbCrLf & vbCrLf Else CurrChar = ""
            Case "/div"
              If Right$(NoHTML, 2) <> vbCrLf Then _
                CurrChar = vbCrLf Else CurrChar = ""
            Case "br"
              CurrChar = vbCrLf
            Case "ul", "/ul", "ol", "/ol"
              CurrChar = vbCrLf
            Case "li"
              CurrChar = vbCrLf & "   - "
            Case "blockquote"
              BlockQuote = True
              CurrChar = ""
            Case "/blockquote"
              BlockQuote = False
              CurrChar = ""
            Case "img"
              If Len(ImgText) > 0 Then
                Set ParamColl = StripByCharAndQuotes(Params, " ")
                imgAlt = ""
                imgFile = ""
                For z = 1 To ParamColl.count
                  If LCase$(Left$(ParamColl(z), 4)) = "src=" Then
                    imgFile = StripQuotes(Mid$(ParamColl(z), 5))
                  ElseIf LCase$(Left$(ParamColl(z), 4)) = "alt=" Then
                    imgAlt = StripQuotes(Mid$(ParamColl(z), 5))
                  End If
                  If Len(imgAlt) > 0 And Len(imgFile) > 0 Then Exit For
                Next
                If Len(Trim$(imgAlt)) = 0 Then _
                  imgAlt = "Image " & imgFile
                ImgText = ReplaceChars(ImgText, "%imgalt", imgAlt)
                ImgText = ReplaceChars(ImgText, "%imgsrc", imgFile)

                CurrChar = " " & ImgText & " "
              Else
                CurrChar = ""
              End If
            Case "a"
              Set ParamColl = StripByCharAndQuotes(Params, " ")
              hRef = ""
              For z = 1 To ParamColl.count
                If LCase$(Left$(ParamColl(z), 5)) = "href=" Then
                  hRef = StripQuotes(Mid$(ParamColl(z), 6))
                  Exit For
                End If
              Next
              CurrChar = ""
            Case "/a"
              CurrChar = ""
              If Len(Trim$(hRef)) > 0 Then
                If LCase$(Left$(hRef, 7)) = "mailto:" Then _
                  hRef = Mid$(hRef, 8)
                If LCase$(Right$(Trim$(NoHTML), _
                  Len(hRef))) <> LCase$(hRef) Then
                  If Not (LCase$(Left$(hRef, 7)) = "http://" And _
                   LCase$(Right$(Trim$(NoHTML), _
                   Len(hRef) - 7)) = LCase$(Mid$(hRef, 8))) Then
                    CurrChar = " [" & hRef & "]"
                    hRef = ""
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
              CurrChar = ""
              If InStr(LCase$(OrigHTML), "</script>") > 0 Then _
                OrigHTML = Mid$(OrigHTML, InStr(LCase$(OrigHTML), _
                  "</script>"))
            Case "pre"
              CurrChar = vbCrLf
              If InStr(LCase$(OrigHTML), "</pre>") > 0 Then
                CurrChar = CurrChar & Left$(OrigHTML, _
                  InStr(LCase$(OrigHTML), "</pre>") - 1)
                OrigHTML = Mid$(OrigHTML, InStr(LCase$(OrigHTML), _
                  "</pre>"))
              End If
              CurrChar = CurrChar & vbCrLf
            Case Else
              CurrChar = ""
          End Select
        End If
      Case "&"
        If InStr(OrigHTML, ";") > 0 And (InStr(OrigHTML, ";") < _
          InStr(OrigHTML, " ") Or InStr(OrigHTML, " ") = 0) Then
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
              CurrChar = "Ä"
            Case "auml"
              CurrChar = "ä"
            Case "iexcl"
              CurrChar = "¡"
            Case "cent"
              CurrChar = "¢"
            Case "pound"
              CurrChar = "£"
            Case "curren"
              CurrChar = "¤"
            Case "yen"
              CurrChar = "¥"
            Case "brvbar"
              CurrChar = "|"
            Case "sect"
              CurrChar = "§"
            Case "uml"
              CurrChar = "¨"
            Case "copy"
              CurrChar = "©"
            Case "ordf"
              CurrChar = "ª"
            Case "laquo"
              CurrChar = "«"
            Case "not"
              CurrChar = "¬"
            Case "reg"
              CurrChar = "®"
            Case "macr"
              CurrChar = "¯"
            Case "deg"
              CurrChar = "°"
            Case "plusm"
              CurrChar = "±"
            Case "sup2"
              CurrChar = "²"
            Case "sup3"
              CurrChar = "³"
            Case "acute"
              CurrChar = "´"
            Case "micro"
              CurrChar = "µ"
            Case "para"
              CurrChar = "¶"
            Case "middot"
              CurrChar = "·"
            Case "cedil"
              CurrChar = "¸"
            Case "sup1"
              CurrChar = "¹"
            Case "ordm"
              CurrChar = "º"
            Case "raquo"
              CurrChar = "»"
            Case "frac14"
              CurrChar = "¼"
            Case "frac12"
              CurrChar = "½"
            Case "frac34"
              CurrChar = "¾"
            Case "iquest"
              CurrChar = "¿"
            Case "Agrave"
              CurrChar = "À"
            Case "Aacute"
              CurrChar = "Á"
            Case "Acirc"
              CurrChar = "Â"
            Case "Atilde"
              CurrChar = "Ã"
            Case "Aring"
              CurrChar = "Å"
            Case "AElig"
              CurrChar = "Æ"
            Case "Ccedil"
              CurrChar = "Ç"
            Case "Egrave"
              CurrChar = "È"
            Case "Eacute"
              CurrChar = "É"
            Case "Ecirc"
              CurrChar = "Ê"
            Case "Euml"
              CurrChar = "Ë"
            Case "Igrave"
              CurrChar = "Ì"
            Case "Iacute"
              CurrChar = "Í"
            Case "Icirc"
              CurrChar = "Î"
            Case "Iuml"
              CurrChar = "Ï"
            Case "ETH"
              CurrChar = "Ð"
            Case "Ntilde"
              CurrChar = "Ñ"
            Case "Ograve"
              CurrChar = "Ò"
            Case "Oacute"
              CurrChar = "Ó"
            Case "Ocirc"
              CurrChar = "Ô"
            Case "Otilde"
              CurrChar = "Õ"
            Case "Ouml"
              CurrChar = "Ö"
            Case "times"
              CurrChar = "×"
            Case "Oslash"
              CurrChar = "Ø"
            Case "Ugrave"
              CurrChar = "Ù"
            Case "Uacute"
              CurrChar = "Ú"
            Case "Ucirc"
              CurrChar = "Û"
            Case "Uuml"
              CurrChar = "Ü"
            Case "Yacute"
              CurrChar = "Ý"
            Case "THORN"
              CurrChar = "Þ"
            Case "szlig"
              CurrChar = "ß"
            Case "agrave"
              CurrChar = "à"
            Case "aacute"
              CurrChar = "á"
            Case "acirc"
              CurrChar = "â"
            Case "atilde"
              CurrChar = "ã"
            Case "aring"
              CurrChar = "å"
            Case "aelig"
              CurrChar = "æ"
            Case "ccedil"
              CurrChar = "ç"
            Case "egrave"
              CurrChar = "è"
            Case "eacute"
              CurrChar = "é"
            Case "ecirc"
              CurrChar = "ê"
            Case "euml"
              CurrChar = "ë"
            Case "igrave"
              CurrChar = "ì"
            Case "iacute"
              CurrChar = "í"
            Case "icirc"
              CurrChar = "î"
            Case "iuml"
              CurrChar = "ï"
            Case "eth"
              CurrChar = "ð"
            Case "ntilde"
              CurrChar = "ñ"
            Case "ograve"
              CurrChar = "ò"
            Case "oacute"
              CurrChar = "ó"
            Case "ocirc"
              CurrChar = "ô"
            Case "otilde"
              CurrChar = "õ"
            Case "ouml"
              CurrChar = "ö"
            Case "divide"
              CurrChar = "÷"
            Case "oslash"
              CurrChar = "ø"
            Case "ugrave"
              CurrChar = "ù"
            Case "uacute"
              CurrChar = "ú"
            Case "ucirc"
              CurrChar = "û"
            Case "uuml"
              CurrChar = "ü"
            Case "yacute"
              CurrChar = "ý"
            Case "thorn"
              CurrChar = "þ"
            Case "yuml"
              CurrChar = "ÿ"
            Case Else
              CurrChar = "&" & CurrChar & ";"
          End Select
        End If
    End Select
    If Right$(CurrChar, 2) = vbCrLf And BlockQuote Then _
      CurrChar = CurrChar & "> "
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
End Function


Public Function ReplaceChars(ByVal OrgString _
  As String, ByVal ToReplace As String, _
  ByVal ToInsert As String) As String

  Dim ST As Long
  Dim newst As Long
  
  ST = 0
  Do While InStr(ST + 1, LCase$(OrgString), LCase$(ToReplace)) <> 0
    newst = InStr(ST + 1, LCase$(OrgString), LCase$(ToReplace))
    OrgString = Left$(OrgString, InStr(ST + 1, LCase$(OrgString), _
      LCase$(ToReplace)) - 1) & ToInsert & Mid$(OrgString, _
      InStr(ST + 1, LCase$(OrgString), LCase$(ToReplace)) + _
      Len(ToReplace))
    ST& = newst + Len(ToInsert) - 1
  Loop
  ReplaceChars = OrgString
End Function



Function StripByCharAndQuotes(ByVal OrgString _
  As String, StripChar As String) As Collection

  Dim Scoll As Collection
  Dim x As Long, Y As Long
  
  Set Scoll = New Collection
  Do
    x = InStr(OrgString, StripChar)
    Y = InStr(OrgString, Chr$(34))
    
    If Y > 0 And Y < x Then
      Y = InStr(Y + 1, OrgString, Chr$(34))
      Do While Y > x And Y > 0 And x > 0
        x = InStr(x + 1, OrgString, StripChar)
      Loop
    End If
    
    If x > 0 Then
      Scoll.Add Left$(OrgString, x - 1)
      OrgString = Mid$(OrgString, x + 1)
    Else
      Scoll.Add OrgString
      OrgString = ""
    End If
  Loop While Len(OrgString) > 0

  Set StripByCharAndQuotes = Scoll
  Set Scoll = Nothing
End Function



Private Function StripQuotes(ByVal sText _
  As String) As String

  If Left$(sText, 1) = Chr$(34) Then _
    sText = Mid$(sText, 2)
  If Right$(sText, 1) = Chr$(34) Then _
    sText = Left$(sText, Len(sText) - 1)
End Function






