VERSION 5.00
Begin VB.UserControl SliderPic 
   Appearance      =   0  '2D
   AutoRedraw      =   -1  'True
   BackColor       =   &H00C0C0C0&
   ClientHeight    =   3600
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   4800
   MaskColor       =   &H00C0C0C0&
   ScaleHeight     =   240
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   320
   ToolboxBitmap   =   "SliderPic.ctx":0000
   Begin VB.PictureBox picMain 
      Appearance      =   0  '2D
      AutoRedraw      =   -1  'True
      BackColor       =   &H00FFFFFF&
      BorderStyle     =   0  'Kein
      ForeColor       =   &H80000008&
      Height          =   375
      Left            =   0
      ScaleHeight     =   25
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   201
      TabIndex        =   3
      Top             =   0
      Visible         =   0   'False
      Width           =   3015
   End
   Begin VB.PictureBox imPos 
      Appearance      =   0  '2D
      AutoRedraw      =   -1  'True
      AutoSize        =   -1  'True
      BackColor       =   &H80000005&
      BorderStyle     =   0  'Kein
      ForeColor       =   &H80000008&
      Height          =   255
      Left            =   240
      Picture         =   "SliderPic.ctx":0312
      ScaleHeight     =   17
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   6
      TabIndex        =   2
      Top             =   600
      Visible         =   0   'False
      Width           =   90
   End
   Begin VB.PictureBox imLeft 
      Appearance      =   0  '2D
      AutoRedraw      =   -1  'True
      AutoSize        =   -1  'True
      BackColor       =   &H80000005&
      BorderStyle     =   0  'Kein
      ForeColor       =   &H80000008&
      Height          =   75
      Left            =   120
      Picture         =   "SliderPic.ctx":04A8
      ScaleHeight     =   5
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   30
      TabIndex        =   1
      Top             =   2160
      Visible         =   0   'False
      Width           =   450
   End
   Begin VB.PictureBox Picture1 
      Appearance      =   0  '2D
      AutoRedraw      =   -1  'True
      AutoSize        =   -1  'True
      BackColor       =   &H80000005&
      BorderStyle     =   0  'Kein
      ForeColor       =   &H80000008&
      Height          =   75
      Left            =   120
      Picture         =   "SliderPic.ctx":06B6
      ScaleHeight     =   5
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   30
      TabIndex        =   0
      Top             =   1560
      Visible         =   0   'False
      Width           =   450
   End
End
Attribute VB_Name = "SliderPic"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'Default Property Values:
Const m_def_DisabledStyle = 0
Const m_def_DisabledIntense = 20
Const m_def_MaskColor = &HC0C0C0
Const m_def_BackStyle = 1
Const m_def_Style = 0
Const m_def_Enabled = True
Const m_def_CurPosition = 0
Const m_def_Min = 0
Const m_def_Max = 10
Const m_def_Orientation = 0
'Property Variables:
Dim m_DisabledIntense As Long
Dim m_MaskColor As OLE_COLOR
Dim m_Enabled As Boolean
Dim m_CurPosition As Long
Dim m_Min As Long
Dim m_Max As Long
Dim m_ImageSlider As Picture
Dim m_ImageLeft As Picture
Dim m_ImagePointer As Picture
'Event Declarations:
Event PositionChanged(oldPosition As Long, newPosition As Long)
Attribute PositionChanged.VB_Description = "Fired when position of pointer is changed"
'Event Click()
'Event DblClick()
'Event KeyDown(KeyCode As Integer, Shift As Integer)
'Event KeyPress(KeyAscii As Integer)
'Event KeyUp(KeyCode As Integer, Shift As Integer)
Event MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
Attribute MouseDown.VB_Description = "Occurs when the user presses the mouse button while an object has the focus."
Event MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
Attribute MouseMove.VB_Description = "Occurs when the user moves the mouse."
Event MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
Attribute MouseUp.VB_Description = "Occurs when the user releases the mouse button while an object has the focus."

'const for orientation
Public Enum SLIDER_ORIENTATION
    asLeftRight = 0 'minimum on left side
    asRightLeft = 1 'minimum on right side
    asTopBottom = 2 'minimum on top
    asBottomTop = 3 'minimum on bottom
