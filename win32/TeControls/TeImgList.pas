unit TeImgList;

interface

uses
  Windows,
  Classes, SysUtils, ImgList, Graphics,
  Controls;

resourcestring
  rsImageIsWrongSize          = 'The image named "%s" has the wrong size';

  {$R TeDefault.res}

const
  imAbort                     = 'Abort';
  imApply                     = 'Apply';
  imClose                     = 'Close';
  imFastBack                  = 'FastBack';
  imFastForward               = 'FastForward';
  imFirst                     = 'First';
  imHelp                      = 'Help';
  imIgnore                    = 'Ignore';
  imLast                      = 'Last';
  imNext                      = 'Next';
  imNo                        = 'No';
  imOK                        = 'OK';
  imPrior                     = 'Prior';
  imReset                     = 'Reset';
  imYes                       = 'Yes';
  imNew                       = 'New';
  imCopy                      = 'Copy';
  imEdit                      = 'Edit';
  imDelete                    = 'Delete';
  imMoveUp                    = 'MoveUp';
  imMoveDown                  = 'MoveDown';

type
  TTeImageState = (isUp, isDown, isDisabled, isMono);
  TTeIntegerArray = array of integer;

  ETeImageManager = class(Exception);

  TTeImageManager = class(TObject)
  private
    FImages: TList;
    FMasks: TList;
    FNames: TStringList;
    function GetImageIndex(Name: string): integer;
  public
    constructor Create;
    destructor Destroy; override;

    function AddImage(aName: string; aBmp: TBitmap): Integer; overload;
    function AddImage(aName: string): Integer; overload;    // from resource
    function AddImage(aName: string; Instance: HINST): Integer; overload; // from resource

    procedure Draw(State: TTeImageState; Canvas: TCanvas; X, Y, Index: Integer); overload;
    procedure Draw(State: TTeImageState; Canvas: TCanvas; X, Y: Integer; Name: string); overload;

    procedure DrawMulti(State: TTeImageState; aCanvas: TCanvas; X, Y: Integer; const Indices: TTeIntegerArray); overload;
    procedure DrawMulti(State: TTeImageState; aCanvas: TCanvas; X, Y: Integer; Names: string); overload;

    property ImageIndex[Name: string]: integer read GetImageIndex;
  end;

function TeImageManager: TTeImageManager;

implementation

function CorrectColor(C: Single): Integer;
begin
  Result := Round(C);
  if Result > 255 then Result := 255;
  if Result < 0 then Result := 0;
end;

function ERGB(R, G, B: Single): TColor;
begin
  Result := RGB(CorrectColor(R), CorrectColor(G), CorrectColor(B));
end;

function ColorToGrey(SC: TColor): TColor;
var
  avg                         : Integer;
begin
  avg := Round((GetRValue(SC) * 20 + GetGValue(SC) * 50 + GetBValue(SC) * 30) / 100);
  Result := RGB(avg, avg, avg);
end;

function Colorise(SC, MC: TColor): TColor;
var
  pR, pG, pB                  : Single;
begin
  // take the each percentage of r, g, b in the given color
  pR := GetRValue(MC) / 255 + 1;
  pG := GetGValue(MC) / 255 + 1;
  pB := GetBValue(MC) / 255 + 1;

  Result := ColorToGrey(SC);
  Result := ERGB(pR * GetRValue(Result), pG * GetGValue(Result), pB * GetBValue(Result));
end;

function CreateMask(Src: TBitmap; TransColor: TColor): TBitmap;
var
  OrigColor                   : TColor;
  SDC                         : HDC;
begin
  Result := TBitmap.Create;
  try
    SDC := Src.Canvas.Handle;
    Result.Monochrome := True;
    Result.Width := Src.Width;
    Result.Height := Src.Height;
    TransColor := ColorToRGB(TransColor);
    OrigColor := SetBkColor(SDC, TransColor);
    try
      // The transparent area will White and the non-transparent area
      // will be Black.
      BitBlt(Result.Canvas.Handle, 0, 0, Src.Width, Src.Height,
        SDC, 0, 0, SRCCOPY);
    finally
      SetBkColor(SDC, OrigColor);
    end;
  except
    Result.Free;
    raise;
  end;
end;

function ColoriseImage(Bmp: TBitmap; BaseColor: TColor): TBitmap;
var
  i, j                        : Integer;
