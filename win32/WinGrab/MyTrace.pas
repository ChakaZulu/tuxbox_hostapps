////////////////////////////////////////////////////////////////////////////////
//
// $Log: MyTrace.pas,v $
// Revision 1.3  2004/10/15 13:39:16  thotto
// neue Db-Klasse
//
// Revision 1.2  2004/10/11 15:33:39  thotto
// Bugfixes
//
// Revision 1.1  2004/07/02 13:58:39  thotto
// initial
//
//
unit MyTrace;

interface

uses
  Classes,
  Windows,
  Registry,
  SysUtils,
  DelTools;

const  TRACE_KEY_SERVICE  = 'System\CurrentControlSet\Services';
const  TRACE_KEY          = 'Software\GNU';
const  TRACE_FILE_VAL     = 'TraceFile';
const  TRACE_LEVEL_VAL    = 'TraceLevel';
const  TRACE_MODE_VAL			= 'TraceMode';

const  TRACE_ERROR        = $00000000;
const  TRACE_MIN          = $00000001;
const  TRACE_CALLSTACK    = $00000002;
const  TRACE_DETAIL       = $00000008;
const  TRACE_SYNC				  = $00000010;
const  TRACE_CRYPT				= $00000020;
const  TRACE_SIGNAL			  = $00000040;
const  TRACE_TOOLS	      = $00000080;
const  TRACE_ALL  	      = $FFFFFFFF;

type
  TTrace = class(TObject)
  private
  	m_strModul     : String;
		m_strRegKey    : String;
		m_bTraceInit   : Boolean;

		m_bTraceFile   : Boolean;
    m_TraceFile    : String;

    m_lTraceId     : LongInt;

    m_strMsgPrefix : String;

  protected

  public
    procedure DBMSG_INIT( szBaseKey, szProduct, szVersion, szPackage, szModule: String );
    function  DBMSG_IsInit(): Boolean;
    procedure DBMSG_DONE();

    procedure DBMSG( DebugLevel: DWORD; Msg: String );


  end;

implementation

////////////////////////////////////////////////////////////////////////////////////////////
//
//
//
procedure TTrace.DBMSG_INIT( szBaseKey,
                             szProduct,
                             szVersion,
                             szPackage,
                             szModule: String );
var
  strHelper,
  sTrace,
  sNow      : String;
  F         : TextFILE;
//  dwDbgMode,
  dwDbgLevel: DWORD;
begin
  m_bTraceInit := false;
  try
    dwDbgLevel:= 0;
    
    DateSeparator   := '-';
    ShortDateFormat := 'yyyy/m/d';
    TimeSeparator   := '.';

		m_lTraceId  := GetCurrentThreadId();
    m_strMsgPrefix :='';

		if (Length(szBaseKey) > 0) then
		begin
  		strHelper    := szBaseKey;
    end else
    begin
  		strHelper    := TRACE_KEY;
		end;
		if (Length(szProduct) > 0) then
		begin
			strHelper    := strHelper + '\' + szProduct;
		end;
		if (Length(szVersion) > 0) then
		begin
			strHelper    := strHelper + '\' + szVersion;
		end;
		if (Length(szPackage) > 0) then
		begin
			strHelper    := strHelper + '\' + szPackage;
		end;
		if (Length(szModule) > 0) then
		begin
			strHelper    := strHelper + '\' + szModule;
			m_strModul   := szModule;
			m_bTraceFile := true;
		end;
		m_strRegKey := strHelper;

    with TRegistry.Create() do
    try
      RootKey := HKEY_CURRENT_USER;
      if OpenKey(m_strRegKey, True) then
      begin
        try
        m_TraceFile:= ReadString( TRACE_FILE_VAL );
        finally
          if m_TraceFile = '' then
          begin
            m_TraceFile := GetEnvironmentVariable('TEMP') + '\'+ m_strModul;
            WriteString(TRACE_FILE_VAL, m_TraceFile);
          end;
        end;
        m_TraceFile := m_TraceFile + '_' + DateTimeToStr(Date) + '.log';
        try
          dwDbgLevel := ReadInteger(TRACE_LEVEL_VAL);
        except
          WriteInteger(TRACE_LEVEL_VAL, 1);
        end;
{
        try
          dwDbgMode := ReadInteger(TRACE_MODE_VAL);
        except
          WriteInteger(TRACE_MODE_VAL, 0);
        end;
}

      end;
    finally
      Free;
      inherited;
    end;

    if (dwDbgLevel > 0)	AND m_bTraceFile then
    begin
      try
        AssignFile(F, m_TraceFile);
        IF not FileExists(m_TraceFile) then Rewrite(F);
        Append(F);

        sNow := '';
        DateTimeToString(sNow, 'DD.MM.YYYY hh:nn:ss.zzz', Now);
        sTrace := Format('%s ########### TRACE INIT ###########',
                         [sNow]);
        Writeln(F, sTrace);
        OutputDebugString(PChar(sTrace));
        sTrace:= Format('%s Product: %s',
                        [sNow,szProduct]);
        Writeln(F, sTrace);
        OutputDebugString(PChar(sTrace));
        sTrace:= Format('%s Version: %s',
                        [sNow,szVersion]);
        Writeln(F, sTrace);
        OutputDebugString(PChar(sTrace));
        sTrace:= Format('%s Package: %s',
                        [sNow,szPackage]);
        Writeln(F, sTrace);
        OutputDebugString(PChar(sTrace));
        sTrace:= Format('%s Module:  %s',
                        [sNow,szModule]);
        Writeln(F, sTrace);
        OutputDebugString(PChar(sTrace));
        Flush(F);
        CloseFile(F);
      except
        on E: Exception do OutputDebugString(PChar(E.Message));
      end;
    end;
    m_bTraceInit := true;
  except
    on E: Exception do OutputDebugString(PChar(E.Message));
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////
//
//
//
function  TTrace.DBMSG_IsInit(): Boolean;
begin
  Result := Boolean(m_lTraceId)
