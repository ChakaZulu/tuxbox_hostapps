unit TeChannelsReader;

interface

uses
  Classes, SysUtils,
  forms, IdTCPConnection, IdTCPClient, dialogs;

const
  NAMELEN                     = 24;

type
  PChannel = ^TChannel;
  TChannel = packed record
    szFlag: array[0..3] of Byte;                            // always DVSO           0-3
    usChannelID: Word;                                      // channel ID            4-5
    usPMTPID: Word;                                         // PMT PID               6-7
    usFreq: Word;                                           // frequency             8-9
    usSR: Word;                                             // symbol rate           a-b
    ucFEC: Byte;                                            // FEC flag              c
    ucAcqBW: Byte;                                          // Aquisition bandwidth  d
    ucPolarity: Byte;                                       // polarity              e
    ucDiseqc: Byte;                                         // diseqc mode           f
    usVPID: Word;                                           // video PID             10-11
    usAPID: Word;                                           // audio PID             12-13
    usPCRPID: Word;                                         // PCR PID               14-15
    usFlags: Word;                                          // scrambling flags      16-17
    usPMC: Word;                                            // PMC for CA            18-19
    ucVideo: Byte;                                          // video/audio mode      1a
    ucServiceType: Byte;                                    // service type          1b
    usTPID: Word;                                           // teletext PID          1c-1d
    usTSID: Word;                                           // Transport stream ID   1e-1f
    szName: array[0..NAMELEN - 1] of char;                  // channel name          20-37
    ucAutoPIDPMT: Byte;                                     // Auto PID/PMT          38
    ucProviderIndex: Byte;                                  // provider index        39
    parental_lock: Byte;                                    // parental lock         3a
    CountryCode: Byte;                                      // country code          3b
    channel_linkage: Byte;                                  // channel linkage       3c
    digicipher: Byte;                                       // unknown               3d
    usNetworkID: Word;                                      // Network ID            3e-3f
  end;

  TTeChannelList = class(TList)
  protected
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
  public
    function ReadFromFile(aFileName: TFileName): Word;
    function ReadFromBox(sIP: string; iPort: Integer): Word;
    procedure SetPids(sName: string; VPid, APid: Word);
  end;

implementation

{ TTeChannelList }

procedure TTeChannelList.Notify(Ptr: Pointer; Action: TListNotification);
begin
  if Action = lnDeleted then
    Dispose(PChannel(Ptr));
end;

function TTeChannelList.ReadFromFile(aFileName: TFileName): Word;

  function FilterName(s: string): string;
  begin
    Result := StringReplace(s, Chr($86), '', [rfReplaceAll]);
    Result := StringReplace(Result, Chr($87), '', [rfReplaceAll]);
  end;

var
  FileStream                  : TFileStream;
  pCh                         : PChannel;
begin
  Clear;

  FileStream := TFileStream.Create(aFileName, fmOpenRead or fmShareDenyWrite);
  try
    while FileStream.Position + SizeOf(TChannel) <= FileStream.Size do begin
      New(pCh);
      FileStream.Read(pCh^, SizeOf(TChannel));
      StrPCopy(@pCh^.szName, FilterName(pCh^.szName));
      Add(pCh);
    end;
  finally
    FileStream.Free;
  end;

  Result := Count;
end;

function TTeChannelList.ReadFromBox(sIP: string; iPort: Integer): Word;
type
  TChannelMsg = record
    chan_nr: Integer;
    name: array[0..29] of char;
    mode: char;
  end;
var
  i                           : Byte;
  Buffer                      : array[0..4] of Char;
  channel                     : Integer;
  cmsg                        : TChannelMsg;
  pc                          : PChannel;
begin
  with TIDTCPCLient.Create(Application) do try
    try
      Host := sIP;
      Port := iPort;
      Connect;
      // anfrage
      WriteLn(#1#5#0#0#0 +
        #0#0#0#0#0#0#0#0#0#0 +
        #0#0#0#0#0#0#0#0#0#0 +
        #0#0#0#0#0#0#0#0#0#0);
      // 005
      readBuffer(Buffer, 3);
      Buffer[3] := #0;
      if Buffer[0] <> '-' then begin
        // unendlich
        while true do begin
          new(pc);
          readBuffer(cmsg, sizeof(cmsg));
          StrCopy(pc^.szName, cMsg.name);
          add(pc);
        end;
      end;
    except
      disconnect;
    end;

  finally
    free;
  end;
end;

procedure TTeChannelList.SetPids(sName: string; VPid, APid: Word);
var
  chname                      : array[0..30] of char;
  i                           : Integer;
begin
  StrPCopy(chname, sName);

  if count > 0 then
    for i := 0 to count - 1 do
      // namen vergleichen
      if StrComp(chName, PChannel(Items[i])^.szName) = 0 then begin
        PChannel(Items[i])^.usVPID := VPID;
        PChannel(Items[i])^.usAPID := APID;
      end;
end;

end.

