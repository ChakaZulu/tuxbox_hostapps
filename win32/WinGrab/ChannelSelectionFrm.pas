unit ChannelSelectionFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TeControls, ExtCtrls, TeButtons, TeChannelsReader;

type
  TfrmChannelSelect = class(TForm)
    plButtons: TTePanel;
    plChannelList: TTePanel;
    bnAbbruch: TTeBitBtn;
    bnOK: TTeBitBtn;
    Bevel1: TBevel;
    gbxChannelList: TTeGroupBox;
    lbxChannelList: TListBox;
    procedure lbxChannelListDblClick(Sender: TObject);
    procedure lbxChannelListClick(Sender: TObject);
    procedure lbxChannelListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

function SelectChannel(aChannelList: TTeChannelList): Integer; //-1 if no channel selected

implementation

{$R *.DFM}

function SelectChannel(aChannelList: TTeChannelList): Integer;

var
  i                                : Integer;
begin
  with TfrmChannelSelect.Create(nil) do try
    for i := 0 to Pred(aChannelList.Count) do
      lbxChannelList.Items.AddObject(PChannel(aChannelList.Items[i])^.szName, TObject(i));
    if ShowModal = mrOK then
      Result := lbxChannelList.ItemIndex
    else
      Result := -1;
  finally
    Free;
  end;
end;

procedure TfrmChannelSelect.lbxChannelListDblClick(Sender: TObject);
begin
  if bnOK.Enabled and (lbxChannelList.ItemIndex >= 0) then
    bnOK.Click;
end;

procedure TfrmChannelSelect.lbxChannelListClick(Sender: TObject);
begin
  bnOK.Enabled := lbxChannelList.ItemIndex >= 0;
end;

function MidColor(aColor1, aColor2: TColor): TColor;
var
  hColor1                          : TRGBQuad absolute aColor1;
  hColor2                          : TRGBQuad absolute aColor2;
  hResult                          : TRGBQuad absolute Result;
begin
  aColor1 := ColorToRGB(aColor1);
  aColor2 := ColorToRGB(aColor2);
  Result := 0;
  hResult.rgbBlue := (hColor1.rgbBlue + hColor2.rgbBlue) div 2;
  hResult.rgbGreen := (hColor1.rgbGreen + hColor2.rgbGreen) div 2;
  hResult.rgbRed := (hColor1.rgbRed + hColor2.rgbRed) div 2;
end;

procedure TfrmChannelSelect.lbxChannelListDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  if not (odSelected in State) then
    if Index mod 2 = 0 then
      lbxChannelList.Canvas.Brush.Color := clWindow
    else
      lbxChannelList.Canvas.Brush.Color := MidColor(clWindow, MidColor(clWindow, clBtnShadow));

  if (Index >= 0) and (Index < lbxChannelList.Items.Count) then begin
    WriteText(lbxChannelList.Canvas, Rect, 2, 2, lbxChannelList.Items[Index], taLeftJustify, false)
  end else
    lbxChannelList.Canvas.FillRect(Rect);
end;

end.

