{Bug: TTeRadioGroup dosen't rearrange the buttons when the scrollrange changes
      - Call ArrangeButtons to ensure }
unit TeControls;

interface

uses
  Windows, Messages,
  Classes, SysUtils, Graphics,
  Controls, StdCtrls, ExtCtrls, Forms,
  TeImgList;

type
  TTeScrollingCustomControl = class(TScrollingWinControl)
  private
    FCanvas: TCanvas;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
  protected
    procedure Paint; virtual;
    procedure PaintWindow(DC: HDC); override;
    property Canvas: TCanvas read FCanvas;
    property AutoScroll default False;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TTeCustomPanel = class(TTeScrollingCustomControl)
  private
    FAutoSizeDocking: Boolean;
    FBevelInner: TPanelBevel;
    FBevelOuter: TPanelBevel;
    FBevelWidth: TBevelWidth;
    FBorderWidth: TBorderWidth;
    FFullRepaint: Boolean;
    FLocked: Boolean;
    FAlignment: TAlignment;
    FHeavyBorder: Boolean;
    FOuterBorderWidth: TBorderWidth;
    FBevelPixels: Integer;
    procedure CMIsToolControl(var Message: TMessage); message CM_ISTOOLCONTROL;
    procedure CMParentColorChanged(var Message: TMessage); message CM_PARENTCOLORCHANGED;
    procedure CMColorChanged(var Message: TMessage); message CM_COLORCHANGED;
    procedure WMNCCalcSize(var Message: TWMNCCalcSize); message WM_NCCALCSIZE;
    procedure WMNCPaint(var Message: TMessage); message WM_NCPAINT;
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
    procedure SetAlignment(Value: TAlignment);
    procedure SetBevelInner(Value: TPanelBevel);
    procedure SetBevelOuter(Value: TPanelBevel);
    procedure SetBevelWidth(Value: TBevelWidth);
    procedure SetBorderWidth(Value: TBorderWidth);
    procedure SetOuterBorderWidth(const Value: TBorderWidth);
    procedure SetHeavyBorder(const Value: Boolean);
    procedure CMDockClient(var Message: TCMDockClient); message CM_DOCKCLIENT;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    function CanAutoSize(var NewWidth, NewHeight: Integer): Boolean; override;
    procedure Paint; override;
    property Alignment: TAlignment read FAlignment write SetAlignment default taCenter;
    property BevelInner: TPanelBevel read FBevelInner write SetBevelInner default bvNone;
    property BevelOuter: TPanelBevel read FBevelOuter write SetBevelOuter default bvRaised;
    property BevelWidth: TBevelWidth read FBevelWidth write SetBevelWidth default 1;
    property BorderWidth: TBorderWidth read FBorderWidth write SetBorderWidth default 0;
    property OuterBorderWidth: TBorderWidth read FOuterBorderWidth write SetOuterBorderWidth default 0;
    property HeavyBorder: Boolean read FHeavyBorder write SetHeavyBorder default False;
    property Color default clBtnFace;
    property FullRepaint: Boolean read FFullRepaint write FFullRepaint default False;
    property Locked: Boolean read FLocked write FLocked default False;
    property ParentColor default False;
    property UseDockManager default True;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetControlsAlignment: TAlignment; override;
  end;

  TTePanel = class(TTeCustomPanel)
  public
    property DockManager;
  published
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize;
    property BevelInner;
    property BevelOuter;
    property BevelWidth;
    property BorderWidth;
    property OuterBorderWidth;
    property HeavyBorder;
    property Caption;
    property Color;
    property Constraints;
    property Ctl3D;
    property UseDockManager;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FullRepaint;
    property Font;
    property Locked;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnCanResize;
    property OnClick;
    property OnConstrainedResize;
    property OnDockDrop;
    property OnDockOver;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetSiteInfo;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;

  TTeSplitter = class(TSplitter)
  published
    property OnMouseUp;
    property Enabled;
  end;

  TTeCheckBox = class(TCheckBox)
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  published
    property Align;
  end;

  TTeRadioButton = class(TRadioButton)
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  published
    property Align;
  end;

  TTeGroupStyle = (gsBox, gsTopLine, gsNoLine);
  TTeGroupOption = (goBoldCaption, goImageInFront, goMonoImage, goTrackFocus);
  TTeGroupOptions = set of TTeGroupOption;

  TTeGroupBox = class(TTeScrollingCustomControl)
  private
    FCaptionHeight: integer;
    FGroupStyle: TTeGroupStyle;
    FGroupOptions: TTeGroupOptions;
    FFocused: Boolean;
    FImageName: string;
    procedure CMEnter(var Message); message CM_ENTER;
    procedure CMExit(var Message); message CM_EXIT;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure WMNCCalcSize(var Message: TWMNCCalcSize); message WM_NCCALCSIZE;
    procedure WMNCPaint(var Message: TMessage); message WM_NCPAINT;
    procedure WMVScroll(var Message: TMessage); message WM_VSCROLL;
    procedure WMHScroll(var Message: TMessage); message WM_HSCROLL;
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure SetGroupStyle(const Value: TTeGroupStyle);
    procedure SetGroupOptions(const Value: TTeGroupOptions);
    procedure SetImageName(const Value: string);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Style: TTeGroupStyle read FGroupStyle write SetGroupStyle default gsTopLine;
    property Options: TTeGroupOptions read FGroupOptions write SetGroupOptions default [goBoldCaption];
    property ImageName: string read FImageName write SetImageName;
    property Align;
    property Anchors;
    property BiDiMode;
    property Caption;
    property Color;
    property Constraints;
    property Ctl3D;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDockDrop;
    property OnDockOver;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetSiteInfo;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;

  TTeRadioGroup = class(TTeGroupBox)
  private
    FButtons: TList;
    FItems: TStrings;
    FItemIndex: Integer;
    FColumns: Integer;
    FReading: Boolean;
    FUpdating: Boolean;
    procedure ButtonClick(Sender: TObject);
    procedure ItemsChange(Sender: TObject);
    procedure SetButtonCount(Value: Integer);
    procedure SetColumns(Value: Integer);
    procedure SetItemIndex(Value: Integer);
    procedure SetItems(Value: TStrings);
    procedure UpdateButtons;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMHScroll(var Message: TWMHScroll); message WM_HSCROLL;
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
  protected
    procedure ReadState(Reader: TReader); override;
    function CanModify: Boolean; virtual;
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    procedure CreateWnd; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure FlipChildren(AllLevels: Boolean); override;
    procedure ArrangeButtons;
  published
    property Columns: Integer read FColumns write SetColumns default 1;
    property ItemIndex: Integer read FItemIndex write SetItemIndex default -1;
    property Items: TStrings read FItems write SetItems;
  end;

  TTeEdit = class(TEdit)
  published
    property Align;
  end;

