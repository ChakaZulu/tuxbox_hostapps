Attribute VB_Name = "Excel_Statistik"
Option Explicit
Public Sub AddData()
    Dim pos1 As Integer, pos2 As Integer, day As String, mounth As String, year As String, fso As Object
    Dim excelname As String, i As Integer, number As Integer, temp As Integer
    
    number = 100
    Set fso = CreateObject("Scripting.FileSystemObject")
    day = Left(frmMain.aktdate.Caption, 2)
    mounth = Mid(frmMain.aktdate.Caption, 4, 2)
    year = Right(frmMain.aktdate.Caption, 4)
    excelname = year + "-" + mounth + ".xls"
    If LenB(Dir$(App.Path + "\Datenbank\Statistik\" + excelname, vbDirectory)) = 0 Then fso.CopyFile App.Path + "\Datenbank\Statistik\vorlage.xls", App.Path + "\Datenbank\Statistik\" + excelname
    Call Werkzeuge.IsFileOpen(App.Path + "\Datenbank\Statistik\" + excelname, "1")
    
    With ExcelTable(App.Path + "\Datenbank\Statistik\" + excelname, "Tabelle1")
        .AbsolutePosition = 1
        .Update 0, "Aufnahme"
        .Close
    End With
    
    With ExcelTable(App.Path + "\Datenbank\Statistik\" + excelname, "Tabelle1")
        .AbsolutePosition = 1
        
        For i = 0 To 20
            .Update 3 + (i * 3), plbezeichnung.plID(i).Text 'Bezeichnungen aktualisieren
            If plbezeichnung.plID(i).Text = frmMain.infoplaylist.Caption Then number = i
        Next i
        
        If number = 100 Then GoTo ende
        .AbsolutePosition = Int(day) + 2
        .Update 0, frmMain.aktdate.Caption
        temp = .Fields(1 + (number * 3)).Value
        temp = temp + 1
        .Update (1 + (number * 3)), temp
ende:
        .Close
    End With
    Set fso = Nothing
End Sub
Public Sub AddDatagesamt()
    Dim pos1 As Integer, pos2 As Integer, day As String, mounth As String, year As String, fso As Object
    Dim excelname As String, i As Integer, number As Integer, temp As Integer
   
    number = 100
    Set fso = CreateObject("Scripting.FileSystemObject")
    day = Left(frmMain.aktdate.Caption, 2)
    mounth = Mid(frmMain.aktdate.Caption, 4, 2)
    year = Right(frmMain.aktdate.Caption, 4)
    excelname = year + "-" + mounth + ".xls"
    If LenB(Dir$(App.Path + "\Datenbank\Statistik\" + excelname, vbDirectory)) = 0 Then fso.CopyFile App.Path + "\Datenbank\Statistik\vorlage.xls", App.Path + "\Datenbank\Statistik\" + excelname
    Call Werkzeuge.IsFileOpen(App.Path + "\Datenbank\Statistik\" + excelname, "1")
    
    With ExcelTable(App.Path + "\Datenbank\Statistik\" + excelname, "Tabelle1")
        .AbsolutePosition = 1
        .Update 0, "Aufnahme"
        .Close
    End With
    
    With ExcelTable(App.Path + "\Datenbank\Statistik\" + excelname, "Tabelle1")
        .AbsolutePosition = 1
        
        For i = 0 To 20
            .Update 3 + (i * 3), plbezeichnung.plID(i) 'Bezeichnungen aktualisieren
            If plbezeichnung.plID(i).Text = frmMain.infoplaylist.Caption Then number = i
        Next i
        
        If number = 100 Then GoTo ende
        .AbsolutePosition = Int(day) + 2
        .Update 0, frmMain.aktdate.Caption
        temp = .Fields(2 + (number * 3)).Value
        temp = temp + 1
        .Update (2 + (number * 3)), temp
ende:
        .Close
    End With
    Set fso = Nothing
End Sub
Private Function ExcelTable(ByRef Path As String, ByRef Table As String) As ADODB.Recordset
  'Deklarationen:
  Dim SQL As String
  Dim Con As String
  
  'Los gehts:
  SQL = "select * from [" & Table & "$]"
  Con = "Provider=Microsoft.Jet.OLEDB.4.0;" _
      & "Extended Properties=Excel 8.0;" _
      & "Data Source=" & Path & ";"
  Set ExcelTable = New ADODB.Recordset
  ExcelTable.Open SQL, Con, adOpenKeyset, adLockOptimistic
End Function