End Enum
Private m_Orientation As SLIDER_ORIENTATION

'const for style
Public Enum WHAT_STYLE
    asStyleAnalog = 0
    asStyleDiscrete = 1
End Enum
Private m_Style As WHAT_STYLE

'const for backstyle
Public Enum BACKSTYLE_TO
    asTransparent = 0
    asOpaque = 1
End Enum
Dim m_BackStyle As Integer

Public Enum DISABLED_STYLE
    asShowLighter = 0
    asShowDarker = 1
End Enum
Dim m_DisabledStyle As DISABLED_STYLE

Private m_isPointerPicSet As Boolean
Private m_isSliderLeftPicSet As Boolean
Private sl_width As Long    'width of slider and left slider pictures
Private sl_height As Long   'height of slider and left slider pictures
Private sl_left As Long     'left position of slider and left slider pictures
Private sl_top As Long      'top position of slider and left slider pictures
Private pos_width As Long   'width of pointer picture
Private pos_height As Long  'height of pointer picture
Private pos_left As Long    'left position of pointer picture
Private pos_top As Long     'top position of pointer picture
Private xSl As Long, ySl As Long        'var to define if we clicked on pointer or not
Private pic_width As Long   'width of main picture
Private pic_height As Long  'height of main picture

Private Sub DrawControl()
'draws control according to settings into MainPic
Dim ret As Long
Dim uDC As Long

picMain.Width = pic_width
picMain.Height = pic_height

Set picMain.Picture = Nothing
picMain.BackColor = m_MaskColor
picMain.Refresh
uDC = picMain.hdc
'copy a slider to picture
ret = BitBlt(uDC, sl_left, sl_top, sl_width, sl_height, Picture1.hdc, 0, 0, SRCCOPY)
If m_Orientation = asLeftRight Then
    If m_Style = asStyleDiscrete Then pos_left = m_CurPosition * sl_width \ (m_Max - m_Min)
    'draw left slider if any on picture
    If m_isSliderLeftPicSet Then
        ret = TransparentBlt(uDC, sl_left, sl_top, pos_left, sl_height, imLeft.hdc, 0, 0, m_MaskColor)
    End If
ElseIf m_Orientation = asRightLeft Then
    If m_Style = asStyleDiscrete Then pos_left = m_CurPosition * sl_width \ (m_Max - m_Min)
    'draw right slider if any on picture
    If m_isSliderLeftPicSet Then
        ret = TransparentBlt(uDC, sl_left + pos_left, sl_top, sl_width - pos_left, sl_height, imLeft.hdc, sl_left + pos_left - pos_width / 2, 0, m_MaskColor)
    End If
ElseIf Orientation = asBottomTop Then
    If m_Style = asStyleDiscrete Then pos_top = m_CurPosition * sl_height \ (m_Max - m_Min)
    'draw left slider if any on picture
    If m_isSliderLeftPicSet Then
        ret = TransparentBlt(uDC, sl_left, sl_top + pos_top, sl_width, sl_height - pos_top, imLeft.hdc, 0, sl_top + pos_top - pos_height / 2, m_MaskColor)
    End If
ElseIf m_Orientation = asTopBottom Then
    If m_Style = asStyleDiscrete Then pos_top = m_CurPosition * sl_height \ (m_Max - m_Min)
    'draw left slider if any on picture
    If m_isSliderLeftPicSet Then
        ret = TransparentBlt(uDC, sl_left, sl_top, sl_width, pos_top, imLeft.hdc, 0, 0, m_MaskColor)
    End If
End If
'draw a pointer if any on picture
If m_isPointerPicSet Then
    ret = TransparentBlt(uDC, pos_left, pos_top, pos_width, pos_height, imPos.hdc, 0, 0, m_MaskColor)
    'ret = DrawTransparent(uDC, pos_left, pos_top, pos_width, pos_height, imPos.hdc, 0, 0, pos_width, pos_height, m_MaskColor)
End If