procedure WriteText(aCanvas: TCanvas; aRect: TRect; DX, DY: Integer;
  const Text: string; Alignment: TAlignment; ARightToLeft: Boolean);

implementation

uses
  Math;

procedure WriteText(aCanvas: TCanvas; aRect: TRect; DX, DY: Integer;
  const Text: string; Alignment: TAlignment; ARightToLeft: Boolean);
const
  AlignFlags                  : array[TAlignment] of Integer =
    (DT_LEFT or DT_WORDBREAK or DT_EXPANDTABS or DT_NOPREFIX,
    DT_RIGHT or DT_WORDBREAK or DT_EXPANDTABS or DT_NOPREFIX,
    DT_CENTER or DT_WORDBREAK or DT_EXPANDTABS or DT_NOPREFIX);
  RTL                         : array[Boolean] of Integer = (0, DT_RTLREADING);
var
  B, R                        : TRect;
  Hold, Left                  : Integer;
  i                           : TColorRef;
  DrawBitmap                  : TBitmap;
begin
  i := ColorToRGB(aCanvas.Brush.Color);
  if GetNearestColor(aCanvas.Handle, i) = i then begin      { Use ExtTextOut for solid colors }
    { In BiDi, because we changed the window origin, the text that does not
      change alignment, actually gets its alignment changed. }
    if (aCanvas.CanvasOrientation = coRightToLeft) and (not ARightToLeft) then
      ChangeBiDiModeAlignment(Alignment);
    case Alignment of
      taLeftJustify:
        Left := aRect.Left + DX;
      taRightJustify:
        Left := aRect.Right - aCanvas.TextWidth(Text) - 3;
    else                                                    { taCenter }
      Left := aRect.Left + (aRect.Right - aRect.Left) shr 1
        - (aCanvas.TextWidth(Text) shr 1);
    end;
    aCanvas.TextRect(aRect, Left, aRect.Top + DY, Text);
  end
  else begin                                                { Use FillRect and Drawtext for dithered colors }
    DrawBitmap := TBitmap.Create;
    try
      DrawBitmap.Canvas.Lock;
      try
        with DrawBitmap, aRect do { Use offscreen bitmap to eliminate flicker and }  begin { brush origin tics in painting / scrolling.    }
          Width := Max(Width, Right - Left);
          Height := Max(Height, Bottom - Top);
          R := Rect(DX, DY, Right - Left - 1, Bottom - Top - 1);
          B := Rect(0, 0, Right - Left, Bottom - Top);
        end;
        with DrawBitmap.Canvas do begin
          Font := aCanvas.Font;
          Font.Color := aCanvas.Font.Color;
          Brush := aCanvas.Brush;
          Brush.Style := bsSolid;
          FillRect(B);
          SetBkMode(Handle, TRANSPARENT);
          if (aCanvas.CanvasOrientation = coRightToLeft) then
            ChangeBiDiModeAlignment(Alignment);
          DrawText(Handle, PChar(Text), Length(Text), R,
            AlignFlags[Alignment] or RTL[ARightToLeft]);
        end;
        if (aCanvas.CanvasOrientation = coRightToLeft) then begin
          Hold := aRect.Left;
          aRect.Left := aRect.Right;
          aRect.Right := Hold;
        end;
        aCanvas.CopyRect(aRect, DrawBitmap.Canvas, B);
      finally
        DrawBitmap.Canvas.Unlock;
      end;
    finally
      FreeAndNil(DrawBitmap);
    end;
  end;
