unit TeButtons;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, TypInfo, Menus, ActnList, extctrls, comctrls;

const
  CM_BUTTONSTYLECHANGED            = CM_BASE + 200;

type
  TTeButtonState = (bsUp, bsDown, bsDisabled, bsMono, bsExclusive);
  TTeButtonStyle = (bsFlat, bsMiddle, bsNormal);

  TTeButtonOption = (boMonoDisplay, boIconOnly, boWordWarp);
  TTeButtonOptions = set of TTeButtonOption;

  TTeSpeedButton = class;

  TTeSpeedButtonActionLink = class(TControlActionLink)
  protected
    FClient: TTeSpeedButton;
    procedure AssignClient(AClient: TObject); override;
    function IsCheckedLinked: Boolean; override;
  public
    procedure SetChecked(Value: Boolean); override;
  end;

  TTeSpeedButton = class(TGraphicControl)
  private
    FGroupIndex: Integer;
    FGlyph: Pointer;
    FDown: Boolean;
    FDragging: Boolean;
    FAllowAllUp: Boolean;
    FLayout: TButtonLayout;
    FSpacing: Integer;
    FMargin: Integer;
    FFlat: Boolean;
    FMouseInControl: Boolean;
    FAlwaysUp: Boolean;
    FOptions: TTeButtonOptions;
    procedure UpdateExclusive;
    procedure SetDown(Value: Boolean);
    procedure SetFlat(Value: Boolean);
    procedure SetAllowAllUp(Value: Boolean);
    procedure SetGroupIndex(Value: Integer);
    procedure SetLayout(Value: TButtonLayout);
    procedure SetSpacing(Value: Integer);
    procedure SetMargin(Value: Integer);
    procedure UpdateTracking;
    procedure WMLButtonDblClk(var Message: TWMLButtonDown); message WM_LBUTTONDBLCLK;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMButtonPressed(var Message: TMessage); message CM_BUTTONPRESSED;
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure CMSysColorChange(var Message: TMessage); message CM_SYSCOLORCHANGE;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMButtonStyleChanged(var Message: TMessage); message CM_BUTTONSTYLECHANGED;
    function IsCheckedStored: Boolean;
    procedure SetImageName(const Value: string);
    function GetImageName: string;
  protected
    FState: TTeButtonState;
    procedure ActionChange(Sender: TObject; CheckDefaults: Boolean); override;
    procedure AssignTo(Dest: TPersistent); override;
    procedure SetOptions(value: TTeButtonOptions);
    function GetActionLinkClass: TControlActionLinkClass; override;
    procedure Loaded; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Click; override;
  published
    property Action;
    property Align;
    property Options: TTeButtonOptions read FOptions write SetOptions default [boMonoDisplay, boIconOnly];
    property AllowAllUp: Boolean read FAllowAllUp write SetAllowAllUp default false;
    property GroupIndex: Integer read FGroupIndex write SetGroupIndex default 0;
    property Down: Boolean read FDown write SetDown stored IsCheckedStored default false;
    property ImageName: string read GetImageName write SetImageName;
    property Caption;
    property Enabled;
    property Font;
    property Layout: TButtonLayout read FLayout write SetLayout default blGlyphLeft;
    property Margin: Integer read FMargin write SetMargin default -1;
    property ParentFont;
    property ParentShowHint;
    property ShowHint;
    property Spacing: Integer read FSpacing write SetSpacing default 4;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;

  TTeBitBtn = class;

  TTeBitBtnActionLink = class(TButtonActionLink)
  protected
    FClient: TTeBitBtn;
    procedure AssignClient(AClient: TObject); override;
    function IsCheckedLinked: Boolean; override;
  public
    procedure SetChecked(Value: Boolean); override;
  end;

  TTeBitBtn = class(TButtonControl)
  private
    FGroupIndex: Integer;
    FDown: Boolean;
    FAllowAllUp: Boolean;
    FCanvas: TCanvas;
    FGlyph: Pointer;
    FStyle: TButtonStyle;
    FOptions: TTeButtonOptions;
    FLayout: TButtonLayout;
    FSpacing: Integer;
    FMargin: Integer;
    FIsFocused: Boolean;
    FMouseInControl: Boolean;
    FFlat: Boolean;
    FDragging: Boolean;
    FDefault: Boolean;
    FCancel: Boolean;
    FActive: Boolean;
    FModalResult: TModalResult;
    FAlwaysUp: Boolean;
    procedure SetDefault(Value: Boolean);
    procedure CMDialogKey(var Message: TCMDialogKey); message CM_DIALOGKEY;
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure CMFocusChanged(var Message: TCMFocusChanged); message CM_FOCUSCHANGED;
    procedure CNCommand(var Message: TWMCommand); message CN_COMMAND;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMCancelMode(var Message: TWMChar); message WM_CANCELMODE;
    procedure DrawItem(const DrawItemStruct: TDrawItemStruct);
    procedure UpdateTracking;
    procedure SetStyle(Value: TButtonStyle);
    procedure SetFlat(Value: Boolean);
    procedure UpdateExclusive;
    procedure SetDown(Value: Boolean);
    procedure SetAllowAllUp(Value: Boolean);
    procedure SetGroupIndex(Value: Integer);
    procedure SetLayout(Value: TButtonLayout);
    procedure SetSpacing(Value: Integer);
    procedure SetMargin(Value: Integer);
    procedure SetCaption(Value: TCaption);
    procedure CNMeasureItem(var Message: TWMMeasureItem); message CN_MEASUREITEM;
    procedure CNDrawItem(var Message: TWMDrawItem); message CN_DRAWITEM;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMButtonPressed(var Message: TMessage); message CM_BUTTONPRESSED;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMButtonStyleChanged(var Message: TMessage); message CM_BUTTONSTYLECHANGED;
    function IsCheckedStored: Boolean;
    function GetImageName: string;
    procedure SetImageName(const Value: string);
  protected
    FState: TTeButtonState;
    procedure ActionChange(Sender: TObject; CheckDefaults: Boolean); override;
    procedure AssignTo(Dest: TPersistent); override;
    function GetActionLinkClass: TControlActionLinkClass; override;
    procedure CreateWnd; override;
    procedure SetButtonStyle(ADefault: Boolean); virtual;
    procedure CreateHandle; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure SetOptions(value: TTeButtonOptions);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Click; override;
  published
    property ImageName: string read GetImageName write SetImageName;
    property Align;
    property Action;
    property AllowAllUp: Boolean read FAllowAllUp write SetAllowAllUp default false;
    property Cancel: Boolean read FCancel write FCancel default false;
    property Checked default false;
    property Caption write SetCaption;
    property Default: Boolean read FDefault write SetDefault default false;
    property Down: Boolean read FDown write SetDown stored IsCheckedStored default false;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property Options: TTeButtonOptions read FOptions write SetOptions default [boMonoDisplay, boIconOnly];
    property Layout: TButtonLayout read FLayout write SetLayout default blGlyphLeft;
    property Margin: Integer read FMargin write SetMargin default -1;
    property Style: TButtonStyle read FStyle write SetStyle default bsAutoDetect;
    property Spacing: Integer read FSpacing write SetSpacing default 4;
    property GroupIndex: Integer read FGroupIndex write SetGroupIndex default 0;
    property ModalResult: TModalResult read FModalResult write FModalResult default mrNone;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop default true;
    property Visible;
    property OnClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
  end;

  TTeButtonManager = class(TObject)
  private
    FButtonStyle: TTeButtonStyle;
    procedure SetButtonStyle(const Value: TTeButtonStyle);
  protected
    procedure UpdateAll; virtual; abstract;
  public
    property ButtonStyle: TTeButtonStyle read FButtonStyle write SetButtonStyle;
  end;