'create picture
Set picMain.Picture = picMain.Image
If m_Enabled = False Then
    Dim i As Long
    Dim j As Long
    Dim c As Long
    Dim r As Long, g As Long, b As Long
    Dim v As Long
    
    If m_DisabledStyle = asShowDarker Then v = -m_DisabledIntense Else v = m_DisabledIntense
    uDC = picMain.hdc
    For i = 0 To pic_width
        For j = 0 To pic_height
            c = GetPixel(uDC, i, j)
            If c >= 0 Then
                If c <> m_MaskColor Then
                    b = c \ (256# * 256#)
                    c = c - b * 256# * 256#
                    g = c \ 256#
                    r = c - g * 256#
                    If r < 128 Then r = r + v * 2.5 Else r = r + v
                    If g < 128 Then g = g + v * 2.5 Else g = g + v
                    If b < 128 Then b = b + v * 2.5 Else b = b + v
                    If r > 255 Then r = 255
                    If g > 255 Then g = 255
                    If b > 255 Then b = 255
                    If r < 0 Then r = 0
                    If g < 0 Then g = 0
                    If b < 0 Then b = 0
                    c = b * 256# * 256 + g * 256# + r
                    If c = m_MaskColor Then c = c + 1
                    SetPixelV uDC, i, j, c
                End If
            End If
        Next j
    Next i
    Set picMain.Picture = picMain.Image
End If

End Sub

Private Function PositionToPixels(m_pos As Long) As Long
'convert position to pixels
If m_Orientation = asLeftRight Then
    PositionToPixels = sl_width * (m_pos - m_Min) / (m_Max - m_Min)
ElseIf m_Orientation = asRightLeft Then
    PositionToPixels = sl_width * (m_pos - m_Max) / (m_Min - m_Max)
ElseIf m_Orientation = asTopBottom Then
    PositionToPixels = sl_height * (m_pos - m_Min) / (m_Max - m_Min)
ElseIf m_Orientation = asBottomTop Then
    PositionToPixels = sl_height * (m_pos - m_Max) / (m_Min - m_Max)
End If

End Function

Private Function PixelsToPosition(m_pix As Single) As Long
'convert pixels to position
If m_Orientation = asLeftRight Then
    PixelsToPosition = m_Min + (m_Max - m_Min) * (m_pix - sl_left) / sl_width
ElseIf m_Orientation = asRightLeft Then
    PixelsToPosition = m_Max + (m_Min - m_Max) * (m_pix - sl_left) / sl_width
ElseIf m_Orientation = asTopBottom Then
    PixelsToPosition = m_Min + (m_Max - m_Min) * (m_pix - sl_top) / sl_height
ElseIf m_Orientation = asBottomTop Then
    PixelsToPosition = m_Max + (m_Min - m_Max) * (m_pix - sl_top) / sl_height
End If

End Function

'I don't want for user to see this property - so it is private
Private Property Get isPointerPicSet() As Boolean
isPointerPicSet = m_isPointerPicSet

End Property

Private Property Let isPointerPicSet(ByVal New_isPointerPicSet As Boolean)
m_isPointerPicSet = New_isPointerPicSet
PropertyChanged "isPointerPicSet"

End Property

'I don't want for user to see this property - so it is private
Private Property Get isSliderLeftPicSet() As Boolean
isSliderLeftPicSet = m_isSliderLeftPicSet

End Property

Private Property Let isSliderLeftPicSet(ByVal New_isSliderLeftPicSet As Boolean)
m_isSliderLeftPicSet = New_isSliderLeftPicSet
PropertyChanged "isSliderLeftPicSet"

End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=0,0,0,True
Public Property Get Enabled() As Boolean
Attribute Enabled.VB_Description = "Returns/sets a value that determines whether an object can respond to user-generated events."
Enabled = m_Enabled

End Property

Public Property Let Enabled(ByVal New_Enabled As Boolean)
    m_Enabled = New_Enabled
    PropertyChanged "Enabled"
    If m_Enabled = True Then
        UserControl.Enabled = True
    Else
        UserControl.Enabled = False
    End If
Call UserControl_Resize

End Property

Public Property Get Orientation() As SLIDER_ORIENTATION
Orientation = m_Orientation

End Property

Public Property Let Orientation(ByVal New_Orientation As SLIDER_ORIENTATION)
m_Orientation = New_Orientation
PropertyChanged "Orientation"
If (m_Orientation = asLeftRight) Or (m_Orientation = asRightLeft) Then
    pos_left = PositionToPixels(m_CurPosition)
Else
    pos_top = PositionToPixels(m_CurPosition)
End If
UserControl_Resize

End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=8,0,0,0
Public Property Get CurPosition() As Long
Attribute CurPosition.VB_Description = "Sets or returns current pointer's position"
CurPosition = m_CurPosition

End Property

Public Property Let CurPosition(ByVal New_CurPosition As Long)
If New_CurPosition < m_Min Then New_CurPosition = m_Min
If New_CurPosition > m_Max Then New_CurPosition = m_Max
m_CurPosition = New_CurPosition
PropertyChanged "CurPosition"
If (m_Orientation = asLeftRight) Or (m_Orientation = asRightLeft) Then
    pos_left = PositionToPixels(m_CurPosition)
Else
    pos_top = PositionToPixels(m_CurPosition)
End If
Call UserControl_Resize

End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=8,0,0,0
Public Property Get Min() As Long
Attribute Min.VB_Description = "Sets or returns minimum pointer's position"
Min = m_Min

End Property

Public Property Let Min(ByVal New_Min As Long)
If New_Min < m_Max Then
    m_Min = New_Min
    PropertyChanged "Min"
    If m_CurPosition < m_Min Then m_CurPosition = m_Min
    If (m_Orientation = asLeftRight) Or (m_Orientation = asRightLeft) Then
        pos_left = PositionToPixels(m_CurPosition)
    Else
        pos_top = PositionToPixels(m_CurPosition)
    End If
    Call UserControl_Resize
Else
    Err.Raise 513, "ActiveSlider", "Minimum must be less than Maximum"
End If

End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=8,0,0,10
Public Property Get Max() As Long
Attribute Max.VB_Description = "Sets or returns maximum pointer's position"
Max = m_Max

End Property

Public Property Let Max(ByVal New_Max As Long)
If New_Max > m_Min Then
    m_Max = New_Max
    PropertyChanged "Max"
    If m_CurPosition > m_Max Then m_CurPosition = m_Max
    If (m_Orientation = asLeftRight) Or (m_Orientation = asRightLeft) Then
        pos_left = PositionToPixels(m_CurPosition)
    Else
        pos_top = PositionToPixels(m_CurPosition)
    End If
    Call UserControl_Resize
Else
    Err.Raise 514, "ActiveSlider", "Maximum must be greater than Minimum"
End If

End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=11,0,0,0
Public Property Get ImageSlider() As Picture
Attribute ImageSlider.VB_Description = "Sets picture for slider"
Set ImageSlider = m_ImageSlider

End Property

Public Property Set ImageSlider(ByVal New_ImageSlider As Picture)
Set m_ImageSlider = New_ImageSlider
PropertyChanged "ImageSlider"
Set Picture1.Picture = m_ImageSlider
sl_width = Picture1.Width
sl_height = Picture1.Height
Call UserControl_Resize
    
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=11,0,0,0
Public Property Get ImageLeft() As Picture
Attribute ImageLeft.VB_Description = "Sets picture to show on the left of pointer"
Set ImageLeft = m_ImageLeft

End Property

Public Property Set ImageLeft(ByVal New_ImageLeft As Picture)
Set m_ImageLeft = New_ImageLeft
PropertyChanged "ImageLeft"
Set imLeft.Picture = m_ImageLeft
'check if picture is set
If TypeName(m_ImageLeft) = "Nothing" Then
    m_isSliderLeftPicSet = False
Else
    m_isSliderLeftPicSet = True
End If
PropertyChanged "isSliderLeftPicSet"

End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=11,0,0,0
Public Property Get ImagePointer() As Picture
Attribute ImagePointer.VB_Description = "Sets pipcture for pointer. Use icon to make it transparent"
Set ImagePointer = m_ImagePointer

End Property

Public Property Set ImagePointer(ByVal New_ImagePointer As Picture)
Set m_ImagePointer = New_ImagePointer
PropertyChanged "ImagePointer"
Set imPos.Picture = m_ImagePointer
'check if picture is set
If TypeName(m_ImagePointer) = "Nothing" Then
    m_isPointerPicSet = False
    pos_width = 0
    pos_height = 0
Else
    m_isPointerPicSet = True
    pos_width = imPos.Width
    pos_height = imPos.Height
End If
PropertyChanged "isPointerPicSet"
If (m_Orientation = asLeftRight) Or (m_Orientation = asRightLeft) Then
    pos_left = PositionToPixels(m_CurPosition)
Else
    pos_top = PositionToPixels(m_CurPosition)
End If
Call UserControl_Resize

End Property

'Initialize Properties for User Control
Private Sub UserControl_InitProperties()
    m_Enabled = m_def_Enabled
    m_CurPosition = m_def_CurPosition
    m_Min = m_def_Min
    m_Max = m_def_Max
    m_DisabledStyle = m_def_DisabledStyle
    m_DisabledIntense = m_def_DisabledIntense
    m_Style = m_def_Style
    m_BackStyle = m_def_BackStyle
    m_MaskColor = m_def_MaskColor
    m_Orientation = m_def_Orientation
    
    'load default pictures in control
    Set m_ImageSlider = Picture1.Picture
    Set m_ImageLeft = imLeft.Picture
    Set m_ImagePointer = imPos.Picture
    pos_width = imPos.Width
    pos_height = imPos.Height
    sl_width = Picture1.Width
    sl_height = Picture1.Height
    
    UserControl.BackStyle = m_BackStyle
    UserControl.MaskColor = m_MaskColor
    xSl = -1
    ySl = -1
    m_isSliderLeftPicSet = True
    m_isPointerPicSet = True
    picMain.BackColor = m_MaskColor
End Sub

Private Sub UserControl_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)

