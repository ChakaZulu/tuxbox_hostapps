VERSION 5.00
Object = "{48E59290-9880-11CF-9754-00AA00C00908}#1.0#0"; "MSINET.OCX"
Begin VB.UserControl DownLoad 
   CanGetFocus     =   0   'False
   ClientHeight    =   525
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   555
   InvisibleAtRuntime=   -1  'True
   MaskColor       =   &H000000FF&
   MaskPicture     =   "DLMain.ctx":0000
   Picture         =   "DLMain.ctx":0844
   PropertyPages   =   "DLMain.ctx":1086
   ScaleHeight     =   525
   ScaleWidth      =   555
   ToolboxBitmap   =   "DLMain.ctx":10A8
   Begin VB.Timer timeout 
      Interval        =   2000
      Left            =   1920
      Top             =   300
   End
   Begin InetCtlsObjects.Inet I1 
      Left            =   600
      Top             =   480
      _ExtentX        =   1005
      _ExtentY        =   1005
      _Version        =   393216
   End
End
Attribute VB_Name = "DownLoad"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Attribute VB_Ext_KEY = "PropPageWizardRun" ,"Yes"
Private Declare Function InternetGetConnectedState Lib "wininet" (lpdwFlags As Long, ByVal dwReserved As Long) As Boolean

Dim a_Resume As Boolean
Dim c_Cancel As Boolean
Dim c_Pause As Boolean
Dim m_URL As String
Dim m_FileSize As Long
Dim m_CHUNK As Long
Dim m_FileExists As Boolean
Dim m_Percent As Long
Dim m_Status As String
Dim m_BYTES As Long
Dim m_SaveLocation As String
Dim m_KeepType As Boolean
Dim m_OnlineCheck As Boolean
Dim m_PromptOverwrite As Boolean
Dim m_Connected As Boolean
Dim m_Resume As Boolean
Dim m_ROLLBACK As Long
Dim m_InDL As Boolean
Dim m_UserName As String
Dim m_Password As String
Dim t_OldTime As Single
Dim t_Time As Single
Dim r_RateTransfer As Single
Dim timeou As Boolean

Const INTERNET_CONNECTION_MODEM = 1
Const INTERNET_CONNECTION_LAN = 2
Const INTERNET_CONNECTION_PROXY = 4

Const d_URL = "http://members.tripod.com/darkmsoft/index.html"
Const d_CHUNK = 1024
Const d_SaveLocation = "C:\File1.tmp"
Const d_KeepType = False
Const d_OnlineCheck = False
Const d_PromptOverwrite = False
Const d_ROLLBACK = 5120

'error codes
'1 Unknown error
'2 File doesn't exist
'3 Server timed out
'4 canceled
'5 No Connection To Internet
'401 Unauthorized Access
'403 Access Denied

Event DLComplete()
Event DLError(lpErrorDescription As String)
Event DLECode(lErrorCode As Long)
Event RecievedBytes(lnumBYTES As Long)
Event Percent(lPercent As Long)
Event StatusChange(lpStatus As String)
Event Rate(lpRate As String)
Event TimeLeft(lpTime As String)
Event ConnectionState(strState As String)


Public Property Get InDL() As Boolean
InDL = m_InDL
End Property
Public Property Get timeo() As Boolean
timeo = timeou
End Property
Public Property Get AResume() As Boolean
AResume = a_Resume
End Property

Public Property Get CPause() As Boolean
CPause = c_Pause
End Property

Public Property Get CCancel() As Boolean
CCancel = c_Cancel
End Property

Public Property Get ROLLBACK() As Long
ROLLBACK = m_ROLLBACK
End Property

Public Property Let ROLLBACK(ByVal lnumBYTES As Long)
m_ROLLBACK = ROLLBACK
PropertyChanged "ROLLBACK"
End Property

Public Property Get ResumeSupported() As Boolean
ResumeSupported = a_Resume
End Property