function TeButtonManager: TTeButtonManager;

implementation

uses
  Math, CommCtrl, TeImgList;

type
  TTeButtonGlyph = class
  private
    FImageName: string;
    procedure DrawButtonGlyph(Canvas: TCanvas; const GlyphPos: TPoint; State: TTeButtonState; Transparent, AMouseInControl: Boolean; AOptions: TTeButtonOptions);
    procedure DrawButtonText(Canvas: TCanvas; const Caption: string; TextBounds: TRect; State: TTeButtonState; AOptions: TTeButtonOptions; Layout: TButtonLayout);
    procedure CalcButtonLayout(Canvas: TCanvas; const Client: TRect; const Offset: TPoint; const Caption: string; Layout: TButtonLayout; Margin, Spacing: Integer; var GlyphPos: TPoint; var TextBounds: TRect; AOptions: TTeButtonOptions);
  public
    constructor Create(AParent: TControl);
    destructor Destroy; override;
    function Draw(Canvas: TCanvas; const Client: TRect; const Offset: TPoint; const Caption: string; Layout: TButtonLayout; Margin, Spacing: Integer; State: TTeButtonState; Transparent, AMouseInControl, AIsFocused: Boolean; AOptions: TTeButtonOptions): TRect;
  end;

type
  TTeButtonManagerImpl = class(TTeButtonManager)
  private
    FList: TList;
  protected
    procedure AddButton(AButton: TControl);
    procedure RemoveButton(AButton: TControl);
    procedure UpdateAll; override;
  public
    constructor Create;
    destructor Destroy; override;
  end;

var
  _ButtonManager                   : TTeButtonManagerImpl;

function TeButtonManager: TTeButtonManager;
begin
  Result := _ButtonManager;
end;

var
  Pattern                          : TBitmap = nil;
  ButtonCount                      : Integer = 0;

procedure CreateBrushPattern;
var
  X, Y                             : Integer;
begin
  Pattern := TBitmap.Create;
  Pattern.Width := 8;
  Pattern.Height := 8;
  with Pattern.Canvas do begin
    Brush.Style := bsSolid;
    Brush.Color := clBtnFace;
    FillRect(Rect(0, 0, Pattern.Width, Pattern.Height));
    for Y := 0 to 7 do
      for X := 0 to 7 do
        if (Y mod 2) = (X mod 2) then                       { toggles between even/odd pixles }
          Pixels[X, Y] := clBtnHighlight;                   { on even/odd rows }
  end;
end;

{ TTeButtonGlyph }

constructor TTeButtonGlyph.Create(AParent: TControl);
begin
  inherited Create;
end;

destructor TTeButtonGlyph.Destroy;
begin
  inherited Destroy;
end;

procedure TTeButtonGlyph.DrawButtonGlyph(Canvas: TCanvas; const GlyphPos: TPoint; State: TTeButtonState; Transparent, AMouseInControl: Boolean; AOptions: TTeButtonOptions);
var
  ImageState                       : TTeImageState;
begin
  if State = bsExclusive then
    State := bsDown;

  if AMouseInControl or (State <> bsUp) or (not (boMonoDisplay in AOptions)) then
    ImageState := TTeImageState(State)
  else
    ImageState := isMono;

  TeImageManager.DrawMulti(ImageState, Canvas, GlyphPos.x, GlyphPos.y, FImageName);
end;

procedure TTeButtonGlyph.DrawButtonText(Canvas: TCanvas; const Caption: string; TextBounds: TRect; State: TTeButtonState; AOptions: TTeButtonOptions; Layout: TButtonLayout);
var
  Flags                            : Integer;
