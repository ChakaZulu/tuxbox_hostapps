{*******************************************************}
{                                                       }
{       Based on:                                       }
{                                                       }
{       Borland Delphi Visual Component Library         }
{       Windows socket components                       }
{                                                       }
{       Copyright (c) 1997,99 Inprise Corporation       }
{                                                       }
{*******************************************************}

unit TeSocket;

interface

uses
  Windows, Messages, WinSock2,
  SysUtils, Classes,
  JclSynch,
  TeBase, TeThrd;

type
  EteSocketError = class(ETeError);

  TJclSimpleEvent = class(TJclEvent)
  public
    constructor Create;
  end;

  TTeCustomWinSocket = class;
  TTeCustomSocket = class;
  TTeServerAcceptThread = class;
  TTeServerClientThread = class;
  TTeServerWinSocket = class;
  TTeServerClientWinSocket = class;

  TTeSocketEvent = (seLookup, seConnecting, seConnect, seDisconnect, seListen,
    seAccept, seWrite, seRead);
  TTeErrorEvent = (eeGeneral, eeSend, eeReceive, eeConnect, eeDisconnect, eeAccept);

  TTeSocketEventEvent = procedure(Sender: TObject; Socket: TTeCustomWinSocket;
    SocketEvent: TTeSocketEvent) of object;
  TTeSocketErrorEvent = procedure(Sender: TObject; Socket: TTeCustomWinSocket;
    ErrorEvent: TTeErrorEvent; var ErrorCode: Integer) of object;
  TTeGetSocketEvent = procedure(Sender: TObject; Socket: TSocket;
    var ClientSocket: TTeServerClientWinSocket) of object;
  TTeGetThreadEvent = procedure(Sender: TObject; ClientSocket: TTeServerClientWinSocket;
    var SocketThread: TTeServerClientThread) of object;
  TTeSocketNotifyEvent = procedure(Sender: TObject; Socket: TTeCustomWinSocket) of object;

  TTeCustomWinSocket = class
  private
    cwsSocket: TSocket;
    cwsConnected: Boolean;
    cwsSendStream: TStream;
    cwsDropAfterSend: Boolean;
    cwsAddr: TSockAddrIn;
    cwsOnSocketEvent: TTeSocketEventEvent;
    cwsOnErrorEvent: TTeSocketErrorEvent;
    cwsSocketLock: TJclCriticalSection;
    cwsData: Pointer;
    // Used during non-blocking host and service lookups
    function SendStreamPiece: Boolean;
    function GetLocalHost: string;
    function GetLocalAddress: string;
    function GetLocalPort: Integer;
    function GetRemoteHost: string;
    function GetRemoteAddress: string;
    function GetRemotePort: Integer;
    function GetRemoteAddr: TSockAddrIn;
    procedure DoSetAsyncStyles;
  protected
    procedure DoOpen;
    procedure DoListen(QueueSize: Integer);
    function InitSocket(const Name, Address, Service: string; Port: Word;
      Client: Boolean): TSockAddrIn;
    procedure Event(Socket: TTeCustomWinSocket; SocketEvent: TTeSocketEvent); dynamic;
    procedure Error(Socket: TTeCustomWinSocket; ErrorEvent: TTeErrorEvent;
      var ErrorCode: Integer); dynamic;
  public
    constructor Create(aSocket: TSocket);
    destructor Destroy; override;
    procedure Close;
    procedure Lock;
    procedure Unlock;
    procedure Listen(const Name, Address, Service: string; Port: Word;
      QueueSize: Integer);
    procedure Open(const Name, Address, Service: string; Port: Word);
    procedure Accept(Socket: TSocket); virtual;
    procedure Connect(Socket: TSocket); virtual;
    procedure Disconnect(Socket: TSocket); virtual;
    procedure Read(Socket: TSocket); virtual;
    procedure Write(Socket: TSocket); virtual;
    function LookupName(const name: string): TInAddr;
    function LookupService(const service: string): Integer;

    function ReceiveLength: Integer;
    function ReceiveBuf(var Buf; Count: Integer; Peek: Boolean = False): Integer;
    function ReceiveText(Peek: Boolean = False): string;
    function SendBuf(var Buf; Count: Integer): Integer;
    function SendStream(aStream: TStream): Boolean;
    function SendStreamThenDrop(aStream: TStream): Boolean;
    function SendText(const S: string): Integer;

    property LocalHost: string read GetLocalHost;
    property LocalAddress: string read GetLocalAddress;
    property LocalPort: Integer read GetLocalPort;

    property RemoteHost: string read GetRemoteHost;
    property RemoteAddress: string read GetRemoteAddress;
    property RemotePort: Integer read GetRemotePort;
    property RemoteAddr: TSockAddrIn read GetRemoteAddr;

    property Connected: Boolean read cwsConnected;
    property Addr: TSockAddrIn read cwsAddr;
    property SocketHandle: TSocket read cwsSocket;

    property OnSocketEvent: TTeSocketEventEvent read cwsOnSocketEvent write cwsOnSocketEvent;
    property OnErrorEvent: TTeSocketErrorEvent read cwsOnErrorEvent write cwsOnErrorEvent;

    property Data: Pointer read cwsData write cwsData;
  end;

  TTeClientWinSocket = class(TTeCustomWinSocket)
  public
    procedure Connect(Socket: TSocket); override;
  end;

  TTeServerClientWinSocket = class(TTeCustomWinSocket)
  private
    scwsServerWinSocket: TTeServerWinSocket;
  public
    constructor Create(Socket: TSocket; ServerWinSocket: TTeServerWinSocket);
    destructor Destroy; override;

    property ServerWinSocket: TTeServerWinSocket read scwsServerWinSocket;
  end;

  TTeThreadNotifyEvent = procedure(Sender: TObject;
    Thread: TTeServerClientThread) of object;

  TTeServerWinSocket = class(TTeCustomWinSocket)
  private
    swsThreadCacheSize: Integer;
    swsConnections: TList;
    swsActiveThreads: TList;
    swsListLock: TJclCriticalSection;
    swsServerAcceptThread: TTeServerAcceptThread;
    swsOnGetSocket: TTeGetSocketEvent;
    swsOnGetThread: TTeGetThreadEvent;
    swsOnThreadStart: TTeThreadNotifyEvent;
    swsOnThreadEnd: TTeThreadNotifyEvent;
    swsOnClientConnect: TTeSocketNotifyEvent;
    swsOnClientDisconnect: TTeSocketNotifyEvent;
    swsOnClientRead: TTeSocketNotifyEvent;
    swsOnClientWrite: TTeSocketNotifyEvent;
    swsOnClientError: TTeSocketErrorEvent;
    procedure AddClient(aClient: TTeServerClientWinSocket);
    procedure RemoveClient(aClient: TTeServerClientWinSocket);
    procedure AddThread(aThread: TTeServerClientThread);
    procedure RemoveThread(aThread: TTeServerClientThread);
    procedure ClientEvent(Sender: TObject; Socket: TTeCustomWinSocket;
      SocketEvent: TTeSocketEvent);
    procedure ClientError(Sender: TObject; Socket: TTeCustomWinSocket;
      ErrorEvent: TTeErrorEvent; var ErrorCode: Integer);
    function GetActiveConnections: Integer;
    function GetActiveThreads: Integer;
    function GetConnections(Index: Integer): TTeCustomWinSocket;
    function GetIdleThreads: Integer;
  protected
    function DoCreateThread(ClientSocket: TTeServerClientWinSocket): TTeServerClientThread; virtual;
    procedure Listen(var Name, Address, Service: string; Port: Word;
      QueueSize: Integer);
    procedure SetThreadCacheSize(Value: Integer);
    procedure ThreadEnd(aThread: TTeServerClientThread); dynamic;
    procedure ThreadStart(aThread: TTeServerClientThread); dynamic;
    function GetClientSocket(Socket: TSocket): TTeServerClientWinSocket; dynamic;
    function GetServerThread(ClientSocket: TTeServerClientWinSocket): TTeServerClientThread; dynamic;
    procedure ClientRead(Socket: TTeCustomWinSocket); dynamic;
    procedure ClientWrite(Socket: TTeCustomWinSocket); dynamic;
    procedure ClientConnect(Socket: TTeCustomWinSocket); dynamic;
    procedure ClientDisconnect(Socket: TTeCustomWinSocket); dynamic;
    procedure ClientErrorEvent(Socket: TTeCustomWinSocket; ErrorEvent: TTeErrorEvent;
      var ErrorCode: Integer); dynamic;
  public
    constructor Create(aSocket: TSocket);
    destructor Destroy; override;
    procedure Accept(Socket: TSocket); override;
    procedure Disconnect(Socket: TSocket); override;
    function GetClientThread(ClientSocket: TTeServerClientWinSocket): TTeServerClientThread;
    property ActiveConnections: Integer read GetActiveConnections;
    property ActiveThreads: Integer read GetActiveThreads;
    property Connections[Index: Integer]: TTeCustomWinSocket read GetConnections;
    property IdleThreads: Integer read GetIdleThreads;
    property ThreadCacheSize: Integer read swsThreadCacheSize write SetThreadCacheSize;
    property OnGetSocket: TTeGetSocketEvent read swsOnGetSocket write swsOnGetSocket;
    property OnGetThread: TTeGetThreadEvent read swsOnGetThread write swsOnGetThread;
    property OnThreadStart: TTeThreadNotifyEvent read swsOnThreadStart write swsOnThreadStart;
    property OnThreadEnd: TTeThreadNotifyEvent read swsOnThreadEnd write swsOnThreadEnd;
    property OnClientConnect: TTeSocketNotifyEvent read swsOnClientConnect write swsOnClientConnect;
    property OnClientDisconnect: TTeSocketNotifyEvent read swsOnClientDisconnect write swsOnClientDisconnect;
    property OnClientRead: TTeSocketNotifyEvent read swsOnClientRead write swsOnClientRead;
    property OnClientWrite: TTeSocketNotifyEvent read swsOnClientWrite write swsOnClientWrite;
    property OnClientError: TTeSocketErrorEvent read swsOnClientError write swsOnClientError;
  end;

  TTeServerAcceptThread = class(TTeThread)
  private
    satServerSocket: TTeServerWinSocket;
  public
    constructor Create(CreateSuspended: Boolean; aSocket: TTeServerWinSocket);
    procedure DoExecute; override;

    property ServerSocket: TTeServerWinSocket read satServerSocket;
  end;

  TTeServerClientThread = class(TTeThread)
  private
    sctClientSocket: TTeServerClientWinSocket;
    sctServerSocket: TTeServerWinSocket;
    sctException: Exception;
    sctEvent: TJclSimpleEvent;
    sctKeepInCache: Boolean;
    sctData: Pointer;
    procedure HandleEvent(Sender: TObject; Socket: TTeCustomWinSocket;
      SocketEvent: TTeSocketEvent);
    procedure HandleError(Sender: TObject; Socket: TTeCustomWinSocket;
      ErrorEvent: TTeErrorEvent; var ErrorCode: Integer);
    procedure DoHandleException; reintroduce;
    procedure DoRead;
    procedure DoWrite;
  protected
    procedure DoTerminate; override;
    procedure DoExecute; override;
    procedure ClientExecute; virtual;
    procedure Event(SocketEvent: TTeSocketEvent); virtual;
    procedure Error(ErrorEvent: TTeErrorEvent; var ErrorCode: Integer); virtual;
    procedure HandleException; virtual;
    procedure ReActivate(aSocket: TTeServerClientWinSocket);
    function StartConnect: Boolean;
    function EndConnect: Boolean;
  public
    constructor Create(CreateSuspended: Boolean; aSocket: TTeServerClientWinSocket);
    destructor Destroy; override;

    property ClientSocket: TTeServerClientWinSocket read sctClientSocket;
    property ServerSocket: TTeServerWinSocket read sctServerSocket;
    property KeepInCache: Boolean read sctKeepInCache write sctKeepInCache;
    property Data: Pointer read sctData write sctData;
  end;

  TTeAbstractSocket = class(TObject)
  private
    asActive: Boolean;
    asPort: Integer;
    asAddress: string;
    asHost: string;
    asService: string;
    procedure DoEvent(Sender: TObject; Socket: TTeCustomWinSocket;
      SocketEvent: TTeSocketEvent);
    procedure DoError(Sender: TObject; Socket: TTeCustomWinSocket;
      ErrorEvent: TTeErrorEvent; var ErrorCode: Integer);
  protected
    procedure Event(Socket: TTeCustomWinSocket; SocketEvent: TTeSocketEvent);
      virtual; abstract;
    procedure Error(Socket: TTeCustomWinSocket; ErrorEvent: TTeErrorEvent;
      var ErrorCode: Integer); virtual; abstract;
    procedure DoActivate(Value: Boolean); virtual; abstract;
    procedure InitSocket(Socket: TTeCustomWinSocket);
    procedure SetActive(Value: Boolean);
    procedure SetAddress(Value: string);
    procedure SetHost(Value: string);
    procedure SetPort(Value: Integer);
    procedure SetService(Value: string);
    property Active: Boolean read asActive write SetActive;
    property Address: string read asAddress write SetAddress;
    property Host: string read asHost write SetHost;
    property Port: Integer read asPort write SetPort;
    property Service: string read asService write SetService;
  public
    procedure Open;
    procedure Close;
  end;

  TTeCustomSocket = class(TTeAbstractSocket)
  private
    csOnLookup: TTeSocketNotifyEvent;
    csOnConnect: TTeSocketNotifyEvent;
    csOnConnecting: TTeSocketNotifyEvent;
    csOnDisconnect: TTeSocketNotifyEvent;
    csOnListen: TTeSocketNotifyEvent;
    csOnAccept: TTeSocketNotifyEvent;
    csOnRead: TTeSocketNotifyEvent;
    csOnWrite: TTeSocketNotifyEvent;
    csOnError: TTeSocketErrorEvent;
  protected
    procedure Event(Socket: TTeCustomWinSocket; SocketEvent: TTeSocketEvent); override;
    procedure Error(Socket: TTeCustomWinSocket; ErrorEvent: TTeErrorEvent;
      var ErrorCode: Integer); override;
    property OnLookup: TTeSocketNotifyEvent read csOnLookup write csOnLookup;
    property OnConnecting: TTeSocketNotifyEvent read csOnConnecting write csOnConnecting;
    property OnConnect: TTeSocketNotifyEvent read csOnConnect write csOnConnect;
    property OnDisconnect: TTeSocketNotifyEvent read csOnDisconnect write csOnDisconnect;
    property OnListen: TTeSocketNotifyEvent read csOnListen write csOnListen;
    property OnAccept: TTeSocketNotifyEvent read csOnAccept write csOnAccept;
    property OnRead: TTeSocketNotifyEvent read csOnRead write csOnRead;
    property OnWrite: TTeSocketNotifyEvent read csOnWrite write csOnWrite;
    property OnError: TTeSocketErrorEvent read csOnError write csOnError;
  end;

  TTeWinSocketStream = class(TStream)
  private
    wssSocket: TTeCustomWinSocket;
    wssTimeout: Longint;
    wssEvent: TJclSimpleEvent;
  public
    constructor Create(aSocket: TTeCustomWinSocket; TimeOut: Longint);
    destructor Destroy; override;
    function WaitForData(Timeout: Longint): Boolean;
    function Read(var Buffer; Count: Longint): Longint; override;
    function Write(const Buffer; Count: Longint): Longint; override;
    function Seek(Offset: Longint; Origin: Word): Longint; override;

    procedure WriteString(aString: string);
    function ReadString: string;

    property TimeOut: Longint read wssTimeout write wssTimeout;
  end;

  TTeClientSocket = class(TTeCustomSocket)
  private
    clsClientSocket: TTeClientWinSocket;
  protected
    procedure DoActivate(Value: Boolean); override;
  public
    constructor Create;
    destructor Destroy; override;
    property Socket: TTeClientWinSocket read clsClientSocket;
  published
    property Active;
    property Address;
    property Host;
    property Port;
    property Service;
    property OnLookup;
    property OnConnecting;
    property OnConnect;
    property OnDisconnect;
    property OnRead;
    property OnWrite;
    property OnError;
  end;

  TTeCustomServerSocket = class(TTeCustomSocket)
  protected
    cssServerSocket: TTeServerWinSocket;
    procedure DoActivate(Value: Boolean); override;
    function GetGetThreadEvent: TTeGetThreadEvent;
    function GetGetSocketEvent: TTeGetSocketEvent;
    function GetThreadCacheSize: Integer;
    function GetOnThreadStart: TTeThreadNotifyEvent;
    function GetOnThreadEnd: TTeThreadNotifyEvent;
    function GetOnClientEvent(Index: Integer): TTeSocketNotifyEvent;
    function GetOnClientError: TTeSocketErrorEvent;
    procedure SetGetThreadEvent(Value: TTeGetThreadEvent);
    procedure SetGetSocketEvent(Value: TTeGetSocketEvent);
    procedure SetThreadCacheSize(Value: Integer);
    procedure SetOnThreadStart(Value: TTeThreadNotifyEvent);
    procedure SetOnThreadEnd(Value: TTeThreadNotifyEvent);
    procedure SetOnClientEvent(Index: Integer; Value: TTeSocketNotifyEvent);
    procedure SetOnClientError(Value: TTeSocketErrorEvent);
    property ThreadCacheSize: Integer read GetThreadCacheSize
      write SetThreadCacheSize;
    property OnGetThread: TTeGetThreadEvent read GetGetThreadEvent
      write SetGetThreadEvent;
    property OnGetSocket: TTeGetSocketEvent read GetGetSocketEvent
      write SetGetSocketEvent;
    property OnThreadStart: TTeThreadNotifyEvent read GetOnThreadStart
      write SetOnThreadStart;
    property OnThreadEnd: TTeThreadNotifyEvent read GetOnThreadEnd
      write SetOnThreadEnd;
    property OnClientConnect: TTeSocketNotifyEvent index 2 read GetOnClientEvent
      write SetOnClientEvent;
    property OnClientDisconnect: TTeSocketNotifyEvent index 3 read GetOnClientEvent
      write SetOnClientEvent;
    property OnClientRead: TTeSocketNotifyEvent index 0 read GetOnClientEvent
      write SetOnClientEvent;
    property OnClientWrite: TTeSocketNotifyEvent index 1 read GetOnClientEvent
      write SetOnClientEvent;
    property OnClientError: TTeSocketErrorEvent read GetOnClientError write SetOnClientError;
  public
    destructor Destroy; override;
  end;

  TTeServerSocket = class(TTeCustomServerSocket)
  public
    constructor Create;
    property Socket: TTeServerWinSocket read cssServerSocket;
  published
    property Active;
    property Port;
    property Service;
    property ThreadCacheSize default 10;
    property OnListen;
    property OnAccept;
    property OnGetThread;
    property OnGetSocket;
    property OnThreadStart;
    property OnThreadEnd;
    property OnClientConnect;
    property OnClientDisconnect;
    property OnClientRead;
    property OnClientWrite;
    property OnClientError;
  end;

  TTeSocketErrorProc = procedure(ErrorCode: Integer);

