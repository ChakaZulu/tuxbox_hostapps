VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CPULoad"
Attribute VB_GlobalNameSpace = True
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
Function CurrentCPUUsage() As Long
    Dim structSysBaseInfo      As SYSTEM_BASIC_INFORMATION
    Dim structSysPerfInfo      As SYSTEM_PERFORMANCE_INFORMATION
    Dim structSysTimeInfo      As SYSTEM_TIME_INFORMATION
    Dim dblIdleTime            As Currency
    Dim dblSystemTime          As Currency
    
    CurrentCPUUsage = 0
      
    If NtQuerySystemInformation(0&, VarPtr(structSysBaseInfo), LenB(structSysBaseInfo), 0&) <> 0 Then Exit Function
    If NtQuerySystemInformation(3&, VarPtr(structSysTimeInfo), LenB(structSysTimeInfo), 0&) <> 0 Then Exit Function
    If NtQuerySystemInformation(2&, VarPtr(structSysPerfInfo), LenB(structSysPerfInfo), ByVal 0&) <> 0 Then Exit Function

    ' CurrentValue = NewValue - OldValue
    dblIdleTime = LI2Currency(structSysPerfInfo.liIdleTime) - LI2Currency(liOldIdleTime)
    dblSystemTime = LI2Currency(structSysTimeInfo.liKeSystemTime) - LI2Currency(liOldSystemTime)
      
    ' CurrentCpuIdle = IdleTime / SystemTime
    If dblSystemTime <> 0 Then dblIdleTime = dblIdleTime / dblSystemTime
      
    ' CurrentCpuUsage% = 100 - (CurrentCpuIdle * 100) / NumberOfProcessors
    dblIdleTime = 100 - dblIdleTime * 100 / structSysBaseInfo.bKeNumberProcessors + 0.5
    CurrentCPUUsage = Int(dblIdleTime)
      
    ' store new CPU's idle and system time
    liOldIdleTime = structSysPerfInfo.liIdleTime
    liOldSystemTime = structSysTimeInfo.liKeSystemTime
End Function
Private Sub Class_Initialize()
    Dim structSysTimeInfo      As SYSTEM_TIME_INFORMATION
    Dim structSysPerfInfo      As SYSTEM_PERFORMANCE_INFORMATION
   
    If NtQuerySystemInformation(3&, VarPtr(structSysTimeInfo), LenB(structSysTimeInfo), 0&) <> 0 Then Exit Sub
    If NtQuerySystemInformation(2&, VarPtr(structSysPerfInfo), LenB(structSysPerfInfo), ByVal 0&) <> 0 Then Exit Sub
    
    'store new CPU's idle and system time
    liOldIdleTime = structSysPerfInfo.liIdleTime
    liOldSystemTime = structSysTimeInfo.liKeSystemTime
End Sub
Private Function LI2Currency(liInput As LARGE_INTEGER) As Currency
    CopyMemory LI2Currency, liInput, LenB(liInput)
End Function