begin
  with Canvas do begin
    Brush.Style := bsClear;
    if boWordWarp in AOptions then begin
      if Layout in [blGlyphTop, blGlyphBottom] then
        Flags := DT_CENTER or DT_VCENTER or DT_WORDBREAK
      else
        Flags := DT_LEFT or DT_VCENTER or DT_WORDBREAK;
    end else
      Flags := DT_CENTER or DT_VCENTER or DT_SINGLELINE;
    if State = bsDisabled then begin
      OffsetRect(TextBounds, 1, 1);
      Font.Color := clBtnHighlight;
      DrawText(Handle, PChar(Caption), Length(Caption), TextBounds, Flags);
      OffsetRect(TextBounds, -1, -1);
      Font.Color := clBtnShadow;
      DrawText(Handle, PChar(Caption), Length(Caption), TextBounds, Flags);
    end else
      DrawText(Handle, PChar(Caption), Length(Caption), TextBounds, Flags);
  end;
end;

procedure TTeButtonGlyph.CalcButtonLayout(Canvas: TCanvas; const Client: TRect; const Offset: TPoint; const Caption: string; Layout: TButtonLayout; Margin, Spacing: Integer; var GlyphPos: TPoint; var TextBounds: TRect; AOptions: TTeButtonOptions);
var
  Flags                            : Integer;
  TextPos                          : TPoint;
  ClientSize, GlyphSize, TextSize  : TPoint;
  TotalSize                        : TPoint;
begin
  { calculate the item sizes }
  ClientSize := Point(Client.Right - Client.Left, Client.Bottom - Client.Top);

  {!!!  if TeImageManager.ImageIndex[FImageName] >= 0 then}
  if FImageName <> '' then
    GlyphSize := Point(24, 24)
  else
    GlyphSize := Point(0, 0);

  if Length(Caption) > 0 then begin
    Flags := DT_CALCRECT;

    if boWordWarp in AOptions then begin
      if Layout in [blGlyphLeft, blGlyphRight] then
        TextBounds := Rect(0, 0, Client.Right - Client.Left - GlyphSize.x - Spacing, 0)
      else
        TextBounds := Rect(0, 0, Client.Right - Client.Left, 0);
      Flags := Flags or DT_WORDBREAK or DT_LEFT;
    end else
      TextBounds := Rect(0, 0, Client.Right - Client.Left, 0);

    DrawText(Canvas.Handle, PChar(Caption), Length(Caption), TextBounds, Flags);
    TextSize := Point(TextBounds.Right - TextBounds.Left, TextBounds.Bottom - TextBounds.Top);
  end else begin
    TextBounds := Rect(0, 0, 0, 0);
    TextSize := Point(0, 0);
  end;

  { If the layout has the glyph on the right or the left, then both the
   text and the glyph are centered vertically.  If the glyph is on the top
   or the bottom, then both the text and the glyph are centered horizontally.}
  if Layout in [blGlyphLeft, blGlyphRight] then begin
    GlyphPos.Y := (ClientSize.Y - GlyphSize.Y + 1) div 2;
    TextPos.Y := (ClientSize.Y - TextSize.Y) div 2;
  end
  else begin
    GlyphPos.X := (ClientSize.X - GlyphSize.X + 1) div 2;
    TextPos.X := (ClientSize.X - TextSize.X) div 2;
  end;

  { if there is no text or no bitmap, then Spacing is irrelevant }
  if (TextSize.X = 0) or (GlyphSize.X = 0) then
    Spacing := 0;

  { adjust Margin and Spacing }
  if Margin = -1 then begin
    if Spacing = -1 then begin
      TotalSize := Point(GlyphSize.X + TextSize.X, GlyphSize.Y + TextSize.Y);
      if Layout in [blGlyphLeft, blGlyphRight] then
        Margin := (ClientSize.X - TotalSize.X) div 3
      else
        Margin := (ClientSize.Y - TotalSize.Y) div 3;
      Spacing := Margin;
    end else begin
      TotalSize := Point(GlyphSize.X + Spacing + TextSize.X, GlyphSize.Y +
        Spacing + TextSize.Y);
      if Layout in [blGlyphLeft, blGlyphRight] then
        Margin := (ClientSize.X - TotalSize.X + 1) div 2
      else
        Margin := (ClientSize.Y - TotalSize.Y + 1) div 2;
    end;
  end
  else begin
    if Spacing = -1 then begin
      TotalSize := Point(ClientSize.X - (Margin + GlyphSize.X), ClientSize.Y -
        (Margin + GlyphSize.Y));
      if Layout in [blGlyphLeft, blGlyphRight] then
        Spacing := (TotalSize.X - TextSize.X) div 2
      else
        Spacing := (TotalSize.Y - TextSize.Y) div 2;
    end;
  end;

  case Layout of
    blGlyphLeft: begin
        GlyphPos.X := Margin;
        TextPos.X := GlyphPos.X + GlyphSize.X + Spacing;
      end;
    blGlyphRight: begin
        GlyphPos.X := ClientSize.X - Margin - GlyphSize.X;
        TextPos.X := GlyphPos.X - Spacing - TextSize.X;
      end;
    blGlyphTop: begin
        GlyphPos.Y := Margin;
        TextPos.Y := GlyphPos.Y + GlyphSize.Y + Spacing;
      end;
    blGlyphBottom: begin
        GlyphPos.Y := ClientSize.Y - Margin - GlyphSize.Y;
        TextPos.Y := GlyphPos.Y - Spacing - TextSize.Y;
      end;
  end;

  { fixup the result variables }
  with GlyphPos do begin
    Inc(X, Client.Left + Offset.X);
    Inc(Y, Client.Top + Offset.Y);
  end;
  OffsetRect(TextBounds, TextPos.X + Client.Left + Offset.X,
    TextPos.Y + Client.Top + Offset.X);
end;

function TTeButtonGlyph.Draw(Canvas: TCanvas; const Client: TRect;
  const Offset: TPoint; const Caption: string; Layout: TButtonLayout;
  Margin, Spacing: Integer; State: TTeButtonState; Transparent, AMouseInControl, AIsFocused: Boolean;
  AOptions: TTeButtonOptions): TRect;
var
  GlyphPos                         : TPoint;
  R                                : TRect;