function SetErrorProc(ErrorProc: TTeSocketErrorProc): TTeSocketErrorProc;

implementation

uses Forms, RTLConsts;

threadvar
  SocketErrorProc                  : TTeSocketErrorProc;

var
  WSAData                          : TWSAData;

function SetErrorProc(ErrorProc: TTeSocketErrorProc): TTeSocketErrorProc;
begin
  Result := SocketErrorProc;
  SocketErrorProc := ErrorProc;
end;

function CheckSocketResult(ResultCode: Integer; const Op: string): Integer;
begin
  if ResultCode <> 0 then begin
    Result := WSAGetLastError;
    if Result <> WSAEWOULDBLOCK then
      if Assigned(SocketErrorProc) then
        SocketErrorProc(Result)
      else raise EteSocketError.CreateResFmt(@sWindowsSocketError,
          [SysErrorMessage(Result), Result, Op]);
  end else Result := 0;
end;

procedure Startup;
var
  ErrorCode                        : Integer;
begin
  ErrorCode := WSAStartup($0202, WSAData);
  if ErrorCode <> 0 then
    raise EteSocketError.CreateResFmt(@sWindowsSocketError,
      [SysErrorMessage(ErrorCode), ErrorCode, 'WSAStartup']);
end;

procedure Cleanup;
var
  ErrorCode                        : Integer;