If Button = 1 Then
    If m_isPointerPicSet Then
        'go here only if pointer picture is set, otherwise the control is
        '  just a progress bar, no mouse activities tracked
        Dim np As Long
        If (m_Orientation = asLeftRight) Or (m_Orientation = asRightLeft) Then
            'horizontal slider
            If x > pos_left And x < pos_left + pos_width Then
                'we are on the pointer - prepare to slide it
                xSl = 0
            Else
                'move the pointer at current point immediately
                If x < sl_left Then x = sl_left
                If x > sl_width + sl_left Then x = sl_width + sl_left
                pos_left = x - sl_left
                np = PixelsToPosition(x)
                RaiseEvent PositionChanged(m_CurPosition, np)
                m_CurPosition = np
                PropertyChanged ("CurPosition")
                DrawControl
                UserControl.Picture = picMain.Picture
                UserControl.MaskPicture = picMain.Picture
                xSl = -1
            End If
        Else
            'vertical slider
            If y > pos_top And y < pos_top + pos_height Then
                'we are on the pointer - prepare to slide
                ySl = 0
            Else
                'move the pointer at current point immediately
                If y < sl_top Then y = sl_top
                If y > sl_height + sl_top Then y = sl_height + sl_top
                pos_top = y - sl_top
                np = PixelsToPosition(y)
                RaiseEvent PositionChanged(m_CurPosition, np)
                m_CurPosition = np
                PropertyChanged ("CurPosition")
                DrawControl
                UserControl.Picture = picMain.Picture
                UserControl.MaskPicture = picMain.Picture
                ySl = -1
            End If
        End If
    End If