begin
  if boIconOnly in AOptions then
    CalcButtonLayout(Canvas, Client, Offset, '', Layout, Margin, Spacing,
      GlyphPos, Result, AOptions)
  else
    CalcButtonLayout(Canvas, Client, Offset, Caption, Layout, Margin, Spacing,
      GlyphPos, Result, AOptions);

  DrawButtonGlyph(Canvas, GlyphPos, State, Transparent, AMouseInControl, AOptions);

  if not (boIconOnly in AOptions) then
    DrawButtonText(Canvas, Caption, Result, State, AOptions, Layout);

  if AIsFocused then begin
    R := Client;
    InflateRect(R, -1, -1);
    Canvas.Pen.Color := clWindowFrame;
    Canvas.Brush.Color := clBtnFace;
    DrawFocusRect(Canvas.Handle, R);
  end;
end;

{ TTeSpeedButton }

constructor TTeSpeedButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := [csSetCaption, csOpaque, csDoubleClicks];
  Width := 30;
  Height := 30;
  FGlyph := TTeButtonGlyph.Create(Self);
  FLayout := blGlyphLeft;
  FSpacing := 4;
  FMargin := -1;
  ParentFont := false;
  FOptions := [boMonoDisplay, boIconOnly];
  Inc(ButtonCount);
  Perform(CM_BUTTONSTYLECHANGED, 0, 0);
  _ButtonManager.AddButton(Self);
end;

destructor TTeSpeedButton.Destroy;
begin
  _ButtonManager.RemoveButton(Self);
  TTeButtonGlyph(FGlyph).Free;
  Dec(ButtonCount);
  if ButtonCount = 0 then begin
    Pattern.Free;
    Pattern := nil;
  end;
  inherited Destroy;
end;

procedure TTeSpeedButton.Paint;
const
  DownStyles                       : array[Boolean] of Integer = (BDR_RAISEDINNER, BDR_SUNKENOUTER);
  FillStyles                       : array[Boolean] of Integer = (BF_MIDDLE, 0);
var
  PaintRect                        : TRect;
  DrawFlags                        : Integer;
  Offset                           : TPoint;
begin
  if not Enabled then begin
    FState := bsDisabled;
    FDragging := false;
  end
  else
    if FState = bsDisabled then
      if FDown and (GroupIndex <> 0) then
        FState := bsExclusive
      else
        FState := bsUp;
  Canvas.Font := Self.Font;
  PaintRect := Rect(0, 0, Width, Height);
  if not FFlat then begin
    DrawFlags := DFCS_BUTTONPUSH or DFCS_ADJUSTRECT;
    if FState in [bsDown, bsExclusive] then
      DrawFlags := DrawFlags or DFCS_PUSHED;
    DrawFrameControl(Canvas.Handle, PaintRect, DFC_BUTTON, DrawFlags);
  end
  else begin
    if (FState in [bsDown, bsExclusive])
      or (FMouseInControl and (FState <> bsDisabled))
      or (csDesigning in ComponentState) or FAlwaysUp then
      DrawEdge(Canvas.Handle, PaintRect, DownStyles[FState in [bsDown, bsExclusive]],
        FillStyles[FFlat] or BF_RECT);
    InflateRect(PaintRect, -1, -1);
  end;
  if FState in [bsDown, bsExclusive] then begin
    if (FState = bsExclusive) and (not FFlat or not FMouseInControl) then begin
      if Pattern = nil then CreateBrushPattern;
      Canvas.Brush.Bitmap := Pattern;
      Canvas.FillRect(PaintRect);
    end;
    Offset.X := 1;
    Offset.Y := 1;
  end
  else begin
    Offset.X := 0;
    Offset.Y := 0;
  end;
  TTeButtonGlyph(FGlyph).Draw(Canvas, PaintRect, Offset, Caption, FLayout, FMargin,
    FSpacing, FState, FFlat, FMouseInControl, false, FOptions);
end;

procedure TTeSpeedButton.UpdateTracking;
var
  P                                : TPoint;
begin
  if FFlat then begin
    if Enabled then begin
      GetCursorPos(P);
      FMouseInControl := not (FindDragTarget(P, true) = Self);
      if FMouseInControl then
        Perform(CM_MOUSELEAVE, 0, 0)
      else
        Perform(CM_MOUSEENTER, 0, 0);
    end;
  end;
end;

procedure TTeSpeedButton.Loaded;
begin
  inherited Loaded;
end;

procedure TTeSpeedButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if (Button = mbLeft) and Enabled then begin
    if not FDown then begin
      FState := bsDown;
      Invalidate;
    end;
    FDragging := true;
  end;
end;

procedure TTeSpeedButton.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  NewState                         : TTeButtonState;
begin
  inherited MouseMove(Shift, X, Y);
  if FDragging then begin
    if not FDown then
      NewState := bsUp
    else
      NewState := bsExclusive;

    if (X >= 0) and (X < ClientWidth) and (Y >= 0) and (Y <= ClientHeight) then
      if FDown then
        NewState := bsExclusive
      else
        NewState := bsDown;
    if NewState <> FState then begin
      FState := NewState;
      Invalidate;
    end;
  end;
end;

procedure TTeSpeedButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  DoClick                          : Boolean;
begin
  inherited MouseUp(Button, Shift, X, Y);
  if FDragging then begin
    FDragging := false;
    DoClick := (X >= 0) and (X < ClientWidth) and (Y >= 0) and (Y <= ClientHeight);
    if FGroupIndex = 0 then begin
      { Redraw face in-case mouse is captured }
      FState := bsUp;
      FMouseInControl := false;
      if DoClick and not (FState in [bsExclusive, bsDown]) then
        Invalidate;
    end else
      if DoClick then begin
        SetDown(not FDown);
        if FDown then Repaint;
      end else begin
        if FDown then FState := bsExclusive;
        Repaint;
      end;
    if DoClick then Click;
    UpdateTracking;
  end;
end;

procedure TTeSpeedButton.UpdateExclusive;
var
  Msg                              : TMessage;