begin
  ErrorCode := WSACleanup;
  if ErrorCode <> 0 then
    raise EteSocketError.CreateResFmt(@sWindowsSocketError,
      [SysErrorMessage(ErrorCode), ErrorCode, 'WSACleanup']);
end;

{ TTeCustomWinSocket }

constructor TTeCustomWinSocket.Create(aSocket: TSocket);
begin
  inherited Create;
  Startup;
  cwsSocketLock := TJclCriticalSection.Create;
  cwsSocket := aSocket;
  cwsAddr.sin_family := PF_INET;
  cwsAddr.sin_addr.s_addr := INADDR_ANY;
  cwsAddr.sin_port := 0;
  cwsConnected := cwsSocket <> INVALID_SOCKET;
end;

destructor TTeCustomWinSocket.Destroy;
begin
  cwsOnSocketEvent := nil;                                  { disable events }
  if cwsConnected and (cwsSocket <> INVALID_SOCKET) then
    Disconnect(cwsSocket);
  cwsSocketLock.Free;
  Cleanup;
  inherited Destroy;
end;

procedure TTeCustomWinSocket.Accept(Socket: TSocket);
begin
end;

procedure TTeCustomWinSocket.Close;
begin
  Disconnect(cwsSocket);
end;

procedure TTeCustomWinSocket.Connect(Socket: TSocket);
begin
end;

procedure TTeCustomWinSocket.Lock;
begin
  cwsSocketLock.Enter;
end;

procedure TTeCustomWinSocket.Unlock;
begin
  cwsSocketLock.Leave;
end;

procedure TTeCustomWinSocket.DoSetAsyncStyles;
var
  Blocking                         : Cardinal;
begin
  WSAAsyncSelect(cwsSocket, 0, 0, 0);
  Blocking := 0;
  ioctlsocket(cwsSocket, FIONBIO, Blocking);
end;

procedure TTeCustomWinSocket.DoListen(QueueSize: Integer);
begin
  CheckSocketResult(bind(cwsSocket, cwsAddr, SizeOf(cwsAddr)), 'bind');
  DoSetASyncStyles;
  Event(Self, seListen);
  CheckSocketResult(WinSock2.listen(cwsSocket, QueueSize), 'listen');
  cwsConnected := True;
end;

procedure TTeCustomWinSocket.DoOpen;
begin
  DoSetASyncStyles;
  Event(Self, seConnecting);
  CheckSocketResult(WinSock2.connect(cwsSocket, cwsAddr, SizeOf(cwsAddr)), 'connect');
  cwsConnected := cwsSocket <> INVALID_SOCKET;
  Event(Self, seConnect);
end;

function TTeCustomWinSocket.GetLocalAddress: string;
var
  SockAddrIn                       : TSockAddrIn;
  Size                             : Integer;