begin
  Result := TBitmap.Create;
  try
    Result.Width := Bmp.Width;
    Result.Height := Bmp.Height;
    for i := 0 to Result.Width - 1 do
      for j := 0 to Result.Height - 1 do
        Result.Canvas.Pixels[i, j] := Colorise(Bmp.Canvas.Pixels[i, j], BaseColor);
  except
    Result.Free;
    raise;
  end;
end;

function BMPFromRes(ResName: string; Instance: HINST): TBitmap;
begin
  Result := TBitmap.Create;
  try
    Result.LoadFromResourceName(Instance, UpperCase(ResName));
  except
    Result.Free;
    raise;
  end;
end;

procedure PaintOnMask(Dest: TCanvas; X, Y: Integer; XMask, Bmp: TBitmap); overload;
var
  fStore                      : TBitmap;
  R                           : TRect;
  OldMode                     : TCopyMode;
begin
  fStore := TBitmap.Create;
  try
    with fStore do begin
      Width := Bmp.Width;
      Height := Bmp.Height;
      R := Rect(0, 0, Width, Height);
      with Canvas do begin
        OldMode := CopyMode;
        try
          CopyMode := cmSrcCopy;
          CopyRect(R, Dest, Bounds(X, Y, Width, Height));

          CopyMode := cmSrcInvert;
          Draw(0, 0, Bmp);

          CopyMode := cmSrcAnd;
          Draw(0, 0, XMask);

          CopyMode := cmSrcInvert;
          Draw(0, 0, Bmp);
        finally
          CopyMode := OldMode;
        end;
      end;
    end;
    Dest.Draw(x, y, fStore);
  finally
    fStore.Free;
  end;
end;

procedure PaintOnMask(Dest: TCanvas; X, Y: Integer; XMask, Bmp: TBitmap; const rc: TRect); overload;
var
  fStore                      : TBitmap;
  R                           : TRect;
begin
  fStore := TBitmap.Create;
  try
    with fStore do begin
      Width := rc.Right - rc.Left;
      Height := rc.Bottom - rc.Top;
      R := Rect(0, 0, Width, Height);
      with Canvas do begin
        CopyMode := cmSrcCopy;
        CopyRect(R, Dest, Bounds(X, Y, Width, Height));

        CopyMode := cmSrcInvert;
        CopyRect(R, Bmp.Canvas, rc);

        CopyMode := cmSrcAnd;
        CopyRect(R, XMask.Canvas, rc);

        CopyMode := cmSrcInvert;
        CopyRect(R, Bmp.Canvas, rc);
      end;
    end;
    Dest.Draw(x, y, fStore);
  finally
    fStore.Free;
  end;
end;

function TransColor(Bmp: TBitmap): TColor;
begin
  Result := Bmp.Canvas.Pixels[0, 0];
end;

{ TTeImageManager }

function TTeImageManager.AddImage(aName: string; aBmp: TBitmap): Integer;
var
  b                           : TBitmap;
  m                           : TBitmap;
  mono                        : TBitmap;
begin
  Result := ImageIndex[aName];
  if Result < 0 then begin
    if not Assigned(aBmp) or (aBmp.Width <> 24 * 3) or (aBmp.Height <> 24) then
      raise ETeImageManager.CreateFmt(rsImageIsWrongSize, [aName]);
    b := TBitmap.Create;
    try
      b.Width := 24 * 4;
      b.Height := 24;
      b.Canvas.Draw(0, 0, aBmp);
      b.Canvas.Draw(24 * 3, 0, aBmp);
      m := CreateMask(b, TransColor(b));
      mono := ColoriseImage(b, ColorToRGB(clBtnFace));
      try
        b.Canvas.Draw(24 * 3, 0, mono);
      finally
        mono.Free;
      end;
    except
      b.Free;
      raise;
    end;
    Result := FImages.Add(b);
    FMasks.Add(m);
    FNames.AddObject(aName, TObject(Result));
  end;
end;

function TTeImageManager.AddImage(aName: string): Integer;
var
  Bmp                         : TBitmap;
begin
  Bmp := BMPFromRes(aName, HINSTANCE);
  try
    Result := AddImage(aName, Bmp);
  finally
    Bmp.Free;
  end;
end;

function TTeImageManager.AddImage(aName: string; Instance: HINST): Integer;
var
  Bmp                         : TBitmap;
begin
  Bmp := BMPFromRes(aName, Instance);
  try
    Result := AddImage(aName, Bmp);
  finally
    Bmp.Free;
  end;
end;