Public Property Get Connected() As Boolean
Connected = m_Connected
End Property

Public Property Get PromptOverwrite() As Boolean
Attribute PromptOverwrite.VB_ProcData.VB_Invoke_Property = "DownLoad_Properties"
PromptOverwrite = m_PromptOverwrite
End Property

Public Property Let PromptOverwrite(ByVal DoPrompt As Boolean)
m_PromptOverwrite = DoPrompt
PropertyChanged "PromptOverwrite"
End Property

Public Property Get OnlineCheck() As Boolean
OnlineCheck = m_OnlineCheck
End Property

Public Property Let OnlineCheck(ByVal DoCheck As Boolean)
m_OnlineCheck = DoCheck
PropertyChanged "OnlineCheck"
End Property

Public Property Get KeepType() As Boolean
KeepType = m_KeepType
End Property

Public Property Let KeepType(ByVal IsKeep As Boolean)
m_KeepType = IsKeep
PropertyChanged "KeepType"
End Property

Public Property Get FileExists() As Boolean
  FileExists = m_FileExists
End Property

Public Property Get FileSize() As Long
  FileSize = m_FileSize
End Property

Public Property Get URL() As String
Attribute URL.VB_ProcData.VB_Invoke_Property = "DownLoad_Properties"
  URL = m_URL
End Property

Public Property Get CHUNK() As Long
Attribute CHUNK.VB_ProcData.VB_Invoke_Property = "DownLoad_Properties"
CHUNK = m_CHUNK
End Property

Public Property Get SaveLocation() As String
Attribute SaveLocation.VB_ProcData.VB_Invoke_Property = "DownLoad_Properties"
SaveLocation = m_SaveLocation
End Property

Public Property Let SaveLocation(ByVal New_Location As String)
m_SaveLocation = New_Location
PropertyChanged "SaveLocation"
End Property

Public Property Let CHUNK(ByVal New_CHUNK As Long)
m_CHUNK = New_CHUNK
PropertyChanged "CHUNK"
End Property

Public Property Let URL(ByVal New_Url As String)
m_URL = New_Url
PropertyChanged "Url"
End Property

Private Sub timeout_Timer()
    timeout.Enabled = "0"
End Sub

Private Sub UserControl_InitProperties()
m_URL = d_URL
m_CHUNK = d_CHUNK
m_SaveLocation = d_SaveLocation
End Sub

Private Sub UserControl_ReadProperties(PropBag As PropertyBag)
m_URL = PropBag.ReadProperty("URL", d_URL)
m_CHUNK = PropBag.ReadProperty("CHUNK", d_CHUNK)
m_SaveLocation = PropBag.ReadProperty("SaveLocation", d_SaveLocation)
m_KeepType = PropBag.ReadProperty("KeepType", d_KeepType)
m_OnlineCheck = PropBag.ReadProperty("OnlineCheck", d_OnlineCheck)
m_PromptOverwrite = PropBag.ReadProperty("PromptOverwrite", d_PromptOverwrite)
End Sub

Private Sub UserControl_Resize()
UserControl.Height = 480
UserControl.Width = 480
End Sub

Private Sub UserControl_WriteProperties(PropBag As PropertyBag)
Call PropBag.WriteProperty("URL", m_URL, d_URL)
Call PropBag.WriteProperty("CHUNK", m_CHUNK, d_CHUNK)
Call PropBag.WriteProperty("SaveLocation", m_SaveLocation, d_SaveLocation)
Call PropBag.WriteProperty("KeepType", m_KeepType, d_KeepType)
Call PropBag.WriteProperty("OnlineCheck", m_OnlineCheck, d_OnlineCheck)
Call PropBag.WriteProperty("PromptOverwrite", m_PromptOverwrite, d_PromptOverwrite)
End Sub