end;

{ TTeScrollingCustomControl }

constructor TTeScrollingCustomControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCanvas := TControlCanvas.Create;
  TControlCanvas(FCanvas).Control := Self;
  AutoScroll := False;
end;

destructor TTeScrollingCustomControl.Destroy;
begin
  FCanvas.Free;
  inherited Destroy;
end;

procedure TTeScrollingCustomControl.WMPaint(var Message: TWMPaint);
begin
  ControlState := ControlState + [csCustomPaint];
  inherited;
  ControlState := ControlState - [csCustomPaint];
end;

procedure TTeScrollingCustomControl.PaintWindow(DC: HDC);
var
  SaveIndex                   : Integer;
  rc                          : TRect;
begin
  AdjustClientRect(rc);
  FCanvas.Lock;
  try
    SaveIndex := SaveDC(DC);
    try
      MoveWindowOrg(DC, rc.Left, rc.Top);
      FCanvas.Handle := DC;
      try
        TControlCanvas(FCanvas).UpdateTextFlags;
        Paint;
      finally
        FCanvas.Handle := 0;
      end;
    finally
      RestoreDC(DC, SaveIndex);
    end;
  finally
    FCanvas.Unlock;
  end;
end;

procedure TTeScrollingCustomControl.Paint;
var
  rc                          : TRect;
begin
  AdjustClientRect(rc);
  Canvas.Brush.Color := Color;
  Canvas.FillRect(rc);
end;

procedure TTeScrollingCustomControl.WMNCHitTest(var Message: TWMNCHitTest);
begin
  DefaultHandler(Message);
end;

{ TTeCustomPanel }

constructor TTeCustomPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := [csAcceptsControls, csCaptureMouse, csClickEvents,
    csSetCaption, csOpaque, csDoubleClicks, csReplicatable];
  Width := 185;
  Height := 41;
  FAlignment := taCenter;
  BevelOuter := bvRaised;
  BevelWidth := 1;
  Color := clBtnFace;
  FFullRepaint := False;
  UseDockManager := True;
end;

procedure TTeCustomPanel.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
    WindowClass.style := WindowClass.style and not (CS_HREDRAW or CS_VREDRAW);
end;

procedure TTeCustomPanel.CMIsToolControl(var Message: TMessage);
begin
  if not FLocked then Message.Result := 1;
end;

procedure TTeCustomPanel.Paint;
var
  rc                          : TRect;
begin
  AdjustClientRect(rc);
  Canvas.Brush.Color := Color;
  Canvas.FillRect(rc);
end;

procedure TTeCustomPanel.SetAlignment(Value: TAlignment);
begin
  if FAlignment <> Value then begin
    FAlignment := Value;
    Invalidate;
  end;
end;

procedure TTeCustomPanel.SetBevelInner(Value: TPanelBevel);
begin
  if FBevelInner <> Value then begin
    FBevelInner := Value;
    Perform(CM_BORDERCHANGED, 0, 0);
  end;
end;

procedure TTeCustomPanel.SetBevelOuter(Value: TPanelBevel);
begin
  if FBevelOuter <> Value then begin
    FBevelOuter := Value;
    Perform(CM_BORDERCHANGED, 0, 0);
  end;
end;

procedure TTeCustomPanel.SetBevelWidth(Value: TBevelWidth);
begin
  if FBevelWidth <> Value then begin
    FBevelWidth := Value;
    Perform(CM_BORDERCHANGED, 0, 0);
  end;
end;

procedure TTeCustomPanel.SetBorderWidth(Value: TBorderWidth);
begin
  if FBorderWidth <> Value then begin
    FBorderWidth := Value;
    Perform(CM_BORDERCHANGED, 0, 0);
  end;
end;

function TTeCustomPanel.GetControlsAlignment: TAlignment;
begin
  Result := FAlignment;
end;

procedure TTeCustomPanel.CMDockClient(var Message: TCMDockClient);
var
  R                           : TRect;
  Dim                         : Integer;
