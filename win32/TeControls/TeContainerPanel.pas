unit TeContainerPanel;

interface

uses
  Windows, Messages,
  SysUtils, Classes, Graphics, Menus,
  Forms, Controls, ExtCtrls, ComCtrls, Dialogs,
  TeControls;

type
  TTeContainerPanelClass = class of TTeContainerPanel;
  TTeContainerPanel = class(TTeCustomPanel)
  private
    FAlreadyShowed: Boolean;
    FOnCreate: TNotifyEvent;
    FOnDestroy: TNotifyEvent;
    FOnLoaded: TNotifyEvent;
    FOnHide: TNotifyEvent;
    FOnShow: TNotifyEvent;
    FOnFirstShow: TNotifyEvent;
    procedure CMShowingChanged(var Message: TMessage); message CM_SHOWINGCHANGED;
  protected
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    procedure Loaded; override;
    procedure DoFirstShow; dynamic;
    procedure DoShow; dynamic;
    procedure DoHide; dynamic;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    constructor Create(AOwner: TComponent); override;
    constructor CreateNew(AOwner: TComponent; Dummy: Integer = 0); virtual;
    destructor Destroy; override;
  published
    property BorderWidth;
    property Color;
    property Ctl3D;
    property Font;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont default false;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnCreate: TNotifyEvent read FOnCreate write FOnCreate;
    property OnLoaded: TNotifyEvent read FOnLoaded write FOnLoaded;
    property OnDestroy: TNotifyEvent read FOnDestroy write FOnDestroy;
    property OnFirstShow: TNotifyEvent read FOnFirstShow write FOnFirstShow;
    property OnShow: TNotifyEvent read FOnShow write FOnShow;
    property OnHide: TNotifyEvent read FOnHide write FOnHide;
  end;

implementation

uses
  RTLConsts;

{ TTeContainerPanel }

procedure TTeContainerPanel.AfterConstruction;
begin
  inherited;
  if Assigned(OnCreate) then
    OnCreate(Self);
end;

procedure TTeContainerPanel.BeforeDestruction;
begin
  if Assigned(OnDestroy) then
    OnDestroy(Self);
  inherited;
end;

procedure TTeContainerPanel.CMShowingChanged(var Message: TMessage);
begin
  if Showing then begin
    if not FAlreadyShowed then try
      FAlreadyShowed := True;
      DoFirstShow;
    except
      Application.HandleException(Self);
    end;
    try
      DoShow;
    except
      Application.HandleException(Self);
    end;
    inherited;
  end
  else begin
    try
      DoHide;
    except
      Application.HandleException(Self);
    end;
    inherited;
  end;
  inherited;
end;

constructor TTeContainerPanel.Create(AOwner: TComponent);
begin
  GlobalNameSpace.BeginWrite;
  try
    CreateNew(AOwner);
    if (ClassType <> TTeContainerPanel) and not (csDesigning in ComponentState) then begin
      if not InitInheritedComponent(Self, TTeContainerPanel) then
        raise EResNotFound.CreateFmt(SResNotFound, [ClassName]);
    end;
  finally
    GlobalNameSpace.EndWrite;
  end;
end;

constructor TTeContainerPanel.CreateNew(AOwner: TComponent; Dummy: Integer);
begin
  inherited Create(AOwner);
  BevelOuter := bvNone;
  ParentFont := false;
end;

destructor TTeContainerPanel.Destroy;
begin
  inherited;
end;

procedure TTeContainerPanel.DoFirstShow;
begin
  if Assigned(OnShow) then
    OnShow(Self);
end;

procedure TTeContainerPanel.DoHide;
begin
  if Assigned(OnHide) then
    OnHide(Self);
end;

procedure TTeContainerPanel.DoShow;
begin
  if Assigned(OnShow) then
    OnShow(Self);
end;

procedure TTeContainerPanel.GetChildren(Proc: TGetChildProc; Root: TComponent);
var
  I                 : Integer;
  OwnedComponent    : TComponent;
begin
  inherited GetChildren(Proc, Root);
  if Root = Self then
    for I := 0 to ComponentCount - 1 do begin
      OwnedComponent := Components[I];
      if not OwnedComponent.HasParent then Proc(OwnedComponent);
    end;
end;

procedure TTeContainerPanel.Loaded;
begin
  inherited;
  if Assigned(OnLoaded) then
    OnLoaded(Self);
end;

initialization
  RegisterClass(TTeContainerPanel);
end.

