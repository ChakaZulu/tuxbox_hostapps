unit TeRichEdit;

interface

uses
  Windows, Messages, ActiveX,
  RichEdit, TeRichOle, OleDlg, TeTextObjectModel,
  Classes, SysUtils, Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls,
  ComCtrls, ComStrs, OleCtnrs, OleCtrls, ComObj, Menus, Printers, Clipbrd,
  StdActns;

resourcestring
  rsTyping                    = 'typing';
  rsDelete                    = 'delete';
  rsDragDrop                  = 'drag and drop';
  rsCut                       = 'cut';
  rsPaste                     = 'past';

  rsUnableToGetInterface      = 'RichEdit: Unable to get interface';
  rsUnableToSetCallback       = 'RichEdit: Unable to set callback';
  rsEmptyDocument             = 'RichEdit: Empty document';
  rsInvalidVerb               = 'RichEdit: Invalid Verb';

var
  CF_RTF                      : Cardinal = 0;
  CF_RTFNOOBJS                : Cardinal = 0;
  CF_RETEXTOBJ                : Cardinal = 0;

const
  RichEditModuleName          = 'RICHED20.DLL';

type
  TLanguage = 0..$FFFF;

  TTeCustomRichEdit = class;

  TTeRichEditOleCallback = class(TInterfacedObject, IRichEditOleCallback)
  private
    FOwner: TTeCustomRichEdit;
  protected
    function GetNewStorage(out stg: IStorage): HRESULT; stdcall;
    function GetInPlaceContext(out Frame: IOleInPlaceFrame; out Doc: IOleInPlaceUIWindow; var FrameInfo: TOleInPlaceFrameInfo): HRESULT; stdcall;
    function ShowContainerUI(fShow: BOOL): HRESULT; stdcall;
    function QueryInsertObject(const clsid: TCLSID; stg: IStorage; cp: longint): HRESULT; stdcall;
    function DeleteObject(oleobj: IOLEObject): HRESULT; stdcall;
    function QueryAcceptData(dataobj: IDataObject; var cfFormat: TClipFormat; reco: DWORD; fReally: BOOL; hMetaPict: HGLOBAL): HRESULT; stdcall;
    function ContextSensitiveHelp(fEnterMode: BOOL): HRESULT; stdcall;
    function GetClipboardData(const chrg: TCharRange; reco: DWORD; out dataobj: IDataObject): HRESULT; stdcall;
    function GetDragDropEffect(fDrag: BOOL; grfKeyState: DWORD; var dwEffect: DWORD): HRESULT; stdcall;
    function GetContextMenu(seltype: Word; oleobj: IOleObject; const chrg: TCharRange; var menu: HMENU): HRESULT; stdcall;
  public
    constructor Create(AOwner: TTeCustomRichEdit);
    destructor Destroy; override;
  end;

  TTeConsistentAttribute = (caBold, caColor, caFace, caItalic,
    caSize, caStrikeOut, caUnderline, caProtected, caWeight,
    caBackColor, caLanguage, caIndexKind, caOffset, caSpacing,
    caKerning, caULType, caAnimation, caSmallCaps, caAllCaps,
    caHidden, caOutline, caShadow, caEmboss, caImprint, caURL);
  TTeConsistentAttributes = set of TTeConsistentAttribute;

  TTeIndexKind = (ikNone, ikSubscript, ikSuperscript);

  TTeUnderlineType = (ultNone, ultSingle, ultWord, ultDouble, ultDotted, ultWave,
    ultThick, ultHair, ultDashDD, ultDashD, ultDash);

  TTeAnimationType = (aniNone, aniLasVegas, aniBlink, aniSparkle, aniBlackAnts,
    aniRedAnts, aniShimmer);

  TTeTextAttributes = class(TPersistent)
  private
    RichEdit: TTeCustomRichEdit;
    FType: TAttributeType;
    procedure GetAttributes(var Format: TCharFormat2);
    function GetConsistentAttributes: TTeConsistentAttributes;
    procedure SetAttributes(var Format: TCharFormat2);
  protected
    procedure InitFormat(var Format: TCharFormat2);
    procedure AssignTo(Dest: TPersistent); override;
    function GetColor: TColor;
    procedure SetColor(Value: TColor);
    function GetName: TFontName;
    procedure SetName(Value: TFontName);
    function GetPitch: TFontPitch;
    procedure SetPitch(Value: TFontPitch);
    function GetProtected: Boolean;
    procedure SetProtected(Value: Boolean);
    function GetSize: Integer;
    procedure SetSize(Value: Integer);
    function GetHeight: Integer;
    procedure SetHeight(Value: Integer);
    function GetWeight: Word;
    procedure SetWeight(Value: Word);
    function GetBackColor: TColor;
    procedure SetBackColor(Value: TColor);
    function GetLanguage: TLanguage;
    procedure SetLanguage(Value: TLanguage);
    function GetIndexKind: TTeIndexKind;
    procedure SetIndexKind(Value: TTeIndexKind);
    function GetOffset: Double;
    procedure SetOffset(Value: Double);
    function GetSpacing: Double;
    procedure SetSpacing(Value: Double);
    function GetKerning: Double;
    procedure SetKerning(Value: Double);
    function GetUnderlineType: TTeUnderlineType;
    procedure SetUnderlineType(Value: TTeUnderlineType);
    function GetAnimation: TTeAnimationType;
    procedure SetAnimation(Value: TTeAnimationType);
    function GetBold: Boolean;
    procedure SetBold(Value: Boolean);
    function GetUnderline: Boolean;
    procedure SetUnderline(Value: Boolean);
    function GetItalic: Boolean;
    procedure SetItalic(Value: Boolean);
    function GetStrikeOut: Boolean;
    procedure SetStrikeOut(Value: Boolean);
    function GetSmallCaps: Boolean;
    procedure SetSmallCaps(Value: Boolean);
    function GetAllCaps: Boolean;
    procedure SetAllCaps(Value: Boolean);
    function GetHidden: Boolean;
    procedure SetHidden(Value: Boolean);
    function GetOutline: Boolean;
    procedure SetOutline(Value: Boolean);
    function GetShadow: Boolean;
    procedure SetShadow(Value: Boolean);
    function GetEmboss: Boolean;
    procedure SetEmboss(Value: Boolean);
    function GetImprint: Boolean;
    procedure SetImprint(Value: Boolean);
    function GetStyle: TFontStyles;
    procedure SetStyle(Value: TFontStyles);
    function GetIsURL: Boolean;
    procedure SetIsURL(Value: Boolean);
  public
    constructor Create(AOwner: TTeCustomRichEdit; AttributeType: TAttributeType);
    procedure Assign(Source: TPersistent); override;
    property ConsistentAttributes: TTeConsistentAttributes read GetConsistentAttributes;
    property Color: TColor read GetColor write SetColor;
    property Name: TFontName read GetName write SetName;
    property Pitch: TFontPitch read GetPitch write SetPitch;
    property Protected: Boolean read GetProtected write SetProtected;
    property Size: Integer read GetSize write SetSize;
    property Height: Integer read GetHeight write SetHeight;
    property Weight: Word read GetWeight write SetWeight;
    property BackColor: TColor read GetBackColor write SetBackColor;
    property Language: TLanguage read GetLanguage write SetLanguage;
    property IndexKind: TTeIndexKind read GetIndexKind write SetIndexKind;
    property Offset: Double read GetOffset write SetOffset;
    property Spacing: Double read GetSpacing write SetSpacing;
    property Kerning: Double read GetKerning write SetKerning;
    property UnderlineType: TTeUnderlineType read GetUnderlineType write SetUnderlineType;
    property Animation: TTeAnimationType read GetAnimation write SetAnimation;
    property Bold: Boolean read GetBold write SetBold;
    property Underline: Boolean read GetUnderline write SetUnderline;
    property Italic: Boolean read GetItalic write SetItalic;
    property StrikeOut: Boolean read GetStrikeOut write SetStrikeOut;
    property SmallCaps: Boolean read GetSmallCaps write SetSmallCaps;
    property AllCaps: Boolean read GetAllCaps write SetAllCaps;
    property Hidden: Boolean read GetHidden write SetHidden;
    property Outline: Boolean read GetOutline write SetOutline;
    property Shadow: Boolean read GetShadow write SetShadow;
    property Emboss: Boolean read GetEmboss write SetEmboss;
    property Imprint: Boolean read GetImprint write SetImprint;
    property Style: TFontStyles read GetStyle write SetStyle;
    property IsURL: Boolean read GetIsURL write SetIsURL;
  end;

  TTeLineSpacingRule = (lsrOrdinary, lsr15, lsrDouble, lsrAtLeast, lsrExactly, lsrMultiple);

  TTeAlignment = (taLeft, taRight, taCenter, taJustify);

  TTeNumberingStyle = (nsNone, nsBullet, nsNumber, nsLowerCase, nsUpperCase, nsLowerRoman, nsUpperRoman, nsSequence);

  TTeNumberingFollow = (nfParenthesis, nfPeriod, nfEncloseParenthesis);

  TTeBorderLocation = (blLeft, blRight, blTop, blBottom, blInside, blOutside);
  TTeBorderLocations = set of TTeBorderLocation;

  TTeBorderStyle = (bsNone, bs15, bs30, bs45, bs60, bs90, bs120, bs15Dbl,
    bs30Dbl, bs45Dbl, bs15Gray, bs15GrayDashed);

  TTeShadingWeight = 0..100;

  TTeShadingStyle = (shsNone, shsDarkHorizontal, shsDarkVertical, shsDarkDownDiagonal,
    shsDarkUpDiagonal, shsDarkGrid, shsDarkTrellis, shsLightHorizontal,
    shsLightVertical, shsLightDownDiagonal, shsLightUpDiagonal,
    shsLightGrid, shsLightTrellis);

  TTeTabAlignment = (tbaLeft, tbaCenter, tbaRight, tbaDecimal, tbaWordBar);

  TTeTabLeader = (tblNone, tblDotted, tblDashed, tblUnderlined, tblThick, tblDouble);

  TTeParaAttributes = class(TPersistent)
  private
    RichEdit: TTeCustomRichEdit;
    procedure GetAttributes(var Paragraph: TParaFormat2);
    procedure InitPara(var Paragraph: TParaFormat2);
    procedure SetAttributes(var Paragraph: TParaFormat2);
    function GetFirstIndent: Double;
    procedure SetFirstIndent(Value: Double);
    function GetLeftIndent: Double;
    procedure SetLeftIndent(Value: Double);
    function GetRightIndent: Double;
    procedure SetRightIndent(Value: Double);
    function GetSpaceBefore: Double;
    procedure SetSpaceBefore(Value: Double);
    function GetSpaceAfter: Double;
    procedure SetSpaceAfter(Value: Double);
    function GetLineSpacing: Double;
    function GetLineSpacingRule: TTeLineSpacingRule;
    function GetKeepTogether: Boolean;
    procedure SetKeepTogether(Value: Boolean);
    function GetKeepWithNext: Boolean;
    procedure SetKeepWithNext(Value: Boolean);
    function GetPageBreakBefore: Boolean;
    procedure SetPageBreakBefore(Value: Boolean);
    function GetNoLineNumber: Boolean;
    procedure SetNoLineNumber(Value: Boolean);
    function GetNoWidowControl: Boolean;
    procedure SetNoWidowControl(Value: Boolean);
    function GetDoNotHyphen: Boolean;
    procedure SetDoNotHyphen(Value: Boolean);
    function GetSideBySide: Boolean;
    procedure SetSideBySide(Value: Boolean);
    function GetAlignment: TTeAlignment;
    procedure SetAlignment(Value: TTeAlignment);
    function GetNumbering: TTeNumberingStyle;
    procedure SetNumbering(Value: TTeNumberingStyle);
    function GetBullet: Boolean;
    procedure SetBullet(Value: Boolean);
    function GetNumberingStart: Word;
    procedure SetNumberingStart(Value: Word);
    function GetNumberingFollow: TTeNumberingFollow;
    procedure SetNumberingFollow(Value: TTeNumberingFollow);
    function GetNumberingTab: Double;
    procedure SetNumberingTab(Value: Double);
    function GetBorderSpace: Double;
    function GetBorderWidth: Double;
    function GetBorderLocations: TTeBorderLocations;
    function GetBorderStyle: TTeBorderStyle;
    function GetBorderColor: TColor;
    function GetShadingWeight: TTeShadingWeight;
    function GetShadingStyle: TTeShadingStyle;
    function GetShadingColor: TColor;
    function GetShadingBackColor: TColor;
    function GetTabCount: Integer;
    function GetTab(Index: Integer): Double;
    function GetTabAlignment(Index: Integer): TTeTabAlignment;
    function GetTabLeader(Index: Integer): TTeTabLeader;
  public
    constructor Create(AOwner: TTeCustomRichEdit);
    property Alignment: TTeAlignment read GetAlignment write SetAlignment;
    property FirstIndent: Double read GetFirstIndent write SetFirstIndent;
    property LeftIndent: Double read GetLeftIndent write SetLeftIndent;
    property RightIndent: Double read GetRightIndent write SetRightIndent;
    property SpaceBefore: Double read GetSpaceBefore write SetSpaceBefore;
    property SpaceAfter: Double read GetSpaceAfter write SetSpaceAfter;
    procedure SetLineSpacing(Rule: TTeLineSpacingRule; Value: Double);
    property LineSpacing: Double read GetLineSpacing;
    property LineSpacingRule: TTeLineSpacingRule read GetLineSpacingRule;
    property KeepTogether: Boolean read GetKeepTogether write SetKeepTogether;
    property KeepWithNext: Boolean read GetKeepWithNext write SetKeepWithNext;
    property PageBreakBefore: Boolean read GetPageBreakBefore write SetPageBreakBefore;
    property NoLineNumber: Boolean read GetNoLineNumber write SetNoLineNumber;
    property NoWidowControl: Boolean read GetNoWidowControl write SetNoWidowControl;
    property DoNotHyphen: Boolean read GetDoNotHyphen write SetDoNotHyphen;
    property SideBySide: Boolean read GetSideBySide write SetSideBySide;
    property Numbering: TTeNumberingStyle read GetNumbering write SetNumbering;
    property Bullet: Boolean read GetBullet write SetBullet;
    property NumberingStart: Word read GetNumberingStart write SetNumberingStart;
    property NumberingFollow: TTeNumberingFollow read GetNumberingFollow write SetNumberingFollow;
    property NumberingTab: Double read GetNumberingTab write SetNumberingTab;
    property BorderSpace: Double read GetBorderSpace;
    property BorderWidth: Double read GetBorderWidth;
    property BorderLocations: TTeBorderLocations read GetBorderLocations;
    property BorderStyle: TTeBorderStyle read GetBorderStyle;
    property BorderColor: TColor read GetBorderColor;
    procedure SetBorder(Space, Width: Double; Locations: TTeBorderLocations; Style: TTeBorderStyle; Color: TColor);
    property ShadingWeight: TTeShadingWeight read GetShadingWeight;
    property ShadingStyle: TTeShadingStyle read GetShadingStyle;
    property ShadingColor: TColor read GetShadingColor;
    property ShadingBackColor: TColor read GetShadingBackColor;
    procedure SetShading(Weight: TTeShadingWeight; Style: TTeShadingStyle; Color, BackColor: TColor);
    property TabCount: Integer read GetTabCount;
    property Tab[Index: Integer]: Double read GetTab;
    property TabAlignment[Index: Integer]: TTeTabAlignment read GetTabAlignment;
    property TabLeader[Index: Integer]: TTeTabLeader read GetTabLeader;
    procedure SetTab(Index: Integer; Value: Double; Alignment: TTeTabAlignment; Leader: TTeTabLeader);
  end;

  TTeInputFormat = (ifText, ifRTF, ifUnicode);
  TTeOutputFormat = (ofText, ofRTF, ofRTFNoObjs, ofTextized, ofUnicode);

  ETeCustomRichEdit = class(Exception);

  TTeCustomRichEdit = class(TCustomRichEdit)
  private
    FRecreateStream: TMemoryStream;

    FLines: TStrings;
    FWordFormatting: Boolean;
    FSelAttributesEx: TTeTextAttributes;
    FDefAttributesEx: TTeTextAttributes;
    FParagraphEx: TTeParaAttributes;

    FRichEditOle: IRichEditOle;
    FTextDocument: ITextDocument;
    FRichEditOleCallback: IRichEditOleCallback;

    FScreenLogPixels: Integer;

    FObjectVerbs: TStringList;
    FSelObject: IOleObject;
    FDrawAspect: Longint;
    FPopupVerbMenu: TPopupMenu;
    FViewSize: TPoint;

    FResizeRequest: TRect;

    procedure UpdateObject;
    procedure UpdateView;
    procedure DestroyVerbs;
    procedure UpdateVerbs;
    procedure PopupVerbMenuClick(Sender: TObject);
    procedure DoVerb(Verb: Integer);
    function GetCanPaste: Boolean;
    function GetIconMetaPict: HGlobal;
    procedure CheckObject;
    procedure SetDrawAspect(Iconic: Boolean; IconMetaPict: HGlobal);
    procedure CloseOLEObjects;

    procedure CNNotify(var Message: TWMNotify); message CN_NOTIFY;
    procedure WMDestroy(var Message: TMessage); message WM_DESTROY;
    procedure WMNCDestroy(var Message: TWMNCDestroy); message WM_NCDESTROY;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;

    procedure WMKeyDown(var Message: TWMKeyDown); message WM_KEYDOWN;
    procedure WMSysKeyDown(var Message: TWMKeyDown); message WM_SYSKEYDOWN;
    procedure WMKeyUp(var Message: TWMKeyUp); message WM_KEYUP;
    procedure WMSysKeyUp(var Message: TWMKeyUp); message WM_SYSKEYUP;
    procedure CMWantSpecialKey(var Msg: TCMWantSpecialKey); message CM_WANTSPECIALKEY;

    procedure SetLines(const Value: TStrings);
    function GetCanRedo: Boolean;
    function GetRedoName: string;
    function GetUndoName: string;
    procedure SetDefAttributesEx(const Value: TTeTextAttributes);
    procedure SetSelAttributesEx(const Value: TTeTextAttributes);
    procedure SetParagraphEx(const Value: TTeParaAttributes);
  protected
    procedure UpdateSelObject;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
    function GetPopupMenu: TPopupMenu; override;
    procedure Loaded; override;
    procedure Resize; override;
    procedure RequestSize(const Rect: TRect); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function ObjectSelected: Boolean;
    procedure Clear; override;
    procedure CreateLinkToFile(const FileName: string; Iconic: Boolean);
    procedure CreateObject(const OleClassName: string; Iconic: Boolean);
    procedure CreateObjectFromFile(const FileName: string; Iconic: Boolean);
    procedure CreateObjectFromInfo(const CreateInfo: TCreateInfo);
    procedure InsertObjectDialog;
    function PasteSpecialDialog: Boolean;
    function ChangeIconDialog: Boolean;

    procedure Redo;

    procedure LoadFromStream(Stream: TStream; InputFormat: TTeInputFormat = ifRTF; Selection: boolean = false; PlainRTF: boolean = false);
    procedure SaveToStream(Stream: TStream; OutputFormat: TTeOutputFormat = ofRTF; Selection: boolean = false; PlainRTF: boolean = false);
    procedure LoadFromFile(FileName: string; InputFormat: TTeInputFormat = ifRTF; Selection: boolean = false; PlainRTF: boolean = false);
    procedure SaveToFile(FileName: string; OutputFormat: TTeOutputFormat = ofRTF; Selection: boolean = false; PlainRTF: boolean = false);

    procedure Import(FileName: string);

    property Lines: TStrings read FLines write SetLines;
    property TextDocument: ITextDocument read FTextDocument;
    property CanRedo: Boolean read GetCanRedo;
    property UndoName: string read GetUndoName;
    property RedoName: string read GetRedoName;
    property WordFormatting: Boolean read FWordFormatting write FWordFormatting default False;
    property SelAttributesEx: TTeTextAttributes read FSelAttributesEx write SetSelAttributesEx;
    property DefAttributesEx: TTeTextAttributes read FDefAttributesEx write SetDefAttributesEx;
    property ParagraphEx: TTeParaAttributes read FParagraphEx write SetParagraphEx;
    property CanPaste: Boolean read GetCanPaste;
    property ResizeRequest: TRect read FResizeRequest;
  published
  end;

  TTeRichEdit = class(TTeCustomRichEdit)
  published
    property Align;
    property Alignment;
    property Anchors;
    property BorderStyle;
    property BorderWidth;
    property Color;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property HideScrollBars;
    property Constraints;
    property Lines;
    property MaxLength;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PlainText;
    property PopupMenu;
    property ReadOnly;
    property ScrollBars;
    property ShowHint;
    property TabOrder;
    property TabStop default True;
    property Visible;
    property WantTabs;
    property WantReturns;
    property WordWrap;
    property OnChange;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnProtectChange;
    property OnResizeRequest;
    property OnSaveClipboard;
    property OnSelectionChange;
    property OnStartDock;
    property OnStartDrag;
    property WordFormatting;
  end;

  { TTeRichEditAction }

  TTeRichEditAction = class(TEditAction)
  protected
    function CurrText(Edit: TTeRichEdit): TTeTextAttributes;
    procedure SetFontStyle(Edit: TTeRichEdit; Style: TFontStyle);
  public
    constructor Create(AOwner: TComponent); override;
    function HandlesTarget(Target: TObject): Boolean; override;
  end;

  { TTeRichEditBold }

  TTeRichEditBold = class(TTeRichEditAction)
  public
    procedure ExecuteTarget(Target: TObject); override;
    procedure UpdateTarget(Target: TObject); override;
  end;

  { TTeRichEditItalic }

  TTeRichEditItalic = class(TTeRichEditAction)
  public
    procedure ExecuteTarget(Target: TObject); override;
    procedure UpdateTarget(Target: TObject); override;
  end;

  { TTeRichEditUnderline }

  TTeRichEditUnderline = class(TTeRichEditAction)
  public
    procedure ExecuteTarget(Target: TObject); override;
    procedure UpdateTarget(Target: TObject); override;
  end;

  { TTeRichEditStrikeOut }

  TTeRichEditStrikeOut = class(TTeRichEditAction)
  public
    procedure ExecuteTarget(Target: TObject); override;
    procedure UpdateTarget(Target: TObject); override;
  end;

  { TTeRichEditBullets }

  TTeRichEditBullets = class(TTeRichEditAction)
  public
    procedure ExecuteTarget(Target: TObject); override;
    procedure UpdateTarget(Target: TObject); override;
  end;

  { TTeRichEditIncreaseIndent }

  TTeRichEditIncreaseIndent = class(TTeRichEditAction)
  public
    procedure ExecuteTarget(Target: TObject); override;
    procedure UpdateTarget(Target: TObject); override;
  end;

  { TTeRichEditDecreaseIndent }

  TTeRichEditDecreaseIndent = class(TTeRichEditAction)
  public
    procedure ExecuteTarget(Target: TObject); override;
    procedure UpdateTarget(Target: TObject); override;
  end;

  { TTeRichEditAlignLeft }

  TTeRichEditAlignLeft = class(TTeRichEditAction)
  public
    procedure ExecuteTarget(Target: TObject); override;
    procedure UpdateTarget(Target: TObject); override;
  end;

  { TTeRichEditAlignRight }

  TTeRichEditAlignRight = class(TTeRichEditAction)
  public
    procedure ExecuteTarget(Target: TObject); override;
    procedure UpdateTarget(Target: TObject); override;
  end;

  { TTeRichEditAlignCenter }

  TTeRichEditAlignCenter = class(TTeRichEditAction)
  public
    procedure ExecuteTarget(Target: TObject); override;
    procedure UpdateTarget(Target: TObject); override;
  end;