End If

End Sub
Private Sub UserControl_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
Dim np As Long

If Button = 1 Then
    If m_isPointerPicSet Then
        
        If (m_Orientation = asLeftRight) Or (m_Orientation = asRightLeft) Then
            'horizontal slider
            If xSl = -1 Then Exit Sub
            If x < sl_left Then x = sl_left
            If x > sl_width + sl_left Then x = sl_width + sl_left
            pos_left = x - sl_left
            np = PixelsToPosition(x)
        Else
            'vertical slider
            If ySl = -1 Then Exit Sub
            If y < sl_top Then y = sl_top
            If y > sl_height + sl_top Then y = sl_height + sl_top
            pos_top = y - sl_top
            np = PixelsToPosition(y)
        End If
        RaiseEvent PositionChanged(m_CurPosition, np)
        m_CurPosition = np
        PropertyChanged ("CurPosition")
        DrawControl
        Set UserControl.Picture = picMain.Picture
        Set UserControl.MaskPicture = picMain.Picture
        UserControl.Refresh
    End If
End If

End Sub

Private Sub UserControl_Mouseup(Button As Integer, Shift As Integer, x As Single, y As Single)


If Button = 1 Then xSl = -1: ySl = -1
End Sub

'Load property values from storage
Private Sub UserControl_ReadProperties(PropBag As PropertyBag)

    m_Enabled = PropBag.ReadProperty("Enabled", m_def_Enabled)
    m_CurPosition = PropBag.ReadProperty("CurPosition", m_def_CurPosition)
    m_Min = PropBag.ReadProperty("Min", m_def_Min)
    m_Max = PropBag.ReadProperty("Max", m_def_Max)
    m_isSliderLeftPicSet = PropBag.ReadProperty("isSliderLeftPicSet", True)
    m_isPointerPicSet = PropBag.ReadProperty("isPointerPicSet", True)
    Set m_ImageSlider = PropBag.ReadProperty("ImageSlider", Nothing)
    Set m_ImageLeft = PropBag.ReadProperty("ImageLeft", Nothing)
    Set m_ImagePointer = PropBag.ReadProperty("ImagePointer", Nothing)
    m_Style = PropBag.ReadProperty("Style", m_def_Style)
    m_BackStyle = PropBag.ReadProperty("BackStyle", m_def_BackStyle)
    m_MaskColor = PropBag.ReadProperty("MaskColor", m_def_MaskColor)
    
    Set imPos.Picture = m_ImagePointer
    Set imLeft.Picture = m_ImageLeft
    Set Picture1.Picture = m_ImageSlider
    UserControl.BackStyle = m_BackStyle
    UserControl.MaskColor = m_MaskColor
    sl_width = Picture1.Width
    sl_height = Picture1.Height
    If m_isPointerPicSet Then
        pos_width = imPos.Width
        pos_height = imPos.Height
    Else
        pos_width = 0
        pos_height = 0
    End If
    m_Orientation = PropBag.ReadProperty("Orientation", m_def_Orientation)
    
    If (m_Orientation = asLeftRight) Or (m_Orientation = asRightLeft) Then
        pos_left = PositionToPixels(m_CurPosition)
    Else
        pos_top = PositionToPixels(m_CurPosition)
    End If
    xSl = -1
    ySl = -1
    m_DisabledStyle = PropBag.ReadProperty("DisabledStyle", m_def_DisabledStyle)
    m_DisabledIntense = PropBag.ReadProperty("DisabledIntense", m_def_DisabledIntense)
