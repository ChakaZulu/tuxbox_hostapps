unit TeRichConv;

interface

uses
  Classes;

resourcestring
  rsConverterSchonGeladen = 'Converter bereits geladen';
  rsInitConverterFehlgeschlagen = 'InitConverter fehlgeschlagen';
  rsBusy                 = 'Converter ist beschäftigt';
  rsImportFehler         = 'Fehler beim Import';
  rsExportFehler         = 'Fehler beim Export';

type
  TTeFilterInfo = class(TObject)
  private
    fiBez: string;
    fiFileName: string;
    fiExtList: TStringList;
    function GetExt(Index: integer): string;
    function GetExtCount: integer;
    function GetFilterOK: Boolean;
    function GetFilterEntry: string;
  protected
    property FilterOK: Boolean read GetFilterOK;
    property FilterEntry: string read GetFilterEntry;
  public
    constructor Create(ABez, AFileName, AExt: string);
    destructor Destroy; override;
    property Bez: string read fiBez;
    property FileName: string read fiFileName;
    property ExtCount: integer read GetExtCount;
    property Ext[Index: integer]: string read GetExt;
  end;

  TTeFilterList = class(TObject)
  private
    flList: TList;
    function GetCount: integer;
    function GeTTeFilterInfo(Index: Integer): TTeFilterInfo;
  public
    constructor Create;
    destructor Destroy; override;
    property Count: integer read GetCount;
    property Items[Index: Integer]: TTeFilterInfo read GeTTeFilterInfo; default;
  end;

function ImportFilter: string;
function ExportFilter: string;

function ImportFilters: TTeFilterList;
function ExportFilters: TTeFilterList;

procedure ImportToRtf(Filter: TTeFilterInfo; FileName: string; RtfStream: TStream); overload;
procedure ImportToRtf(Filter: Integer; FileName: string; RtfStream: TStream); overload;
procedure ImportToRtf(AFileName: string; RtfStream: TStream); overload;

procedure ExportFromRtf(Filter: TTeFilterInfo; RtfStream: TStream; FileName: string); overload;
procedure ExportFromRtf(Filter: Integer; RtfStream: TStream; FileName: string); overload;

implementation

uses
  Windows,
  SysUtils, Registry,
  Forms;

{ TTeFilterInfo }

constructor TTeFilterInfo.Create(ABez, AFileName, AExt: string);
var
  j                      : integer;
begin
  inherited Create;
  fiBez := Trim(ABez);
  fiFileName := AnsiLowerCase(Trim(AFileName));
  fiExtList := TStringList.Create;
  fiExtList.CommaText := AnsiLowerCase(AExt);
  for j := fiExtList.Count - 1 downto 0 do begin
    fiExtList[j] := Trim(fiExtList[j]);
    if fiExtList[j] = '' then
      fiExtList.Delete(j);
  end;
end;

destructor TTeFilterInfo.Destroy;
begin
  inherited Destroy;
  fiExtList.Free;
  fiExtList := nil;
end;

function TTeFilterInfo.GetExt(Index: integer): string;
begin
  Result := fiExtList[Index];
end;

function TTeFilterInfo.GetExtCount: integer;
begin
  Result := fiExtList.Count;
end;

function TTeFilterInfo.GetFilterEntry: string;
var
  FilterStr              : string;
  j                      : integer;
begin
  FilterStr := '';
  for j := 0 to ExtCount - 1 do
    FilterStr := FilterStr + '*.' + Ext[j] + ';';
  Delete(FilterStr, Length(FilterStr), 1);
  Result := Bez + ' (' + FilterStr + ')|' + FilterStr + '|';
end;

function TTeFilterInfo.GetFilterOK: Boolean;
begin
  Result := (Bez <> '') and (FileName <> '') and FileExists(FileName) and (ExtCount > 0);
end;

{ TTeFilterList }

constructor TTeFilterList.Create;
begin
  flList := TList.Create;
  inherited Create;
end;

destructor TTeFilterList.Destroy;
var
  j                      : integer;
begin
  inherited Destroy;
  for j := 0 to flList.Count - 1 do
    TObject(flList[j]).Free;
  flList.Free;
  flList := nil;
end;

function TTeFilterList.GetCount: integer;
begin
  Result := flList.Count;