begin
  if (FGroupIndex <> 0) and (Parent <> nil) then begin
    Msg.Msg := CM_BUTTONPRESSED;
    Msg.WParam := FGroupIndex;
    Msg.LParam := Longint(Self);
    Msg.Result := 0;
    Parent.Broadcast(Msg);
  end;
end;

procedure TTeSpeedButton.SetDown(Value: Boolean);
begin
  if FGroupIndex = 0 then
    Value := false;
  if Value <> FDown then begin
    if FDown and (not FAllowAllUp) then
      Exit;
    FDown := Value;
    if Value then begin
      if FState = bsUp then Invalidate;
      FState := bsExclusive
    end else begin
      FState := bsUp;
      Repaint;
    end;
    if Value then
      UpdateExclusive;
  end;
end;

procedure TTeSpeedButton.SetFlat(Value: Boolean);
begin
  if Value <> FFlat then begin
    FFlat := Value;
    if Value then
      ControlStyle := ControlStyle - [csOpaque]
    else
      ControlStyle := ControlStyle + [csOpaque];
    Invalidate;
  end;
end;

procedure TTeSpeedButton.SetGroupIndex(Value: Integer);
begin
  if FGroupIndex <> Value then begin
    FGroupIndex := Value;
    UpdateExclusive;
  end;
end;

procedure TTeSpeedButton.SetLayout(Value: TButtonLayout);
begin
  if FLayout <> Value then begin
    FLayout := Value;
    Invalidate;
  end;
end;

procedure TTeSpeedButton.SetMargin(Value: Integer);
begin
  if (Value <> FMargin) and (Value >= -1) then begin
    FMargin := Value;
    Invalidate;
  end;
end;

procedure TTeSpeedButton.SetSpacing(Value: Integer);
begin
  if Value <> FSpacing then begin
    FSpacing := Value;
    Invalidate;
  end;
end;

procedure TTeSpeedButton.SetAllowAllUp(Value: Boolean);
begin
  if FAllowAllUp <> Value then begin
    FAllowAllUp := Value;
    UpdateExclusive;
  end;
end;

procedure TTeSpeedButton.WMLButtonDblClk(var Message: TWMLButtonDown);
begin
  inherited;
  if FDown then DblClick;
end;

procedure TTeSpeedButton.CMEnabledChanged(var Message: TMessage);
begin
  UpdateTracking;
  Repaint;
end;

procedure TTeSpeedButton.CMButtonPressed(var Message: TMessage);
var
  Sender                           : TTeSpeedButton;
begin
  if Message.WParam = FGroupIndex then begin
    Sender := TTeSpeedButton(Message.LParam);
    if Sender <> Self then begin
      if Sender.Down and FDown then begin
        FDown := false;
        FState := bsUp;
        Invalidate;
      end;
      FAllowAllUp := Sender.AllowAllUp;
    end;
  end;
end;

procedure TTeSpeedButton.CMDialogChar(var Message: TCMDialogChar);
begin
  with Message do
    if IsAccel(CharCode, Caption) and Enabled then begin
      Click;
      Result := 1;
    end else
      inherited;
end;

procedure TTeSpeedButton.CMFontChanged(var Message: TMessage);
begin
  Invalidate;
end;

procedure TTeSpeedButton.CMTextChanged(var Message: TMessage);
begin
  Invalidate;
end;

procedure TTeSpeedButton.CMSysColorChange(var Message: TMessage);
begin
  with TTeButtonGlyph(FGlyph) do begin
    Invalidate;
  end;
end;

procedure TTeSpeedButton.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  if FFlat and not FMouseInControl and Enabled then begin
    FMouseInControl := true;
    Repaint;
  end;
end;

procedure TTeSpeedButton.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  if FFlat and FMouseInControl and Enabled then begin
    FMouseInControl := false;
    if FDragging then begin
      FDragging := false;
      if FState <> bsExclusive then begin
        FDown := false;
        FState := bsUp;
      end;
    end;
    Invalidate;
  end;
end;

procedure TTeSpeedButton.SetOptions(value: TTeButtonOptions);
begin
  if FOptions <> value then begin
    FOptions := value;
    Repaint;
  end;
end;

{ TBitBtn }

constructor TTeBitBtn.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := [csSetCaption, csOpaque, csDoubleClicks, csCaptureMouse];
  Width := 90;
  Height := 30;
  TabStop := true;
  FGlyph := TTeButtonGlyph.Create(Self);
  FCanvas := TCanvas.Create;
  FStyle := bsAutoDetect;
  FLayout := blGlyphLeft;
  FSpacing := 4;
  FMargin := -1;
  FOptions := [boMonoDisplay, boWordWarp];
  Inc(ButtonCount);
  Perform(CM_BUTTONSTYLECHANGED, 0, 0);
  _ButtonManager.AddButton(Self);
end;

destructor TTeBitBtn.Destroy;
begin
  _ButtonManager.RemoveButton(Self);
  Dec(ButtonCount);
  if ButtonCount = 0 then begin
    Pattern.Free;
    Pattern := nil;
  end;
  inherited Destroy;
  TTeButtonGlyph(FGlyph).Free;
  FCanvas.Free;
  FCanvas := nil;
end;

procedure TTeBitBtn.CreateHandle;
begin
  inherited CreateHandle;
end;

procedure TTeBitBtn.CreateParams(var Params: TCreateParams);
const
  ButtonStyles                     : array[Boolean] of LongWord = (BS_PUSHBUTTON, BS_DEFPUSHBUTTON);
begin
  inherited CreateParams(Params);
  CreateSubClass(Params, 'BUTTON');
  Params.Style := Params.Style or ButtonStyles[FDefault] or BS_OWNERDRAW;
end;

procedure TTeBitBtn.CreateWnd;
begin
  inherited CreateWnd;
  FActive := FDefault;
end;

procedure TTeBitBtn.SetButtonStyle(ADefault: Boolean);
begin
  if (ADefault <> FIsFocused) then begin
    FIsFocused := ADefault;
    Refresh;
  end;