begin
  Lock;
  try
    Result := '';
    if cwsSocket = INVALID_SOCKET then Exit;
    Size := SizeOf(SockAddrIn);
    if getsockname(cwsSocket, SockAddrIn, Size) = 0 then
      Result := inet_ntoa(SockAddrIn.sin_addr);
  finally
    Unlock;
  end;
end;

function TTeCustomWinSocket.GetLocalHost: string;
var
  LocalName                        : array[0..255] of Char;
begin
  Lock;
  try
    Result := '';
    if cwsSocket = INVALID_SOCKET then Exit;
    if gethostname(LocalName, SizeOf(LocalName)) = 0 then
      Result := LocalName;
  finally
    Unlock;
  end;
end;

function TTeCustomWinSocket.GetLocalPort: Integer;
var
  SockAddrIn                       : TSockAddrIn;
  Size                             : Integer;
begin
  Lock;
  try
    Result := -1;
    if cwsSocket = INVALID_SOCKET then Exit;
    Size := SizeOf(SockAddrIn);
    if getsockname(cwsSocket, SockAddrIn, Size) = 0 then
      Result := ntohs(SockAddrIn.sin_port);
  finally
    Unlock;
  end;
end;

function TTeCustomWinSocket.GetRemoteHost: string;
var
  SockAddrIn                       : TSockAddrIn;
  Size                             : Integer;
  HostEnt                          : PHostEnt;
begin
  Lock;
  try
    Result := '';
    if not cwsConnected then Exit;
    Size := SizeOf(SockAddrIn);
    CheckSocketResult(getpeername(cwsSocket, SockAddrIn, Size), 'getpeername');
    HostEnt := gethostbyaddr(@SockAddrIn.sin_addr.s_addr, 4, PF_INET);
    if HostEnt <> nil then Result := HostEnt.h_name;
  finally
    Unlock;
  end;
end;

function TTeCustomWinSocket.GetRemoteAddress: string;
var
  SockAddrIn                       : TSockAddrIn;
  Size                             : Integer;
begin
  Lock;
  try
    Result := '';
    if not cwsConnected then Exit;
    Size := SizeOf(SockAddrIn);
    CheckSocketResult(getpeername(cwsSocket, SockAddrIn, Size), 'getpeername');
    Result := inet_ntoa(SockAddrIn.sin_addr);
  finally
    Unlock;
  end;
end;

function TTeCustomWinSocket.GetRemotePort: Integer;
var
  SockAddrIn                       : TSockAddrIn;
  Size                             : Integer;
begin
  Lock;
  try
    Result := 0;
    if not cwsConnected then Exit;
    Size := SizeOf(SockAddrIn);
    CheckSocketResult(getpeername(cwsSocket, SockAddrIn, Size), 'getpeername');
    Result := ntohs(SockAddrIn.sin_port);
  finally
    Unlock;
  end;
end;

function TTeCustomWinSocket.GetRemoteAddr: TSockAddrIn;
var
  Size                             : Integer;
begin
  Lock;
  try
    FillChar(Result, SizeOf(Result), 0);
    if not cwsConnected then Exit;
    Size := SizeOf(Result);
    if getpeername(cwsSocket, Result, Size) <> 0 then
      FillChar(Result, SizeOf(Result), 0);
  finally
    Unlock;
  end;
end;

function TTeCustomWinSocket.LookupName(const Name: string): TInAddr;
var
  HostEnt                          : PHostEnt;
  InAddr                           : TInAddr;
begin
  HostEnt := gethostbyname(PChar(Name));
  FillChar(InAddr, SizeOf(InAddr), 0);
  if HostEnt <> nil then begin
    with InAddr, HostEnt^ do begin
      S_un_b.s_b1 := Byte(h_addr^[0]);
      S_un_b.s_b2 := Byte(h_addr^[1]);
      S_un_b.s_b3 := Byte(h_addr^[2]);
      S_un_b.s_b4 := Byte(h_addr^[3]);
    end;
  end;
  Result := InAddr;
end;

function TTeCustomWinSocket.LookupService(const Service: string): Integer;
var
  ServEnt                          : PServEnt;
begin
  ServEnt := getservbyname(PChar(Service), 'tcp');
  if ServEnt <> nil then
    Result := ntohs(ServEnt.s_port)
  else Result := 0;
end;

function TTeCustomWinSocket.InitSocket(const Name, Address, Service: string; Port: Word;
  Client: Boolean): TSockAddrIn;
begin
  Result.sin_family := PF_INET;
  if Name <> '' then
    Result.sin_addr := LookupName(name)
  else if Address <> '' then
    Result.sin_addr.s_addr := inet_addr(PChar(Address))
  else if not Client then
    Result.sin_addr.s_addr := INADDR_ANY
  else raise EteSocketError.CreateRes(@sNoAddress);
  if Service <> '' then
    Result.sin_port := htons(LookupService(Service))
  else
    Result.sin_port := htons(Port);
end;

procedure TTeCustomWinSocket.Listen(const Name, Address, Service: string; Port: Word;
  QueueSize: Integer);
begin
  if cwsConnected then raise EteSocketError.CreateRes(@sCannotListenOnOpen);
  cwsSocket := socket(PF_INET, SOCK_STREAM, IPPROTO_IP);
  if cwsSocket = INVALID_SOCKET then raise EteSocketError.CreateRes(@sCannotCreateSocket);
  try
    Event(Self, seLookUp);
    cwsAddr := InitSocket(Name, Address, Service, Port, False);
    DoListen(QueueSize);
  except
    Disconnect(cwsSocket);
    raise;
  end;
end;

procedure TTeCustomWinSocket.Open(const Name, Address, Service: string; Port: Word);
begin
  if cwsConnected then raise EteSocketError.CreateRes(@sSocketAlreadyOpen);
  cwsSocket := socket(PF_INET, SOCK_STREAM, IPPROTO_IP);
  if cwsSocket = INVALID_SOCKET then raise EteSocketError.CreateRes(@sCannotCreateSocket);
  try
    Event(Self, seLookUp);
    cwsAddr := InitSocket(Name, Address, Service, Port, True);
    DoOpen;
  except
    Disconnect(cwsSocket);
    raise;
  end;
end;

procedure TTeCustomWinSocket.Disconnect(Socket: TSocket);
begin
  Lock;
  try
    if (Socket = INVALID_SOCKET) or (Socket <> cwsSocket) then exit;
    Event(Self, seDisconnect);
    CheckSocketResult(closesocket(cwsSocket), 'closesocket');
    cwsSocket := INVALID_SOCKET;
    cwsAddr.sin_family := PF_INET;
    cwsAddr.sin_addr.s_addr := INADDR_ANY;
    cwsAddr.sin_port := 0;
    cwsConnected := False;
    FreeAndNil(cwsSendStream);
  finally
    Unlock;
  end;
end;

procedure TTeCustomWinSocket.Event(Socket: TTeCustomWinSocket; SocketEvent: TTeSocketEvent);
begin
  if Assigned(cwsOnSocketEvent) then cwsOnSocketEvent(Self, Socket, SocketEvent);
end;

procedure TTeCustomWinSocket.Error(Socket: TTeCustomWinSocket; ErrorEvent: TTeErrorEvent;
  var ErrorCode: Integer);
begin
  if Assigned(cwsOnErrorEvent) then cwsOnErrorEvent(Self, Socket, ErrorEvent, ErrorCode);
end;

function TTeCustomWinSocket.SendText(const s: string): Integer;
begin
  Result := SendBuf(Pointer(S)^, Length(S));
end;

function TTeCustomWinSocket.SendStreamPiece: Boolean;
var
  Buffer                           : array[0..4095] of Byte;
  StartPos                         : Integer;
  AmountInBuf                      : Integer;
  AmountSent                       : Integer;
  ErrorCode                        : Integer;

  procedure DropStream;
  begin
    if cwsDropAfterSend then Disconnect(cwsSocket);
    cwsDropAfterSend := False;
    cwsSendStream.Free;
    cwsSendStream := nil;
  end;

