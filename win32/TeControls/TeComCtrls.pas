unit TeComCtrls;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, TypInfo, Menus, ActnList, ExtCtrls, ComCtrls, CommCtrl,
  ImgList;

type
  { TTeListItem }

  TTeListItem = class(TListItem)
  private
    FImageName: string;
    procedure SetImageName(const Value: string);
  public
    property ImageName: string read FImageName write SetImageName;
  end;

  { TTeListView }

  TTeListView = class(TCustomListView)
  private
    procedure CNNotify(var Message: TWMNotify); message CN_NOTIFY;
    function GetItem(Value: TLVItem): TListItem;
  protected
    function CreateListItem: TListItem; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Align;
    property AllocBy;
    property Anchors;
    property BiDiMode;
    property BorderStyle;
    property BorderWidth;
    property Checkboxes;
    property Color;
    property Columns;
    property ColumnClick;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property FlatScrollBars;
    property FullDrag;
    property GridLines;
    property HideSelection;
    property HotTrack;
    property HotTrackStyles;
    property IconOptions;
    property Items;
    property MultiSelect;
    property OwnerData;
    property OwnerDraw;
    property ReadOnly default False;
    property RowSelect;
    property ParentBiDiMode;
    property ParentColor default False;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowColumnHeaders;
    property ShowHint;
    property SortType;
    property TabOrder;
    property TabStop default True;
    property ViewStyle;
    property Visible;
    property OnChange;
    property OnChanging;
    property OnClick;
    property OnColumnClick;
    property OnCompare;
    property OnCustomDraw;
    property OnCustomDrawItem;
    property OnCustomDrawSubItem;
    property OnData;
    property OnDataFind;
    property OnDataHint;
    property OnDataStateChange;
    property OnDblClick;
    property OnDeletion;
    property OnDrawItem;
    property OnEdited;
    property OnEditing;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetImageIndex;
    property OnDragDrop;
    property OnDragOver;
    property OnInsert;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnSelectItem;
    property OnStartDock;
    property OnStartDrag;
  end;

  TTeTreeNode = class(TTreeNode)
  private
    FImageName: string;
    procedure SetImageName(const Value: string);
  public
    property ImageName: string read FImageName write SetImageName;
  end;

  TTeTreeView = class(TCustomTreeView)
  private
    procedure CNNotify(var Message: TWMNotify); message CN_NOTIFY;
    function GetNodeFromItem(const Item: TTVItem): TTreeNode;
  protected
    function CreateNode: TTreeNode; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Align;
    property Anchors;
    property AutoExpand;
    property BiDiMode;
    property BorderStyle;
    property BorderWidth;
    property ChangeDelay;
    property Color;
    property Ctl3D;
    property Constraints;
    property DragKind;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property HotTrack;
    property Indent;
    property Items;
    property ParentBiDiMode;
    property ParentColor default False;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property RightClickSelect;
    property RowSelect;
    property ShowButtons;
    property ShowHint;
    property ShowLines;
    property ShowRoot;
    property SortType;
    property TabOrder;
    property TabStop default True;
    property ToolTips;
    property Visible;
    property OnChange;
    property OnChanging;
    property OnClick;
    property OnCollapsing;
    property OnCollapsed;
    property OnCompare;
    property OnCustomDraw;
    property OnCustomDrawItem;
    property OnDblClick;
    property OnDeletion;
    property OnDragDrop;
    property OnDragOver;
    property OnEdited;
    property OnEditing;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnExpanding;
    property OnExpanded;
    property OnGetImageIndex;
    property OnGetSelectedIndex;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

implementation

uses
  ComStrs, Consts,
  TeImgList;

var
  _InternalImageList: TImageList;

  { TTeListItem }

procedure TTeListItem.SetImageName(const Value: string);
begin
  if FImageName <> Value then begin
    FImageName := Value;
    Update;
  end;
end;

{ TTeListView }

constructor TTeListView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  LargeImages := _InternalImageList;
  SmallImages := _InternalImageList;
end;

procedure TTeListView.CNNotify(var Message: TWMNotify);
var
  Item              : TTeListItem;
  TmpItem           : TLVItem;
  SavedDC           : integer;
  R                 : TRect;