end;

procedure TTeBitBtn.SetOptions(value: TTeButtonOptions);
begin
  if FOptions <> value then begin
    FOptions := value;
    Invalidate;
  end;
end;

procedure TTeBitBtn.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if (Button = mbLeft) and Enabled then begin
    if not FDown then begin
      FState := bsDown;
      Invalidate;
    end;
    FDragging := true;
  end;
end;

procedure TTeBitBtn.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  NewState                         : TTeButtonState;
begin
  inherited MouseMove(Shift, X, Y);
  if FDragging then begin
    if not FDown then
      NewState := bsUp
    else
      NewState := bsExclusive;

    if (X >= 0) and (X < ClientWidth) and (Y >= 0) and (Y <= ClientHeight) then
      if FDown then
        NewState := bsExclusive
      else
        NewState := bsDown;
    if NewState <> FState then begin
      FState := NewState;
      Invalidate;
    end;
  end;
end;

procedure TTeBitBtn.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  if FDragging then begin
    FDragging := false;
    if FGroupIndex = 0 then begin
      { Redraw face in-case mouse is captured }
      FState := bsUp;
      FMouseInControl := false;
      if (X >= 0) and (X < ClientWidth) and (Y >= 0) and (Y <= ClientHeight)
        and (not (FState in [bsExclusive, bsDown])) then
        Invalidate;
    end else
      if (X >= 0) and (X < ClientWidth) and (Y >= 0) and (Y <= ClientHeight) then begin
        if FDown then
          Repaint;
      end else begin
        if FDown then
          FState := bsExclusive;
        Repaint;
      end;
    UpdateTracking;
  end;
end;

procedure TTeBitBtn.Loaded;
begin
  inherited;
end;

procedure TTeBitBtn.Click;
var
  Form                             : TCustomForm;
begin
  if Enabled then begin
    Form := GetParentForm(Self);
    if Assigned(Form) then
      Form.ModalResult := ModalResult;
    inherited;
  end;
end;

