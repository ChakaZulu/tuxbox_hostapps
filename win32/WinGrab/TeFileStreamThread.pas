unit TeFileStreamThread;

interface

uses
  Windows,
  Classes, SysUtils,
  TeBase, TeThrd, TeSocket, TeFiFo, TeLogableThread;

type
  TTeReaderFileStreamThread = class(TTeLogableThread)
  private
    rfstFileName: string;
    rfstFile: HFILE;
    rfstFileCounter: Integer;
    rfstFiFo: TTeFiFoBuffer;
  protected
    procedure DoBeforeExecute; override;
    procedure DoAfterExecute; override;
    procedure InnerExecute; override;
  public
    constructor Create(aLog: ILog; aThreadPriority: TThreadPriority; aFileName: string; aFiFo: TTeFiFoBuffer);
    destructor Destroy; override;
  end;

  TTeWriterFileStreamThread = class(TTeLogableThread)
  private
    wfstFileName: string;
    wfstFile: HFILE;
    wfstFiFo: TTeFiFoBuffer;
    wfstSupportSplitting: Boolean;
    wfstFileNo: Integer;
    wfstCurrentFileName: string;
    function GetFileName: string;
  protected
    procedure DoBeforeExecute; override;
    procedure DoAfterExecute; override;
    procedure InnerExecute; override;
  public
    constructor Create(aLog: ILog; aThreadPriority: TThreadPriority; aFileName: string; aFiFo: TTeFiFoBuffer; aSupportSplitting: Boolean);
    destructor Destroy; override;
  end;

implementation

{ TTeReaderFileStreamThread }

constructor TTeReaderFileStreamThread.Create(aLog: ILog; aThreadPriority: TThreadPriority; aFileName: string; aFiFo: TTeFiFoBuffer);
begin
  rfstFileName := aFileName;
  rfstFiFo := aFiFo;
  inherited Create(aLog, aThreadPriority);
end;

destructor TTeReaderFileStreamThread.Destroy;
begin
  rfstFiFo.Shutdown;
  inherited;
end;

procedure TTeReaderFileStreamThread.DoAfterExecute;
begin
  rfstFiFo.Shutdown;
  if rfstFile <> INVALID_HANDLE_VALUE then
    CloseHandle(rfstFile);
  rfstFile := INVALID_HANDLE_VALUE;
end;