end;

function TTeFilterList.GeTTeFilterInfo(Index: Integer): TTeFilterInfo;
begin
  Result := TTeFilterInfo(flList[Index]);
end;

var
  FImportFilter          : string;
  FImportFilters         : TTeFilterList;

  FExportFilter          : string;
  FExportFilters         : TTeFilterList;

  FBuildOK               : Boolean;

procedure BuildInfo;
const
  MSTextConvKey          = 'SOFTWARE\Microsoft\Shared Tools\Text Converters\';
  saImEx                 : array[boolean] of string = ('Export', 'Import');
var
  WordPadDir             : string;

  procedure GetWordPadDir;
  begin
    with TRegistry.Create do try
      RootKey := HKEY_LOCAL_MACHINE;
      WordPadDir := '';
      if OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\WORDPAD.EXE', False) then
        WordPadDir := ReadString('');
      WordPadDir := ExtractFilePath(WordPadDir);
    finally
      CloseKey;
      Free;
    end;
  end;

  procedure BuildList(List: TList; Import: Boolean);
  var
    slEntries            : TStringList;
    j                    : integer;
  begin
    slEntries := TStringList.Create;
    try
      with TRegistry.Create do try
        RootKey := HKEY_LOCAL_MACHINE;

        if OpenKey(MSTextConvKey + saImEx[Import], False) then
          GetKeyNames(slEntries);
        CloseKey;

        for j := 0 to slEntries.Count - 1 do begin
          if OpenKey(MSTextConvKey + saImEx[Import] + '\' + slEntries[j], false) then try
            List.Add(TTeFilterInfo.Create(ReadString('Name'), ReadString('Path'), ReadString('Extensions')));
          except
            // catch a faulty key mismatch
          end;
          CloseKey;
        end;
      finally
        Free;
      end;
    finally
      slEntries.Free;
    end;

    List.Add(TTeFilterInfo.Create('Windows Write via Wordpad', WordPadDir + 'write32.wpc', 'wri'));
    List.Add(TTeFilterInfo.Create('Word 6.0/95 via Wordpad', WordPadDir + 'mswd6_32.wpc', 'doc'));

    for j := List.Count - 1 downto 0 do
      if not TTeFilterInfo(List[j]).FilterOK then begin
        TTeFilterInfo(List[j]).Free;
        List.Delete(j);
      end;

    List.Insert(0, TTeFilterInfo.Create('Rich Text Format', '', 'rtf'));
    List.Add(TTeFilterInfo.Create('Textformat', '', 'txt'));
  end;

  function BuildFilterStr(List: TList): string;
  var
    j                    : integer;
  begin
    Result := '';
    for j := 0 to List.Count - 1 do
      Result := Result + TTeFilterInfo(List[j]).FilterEntry;
    if (Length(Result) > 0) and (Result[Length(Result)] = '|') then
      Delete(Result, Length(Result), 1);
  end;

begin
  if FBuildOK then exit;

  GetWordPadDir;

  if not Assigned(FImportFilters) then
    FImportFilters := TTeFilterList.Create;
  if not Assigned(FExportFilters) then
    FExportFilters := TTeFilterList.Create;

  BuildList(FImportFilters.flList, true);
  BuildList(FExportFilters.flList, false);

  FImportFilter := BuildFilterStr(FImportFilters.flList);
  FExportFilter := BuildFilterStr(FExportFilters.flList);

  FBuildOK := true;
end;

function ImportFilter: string;
begin
  BuildInfo;
  Result := FImportFilter;
end;

function ExportFilter: string;
begin
  BuildInfo;
  Result := FExportFilter;
end;

function ImportFilters: TTeFilterList;
begin
  BuildInfo;
  Result := FImportFilters;
end;

function ExportFilters: TTeFilterList;
begin
  BuildInfo;
  Result := FExportFilters;
end;

const
  BufferSize             = 16 * 1024;

type
  RTF_CALLBACK = function(CCH, nPercentComplete: integer): Integer; stdcall;
  TInitConverter = function(ParentWin: THandle; ParentAppName: LPCSTR): integer; stdcall;
  TIsFormatCorrect = function(FileName, Desc: HGLOBAL): integer; stdcall;
  TForeignToRtf = function(FileName: HGLOBAL; void: pointer {LPSTORAGE}; Buf, Desc, Subset: HGLOBAL; Callback: RTF_CALLBACK): integer; stdcall;
  TRtfToForeign = function(FileName: HGLOBAL; void: pointer {LPSTORAGE}; Buf, Desc: HGLOBAL; Callback: RTF_CALLBACK): integer; stdcall;

var
  CurrentConverter       : THandle;
  InitConverter          : TInitConverter = nil;
  IsFormatCorrect        : TIsFormatCorrect = nil;
  ForeignToRtf           : TForeignToRtf = nil;
  RtfToForeign           : TRtfToForeign = nil;
  hBuf                   : HGLOBAL;
  Stream                 : TStream;

function LoadConverter(Filter: TTeFilterInfo): THandle;
begin
  Result := 0;

  if CurrentConverter <> 0 then
    raise Exception.Create(rsConverterSchonGeladen);

  try
    if Filter.FilterOK then
      Result := LoadLibrary(PChar(Filter.FileName));

    CurrentConverter := Result;

    if Result <> 0 then begin
      @InitConverter := GetProcAddress(Result, 'InitConverter32');
      @IsFormatCorrect := GetProcAddress(Result, 'IsFormatCorrect32');
      @ForeignToRtf := GetProcAddress(Result, 'ForeignToRtf32');
      @RtfToForeign := GetProcAddress(Result, 'RtfToForeign32');
    end
    else begin
      @InitConverter := nil;
      @IsFormatCorrect := nil;
      @ForeignToRtf := nil;
      @RtfToForeign := nil;
    end;

  except
    if Result <> 0 then
      FreeLibrary(Result);
    raise;
  end;
end;

function StringToHGLOBAL(const Str: string): HGLOBAL;
var
  New                    : PChar;
begin
  Result := GlobalAlloc(GHND, Length(Str) * 2 + 1);
  try
    New := GlobalLock(Result);
    try
      if Assigned(New) then
        StrCopy(New, PChar(Str));
    finally
      GlobalUnlock(Result);
    end;
  except
    GlobalFree(Result);
    raise;
  end;
end;

function IsKnownFormat(FileName: string): Boolean;
var
  hFileName, hDesc       : HGLOBAL;
begin
  Result := False;

  if not (Assigned(InitConverter) and LongBool(InitConverter(Application.Handle, PChar(AnsiUpperCase(Application.ExeName))))) then
    raise Exception.Create(rsInitConverterFehlgeschlagen);

  hFileName := StringToHGLOBAL(FileName);
  hDesc := StringToHGLOBAL('');
  try
    if Assigned(IsFormatCorrect) then
      Result := LongBool(IsFormatCorrect(hFileName, hDesc))
  finally
    GlobalFree(hDesc);
    GlobalFree(hFileName);
  end;
end;

function Reading(CCH, nPercentComplete: integer): Integer; stdcall;
var
  pBuffer                : PChar;
begin
  if CCH > 0 then begin
    pBuffer := GlobalLock(hBuf);
    try
      Stream.Write(pBuffer^, CCH);
    finally
      GlobalUnlock(hBuf);
    end;
  end;
  Result := 0;
end;

function Writing(CCH, nPercentComplete: integer): Integer; stdcall;
var
  pBuffer                : PChar;
begin
  pBuffer := GlobalLock(hBuf);
  try
    if not Assigned(pBuffer) then begin
      Result := -8;                     // out of memory
      exit;
    end;
    Result := Stream.Read(pBuffer^, BufferSize);
  finally
    GlobalUnlock(hBuf);
  end;
end;

procedure FreeConverter;
begin
  if CurrentConverter <> 0 then begin
    FreeLibrary(CurrentConverter);
    CurrentConverter := 0;
    @InitConverter := nil;
    @IsFormatCorrect := nil;
    @ForeignToRtf := nil;
    @RtfToForeign := nil;
  end;
end;

procedure ImportToRtf(Filter: TTeFilterInfo; FileName: string; RtfStream: TStream);
var
  hSubset, hFileName, hDesc: HGLOBAL;
  Res                    : integer;
  FileStream             : TFileStream;
begin
  if not Filter.FilterOK then begin
    FileStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
    try
      RtfStream.CopyFrom(FileStream, FileStream.Size - FileStream.Position);
    finally
      FileStream.Free;
    end;
    exit;
  end;

  if CurrentConverter <> 0 then
    raise Exception.Create(rsBusy);

  Stream := RtfStream;
  LoadConverter(Filter);
  try
    if IsKnownFormat(FileName) then begin
      hSubset := StringToHGLOBAL(' ');
      hDesc := StringToHGLOBAL(' ');
      hFileName := StringToHGLOBAL(FileName);
      hBuf := GlobalAlloc(GHND, BufferSize + 1);
      try
        Res := -1;

        if Assigned(ForeignToRtf) then
          Res := ForeignToRtf(hFileName, nil, hBuf, hDesc, hSubset, Reading);

        if Res <> 0 then
          raise Exception.Create(rsImportFehler);

      finally
        GlobalFree(hBuf);
        GlobalFree(hFileName);
        GlobalFree(hDesc);
        GlobalFree(hSubset);
      end;
    end;
  finally
    FreeConverter;
    Stream := nil;
  end;
end;

procedure ImportToRtf(Filter: Integer; FileName: string; RtfStream: TStream);
begin
  ImportToRtf(ImportFilters[Filter], FileName, RtfStream);
end;

procedure ImportToRtf(AFileName: string; RtfStream: TStream); overload;
var
  i, j                   : integer;
  a, b                   : Boolean;
  FileExt                : string;
begin
  AFileName := ExpandUNCFileName(AFileName);
  FileExt := Copy(ExtractFileExt(AFileName), 2, High(Integer));
  b := false;
  for i := 0 to Pred(ImportFilters.Count) do
    with ImportFilters[i] do begin
      a := false;
      for j := 0 to Pred(ExtCount) do
        if Ext[j] = FileExt then begin
          a := true;
          break;
        end;
      if a then begin
        b := false;
        if CurrentConverter <> 0 then
          raise Exception.Create(rsBusy);
        if FilterOk then begin
          LoadConverter(ImportFilters[i]);
          try
            if IsKnownFormat(AFileName) then
              b := true;
          finally
            FreeConverter;
          end;
        end
        else
          b := true;
        if b then begin
          ImportToRtf(ImportFilters[i], AFileName, RtfStream);
        end;
      end;
    end;
  if not b then
    Abort;
end;

procedure ExportFromRtf(Filter: TTeFilterInfo; RtfStream: TStream; FileName: string);
var
  hSubset, hFileName, hDesc: HGLOBAL;
  Result                 : integer;
  FileStream             : TFileStream;
begin
  if not Filter.FilterOK then begin
    FileStream := TFileStream.Create(FileName, fmCreate or fmShareDenyWrite);
    try
      FileStream.CopyFrom(RtfStream, RtfStream.Size - RtfStream.Position);
    finally
      FileStream.Free;
    end;
    exit;
  end;

  if CurrentConverter <> 0 then
    raise Exception.Create(rsBusy);

  Stream := RtfStream;
  LoadConverter(Filter);
  try
    if not (Assigned(InitConverter) and LongBool(InitConverter(Application.Handle, PChar(AnsiUpperCase(Application.ExeName))))) then
      raise Exception.Create(rsInitConverterFehlgeschlagen);

    hSubset := StringToHGLOBAL('');
    hDesc := StringToHGLOBAL('');
    hFileName := StringToHGLOBAL(FileName);
    hBuf := GlobalAlloc(GHND, BufferSize + 1);
    try
      Result := -1;

      if Assigned(RtfToForeign) then
        Result := RtfToForeign(hFileName, nil, hBuf, hDesc, Writing);

      if Result <> 0 then
        raise Exception.Create(rsExportFehler);

    finally
      GlobalFree(hBuf);
      GlobalFree(hFileName);
      GlobalFree(hDesc);
      GlobalFree(hSubset);
    end;
  finally
    FreeConverter;
    Stream := nil;
  end;
end;

procedure ExportFromRtf(Filter: Integer; RtfStream: TStream; FileName: string);
begin
  ExportFromRtf(ExportFilters[Filter], RtfStream, FileName);
end;

initialization
finalization
  FreeConverter;
  FImportFilters.Free;
  FImportFilters := nil;
  FExportFilters.Free;
  FExportFilters := nil;
end.