begin
  Lock;
  try
    Result := False;
    if cwsSendStream <> nil then begin
      if (cwsSocket = INVALID_SOCKET) or (not cwsConnected) then exit;
      while True do begin
        StartPos := cwsSendStream.Position;
        AmountInBuf := cwsSendStream.Read(Buffer, SizeOf(Buffer));
        if AmountInBuf > 0 then begin
          AmountSent := send(cwsSocket, Buffer, AmountInBuf, 0);
          if AmountSent = SOCKET_ERROR then begin
            ErrorCode := WSAGetLastError;
            if ErrorCode <> WSAEWOULDBLOCK then begin
              Error(Self, eeSend, ErrorCode);
              Disconnect(cwsSocket);
              DropStream;
              Break;
            end else begin
              cwsSendStream.Position := StartPos;
              Break;
            end;
          end else if AmountInBuf > AmountSent then
            cwsSendStream.Position := StartPos + AmountSent
          else if cwsSendStream.Position = cwsSendStream.Size then begin
            DropStream;
            Break;
          end;
        end else begin
          DropStream;
          Break;
        end;
      end;
      Result := True;
    end;
  finally
    Unlock;
  end;
end;

function TTeCustomWinSocket.SendStream(aStream: TStream): Boolean;
begin
  Result := False;
  if cwsSendStream = nil then begin
    cwsSendStream := aStream;
    Result := SendStreamPiece;
  end;
end;

function TTeCustomWinSocket.SendStreamThenDrop(aStream: TStream): Boolean;
begin
  cwsDropAfterSend := True;
  Result := SendStream(aStream);
  if not Result then cwsDropAfterSend := False;
end;

function TTeCustomWinSocket.SendBuf(var Buf; Count: Integer): Integer;
var
  ErrorCode                        : Integer;
begin
  Lock;
  try
    Result := 0;
    if not cwsConnected then Exit;
    Result := send(cwsSocket, Buf, Count, 0);
    if Result = SOCKET_ERROR then begin
      ErrorCode := WSAGetLastError;
      if (ErrorCode <> WSAEWOULDBLOCK) then begin
        Error(Self, eeSend, ErrorCode);
        Disconnect(cwsSocket);
        if ErrorCode <> 0 then
          raise EteSocketError.CreateResFmt(@sWindowsSocketError,
            [SysErrorMessage(ErrorCode), ErrorCode, 'send']);
      end;
    end;
  finally
    Unlock;
  end;
end;

procedure TTeCustomWinSocket.Read(Socket: TSocket);
begin
  if (cwsSocket = INVALID_SOCKET) or (Socket <> cwsSocket) then Exit;
  Event(Self, seRead);
end;

function TTeCustomWinSocket.ReceiveBuf(var Buf; Count: Integer; Peek: Boolean = False): Integer;
var
  ErrorCode                        : Integer;
const
  PeekFlag                         : array[Boolean] of Integer = (0, MSG_PEEK);
begin
  Lock;
  try
    Result := 0;
    if (Count = -1) and cwsConnected then
      ioctlsocket(cwsSocket, FIONREAD, Cardinal(Result))
    else begin
      if not cwsConnected then Exit;
      Result := recv(cwsSocket, Buf, Count, PeekFlag[Peek]);
      if Result = SOCKET_ERROR then begin
        ErrorCode := WSAGetLastError;
        if ErrorCode <> WSAEWOULDBLOCK then begin
          Error(Self, eeReceive, ErrorCode);
          Disconnect(cwsSocket);
          if ErrorCode <> 0 then
            raise EteSocketError.CreateResFmt(@sWindowsSocketError,
              [SysErrorMessage(ErrorCode), ErrorCode, 'recv']);
        end;
      end;
    end;
  finally
    Unlock;
  end;
end;

function TTeCustomWinSocket.ReceiveLength: Integer;
begin
  Result := ReceiveBuf(Pointer(nil)^, -1);
end;

function TTeCustomWinSocket.ReceiveText(Peek: Boolean = False): string;
begin
  SetLength(Result, ReceiveBuf(Pointer(nil)^, -1));
  SetLength(Result, ReceiveBuf(Pointer(Result)^, Length(Result), Peek));
end;

procedure TTeCustomWinSocket.Write(Socket: TSocket);
begin
  if (cwsSocket = INVALID_SOCKET) or (Socket <> cwsSocket) then Exit;
  if not SendStreamPiece then Event(Self, seWrite);
end;

{ TTeClientWinSocket }

procedure TTeClientWinSocket.Connect(Socket: TSocket);
begin
  cwsConnected := True;
  Event(Self, seConnect);
end;

{ TTeServerClientWinSocket }

constructor TTeServerClientWinSocket.Create(Socket: TSocket; ServerWinSocket: TTeServerWinSocket);
begin
  scwsServerWinSocket := ServerWinSocket;
  if Assigned(scwsServerWinSocket) then
    scwsServerWinSocket.AddClient(Self);
  inherited Create(Socket);
  if cwsConnected then Event(Self, seConnect);
end;

destructor TTeServerClientWinSocket.Destroy;
begin
  if Assigned(scwsServerWinSocket) then
    scwsServerWinSocket.RemoveClient(Self);
  inherited Destroy;
end;

{ TTeServerWinSocket }

constructor TTeServerWinSocket.Create(aSocket: TSocket);
begin
  swsConnections := TList.Create;
  swsActiveThreads := TList.Create;
  swsListLock := TJclCriticalSection.Create;
  inherited Create(aSocket);
end;

destructor TTeServerWinSocket.Destroy;
begin
  inherited Destroy;
  swsConnections.Free;
  swsActiveThreads.Free;
  swsListLock.Free;
end;

procedure TTeServerWinSocket.AddClient(aClient: TTeServerClientWinSocket);
begin
  swsListLock.Enter;
  try
    if swsConnections.IndexOf(aClient) < 0 then
      swsConnections.Add(aClient);
  finally
    swsListLock.Leave;
  end;
end;

procedure TTeServerWinSocket.RemoveClient(aClient: TTeServerClientWinSocket);
begin
  swsListLock.Enter;
  try
    swsConnections.Remove(aClient);
  finally
    swsListLock.Leave;
  end;
end;

procedure TTeServerWinSocket.AddThread(aThread: TTeServerClientThread);
begin
  swsListLock.Enter;
  try
    if swsActiveThreads.IndexOf(aThread) < 0 then begin
      swsActiveThreads.Add(aThread);
      if swsActiveThreads.Count <= swsThreadCacheSize then
        aThread.KeepInCache := True;
    end;
  finally
    swsListLock.Leave;
  end;
end;

procedure TTeServerWinSocket.RemoveThread(aThread: TTeServerClientThread);
begin
  swsListLock.Enter;
  try
    swsActiveThreads.Remove(aThread);
  finally
    swsListLock.Leave;
  end;
end;

procedure TTeServerWinSocket.ClientEvent(Sender: TObject; Socket: TTeCustomWinSocket;
  SocketEvent: TTeSocketEvent);
begin
  case SocketEvent of
    seAccept,
      seLookup,
      seConnecting,
      seListen: begin
      end;
    seConnect: ClientConnect(Socket);
    seDisconnect: ClientDisconnect(Socket);
    seRead: ClientRead(Socket);
    seWrite: ClientWrite(Socket);
  end;
end;

procedure TTeServerWinSocket.ClientError(Sender: TObject; Socket: TTeCustomWinSocket;
  ErrorEvent: TTeErrorEvent; var ErrorCode: Integer);
begin
  ClientErrorEvent(Socket, ErrorEvent, ErrorCode);
end;

function TTeServerWinSocket.GetActiveConnections: Integer;
begin
  Result := swsConnections.Count;
end;

function TTeServerWinSocket.GetConnections(Index: Integer): TTeCustomWinSocket;
begin
  Result := swsConnections[Index];
end;

