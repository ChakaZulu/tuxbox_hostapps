VERSION 5.00
Object = "{EAB22AC0-30C1-11CF-A7EB-0000C05BAE0B}#1.1#0"; "shdocvw.dll"
Begin VB.Form Cover_downloader 
   Caption         =   "Form1"
   ClientHeight    =   5415
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   6465
   LinkTopic       =   "Form1"
   ScaleHeight     =   5415
   ScaleWidth      =   6465
   StartUpPosition =   3  'Windows-Standard
   Begin VB.Timer timeout 
      Enabled         =   0   'False
      Interval        =   60000
      Left            =   4800
      Top             =   840
   End
   Begin SHDocVwCtl.WebBrowser WebBrowser1 
      Height          =   3615
      Left            =   240
      TabIndex        =   0
      Top             =   480
      Width           =   3615
      ExtentX         =   6376
      ExtentY         =   6376
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
      Location        =   "http:///"
   End
End
Attribute VB_Name = "Cover_downloader"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private Declare Function URLDownloadToFile Lib "urlmon" Alias "URLDownloadToFileA" (ByVal pCaller As Long, ByVal szURL As String, ByVal szFileName As String, ByVal dwReserved As Long, ByVal lpfnCB As Long) As Long
Private picturefilename As String
Private wait As Boolean
Public Sub cover_download(c_interpret As String, c_album As String, korrsymbol As String, Sondercheck As String)
    Dim ret As String, covername As String, cover_interpret As String, cover_album As String, F As Integer, filesize As Long, i As Integer
    Dim cinter As String, calbum As String, trennzei As String
    
    'Trennzeichen wird bestimmt
    If korrsymbol = "Line:         ""-""" Then trennzei = "-"
    If korrsymbol = "Underline: ""_""" Then trennzei = "_"
    If korrsymbol = "Space:      "" """ Then trennzei = " "
    
    cinter = c_interpret
    calbum = c_album
    
    For i = 1 To Len(Sondercheck)
        cinter = Replace(cinter, Mid$(Sondercheck, i, 1), trennzei) 'Sonderzeichen durch Leerzeichen ersetzten
        calbum = Replace(calbum, Mid$(Sondercheck, i, 1), trennzei) 'Sonderzeichen durch Leerzeichen ersetzten
    Next i
    
    If LenB(Dir$(App.Path & "\Datenbank\Covers\" + cinter + " - " + calbum + "_Front." + "jpg", vbDirectory)) <> 0 Then Exit Sub
    
    cover_interpret = c_interpret
    cover_album = c_album
    cover_interpret = Replace(cover_interpret, " ", "_")
    cover_album = Replace(cover_album, " ", "_")
    covername = cover_interpret + "_-_" + cover_album
    
    wait = "0"
    timeout.Enabled = "1"
    Call WebBrowser1.Navigate("http://covertarget.com/ss.php?/audio/audio" + Format(Left$(c_interpret, 1), "<") + "/" + covername + "_-_Front.jpg")
    picturefilename = "Front.jpg"
    
    While wait = "0"
        If timeout.Enabled = "0" Then Exit Sub
        DoEvents
    Wend
        
    timeout.Enabled = "0"
    F = FreeFile
    
    Open App.Path + "\temp\Front.jpg" For Binary As #F
        filesize = LOF(F)
    Close F
                    
    If filesize > 200 Then
        Name App.Path + "\temp\Front.jpg" As App.Path & "\Datenbank\Covers\" + cinter + " - " + calbum + "_Front." + "jpg"
        
        wait = "0"
        Call WebBrowser1.Navigate("http://covertarget.com/ss.php?/audio/audio" + Format(Left$(c_interpret, 1), "<") + "/" + covername + "_-_Back.jpg")
        picturefilename = "Back.jpg"
        timeout.Enabled = "1"
        
        While wait = "0"
            If timeout.Enabled = "0" Then Exit Sub
            DoEvents
        Wend
                
        timeout.Enabled = "0"
        F = FreeFile

        Open App.Path + "\temp\Back.jpg" For Binary As #F
            filesize = LOF(F)
        Close F
    
        If filesize > 200 Then
            Name App.Path + "\temp\Back.jpg" As App.Path & "\Datenbank\Covers\" + cinter + " - " + calbum + "_Back." + "jpg"
        Else
            Kill App.Path + "\temp\Back.jpg"
        End If
        
        wait = "0"
        Call WebBrowser1.Navigate("http://covertarget.com/ss.php?/audio/audio" + Format(Left$(c_interpret, 1), "<") + "/" + covername + "_-_Cd.jpg")
        picturefilename = "CD.jpg"
        timeout.Enabled = "1"
        
        While wait = "0"
            If timeout.Enabled = "0" Then Exit Sub
            DoEvents
        Wend
        
        timeout.Enabled = "0"
        F = FreeFile
        
        Open App.Path + "\temp\Cd.jpg" For Binary As #F
            filesize = LOF(F)
        Close F
    
        If filesize > 200 Then
            Name App.Path + "\temp\Cd.jpg" As App.Path & "\Datenbank\Covers\" + cinter + " - " + calbum + "_CD." + "jpg"
        Else
            Kill App.Path + "\temp\Cd.jpg"
        End If
        
        wait = "0"
        Call WebBrowser1.Navigate("http://covertarget.com/ss.php?/audio/audio" + Format(Left$(c_interpret, 1), "<") + "/" + covername + "_-_Inside.jpg")
        picturefilename = "Inside.jpg"
        timeout.Enabled = "1"
        
        While wait = "0"
            If timeout.Enabled = "0" Then Exit Sub
            DoEvents
        Wend
        
        timeout.Enabled = "0"
        F = FreeFile
        
        Open App.Path + "\temp\Inside.jpg" For Binary As #F
            filesize = LOF(F)
        Close F
    
        If filesize > 200 Then
            Name App.Path + "\temp\Inside.jpg" As App.Path & "\Datenbank\Covers\" + cinter + " - " + calbum + "_Inside." + "jpg"
        Else
            Kill App.Path + "\temp\Inside.jpg"
        End If
    Else
        Kill App.Path + "\temp\Front.jpg"
    End If
End Sub
Private Sub timeout_Timer()
    timeout.Enabled = "0"
End Sub
Private Sub WebBrowser1_DocumentComplete(ByVal pDisp As Object, URL As Variant)
    Dim collImages As MSHTML.IHTMLElementCollection
    Dim img As IHTMLImgElement
    Dim lResult As Long
    Dim i As Long
    
    wait = "1"
    Set collImages = pDisp.Document.getElementsByTagName("IMG")
    
    For i = 0 To collImages.length - 1
        Set img = collImages.Item(i)
        lResult = URLDownloadToFile(0, img.src, App.Path + "\temp\" & picturefilename, 0, 0)
        Set img = Nothing
    Next i
    
    Set collImages = Nothing
End Sub