begin
  if AutoSize then begin
    FAutoSizeDocking := True;
    try
      R := Message.DockSource.DockRect;
      case Align of
        alLeft:
          if Width = 0 then Width := R.Right - R.Left;
        alRight:
          if Width = 0 then begin
            Dim := R.Right - R.Left;
            SetBounds(Left - Dim, Top, Dim, Height);
          end;
        alTop:
          if Height = 0 then Height := R.Bottom - R.Top;
        alBottom:
          if Height = 0 then begin
            Dim := R.Bottom - R.Top;
            SetBounds(Left, Top - Dim, Width, Dim);
          end;
      end;
      inherited;
      Exit;
    finally
      FAutoSizeDocking := False;
    end;
  end;
  inherited;
end;

function TTeCustomPanel.CanAutoSize(var NewWidth, NewHeight: Integer): Boolean;
begin
  Result := (not FAutoSizeDocking) and inherited CanAutoSize(NewWidth, NewHeight);
end;

procedure TTeCustomPanel.WMNCCalcSize(var Message: TWMNCCalcSize);
begin
  FBevelPixels := BorderWidth + OuterBorderWidth;
  if BevelInner <> bvNone then Inc(FBevelPixels, BevelWidth);
  if BevelOuter <> bvNone then Inc(FBevelPixels, BevelWidth);
  if HeavyBorder and (BevelWidth = 1) and (BevelOuter = bvRaised) then Inc(FBevelPixels, 1);
  inherited;
  with Message.CalcSize_Params^ do
    InflateRect(rgrc[0], -FBevelPixels, -FBevelPixels);
end;

procedure TTeCustomPanel.WMNCPaint(var Message: TMessage);
var
  DC                          : HDC;
  RC, RW                      : TRect;
  Canvas                      : TCanvas;
  TopColor, BottomColor       : TColor;

  procedure AdjustColors(Bevel: TPanelBevel);
  begin
    TopColor := clBtnHighlight;
    if Bevel = bvLowered then
      TopColor := clBtnShadow;
    BottomColor := clBtnShadow;
    if Bevel = bvLowered then
      BottomColor := clBtnHighlight;
  end;

const
  XorColor                    = $00FFD8CE;
begin
  DC := GetWindowDC(Handle);
  try
    Windows.GetClientRect(Handle, RC);
    GetWindowRect(Handle, RW);
    MapWindowPoints(0, Handle, RW, 2);
    OffsetRect(RC, -RW.Left, -RW.Top);
    ExcludeClipRect(DC, RC.Left, RC.Top, RC.Right, RC.Bottom);
    { Draw borders in non-client area }
    OffsetRect(RW, -RW.Left, -RW.Top);
    RC := RW;
    InflateRect(RC, -FBevelPixels, -FBevelPixels);

    Canvas := TCanvas.Create;
    try
      Canvas.Handle := DC;
      try
        if BorderWidth > 0 then begin
          Canvas.Brush.Color := Color;
          rw := rc;
          InflateRect(rc, BorderWidth, BorderWidth);
          Canvas.FillRect(rc);
          ExcludeClipRect(DC, RC.Left, RC.Top, RC.Right, RC.Bottom);
        end;

        if BevelInner <> bvNone then begin
          InflateRect(rc, BevelWidth, BevelWidth);
          AdjustColors(BevelInner);
          RW := RC;
          Frame3D(Canvas, RW, TopColor, BottomColor, BevelWidth);
          ExcludeClipRect(DC, RC.Left, RC.Top, RC.Right, RC.Bottom);
        end;

        if HeavyBorder and (BevelWidth = 1) and (BevelOuter = bvRaised) then begin
          InflateRect(rc, 2, 2);
          RW := RC;
          AdjustColors(BevelOuter);
          Frame3D(Canvas, RW, TopColor, BottomColor, 2);
          RW := RC;
          DrawEdge(Canvas.Handle, RW, BDR_RAISEDOUTER, BF_BOTTOMRIGHT);
          InflateRect(RW, -1, -1);
          DrawEdge(Canvas.Handle, RW, BDR_RAISEDOUTER, BF_TOPLEFT);
          InflateRect(RW, -1, -1);
          ExcludeClipRect(DC, RC.Left, RC.Top, RC.Right, RC.Bottom);
        end
        else
          if BevelOuter <> bvNone then begin
            InflateRect(rc, BevelWidth, BevelWidth);
            AdjustColors(BevelOuter);
            RW := RC;
            Frame3D(Canvas, RW, TopColor, BottomColor, BevelWidth);
            ExcludeClipRect(DC, RC.Left, RC.Top, RC.Right, RC.Bottom);
          end;

        if OuterBorderWidth > 0 then begin
          if Assigned(Parent) then
            Canvas.Brush.Color := TTeCustomPanel(Parent).Color;
          InflateRect(rc, OuterBorderWidth, OuterBorderWidth);
          Canvas.FillRect(rc);
        end;
      finally
        Canvas.Handle := 0;
      end;
    finally
      Canvas.Free;
    end;
  finally
    ReleaseDC(Handle, DC);
  end;
  inherited;
