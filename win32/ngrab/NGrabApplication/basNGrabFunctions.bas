Attribute VB_Name = "basNGrabFunctions"
'-----------------------------------------------------------------------
' <DOC>
' <MODULE>
'
' <NAME>
'   basNGrabFunctions
' </NAME>
'
' <DESCRIPTION>
'   NGrab Functions
' </DESCRIPTION>
'
' <NOTES>
' </NOTES>
'
' <COPYRIGHT>
'   Copyright (c) Michael Sommer (LYNX)
' </COPYRIGHT>
'
' <AUTHOR>
'   LYNX
' </AUTHOR>
'
' <HISTORY>
'   31.07.2002 - LYNX Neues Modul basNGRabFunctions eingeführt. Dieses Modul enthält Globale NGrabFunctions. Erst einmal nur die WriteLog Funktion die vorher in der clsIni drin war. Ausserdem gibt es noch zwei neu Globale Funktionen für das lesen und schreiben der Settings in/aus der/die Registry!
' </HISTORY>
'
' </MODULE>
' </DOC>
'-----------------------------------------------------------------------
Option Explicit

Public Sub gRegistrySettingsRead()
     
    goSettings.sItem(NLSDBoxIPAdress) = gvntRegistrySettingGet(HKEY_LOCAL_MACHINE, NLSNGrabRegKey, NLSDBoxIPAdress)
    goSettings.nItem(NLSDBoxPort) = gvntRegistrySettingGet(HKEY_LOCAL_MACHINE, NLSNGrabRegKey, NLSDBoxPort)
    goSettings.sItem(NLSGrabPath) = gvntRegistrySettingGet(HKEY_LOCAL_MACHINE, NLSNGrabRegKey, NLSGrabPath)
    goSettings.nItem(NLSSyncTime) = gvntRegistrySettingGet(HKEY_LOCAL_MACHINE, NLSNGrabRegKey, NLSSyncTime)
    goSettings.nItem(NLSWriteLog) = gvntRegistrySettingGet(HKEY_LOCAL_MACHINE, NLSNGrabRegKey, NLSWriteLog)
    goSettings.nItem(NLSWriteEPG) = gvntRegistrySettingGet(HKEY_LOCAL_MACHINE, NLSNGrabRegKey, NLSWriteEPG)
    goSettings.nItem(NLSWGESplitFile) = gvntRegistrySettingGet(HKEY_LOCAL_MACHINE, NLSNGrabRegKey, NLSWGESplitFile)
    goSettings.sItem(NLSStartEnc) = gvntRegistrySettingGet(HKEY_LOCAL_MACHINE, NLSNGrabRegKey, NLSStartEnc)
    goSettings.sItem(NLSEncFile) = gvntRegistrySettingGet(HKEY_LOCAL_MACHINE, NLSNGrabRegKey, NLSEncFile)
    
    goSettings.sItem(NLSFileExtM2P) = gvntRegistrySettingGet(HKEY_LOCAL_MACHINE, NLSNGrabRegKey, NLSFileExtM2P)
    goSettings.sItem(NLSFileExtTXT) = gvntRegistrySettingGet(HKEY_LOCAL_MACHINE, NLSNGrabRegKey, NLSFileExtTXT)
    goSettings.sItem(NLSFileExtM2V) = gvntRegistrySettingGet(HKEY_LOCAL_MACHINE, NLSNGrabRegKey, NLSFileExtM2V)
    goSettings.sItem(NLSFileExtM2A) = gvntRegistrySettingGet(HKEY_LOCAL_MACHINE, NLSNGrabRegKey, NLSFileExtM2A)
    goSettings.sItem(NLSFileExtLOG) = gvntRegistrySettingGet(HKEY_LOCAL_MACHINE, NLSNGrabRegKey, NLSFileExtLOG)
    
    goSettings.nItem(NLSWGEStreamType) = gvntRegistrySettingGet(HKEY_LOCAL_MACHINE, NLSNGrabRegKey, NLSWGEStreamType)

End Sub