End Sub

Private Sub UserControl_Resize()
'resize according to picture's heights
If (m_Orientation = asLeftRight) Or (m_Orientation = asRightLeft) Then
    If sl_height > pos_height Then
        pos_top = (sl_height - pos_height) / 2
        sl_top = 0
        pic_height = sl_height
    Else
        sl_top = (pos_height - sl_height) / 2
        pos_top = 0
        pic_height = pos_height
    End If
    pic_width = sl_width + pos_width
    sl_left = pos_width / 2
Else
    'vertical slider
    If sl_width > pos_width Then
        pos_left = (sl_width - pos_width) / 2
        sl_left = 0
        pic_width = sl_width
    Else
        sl_left = (pos_width - sl_width) / 2
        pos_left = 0
        pic_width = pos_width
    End If
    pic_height = sl_height + pos_height
    sl_top = pos_height / 2
End If
UserControl.Height = pic_height * Screen.TwipsPerPixelX
UserControl.Width = pic_width * Screen.TwipsPerPixelX
DrawControl
Set UserControl.Picture = picMain.Image
Set UserControl.MaskPicture = picMain.Picture

End Sub

'Write property values to storage
Private Sub UserControl_WriteProperties(PropBag As PropertyBag)
    Call PropBag.WriteProperty("Enabled", m_Enabled, m_def_Enabled)
    Call PropBag.WriteProperty("CurPosition", m_CurPosition, m_def_CurPosition)
    Call PropBag.WriteProperty("Min", m_Min, m_def_Min)
    Call PropBag.WriteProperty("Max", m_Max, m_def_Max)
    Call PropBag.WriteProperty("ImageSlider", m_ImageSlider, Nothing)
    Call PropBag.WriteProperty("ImageLeft", m_ImageLeft, Nothing)
    Call PropBag.WriteProperty("ImagePointer", m_ImagePointer, Nothing)
    Call PropBag.WriteProperty("Style", m_Style, m_def_Style)
    Call PropBag.WriteProperty("BackStyle", m_BackStyle, m_def_BackStyle)
    Call PropBag.WriteProperty("MaskColor", m_MaskColor, m_def_MaskColor)
    Call PropBag.WriteProperty("isSliderLeftPicSet", m_isSliderLeftPicSet, True)
    Call PropBag.WriteProperty("isPointerPicSet", m_isPointerPicSet, True)
    Call PropBag.WriteProperty("Orientation", m_Orientation, m_def_Orientation)
    
    Call PropBag.WriteProperty("DisabledStyle", m_DisabledStyle, m_def_DisabledStyle)
    Call PropBag.WriteProperty("DisabledIntense", m_DisabledIntense, m_def_DisabledIntense)
