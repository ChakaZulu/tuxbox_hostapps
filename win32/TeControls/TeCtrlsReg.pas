unit TeCtrlsReg;

interface

uses
  TeButtons,                                                {TTeSpeedButton, TTeBitBtn}
  TeComCtrls,                                               {TTeListView, TTeTreeView}
  TeControls,                                               {TTePanel, TTeSplitter, TTeCheckBox, TTeRadioButton, TTeGroupBox, TTeRadioGroup}
  TeRichEdit;                                               {TTeRichEdit}

resourcestring
  rsTeControls                = 'TESS Controls';

procedure Register;

implementation

uses
  Classes, ActnList;

procedure Register;
begin
  RegisterComponents(rsTeControls, [TTeSpeedButton, TTeBitBtn]);
  RegisterComponents(rsTeControls, [TTeListView, TTeTreeView]);
  RegisterComponents(rsTeControls, [TTePanel, TTeSplitter,
    TTeCheckBox, TTeRadioButton, TTeGroupBox, TTeRadioGroup]);
  RegisterComponents(rsTeControls, [TTeRichEdit]);
  RegisterComponents(rsTeControls, [TTeEdit]);
  RegisterActions('', [TTeRichEditBold, TTeRichEditItalic,
    TTeRichEditUnderline, TTeRichEditStrikeOut, TTeRichEditBullets,
      TTeRichEditIncreaseIndent, TTeRichEditDecreaseIndent,
      TTeRichEditAlignLeft, TTeRichEditAlignRight, TTeRichEditAlignCenter], nil);
end;

end.

