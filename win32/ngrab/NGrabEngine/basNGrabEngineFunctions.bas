Attribute VB_Name = "basNGrabEngineFunctions"
Option Explicit

Public Function gsXMLParse(sXMLData As String, sTag As String) As String
            
    Dim sStart As String
    Dim sEnd As String
    Dim sDiff As String
    Dim sTagOpen As String
    Dim sTagClose As String
    
    sTagOpen = "<" & sTag & ">"
    sTagClose = "</" & sTag & ">"
        
    sStart = InStr(sXMLData, sTagOpen) + Len(sTagOpen)
    sEnd = InStr(sXMLData, sTagClose)
    sDiff = sEnd - sStart
    gsXMLParse = Mid(sXMLData, sStart, sDiff)
       
End Function

Public Sub gSystemDateSet(dtDate As Date)

    Dim sDate() As String
    
    sDate() = Split(dtDate, " ")
    DateTime.Date = sDate(0)
    DateTime.Time = sDate(1)

End Sub