Sub DownLoad()
On Error GoTo DLE
Dim lpHeader As String
Dim lpdestination As String
Dim lpdestination2 As String
Dim strreturn As String
Dim CHUNK As Long
Dim bData() As Byte
Dim intfile As Integer
Dim lBR As Long

If c_Cancel = True Then
Exit Sub
End If

If m_OnlineCheck = True Then
    If m_Connected = False Then
        RaiseEvent DLECode(5)
        RaiseEvent DLError("No Connection Found!")
        RaiseEvent StatusChange("Download aborted, no connection present!")
        I1.Cancel
        Exit Sub
    End If
End If

I1.URL = m_URL
CHUNK = m_CHUNK
lpdestination = m_SaveLocation
intfile = FreeFile()

If m_KeepType = True Then
lpdestination = KeepSave(m_URL, m_SaveLocation)
End If

If m_PromptOverwrite = True Then
    If Dir$(lpdestination) > " " Then
        strreturn = MsgBox("Would you like to overwrite the file at: " & lpdestination & " ?", vbInformation + vbYesNo, "Overwrite?")
            If strreturn = vbYes Then
                Kill lpdestination
            Else
404:            lpdestination2 = InputBox("Please type in a new file path and name." & vbCrLf & "Example: C:\File2.txt", "New File...", lpdestination)
                    If lpdestination2 <= " " Then
                        MsgBox "You didn't specify a file!", vbExclamation + vbOKOnly, "Error!"
                        GoTo 404
                    End If
                    If lpdestination = lpdestination2 Then
                        strreturn = MsgBox("You typed in the same file! Would you like type in a different file?", vbCritical + vbYesNo, "Try Again?")
                            If strreturn = vbYes Then
                                GoTo 404
                            End If
                    End If
            End If
    End If
Else
    If Dir$(lpdestination) > " " Then
        Kill lpdestination
    End If
End If

Open lpdestination For Binary Access Write As #intfile
RaiseEvent StatusChange("Opening " & lpdestination & " For DATA Input.")
m_InDL = True
Do
    If c_Cancel = True Then
    c_Cancel = False
    Close #intfile
    RaiseEvent DLECode(4)
    RaiseEvent StatusChange("Cancelled.")
    Exit Sub
    End If
    bData = I1.GetChunk(CHUNK, icByteArray)
    Put #intfile, , bData
    lBR = lBR + UBound(bData, 1) + 1
    m_BYTES = lBR
    r_RateTransfer = lBR / (Timer - t_OldTime)
    t_Time = (m_FileSize - lBR) / r_RateTransfer
    RaiseEvent Rate(FormatFileSize(r_RateTransfer))
    RaiseEvent TimeLeft(FormatTime(t_Time))
    RaiseEvent RecievedBytes(lBR)
    RaiseEvent Percent(Round((lBR / m_FileSize) * 100, 0))
    RaiseEvent StatusChange("Recieving File, Inputting DATA to File.")
    If c_Pause = True Then
    While c_Pause = True
    DoEvents
    RaiseEvent StatusChange("Paused.")
    Wend
    End If
Loop While UBound(bData, 1) > 0
Close #intfile
m_InDL = False
RaiseEvent DLComplete
RaiseEvent StatusChange("Download Successful!")
I1.Cancel
Exit Sub
DLE:
RaiseEvent DLError("Error Downloading File from : " & m_URL)
RaiseEvent StatusChange("Download Aborted Due To Error In Download!")
RaiseEvent DLECode(1)
I1.Cancel
Exit Sub
End Sub

Sub GetFileInformation()
On Error GoTo Ge
Dim sHeader As String
Dim blnreturn As Boolean

If c_Cancel = True Then
c_Cancel = False
End If

If m_OnlineCheck = True Then
blnreturn = IsOnline
    If blnreturn = False Then
        MsgBox "You are not currently connected to the internet!" & vbCrLf & "The download will be aborted!"
        m_Connected = False
        RaiseEvent DLECode(5)
        RaiseEvent DLError("No Connection Found!")
        RaiseEvent StatusChange("Download aborted, no connection present!")
        Exit Sub
    Else
        m_Connected = True
    End If