procedure TTeReaderFileStreamThread.DoBeforeExecute;
begin
  rfstFile := INVALID_HANDLE_VALUE;
  try
    rfstFile := CreateFile(PChar(rfstFileName), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
    if rfstFile = INVALID_HANDLE_VALUE then
      RaiseLastWin32Error;
    inherited;
  except
    if rfstFile <> INVALID_HANDLE_VALUE then
      CloseHandle(rfstFile);
    rfstFile := INVALID_HANDLE_VALUE;
    raise;
  end;
end;

function FileSeek64(Handle: Integer; const Offset: Int64; Origin: Integer): Int64;
begin
  Result := Offset;
  Int64Rec(Result).Lo := SetFilePointer(THandle(Handle), Int64Rec(Result).Lo,
    @Int64Rec(Result).Hi, Origin);
end;

procedure TTeReaderFileStreamThread.InnerExecute;
var
  FileSize                    : Int64;
  BytesRead                   : Int64;
  FileName                    : string;
  s                           : string;
const
  Int64Null                   : Int64 = 0;
begin
  FileName := rfstFileName;
  BytesRead := 0;
  FileSize := FileSeek64(rfstFile, Int64Null, 2);
  FileSeek(rfstFile, Int64Null, 0);
  while not Terminated do begin
    if FileSize >= rfstFiFo.PageSize then
      with rfstFiFo.GetWritePage do try
        FileRead(rfstFile, Memory^, Size);
      finally
        Finished;
      end
    else
      with rfstFiFo.GetWritePage(FileSize) do try
        FileRead(rfstFile, Memory^, Size);
      finally
        Finished;
      end;
    Inc(BytesRead, rfstFiFo.PageSize);
    SetState('reading "' + FileName + '" [' + IntToStr(BytesRead div 1024) + ' KB]');
    Dec(FileSize, rfstFiFo.PageSize);
    if FileSize <= 0 then begin
      LogMessage('eof: ' + FileName);
      Inc(rfstFileCounter);
      s := IntToStr(rfstFileCounter);
      if Length(s) < 3 then
        s := StringOfChar('0', 3 - Length(s)) + s;
      FileName := rfstFileName + '.' + s;
      if FileExists(FileName) then begin
        LogMessage('changing to next file: ' + FileName);
        CloseHandle(rfstFile);
        rfstFile := CreateFile(PChar(FileName), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
        if rfstFile = INVALID_HANDLE_VALUE then
          RaiseLastWin32Error;
        BytesRead := 0;
        FileSize := FileSeek64(rfstFile, Int64Null, 2);
        FileSeek(rfstFile, Int64Null, 0);
      end else
        Exit;
    end;
  end;
end;

{ TTeWriterFileStreamThread }

constructor TTeWriterFileStreamThread.Create(aLog: ILog; aThreadPriority: TThreadPriority; aFileName: string; aFiFo: TTeFiFoBuffer; aSupportSplitting: Boolean);
begin
  wfstFileNo := 1;
  wfstSupportSplitting := aSupportSplitting;
  wfstFileName := aFileName;
  wfstFiFo := aFiFo;
  inherited Create(aLog, aThreadPriority);
end;

destructor TTeWriterFileStreamThread.Destroy;
begin
  wfstFiFo.Shutdown;
  inherited;
end;

procedure TTeWriterFileStreamThread.DoAfterExecute;
begin
  wfstFiFo.Shutdown;
  if wfstFile <> INVALID_HANDLE_VALUE then
    CloseHandle(wfstFile);
  wfstFile := INVALID_HANDLE_VALUE;
end;

procedure TTeWriterFileStreamThread.DoBeforeExecute;
begin
  wfstFile := INVALID_HANDLE_VALUE;
  try
    wfstFile := CreateFile(PChar(GetFileName), GENERIC_WRITE, FILE_SHARE_READ, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
    if wfstFile = INVALID_HANDLE_VALUE then
      RaiseLastWin32Error;
    inherited;
  except
    if wfstFile <> INVALID_HANDLE_VALUE then
      CloseHandle(wfstFile);
    wfstFile := INVALID_HANDLE_VALUE;
    raise;
  end;
end;

function TTeWriterFileStreamThread.GetFileName: string;
var
  Ext                         : string;
  S                           : string;
begin
  if wfstSupportSplitting then begin
    s := IntToStr(wfstFileNo);
    while Length(s) < 2 do
      s := '0' + s;
    Ext := ExtractFileExt(wfstFileName);
    Result := ChangeFileExt(wfstFileName, '');
    Result := Result + '[' + s + ']' + Ext;
  end else
    Result := wfstFileName;
  wfstCurrentFileName := Result;
end;

procedure TTeWriterFileStreamThread.InnerExecute;
var
  BytesWritten                : Int64;
begin
  SetState('waiting for first data');
  BytesWritten := 0;
  while not Terminated do
    with wfstFiFo.GetReadPage(true) do try
      if FileWrite(wfstFile, Memory^, Size) <> Size then
        RaiseLastWin32Error;
      FlushFileBuffers(wfstFile);
      Inc(BytesWritten, Size);
      SetState('writing "' + wfstCurrentFileName + '" [' + IntToStr(BytesWritten div 1024) + ' KB]');
      if wfstSupportSplitting and (Marker = bmNextFile) then begin
        CloseHandle(wfstFile);
        Inc(wfstFileNo);
        wfstFile := CreateFile(PChar(GetFileName), GENERIC_WRITE, FILE_SHARE_READ, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
        if wfstFile = INVALID_HANDLE_VALUE then
          RaiseLastWin32Error;
        BytesWritten := 0;
      end;
    finally
      Finished;
    end;
end;

end.