begin
  with Message do
    case NMHdr^.code of
      NM_CUSTOMDRAW:
        with PNMCustomDraw(NMHdr)^ do begin
          Result := CDRF_DODEFAULT;
          if dwDrawStage = CDDS_PREPAINT then
            Result := CDRF_NOTIFYPOSTPAINT or CDRF_NOTIFYITEMDRAW
          else
            if dwDrawStage and CDDS_ITEMPREPAINT <> 0 then begin
              if dwDrawStage and CDDS_SUBITEM <> 0 then
                exit;
              SavedDC := SaveDC(hdc);
              try
                Canvas.Handle := hdc;
                Canvas.Font := Font;
                Canvas.Brush := Brush;
                FillChar(TmpItem, SizeOf(TmpItem), 0);
                TmpItem.iItem := dwItemSpec;

                Item := TTeListItem(GetItem(TmpItem));
                if (Item.FImageName <> '') then begin
                  R := Item.DisplayRect(drIcon);
                  TeImageManager.DrawMulti(isUp, Canvas, R.Left, R.Top, Item.FImageName);
                end;

                Canvas.Handle := 0;
              finally
                RestoreDC(hdc, SavedDC);
              end;
            end;
        end;
    else
      inherited;
    end;
end;

function TTeListView.CreateListItem: TListItem;
begin
  Result := TTeListItem.Create(Items);
end;

function TTeListView.GetItem(Value: TLVItem): TListItem;
begin
  with Value do
    if (mask and LVIF_PARAM) <> 0 then
      Result := TListItem(lParam)
    else
      Result := Items[IItem];
end;

{ TTeTreeNode }

procedure TTeTreeNode.SetImageName(const Value: string);
var
  rc                : TRect;
begin
  if FImageName <> Value then begin
    FImageName := Value;
    rc := DisplayRect(False);
    if TreeView.HandleAllocated then
      InvalidateRect(TreeView.Handle, @rc, True);
  end;
end;

{ TTeTreeView }

constructor TTeTreeView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Images := _InternalImageList;
end;

procedure TTeTreeView.CNNotify(var Message: TWMNotify);
var
  Node              : TTeTreeNode;
  TmpItem           : TTVItem;
  SavedDC           : integer;
  R                 : TRect;
begin
  with Message do
    case NMHdr^.code of
      NM_CUSTOMDRAW:
        with PNMCustomDraw(NMHdr)^ do begin
          Result := CDRF_DODEFAULT;
          if dwDrawStage = CDDS_PREPAINT then
            Result := CDRF_NOTIFYPOSTPAINT or CDRF_NOTIFYITEMDRAW
          else
            if dwDrawStage = CDDS_ITEMPREPAINT then begin
              FillChar(TmpItem, SizeOf(TmpItem), 0);
              TmpItem.hItem := HTREEITEM(dwItemSpec);
              Node := TTeTreeNode(GetNodeFromItem(TmpItem));
              if Node <> nil then begin
                SavedDC := SaveDC(hdc);
                try
                  Canvas.Handle := hdc;
                  Canvas.Font := Font;
                  Canvas.Brush := Brush;

                  if (Node.FImageName <> '') then begin
                    R := Node.DisplayRect(True);
                    TeImageManager.DrawMulti(isUp, Canvas, R.Left - 24, R.Top, Node.FImageName);
                  end;

                  Canvas.Handle := 0;
                finally
                  RestoreDC(hdc, SavedDC);
                end;
              end;
            end;
        end;
    else
      inherited;
    end;
end;

function TTeTreeView.GetNodeFromItem(const Item: TTVItem): TTreeNode;
begin
  with Item do
    if (state and TVIF_PARAM) <> 0 then Result := Pointer(lParam)
    else Result := Items.GetNode(hItem);
end;

function TTeTreeView.CreateNode: TTreeNode;
begin
  Result := TTeTreeNode.Create(Items);
end;

initialization
  _InternalImageList := TImageList.CreateSize(24, 24);
finalization
  _InternalImageList.Free;
  _InternalImageList := nil;
end.