End If

I1.URL = m_URL
I1.Execute , "GET"
RaiseEvent StatusChange("Initiating Connection.")

timeout.Enabled = "1"
timeou = "0"

While I1.StillExecuting
    DoEvents
    
    If timeout.Enabled = "0" Then
        timeou = "1"
        I1.Cancel
        Exit Sub
    End If
Wend

RaiseEvent StatusChange("Connection Accepted, Retrieving File Information.")

If c_Cancel = True Then GoTo Cc

sHeader = I1.GetHeader()
Select Case Mid$(sHeader, 10, 3)


Case 401
RaiseEvent StatusChange("Unauthorized Access, Download Terminated!")
RaiseEvent DLECode(401)
RaiseEvent DLError("Unauthorized Access!")
a_Resume = False
I1.Cancel
m_FileExists = True
m_FileSize = 0
Exit Sub

Case 403
RaiseEvent StatusChange("Access Denied, Download Terminated!")
RaiseEvent DLECode(403)
RaiseEvent DLError("Access Denied!")
a_Resume = False
m_FileExists = True
m_FileSize = 0
I1.Cancel
Exit Sub

Case 404
    RaiseEvent DLError("File Not Found!")
    RaiseEvent StatusChange("File Not Found!")
    RaiseEvent DLECode(2)
    m_FileExists = False
    m_FileSize = 0
    I1.Cancel
    Exit Sub

End Select

If c_Cancel = True Then GoTo Cc

If Mid$(aheader, 6, 3) = "1.1" Then a_Resume = True

m_FileExists = True
t_OldTime = Timer - 1
m_FileSize = CLng(I1.GetHeader("Content-Length"))
RaiseEvent StatusChange("Retrieving File Information Complete!")
Exit Sub

Ge:
RaiseEvent DLError("Error Reading File Headers.")
RaiseEvent StatusChange("Error Reading File Headers!")
RaiseEvent DLECode(3)
Exit Sub

Cc:
c_Cancel = False
RaiseEvent DLECode(4)
RaiseEvent StatusChange("cancelled.")
Exit Sub
End Sub

Sub Cancel()
c_Cancel = True
RaiseEvent StatusChange("Cancelling..")
End Sub

Private Function FormatTime(ByVal sglTime As Single) As String
                           
Select Case sglTime
    Case 0 To 59
        FormatTime = Format(sglTime, "0") & " sec"
    Case 60 To 3599
        FormatTime = Format(Int(sglTime / 60), "#0") & _
                     " min " & _
                     Format(sglTime Mod 60, "0") & " sec"
    Case Else
        FormatTime = Format(Int(sglTime / 3600), "#0") & _
                     " hr " & _
                     Format(sglTime / 60 Mod 60, "0") & " min"
End Select

End Function

Private Function FormatFileSize(ByVal dFileSize As Double) As String

Select Case dFileSize
    Case 0 To 1023
        FormatFileSize = Round(dFileSize, 0) & " Bytes/S"
    Case 1024 To 1048575
        FormatFileSize = Round(dFileSize / 1024, 2) & " KB/S"
End Select

End Function

Private Function KeepSave(lpURL As String, lpSL As String) As String
Dim temphold(1 To 2) As String
Dim lplace(1 To 2) As Long
lplace(1) = InStr(Len(lpURL) - 5, lpURL, ".", vbTextCompare)
temphold(1) = Right$(lpURL, Len(lpURL) - lplace(1))
lplace(2) = InStr(Len(lpSL) - 5, lpSL, ".", vbTextCompare)
temphold(2) = Left$(lpSL, lplace(2))
KeepSave = temphold(2) & temphold(1)
End Function