constructor TTeImageManager.Create;
begin
  inherited Create;
  FNames := TStringList.Create;
  FNames.Sorted := True;
  FNames.Duplicates := dupError;
  FImages := TList.Create;
  FMasks := TList.Create;
end;

destructor TTeImageManager.Destroy;

  procedure FreeObjectList(var List: TList);
  var
    j                         : Integer;
  begin
    if Assigned(List) then
      for j := Pred(List.Count) downto 0 do try
        TObject(List[j]).Free;
      except
      end;
    List.Free;
    List := nil;
  end;

begin
  FNames.Free;
  FNames := nil;
  FreeObjectList(FImages);
  FreeObjectList(FMasks);
  inherited;
end;

procedure TTeImageManager.Draw(State: TTeImageState; Canvas: TCanvas; X, Y: Integer; Name: string);
var
  i                           : integer;
begin
  i := ImageIndex[Name];
  if i >= 0 then
    Draw(State, Canvas, x, y, i);
end;

procedure TTeImageManager.Draw(State: TTeImageState; Canvas: TCanvas; X, Y, Index: Integer);
begin
  if (Index >= 0) and (Index < FImages.Count) then
    PaintOnMask(Canvas, x, y, TBitmap(FMasks[Index]), TBitmap(FImages[Index]), Bounds(Ord(State) * 24, 0, 24, 24));
end;

procedure TTeImageManager.DrawMulti(State: TTeImageState; aCanvas: TCanvas; X, Y: Integer; const Indices: TTeIntegerArray);
var
  Store                       : TBitmap;
  r                           : TRect;
  i                           : integer;
begin
  Store := TBitmap.Create;
  try
    with Store do begin
      Width := 24;
      Height := 24;
      r := Rect(0, 0, 24, 24);
      with Canvas do begin
        CopyMode := cmSrcCopy;
        CopyRect(r, aCanvas, Bounds(X, Y, 24, 24));
        for i := Low(Indices) to High(Indices) do
          Self.Draw(State, Canvas, 0, 0, Indices[i]);
      end;
    end;
    aCanvas.Draw(X, Y, Store);
  finally
    Store.Free;
  end;
end;

procedure TTeImageManager.DrawMulti(State: TTeImageState; aCanvas: TCanvas; X, Y: Integer; Names: string);
var
  sl                          : TStringList;
  i, j                        : integer;
  Indices                     : TTeIntegerArray;
begin
  sl := TStringList.Create;
  try
    sl.CommaText := Names;
    if sl.Count > 0 then begin
      for i := 0 to Pred(sl.Count) do begin
        j := ImageIndex[sl[i]];
        if j >= 0 then begin
          SetLength(Indices, Length(Indices) + 1);
          Indices[High(Indices)] := j;
        end;
      end;
      if Length(Indices) > 0 then
        DrawMulti(State, aCanvas, x, y, Indices);
    end;
  finally
    sl.Free;
  end;
end;

function TTeImageManager.GetImageIndex(Name: string): integer;
begin
  Result := FNames.IndexOf(Name);
  if Result >= 0 then
    Result := Integer(FNames.Objects[Result]);
end;

var
  _ImageManager               : TTeImageManager;

function TeImageManager: TTeImageManager;
begin
  if not Assigned(_ImageManager) then
    _ImageManager := TTeImageManager.Create;
  Result := _ImageManager;
end;

initialization
  // Default Images
  TeImageManager.AddImage(imAbort);
  TeImageManager.AddImage(imApply);
  TeImageManager.AddImage(imClose);
  TeImageManager.AddImage(imFastBack);
  TeImageManager.AddImage(imFastForward);
  TeImageManager.AddImage(imFirst);
  TeImageManager.AddImage(imHelp);
  TeImageManager.AddImage(imIgnore);
  TeImageManager.AddImage(imLast);
  TeImageManager.AddImage(imNext);
  TeImageManager.AddImage(imNo);
  TeImageManager.AddImage(imOK);
  TeImageManager.AddImage(imPrior);
  TeImageManager.AddImage(imReset);
  TeImageManager.AddImage(imYes);
  TeImageManager.AddImage(imNew);
  TeImageManager.AddImage(imCopy);
  TeImageManager.AddImage(imEdit);
  TeImageManager.AddImage(imDelete);
  TeImageManager.AddImage(imMoveUp);
  TeImageManager.AddImage(imMoveDown);
finalization
  _ImageManager.Free;
  _ImageManager := nil;
end.