function TTeServerWinSocket.GetActiveThreads: Integer;
var
  I                                : Integer;
begin
  swsListLock.Enter;
  try
    Result := 0;
    for I := 0 to swsActiveThreads.Count - 1 do
      if TTeServerClientThread(swsActiveThreads[I]).ClientSocket <> nil then
        Inc(Result);
  finally
    swsListLock.Leave;
  end;
end;

function TTeServerWinSocket.GetIdleThreads: Integer;
var
  I                                : Integer;
begin
  swsListLock.Enter;
  try
    Result := 0;
    for I := 0 to swsActiveThreads.Count - 1 do
      if TTeServerClientThread(swsActiveThreads[I]).ClientSocket = nil then
        Inc(Result);
  finally
    swsListLock.Leave;
  end;
end;

procedure TTeServerWinSocket.Accept(Socket: TSocket);
var
  ClientSocket                     : TTeServerClientWinSocket;
  ClientWinSocket                  : TSocket;
  Addr                             : TSockAddrIn;
  Len                              : Integer;
  OldOpenType, NewOpenType         : Integer;
begin
  Len := SizeOf(OldOpenType);
  if getsockopt(INVALID_SOCKET, SOL_SOCKET, SO_OPENTYPE, PChar(@OldOpenType),
    Len) = 0 then try
    NewOpenType := SO_SYNCHRONOUS_NONALERT;
    setsockopt(INVALID_SOCKET, SOL_SOCKET, SO_OPENTYPE, PChar(@NewOpenType), Len);
    Len := SizeOf(Addr);
    ClientWinSocket := WinSock2.accept(Socket, Addr, Len);
    if ClientWinSocket <> INVALID_SOCKET then begin
      ClientSocket := GetClientSocket(ClientWinSocket);
      if Assigned(cwsOnSocketEvent) then
        cwsOnSocketEvent(Self, ClientSocket, seAccept);
      GetServerThread(ClientSocket);
    end;
  finally
    Len := SizeOf(OldOpenType);
    setsockopt(INVALID_SOCKET, SOL_SOCKET, SO_OPENTYPE, PChar(@OldOpenType), Len);
  end;
end;

procedure TTeServerWinSocket.Disconnect(Socket: TSocket);
var
  SaveCacheSize                    : Integer;
begin
  Lock;
  try
    SaveCacheSize := ThreadCacheSize;
    try
      ThreadCacheSize := 0;
      while swsActiveThreads.Count > 0 do
        with TTeServerClientThread(swsActiveThreads.Last) do begin
          FreeOnTerminate := False;
          Terminate;
          sctEvent.SetEvent;
          if (ClientSocket <> nil) and ClientSocket.Connected then
            ClientSocket.Close;
          WaitFor;
          Free;
        end;
      while swsConnections.Count > 0 do
        TTeCustomWinSocket(swsConnections.Last).Free;
      if swsServerAcceptThread <> nil then
        swsServerAcceptThread.Terminate;
      inherited Disconnect(Socket);
      swsServerAcceptThread.Free;
      swsServerAcceptThread := nil;
    finally
      ThreadCacheSize := SaveCacheSize;
    end;
  finally
    Unlock;
  end;
end;

function TTeServerWinSocket.DoCreateThread(ClientSocket: TTeServerClientWinSocket): TTeServerClientThread;
begin
  Result := TTeServerClientThread.Create(False, ClientSocket);
end;

procedure TTeServerWinSocket.Listen(var Name, Address, Service: string; Port: Word;
  QueueSize: Integer);
begin
  inherited Listen(Name, Address, Service, Port, QueueSize);
  if cwsConnected then
    swsServerAcceptThread := TTeServerAcceptThread.Create(False, Self);
end;

procedure TTeServerWinSocket.SetThreadCacheSize(Value: Integer);
var
  Start, I                         : Integer;
begin
  if Value <> swsThreadCacheSize then begin
    if Value < swsThreadCacheSize then
      Start := Value
    else Start := swsThreadCacheSize;
    swsThreadCacheSize := Value;
    swsListLock.Enter;
    try
      for I := 0 to swsActiveThreads.Count - 1 do
        with TTeServerClientThread(swsActiveThreads[I]) do
          KeepInCache := I < Start;
    finally
      swsListLock.Leave;
    end;
  end;
end;

function TTeServerWinSocket.GetClientSocket(Socket: TSocket): TTeServerClientWinSocket;
begin
  Result := nil;
  if Assigned(swsOnGetSocket) then swsOnGetSocket(Self, Socket, Result);
  if Result = nil then
    Result := TTeServerClientWinSocket.Create(Socket, Self);
end;

procedure TTeServerWinSocket.ThreadEnd(aThread: TTeServerClientThread);
begin
  if Assigned(swsOnThreadEnd) then swsOnThreadEnd(Self, aThread);
end;

procedure TTeServerWinSocket.ThreadStart(aThread: TTeServerClientThread);
begin
  if Assigned(swsOnThreadStart) then swsOnThreadStart(Self, aThread
      );
end;

function TTeServerWinSocket.GetServerThread(ClientSocket: TTeServerClientWinSocket): TTeServerClientThread;
var
  I                                : Integer;
begin
  Result := nil;
  swsListLock.Enter;
  try
    for I := 0 to swsActiveThreads.Count - 1 do
      if TTeServerClientThread(swsActiveThreads[I]).ClientSocket = nil then begin
        Result := swsActiveThreads[I];
        Result.ReActivate(ClientSocket);
        Break;
      end;
  finally
    swsListLock.Leave;
  end;
  if Result = nil then begin
    if Assigned(swsOnGetThread) then swsOnGetThread(Self, ClientSocket, Result);
    if Result = nil then Result := DoCreateThread(ClientSocket);
  end;
end;

function TTeServerWinSocket.GetClientThread(ClientSocket: TTeServerClientWinSocket): TTeServerClientThread;
var
  I                                : Integer;
begin
  Result := nil;
  swsListLock.Enter;
  try
    for I := 0 to swsActiveThreads.Count - 1 do
      if TTeServerClientThread(swsActiveThreads[I]).ClientSocket = ClientSocket then begin
        Result := swsActiveThreads[I];
        Break;
      end;
  finally
    swsListLock.Leave;
  end;
end;

procedure TTeServerWinSocket.ClientConnect(Socket: TTeCustomWinSocket);
begin
  if Assigned(swsOnClientConnect) then swsOnClientConnect(Self, Socket);
end;

procedure TTeServerWinSocket.ClientDisconnect(Socket: TTeCustomWinSocket);
begin
  if Assigned(swsOnClientDisconnect) then swsOnClientDisconnect(Self, Socket);
end;

procedure TTeServerWinSocket.ClientRead(Socket: TTeCustomWinSocket);
begin
  if Assigned(swsOnClientRead) then swsOnClientRead(Self, Socket);
end;

procedure TTeServerWinSocket.ClientWrite(Socket: TTeCustomWinSocket);
begin
  if Assigned(swsOnClientWrite) then swsOnClientWrite(Self, Socket);
end;

procedure TTeServerWinSocket.ClientErrorEvent(Socket: TTeCustomWinSocket;
  ErrorEvent: TTeErrorEvent; var ErrorCode: Integer);
begin
  if Assigned(swsOnClientError) then swsOnClientError(Self, Socket, ErrorEvent, ErrorCode);
end;

{ TTeServerAcceptThread }

constructor TTeServerAcceptThread.Create(CreateSuspended: Boolean;
  aSocket: TTeServerWinSocket);
begin
  satServerSocket := aSocket;
  inherited Create(CreateSuspended);
end;

procedure TTeServerAcceptThread.DoExecute;
begin
  while not Terminated do
    satServerSocket.Accept(satServerSocket.SocketHandle);
end;

{ TTeServerClientThread }

constructor TTeServerClientThread.Create(CreateSuspended: Boolean;
  aSocket: TTeServerClientWinSocket);