end;

procedure TTeCustomPanel.SetOuterBorderWidth(const Value: TBorderWidth);
begin
  if FOuterBorderWidth <> Value then begin
    FOuterBorderWidth := Value;
    Perform(CM_BORDERCHANGED, 0, 0);
  end;
end;

procedure TTeCustomPanel.SetHeavyBorder(const Value: Boolean);
begin
  if FHeavyBorder <> Value then begin
    FHeavyBorder := Value;
    Perform(CM_BORDERCHANGED, 0, 0);
  end;
end;

procedure TTeCustomPanel.CMParentColorChanged(var Message: TMessage);
begin
  inherited;
  if OuterBorderWidth > 0 then
    Perform(CM_BORDERCHANGED, 0, 0);
end;

procedure TTeCustomPanel.CMColorChanged(var Message: TMessage);
begin
  inherited;
  if BorderWidth > 0 then
    Perform(CM_BORDERCHANGED, 0, 0)
  else
    Invalidate;
end;

procedure TTeCustomPanel.WMNCHitTest(var Message: TWMNCHitTest);
var
  rc                          : TRect;
begin
  inherited;
  GetWindowRect(Handle, rc);
  if PtInRect(rc, Point(Message.XPos, Message.YPos)) then
    if (Message.XPos <= rc.Left + FBevelPixels) or
      (Message.XPos >= rc.Right - FBevelPixels) or
      (Message.YPos <= rc.Top + FBevelPixels) or
      (Message.YPos >= rc.Bottom - FBevelPixels) then
      if csDesigning in ComponentState then
        Message.Result := HTCLIENT
      else
        Message.Result := HTBORDER;
end;

destructor TTeCustomPanel.Destroy;
begin
  inherited;
end;

procedure TTeCheckBox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  // prevents flicker when resizing
  with Params.WindowClass do
    style := style and not (CS_HREDRAW or CS_VREDRAW);
end;

{ TTeGroupBox }

procedure TTeGroupBox.CMDialogChar(var Message: TCMDialogChar);
var
  NextControl                 : TWinControl;
begin
  with Message do begin
    Result := 0;
    if IsAccel(CharCode, Caption) then begin
      NextControl := FindNextControl(Self, True, True, False);
      if Assigned(NextControl) then try
        NextControl.SetFocus;
        Result := 1;
      except
      end;
    end;
    if Result = 0 then
      inherited;
  end;
end;

procedure TTeGroupBox.CMEnabledChanged(var Message: TMessage);
begin
  Perform(CM_BORDERCHANGED, 0, 0);
  inherited;
end;

procedure TTeGroupBox.CMEnter(var Message);
begin
  inherited;
  FFocused := true;
  if goTrackFocus in Options then
    Perform(CM_BORDERCHANGED, 0, 0);
end;

procedure TTeGroupBox.CMExit(var Message);
begin
  inherited;
  FFocused := false;
  if goTrackFocus in Options then
    Perform(CM_BORDERCHANGED, 0, 0);
end;

procedure TTeGroupBox.CMFontChanged(var Message: TMessage);
begin
  inherited;
  Perform(CM_BORDERCHANGED, 0, 0);
end;

procedure TTeGroupBox.CMTextChanged(var Message: TMessage);
begin
  inherited;
  Perform(CM_BORDERCHANGED, 0, 0);
end;

constructor TTeGroupBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FGroupStyle := gsTopLine;
  FGroupOptions := [goBoldCaption];
  ControlStyle := [csAcceptsControls, csCaptureMouse, csClickEvents,
    csSetCaption, csDoubleClicks, csReplicatable];
  Width := 185;
  Height := 105;
end;

procedure TTeGroupBox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  // prevent flicker
  with Params.WindowClass do
    style := style and not (CS_HREDRAW or CS_VREDRAW);
end;

procedure TTeGroupBox.Paint;
const
  XorColor                    = $00FFD8CE;
begin
  inherited;
  if csDesigning in ComponentState then
    with Canvas do begin
      Pen.Style := psDot;
      Pen.Mode := pmXor;
      Pen.Color := XorColor;
      Brush.Style := bsClear;
      Rectangle(HorzScrollBar.Position, VertScrollBar.Position,
        HorzScrollBar.Position + ClientWidth, VertScrollBar.Position + ClientHeight);
    end;
end;