Public Sub gRegistrySettingsSave()

    nil = glRegistrySettingSave(HKEY_LOCAL_MACHINE, NLSNGrabRegKey, NLSDBoxIPAdress, goSettings.sItem(NLSDBoxIPAdress))
    nil = glRegistrySettingSave(HKEY_LOCAL_MACHINE, NLSNGrabRegKey, NLSDBoxPort, goSettings.nItem(NLSDBoxPort))
    nil = glRegistrySettingSave(HKEY_LOCAL_MACHINE, NLSNGrabRegKey, NLSGrabPath, goSettings.sItem(NLSGrabPath))
    nil = glRegistrySettingSave(HKEY_LOCAL_MACHINE, NLSNGrabRegKey, NLSSyncTime, goSettings.nItem(NLSSyncTime))
    nil = glRegistrySettingSave(HKEY_LOCAL_MACHINE, NLSNGrabRegKey, NLSWriteLog, goSettings.nItem(NLSWriteLog))
    nil = glRegistrySettingSave(HKEY_LOCAL_MACHINE, NLSNGrabRegKey, NLSWriteEPG, goSettings.nItem(NLSWriteEPG))
    nil = glRegistrySettingSave(HKEY_LOCAL_MACHINE, NLSNGrabRegKey, NLSWGESplitFile, goSettings.nItem(NLSWGESplitFile))
    nil = glRegistrySettingSave(HKEY_LOCAL_MACHINE, NLSNGrabRegKey, NLSStartEnc, goSettings.nItem(NLSStartEnc))
    nil = glRegistrySettingSave(HKEY_LOCAL_MACHINE, NLSNGrabRegKey, NLSEncFile, goSettings.sItem(NLSEncFile))
    
    nil = glRegistrySettingSave(HKEY_LOCAL_MACHINE, NLSNGrabRegKey, NLSFileExtM2P, goSettings.sItem(NLSFileExtM2P))
    nil = glRegistrySettingSave(HKEY_LOCAL_MACHINE, NLSNGrabRegKey, NLSFileExtTXT, goSettings.sItem(NLSFileExtTXT))
    nil = glRegistrySettingSave(HKEY_LOCAL_MACHINE, NLSNGrabRegKey, NLSFileExtM2V, goSettings.sItem(NLSFileExtM2V))
    nil = glRegistrySettingSave(HKEY_LOCAL_MACHINE, NLSNGrabRegKey, NLSFileExtM2A, goSettings.sItem(NLSFileExtM2A))
    nil = glRegistrySettingSave(HKEY_LOCAL_MACHINE, NLSNGrabRegKey, NLSFileExtLOG, goSettings.sItem(NLSFileExtLOG))
        
    nil = glRegistrySettingSave(HKEY_LOCAL_MACHINE, NLSNGrabRegKey, NLSWGEStreamType, goSettings.nItem(NLSWGEStreamType))
    
End Sub

Public Function gnCount(vntExp As Variant, Optional sDel As String = ";") As Integer

    Dim nPos As Integer
    Dim nCount As Integer
    
    sDel = IIf(sDel = "", ";", sDel)
    
    If gbNull(vntExp) Then
        Exit Function
    End If
    
    Do
        nCount = nCount + 1
        nPos = InStr(nPos + Len(sDel), CStr(vntExp), sDel, 0)
    Loop Until (nPos = 0)
    
    gnCount = nCount

End Function

Public Function gsParse(vntExp As Variant, nArg As Integer, Optional sDel As String = ";") As String

    Dim I As Integer
    Dim nPos As Integer
    Dim sBuffer As String

    If IsNull(vntExp) Then
        gsParse = ""
    Else
        sDel = IIf(sDel = "", ";", sDel)
        sBuffer = Trim$(CStr(vntExp))
        For I = 1 To nArg
            sBuffer = sBuffer + sDel
        Next
        For I = 1 To Abs(nArg) - 1
            nPos = InStr(nPos + 1, sBuffer, sDel, 0) + Len(sDel) - 1
        Next
        If nArg > 0 Then
            'Argument nArg
            gsParse = Trim$(Mid$(sBuffer, nPos + 1, InStr(nPos + 1, sBuffer, sDel, 0) - nPos - 1))
        Else
            'Alle Argumente ab Argument nArg
            gsParse = Trim$(Mid$(sBuffer, nPos + 1))
        End If
    End If

End Function

Public Function gbNull(vnt As Variant) As Boolean

    On Error GoTo NullErr
    
    Select Case VarType(vnt)
    Case vbNull, vbEmpty
        gbNull = True
    Case vbString
        gbNull = (Len(RTrim(CStr(vnt))) = 0)
    Case vbDate
        gbNull = Not gbDate(vnt)
    Case Else
        gbNull = (vnt = 0)
    End Select
    Exit Function

NullErr:
    gbNull = True
    Exit Function

End Function

Public Function gbDate(vnt As Variant) As Boolean

    If IsDate(vnt) Then
        gbDate = (Year(CVDate(vnt)) >= 1900)
    Else
        gbDate = False
    End If

End Function
