unit WinGrabLibrary;

interface

uses
  ComObj, ActiveX, WinGrabEngine_TLB, StdVcl, TeGrabManager;

type
  TWinGrabLibrary = class(TAutoObject, IWinGrabLibrary)
  protected
    function StartDirectGrab(const aIP: WideString; aVideoPID: Integer;
      aAudioPIDs: OleVariant; const aVideoFileName: WideString;
      aAudioFileNames: OleVariant; aStripVideoPes: WordBool;
      aStripAudioPes: OleVariant): IDispatch; safecall;
    function StartMuxGrab(const aIP: WideString; aVideoPID: Integer;
      aAudioPIDs: OleVariant; const aMuxFileName: WideString;
      aSplittSize: Integer): IDispatch; safecall;
    function StartDirectGrabEx(const aIP: WideString; aVideoPID: Integer;
      aAudioPIDs: OleVariant; const aVideoFileName: WideString;
      aAudioFileNames: OleVariant; aStripVideoPes: WordBool;
      aStripAudioPes: OleVariant;
      const aCallback: IWinGrabProcessCallback): IWinGrabGrabControl;
      safecall;
    function StartMuxGrabEx(const aIP: WideString; aVideoPID: Integer;
      aAudioPIDs: OleVariant; const aMuxFileName: WideString;
      aSplittSize: Integer;
      const aCallback: IWinGrabProcessCallback): IWinGrabGrabControl;
      safecall;
    function StartMux(const aVideoFileName: WideString; aVideoStartOffset,
      aVideoEndOffset: Integer; aAudioFileNames: OleVariant;
      const aMuxFileName: WideString; aSplittSize: Integer): IDispatch;
      safecall;
    function StartMuxEx(const aVideoFileName: WideString; aVideoStartOffset,
      aVideoEndOffset: Integer; aAudioFileNames: OleVariant;
      const aMuxFileName: WideString; aSplittSize: Integer;
      const aCallback: IWinGrabProcessCallback): IWinGrabGrabControl;
      safecall;
    { Protected-Deklarationen }
  end;

implementation

uses
  SysUtils,
  ComServ, Dialogs,
  WinGrabGrabControl;

function TWinGrabLibrary.StartDirectGrab(const aIP: WideString;
  aVideoPID: Integer; aAudioPIDs: OleVariant;
  const aVideoFileName: WideString; aAudioFileNames: OleVariant;
  aStripVideoPes: WordBool; aStripAudioPes: OleVariant): IDispatch;
var
  hAudioPIDs                  : array of Integer;
  hAudioFileNames             : array of string;
  hStripAudioPes              : array of Boolean;
  DirectGrabManager           : TTeDirectGrabManager;
begin
  try
    hAudioPIDs := aAudioPIDs;
  except
    SetLength(hAudioPIDs, 1);
    hAudioPIDs[0] := aAudioPIDs;
  end;

  try
    hAudioFileNames := aAudioFileNames;
  except
    SetLength(hAudioFileNames, 1);
    hAudioFileNames[0] := aAudioFileNames;
  end;

  try
    hStripAudioPes := aStripAudioPes;
  except
    SetLength(hStripAudioPes, 1);
    hStripAudioPes[0] := aStripAudioPes;
  end;

  if (Length(hAudioPIDs) <> Length(hAudioFileNames)) or (Length(hAudioPIDs) <> Length(hStripAudioPes)) then
    raise Exception.Create('Anzahl von aAudioPIDs, aAudioFileNames und aStripAudioPes unterscheidet sich');

  DirectGrabManager := TTeDirectGrabManager.Create(
    aIP,
    aVideoPID,
    hAudioPIDs,
    aVideoFileName,
    hAudioFileNames,
    aStripVideoPes,
    hStripAudioPes,
    nil,
    nil); ;

  Result := TWinGrabGrabControl.Create(DirectGrabManager, nil);
end;

function TWinGrabLibrary.StartMuxGrab(const aIP: WideString;
  aVideoPID: Integer; aAudioPIDs: OleVariant;
  const aMuxFileName: WideString; aSplittSize: Integer): IDispatch;
var
  hAudioPIDs                  : array of Integer;
  MuxGrabManager              : TTeMuxGrabManager;
begin
  try
    hAudioPIDs := aAudioPIDs;
  except
    SetLength(hAudioPIDs, 1);
    hAudioPIDs[0] := aAudioPIDs;
  end;

  MuxGrabManager := TTeMuxGrabManager.Create(
    aIP,
    aVideoPID,
    hAudioPIDs,
    aMuxFileName,
    aSplittSize,
    nil,
    nil); ;

  Result := TWinGrabGrabControl.Create(MuxGrabManager, nil);
end;

function TWinGrabLibrary.StartDirectGrabEx(const aIP: WideString;
  aVideoPID: Integer; aAudioPIDs: OleVariant;
  const aVideoFileName: WideString; aAudioFileNames: OleVariant;
  aStripVideoPes: WordBool; aStripAudioPes: OleVariant;
  const aCallback: IWinGrabProcessCallback): IWinGrabGrabControl;
var
  hAudioPIDs                  : array of Integer;
  hAudioFileNames             : array of string;
  hStripAudioPes              : array of Boolean;
  DirectGrabManager           : TTeDirectGrabManager;
  CallbackHandler             : TWinGrabCallbackHandler;