procedure TTeGroupBox.SetGroupOptions(const Value: TTeGroupOptions);
begin
  if FGroupOptions <> Value then begin
    FGroupOptions := Value;
    Perform(CM_BORDERCHANGED, 0, 0);
  end;
end;

procedure TTeGroupBox.SetGroupStyle(const Value: TTeGroupStyle);
begin
  if FGroupStyle <> Value then begin
    FGroupStyle := Value;
    Perform(CM_BORDERCHANGED, 0, 0);
  end;
end;

procedure TTeGroupBox.SetImageName(const Value: string);
begin
  if FImageName <> Value then begin
    FImageName := Value;
    Perform(CM_BORDERCHANGED, 0, 0);
  end;
end;

procedure TTeGroupBox.WMHScroll(var Message: TMessage);
begin
  inherited;
  if csDesigning in ComponentState then
    Invalidate;
end;

procedure TTeGroupBox.WMNCCalcSize(var Message: TWMNCCalcSize);
begin
  inherited;
  Canvas.Font := Self.Font;
  if goBoldCaption in FGroupOptions then
    Canvas.Font.Style := [fsBold];
  FCaptionHeight := Canvas.TextHeight('Wg');
  if (FCaptionHeight < 24) and (FImageName <> '') and (not (goImageInFront in FGroupOptions)) then
    FCaptionHeight := 24;

  with Message.CalcSize_Params^ do
    with rgrc[0] do begin
      Inc(Top, FCaptionHeight + 3);
      Inc(Left, 19);
      case FGroupStyle of
        gsBox: begin
            Inc(Left, 5);
            Dec(Right, 8);
            Dec(Bottom, 8);
          end;
      end;
      if (goImageInFront in FGroupOptions) then
        Inc(Left, 24);
    end;
end;

procedure TTeGroupBox.WMNCPaint(var Message: TMessage);
var
  DC                          : HDC;
  RC, RW, SaveRW              : TRect;
  Canvas                      : TCanvas;
  SavedDC                     : integer;
  i                           : integer;
  State                       : TTeImageState;
begin
  DC := GetWindowDC(Handle);
  try
    Windows.GetClientRect(Handle, RC);
    GetWindowRect(Handle, RW);
    MapWindowPoints(0, Handle, RW, 2);
    OffsetRect(RC, -RW.Left, -RW.Top);
    ExcludeClipRect(DC, RC.Left, RC.Top, RC.Right, RC.Bottom);
    { Draw borders in non-client area }
    OffsetRect(RW, -RW.Left, -RW.Top);
    SaveRW := RW;

    Canvas := TCanvas.Create;
    try
      Canvas.Handle := DC;
      try
        with Canvas do begin
          Font := Self.Font;
          if (goBoldCaption in FGroupOptions) and Enabled then
            Font.Style := [fsBold];
          Brush := Self.Brush;
          SavedDC := SaveDC(DC);
          try

            if Text <> '' then begin
              RC := RW;

              if FGroupStyle = gsBox then
                RC.Left := 8
              else
                RC.Left := 3;

              if (not (goImageInFront in FGroupOptions)) and (FImageName <> '') then begin
                ExcludeClipRect(DC, RC.Left - 1, 0, RC.Left + 26, 24);
                Inc(RC.Left, 26);
              end;

              DrawText(Handle, PChar(Text), Length(Text), RC, DT_CALCRECT);
              OffSetRect(RC, 0, (FCaptionHeight - (RC.Bottom - RC.Top)) div 2);
              ExcludeClipRect(DC, RC.Left, RC.Top, RC.Right, RC.Bottom);
            end;

            FillRect(RW);
            Inc(RW.Top, FCaptionHeight div 2);

            case FGroupStyle of
              gsBox: begin
                  Inc(RW.Left, 1);
                  Dec(RW.Right, 1);
                  Dec(RW.Bottom, 1);
                  Brush.Color := clBtnHighlight;
                  FrameRect(RW);
                  OffsetRect(RW, -1, -1);
                  Brush.Color := clBtnShadow;
                  FrameRect(RW);
                end;
              gsTopLine: begin
                  RW.Left := RC.Right + 10;
                  Pen.Color := clBtnHighlight;
                  MoveTo(RW.Left, RW.Top);
                  LineTo(RW.Right, RW.Top);
                  Pen.Color := clBtnShadow;
                  MoveTo(RW.Left, RW.Top - 1);
                  LineTo(RW.Right, RW.Top - 1);
                end;
            end;

          finally
            Refresh;
            RestoreDC(DC, SavedDC);
          end;

          Brush := Self.Brush;

          if Text <> '' then
            if Enabled then
              DrawText(Handle, PChar(Text), Length(Text), RC, 0)
            else begin
              RW := RC;
              Font.Color := clBtnHighlight;
              OffsetRect(RW, 1, 1);
              DrawText(Handle, PChar(Text), Length(Text), RW, 0);
              Font.Color := clBtnShadow;
              Brush.Style := bsClear;
              DrawText(Handle, PChar(Text), Length(Text), RC, 0);
              Brush.Style := bsSolid;
            end;

          if FImageName <> '' then begin

            if Enabled then begin
              if goMonoImage in FGroupOptions then
                State := isMono
              else
                State := isUp;

              if (goTrackFocus in FGroupOptions) and FFocused then
                State := isDown;
            end else
              State := isDisabled;

            if goImageInFront in FGroupOptions then begin
              if FGroupStyle = gsBox then
                i := 4
              else
                i := 2;
              Inc(i, 8);
              TeImageManager.DrawMulti(State, Canvas, i, FCaptionHeight + 5, FImageName);
            end else begin
              Brush.Color := Color;
              RW := Rect(RC.Left - 27, 0, RC.Left, 24);
              FillRect(RW);
              TeImageManager.DrawMulti(State, Canvas, RC.Left - 26, 0, FImageName);
            end;
          end;
        end;
      finally
        Canvas.Handle := 0;
      end;
    finally
      Canvas.Free;
    end;
  finally
    ReleaseDC(Handle, DC);
  end;
  inherited;
