Attribute VB_Name = "basNGrabMain"
'-----------------------------------------------------------------------
' <DOC>
' <MODULE>
'
' <NAME>
'   basNGrabMain.bas
' </NAME>
'
' <DESCRIPTION>
'   NGrab Main
' </DESCRIPTION>
'
' <NOTES>
' </NOTES>
'
' <COPYRIGHT>
'   Copyright (c) Reinhard Eidelsburger
' </COPYRIGHT>
'
' <AUTHOR>
'   RE
' </AUTHOR>
'
' <HISTORY>
'   22.07.2002 - RE Hinzuf�gen von Main-Modul
'   26.07.2002 - LYNX mAppInit hinzugef�gt, SplashScreen wird angezeigt bis frmNGrabMain geladen ist, Hourglass hinzugef�gt
'   30.07.2002 - LYNX Splash Screen wird nun w�hrend des Laden des Hauptformulares angezeigt. Hourglass entfernt.
'   03.08.2002 - LYNX mAppInit ge�ndert, Einlesen der RegistrySettings
' </HISTORY>
'
' </MODULE>
' </DOC>
'-----------------------------------------------------------------------

Option Explicit

Sub Main()

    Call mAppInit

End Sub

Private Sub mAppInit()
    
    Set goHelp = New clsNOXHTMLHelp
    goHelp.Init (App.Path & "\" & NLSHelpFile)
    
    Set goSettings = New clsNOXParameterBag
    Call gRegistrySettingsRead
    
    Load frmNGrabMain

End Sub