Private Function IsOnline() As Boolean
Dim lflag As Long
Dim blnreturn As Boolean
blnreturn = InternetGetConnectedState(lflag, 0)

If lflag And INTERNET_CONNECTION_MODEM Then
RaiseEvent ConnectionState("Connected Via Modem.")
End If
If lflag And INTERNET_CONNECTION_LAN Then
RaiseEvent ConnectionState("Connected Via LAN.")
End If
If lflag And INTERNET_CONNECTION_PROXY Then
RaiseEvent ConnectionState("Connected Through A Proxy.")
End If

IsOnline = blnreturn
End Function

Sub DLResume()
On Error GoTo DLE
Dim lpHeader As String
Dim lpdestination As String
Dim lpdestination2 As String
Dim strreturn As String
Dim CHUNK As Long
Dim bData() As Byte
Dim intfile As Integer
Dim lBR As Long
Dim SFV As Long
If c_Cancel = True Then
Exit Sub
End If

If m_OnlineCheck = True Then
    If m_Connected = False Then
        RaiseEvent DLECode(5)
        RaiseEvent DLError("No Connection Found!")
        RaiseEvent StatusChange("Download aborted, no connection present!")
        I1.Cancel
        Exit Sub
    End If
End If

I1.URL = m_URL
CHUNK = m_CHUNK
lpdestination = m_SaveLocation

If Dir$(m_SaveLocation) < " " Then
RaiseEvent DLError("Resume File Not Found!")
RaiseEvent DLECode(6)
RaiseEvent StatusChange("Resume File Not Found, Aborting Download!")
Exit Sub
End If

If a_Resume = False Then
RaiseEvent DLError("Resume Not Supported!")
RaiseEvent DLECode(7)
RaiseEvent StatusChange("Resume NotSupported, Aborting Download!")
Exit Sub
End If

I1.Execute , "GET", , "Range: bytes=" & CStr(SFV) & "-" & vbCrLf

While I1.StillExecuting
DoEvents
Wend

SFV = FileLen(m_SaveLocation)
intfile = FreeFile()

Open m_SaveLocation For Binary Access Write As #intfile
Seek #intfile, SFV + 1
RaiseEvent StatusChange("Opening " & lpdestination & " For DATA Input.")
m_InDL = True
Do
    If c_Cancel = True Then
    c_Cancel = False
    Close #intfile
    RaiseEvent DLECode(4)
    RaiseEvent StatusChange("Cancelled.")
    Exit Sub
    End If
    bData = I1.GetChunk(CHUNK, icByteArray)
    Put #intfile, , bData
    lBR = lBR + UBound(bData, 1) + 1
    m_BYTES = lBR
    r_RateTransfer = lBR / (Timer - t_OldTime)
    t_Time = (m_FileSize - lBR) / r_RateTransfer
    RaiseEvent Rate(FormatFileSize(r_RateTransfer))
    RaiseEvent TimeLeft(FormatTime(t_Time))
    RaiseEvent RecievedBytes(lBR + SFV)
    RaiseEvent Percent(Round(((lBR + SFV) / m_FileSize) * 100, 0))
    RaiseEvent StatusChange("Recieving File, Inputting DATA to File.")
    If c_Pause = True Then
    While c_Pause = True
    DoEvents
    RaiseEvent StatusChange("Paused.")
    Wend
    End If
Loop While UBound(bData, 1) > 0
Close #intfile
m_InDL = False
RaiseEvent DLComplete
RaiseEvent StatusChange("Download Successful!")
I1.Cancel
Exit Sub
DLE:
RaiseEvent DLError("Error Downloading File from : " & m_URL)
RaiseEvent StatusChange("Download Aborted Due To Error In Download!")
RaiseEvent DLECode(1)
I1.Cancel
Exit Sub
End Sub

Sub Pause(blnPause As Boolean)
c_Pause = blnPause
If c_Pause = False Then
RaiseEvent StatusChange("Unpausing")
End If
End Sub
