unit TeSectionParserThread;

interface

uses
  Classes, SysUtils,
  TeBase, TeFiFo, TeThrd, TeSectionParser, TeLogableThread;

type
  TTeSectionParserThread = class(TTeLogableThread)
  private
    sptParser: TTeSectionParser;
    sptInput: TTeFiFoBuffer;
    //sptOutput: TTeSectionFiFoBuffer;
  protected
    procedure DoBeforeExecute; override;
    procedure DoAfterExecute; override;
    procedure InnerExecute; override;
  public
    constructor Create(aLog: ILog; aThreadPriority: TThreadPriority; aInput: TTeFiFoBuffer {; aOutput: TTeSectionFiFoBuffer});
    destructor Destroy; override;
  end;

implementation

{ TTeSectionParserThread }

constructor TTeSectionParserThread.Create(aLog: ILog; aThreadPriority: TThreadPriority; aInput: TTeFiFoBuffer {;
  aOutput: TTeSectionFiFoBuffer});
begin
  sptInput := aInput;
  //sptOutput := aOutput;
  inherited Create(aLog, aThreadPriority);
end;

destructor TTeSectionParserThread.Destroy;
begin
  sptInput.Shutdown;
  //sptOutput.Shutdown;
  inherited;
end;

procedure TTeSectionParserThread.DoAfterExecute;
begin
  sptInput.Shutdown;
  //sptOutput.Shutdown;
  FreeAndNil(sptParser);
  inherited;
end;

procedure TTeSectionParserThread.DoBeforeExecute;
begin
  inherited;
  sptParser := TTeSectionParser.Create;
  //sptParser.OnSectionFound := sptOutput.SectionPacketFound;
  sptParser.Log := ltLog;
end;

procedure TTeSectionParserThread.InnerExecute;
begin
  SetState('waiting for first data');
  while not Terminated do
    with sptInput.GetReadPage(true) do try
      sptParser.FindSections(Memory, Size);
    finally
      Finished;
    end;
end;

end.