begin
  FreeOnTerminate := True;
  sctEvent := TJclSimpleEvent.Create;
  inherited Create(True, tpHigher);
  ReActivate(aSocket);
  if not CreateSuspended then Resume;
end;

destructor TTeServerClientThread.Destroy;
begin
  sctClientSocket.Free;
  sctEvent.Free;
  inherited Destroy;
end;

procedure TTeServerClientThread.ReActivate(aSocket: TTeServerClientWinSocket);
begin
  sctClientSocket := aSocket;
  if Assigned(sctClientSocket) then begin
    sctServerSocket := sctClientSocket.ServerWinSocket;
    sctServerSocket.AddThread(Self);
    sctClientSocket.OnSocketEvent := HandleEvent;
    sctClientSocket.OnErrorEvent := HandleError;
    sctEvent.SetEvent;
  end;
end;

procedure TTeServerClientThread.DoHandleException;
begin
  if GetCapture <> 0 then SendMessage(GetCapture, WM_CANCELMODE, 0, 0);
  if sctException is Exception then begin
    Application.ShowException(sctException);
  end else
    SysUtils.ShowException(sctException, nil);
end;

procedure TTeServerClientThread.DoRead;
begin
  ClientSocket.ServerWinSocket.Event(ClientSocket, seRead);
end;

procedure TTeServerClientThread.DoTerminate;
begin
  inherited DoTerminate;
  if Assigned(sctServerSocket) then
    sctServerSocket.RemoveThread(Self);
end;

procedure TTeServerClientThread.DoWrite;
begin
  sctServerSocket.Event(ClientSocket, seWrite);
end;

procedure TTeServerClientThread.HandleEvent(Sender: TObject; Socket: TTeCustomWinSocket;
  SocketEvent: TTeSocketEvent);
begin
  Event(SocketEvent);
end;

procedure TTeServerClientThread.HandleError(Sender: TObject; Socket: TTeCustomWinSocket;
  ErrorEvent: TTeErrorEvent; var ErrorCode: Integer);
begin
  Error(ErrorEvent, ErrorCode);
end;

procedure TTeServerClientThread.Event(SocketEvent: TTeSocketEvent);
begin
  sctServerSocket.ClientEvent(Self, ClientSocket, SocketEvent);
end;

procedure TTeServerClientThread.Error(ErrorEvent: TTeErrorEvent; var ErrorCode: Integer);
begin
  sctServerSocket.ClientError(Self, ClientSocket, ErrorEvent, ErrorCode);
end;

procedure TTeServerClientThread.HandleException;
begin
  sctException := Exception(ExceptObject);
  try
    if not (sctException is EAbort) then
      Synchronize(DoHandleException);
  finally
    sctException := nil;
  end;
end;

procedure TTeServerClientThread.DoExecute;
begin
  sctServerSocket.ThreadStart(Self);
  try
    try
      while True do begin
        if StartConnect then ClientExecute;
        if EndConnect then Break;
      end;
    except
      HandleException;
      KeepInCache := False;
    end;
  finally
    sctServerSocket.ThreadEnd(Self);
  end;
end;

procedure TTeServerClientThread.ClientExecute;
var
  FDSet                            : TFDSet;
  TimeVal                          : TTimeVal;
begin
  while not Terminated and ClientSocket.Connected do begin
    FD_ZERO(FDSet);
    FD_SET(ClientSocket.SocketHandle, FDSet);
    TimeVal.tv_sec := 0;
    TimeVal.tv_usec := 500;
    if (select(0, @FDSet, nil, nil, @TimeVal) > 0) and not Terminated then
      if ClientSocket.ReceiveBuf(FDSet, -1) = 0 then Break
      else Synchronize(DoRead);
    if (select(0, nil, @FDSet, nil, @TimeVal) > 0) and not Terminated then
      Synchronize(DoWrite);
  end;
end;

function TTeServerClientThread.StartConnect: Boolean;
begin
  if sctEvent.WaitFor(INFINITE) = wrSignaled then
    sctEvent.ResetEvent;
  Result := not Terminated;
end;

function TTeServerClientThread.EndConnect: Boolean;
begin
  sctClientSocket.Free;
  sctClientSocket := nil;
  Result := Terminated or not KeepInCache;
end;

{ TTeAbstractSocket }

procedure TTeAbstractSocket.DoEvent(Sender: TObject; Socket: TTeCustomWinSocket;
  SocketEvent: TTeSocketEvent);
begin
  Event(Socket, SocketEvent);
end;

procedure TTeAbstractSocket.DoError(Sender: TObject; Socket: TTeCustomWinSocket;
  ErrorEvent: TTeErrorEvent; var ErrorCode: Integer);
begin
  Error(Socket, ErrorEvent, ErrorCode);
end;

procedure TTeAbstractSocket.SetActive(Value: Boolean);
begin
  if Value <> asActive then
    DoActivate(Value);
end;

procedure TTeAbstractSocket.InitSocket(Socket: TTeCustomWinSocket);
begin
  Socket.OnSocketEvent := DoEvent;
  Socket.OnErrorEvent := DoError;
end;

procedure TTeAbstractSocket.SetAddress(Value: string);
begin
  if CompareText(Value, asAddress) <> 0 then begin
    if asActive then
      raise EteSocketError.CreateRes(@sCantChangeWhileActive);
    asAddress := Value;
  end;
end;

procedure TTeAbstractSocket.SetHost(Value: string);
begin
  if CompareText(Value, asHost) <> 0 then begin
    if asActive then
      raise EteSocketError.CreateRes(@sCantChangeWhileActive);
    asHost := Value;
  end;
end;

procedure TTeAbstractSocket.SetPort(Value: Integer);
begin
  if asPort <> Value then begin
    if asActive then
      raise EteSocketError.CreateRes(@sCantChangeWhileActive);
    asPort := Value;
  end;
end;

procedure TTeAbstractSocket.SetService(Value: string);
begin
  if CompareText(Value, asService) <> 0 then begin
    if asActive then
      raise EteSocketError.CreateRes(@sCantChangeWhileActive);
    asService := Value;
  end;
end;

procedure TTeAbstractSocket.Open;
begin
  Active := True;
end;

procedure TTeAbstractSocket.Close;
begin
  Active := False;
end;

{ TTeCustomSocket }

procedure TTeCustomSocket.Event(Socket: TTeCustomWinSocket; SocketEvent: TTeSocketEvent);
begin
  case SocketEvent of
    seLookup: if Assigned(csOnLookup) then csOnLookup(Self, Socket);
    seConnecting: if Assigned(csOnConnecting) then csOnConnecting(Self, Socket);
    seConnect: begin
        asActive := True;
        if Assigned(csOnConnect) then csOnConnect(Self, Socket);
      end;
    seListen: begin
        asActive := True;
        if Assigned(csOnListen) then csOnListen(Self, Socket);
      end;
    seDisconnect: begin
        asActive := False;
        if Assigned(csOnDisconnect) then csOnDisconnect(Self, Socket);
      end;
    seAccept: if Assigned(csOnAccept) then csOnAccept(Self, Socket);
    seRead: if Assigned(csOnRead) then csOnRead(Self, Socket);
    seWrite: if Assigned(csOnWrite) then csOnWrite(Self, Socket);
  end;
end;

procedure TTeCustomSocket.Error(Socket: TTeCustomWinSocket; ErrorEvent: TTeErrorEvent;
  var ErrorCode: Integer);
begin
  if Assigned(csOnError) then csOnError(Self, Socket, ErrorEvent, ErrorCode);
end;

{ TTeWinSocketStream }

constructor TTeWinSocketStream.Create(aSocket: TTeCustomWinSocket; TimeOut: Longint);
begin
  wssSocket := aSocket;
  wssTimeout := TimeOut;
  wssEvent := TJclSimpleEvent.Create;
  inherited Create;
end;

