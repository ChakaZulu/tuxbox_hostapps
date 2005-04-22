Attribute VB_Name = "modHTTP"
Option Explicit

Private Const INTERNET_OPEN_TYPE_PRECONFIG = 0
Private Const INTERNET_OPEN_TYPE_DIRECT = 1
Private Const INTERNET_OPEN_TYPE_PROXY = 3
Private Const scUserAgent = "VB Project"
Private Const INTERNET_FLAG_RELOAD = &H80000000

Private Declare Function InternetOpen Lib "wininet.dll" _
                   Alias "InternetOpenA" (ByVal sAgent As String, _
                                          ByVal lAccessType As Long, _
                                          ByVal sProxyName As String, _
                                          ByVal sProxyBypass As String, _
                                          ByVal lFlags As Long) As Long
Private Declare Function InternetOpenUrl Lib "wininet.dll" _
                   Alias "InternetOpenUrlA" (ByVal hOpen As Long, _
                                             ByVal sUrl As String, _
                                             ByVal sHeaders As String, _
                                             ByVal lLength As Long, _
                                             ByVal lFlags As Long, _
                                             ByVal lContext As Long) As Long
Private Declare Function InternetReadFile Lib "wininet.dll" _
                                          (ByVal hFile As Long, _
                                           ByVal sBuffer As String, _
                                           ByVal lNumBytesToRead As Long, _
                                           lNumberOfBytesRead As Long) As Integer
Private Declare Function InternetCloseHandle Lib "wininet.dll" _
                                             (ByVal hInet As Long) As Integer


Public Function fbasHttpGet(strURL As String, _
                   Optional strWriteToFile As String = "", _
                   Optional strUser As String = "", _
                   Optional strPass As String = "") As String
Dim hInet As Long
Dim hHTTP As Long
Dim strBuf As String, lngBufLen As Long
Dim strRes As String
Const conBufLen As Long = 1024
Dim sHeaders As String

   strRes = ""
   hInet = InternetOpen(scUserAgent, _
                        INTERNET_OPEN_TYPE_PRECONFIG, _
                        vbNullString, _
                        vbNullString, _
                        0)
   If Not hInet = 0 Then
   
      If strUser = "" Then
        sHeaders = Chr(0)
      Else
        sHeaders = "Authorization: Basic " & fbasBase64Enc(strUser & ":" & strPass) & Chr(0)
      End If
      hHTTP = InternetOpenUrl(hInet, _
                              strURL, _
                              "", _
                              0, _
                              INTERNET_FLAG_RELOAD, _
                              0)
      If Not hHTTP = 0 Then
      
        Do
          DoEvents
          strBuf = String(conBufLen, Chr(0))
          If InternetReadFile(hHTTP, _
                              strBuf, _
                              conBufLen, _
                              lngBufLen) Then
            DoEvents
            strBuf = Left(strBuf, lngBufLen)
            strRes = strRes & strBuf
          End If
        Loop Until lngBufLen = 0
        
        Call InternetCloseHandle(hHTTP)
      End If
      
      Call InternetCloseHandle(hInet)
   End If
   
   fbasHttpGet = strRes

End Function


Public Function fbasUrlEnc(str As String) As String
Dim lngPos As Long
Dim strRes As String
Dim strChar As String

  strRes = ""
  For lngPos = 1 To Len(str)
    
    strChar = Mid(str, lngPos, 1)
    Select Case Asc(strChar)
      
      Case Asc("a") To Asc("z"), _
           Asc("A") To Asc("Z"), _
           Asc("0") To Asc("9")
        strRes = strRes & strChar
      
      Case Asc(" ")
        strRes = strRes & "+"
      
      Case Else
        strRes = strRes & "%" & Right("00" & Hex(Asc(strChar)), 2)
      
    End Select
    
  Next
  
  fbasUrlEnc = strRes

End Function

Private Function fbasBase64Enc(s$) As String
' by Nobody, 20011204
  Static Enc() As Byte
  Dim b() As Byte, Out() As Byte, i&, j&, L&
  If (Not Val(Not Enc)) = 0 Then 'Null-Ptr = not initialized
    Enc = StrConv("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/", vbFromUnicode)
  End If
  L = Len(s): b = StrConv(s, vbFromUnicode)
  ReDim Preserve b(0 To (UBound(b) \ 3) * 3 + 2)
  ReDim Preserve Out(0 To (UBound(b) \ 3) * 4 + 3)
  For i = 0 To UBound(b) - 1 Step 3
    Out(j) = Enc(b(i) \ 4): j = j + 1
    Out(j) = Enc((b(i + 1) \ 16) Or (b(i) And 3) * 16): j = j + 1
    Out(j) = Enc((b(i + 2) \ 64) Or (b(i + 1) And 15) * 4): j = j + 1
    Out(j) = Enc(b(i + 2) And 63): j = j + 1
  Next i
  For i = 1 To i - L: Out(UBound(Out) - i + 1) = 61: Next i
  fbasBase64Enc = StrConv(Out, vbUnicode)
End Function
