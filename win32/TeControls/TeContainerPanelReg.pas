unit TeContainerPanelReg;

interface

uses
  Windows,
  SysUtils, Classes,
  DesignIntf, ExptIntf, ToolIntf, EditIntf, VirtIntf, TypInfo,
  TeContainerPanel;

type
  TTeContainerPanelExpert = class(TIExpert)
  private
    procedure RunExpert(ToolServices: TIToolServices);
  public
    function GetName: string; override;
    function GetAuthor: string; override;
    function GetComment: string; override;
    function GetPage: string; override;
    function GetGlyph: HICON; override;
    function GetStyle: TExpertStyle; override;
    function GetState: TExpertState; override;
    function GetIDString: string; override;
    function GetMenuText: string; override;
    procedure Execute; override;
  end;

procedure Register;

implementation

uses
  Consts, DesignEditors;

procedure Register;
begin
  RegisterCustomModule(TTeContainerPanel, TCustomModule);
  RegisterLibraryExpert(TTeContainerPanelExpert.Create);
end;

const
  sCRLF             = #13#10;
  sCRLF2            = #13#10#13#10;
  DefaultModuleFlags = [cmShowSource, cmShowForm, cmMarkModified, cmUnNamed];

resourcestring
  rsContainerPanelExpertAuthor = 'Te';
  rsContainerPanelExpertName = 'Te Container Panel';
  rsContainerPanelExpertDesc = 'Creates a new Container Panel';
  rsNew             = 'New';

  { TTeContainerPanelModuleCreator }

type
  TTeContainerPanelModuleCreator = class(TIModuleCreator)
  private
    FAncestorIdent: string;
    FAncestorClass: TClass;
    FFormIdent: string;
    FUnitIdent: string;
    FFileName: string;
  public
    function Existing: Boolean; override;
    function GetFileName: string; override;
    function GetFileSystem: string; override;
    function GetFormName: string; override;
    function GetAncestorName: string; override;
    function NewModuleSource(const UnitIdent, FormIdent, AncestorIdent: string): string; override;
    procedure FormCreated(Form: TIFormInterface); override;
  end;

function TTeContainerPanelModuleCreator.Existing: boolean;
begin
  Result := False
end;

function TTeContainerPanelModuleCreator.GetFileName: string;
begin
  Result := '';
end;

function TTeContainerPanelModuleCreator.GetFileSystem: string;
begin
  Result := '';
end;

function TTeContainerPanelModuleCreator.GetFormName: string;
begin
  Result := FFormIdent;
end;

function TTeContainerPanelModuleCreator.GetAncestorName: string;
begin
  Result := FAncestorIdent;
end;

function TTeContainerPanelModuleCreator.NewModuleSource(const UnitIdent, FormIdent, AncestorIdent: string): string;
var
  s                 : string;
begin
  s := 'unit ' + FUnitIdent + ';' + sCRLF2 +
    'interface' + sCRLF2 +
    'uses' + sCRLF +
    '  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,' + sCRLF +
    ' Dialogs, TeContainerPanel';

  s := s + ';' + sCRLF2 +
    'type' + sCRLF +
    '  T' + FFormIdent + ' = class(' + FAncestorClass.ClassName + ')' + sCRLF +
    '  private' + sCRLF +
    '    { Private declarations }' + sCRLF +
    '  protected' + sCRLF +
    '    { Protected declarations }' + sCRLF +
    '  public' + sCRLF +
    '    { Public declarations }' + sCRLF +
    '  published' + sCRLF +
    '    { Published declarations }' + sCRLF +
    '  end;' + sCRLF2;

  s := s +
    'implementation' + sCRLF2;

  s := s +
    '{$R *.DFM}' + sCRLF2;

  s := s +
    'end.';

  Result := s;
end;

procedure TTeContainerPanelModuleCreator.FormCreated(Form: TIFormInterface);
begin
  {  with Form.GetFormComponent do try
      TTeContainerPanel(GetComponentHandle).Width := 300;
      TTeContainerPanel(GetComponentHandle).Height := 300;
      Application.ProcessMessages;
    finally
      Free;
    end;}
end;

{ HandleException }

procedure HandleException;
begin
  ToolServices.RaiseException(ReleaseException);
end;

{ TTeContainerPanelExpert }

function TTeContainerPanelExpert.GetName: string;
begin
  Result := rsContainerPanelExpertName;
end;

function TTeContainerPanelExpert.GetComment: string;
begin
  Result := rsContainerPanelExpertDesc;
end;

function TTeContainerPanelExpert.GetGlyph: HICON;
begin
  //!!!    Result := LoadIcon(HInstance, 'NEWTECONTAINERPANEL');
  Result := 0;
end;

function TTeContainerPanelExpert.GetStyle: TExpertStyle;
begin
  Result := esForm;
end;

function TTeContainerPanelExpert.GetState: TExpertState;
begin
  Result := [esEnabled];
end;

function TTeContainerPanelExpert.GetIDString: string;
begin
  Result := 'tess.' + rsContainerPanelExpertName;
end;

function TTeContainerPanelExpert.GetAuthor: string;
begin
  Result := rsContainerPanelExpertAuthor;
end;

function TTeContainerPanelExpert.GetPage: string;
begin
  Result := rsNew;
end;

procedure TTeContainerPanelExpert.Execute;
begin
  try
    RunExpert(ToolServices);
  except
    HandleException;
  end;
end;

procedure TTeContainerPanelExpert.RunExpert(ToolServices: TIToolServices);
var
  ModuleFlags       : TCreateModuleFlags;
  IModuleCreator    : TTeContainerPanelModuleCreator;
  IModule           : TIModuleInterface;
begin
  if ToolServices = nil then Exit;
  IModuleCreator := TTeContainerPanelModuleCreator.Create;
  IModuleCreator.FAncestorIdent := 'TeContainerPanel';
  IModuleCreator.FAncestorClass := TTeContainerPanel;
  ToolServices.GetNewModuleAndClassName(IModuleCreator.FAncestorIdent,
    IModuleCreator.FUnitIdent, IModuleCreator.FFormIdent, IModuleCreator.FFileName);
  ModuleFlags := DefaultModuleFlags;
  ModuleFlags := ModuleFlags + [cmAddToProject];
  try
    IModule := ToolServices.ModuleCreate(IModuleCreator, ModuleFlags);
    IModule.Free;
  finally
    IModuleCreator.Free;
  end;
end;

function TTeContainerPanelExpert.GetMenuText: string;
begin
  Result := '';
end;

end.