destructor TTeWinSocketStream.Destroy;
begin
  wssEvent.Free;
  inherited Destroy;
end;

function TTeWinSocketStream.WaitForData(Timeout: Longint): Boolean;
var
  FDSet                            : TFDSet;
  TimeVal                          : TTimeVal;
begin
  TimeVal.tv_sec := Timeout div 1000;
  TimeVal.tv_usec := (Timeout mod 1000) * 1000;
  FD_ZERO(FDSet);
  FD_SET(wssSocket.SocketHandle, FDSet);
  Result := select(0, @FDSet, nil, nil, @TimeVal) > 0;
end;

function TTeWinSocketStream.Read(var Buffer; Count: Longint): Longint;
var
  Overlapped                       : TOverlapped;
  ErrorCode                        : Integer;
begin
  wssSocket.Lock;
  try
    FillChar(OVerlapped, SizeOf(Overlapped), 0);
    Overlapped.hEvent := wssEvent.Handle;
    if not ReadFile(wssSocket.SocketHandle, Buffer, Count, DWORD(Result),
      @Overlapped) and (GetLastError <> ERROR_IO_PENDING) then begin
      ErrorCode := GetLastError;
      raise EteSocketError.CreateResFmt(@sSocketIOError, [sSocketRead, ErrorCode,
        SysErrorMessage(ErrorCode)]);
    end;
    if wssEvent.WaitFor(wssTimeout) <> wrSignaled then
      Result := 0
    else begin
      GetOverlappedResult(wssSocket.SocketHandle, Overlapped, DWORD(Result), False);
      wssEvent.ResetEvent;
    end;
  finally
    wssSocket.Unlock;
  end;
end;

function TTeWinSocketStream.Write(const Buffer; Count: Longint): Longint;
var
  Overlapped                       : TOverlapped;
  ErrorCode                        : Integer;
begin
  wssSocket.Lock;
  try
    FillChar(Overlapped, SizeOf(Overlapped), 0);
    Overlapped.hEvent := wssEvent.Handle;
    if not WriteFile(wssSocket.SocketHandle, Buffer, Count, DWORD(Result),
      @Overlapped) and (GetLastError <> ERROR_IO_PENDING) then begin
      ErrorCode := GetLastError;
      raise EteSocketError.CreateResFmt(@sSocketIOError, [sSocketWrite, ErrorCode,
        SysErrorMessage(ErrorCode)]);
    end;
    if wssEvent.WaitFor(wssTimeout) <> wrSignaled then
      Result := 0
    else GetOverlappedResult(wssSocket.SocketHandle, Overlapped, DWORD(Result), False);
  finally
    wssSocket.Unlock;
  end;
end;

function TTeWinSocketStream.Seek(Offset: Longint; Origin: Word): Longint;
begin
  Result := 0;
end;

procedure TTeWinSocketStream.WriteString(aString: string);
begin
  if Length(aString) > 0 then
    WriteBuffer(PChar(aString)^, Length(aString));
end;

function TTeWinSocketStream.ReadString: string;
var
  s                                : string;
  i                                : Integer;
const
  LF                               = #10;
  CR                               = #13;
begin
  Result := '';
  if not WaitForData(Timeout) then
    Exit;
  s := wssSocket.ReceiveText(True);
  i := Pos(LF, s);
  if i > 0 then begin
    SetLength(Result, i);
    wssSocket.ReceiveBuf(PChar(Result)^, Length(Result));
    if (i > 1) and (Result[i - 1] = CR) then
      SetLength(Result, i - 2)
    else
      SetLength(Result, i - 1);
  end;
end;

{ TTeClientSocket }

constructor TTeClientSocket.Create;
begin
  inherited Create;
  clsClientSocket := TTeClientWinSocket.Create(INVALID_SOCKET);
  InitSocket(clsClientSocket);
end;

destructor TTeClientSocket.Destroy;
begin
  clsClientSocket.Free;
  inherited Destroy;
end;

procedure TTeClientSocket.DoActivate(Value: Boolean);
begin
  if (Value <> clsClientSocket.Connected) then begin
    if clsClientSocket.Connected then
      clsClientSocket.Disconnect(clsClientSocket.cwsSocket)
    else clsClientSocket.Open(asHost, asAddress, asService, asPort);
  end;
end;

{ TTeCustomServerSocket }

destructor TTeCustomServerSocket.Destroy;
begin
  cssServerSocket.Free;
  inherited Destroy;
end;

procedure TTeCustomServerSocket.DoActivate(Value: Boolean);
begin
  if Value <> cssServerSocket.Connected then begin
    if cssServerSocket.Connected then
      cssServerSocket.Disconnect(cssServerSocket.SocketHandle)
    else cssServerSocket.Listen(asHost, asAddress, asService, asPort, SOMAXCONN);
  end;
end;

function TTeCustomServerSocket.GetGetThreadEvent: TTeGetThreadEvent;
begin
  Result := cssServerSocket.OnGetThread;
end;

procedure TTeCustomServerSocket.SetGetThreadEvent(Value: TTeGetThreadEvent);
begin
  cssServerSocket.OnGetThread := Value;
end;

function TTeCustomServerSocket.GetGetSocketEvent: TTeGetSocketEvent;
begin
  Result := cssServerSocket.OnGetSocket;
end;

procedure TTeCustomServerSocket.SetGetSocketEvent(Value: TTeGetSocketEvent);
begin
  cssServerSocket.OnGetSocket := Value;
end;

function TTeCustomServerSocket.GetThreadCacheSize: Integer;
begin
  Result := cssServerSocket.ThreadCacheSize;
end;

procedure TTeCustomServerSocket.SetThreadCacheSize(Value: Integer);
begin
  cssServerSocket.ThreadCacheSize := Value;
end;

function TTeCustomServerSocket.GetOnThreadStart: TTeThreadNotifyEvent;
begin
  Result := cssServerSocket.OnThreadStart;
end;

function TTeCustomServerSocket.GetOnThreadEnd: TTeThreadNotifyEvent;
begin
  Result := cssServerSocket.OnThreadEnd;
end;

procedure TTeCustomServerSocket.SetOnThreadStart(Value: TTeThreadNotifyEvent);
begin
  cssServerSocket.OnThreadStart := Value;
end;

procedure TTeCustomServerSocket.SetOnThreadEnd(Value: TTeThreadNotifyEvent);
begin
  cssServerSocket.OnThreadEnd := Value;
end;

function TTeCustomServerSocket.GetOnClientEvent(Index: Integer): TTeSocketNotifyEvent;
begin
  case Index of
    0: Result := cssServerSocket.OnClientRead;
    1: Result := cssServerSocket.OnClientWrite;
    2: Result := cssServerSocket.OnClientConnect;
    3: Result := cssServerSocket.OnClientDisconnect;
  end;
end;

procedure TTeCustomServerSocket.SetOnClientEvent(Index: Integer;
  Value: TTeSocketNotifyEvent);
begin
  case Index of
    0: cssServerSocket.OnClientRead := Value;
    1: cssServerSocket.OnClientWrite := Value;
    2: cssServerSocket.OnClientConnect := Value;
    3: cssServerSocket.OnClientDisconnect := Value;
  end;
end;

function TTeCustomServerSocket.GetOnClientError: TTeSocketErrorEvent;
begin
  Result := cssServerSocket.OnClientError;
end;

procedure TTeCustomServerSocket.SetOnClientError(Value: TTeSocketErrorEvent);
begin
  cssServerSocket.OnClientError := Value;
end;

{ TTeServerSocket }

constructor TTeServerSocket.Create;
begin
  inherited Create;
  cssServerSocket := TTeServerWinSocket.Create(INVALID_SOCKET);
  InitSocket(cssServerSocket);
  cssServerSocket.ThreadCacheSize := 10;
end;

{ TJclSimpleEvent }

constructor TJclSimpleEvent.Create;
begin
  inherited Create(nil, True, False, '');
end;

end.