End Sub

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=8,0,0,0
Public Property Get Style() As WHAT_STYLE
Attribute Style.VB_Description = "Sets pointer behavior"
    Style = m_Style
End Property

Public Property Let Style(ByVal New_Style As WHAT_STYLE)
m_Style = New_Style
PropertyChanged "Style"
'Call UserControl_Resize

End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=7,0,0,0
Public Property Get BackStyle() As BACKSTYLE_TO
Attribute BackStyle.VB_Description = "Indicates whether a Label or the background of a Shape is transparent or opaque."
BackStyle = m_BackStyle

End Property

Public Property Let BackStyle(ByVal New_BackStyle As BACKSTYLE_TO)
m_BackStyle = New_BackStyle
PropertyChanged "BackStyle"
UserControl.BackStyle = m_BackStyle
Call UserControl_Resize

End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=10,0,0,&h00C0C0C0
Public Property Get MaskColor() As OLE_COLOR
Attribute MaskColor.VB_Description = "Returns/sets the color that specifies transparent areas."
MaskColor = m_MaskColor

End Property

Public Property Let MaskColor(ByVal New_MaskColor As OLE_COLOR)
m_MaskColor = New_MaskColor
PropertyChanged "MaskColor"
UserControl.MaskColor = m_MaskColor
picMain.BackColor = m_MaskColor
Call UserControl_Resize

End Property
'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=8,0,0,0
Public Property Get DisabledStyle() As DISABLED_STYLE
Attribute DisabledStyle.VB_Description = "Sets how to show disabled image"
DisabledStyle = m_DisabledStyle

End Property

Public Property Let DisabledStyle(ByVal New_DisabledStyle As DISABLED_STYLE)
m_DisabledStyle = New_DisabledStyle
PropertyChanged "DisabledStyle"
DrawControl
Set UserControl.Picture = picMain.Image
Set UserControl.MaskPicture = picMain.Picture

End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=8,0,0,20
Public Property Get DisabledIntense() As Long
Attribute DisabledIntense.VB_Description = "Sets the value to be added/subtracted from each pixel color when draw disabled control"
DisabledIntense = m_DisabledIntense

End Property

Public Property Let DisabledIntense(ByVal New_DisabledIntense As Long)
If New_DisabledIntense > 85 Then
    Exit Property
ElseIf New_DisabledIntense < 0 Then
    Exit Property
End If
m_DisabledIntense = New_DisabledIntense
PropertyChanged "DisabledIntense"
DrawControl
Set UserControl.Picture = picMain.Image
Set UserControl.MaskPicture = picMain.Picture

End Property