begin
  try
    hAudioPIDs := aAudioPIDs;
  except
    SetLength(hAudioPIDs, 1);
    hAudioPIDs[0] := aAudioPIDs;
  end;

  try
    hAudioFileNames := aAudioFileNames;
  except
    SetLength(hAudioFileNames, 1);
    hAudioFileNames[0] := aAudioFileNames;
  end;

  try
    hStripAudioPes := aStripAudioPes;
  except
    SetLength(hStripAudioPes, 1);
    hStripAudioPes[0] := aStripAudioPes;
  end;

  if (Length(hAudioPIDs) <> Length(hAudioFileNames)) or (Length(hAudioPIDs) <> Length(hStripAudioPes)) then
    raise Exception.Create('Anzahl von aAudioPIDs, aAudioFileNames und aStripAudioPes unterscheidet sich');

  if Assigned(aCallback) then begin
    CallbackHandler := TWinGrabCallbackHandler.Create(aCallback);
    DirectGrabManager := TTeDirectGrabManager.Create(
      aIP,
      aVideoPID,
      hAudioPIDs,
      aVideoFileName,
      hAudioFileNames,
      aStripVideoPes,
      hStripAudioPes,
      CallbackHandler.OnMessage,
      CallbackHandler.OnStateChange);
  end else begin
    CallbackHandler := nil;
    DirectGrabManager := TTeDirectGrabManager.Create(
      aIP,
      aVideoPID,
      hAudioPIDs,
      aVideoFileName,
      hAudioFileNames,
      aStripVideoPes,
      hStripAudioPes,
      nil,
      nil); ;
  end;

  Result := TWinGrabGrabControl.Create(DirectGrabManager, CallbackHandler);
end;

function TWinGrabLibrary.StartMuxGrabEx(const aIP: WideString;
  aVideoPID: Integer; aAudioPIDs: OleVariant;
  const aMuxFileName: WideString; aSplittSize: Integer;
  const aCallback: IWinGrabProcessCallback): IWinGrabGrabControl;
var
  hAudioPIDs                  : array of Integer;
  hAudioFileNames             : array of string;
  hStripAudioPes              : array of Boolean;
  MuxGrabManager              : TTeMuxGrabManager;
  CallbackHandler             : TWinGrabCallbackHandler;
begin
  try
    hAudioPIDs := aAudioPIDs;
  except
    SetLength(hAudioPIDs, 1);
    hAudioPIDs[0] := aAudioPIDs;
  end;

//  ShowMessage(aIP);
//  ShowMessage(IntToStr(hAudioPIDs[0]));

  if Assigned(aCallback) then begin
    CallbackHandler := TWinGrabCallbackHandler.Create(aCallback);
    MuxGrabManager := TTeMuxGrabManager.Create(
      aIP,
      aVideoPID,
      hAudioPIDs,
      aMuxFileName,
      aSplittSize,
      CallbackHandler.OnMessage,
      CallbackHandler.OnStateChange);
  end else begin
    CallbackHandler := nil;
    MuxGrabManager := TTeMuxGrabManager.Create(
      aIP,
      aVideoPID,
      hAudioPIDs,
      aMuxFileName,
      aSplittSize,
      nil,
      nil); ;
  end;

  Result := TWinGrabGrabControl.Create(MuxGrabManager, CallbackHandler);
end;

function TWinGrabLibrary.StartMux(const aVideoFileName: WideString;
  aVideoStartOffset, aVideoEndOffset: Integer; aAudioFileNames: OleVariant;
  const aMuxFileName: WideString; aSplittSize: Integer): IDispatch;
var
  hAudioFileNames             : array of string;
  MuxProcessManager           : TTeMuxProcessManager;
begin
  try
    hAudioFileNames := aAudioFileNames;
  except
    SetLength(hAudioFileNames, 1);
    hAudioFileNames[0] := aAudioFileNames;
  end;

  MuxProcessManager := TTeMuxProcessManager.Create(
    aVideoFileName,
    aVideoStartOffset,
    aVideoEndOffset,
    hAudioFileNames,
    aMuxFileName,
    aSplittSize,
    nil,
    nil);

  Result := TWinGrabGrabControl.Create(MuxProcessManager, nil);
end;

function TWinGrabLibrary.StartMuxEx(const aVideoFileName: WideString;
  aVideoStartOffset, aVideoEndOffset: Integer; aAudioFileNames: OleVariant;
  const aMuxFileName: WideString; aSplittSize: Integer;
  const aCallback: IWinGrabProcessCallback): IWinGrabGrabControl;
var
  hAudioFileNames             : array of string;
  MuxProcessManager           : TTeMuxProcessManager;
  CallbackHandler             : TWinGrabCallbackHandler;
begin
  try
    hAudioFileNames := aAudioFileNames;
  except
    SetLength(hAudioFileNames, 1);
    hAudioFileNames[0] := aAudioFileNames;
  end;

  if Assigned(aCallback) then begin
    CallbackHandler := TWinGrabCallbackHandler.Create(aCallback);
    MuxProcessManager := TTeMuxProcessManager.Create(
      aVideoFileName,
      aVideoStartOffset,
      aVideoEndOffset,
      hAudioFileNames,
      aMuxFileName,
      aSplittSize,
      CallbackHandler.OnMessage,
      CallbackHandler.OnStateChange);
  end else begin
    CallbackHandler := nil;
    MuxProcessManager := TTeMuxProcessManager.Create(
      aVideoFileName,
      aVideoStartOffset,
      aVideoEndOffset,
      hAudioFileNames,
      aMuxFileName,
      aSplittSize,
      nil,
      nil);
  end;

  Result := TWinGrabGrabControl.Create(MuxProcessManager, CallbackHandler);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TWinGrabLibrary, Class_WinGrabLibrary,
    ciMultiInstance, tmApartment);
end.