end;

{ TTeRadioGroup }

{ TTeGroupButton }

type
  TTeGroupButton = class(TTeRadioButton)
  private
    FInClick: Boolean;
    procedure CNCommand(var Message: TWMCommand); message CN_COMMAND;
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure CreateParams(var Params: TCreateParams); override;
  public
    constructor InternalCreate(RadioGroup: TTeRadioGroup);
    destructor Destroy; override;
  end;

constructor TTeGroupButton.InternalCreate(RadioGroup: TTeRadioGroup);
begin
  inherited Create(RadioGroup);
  RadioGroup.FButtons.Add(Self);
  Visible := False;
  Enabled := RadioGroup.Enabled;
  ParentShowHint := False;
  OnClick := RadioGroup.ButtonClick;
  Parent := RadioGroup;
end;

destructor TTeGroupButton.Destroy;
begin
  TTeRadioGroup(Owner).FButtons.Remove(Self);
  inherited Destroy;
end;

procedure TTeGroupButton.CNCommand(var Message: TWMCommand);
begin
  if not FInClick then begin
    FInClick := True;
    try
      if ((Message.NotifyCode = BN_CLICKED) or
        (Message.NotifyCode = BN_DOUBLECLICKED)) and
        TTeRadioGroup(Parent).CanModify then
        inherited;
    except
      Application.HandleException(Self);
    end;
    FInClick := False;
  end;
end;

