Attribute VB_Name = "Module1"
Declare Function PatBlt Lib "gdi32" (ByVal hdc As Long, ByVal x As Long, ByVal y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal dwRop As Long) As Long
Declare Function BitBlt Lib "gdi32" (ByVal hDestDC As Long, ByVal x As Long, ByVal y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hSrcDC As Long, ByVal XSrc As Long, ByVal YSrc As Long, ByVal dwRop As Long) As Long
Declare Function SetBkColor Lib "gdi32" (ByVal hdc As Long, ByVal crColor As Long) As Long
Declare Function CreateCompatibleBitmap Lib "gdi32" (ByVal hdc As Long, ByVal nWidth As Long, ByVal nHeight As Long) As Long
Declare Function CreateCompatibleDC Lib "gdi32" (ByVal hdc As Long) As Long
Declare Function SelectObject Lib "gdi32" (ByVal hdc As Long, ByVal hObject As Long) As Long
Declare Function DeleteObject Lib "gdi32" (ByVal hObject As Long) As Long
Declare Function CreateBitmap Lib "gdi32" (ByVal nWidth As Long, ByVal nHeight As Long, ByVal nPlanes As Long, ByVal nBitCount As Long, lpBits As Any) As Long
Declare Function DeleteDC Lib "gdi32" (ByVal hdc As Long) As Long
Declare Function CreateSolidBrush Lib "gdi32" (ByVal crColor As Long) As Long
Public Declare Function GetPixel Lib "gdi32" (ByVal hdc As Long, ByVal x As Long, ByVal y As Long) As Long
Public Declare Function SetPixelV Lib "gdi32" (ByVal hdc As Long, ByVal x As Long, ByVal y As Long, ByVal crColor As Long) As Long
Public Declare Function AlphaBlending Lib "msimg32.dll" Alias "AlphaBlend" (ByVal hdcDest As Long, ByVal nXOriginDest As Long, ByVal nYOriginDest As Long, ByVal nWidthDest As Long, ByVal nHeightDest As Long, ByVal hdcSrc As Long, ByVal nXOriginSrc As Long, ByVal nYOriginSrc As Long, ByVal nWidthSrc As Long, ByVal nHeightSrc As Long, ByVal BF As Long) As Long
'Public Declare Function DrawTransparent Lib "msimg32.dll" Alias "TransparentBlt" (ByVal hdcDest As Long, ByVal nXOriginDest As Long, ByVal nYOriginDest As Long, ByVal nWidthDest As Long, ByVal nHeightDest As Long, ByVal hdcSrc As Long, ByVal nXOriginSrc As Long, ByVal nYOriginSrc As Long, ByVal nWidthSrc As Long, ByVal nHeightSrc As Long, ByVal crTransparent As Long) As Long
Public Declare Function SetCursorPos Lib "user32" (ByVal x As Long, ByVal y As Long) As Long

Public Const SRCAND = &H8800C6 ' (DWORD) dest = source AND dest
Public Const SRCCOPY = &HCC0020 ' (DWORD) dest = source
Public Const SRCINVERT = &H660046 ' (DWORD) dest = source XOR dest
Public Const PATCOPY = &HF00021

Function TransparentBlt(hDestDC As Long, nDestX, nDestY, nWidth, nHeight, hSourceDC As Long, nSourceX, nSourceY, lTransColor As Long) As Long
'This function copies a bitmap from one device context to the other
'where every pixel in the source bitmap that matches the specified
'color becomes transparent, letting the destination bitmap show through.
Dim lOldColor As Long
Dim hMaskDC As Long
Dim hMaskBmp As Long
Dim hOldMaskBmp As Long
Dim hTempBmp As Long
Dim hTempDC As Long
Dim hOldTempBmp As Long
Dim hDummy As Long
'The Background colors of Source and Destination DCs must
'be the transparancy color in order to create a mask.
lOldColor = SetBkColor(hSourceDC, lTransColor)
lOldColor = SetBkColor(hDestDC, lTransColor)
'The mask DC must be compatible with the destination dc,
'   but the mask has to be created as a monochrome bitmap.
'For this reason, we create a compatible dc and bitblt
'   the mono mask into it.
'Create the Mask DC, and a compatible bitmap to go in it.
hMaskDC = CreateCompatibleDC(hDestDC)
hMaskBmp = CreateCompatibleBitmap(hDestDC, nWidth, nHeight)
'Move the Mask bitmap into the Mask DC
hOldMaskBmp = SelectObject(hMaskDC, hMaskBmp)
'Create a monochrome bitmap that will be the actual mask bitmap.
hTempBmp = CreateBitmap(nWidth, nHeight, 1, 1, 0&)
'Create a temporary DC, and put the mono bitmap into it
hTempDC = CreateCompatibleDC(hDestDC)
hOldTempBmp = SelectObject(hTempDC, hTempBmp)
'BitBlt the Source image into the mono dc to create a mono mask.

hDummy = BitBlt(hTempDC, 0, 0, nWidth, nHeight, hSourceDC, nSourceX, nSourceY, SRCCOPY)
'Copy the mono mask into our Mask DC
hDummy = BitBlt(hMaskDC, 0, 0, nWidth, nHeight, hTempDC, 0, 0, SRCCOPY)

'Clean up temp DC and bitmap
hTempBmp = SelectObject(hTempDC, hOldTempBmp)
hDummy = DeleteObject(hTempBmp)
hDummy = DeleteDC(hTempDC)
'Copy the source to the destination with XOR
hDummy = BitBlt(hDestDC, nDestX, nDestY, nWidth, nHeight, hSourceDC, nSourceX, nSourceY, SRCINVERT)
'Copy the Mask to the destination with AND
hDummy = BitBlt(hDestDC, nDestX, nDestY, nWidth, nHeight, hMaskDC, 0, 0, SRCAND)
'Again, copy the source to the destination with XOR
TransparentBlt = BitBlt(hDestDC, nDestX, nDestY, nWidth, nHeight, hSourceDC, nSourceX, nSourceY, SRCINVERT)

'Clean up mask DC and bitmap
hMaskBmp = SelectObject(hMaskDC, hOldMaskBmp)
hDummy = DeleteObject(hMaskBmp)
hDummy = DeleteDC(hMaskDC)

End Function
