VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Dos"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
Private Declare Function OpenProcess Lib "kernel32" (ByVal dwDesiredAccess As Long, ByVal bInheritHandle As Long, ByVal dwProcessId As Long) As Long
Private Declare Function GetExitCodeProcess Lib "kernel32" (ByVal hProcess As Long, lpExitCode As Long) As Long
Sub shellwait(cmdline As String, sdos As Boolean)
    Dim hProcess As Long, processid As Long, exitCode As Long
    
    If sdos = "1" Then
        processid = Shell(cmdline, vbMinimizedNoFocus)
    Else
        processid = Shell(cmdline, vbHide)
    End If
    
    hProcess = OpenProcess(&H400, False, processid)

    Do
        DoEvents
        GetExitCodeProcess hProcess, exitCode
    Loop While exitCode = &H103&
End Sub