procedure TTeGroupButton.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  TTeRadioGroup(Parent).KeyPress(Key);
  if (Key = #8) or (Key = ' ') then begin
    if not TTeRadioGroup(Parent).CanModify then Key := #0;
  end;
end;

procedure TTeGroupButton.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  TTeRadioGroup(Parent).KeyDown(Key, Shift);
end;

procedure TTeRadioGroup.ArrangeButtons;
var
  ButtonsPerCol, ButtonWidth, ButtonHeight, TopMargin, I: Integer;
  DC                          : HDC;
  SaveFont                    : HFont;
  Metrics                     : TTextMetric;
  DeferHandle                 : THandle;
  ALeft                       : Integer;
  rc                          : TRect;
  sz                          : TSize;
begin
  if (FButtons.Count <> 0) and not FReading then begin
    rc := ClientRect;
    AdjustClientRect(rc);
    sz.cx := rc.Right - rc.Left;
    sz.cy := rc.Bottom - rc.Top;
    DC := GetDC(0);
    SaveFont := SelectObject(DC, Font.Handle);
    GetTextMetrics(DC, Metrics);
    SelectObject(DC, SaveFont);
    ReleaseDC(0, DC);
    ButtonsPerCol := (FButtons.Count + FColumns - 1) div FColumns;
    ButtonWidth := (sz.cx - 10) div FColumns;
    I := sz.cy - 5;
    ButtonHeight := I div ButtonsPerCol;
    TopMargin := 3 + (I mod ButtonsPerCol) div 2;
    DeferHandle := BeginDeferWindowPos(FButtons.Count);
    try
      for I := 0 to FButtons.Count - 1 do
        with TTeGroupButton(FButtons[I]) do begin
          BiDiMode := Self.BiDiMode;
          ALeft := rc.Left + ((I div ButtonsPerCol) * ButtonWidth + 8);
          if UseRightToLeftAlignment then
            ALeft := sz.cx - ALeft - ButtonWidth;
          DeferHandle := DeferWindowPos(DeferHandle, Handle, 0,
            ALeft,
            rc.Top + ((I mod ButtonsPerCol) * ButtonHeight + TopMargin),
            ButtonWidth, ButtonHeight,
            SWP_NOZORDER or SWP_NOACTIVATE);
          Visible := True;
        end;
    finally
      EndDeferWindowPos(DeferHandle);
    end;
  end;
end;

procedure TTeRadioGroup.ButtonClick(Sender: TObject);
begin
  if not FUpdating then begin
    FItemIndex := FButtons.IndexOf(Sender);
    Changed;
    Click;
  end;
end;

function TTeRadioGroup.CanModify: Boolean;
begin
  Result := True;
end;

procedure TTeRadioGroup.CMEnabledChanged(var Message: TMessage);
var
  I                           : Integer;
begin
  inherited;
  for I := 0 to FButtons.Count - 1 do
    TTeGroupButton(FButtons[I]).Enabled := Enabled;
end;

procedure TTeRadioGroup.CMFontChanged(var Message: TMessage);
begin
  inherited;
  ArrangeButtons;
end;

constructor TTeRadioGroup.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := [csSetCaption, csDoubleClicks];
  FButtons := TList.Create;
  FItems := TStringList.Create;
  TStringList(FItems).OnChange := ItemsChange;
  FItemIndex := -1;
  FColumns := 1;
end;

procedure TTeRadioGroup.CreateWnd;
begin
  inherited;
  UpdateButtons;
end;

destructor TTeRadioGroup.Destroy;
begin
  SetButtonCount(0);
  TStringList(FItems).OnChange := nil;
  FItems.Free;
  FButtons.Free;
  inherited Destroy;
end;

procedure TTeRadioGroup.FlipChildren(AllLevels: Boolean);
begin
  { The radio buttons are flipped using BiDiMode }
end;

procedure TTeRadioGroup.GetChildren(Proc: TGetChildProc; Root: TComponent);
begin

end;

procedure TTeRadioGroup.ItemsChange(Sender: TObject);
begin
  if not FReading then begin
    if FItemIndex >= FItems.Count then FItemIndex := FItems.Count - 1;
    UpdateButtons;
  end;
end;

procedure TTeRadioGroup.ReadState(Reader: TReader);
begin
  FReading := True;
  inherited ReadState(Reader);
  FReading := False;
  if HandleAllocated then
    UpdateButtons;
end;

procedure TTeRadioGroup.SetButtonCount(Value: Integer);
begin
  while FButtons.Count < Value do
    TTeGroupButton.InternalCreate(Self);
  while FButtons.Count > Value do
    TTeGroupButton(FButtons.Last).Free;
end;

procedure TTeRadioGroup.SetColumns(Value: Integer);
begin
  if Value < 1 then Value := 1;
  if Value > 16 then Value := 16;
  if FColumns <> Value then begin
    FColumns := Value;
    ArrangeButtons;
    Invalidate;
  end;
end;

procedure TTeRadioGroup.SetItemIndex(Value: Integer);
begin
  if FReading then
    FItemIndex := Value
  else begin
    if Value >= FItems.Count then Value := FItems.Count - 1;
    FItemIndex := Value;
    UpdateButtons;
  end;
end;

procedure TTeRadioGroup.SetItems(Value: TStrings);
begin
  FItems.Assign(Value);
end;

procedure TTeRadioGroup.UpdateButtons;
var
  I                           : Integer;
begin
  SetButtonCount(FItems.Count);
  for I := 0 to FButtons.Count - 1 do
    TTeGroupButton(FButtons[I]).Caption := FItems[I];
  if FItemIndex >= 0 then begin
    FUpdating := True;
    TTeGroupButton(FButtons[FItemIndex]).Checked := True;
    FUpdating := False;
  end;
  ArrangeButtons;
  Invalidate;
end;

procedure TTeRadioGroup.WMHScroll(var Message: TWMHScroll);
begin
  inherited;
  ArrangeButtons;
end;

procedure TTeRadioGroup.WMSize(var Message: TWMSize);
begin
  inherited;
  ArrangeButtons;
end;

procedure TTeGroupButton.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params.WindowClass do
    style := style and not (CS_HREDRAW or CS_VREDRAW);
end;

procedure TTeGroupBox.WMSize(var Message: TWMSize);
begin
  inherited;
  if csDesigning in ComponentState then
    Invalidate;
end;

procedure TTeGroupBox.WMVScroll(var Message: TMessage);
begin
  inherited;
  if csDesigning in ComponentState then
    Invalidate;
end;

{ TTeRadioButton }

procedure TTeRadioButton.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  // prevents flicker when resizing
  with Params.WindowClass do
    style := style and not (CS_HREDRAW or CS_VREDRAW);
end;

procedure TTeRadioGroup.WMVScroll(var Message: TWMVScroll);
begin
  inherited;
  ArrangeButtons;
end;

end.