implementation

uses
  TeRichConv;

function CodePageFromLocale(Language: TLanguage): Integer;
var
  Buf                         : array[0..6] of Char;
begin
  GetLocaleInfo(Language, LOCALE_IDefaultAnsiCodePage, Buf, 6);
  Result := StrToIntDef(Buf, GetACP);
end;

function CharSetFromLocale(Language: TLanguage): TFontCharSet;
var
  CP                          : Integer;
  CSI                         : TCharsetInfo;
begin
  CP := CodePageFromLocale(Language);
  TranslateCharsetInfo(Cardinal(CP), CSI, TCI_SRCCODEPAGE);
  Result := CSI.ciCharset;
end;

procedure CenterWindow(Wnd: HWnd);
var
  Rect                        : TRect;
begin
  GetWindowRect(Wnd, Rect);
  SetWindowPos(Wnd, 0,
    (GetSystemMetrics(SM_CXSCREEN) - Rect.Right + Rect.Left) div 2,
    (GetSystemMetrics(SM_CYSCREEN) - Rect.Bottom + Rect.Top) div 3,
    0, 0, SWP_NOACTIVATE or SWP_NOSIZE or SWP_NOZORDER);
end;

function OleDialogHook(Wnd: HWnd; Msg, WParam, LParam: Longint): Longint; stdcall;
begin
  Result := 0;
  if Msg = WM_INITDIALOG then begin
    if GetWindowLong(Wnd, GWL_STYLE) and WS_CHILD <> 0 then
      Wnd := GetWindowLong(Wnd, GWL_HWNDPARENT);
    CenterWindow(Wnd);
    Result := 1;
  end;
end;

var
  CFLinkSource                : Integer;
  CFEmbeddedObject            : Integer;

  { TTeRichEditStrings }

const
  ReadError                   = $0001;
  WriteError                  = $0002;
  NoError                     = $0000;

type
  TSelection = record
    StartPos, EndPos: Integer;
  end;

  TStringsHacker = class(TStrings);

  TTeRichEditStrings = class(TStrings)
  private
    RichEdit: TTeCustomRichEdit;
    FStrings: TStringsHacker;
    FPlainText: Boolean;
    procedure EnableChange(const Value: Boolean);
  protected
    function Get(Index: Integer): string; override;
    function GetCount: Integer; override;
    procedure Put(Index: Integer; const S: string); override;
    procedure SetUpdateState(Updating: Boolean); override;
    procedure SetTextStr(const Value: string); override;
  public
    procedure Clear; override;
    procedure AddStrings(Strings: TStrings); override;
    procedure Delete(Index: Integer); override;
    procedure Insert(Index: Integer; const S: string); override;
    procedure LoadFromFile(const FileName: string); override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToFile(const FileName: string); override;
    procedure SaveToStream(Stream: TStream); override;
    property PlainText: Boolean read FPlainText write FPlainText;
  end;

procedure TTeRichEditStrings.AddStrings(Strings: TStrings);
var
  SelChange                   : TNotifyEvent;
begin
  SelChange := RichEdit.OnSelectionChange;
  RichEdit.OnSelectionChange := nil;
  try
    inherited AddStrings(Strings);
  finally
    RichEdit.OnSelectionChange := SelChange;
  end;
end;

function TTeRichEditStrings.GetCount: Integer;
begin
  Result := SendMessage(RichEdit.Handle, EM_GETLINECOUNT, 0, 0);
  if SendMessage(RichEdit.Handle, EM_LINELENGTH, SendMessage(RichEdit.Handle,
    EM_LINEINDEX, Result - 1, 0), 0) = 0 then Dec(Result);
end;

function TTeRichEditStrings.Get(Index: Integer): string;
var
  Text                        : array[0..4095] of Char;
  L                           : Integer;