procedure TTeBitBtn.SetCaption(Value: TCaption);
begin
  inherited Caption := StringReplace(Value, '\n', #13, []);
end;

procedure TTeBitBtn.CNMeasureItem(var Message: TWMMeasureItem);
begin
  with Message.MeasureItemStruct^ do begin
    itemWidth := Width;
    itemHeight := Height;
  end;
end;

procedure TTeBitBtn.SetDefault(Value: Boolean);
var
  Form                             : TCustomForm;
begin
  FDefault := Value;
  //!!!
  if FDefault then
    Font.Style := Font.Style + [fsBold]
  else
    Font.Style := Font.Style - [fsBold];

  if HandleAllocated then begin
    Form := GetParentForm(Self);
    if Form <> nil then
      Form.Perform(CM_FOCUSCHANGED, 0, Longint(Form.ActiveControl));
  end;
end;

procedure TTeBitBtn.CMDialogKey(var Message: TCMDialogKey);
begin
  with Message do
    if (((CharCode = VK_RETURN) and FActive) or ((CharCode = VK_ESCAPE) and FCancel))
      and (KeyDataToShiftState(Message.KeyData) = []) and CanFocus then begin
      SetFocus;
      if not Focused then
        Exit;
      Click;
      Result := 1;
    end else
      inherited;
end;

procedure TTeBitBtn.CMDialogChar(var Message: TCMDialogChar);
begin
  with Message do
    if IsAccel(CharCode, Caption) and CanFocus then begin
      Click;
      Result := 1;
    end else
      inherited;
end;

procedure TTeBitBtn.CMFocusChanged(var Message: TCMFocusChanged);
begin
  with Message do
    if Sender is TTeBitBtn then
      FActive := Sender = Self
    else
      FActive := FDefault;
  SetButtonStyle(FActive);
  inherited;
end;

procedure TTeBitBtn.CNCommand(var Message: TWMCommand);
begin
  if Message.NotifyCode = BN_CLICKED then Click;
end;

procedure TTeBitBtn.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  DefaultHandler(Message);
end;

procedure TTeBitBtn.WMCancelMode(var Message: TWMChar);
begin
  inherited;
  if FFlat and FMouseInControl and Enabled and not FDragging then begin
    FState := bsUp;
    FMouseInControl := false;
    Invalidate;
  end;
end;

procedure TTeBitBtn.CNDrawItem(var Message: TWMDrawItem);
begin
  DrawItem(Message.DrawItemStruct^);
end;

procedure TTeBitBtn.DrawItem(const DrawItemStruct: TDrawItemStruct);
const
  DownStyles                       : array[Boolean] of Integer = (BDR_RAISEDINNER, BDR_SUNKENOUTER);
var
  IsDown, IsDefault                : Boolean;
  R                                : TRect;
  Flags                            : Longint;
  Offset                           : TPoint;
begin
  FCanvas.Handle := DrawItemStruct.hDC;
  R := ClientRect;

  with DrawItemStruct do begin
    IsDown := itemState and ODS_SELECTED <> 0;
    IsDefault := ((itemState and ODS_FOCUS) <> 0);
    if not Enabled then begin
      FState := bsDisabled;
      FDragging := false;
    end
    else
      if (not FDown) then
        if IsDown and (FState <> bsDown) then begin
          FState := bsDown;
        end
        else
          if (not IsDown) and (FState = bsDown) then begin
            FState := bsUp;
          end;
  end;

  if not FFlat then begin
    if (FIsFocused or IsDefault) then begin
      FCanvas.Pen.Color := clWindowFrame;
      FCanvas.Pen.Width := 1;
      FCanvas.Brush.Style := bsClear;
      FCanvas.Rectangle(R.Left, R.Top, R.Right, R.Bottom);
    end;

    if IsDown then begin
      FCanvas.Pen.Color := clBtnShadow;
      FCanvas.Pen.Width := 1;
      FCanvas.Brush.Color := clBtnFace;
      FCanvas.Rectangle(R.Left, R.Top, R.Right, R.Bottom);
      InflateRect(R, -1, -1);
    end
    else begin
      Flags := DFCS_BUTTONPUSH or DFCS_ADJUSTRECT;
      if FState in [bsDown, bsExclusive] then
        Flags := Flags or DFCS_PUSHED;
      if (DrawItemStruct.itemState and ODS_DISABLED) <> 0 then
        Flags := Flags or DFCS_INACTIVE;
      DrawFrameControl(DrawItemStruct.hDC, R, DFC_BUTTON, Flags);
    end;
  end
  else begin
    if (FState in [bsDown, bsExclusive])
      or (FMouseInControl and (FState <> bsDisabled))
      or (csDesigning in ComponentState) or FAlwaysUp then begin
      DrawEdge(FCanvas.Handle, R, DownStyles[FState in [bsDown, bsExclusive]], BF_MIDDLE or BF_RECT);
    end
    else begin
      DrawEdge(FCanvas.Handle, R, 0, BF_MIDDLE or BF_RECT);
    end;
    InflateRect(R, -1, -1);
  end;

  if FState in [bsDown, bsExclusive] then begin
    if (FState = bsExclusive) and (not FFlat or not FMouseInControl) then begin
      if Pattern = nil then
        CreateBrushPattern;
      FCanvas.Brush.Bitmap := Pattern;
      FCanvas.FillRect(R);
    end;
    Offset.X := 0;
    Offset.Y := 0;
  end
  else begin
    Offset.X := 0;
    Offset.Y := 0;
  end;

  if FIsFocused and FFlat then begin
    R := ClientRect;
    InflateRect(R, -1, -1);
  end;

  FCanvas.Font := Self.Font;

  if IsDown then
    OffsetRect(R, 1, 1);

  TTeButtonGlyph(FGlyph).Draw(FCanvas, R, Offset, Caption, FLayout, FMargin,
    FSpacing, FState, FFlat, FMouseInControl or FIsFocused, FIsFocused and Enabled,
    FOptions);

  FCanvas.Handle := 0;
end;

procedure TTeBitBtn.UpdateTracking;
var
  P                                : TPoint;
begin
  if FFlat then begin
    if Enabled then begin
      GetCursorPos(P);
      FMouseInControl := not (FindDragTarget(P, TRUE) = Self);
      if FMouseInControl then
        Perform(CM_MOUSELEAVE, 0, 0)
      else
        Perform(CM_MOUSEENTER, 0, 0);
    end;
  end;
end;

procedure TTeBitBtn.CMFontChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TTeBitBtn.CMEnabledChanged(var Message: TMessage);
const
  NewState                         : array[Boolean] of TTeButtonState = (bsDisabled, bsUp);
begin
  inherited;
  FState := NewState[Enabled];
  UpdateTracking;
  Invalidate;
end;

procedure TTeBitBtn.CMButtonPressed(var Message: TMessage);
var
  Sender                           : TTeBitBtn;
begin
  if Message.WParam = FGroupIndex then begin
    Sender := TTeBitBtn(Message.LParam);
    if Sender <> Self then begin
      if Sender.Down and FDown then begin
        FDown := false;
        FState := bsUp;
        Invalidate;
      end;
      FAllowAllUp := Sender.AllowAllUp;
    end;
  end;
end;

procedure TTeBitBtn.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  if FFlat and (not FMouseInControl) and Enabled
    and ((GetCapture = 0) or (GetCapture = Handle)) then begin
    FMouseInControl := true;
    Repaint;
  end;
end;

procedure TTeBitBtn.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  if FFlat and FMouseInControl and Enabled and not FDragging then begin
    FMouseInControl := false;
    Invalidate;
  end;
end;

procedure TTeBitBtn.SetStyle(Value: TButtonStyle);
begin
  if Value <> FStyle then begin
    FStyle := Value;
    Invalidate;
  end;
end;

procedure TTeBitBtn.UpdateExclusive;
var
  Msg                              : TMessage;
begin
  if (FGroupIndex <> 0) and (Parent <> nil) then begin
    Msg.Msg := CM_BUTTONPRESSED;
    Msg.WParam := FGroupIndex;
    Msg.LParam := Longint(Self);
    Msg.Result := 0;
    Parent.Broadcast(Msg);
  end;
end;

procedure TTeBitBtn.SetDown(Value: Boolean);
begin
  if FGroupIndex = 0 then
    Value := false;
  if Value <> FDown then begin
    if FDown and (not FAllowAllUp) then
      Exit;
    FDown := Value;
    if Value then begin
      if FState = bsUp then
        Invalidate;
      FState := bsExclusive
    end
    else begin
      FState := bsUp;
      Repaint;
    end;
    if Value then
      UpdateExclusive;
  end;
end;

procedure TTeBitBtn.SetGroupIndex(Value: Integer);
begin
  if FGroupIndex <> Value then begin
    FGroupIndex := Value;
    UpdateExclusive;
  end;
end;

procedure TTeBitBtn.SetAllowAllUp(Value: Boolean);
begin
  if FAllowAllUp <> Value then begin
    FAllowAllUp := Value;
    UpdateExclusive;
  end;
end;

procedure TTeBitBtn.SetFlat(Value: Boolean);
begin
  if Value <> FFlat then begin
    FFlat := Value;
    if Value then
      ControlStyle := ControlStyle - [csOpaque]
    else
      ControlStyle := ControlStyle + [csOpaque];
    Invalidate;
  end;
end;

procedure TTeBitBtn.SetLayout(Value: TButtonLayout);
begin
  if FLayout <> Value then begin
    FLayout := Value;
    Invalidate;
  end;
end;

procedure TTeBitBtn.SetSpacing(Value: Integer);
begin
  if FSpacing <> Value then begin
    FSpacing := Value;
    Invalidate;
  end;
end;

procedure TTeBitBtn.SetMargin(Value: Integer);
begin
  if (Value <> FMargin) and (Value >= -1) then begin
    FMargin := Value;
    Invalidate;
  end;
end;

procedure TTeSpeedButton.ActionChange(Sender: TObject; CheckDefaults: Boolean);
begin
  inherited ActionChange(Sender, CheckDefaults);
  if Sender is TCustomAction then
    with TCustomAction(Sender) do begin
      if not CheckDefaults or (Self.Down = False) then
        Self.Down := Checked;
    end;
end;

procedure TTeSpeedButton.AssignTo(Dest: TPersistent);
begin
  inherited AssignTo(Dest);
  if Dest is TCustomAction then
    with TCustomAction(Dest) do begin
      Checked := Self.Down;
    end;
end;

function TTeSpeedButton.GetActionLinkClass: TControlActionLinkClass;
begin
  Result := TTeSpeedButtonActionLink;
end;

function TTeSpeedButton.IsCheckedStored: Boolean;
begin
  Result := (ActionLink = nil) or not TTeSpeedButtonActionLink(ActionLink).IsCheckedLinked;
end;

procedure TTeSpeedButton.CMButtonStyleChanged(var Message: TMessage);
begin
  FAlwaysUp := _ButtonManager.FButtonStyle in [bsMiddle];
  SetFlat(_ButtonManager.FButtonStyle in [bsFlat, bsMiddle]);
  Invalidate;
end;

procedure TTeSpeedButton.SetImageName(const Value: string);
begin
  if TTeButtonGlyph(FGlyph).FImageName <> Value then begin
    TTeButtonGlyph(FGlyph).FImageName := Value;
    Invalidate;
  end;
end;

function TTeSpeedButton.GetImageName: string;
begin
  Result := TTeButtonGlyph(FGlyph).FImageName;
end;

procedure TTeSpeedButton.Click;
begin
  if Enabled then
    inherited;
end;

{ TTeSpeedButtonActionLink }

procedure TTeSpeedButtonActionLink.AssignClient(AClient: TObject);
begin
  inherited AssignClient(AClient);
  FClient := AClient as TTeSpeedButton;
end;

function TTeSpeedButtonActionLink.IsCheckedLinked: Boolean;
begin
  Result := inherited IsCheckedLinked and
    (FClient.Down = (Action as TCustomAction).Checked);
end;

procedure TTeSpeedButtonActionLink.SetChecked(Value: Boolean);
begin
  if IsCheckedLinked then FClient.Down := Value;
end;

{ TTeBitBtnActionLink }

procedure TTeBitBtnActionLink.AssignClient(AClient: TObject);
begin
  inherited AssignClient(AClient);
  FClient := AClient as TTeBitBtn;
end;

function TTeBitBtnActionLink.IsCheckedLinked: Boolean;
begin
  Result := inherited IsCheckedLinked and
    (FClient.Down = (Action as TCustomAction).Checked);
end;

procedure TTeBitBtnActionLink.SetChecked(Value: Boolean);
begin
  if IsCheckedLinked then FClient.Down := Value;
end;

procedure TTeBitBtn.ActionChange(Sender: TObject; CheckDefaults: Boolean);
begin
  inherited ActionChange(Sender, CheckDefaults);
  if Sender is TCustomAction then
    with TCustomAction(Sender) do begin
      if not CheckDefaults or (Self.Down = False) then
        Self.Down := Checked;
    end;
end;

procedure TTeBitBtn.AssignTo(Dest: TPersistent);
begin
  inherited AssignTo(Dest);
  if Dest is TCustomAction then
    with TCustomAction(Dest) do begin
      Checked := Self.Down;
    end;
end;

function TTeBitBtn.GetActionLinkClass: TControlActionLinkClass;
begin
  Result := TTeBitBtnActionLink;
end;

function TTeBitBtn.IsCheckedStored: Boolean;
begin
  Result := (ActionLink = nil) or not TTeBitBtnActionLink(ActionLink).IsCheckedLinked;
end;

procedure TTeBitBtn.CMButtonStyleChanged(var Message: TMessage);
begin
  FAlwaysUp := _ButtonManager.FButtonStyle in [bsMiddle];
  SetFlat(_ButtonManager.FButtonStyle in [bsFlat, bsMiddle]);
  Invalidate;
end;

function TTeBitBtn.GetImageName: string;
begin
  Result := TTeButtonGlyph(FGlyph).FImageName;
end;

procedure TTeBitBtn.SetImageName(const Value: string);
begin
  if TTeButtonGlyph(FGlyph).FImageName <> Value then begin
    TTeButtonGlyph(FGlyph).FImageName := Value;
    Invalidate;
  end;
end;

{ TTeButtonManager }

procedure TTeButtonManager.SetButtonStyle(const Value: TTeButtonStyle);
begin
  if Value <> FButtonStyle then begin
    FButtonStyle := Value;
    UpdateAll;
  end;
end;

{ TTeButtonManagerImpl }

procedure TTeButtonManagerImpl.AddButton(AButton: TControl);
begin
  if not Assigned(Self) then Exit;
  FList.Add(AButton);
end;

constructor TTeButtonManagerImpl.Create;
begin
  FList := TList.Create;
end;

destructor TTeButtonManagerImpl.Destroy;
begin
  FList.Free;
  FList := nil;
end;

procedure TTeButtonManagerImpl.RemoveButton(AButton: TControl);
begin
  if not Assigned(Self) then Exit;
  FList.Remove(AButton);
end;

procedure TTeButtonManagerImpl.UpdateAll;
var
  i                                : integer;
begin
  for i := 0 to Pred(FList.Count) do
    TControl(FList[i]).Perform(CM_BUTTONSTYLECHANGED, 0, 0);
end;

initialization
  _ButtonManager := TTeButtonManagerImpl.Create;
finalization
  _ButtonManager.Free;
  _ButtonManager := nil;
end.

