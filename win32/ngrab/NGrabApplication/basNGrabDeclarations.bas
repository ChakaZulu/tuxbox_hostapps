Attribute VB_Name = "basNGrabDeclarations"
'-----------------------------------------------------------------------
' <DOC>
' <MODULE>
'
' <NAME>
'   basNGrabDeclarations
' </NAME>
'
' <DESCRIPTION>
'   Global Declarations
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
'   26.07.2002 - LYNX Neues Modul für Globale Declarationen eingeführt (Kommt bald in externe Library)
'   31.07.2002 - LYNX Modul enhält ab sofort nur noch Globale Variable! Alle anderen Deklarationen wurden bereits gekapselt! Neue Variable nil eingeführt
' </HISTORY>
'
' </MODULE>
' </DOC>
'-----------------------------------------------------------------------
Option Explicit

Public nil As Variant

Public goEngine As clsNGrabEngine

Public goSettings As clsNOXParameterBag

Public goHelp As clsNOXHTMLHelp

Public gsD2SINIFile As String
Public gsProjectFile As String
Public gsINIFile As String
