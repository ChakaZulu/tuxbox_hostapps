unit TePesParserThread;

interface

uses
  Classes, SysUtils,
  TeBase, TeFiFo, TePesFiFo, TeThrd, TePesParser, TeLogableThread;

type
  TTePesParserThread = class(TTeLogableThread)
  private
    pptParser: TPesParser;
    pptInput: TTeFiFoBuffer;
    pptOutput: TTePesFiFoBuffer;
    pptStripPesHeader: Boolean;
  protected
    procedure DoBeforeExecute; override;
    procedure DoAfterExecute; override;
    procedure InnerExecute; override;
  public
    constructor Create(aLog: ILog; aThreadPriority: TThreadPriority; aInput: TTeFiFoBuffer; aOutput: TTePesFiFoBuffer; aStripPesHeader: Boolean);
    destructor Destroy; override;
  end;

implementation

{ TTePesParserThread }

constructor TTePesParserThread.Create(aLog: ILog; aThreadPriority: TThreadPriority; aInput: TTeFiFoBuffer;
  aOutput: TTePesFiFoBuffer; aStripPesHeader: Boolean);
begin
  pptInput := aInput;
  pptOutput := aOutput;
  pptStripPesHeader := aStripPesHeader;
  inherited Create(aLog, aThreadPriority);
end;

destructor TTePesParserThread.Destroy;
begin
  pptInput.Shutdown;
  pptOutput.Shutdown;
  inherited;
end;

procedure TTePesParserThread.DoAfterExecute;
begin
  pptInput.Shutdown;
  pptOutput.Shutdown;
  FreeAndNil(pptParser);
  inherited;
end;

procedure TTePesParserThread.DoBeforeExecute;
begin
  inherited;
  pptParser := TPesParser.Create;
  pptParser.OnPacketFound := pptOutput.PesPacketFound;
  pptParser.Log := ltLog;
  pptParser.StripPesHeader := pptStripPesHeader;
end;

procedure TTePesParserThread.InnerExecute;
begin
  SetState('waiting for first data');
  while not Terminated do
    with pptInput.GetReadPage(true) do try
      pptParser.FindPesPackets(Memory, Size);
    finally
      Finished;
    end;
end;

end.