end;

////////////////////////////////////////////////////////////////////////////////////////////
//
//
//
procedure TTrace.DBMSG_DONE();
begin

end;

////////////////////////////////////////////////////////////////////////////////////////////
//
//
//
procedure TTrace.DBMSG( DebugLevel: DWORD; Msg: String );
var
  dwDbgLevel : DWORD;
//  dwDbgMode  : DWORD;
  sTrace,
//  sTmp,
  sNow       : String;
  F          : TextFILE;
begin
  try
    dwDbgLevel := 0;
//    dwDbgMode  := 0;

    with TRegistry.Create() do
    try
      RootKey := HKEY_CURRENT_USER;
      if OpenKey(m_strRegKey, True) then
      begin
        try
        m_TraceFile:= ReadString( TRACE_FILE_VAL );
        finally
          if m_TraceFile = '' then
          begin
            m_TraceFile := GetEnvironmentVariable('TEMP') + '\'+ m_strModul;
            WriteString(TRACE_FILE_VAL, m_TraceFile);
          end;
        end;
        m_TraceFile := m_TraceFile + '_' + DateTimeToStr(Date) + '.log';
        try
          dwDbgLevel := ReadInteger(TRACE_LEVEL_VAL);
        except
          WriteInteger(TRACE_LEVEL_VAL, 0);
        end;
//        dwDbgMode  := ReadInteger(TRACE_MODE_VAL);
      end;
    finally
      Free;
      inherited;
    end;

    if DebugLevel = TRACE_CALLSTACK then
    begin
      if Pos('<', Msg) = 1 then
      begin
        m_strMsgPrefix := Copy(m_strMsgPrefix,1,Length(m_strMsgPrefix)-2);
      end;
    end;

    sNow := '';
    DateTimeToString(sNow, 'DD.MM.YYYY hh:nn:ss.zzz', Now);
    sTrace := Format('%s %s%s', [sNow,m_strMsgPrefix,Msg]);

    if DebugLevel = TRACE_CALLSTACK then
    begin
      if Pos('>', Msg) = 1 then
      begin
        m_strMsgPrefix := m_strMsgPrefix + '  ';
      end;
    end;

    if dwDbgLevel >= DebugLevel then
    begin
      OutputDebugString(PChar(sTrace));
      if (dwDbgLevel > 0)	AND m_bTraceFile then
      begin
        try
          AssignFile(F, m_TraceFile);
          if not FileExists(m_TraceFile) then
          begin
            Rewrite(F);
          end;
          Append(F);
          Writeln(F, sTrace);
          Flush(F);
          CloseFile(F);
        except
          on E: Exception do OutputDebugString(PChar(E.Message));
        end;
      end;
    end;

  except
    on E: Exception do OutputDebugString(PChar(E.Message));
  end;
end;


end.