begin
  Word((@Text)^) := SizeOf(Text);
  L := SendMessage(RichEdit.Handle, EM_GETLINE, Index, Longint(@Text));
  if (Text[L - 1] = #13) then Dec(L, 1);
  SetString(Result, Text, L);
end;

procedure TTeRichEditStrings.Put(Index: Integer; const S: string);
var
  Selection                   : TCharRange;
begin
  if Index >= 0 then begin
    Selection.cpMin := SendMessage(RichEdit.Handle, EM_LINEINDEX, Index, 0);
    if Selection.cpMin <> -1 then begin
      Selection.cpMax := Selection.cpMin +
        SendMessage(RichEdit.Handle, EM_LINELENGTH, Selection.cpMin, 0);
      SendMessage(RichEdit.Handle, EM_EXSETSEL, 0, Longint(@Selection));
      SendMessage(RichEdit.Handle, EM_REPLACESEL, 0, Longint(PChar(S)));
    end;
  end;
end;

procedure TTeRichEditStrings.Insert(Index: Integer; const S: string);
var
  L                           : Integer;
  Selection                   : TCharRange;
  Fmt                         : PChar;
  Str                         : string;
begin
  if Index >= 0 then begin
    Selection.cpMin := SendMessage(RichEdit.Handle, EM_LINEINDEX, Index, 0);
    if Selection.cpMin >= 0 then
      Fmt := '%s'#13
    else begin
      Selection.cpMin :=
        SendMessage(RichEdit.Handle, EM_LINEINDEX, Index - 1, 0);
      if Selection.cpMin < 0 then Exit;
      L := SendMessage(RichEdit.Handle, EM_LINELENGTH, Selection.cpMin, 0);
      if L = 0 then Exit;
      Inc(Selection.cpMin, L);
      Fmt := #13'%s';
    end;
    Selection.cpMax := Selection.cpMin;
    SendMessage(RichEdit.Handle, EM_EXSETSEL, 0, Longint(@Selection));
    Str := Format(Fmt, [S]);
    SendMessage(RichEdit.Handle, EM_REPLACESEL, 0, LongInt(PChar(Str)));
    if RichEdit.SelStart <> (Selection.cpMax + Length(Str)) then
      raise EOutOfResources.Create(sRichEditInsertError);
  end;
end;

procedure TTeRichEditStrings.Delete(Index: Integer);
const
  Empty                       : PChar = '';
var
  Selection                   : TCharRange;
begin
  if Index < 0 then Exit;
  Selection.cpMin := SendMessage(RichEdit.Handle, EM_LINEINDEX, Index, 0);
  if Selection.cpMin <> -1 then begin
    Selection.cpMax := SendMessage(RichEdit.Handle, EM_LINEINDEX, Index + 1, 0);
    if Selection.cpMax = -1 then
      Selection.cpMax := Selection.cpMin +
        SendMessage(RichEdit.Handle, EM_LINELENGTH, Selection.cpMin, 0);
    SendMessage(RichEdit.Handle, EM_EXSETSEL, 0, Longint(@Selection));
    SendMessage(RichEdit.Handle, EM_REPLACESEL, 0, Longint(Empty));
  end;
end;

procedure TTeRichEditStrings.Clear;
begin
  RichEdit.Clear;
end;

procedure TTeRichEditStrings.SetUpdateState(Updating: Boolean);
begin
  if RichEdit.Showing then
    SendMessage(RichEdit.Handle, WM_SETREDRAW, Ord(not Updating), 0);
  if not Updating then begin
    RichEdit.Refresh;
    RichEdit.Perform(CM_TEXTCHANGED, 0, 0);
  end;
end;

procedure TTeRichEditStrings.EnableChange(const Value: Boolean);
var
  EventMask                   : Longint;
begin
  with RichEdit do begin
    if Value then
      EventMask := SendMessage(Handle, EM_GETEVENTMASK, 0, 0) or ENM_CHANGE
    else
      EventMask := SendMessage(Handle, EM_GETEVENTMASK, 0, 0) and not ENM_CHANGE;
    SendMessage(Handle, EM_SETEVENTMASK, 0, EventMask);
  end;
end;

procedure TTeRichEditStrings.SetTextStr(const Value: string);
begin
  EnableChange(False);
  try
    inherited SetTextStr(Value);
  finally
    EnableChange(True);
  end;
end;

procedure TTeRichEditStrings.LoadFromFile(const FileName: string);
begin
  FStrings.LoadFromFile(FileName);
end;

procedure TTeRichEditStrings.LoadFromStream(Stream: TStream);
begin
  FStrings.LoadFromStream(Stream);
end;

procedure TTeRichEditStrings.SaveToFile(const FileName: string);
begin
  FStrings.SaveToFile(FileName);
end;

procedure TTeRichEditStrings.SaveToStream(Stream: TStream);
begin
  FStrings.SaveToStream(Stream);
end;

type
  TUndoName = (unUnknown, unTyping, unDelete, unDragDrop, unCut, unPaste);

function DecodeUndoName(AUndoName: TUndoName): string;
begin
  case AUndoName of
    unTyping: Result := rsTyping;
    unDelete: Result := rsDelete;
    unDragDrop: Result := rsDragDrop;
    unCut: Result := rsCut;
    unPaste: Result := rsPaste;
  else
    Result := '';
  end;
end;

{ TTeCustomRichEdit }

function TTeCustomRichEdit.ChangeIconDialog: Boolean;
var
  Data                        : TOleUIChangeIcon;
begin
  CheckObject;
  Result := False;
  FillChar(Data, SizeOf(Data), 0);
  Data.cbStruct := SizeOf(Data);
  Data.dwFlags := CIF_SELECTCURRENT;
  Data.hWndOwner := Application.Handle;
  Data.lpfnHook := OleDialogHook;
  OleCheck(FSelObject.GetUserClassID(Data.clsid));
  Data.hMetaPict := GetIconMetaPict;
  try
    if OleUIChangeIcon(Data) = OLEUI_OK then begin
      SetDrawAspect(True, Data.hMetaPict);
      Result := True;
    end;
  finally
    DestroyMetaPict(Data.hMetaPict);
  end;
end;

procedure TTeCustomRichEdit.CheckObject;
begin
  if FSelObject = nil then
    raise EOleError.Create(rsEmptyDocument);
end;

procedure TTeCustomRichEdit.Clear;
begin
  CloseOLEObjects;
  inherited Clear;
end;

procedure TTeCustomRichEdit.CloseOLEObjects;
var
  i                           : integer;
  REObject                    : TREObject;
begin
  if not Assigned(FRichEditOle) then Exit;
  fillchar(REObject, sizeof(REObject), 0);
  REObject.cbStruct := sizeof(REObject);
  try
    for i := 0 to Pred(FRichEditOle.GetObjectCount) do begin
      if FRichEditOle.GetObject(i, REObject, REO_GETOBJ_POLEOBJ) = S_OK then
        REObject.oleobj.Close(OLECLOSE_NOSAVE);
    end;
  except
  end;
end;

procedure TTeCustomRichEdit.CNNotify(var Message: TWMNotify);
type
  PENLink = ^TENLink;
begin
  case Message.NMHdr^.code of
    EN_LINK:
      with PENLink(Pointer(Message.NMHdr))^ do begin
        case msg of
          WM_LBUTTONUP: ;
          WM_MOUSEMOVE:
            Windows.SetCursor(Screen.Cursors[crHandPoint]);
        end;
      end;
  else
    inherited;
  end;
end;

constructor TTeCustomRichEdit.Create(AOwner: TComponent);
var
  DC                          : HDC;

begin
  inherited;
  MaxLength := High(Integer) div 2;
  FLines := TTeRichEditStrings.Create;
  TTeRichEditStrings(FLines).RichEdit := Self;
  TTeRichEditStrings(FLines).FStrings := TStringsHacker(inherited Lines);
  FRichEditOleCallback := TTeRichEditOleCallback.Create(Self);

  DC := GetDC(0);
  FScreenLogPixels := GetDeviceCaps(DC, LOGPIXELSY);
  ReleaseDC(0, DC);

  FSelAttributesEx := TTeTextAttributes.Create(Self, atSelected);
  FDefAttributesEx := TTeTextAttributes.Create(Self, atDefaultText);
  FParagraphEx := TTeParaAttributes.Create(Self);
end;

procedure TTeCustomRichEdit.CreateLinkToFile(const FileName: string; Iconic: Boolean);
var
  CreateInfo                  : TCreateInfo;
begin
  CreateInfo.CreateType := ctLinkToFile;
  CreateInfo.ShowAsIcon := Iconic;
  CreateInfo.IconMetaPict := 0;
  CreateInfo.FileName := FileName;
  CreateObjectFromInfo(CreateInfo);
end;

procedure TTeCustomRichEdit.CreateObject(const OleClassName: string; Iconic: Boolean);
var
  CreateInfo                  : TCreateInfo;
begin
  CreateInfo.CreateType := ctNewObject;
  CreateInfo.ShowAsIcon := Iconic;
  CreateInfo.IconMetaPict := 0;
  CreateInfo.ClassID := ProgIDToClassID(OleClassName);
  CreateObjectFromInfo(CreateInfo);
end;

procedure TTeCustomRichEdit.CreateObjectFromFile(const FileName: string; Iconic: Boolean);
var
  CreateInfo                  : TCreateInfo;
begin
  CreateInfo.CreateType := ctFromFile;
  CreateInfo.ShowAsIcon := Iconic;
  CreateInfo.IconMetaPict := 0;
  CreateInfo.FileName := FileName;
  CreateObjectFromInfo(CreateInfo);
end;

procedure TTeCustomRichEdit.CreateObjectFromInfo(const CreateInfo: TCreateInfo);
var
  Storage                     : IStorage;
  OleObject                   : IOleObject;
  OleSite                     : IOleClientSite;
  ReObject                    : TREObject;
  Data                        : TOleUIChangeIcon;
begin
  try
    FRichEditOle.GetClientSite(OleSite);
    FRichEditOleCallback.GetNewStorage(Storage);
    with CreateInfo do begin
      case CreateType of
        ctNewObject: OleCheck(OleCreate(ClassID, IOleObject, OLERENDER_DRAW, nil, OleSite, Storage, OleObject));
        ctFromFile: OleCheck(OleCreateFromFile(GUID_NULL, PWideChar(FileName), IOleObject, OLERENDER_DRAW, nil, OleSite, Storage, OleObject));
        ctLinkToFile: OleCheck(OleCreateLinkToFile(PWideChar(FileName), IOleObject, OLERENDER_DRAW, nil, OleSite, Storage, OleObject));
        ctFromData: OleCheck(OleCreateFromData(DataObject, IOleObject, OLERENDER_DRAW, nil, OleSite, Storage, OleObject));
        ctLinkFromData: OleCheck(OleCreateLinkFromData(DataObject, IOleObject, OLERENDER_DRAW, nil, OleSite, Storage, OleObject));
      end;
      FillChar(ReObject, SizeOf(TREObject), 0);
      ReObject.cbStruct := SizeOf(TREObject);
      ReObject.cp := SelStart;
      ReObject.oleobj := OleObject;
      ReObject.clsid := Data.clsid;
      ReObject.stg := Storage;
      ReObject.olesite := OleSite;
      ReObject.sizel.cx := 0;
      ReObject.sizel.cy := 0;
      ReObject.dwUser := 0;
      FSelObject := OleObject;
      ReObject.dwFlags := REO_DYNAMICSIZE or REO_RESIZABLE;
      if CreateInfo.ShowAsIcon then begin
        ReObject.dvaspect := DVASPECT_ICON;
        FDrawAspect := DVASPECT_ICON;
        SetDrawaspect(True, ICONMETAPICT);
      end
      else begin
        FDrawaspect := DVASPECT_CONTENT;
        ReObject.dvaspect := DVASPECT_CONTENT;
      end;
      if CreateInfo.CreateType = ctNewObject then
        ReObject.dwFlags := ReObject.dwFlags or REO_BLANK;
      FRicheditOle.SetHostNames(PWideChar(WideString(Application.Title)), PWideChar(WideString(Caption)));
      Olecheck(FRichEditOle.InsertObject(ReObject));
    end;
  except
    raise;
  end;
end;

procedure TTeCustomRichEdit.CreateParams(var Params: TCreateParams);
const
  HideScrollBarsStyle         : array[Boolean] of DWORD = (ES_DISABLENOSCROLL, 0);
  HideSelectionsStyle         : array[Boolean] of DWORD = (ES_NOHIDESEL, 0);
begin
  inherited CreateParams(Params);
  CreateSubClass(Params, RICHEDIT_CLASS);
  with Params do begin
    Style := Style or HideScrollBarsStyle[HideScrollBars] or
      HideSelectionsStyle[HideSelection];
    WindowClass.style := WindowClass.style and not (CS_HREDRAW or CS_VREDRAW);
    Style := Style or ES_SAVESEL;
  end;
end;

procedure TTeCustomRichEdit.CreateWnd;
begin
  inherited;
  SendMessage(Handle, EM_SETEVENTMASK, 0, ENM_CHANGE or ENM_SELCHANGE or ENM_REQUESTRESIZE or ENM_PROTECTED or ENM_LINK);
  if not RichEdit_GetOleInterface(Handle, FRichEditOle) then
    raise ETeCustomRichEdit.Create(rsUnableToGetInterface);
  if not RichEdit_SetOleCallback(Handle, FRichEditOlecallback) then
    raise ETeCustomRichEdit.Create(rsUnableToSetCallback);
  FTextDocument := FRichEditOle as ITextDocument;
  if Assigned(FRecreateStream) then begin
    LoadFromStream(FRecreateStream);
    FRecreateStream.Free;
    FRecreateStream := nil;
  end;
end;

destructor TTeCustomRichEdit.Destroy;
begin
  FSelAttributesEx.Free;
  FDefAttributesEx.Free;
  FParagraphEx.Free;
  FLines.Free;
  DestroyVerbs;
  inherited;
  FRecreateStream.Free;
  FRecreateStream := nil;
end;

procedure TTeCustomRichEdit.DestroyVerbs;
begin
  FPopupVerbMenu.Free;
  FPopupVerbMenu := nil;
  FObjectVerbs.Free;
  FObjectVerbs := nil;
end;

procedure TTeCustomRichEdit.DoVerb(Verb: Integer);
var
  H                           : THandle;
  R                           : TRect;
  ClientSite                  : IOleClientSite;
begin
  if not Assigned(FRichEditOle) or not Assigned(FSelObject) then Exit;
  if Verb > 0 then begin
    if FObjectVerbs = nil then UpdateVerbs;
    if Verb >= FObjectVerbs.Count then
      raise EOleError.Create(rsInvalidVerb);
    Verb := Smallint(Integer(FObjectVerbs.Objects[Verb]) and $0000FFFF);
  end
  else
    if Verb = ovPrimary then
      Verb := 0;

  H := Handle;
  R := BoundsRect;
  OleCheck(FRichEditOle.GetClientSite(ClientSite));
  OleCheck(FSelObject.DoVerb(Verb, nil, ClientSite, 0, H, R));
end;

function TTeCustomRichEdit.GetCanPaste: Boolean;
var
  DataObject                  : IDataObject;
begin
  Result := (OleGetClipboard(DataObject) = S_OK) and
    ((OleQueryCreateFromData(DataObject) = S_OK) or
    (OleQueryLinkFromData(DataObject) = S_OK))
end;

function TTeCustomRichEdit.GetCanRedo: Boolean;
begin
  Result := Perform(EM_CANREDO, 0, 0) <> 0;
end;

function TTeCustomRichEdit.GetIconMetaPict: HGlobal;
var
  DataObject                  : IDataObject;
  FormatEtc                   : TFormatEtc;
  Medium                      : TStgMedium;
  ClassID                     : TCLSID;
begin
  CheckObject;
  Result := 0;
  if FDrawAspect = DVASPECT_ICON then begin
    FSelObject.QueryInterface(IDataObject, DataObject);
    if DataObject <> nil then begin
      FormatEtc.cfFormat := CF_METAFILEPICT;
      FormatEtc.ptd := nil;
      FormatEtc.dwAspect := DVASPECT_ICON;
      FormatEtc.lIndex := -1;
      FormatEtc.tymed := TYMED_MFPICT;
      if Integer(DataObject.GetData(FormatEtc, Medium)) >= 0 then
        Result := Medium.hMetaFilePict;
    end;
  end;
  if Result = 0 then begin
    OleCheck(FSelObject.GetUserClassID(ClassID));
    Result := OleGetIconOfClass(ClassID, nil, True);
  end;
end;

function TTeCustomRichEdit.GetPopupMenu: TPopupMenu;
var
  I                           : Integer;
  Item                        : TMenuItem;
  ReObject                    : TREObject;
begin
  Result := inherited GetPopupMenu;
  ReObject.cbStruct := sizeof(TREObject);
  if (FRichEditOle.GetObject(Integer(REO_IOB_SELECTION), ReObject, REO_GETOBJ_POLEOBJ) <> S_OK) or not Assigned(ReObject.oleobj) then begin
    FSelObject := nil;
    DestroyVerbs;
  end
  else
    if FSelObject = ReObject.oleobj then
      Result := FPopupVerbMenu
    else begin
      FSelObject := ReObject.oleobj;
      UpdateVerbs;
      if FObjectVerbs.Count = 0 then
        FPopupVerbMenu := nil
      else begin
        FPopupVerbMenu := TPopupMenu.Create(Self);
        for I := 0 to FObjectVerbs.Count - 1 do begin
          Item := TMenuItem.Create(Self);
          Item.Caption := FObjectVerbs[I];
          Item.Tag := I;
          if TVerbInfo(FObjectVerbs.Objects[i]).Verb = 0 then
            Item.Default := true;
          Item.OnClick := PopupVerbMenuClick;
          FPopupVerbMenu.Items.Add(Item);
        end;
      end;
      Result := FPopupVerbMenu;
    end;
end;

function TTeCustomRichEdit.GetRedoName: string;
begin
  Result := DecodeUndoName(TUndoName(Perform(EM_GETREDONAME, 0, 0)));
end;

function TTeCustomRichEdit.GetUndoName: string;
begin
  Result := DecodeUndoName(TUndoName(Perform(EM_GETUNDONAME, 0, 0)));
end;

procedure TTeCustomRichEdit.InsertObjectDialog;
var
  Data                        : TOleUIInsertObject;
  NameBuTer                   : array[0..255] of Char;
  CreateInfo                  : TCreateInfo;
begin
  FillChar(Data, SizeOf(Data), 0);
  FillChar(NameBuTer, SizeOf(NameBuTer), 0);
  Data.cbStruct := SizeOf(Data);
  Data.dwFlags := IOF_SELECTCREATENEW;
  Data.hWndOwner := Application.Handle;
  Data.lpfnHook := OleDialogHook;
  Data.lpszFile := NameBuTer;
  Data.cchFile := SizeOf(NameBuTer);
  try
    if OleUIInsertObject(Data) = OLEUI_OK then begin
      if Data.dwFlags and IOF_SELECTCREATENEW <> 0 then begin
        CreateInfo.CreateType := ctNewObject;
        CreateInfo.ClassID := Data.clsid;
      end
      else begin
        if Data.dwFlags and IOF_CHECKLINK = 0 then
          CreateInfo.CreateType := ctFromFile
        else
          CreateInfo.CreateType := ctLinkToFile;
        CreateInfo.FileName := NameBuTer;
      end;
      CreateInfo.ShowAsIcon := Data.dwFlags and IOF_CHECKDISPLAYASICON <> 0;
      CreateInfo.IconMetaPict := Data.hMetaPict;
      CreateObjectFromInfo(CreateInfo);
      if CreateInfo.CreateType = ctNewObject then
        DoVerb(OvOpen);
    end;
  finally
    DestroyMetaPict(Data.hMetaPict);
  end;
end;

function TTeCustomRichEdit.ObjectSelected: Boolean;
var
  ReObject                    : TREObject;
begin
  ReObject.cbStruct := sizeof(TREObject);
  result := (FRichEditOle.GetObject(Integer(REO_IOB_SELECTION), ReObject, REO_GETOBJ_POLEOBJ) = S_OK) and Assigned(ReObject.oleobj);
end;

function TTeCustomRichEdit.PasteSpecialDialog: Boolean;
const
  PasteFormatCount            = 2;
var
  Data                        : TOleUIPasteSpecial;
  PasteFormats                : array[0..PasteFormatCount - 1] of TOleUIPasteEntry;
  CreateInfo                  : TCreateInfo;
begin
  Result := False;
  if not CanPaste then Exit;
  FillChar(Data, SizeOf(Data), 0);
  FillChar(PasteFormats, SizeOf(PasteFormats), 0);
  Data.cbStruct := SizeOf(Data);
  Data.hWndOwner := Application.Handle;
  Data.lpfnHook := OleDialogHook;
  Data.arrPasteEntries := @PasteFormats;
  Data.cPasteEntries := PasteFormatCount;
  Data.arrLinkTypes := @CFLinkSource;
  Data.cLinkTypes := 1;
  PasteFormats[0].fmtetc.cfFormat := CFEmbeddedObject;
  PasteFormats[0].fmtetc.dwAspect := DVASPECT_CONTENT;
  PasteFormats[0].fmtetc.lIndex := -1;
  PasteFormats[0].fmtetc.tymed := TYMED_ISTORAGE;
  PasteFormats[0].lpstrFormatName := '%s';
  PasteFormats[0].lpstrResultText := '%s';
  PasteFormats[0].dwFlags := OLEUIPASTE_PASTE or OLEUIPASTE_ENABLEICON;
  PasteFormats[1].fmtetc.cfFormat := CFLinkSource;
  PasteFormats[1].fmtetc.dwAspect := DVASPECT_CONTENT;
  PasteFormats[1].fmtetc.lIndex := -1;
  PasteFormats[1].fmtetc.tymed := TYMED_ISTREAM;
  PasteFormats[1].lpstrFormatName := '%s';
  PasteFormats[1].lpstrResultText := '%s';
  PasteFormats[1].dwFlags := OLEUIPASTE_LINKTYPE1 or OLEUIPASTE_ENABLEICON;
  try
    if OleUIPasteSpecial(Data) = OLEUI_OK then begin
      if Data.fLink then
        CreateInfo.CreateType := ctLinkFromData
      else
        CreateInfo.CreateType := ctFromData;
      CreateInfo.ShowAsIcon := Data.dwFlags and PSF_CHECKDISPLAYASICON <> 0;
      CreateInfo.IconMetaPict := Data.hMetaPict;
      CreateInfo.DataObject := Data.lpSrcDataObj;
      CreateObjectFromInfo(CreateInfo);
      Result := True;
    end;
  finally
    DestroyMetaPict(Data.hMetaPict);
  end;
end;

procedure TTeCustomRichEdit.PopupVerbMenuClick(Sender: TObject);
begin
  DoVerb((Sender as TMenuItem).Tag);
end;

procedure TTeCustomRichEdit.Redo;
begin
  Perform(EM_REDO, 0, 0);
end;

procedure TTeCustomRichEdit.RequestSize(const Rect: TRect);
begin
  FResizeRequest := Rect;
  inherited;
end;

procedure TTeCustomRichEdit.Resize;
begin
  inherited;
  RePaint;
end;

procedure TTeCustomRichEdit.SetDefAttributesEx(const Value: TTeTextAttributes);
begin
  if FDefAttributesEx <> Value then
    FDefAttributesEx.Assign(Value);
end;

procedure TTeCustomRichEdit.SetDrawAspect(Iconic: Boolean; IconMetaPict: HGlobal);
var
  OleCache                    : IOleCache;
  EnumStatData                : IEnumStatData;
  OldAspect, AdviseFlags, Connection: Longint;
  TempMetaPict                : HGlobal;
  FormatEtc                   : TFormatEtc;
  Medium                      : TStgMedium;
  ClassID                     : TCLSID;
  StatData                    : TStatData;

begin
  OldAspect := FDrawAspect;
  if Iconic then begin
    FDrawAspect := DVASPECT_ICON;
    AdviseFlags := ADVF_NODATA;
  end
  else begin
    FDrawAspect := DVASPECT_CONTENT;
    AdviseFlags := ADVF_PRIMEFIRST;
  end;

  if (FDrawAspect <> OldAspect) or (FDrawAspect = DVASPECT_ICON) then begin
    OleCache := FSelObject as IOleCache;
    if FDrawAspect <> OldAspect then begin
      OleCheck(OleCache.EnumCache(EnumStatData));
      if EnumStatData <> nil then
        while EnumStatData.Next(1, StatData, nil) = 0 do
          if StatData.formatetc.dwAspect = OldAspect then
            OleCache.Uncache(StatData.dwConnection);
      FillChar(FormatEtc, SizeOf(FormatEtc), 0);
      FormatEtc.dwAspect := FDrawAspect;
      FormatEtc.lIndex := -1;
      OleCheck(OleCache.Cache(FormatEtc, AdviseFlags, Connection));
    end;
    if FDrawAspect = DVASPECT_ICON then begin
      TempMetaPict := 0;
      if IconMetaPict = 0 then begin
        OleCheck(FSelObject.GetUserClassID(ClassID));
        TempMetaPict := OleGetIconOfClass(ClassID, nil, True);
        IconMetaPict := TempMetaPict;
      end;
      try
        FormatEtc.cfFormat := CF_METAFILEPICT;
        FormatEtc.ptd := nil;
        FormatEtc.dwAspect := DVASPECT_ICON;
        FormatEtc.lIndex := -1;
        FormatEtc.tymed := TYMED_MFPICT;
        Medium.tymed := TYMED_MFPICT;
        Medium.hMetaFilePict := IconMetaPict;
        Medium.unkForRelease := nil;
        OleCheck(OleCache.Cache(FormatEtc, AdviseFlags, Connection));
        OLECheck(OleCache.SetData(FormatEtc, Medium, False));
      finally
        DestroyMetaPict(TempMetaPict);
      end;
    end;
    if FDrawAspect = DVASPECT_CONTENT then UpdateObject;
    UpdateView;
  end;
end;

procedure TTeCustomRichEdit.SetLines(const Value: TStrings);
begin
  if FLines <> Value then
    FLines.Assign(Value);
end;

procedure TTeCustomRichEdit.SetParagraphEx(const Value: TTeParaAttributes);
begin
  if FParagraphEx <> Value then
    FParagraphEx.Assign(Value);
end;

procedure TTeCustomRichEdit.SetSelAttributesEx(const Value: TTeTextAttributes);
begin
  if FSelAttributesEx <> Value then
    FSelAttributesEx.Assign(Value);
end;

procedure TTeCustomRichEdit.UpdateObject;
begin
  if FSelObject <> nil then begin
    OleCheck(FSelObject.Update);
    Changed;
  end;
end;

procedure TTeCustomRichEdit.UpdateSelObject;
var
  ReObject                    : TReObject;
begin
  if (FRichEditOle.GetObject(Integer(REO_IOB_SELECTION), ReObject, REO_GETOBJ_POLEOBJ) <> S_OK) or not Assigned(ReObject.oleobj) then begin
    FSelObject := nil;
    DestroyVerbs;
  end
  else
    if FSelObject <> ReObject.oleobj then begin
      FSelObject := ReObject.oleobj;
      UpdateVerbs;
    end;
end;

procedure TTeCustomRichEdit.UpdateVerbs;
var
  EnumOleVerb                 : IEnumOleVerb;
  OleVerb                     : TOleVerb;
  VerbInfo                    : TVerbInfo;
begin
  DestroyVerbs;
  FObjectVerbs := TStringList.Create;
  if FSelObject.EnumVerbs(EnumOleVerb) = 0 then begin
    while (EnumOleVerb.Next(1, OleVerb, nil) = 0) and
      (OleVerb.lVerb >= 0) and
      (OleVerb.grfAttribs and OLEVERBATTRIB_ONCONTAINERMENU <> 0) do begin
      VerbInfo.Verb := OleVerb.lVerb;
      VerbInfo.Flags := OleVerb.fuFlags;
      FObjectVerbs.AddObject(OleVerb.lpszVerbName, TObject(VerbInfo));
    end;
  end;
end;

procedure TTeCustomRichEdit.UpdateView;
var
  ViewObject2                 : IViewObject2;
begin
  if Integer(FSelObject.QueryInterface(IViewObject2, ViewObject2)) >= 0 then
    ViewObject2.GetExtent(FDrawAspect, -1, nil, FViewSize);
  Invalidate;
  Changed;
end;

procedure TTeCustomRichEdit.WMDestroy(var Message: TMessage);
begin
  CloseOLEObjects;
  FRichEditOle := nil;
  FTextDocument := nil;
  inherited;
end;

procedure TTeCustomRichEdit.WMLButtonDblClk(var Message: TWMLButtonDblClk);
begin
  if ObjectSelected then begin
    GetPopupMenu;
    DoVerb(ovPrimary);
  end
  else
    inherited;
end;

procedure TTeCustomRichEdit.WMNCDestroy(var Message: TWMNCDestroy);
begin
  inherited;
end;

procedure TTeCustomRichEdit.LoadFromFile(FileName: string; InputFormat: TTeInputFormat; Selection, PlainRTF: boolean);
var
  Stream                      : TStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    LoadFromStream(Stream, InputFormat, Selection, PlainRTF);
  finally
    Stream.Free;
  end;
end;

procedure TTeCustomRichEdit.SaveToFile(FileName: string; OutputFormat: TTeOutputFormat; Selection, PlainRTF: boolean);
var
  Stream                      : TStream;
begin
  Stream := TFileStream.Create(FileName, fmCreate or fmShareDenyWrite);
  try
    SaveToStream(Stream, OutputFormat, Selection, PlainRTF);
  finally
    Stream.Free;
  end;
end;

procedure TTeCustomRichEdit.Loaded;
begin
  inherited;
end;

procedure TTeCustomRichEdit.WMKeyDown(var Message: TWMKeyDown);
begin
  inherited;
end;

procedure TTeCustomRichEdit.WMKeyUp(var Message: TWMKeyUp);
begin
  inherited;
end;

procedure TTeCustomRichEdit.WMSysKeyDown(var Message: TWMKeyDown);
begin
  inherited;
end;

procedure TTeCustomRichEdit.WMSysKeyUp(var Message: TWMKeyUp);
begin
  inherited;
end;

procedure TTeCustomRichEdit.DestroyWnd;
begin
  if not Assigned(FRecreateStream) then
    FRecreateStream := TMemoryStream.Create;
  FRecreateStream.Size := 0;
  SaveToStream(FRecreateStream);
  FRecreateStream.Position := 0;
  inherited;
end;

procedure TTeCustomRichEdit.Import(FileName: string);
var
  Stream                      : TMemoryStream;
begin
  Stream := TMemoryStream.Create;
  try
    ImportToRtf(FileName, Stream);
    Stream.Position := 0;
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TTeCustomRichEdit.CMWantSpecialKey(var Msg: TCMWantSpecialKey);
begin
  inherited;
  if WantReturns then
    if Char(Msg.CharCode) in [#13] then Msg.Result := 1;
end;

{ TTeRichEditOleCallback }

function TTeRichEditOleCallback.ContextSensitiveHelp(fEnterMode: BOOL): HRESULT;
begin
  Result := E_NOTIMPL;
end;

constructor TTeRichEditOleCallback.Create(AOwner: TTeCustomRichEdit);
begin
  inherited Create;
  FOwner := AOwner;
end;

function TTeRichEditOleCallback.DeleteObject(oleobj: IOLEObject): HRESULT;
begin
  FOwner.FSelObject := nil;
  oleobj.Close(OLECLOSE_NOSAVE);
  Result := S_OK;
end;

destructor TTeRichEditOleCallback.Destroy;
begin
  inherited Destroy;
end;

function TTeRichEditOleCallback.GetClipboardData(const chrg: TCharRange; reco: DWORD; out dataobj: IDataObject): HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TTeRichEditOleCallback.GetContextMenu(seltype: Word; oleobj: IOleObject; const chrg: TCharRange; var menu: HMENU): HRESULT;
begin
  Result := S_FALSE;
end;

function TTeRichEditOleCallback.GetDragDropEffect(fDrag: BOOL; grfKeyState: DWORD; var dwEffect: DWORD): HRESULT;
begin
  Result := S_OK;
end;

function TTeRichEditOleCallback.GetInPlaceContext(out Frame: IOleInPlaceFrame; out Doc: IOleInPlaceUIWindow; var FrameInfo: TOleInPlaceFrameInfo): HRESULT;
begin
  Result := S_FALSE;
end;

function TTeRichEditOleCallback.GetNewStorage(out stg: IStorage): HRESULT;
var
  LockBytes                   : ILockBytes;
begin
  Result := S_OK;
  try
    OleCheck(CreateILockBytesOnHGlobal(0, True, LockBytes));
    OleCheck(StgCreateDocfileOnILockBytes(LockBytes, STGM_READWRITE
      or STGM_SHARE_EXCLUSIVE or STGM_CREATE, 0, stg));
  except
    Result := E_OUTOFMEMORY;
  end;
end;

function TTeRichEditOleCallback.QueryAcceptData(dataobj: IDataObject; var cfFormat: TClipFormat; reco: DWORD; fReally: BOOL; hMetaPict: HGLOBAL): HRESULT;
begin
  Result := S_OK;
end;

function TTeRichEditOleCallback.QueryInsertObject(const clsid: TCLSID; stg: IStorage; cp: Integer): HRESULT;
begin
  Result := S_OK;
end;

function TTeRichEditOleCallback.ShowContainerUI(fShow: BOOL): HRESULT;
begin
  Result := E_NOTIMPL;
end;

{ TTeTextAttributes }

procedure TTeTextAttributes.Assign(Source: TPersistent);
begin
  if Source is TTeTextAttributes then begin
    Color := TTeTextAttributes(Source).Color;
    Name := TTeTextAttributes(Source).Name;
    Size := TTeTextAttributes(Source).Size;
    Pitch := TTeTextAttributes(Source).Pitch;
    Weight := TTeTextAttributes(Source).Weight;
    BackColor := TTeTextAttributes(Source).BackColor;
    Language := TTeTextAttributes(Source).Language;
    IndexKind := TTeTextAttributes(Source).IndexKind;
    Offset := TTeTextAttributes(Source).Offset;
    Spacing := TTeTextAttributes(Source).Spacing;
    Kerning := TTeTextAttributes(Source).Kerning;
    UnderlineType := TTeTextAttributes(Source).UnderlineType;
    Bold := TTeTextAttributes(Source).Bold;
    Italic := TTeTextAttributes(Source).Italic;
    Animation := TTeTextAttributes(Source).Animation;
    SmallCaps := TTeTextAttributes(Source).SmallCaps;
    AllCaps := TTeTextAttributes(Source).AllCaps;
    Hidden := TTeTextAttributes(Source).Hidden;
    Outline := TTeTextAttributes(Source).Outline;
    Shadow := TTeTextAttributes(Source).Shadow;
    Emboss := TTeTextAttributes(Source).Emboss;
    Imprint := TTeTextAttributes(Source).Imprint;
    IsURL := TTeTextAttributes(Source).IsURL;
  end
  else
    if Source is TTextAttributes then begin
      Color := TTextAttributes(Source).Color;
      Name := TTextAttributes(Source).Name;
      Size := TTextAttributes(Source).Size;
      Pitch := TTextAttributes(Source).Pitch;
      Bold := fsBold in TTextAttributes(Source).Style;
      Italic := fsItalic in TTextAttributes(Source).Style;
      UnderlineType := TTeUnderlineType(fsUnderline in TTextAttributes(Source).Style);
    end
    else
      if Source is TFont then begin
        Color := TFont(Source).Color;
        Name := TFont(Source).Name;
        Size := TFont(Source).Size;
        Pitch := TFont(Source).Pitch;
        Bold := fsBold in TFont(Source).Style;
        Italic := fsItalic in TFont(Source).Style;
        UnderlineType := TTeUnderlineType(fsUnderline in TFont(Source).Style);
      end
      else
        inherited Assign(Source);
end;

procedure TTeTextAttributes.AssignTo(Dest: TPersistent);
begin
  if Dest is TTeTextAttributes then begin
    TTeTextAttributes(Dest).Color := Color;
    TTeTextAttributes(Dest).Name := Name;
    TTeTextAttributes(Dest).Size := Size;
    TTeTextAttributes(Dest).Pitch := Pitch;
    TTeTextAttributes(Dest).Weight := Weight;
    TTeTextAttributes(Dest).BackColor := BackColor;
    TTeTextAttributes(Dest).Language := Language;
    TTeTextAttributes(Dest).IndexKind := IndexKind;
    TTeTextAttributes(Dest).Offset := Offset;
    TTeTextAttributes(Dest).Spacing := Spacing;
    TTeTextAttributes(Dest).Kerning := Kerning;
    TTeTextAttributes(Dest).UnderlineType := UnderlineType;
    TTeTextAttributes(Dest).Bold := Bold;
    TTeTextAttributes(Dest).Italic := Italic;
    TTeTextAttributes(Dest).Animation := Animation;
    TTeTextAttributes(Dest).SmallCaps := SmallCaps;
    TTeTextAttributes(Dest).AllCaps := AllCaps;
    TTeTextAttributes(Dest).Hidden := Hidden;
    TTeTextAttributes(Dest).Outline := Outline;
    TTeTextAttributes(Dest).Shadow := Shadow;
    TTeTextAttributes(Dest).Emboss := Emboss;
    TTeTextAttributes(Dest).Imprint := Imprint;
    TTeTextAttributes(Dest).IsURL := IsURL;
  end
  else
    if Dest is TTextAttributes then begin
      TTextAttributes(Dest).Color := Color;
      TTextAttributes(Dest).Name := Name;
      if Bold then
        TTextAttributes(Dest).Style := [fsBold]
      else
        TTextAttributes(Dest).Style := [];
      if Italic then
        TTextAttributes(Dest).Style := TTextAttributes(Dest).Style + [fsItalic];
      if UnderlineType <> ultNone then
        TTextAttributes(Dest).Style := TTextAttributes(Dest).Style + [fsUnderline];
      TTextAttributes(Dest).Charset := CharsetFromLocale(Language);
      TTextAttributes(Dest).Size := Size;
      TTextAttributes(Dest).Pitch := Pitch;
    end
    else
      if Dest is TFont then begin
        TFont(Dest).Color := Color;
        TFont(Dest).Name := Name;
        if Bold then
          TFont(Dest).Style := [fsBold]
        else
          TFont(Dest).Style := [];
        if Italic then
          TFont(Dest).Style := TFont(Dest).Style + [fsItalic];
        if UnderlineType <> ultNone then
          TFont(Dest).Style := TFont(Dest).Style + [fsUnderline];
        TFont(Dest).Charset := CharsetFromLocale(Language);
        TFont(Dest).Size := Size;
        TFont(Dest).Pitch := Pitch;
      end
      else
        inherited AssignTo(Dest);
end;

constructor TTeTextAttributes.Create(AOwner: TTeCustomRichEdit; AttributeType: TAttributeType);
begin
  inherited Create;
  RichEdit := AOwner;
  FType := AttributeType;
end;

function TTeTextAttributes.GetAllCaps: Boolean;
var
  Format                      : TCharFormat2;
begin
  GetAttributes(Format);
  Result := Format.dwEffects and CFE_ALLCAPS <> 0;
end;

function TTeTextAttributes.GetAnimation: TTeAnimationType;
var
  Format                      : TCharFormat2;
begin
  GetAttributes(Format);
  Result := TTeAnimationType(Format.bAnimation);
end;

procedure TTeTextAttributes.GetAttributes(var Format: TCharFormat2);
begin
  InitFormat(Format);
  if RichEdit.HandleAllocated then
    RichEdit.Perform(EM_GETCHARFORMAT,
      WPARAM(FType = atSelected), LPARAM(@Format));
end;

function TTeTextAttributes.GetBackColor: TColor;
var
  Format                      : TCharFormat2;
begin
  GetAttributes(Format);
  if ((Format.dwMask and CFM_BACKCOLOR) = 0) or ((Format.dwEffects and CFE_AUTOBACKCOLOR) <> 0) then
    Result := clDefault
  else
    Result := Format.crBackColor;
end;

function TTeTextAttributes.GetBold: Boolean;
var
  Format                      : TCharFormat2;
begin
  GetAttributes(Format);
  Result := Format.dwEffects and CFE_BOLD <> 0;
end;

function TTeTextAttributes.GetColor: TColor;
var
  Format                      : TCharFormat2;
begin
  GetAttributes(Format);
  if ((Format.dwMask and CFM_COLOR) = 0) or ((Format.dwEffects and CFE_AUTOCOLOR) <> 0) then
    Result := clDefault
  else
    Result := Format.crTextColor;
end;

function TTeTextAttributes.GetConsistentAttributes: TTeConsistentAttributes;
var
  Format                      : TCharFormat2;
begin
  Result := [];
  if RichEdit.HandleAllocated and (FType = atSelected) then begin
    InitFormat(Format);
    RichEdit.Perform(EM_GETCHARFORMAT,
      WPARAM(FType = atSelected), LPARAM(@Format));
    with Format do begin
      if (dwMask and CFM_BOLD) <> 0 then Include(Result, caBold);
      if (dwMask and CFM_COLOR) <> 0 then Include(Result, caColor);
      if (dwMask and CFM_FACE) <> 0 then Include(Result, caFace);
      if (dwMask and CFM_ITALIC) <> 0 then Include(Result, caItalic);
      if (dwMask and CFM_SIZE) <> 0 then Include(Result, caSize);
      if (dwMask and CFM_STRIKEOUT) <> 0 then Include(Result, caStrikeOut);
      if (dwMask and CFM_UNDERLINE) <> 0 then Include(Result, caUnderline);
      if (dwMask and CFM_PROTECTED) <> 0 then Include(Result, caProtected);
      if (dwMask and CFM_WEIGHT) <> 0 then Include(Result, caWeight);
      if (dwMask and CFM_BACKCOLOR) <> 0 then Include(Result, caBackColor);
      if (dwMask and CFM_LCID) <> 0 then Include(Result, caLanguage);
      if (dwMask and CFM_SUPERSCRIPT) <> 0 then Include(Result, caIndexKind);
      if (dwMask and CFM_OFFSET) <> 0 then Include(Result, caOffset);
      if (dwMask and CFM_SPACING) <> 0 then Include(Result, caSpacing);
      if (dwMask and CFM_KERNING) <> 0 then Include(Result, caKerning);
      if (dwMask and CFM_UNDERLINETYPE) <> 0 then Include(Result, caULType);
      if (dwMask and CFM_ANIMATION) <> 0 then Include(Result, caAnimation);
      if (dwMask and CFM_SMALLCAPS) <> 0 then Include(Result, caSmallCaps);
      if (dwMask and CFM_ALLCAPS) <> 0 then Include(Result, caAllCaps);
      if (dwMask and CFM_HIDDEN) <> 0 then Include(Result, caHidden);
      if (dwMask and CFM_OUTLINE) <> 0 then Include(Result, caOutline);
      if (dwMask and CFM_SHADOW) <> 0 then Include(Result, caShadow);
      if (dwMask and CFM_EMBOSS) <> 0 then Include(Result, caEmboss);
      if (dwMask and CFM_IMPRINT) <> 0 then Include(Result, caImprint);
      if (dwMask and CFM_LINK) <> 0 then Include(result, caURL);
    end;
  end;
end;

function TTeTextAttributes.GetEmboss: Boolean;
var
  Format                      : TCharFormat2;
begin
  GetAttributes(Format);
  Result := Format.dwEffects and CFE_EMBOSS <> 0;
end;

function TTeTextAttributes.GetHeight: Integer;
begin
  Result := MulDiv(Size, RichEdit.FScreenLogPixels, 72);
end;

function TTeTextAttributes.GetHidden: Boolean;
var
  Format                      : TCharFormat2;
begin
  GetAttributes(Format);
  Result := Format.dwEffects and CFE_HIDDEN <> 0;
end;

function TTeTextAttributes.GetImprint: Boolean;
var
  Format                      : TCharFormat2;
begin
  GetAttributes(Format);
  Result := Format.dwEffects and CFE_IMPRINT <> 0;
end;

function TTeTextAttributes.GetIndexKind: TTeIndexKind;
var
  Format                      : TCharFormat2;
begin
  GetAttributes(Format);
  case (Format.dwEffects and CFM_SUPERSCRIPT) shr 16 of
    1: Result := ikSubscript;
    2: Result := ikSuperscript;
  else
    Result := ikNone;
  end;
end;

function TTeTextAttributes.GetIsURL: Boolean;
var
  Format                      : TCharFormat2;
begin
  GetAttributes(Format);
  Result := Format.dwEffects and CFE_LINK <> 0;
end;

function TTeTextAttributes.GetItalic: Boolean;
var
  Format                      : TCharFormat2;
begin
  GetAttributes(Format);
  Result := Format.dwEffects and CFE_ITALIC <> 0;
end;

function TTeTextAttributes.GetKerning: Double;
var
  Format                      : TCharFormat2;
begin
  GetAttributes(Format);
  Result := Format.wKerning / 20;
end;

function TTeTextAttributes.GetLanguage: TLanguage;
var
  Format                      : TCharFormat2;
begin
  GetAttributes(Format);
  Result := Format.lid;
end;

function TTeTextAttributes.GetName: TFontName;
var
  Format                      : TCharFormat2;
begin
  GetAttributes(Format);
  Result := Format.szFaceName;
end;

function TTeTextAttributes.GetOffset: Double;
var
  Format                      : TCharFormat2;
begin
  GetAttributes(Format);
  Result := Format.yOffset / 20;
end;

function TTeTextAttributes.GetOutline: Boolean;
var
  Format                      : TCharFormat2;
begin
  GetAttributes(Format);
  Result := Format.dwEffects and CFE_OUTLINE <> 0;
end;

function TTeTextAttributes.GetPitch: TFontPitch;
var
  Format                      : TCharFormat2;
begin
  GetAttributes(Format);
  case (Format.bPitchAndFamily and $03) of
    VARIABLE_PITCH: Result := fpVariable;
    FIXED_PITCH: Result := fpFixed;
  else
    Result := fpDefault;
  end;
end;

function TTeTextAttributes.GetProtected: Boolean;
var
  Format                      : TCharFormat2;
begin
  GetAttributes(Format);
  with Format do
    Result := (dwEffects and CFE_PROTECTED) <> 0;
end;

function TTeTextAttributes.GetShadow: Boolean;
var
  Format                      : TCharFormat2;
begin
  GetAttributes(Format);
  Result := Format.dwEffects and CFE_SHADOW <> 0;
end;

function TTeTextAttributes.GetSize: Integer;
var
  Format                      : TCharFormat2;
begin
  GetAttributes(Format);
  Result := Format.yHeight div 20;
end;

function TTeTextAttributes.GetSmallCaps: Boolean;
var
  Format                      : TCharFormat2;
begin
  GetAttributes(Format);
  Result := Format.dwEffects and CFE_SMALLCAPS <> 0;
end;

function TTeTextAttributes.GetSpacing: Double;
var
  Format                      : TCharFormat2;
begin
  GetAttributes(Format);
  Result := Format.sSpacing / 20;
end;

function TTeTextAttributes.GetStrikeOut: Boolean;
var
  Format                      : TCharFormat2;
begin
  GetAttributes(Format);
  Result := Format.dwEffects and CFE_STRIKEOUT <> 0;
end;

function TTeTextAttributes.GetStyle: TFontStyles;
var
  Format                      : TCharFormat2;
begin
  Result := [];
  GetAttributes(Format);
  with Format do begin
    if (dwEffects and CFE_BOLD) <> 0 then Include(Result, fsBold);
    if (dwEffects and CFE_ITALIC) <> 0 then Include(Result, fsItalic);
    if (bUnderlineType > 0) then Include(Result, fsUnderline);
    if (dwEffects and CFE_STRIKEOUT) <> 0 then Include(Result, fsStrikeOut);
  end;
end;

function TTeTextAttributes.GetUnderline: Boolean;
begin
  Result := UnderlineType in [ultSingle, ultWord, ultDouble];
end;

function TTeTextAttributes.GetUnderlineType: TTeUnderlineType;
var
  Format                      : TCharFormat2;
  ult                         : integer;
begin
  if FType = atDefaultText then begin
    GetAttributes(Format);
    if (Format.dwMask and CFM_UNDERLINETYPE) <> 0 then
      Result := TTeUnderlineType(Format.bUnderlineType)
    else
      Result := TTeUnderlineType(0);
  end
  else begin
    if Assigned(RichEdit.TextDocument) and
      Assigned(RichEdit.TextDocument.Selection) and
      Assigned(RichEdit.TextDocument.Selection.Font) then
      ult := RichEdit.TextDocument.Selection.Font.Underline
    else
      ult := 0;
    if (ult >= Ord(Low(TTeUnderlineType))) and (ult <= Ord(High(TTeUnderlineType))) then
      Result := TTeUnderlineType(ult)
    else
      Result := ultNone;
  end;
end;

function TTeTextAttributes.GetWeight: Word;
var
  Format                      : TCharFormat2;
begin
  GetAttributes(Format);
  Result := Format.wWeight;
end;

procedure TTeTextAttributes.InitFormat(var Format: TCharFormat2);
begin
  FillChar(Format, SizeOf(TCharFormat2), 0);
  Format.cbSize := SizeOf(TCharFormat2);
end;

procedure TTeTextAttributes.SetAllCaps(Value: Boolean);
var
  Format                      : TCharFormat2;
begin
  InitFormat(Format);
  with Format do begin
    dwMask := CFM_ALLCAPS;
    if Value then dwEffects := CFE_ALLCAPS;
  end;
  SetAttributes(Format);
end;

procedure TTeTextAttributes.SetAnimation(Value: TTeAnimationType);
var
  Format                      : TCharFormat2;
begin
  InitFormat(Format);
  with Format do begin
    dwMask := CFM_ANIMATION;
    bAnimation := Byte(Value);
  end;
  SetAttributes(Format);
end;

procedure TTeTextAttributes.SetAttributes(var Format: TCharFormat2);
var
  Flag                        : Longint;
begin
  if FType = atSelected then begin
    Flag := SCF_SELECTION or SCF_USEUIRULES;
    if (RichEdit.SelLength = 0) and RichEdit.WordFormatting then
      Flag := Flag or SCF_WORD;
  end
  else
    Flag := SCF_DEFAULT;
  if RichEdit.HandleAllocated then
    RichEdit.Perform(EM_SETCHARFORMAT, Flag, LPARAM(@Format))
end;

procedure TTeTextAttributes.SetBackColor(Value: TColor);
var
  Format                      : TCharFormat2;
begin
  InitFormat(Format);
  with Format do begin
    dwMask := CFM_BACKCOLOR;
    if (Value = clWindow) or (Value = clDefault) then
      dwEffects := CFE_AUTOBACKCOLOR
    else
      crBackColor := ColorToRGB(Value);
  end;
  SetAttributes(Format);
end;

procedure TTeTextAttributes.SetBold(Value: Boolean);
var
  Format                      : TCharFormat2;
begin
  InitFormat(Format);
  with Format do begin
    dwMask := CFM_BOLD;
    if Value then dwEffects := CFE_BOLD;
  end;
  SetAttributes(Format);
end;

procedure TTeTextAttributes.SetColor(Value: TColor);
var
  Format                      : TCharFormat2;
begin
  InitFormat(Format);
  with Format do begin
    dwMask := CFM_COLOR;
    if (Value = clWindowText) or (Value = clDefault) then
      dwEffects := CFE_AUTOCOLOR
    else
      crTextColor := ColorToRGB(Value);
  end;
  SetAttributes(Format);
end;

procedure TTeTextAttributes.SetEmboss(Value: Boolean);
var
  Format                      : TCharFormat2;
begin
  InitFormat(Format);
  with Format do begin
    dwMask := CFM_EMBOSS;
    if Value then dwEffects := CFE_EMBOSS;
  end;
  SetAttributes(Format);
end;

procedure TTeTextAttributes.SetHeight(Value: Integer);
begin
  Size := MulDiv(Value, 72, RichEdit.FScreenLogPixels);
end;

procedure TTeTextAttributes.SetHidden(Value: Boolean);
var
  Format                      : TCharFormat2;
begin
  InitFormat(Format);
  with Format do begin
    dwMask := CFM_HIDDEN;
    if Value then dwEffects := CFE_HIDDEN;
  end;
  SetAttributes(Format);
end;

procedure TTeTextAttributes.SetImprint(Value: Boolean);
var
  Format                      : TCharFormat2;
begin
  InitFormat(Format);
  with Format do begin
    dwMask := CFM_IMPRINT;
    if Value then dwEffects := CFE_IMPRINT;
  end;
  SetAttributes(Format);
end;

procedure TTeTextAttributes.SetIndexKind(Value: TTeIndexKind);
var
  Format                      : TCharFormat2;
begin
  InitFormat(Format);
  with Format do begin
    dwMask := CFM_SUPERSCRIPT;
    dwEffects := Ord(Value) shl 16;
  end;
  SetAttributes(Format);
end;

procedure TTeTextAttributes.SetIsURL(Value: Boolean);
var
  Format                      : TCharFormat2;
begin
  InitFormat(Format);
  with Format do begin
    dwMask := CFM_LINK;
    if Value then dwEffects := CFE_LINK;
  end;
  SetAttributes(Format);
end;

procedure TTeTextAttributes.SetItalic(Value: Boolean);
var
  Format                      : TCharFormat2;
begin
  InitFormat(Format);
  with Format do begin
    dwMask := CFM_ITALIC;
    if Value then dwEffects := CFE_ITALIC;
  end;
  SetAttributes(Format);
end;

procedure TTeTextAttributes.SetKerning(Value: Double);
var
  Format                      : TCharFormat2;
begin
  InitFormat(Format);
  with Format do begin
    dwMask := CFM_KERNING;
    wKerning := Round(Value * 20);
  end;
  SetAttributes(Format);
end;

procedure TTeTextAttributes.SetLanguage(Value: TLanguage);
var
  Format                      : TCharFormat2;
begin
  InitFormat(Format);
  with Format do begin
    dwMask := CFM_LCID;
    lid := Value;
  end;
  SetAttributes(Format);
end;

procedure TTeTextAttributes.SetName(Value: TFontName);
var
  Format                      : TCharFormat2;
begin
  InitFormat(Format);
  with Format do begin
    dwMask := CFM_FACE;
    StrPLCopy(szFaceName, Value, SizeOf(szFaceName));
  end;
  SetAttributes(Format);
end;

procedure TTeTextAttributes.SetOffset(Value: Double);
var
  Format                      : TCharFormat2;
begin
  InitFormat(Format);
  with Format do begin
    dwMask := CFM_OFFSET;
    yOffset := Round(Value * 20);
  end;
  SetAttributes(Format);
end;

procedure TTeTextAttributes.SetOutline(Value: Boolean);
var
  Format                      : TCharFormat2;
begin
  InitFormat(Format);
  with Format do begin
    dwMask := CFM_OUTLINE;
    if Value then dwEffects := CFE_OUTLINE;
  end;
  SetAttributes(Format);
end;

procedure TTeTextAttributes.SetPitch(Value: TFontPitch);
var
  Format                      : TCharFormat2;
begin
  InitFormat(Format);
  with Format do begin
    case Value of
      fpVariable: Format.bPitchAndFamily := VARIABLE_PITCH;
      fpFixed: Format.bPitchAndFamily := FIXED_PITCH;
    else
      Format.bPitchAndFamily := DEFAULT_PITCH;
    end;
  end;
  SetAttributes(Format);
end;

procedure TTeTextAttributes.SetProtected(Value: Boolean);
var
  Format                      : TCharFormat2;
begin
  InitFormat(Format);
  with Format do begin
    dwMask := CFM_PROTECTED;
    if Value then dwEffects := CFE_PROTECTED;
  end;
  SetAttributes(Format);
end;

procedure TTeTextAttributes.SetShadow(Value: Boolean);
var
  Format                      : TCharFormat2;
begin
  InitFormat(Format);
  with Format do begin
    dwMask := CFM_SHADOW;
    if Value then dwEffects := CFE_SHADOW;
  end;
  SetAttributes(Format);
end;

procedure TTeTextAttributes.SetSize(Value: Integer);
var
  Format                      : TCharFormat2;
begin
  InitFormat(Format);
  with Format do begin
    dwMask := CFM_SIZE;
    yHeight := Value * 20;
  end;
  SetAttributes(Format);
end;

procedure TTeTextAttributes.SetSmallCaps(Value: Boolean);
var
  Format                      : TCharFormat2;
begin
  InitFormat(Format);
  with Format do begin
    dwMask := CFM_SMALLCAPS;
    if Value then dwEffects := CFE_SMALLCAPS;
  end;
  SetAttributes(Format);
end;

procedure TTeTextAttributes.SetSpacing(Value: Double);
var
  Format                      : TCharFormat2;
begin
  InitFormat(Format);
  with Format do begin
    dwMask := CFM_SPACING;
    sSpacing := Round(Value * 20);
  end;
  SetAttributes(Format);
end;

procedure TTeTextAttributes.SetStrikeOut(Value: Boolean);
var
  Format                      : TCharFormat2;
begin
  InitFormat(Format);
  with Format do begin
    dwMask := CFM_STRIKEOUT;
    if Value then dwEffects := CFE_STRIKEOUT;
  end;
  SetAttributes(Format);
end;

procedure TTeTextAttributes.SetStyle(Value: TFontStyles);
var
  Format                      : TCharFormat2;
begin
  InitFormat(Format);
  with Format do begin
    dwMask := CFM_BOLD or CFM_ITALIC or CFM_STRIKEOUT;
    if fsBold in Value then dwEffects := dwEffects or CFE_BOLD;
    if fsItalic in Value then dwEffects := dwEffects or CFE_ITALIC;
    if fsStrikeOut in Value then dwEffects := dwEffects or CFE_STRIKEOUT;
    if fsUnderline in Value then begin
      dwMask := dwMask or CFM_UNDERLINETYPE;
      bUnderlineType := 1;
    end;
  end;
  SetAttributes(Format);
end;

procedure TTeTextAttributes.SetUnderline(Value: Boolean);
begin
  UnderlineType := TTeUnderlineType(Value);
end;

procedure TTeTextAttributes.SetUnderlineType(Value: TTeUnderlineType);
var
  Format                      : TCharFormat2;
begin
  InitFormat(Format);
  with Format do begin
    dwMask := CFM_UNDERLINETYPE;
    bUnderlineType := Byte(Value);
  end;
  SetAttributes(Format);
end;

procedure TTeTextAttributes.SetWeight(Value: Word);
var
  Format                      : TCharFormat2;
begin
  InitFormat(Format);
  with Format do begin
    dwMask := CFM_Weight;
    wWeight := Value;
  end;
  SetAttributes(Format);
end;

{ TTeParaAttributes}

constructor TTeParaAttributes.Create(AOwner: TTeCustomRichEdit);
begin
  inherited Create;
  RichEdit := AOwner;
end;

procedure TTeParaAttributes.InitPara(var Paragraph: TParaFormat2);
begin
  FillChar(Paragraph, SizeOf(TParaFormat2), 0);
  Paragraph.cbSize := SizeOf(TParaFormat2);
end;

procedure TTeParaAttributes.GetAttributes(var Paragraph: TParaFormat2);
begin
  InitPara(Paragraph);
  if RichEdit.HandleAllocated then
    RichEdit.Perform(EM_GETPARAFORMAT, 0, LPARAM(@Paragraph));
end;

procedure TTeParaAttributes.SetAttributes(var Paragraph: TParaFormat2);
begin
  if RichEdit.HandleAllocated then
    RichEdit.Perform(EM_SETPARAFORMAT, 0, LPARAM(@Paragraph))
end;

function TTeParaAttributes.GetFirstIndent: Double;
var
  Paragraph                   : TParaFormat2;
begin
  GetAttributes(Paragraph);
  Result := Paragraph.dxStartIndent / 20;
end;

procedure TTeParaAttributes.SetFirstIndent(Value: Double);
var
  Paragraph                   : TParaFormat2;
begin
  InitPara(Paragraph);
  with Paragraph do begin
    dwMask := PFM_STARTINDENT;
    dxStartIndent := Round(Value * 20);
  end;
  SetAttributes(Paragraph);
end;

function TTeParaAttributes.GetLeftIndent: Double;
var
  Paragraph                   : TParaFormat2;
begin
  GetAttributes(Paragraph);
  Result := Paragraph.dxOffset / 20;
end;

procedure TTeParaAttributes.SetLeftIndent(Value: Double);
var
  Paragraph                   : TParaFormat2;
begin
  InitPara(Paragraph);
  with Paragraph do begin
    dwMask := PFM_OFFSET;
    dxOffset := Round(Value * 20);
  end;
  SetAttributes(Paragraph);
end;

function TTeParaAttributes.GetRightIndent: Double;
var
  Paragraph                   : TParaFormat2;
begin
  GetAttributes(Paragraph);
  Result := Paragraph.dxRightIndent / 20;
end;

procedure TTeParaAttributes.SetRightIndent(Value: Double);
var
  Paragraph                   : TParaFormat2;
begin
  InitPara(Paragraph);
  with Paragraph do begin
    dwMask := PFM_RIGHTINDENT;
    dxRightIndent := Round(Value * 20);
  end;
  SetAttributes(Paragraph);
end;

function TTeParaAttributes.GetSpaceBefore: Double;
var
  Paragraph                   : TParaFormat2;
begin
  GetAttributes(Paragraph);
  Result := Paragraph.dySpaceBefore / 20;
end;

procedure TTeParaAttributes.SetSpaceBefore(Value: Double);
var
  Paragraph                   : TParaFormat2;
begin
  InitPara(Paragraph);
  with Paragraph do begin
    dwMask := PFM_SPACEBEFORE;
    dySpaceBefore := Round(Value * 20);
  end;
  SetAttributes(Paragraph);
end;

function TTeParaAttributes.GetSpaceAfter: Double;
var
  Paragraph                   : TParaFormat2;
begin
  GetAttributes(Paragraph);
  Result := Paragraph.dySpaceAfter / 20;
end;

procedure TTeParaAttributes.SetSpaceAfter(Value: Double);
var
  Paragraph                   : TParaFormat2;
begin
  InitPara(Paragraph);
  with Paragraph do begin
    dwMask := PFM_SPACEAFTER;
    dySpaceAfter := Round(Value * 20);
  end;
  SetAttributes(Paragraph);
end;

function TTeParaAttributes.GetLineSpacing: Double;
var
  Paragraph                   : TParaFormat2;
begin
  GetAttributes(Paragraph);
  Result := Paragraph.dyLineSpacing / 20;
end;

function TTeParaAttributes.GetLineSpacingRule: TTeLineSpacingRule;
var
  Paragraph                   : TParaFormat2;
begin
  GetAttributes(Paragraph);
  Result := TTeLineSpacingRule(Paragraph.bLineSpacingRule);
end;

procedure TTeParaAttributes.SetLineSpacing(Rule: TTeLineSpacingRule; Value: Double);
var
  Paragraph                   : TParaFormat2;
begin
  InitPara(Paragraph);
  with Paragraph do begin
    dwMask := PFM_LINESPACING;
    bLineSpacingRule := Ord(Rule);
    dyLineSpacing := Round(Value * 20);
  end;
  SetAttributes(Paragraph);
end;

function TTeParaAttributes.GetKeepTogether: Boolean;
var
  Paragraph                   : TParaFormat2;
begin
  GetAttributes(Paragraph);
  Result := Paragraph.wReserved and PFE_KEEP <> 0;
end;

procedure TTeParaAttributes.SetKeepTogether(Value: Boolean);
var
  Paragraph                   : TParaFormat2;
begin
  InitPara(Paragraph);
  with Paragraph do begin
    dwMask := PFM_KEEP;
    if Value then wReserved := PFE_KEEP;
  end;
  SetAttributes(Paragraph);
end;

function TTeParaAttributes.GetKeepWithNext: Boolean;
var
  Paragraph                   : TParaFormat2;
begin
  GetAttributes(Paragraph);
  Result := Paragraph.wReserved and PFE_KEEPNEXT <> 0;
end;

procedure TTeParaAttributes.SetKeepWithNext(Value: Boolean);
var
  Paragraph                   : TParaFormat2;
begin
  InitPara(Paragraph);
  with Paragraph do begin
    dwMask := PFM_KEEPNEXT;
    if Value then wReserved := PFE_KEEPNEXT;
  end;
  SetAttributes(Paragraph);
end;

function TTeParaAttributes.GetPageBreakBefore: Boolean;
var
  Paragraph                   : TParaFormat2;
begin
  GetAttributes(Paragraph);
  Result := Paragraph.wReserved and PFE_PAGEBREAKBEFORE <> 0;
end;

procedure TTeParaAttributes.SetPageBreakBefore(Value: Boolean);
var
  Paragraph                   : TParaFormat2;
begin
  InitPara(Paragraph);
  with Paragraph do begin
    dwMask := PFM_PAGEBREAKBEFORE;
    if Value then wReserved := PFE_PAGEBREAKBEFORE;
  end;
  SetAttributes(Paragraph);
end;

function TTeParaAttributes.GetNoLineNumber: Boolean;
var
  Paragraph                   : TParaFormat2;
begin
  GetAttributes(Paragraph);
  Result := Paragraph.wReserved and PFE_NOLINENUMBER <> 0;
end;

procedure TTeParaAttributes.SetNoLineNumber(Value: Boolean);
var
  Paragraph                   : TParaFormat2;
begin
  InitPara(Paragraph);
  with Paragraph do begin
    dwMask := PFM_NOLINENUMBER;
    if Value then wReserved := PFE_NOLINENUMBER;
  end;
  SetAttributes(Paragraph);
end;

function TTeParaAttributes.GetNoWidowControl: Boolean;
var
  Paragraph                   : TParaFormat2;
begin
  GetAttributes(Paragraph);
  Result := Paragraph.wReserved and PFE_NOWIDOWCONTROL <> 0;
end;

procedure TTeParaAttributes.SetNoWidowControl(Value: Boolean);
var
  Paragraph                   : TParaFormat2;
begin
  InitPara(Paragraph);
  with Paragraph do begin
    dwMask := PFM_NOWIDOWCONTROL;
    if Value then wReserved := PFE_NOWIDOWCONTROL;
  end;
  SetAttributes(Paragraph);
end;

function TTeParaAttributes.GetDoNotHyphen: Boolean;
var
  Paragraph                   : TParaFormat2;
begin
  GetAttributes(Paragraph);
  Result := Paragraph.wReserved and PFE_DONOTHYPHEN <> 0;
end;

procedure TTeParaAttributes.SetDoNotHyphen(Value: Boolean);
var
  Paragraph                   : TParaFormat2;
begin
  InitPara(Paragraph);
  with Paragraph do begin
    dwMask := PFM_DONOTHYPHEN;
    if Value then wReserved := PFE_DONOTHYPHEN;
  end;
  SetAttributes(Paragraph);
end;

function TTeParaAttributes.GetSideBySide: Boolean;
var
  Paragraph                   : TParaFormat2;
begin
  GetAttributes(Paragraph);
  Result := Paragraph.wReserved and PFE_SIDEBYSIDE <> 0;
end;

procedure TTeParaAttributes.SetSideBySide(Value: Boolean);
var
  Paragraph                   : TParaFormat2;
begin
  InitPara(Paragraph);
  with Paragraph do begin
    dwMask := PFM_SIDEBYSIDE;
    if Value then wReserved := PFE_SIDEBYSIDE;
  end;
  SetAttributes(Paragraph);
end;

function TTeParaAttributes.GetAlignment: TTeAlignment;
var
  Paragraph                   : TParaFormat2;
begin
  GetAttributes(Paragraph);
  Result := TTeAlignment(Paragraph.wAlignment - 1);
end;

procedure TTeParaAttributes.SetAlignment(Value: TTeAlignment);
var
  Paragraph                   : TParaFormat2;
begin
  InitPara(Paragraph);
  with Paragraph do begin
    dwMask := PFM_ALIGNMENT;
    wAlignment := Ord(Value) + 1;
  end;
  SetAttributes(Paragraph);
end;

function TTeParaAttributes.GetNumbering: TTeNumberingStyle;
var
  Paragraph                   : TParaFormat2;
begin
  GetAttributes(Paragraph);
  Result := TTeNumberingStyle(Paragraph.wNumbering);
end;

procedure TTeParaAttributes.SetNumbering(Value: TTeNumberingStyle);
var
  Paragraph                   : TParaFormat2;
begin
  InitPara(Paragraph);
  with Paragraph do begin
    dwMask := PFM_NUMBERING;
    wNumbering := Word(Value);
  end;
  SetAttributes(Paragraph);
end;

function TTeParaAttributes.GetNumberingStart: Word;
var
  Paragraph                   : TParaFormat2;
begin
  GetAttributes(Paragraph);
  Result := Paragraph.wNumberingStart;
end;

procedure TTeParaAttributes.SetNumberingStart(Value: Word);
var
  Paragraph                   : TParaFormat2;
begin
  InitPara(Paragraph);
  with Paragraph do begin
    dwMask := PFM_NUMBERINGSTART;
    wNumberingStart := Value;
  end;
  SetAttributes(Paragraph);
end;

function TTeParaAttributes.GetNumberingFollow: TTeNumberingFollow;
var
  Paragraph                   : TParaFormat2;
begin
  GetAttributes(Paragraph);
  Result := TTeNumberingFollow(Paragraph.wNumberingStyle);
end;

procedure TTeParaAttributes.SetNumberingFollow(Value: TTeNumberingFollow);
var
  Paragraph                   : TParaFormat2;
begin
  InitPara(Paragraph);
  with Paragraph do begin
    dwMask := PFM_NUMBERINGSTYLE;
    wNumberingStyle := Word(Value);
  end;
  SetAttributes(Paragraph);
end;

function TTeParaAttributes.GetNumberingTab: Double;
var
  Paragraph                   : TParaFormat2;
begin
  GetAttributes(Paragraph);
  Result := Paragraph.wNumberingTab / 20;
end;

procedure TTeParaAttributes.SetNumberingTab(Value: Double);
var
  Paragraph                   : TParaFormat2;
begin
  InitPara(Paragraph);
  with Paragraph do begin
    dwMask := PFM_NUMBERINGTAB;
    wNumberingTab := Round(Value * 20);
  end;
  SetAttributes(Paragraph);
end;

function TTeParaAttributes.GetBorderSpace: Double;
var
  Paragraph                   : TParaFormat2;
begin
  GetAttributes(Paragraph);
  Result := Paragraph.wBorderSpace / 20;
end;

function TTeParaAttributes.GetBorderWidth: Double;
var
  Paragraph                   : TParaFormat2;
begin
  GetAttributes(Paragraph);
  Result := Paragraph.wBorderWidth / 20;
end;

function TTeParaAttributes.GetBorderLocations: TTeBorderLocations;
var
  Paragraph                   : TParaFormat2;
begin
  GetAttributes(Paragraph);
  Byte(Result) := Lo(Paragraph.wBorders);
end;

function TTeParaAttributes.GetBorderStyle: TTeBorderStyle;
var
  Paragraph                   : TParaFormat2;
begin
  GetAttributes(Paragraph);
  Byte(Result) := Hi(Paragraph.wBorders) and 15;
end;

const
  IndexedColors               : array[0..15] of TColor =
    (clBlack, clBlue, clAqua, clLime, clFuchsia, clRed, clYellow, clWhite,
    clNavy, clTeal, clGreen, clPurple, clMaroon, clOlive, clDkGray, clLtGray);

function FindClosestColor(Color: TColor): Byte;
var
  I, N, NMin                  : Byte;
begin
  Result := 0;
  NMin := 255;
  for I := 0 to 15 do begin
    N := Abs(TPaletteEntry(Color).peBlue - TPaletteEntry(IndexedColors[I]).peBlue) +
      Abs(TPaletteEntry(Color).peGreen - TPaletteEntry(IndexedColors[I]).peGreen) +
      Abs(TPaletteEntry(Color).peRed - TPaletteEntry(IndexedColors[I]).peRed);
    if N < NMin then begin
      NMin := N;
      Result := I;
      if N = 0 then
        Exit;
    end;
  end;
end;

function TTeParaAttributes.GetBorderColor: TColor;
var
  Paragraph                   : TParaFormat2;
begin
  GetAttributes(Paragraph);
  Result := IndexedColors[Hi(Paragraph.wBorders) shr 4];
end;

procedure TTeParaAttributes.SetBorder(Space, Width: Double; Locations: TTeBorderLocations; Style: TTeBorderStyle; Color: TColor);
var
  Paragraph                   : TParaFormat2;
begin
  InitPara(Paragraph);
  with Paragraph do begin
    dwMask := PFM_BORDER;
    wBorderSpace := Round(Space * 20);
    wBorderWidth := Round(Width * 20);
    wBorders := FindClosestColor(Color) shl 12 or Byte(Style) shl 8 or Byte(Locations);
  end;
  SetAttributes(Paragraph);
end;

function TTeParaAttributes.GetShadingWeight: TTeShadingWeight;
var
  Paragraph                   : TParaFormat2;
begin
  GetAttributes(Paragraph);
  Result := TTeShadingWeight(Paragraph.wShadingWeight);
end;

function TTeParaAttributes.GetShadingStyle: TTeShadingStyle;
var
  Paragraph                   : TParaFormat2;
begin
  GetAttributes(Paragraph);
  Result := TTeShadingStyle(Paragraph.wShadingStyle and 15);
end;

function TTeParaAttributes.GetShadingColor: TColor;
var
  Paragraph                   : TParaFormat2;
begin
  GetAttributes(Paragraph);
  Result := IndexedColors[(Paragraph.wShadingStyle shr 4) and 15];
end;

function TTeParaAttributes.GetShadingBackColor: TColor;
var
  Paragraph                   : TParaFormat2;
begin
  GetAttributes(Paragraph);
  Result := IndexedColors[(Paragraph.wShadingStyle shr 8) and 15];
end;

procedure TTeParaAttributes.SetShading(Weight: TTeShadingWeight; Style: TTeShadingStyle;
  Color, BackColor: TColor);
var
  Paragraph                   : TParaFormat2;
begin
  InitPara(Paragraph);
  with Paragraph do begin
    dwMask := PFM_SHADING;
    wShadingWeight := Weight;
    wShadingStyle := FindClosestColor(BackColor) shl 8 or
      FindClosestColor(Color) shl 4 or Byte(Style);
  end;
  SetAttributes(Paragraph);
end;

function TTeParaAttributes.GetTabCount: Integer;
var
  Paragraph                   : TParaFormat2;
begin
  GetAttributes(Paragraph);
  Result := Paragraph.cTabCount;
end;

function TTeParaAttributes.GetTab(Index: Integer): Double;
var
  Paragraph                   : TParaFormat2;
begin
  GetAttributes(Paragraph);
  Result := (Paragraph.rgxTabs[Index] and $FFFFFF) / 20;
end;

function TTeParaAttributes.GetTabAlignment(Index: Integer): TTeTabAlignment;
var
  Paragraph                   : TParaFormat2;
begin
  GetAttributes(Paragraph);
  Result := TTeTabAlignment(Paragraph.rgxTabs[Index] shr 24 and 15);
end;

function TTeParaAttributes.GetTabLeader(Index: Integer): TTeTabLeader;
var
  Paragraph                   : TParaFormat2;
begin
  GetAttributes(Paragraph);
  Result := TTeTabLeader(Paragraph.rgxTabs[Index] shr 28);
end;

procedure TTeParaAttributes.SetTab(Index: Integer; Value: Double; Alignment: TTeTabAlignment; Leader: TTeTabLeader);
var
  Paragraph                   : TParaFormat2;
begin
  GetAttributes(Paragraph);
  with Paragraph do begin
    rgxTabs[Index] := Round(Value * 20) or (Byte(Alignment) shl 24) or
      (Byte(Leader) shl 28);
    dwMask := PFM_TABSTOPS;
    if cTabCount < Index then cTabCount := Index;
    SetAttributes(Paragraph);
  end;
end;

function TTeParaAttributes.GetBullet: Boolean;
begin
  Result := Numbering <> nsNone;
end;

procedure TTeParaAttributes.SetBullet(Value: Boolean);
begin
  Numbering := TTeNumberingStyle(Value);
end;

function AdjustLineBreaks(Dest, Source: PChar): Integer; assembler;
asm
        PUSH    ESI
        PUSH    EDI
        MOV     EDI,EAX
        MOV     ESI,EDX
        MOV     EDX,EAX
        CLD
@@1:    LODSB
@@2:    OR      AL,AL
        JE      @@4
        CMP     AL,0AH
        JE      @@3
        STOSB
        CMP     AL,0DH
        JNE     @@1
        MOV     AL,0AH
        STOSB
        LODSB
        CMP     AL,0AH
        JE      @@1
        JMP     @@2
@@3:    MOV     EAX,0A0DH
        STOSW
        JMP     @@1
@@4:    STOSB
        LEA     EAX,[EDI-1]
        SUB     EAX,EDX
        POP     EDI
        POP     ESI
end;

function StreamSave(dwCookie: Longint; pbBuff: PByte; cb: Longint; var pcb: Longint): Longint; stdcall;
var
  StreamInfo                  : PRichEditStreamInfo;
begin
  Result := NoError;
  StreamInfo := PRichEditStreamInfo(Pointer(dwCookie));
  try
    pcb := 0;
    if StreamInfo^.Converter <> nil then
      pcb := StreamInfo^.Converter.ConvertWriteStream(StreamInfo^.Stream, PChar(pbBuff), cb);
  except
    Result := WriteError;
  end;
end;

function StreamLoad(dwCookie: Longint; pbBuff: PByte; cb: Longint; var pcb: Longint): Longint; stdcall;
var
  BuTer, pBuff                : PChar;
  StreamInfo                  : PRichEditStreamInfo;
begin
  Result := NoError;
  StreamInfo := PRichEditStreamInfo(Pointer(dwCookie));
  BuTer := StrAlloc(cb + 1);
  try
    cb := cb div 2;
    pcb := 0;
    pBuff := BuTer + cb;
    try
      if StreamInfo^.Converter <> nil then
        pcb := StreamInfo^.Converter.ConvertReadStream(StreamInfo^.Stream, pBuff, cb);
      if pcb > 0 then begin
        pBuff[pcb] := #0;
        if pBuff[pcb - 1] = #13 then pBuff[pcb - 1] := #0;
        pcb := AdjustLineBreaks(BuTer, pBuff);
        Move(BuTer^, pbBuff^, pcb);
      end;
    except
      Result := ReadError;
    end;
  finally
    StrDispose(BuTer);
  end;
end;

procedure TTeCustomRichEdit.LoadFromStream(Stream: TStream; InputFormat: TTeInputFormat; Selection, PlainRTF: boolean);
var
  EditStream                  : TEditStream;
  Position                    : Longint;
  TextType                    : Longint;
  StreamInfo                  : TRichEditStreamInfo;
  Converter                   : TConversion;
begin
  HandleNeeded;
  StreamInfo.Stream := Stream;
  Converter := DefaultConverter.Create;

  StreamInfo.Converter := Converter;
  try
    with EditStream do begin
      dwCookie := LongInt(Pointer(@StreamInfo));
      pfnCallBack := @StreamLoad;
      dwError := 0;
    end;
    Position := Stream.Position;
    case InputFormat of
      ifRTF: TextType := SF_RTF;
      ifUnicode: TextType := SF_UNICODE;
    else
      TextType := SF_TEXT;
    end;
    if Selection then TextType := TextType or SFF_SELECTION;
    if PlainRTF then TextType := TextType or SFF_PLAINRTF;

    Perform(EM_STREAMIN, TextType, Longint(@EditStream));
    if ((TextType and SF_RTF) = SF_RTF) and (EditStream.dwError <> 0) then begin
      Stream.Position := Position;

      case InputFormat of
        ifText: TextType := SF_TEXT;
        ifRTF: TextType := SF_RTF;
        ifUnicode: TextType := SF_UNICODE;
      end;
      if Selection then TextType := TextType or SFF_SELECTION;
      if PlainRTF then TextType := TextType or SFF_PLAINRTF;

      Perform(EM_STREAMIN, TextType, Longint(@EditStream));
      if EditStream.dwError <> 0 then
        raise EOutOfResources.Create(sRichEditLoadFail);
    end;
  finally
    Converter.Free;
  end;
end;

procedure TTeCustomRichEdit.SaveToStream(Stream: TStream; OutputFormat: TTeOutputFormat; Selection, PlainRTF: boolean);
var
  EditStream                  : TEditStream;
  TextType                    : Longint;
  StreamInfo                  : TRichEditStreamInfo;
  Converter                   : TConversion;
begin
  HandleNeeded;
  Converter := DefaultConverter.Create;
  StreamInfo.Stream := Stream;
  StreamInfo.Converter := Converter;
  try
    with EditStream do begin
      dwCookie := LongInt(Pointer(@StreamInfo));
      pfnCallBack := @StreamSave;
      dwError := 0;
    end;

    case OutputFormat of
      ofRTF: TextType := SF_RTF;
      ofRTFNoObjs: TextType := SF_RTFNOOBJS;
      ofTextized: TextType := SF_TEXTIZED;
      ofUnicode: TextType := SF_UNICODE;
    else
      TextType := SF_TEXT;
    end;

    if Selection then TextType := TextType or SFF_SELECTION;
    if PlainRTF then TextType := TextType or SFF_PLAINRTF;

    Perform(EM_STREAMOUT, TextType, Longint(@EditStream));
    if EditStream.dwError <> 0 then
      raise EOutOfResources.Create(sRichEditSaveFail);
  finally
    Converter.Free;
  end;
end;

{ TTeRichEditAction }

constructor TTeRichEditAction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //...AutoCheck := True;
end;

function TTeRichEditAction.CurrText(Edit: TTeRichEdit): TTeTextAttributes;
begin
  Result := Edit.SelAttributesEx;
end;

function TTeRichEditAction.HandlesTarget(Target: TObject): Boolean;
begin
  Result := ((Control <> nil) and (Target = Control) or
    (Control = nil) and (Target is TTeRichEdit)) and TCustomEdit(Target).Focused;
end;

procedure TTeRichEditAction.SetFontStyle(Edit: TTeRichEdit; Style: TFontStyle);
begin
  if Edit = nil then exit;
  if Style in CurrText(Edit).Style then
    CurrText(Edit).Style := CurrText(Edit).Style - [Style]
  else
    CurrText(Edit).Style := CurrText(Edit).Style + [Style];
end;

{ TTeRichEditBold }

procedure TTeRichEditBold.ExecuteTarget(Target: TObject);
begin
  SetFontStyle(Target as TTeRichEdit, fsBold);
end;

procedure TTeRichEditBold.UpdateTarget(Target: TObject);
begin
  inherited UpdateTarget(Target);
  Enabled := Target is TTeRichEdit;
  Checked := fsBold in TTeRichEdit(Target).SelAttributesEx.Style;
end;

{ TTeRichEditItalic }

procedure TTeRichEditItalic.ExecuteTarget(Target: TObject);
begin
  SetFontStyle(Target as TTeRichEdit, fsItalic);
end;

procedure TTeRichEditItalic.UpdateTarget(Target: TObject);
begin
  Enabled := Target is TTeRichEdit;
  Checked := fsItalic in TTeRichEdit(Target).SelAttributesEx.Style;
end;

{ TTeRichEditUnderline }

procedure TTeRichEditUnderline.ExecuteTarget(Target: TObject);
begin
  SetFontStyle(Target as TTeRichEdit, fsUnderline);
end;

procedure TTeRichEditUnderline.UpdateTarget(Target: TObject);
begin
  Enabled := Target is TTeRichEdit;
  Checked := fsUnderline in TTeRichEdit(Target).SelAttributesEx.Style;
end;

{ TTeRichEditStrikeOut }

procedure TTeRichEditStrikeOut.ExecuteTarget(Target: TObject);
begin
  if Target is TTeRichEdit then
    SetFontStyle(Target as TTeRichEdit, fsStrikeOut);
end;

procedure TTeRichEditStrikeOut.UpdateTarget(Target: TObject);
begin
  Enabled := Target is TTeRichEdit;
  if Target is TTeRichEdit then
    Checked := fsStrikeOut in TTeRichEdit(Target).SelAttributesEx.Style;
end;

{ TTeRichEditBullets }

procedure TTeRichEditBullets.ExecuteTarget(Target: TObject);
begin
  if Target is TTeRichEdit then
    if TTeRichEdit(Target).ParagraphEx.Numbering = nsNone then
      TTeRichEdit(Target).ParagraphEx.Numbering := nsBullet
    else
      TTeRichEdit(Target).ParagraphEx.Numbering := nsNone;
end;

procedure TTeRichEditBullets.UpdateTarget(Target: TObject);
begin
  Enabled := Target is TTeRichEdit;
  Checked := Enabled and (TTeRichEdit(Target).ParagraphEx.Numbering = nsBullet);
end;

{ TTeRichEditAlignLeft }

procedure TTeRichEditAlignLeft.ExecuteTarget(Target: TObject);
begin
  if Target is TTeRichEdit then
    TTeRichEdit(Target).ParagraphEx.Alignment := taLeft;
  Checked := True;
end;

procedure TTeRichEditAlignLeft.UpdateTarget(Target: TObject);
begin
  Enabled := Target is TTeRichEdit;
  Checked := Enabled and (TTeRichEdit(Target).ParagraphEx.Alignment = taLeft);
end;

{ TTeRichEditAlignRight }

procedure TTeRichEditAlignRight.ExecuteTarget(Target: TObject);
begin
  if Target is TTeRichEdit then
    TTeRichEdit(Target).ParagraphEx.Alignment := taRight;
  Checked := True;
end;

procedure TTeRichEditAlignRight.UpdateTarget(Target: TObject);
begin
  Enabled := Target is TTeRichEdit;
  Checked := Enabled and (TTeRichEdit(Target).ParagraphEx.Alignment = taRight);
end;

{ TTeRichEditAlignCenter }

procedure TTeRichEditAlignCenter.ExecuteTarget(Target: TObject);
begin
  if Target is TTeRichEdit then
    TTeRichEdit(Target).ParagraphEx.Alignment := taCenter;
  Checked := True;
end;

procedure TTeRichEditAlignCenter.UpdateTarget(Target: TObject);
begin
  Enabled := Target is TTeRichEdit;
  Checked := Enabled and (TTeRichEdit(Target).ParagraphEx.Alignment = taCenter);
end;

var
  _LibHandle                  : THandle;
  OldError                    : Longint;

  { TTeRichEditIncreaseIndent }

const
IndentStep = 10;  

procedure TTeRichEditIncreaseIndent.ExecuteTarget(Target: TObject);
begin
  if Target is TTeRichEdit then
    with TTeRichEdit(Target).ParagraphEx do
      FirstIndent := (Round(FirstIndent * (1 / IndentStep)) * IndentStep) + IndentStep;
end;

procedure TTeRichEditIncreaseIndent.UpdateTarget(Target: TObject);
begin
  Enabled := Target is TTeRichEdit;
end;

{ TTeRichEditDecreaseIndent }

procedure TTeRichEditDecreaseIndent.ExecuteTarget(Target: TObject);
begin
  if Target is TTeRichEdit then
    with TTeRichEdit(Target).ParagraphEx do
      FirstIndent := (Round(FirstIndent * (1 / IndentStep)) * IndentStep) - IndentStep;
end;

procedure TTeRichEditDecreaseIndent.UpdateTarget(Target: TObject);
begin
  Enabled := Target is TTeRichEdit;
end;

initialization
  CF_RTF := RegisterClipboardFormat(RichEdit.CF_RTF);
  CF_RTFNOOBJS := RegisterClipboardFormat(RichEdit.CF_RTFNOOBJS);
  CF_RETEXTOBJ := RegisterClipboardFormat(RichEdit.CF_RETEXTOBJ);
  OldError := SetErrorMode(SEM_NOOPENFILEERRORBOX);
  _LibHandle := LoadLibrary(RichEditModuleName);
  if (_LibHandle > 0) and (_LibHandle < HINSTANCE_ERROR) then _LibHandle := 0;
  SetErrorMode(OldError);
finalization
  if _LibHandle <> 0 then FreeLibrary(_LibHandle);
end.

