unit TeGrabManager;

interface

uses
  Windows, Messages,
  Classes, SysUtils, TeLogableThread, TeProcessManager,
  TeFiFo, TeChannelsReader, JclSynch, TeHTTPStreamThread, TeFileStreamThread,
  TePesFiFo, TePesParser, TePesParserThread, TePesMuxerThread,
  TeVideoFrameProcessorThread, TeAudioFrameProcessorThread, TeTCPStreamThread,
  TeTsParserThread;

type
  TTeGrabManager = class(TTeProcessManager)
  protected
    gmIp: string;
    gmVideoID: Integer;
    gmAudioIDs: array of Integer;

    gmVideoRawFiFo: TTeFiFoBuffer;
    gmVideoReader: TTeHTTPPesStreamThread;

    gmAudioRawFiFos: array of TTeFiFoBuffer;
    gmAudioReaders: array of TTeHTTPPesStreamThread;

    procedure CreateFiFos; virtual;
    procedure CreateWriterThreads; virtual;
    procedure CreateProcessingThreads; virtual;
    procedure CreateStreamingThreads; virtual;

    procedure DestoryStreamingThreads; virtual;
    procedure DestoryProcessingThreads; virtual;
    procedure DestoryWriterThreads; virtual;
    procedure DestoryFiFos; virtual;
  public
    constructor Create(aIp: string; aVideoID: Integer; aAudioIDs: array of Integer; aMessageCallback: TMessageCallback; aStateCallback: TStateCallback);
    destructor Destroy; override;
  end;

  TTeDirectGrabManager = class(TTeGrabManager)
  protected
    dgmVideoFileName: string;
    dgmAudioFileNames: array of string;

    dgmVideoWriter: TTeWriterFileStreamThread;
    dgmAudioWriters: array of TTeWriterFileStreamThread;

    dgmStripAudioPes: array of Boolean;
    dgmAudioPesParsers: array of TTePesParserThread;
    dgmAudioPesFiFos: array of TTePesAudioFiFoBuffer;

    dgmStripVideoPes: Boolean;
    dgmVideoPesParser: TTePesParserThread;
    dgmVideoPesFiFo: TTePesVideoFiFoBuffer;

    procedure CreateFiFos; override;
    procedure CreateWriterThreads; override;
    procedure CreateProcessingThreads; override;

    procedure DestoryProcessingThreads; override;
    procedure DestoryWriterThreads; override;
    procedure DestoryFiFos; override;
  public
    constructor Create(aIp: string; aVideoID: Integer; aAudioIDs: array of Integer; aVideoFileName: string; aAudioFilesName: array of string; aStripVideoPes: Boolean; aStripAudioPes: array of Boolean; aMessageCallback: TMessageCallback; aStateCallback: TStateCallback);
  end;

  TTeMuxGrabManager = class(TTeGrabManager)
  protected
    mgmVideoPesParser: TTePesParserThread;
    mgmVideoPesFiFo: TTePesVideoFiFoBuffer;
    mgmVideoProcessor: TTeVideoFrameProcessorThread;
    mgmVideoFrameFiFo: TTePesVideoFiFoBuffer;

    mgmAudioPesParsers: array of TTePesParserThread;
    mgmAudioPesFiFos: array of TTePesAudioFiFoBuffer;
    mgmAudioProcessors: array of TTeAudioFrameProcessorThread;
    mgmAudioFrameFiFos: array of TTePesAudioFiFoBuffer;

    mgmMuxFileName: string;
    mgmMuxer: TTePesMuxerThread;
    mgmMuxFiFo: TTeFiFoBuffer;
    mgmMuxWriter: TTeWriterFileStreamThread;

    mgmSplittSize: Word;

    procedure CreateFiFos; override;
    procedure CreateWriterThreads; override;
    procedure CreateProcessingThreads; override;

    procedure DestoryProcessingThreads; override;
    procedure DestoryWriterThreads; override;
    procedure DestoryFiFos; override;
  public
    constructor Create(aIp: string; aVideoID: Integer; aAudioIDs: array of Integer; aMuxFileName: string; aSplittSize: Word; aMessageCallback: TMessageCallback; aStateCallback: TStateCallback);
  end;

  TTeReMuxTsProcessManager = class(TTeProcessManager)
  protected
    rmtsTsFileName: string;
    rmtsTsReader: TTeReaderFileStreamThread;//
    rmtsTsFiFo: TTeFiFoBuffer;//
    rmtsTsTsParser: TTeTsParserThread;

    rmtsVideoID: Integer;
    rmtsAudioIDs: array of Integer;

    rmtsVideoRawFifo: TTeFiFoBuffer;//
    rmtsVideoPesParser: TTePesParserThread;//
    rmtsVideoPesFiFo: TTePesVideoFiFoBuffer;//
    rmtsVideoProcessor: TTeVideoFrameProcessorThread;//
    rmtsVideoFrameFiFo: TTePesVideoFiFoBuffer;//

    rmtsAudioRawFifos: array of TTeFiFoBuffer;//
    rmtsAudioPesParsers: array of TTePesParserThread;//
    rmtsAudioPesFiFos: array of TTePesAudioFiFoBuffer;//
    rmtsAudioProcessors: array of TTeAudioFrameProcessorThread;//
    rmtsAudioFrameFiFos: array of TTePesAudioFiFoBuffer;//

    rmtsMuxFileName: string;
    rmtsMuxer: TTePesMuxerThread;//
    rmtsMuxFiFo: TTeFiFoBuffer;//
    rmtsMuxWriter: TTeWriterFileStreamThread;//

    rmtsSplittSize: Word;

    procedure CreateFiFos; virtual;
    procedure CreateWriterThreads; virtual;
    procedure CreateProcessingThreads; virtual;
    procedure CreateStreamingThreads; virtual;

    procedure DestoryStreamingThreads; virtual;
    procedure DestoryProcessingThreads; virtual;
    procedure DestoryWriterThreads; virtual;
    procedure DestoryFiFos; virtual;
  public
    constructor Create(aInTsFileName: string; aVideoID: Integer; aAudioIDs: array of Integer; aMuxFileName: string; aSplittSize: Word; aMessageCallback: TMessageCallback; aStateCallback: TStateCallback);
    destructor Destroy; override;
  end;

  TTeMuxProcessManager = class(TTeProcessManager)
  protected
    mpmVideoFileName: string;
    mpmVideoReader: TTeReaderFileStreamThread;
    mpmVideoRawFiFo: TTeFiFoBuffer;
    mpmVideoPesParser: TTePesParserThread;
    mpmVideoPesFiFo: TTePesVideoFiFoBuffer;
    mpmVideoProcessor: TTeVideoFrameProcessorThread;
    mpmVideoFrameFiFo: TTePesVideoFiFoBuffer;
    mpmVideoStartOffset: Integer;
    mpmVideoEndOffset: Integer;

    mpmAudioFileNames: array of string;
    mpmAudioReaders: array of TTeReaderFileStreamThread;
    mpmAudioRawFiFos: array of TTeFiFoBuffer;
    mpmAudioPesParsers: array of TTePesParserThread;
    mpmAudioPesFiFos: array of TTePesAudioFiFoBuffer;
    mpmAudioProcessors: array of TTeAudioFrameProcessorThread;
    mpmAudioFrameFiFos: array of TTePesAudioFiFoBuffer;

    mpmMuxFileName: string;
    mpmMuxer: TTePesMuxerThread;
    mpmMuxFiFo: TTeFiFoBuffer;
    mpmMuxWriter: TTeWriterFileStreamThread;

    mpmSplittSize: Word;

    procedure CreateFiFos; virtual;
    procedure CreateWriterThreads; virtual;
    procedure CreateProcessingThreads; virtual;
    procedure CreateStreamingThreads; virtual;

    procedure DestoryStreamingThreads; virtual;
    procedure DestoryProcessingThreads; virtual;
    procedure DestoryWriterThreads; virtual;
    procedure DestoryFiFos; virtual;
  public
    constructor Create(aVideoFileName: string; aVideoStartOffset, aVideoEndOffset: Integer; aAudioFileNames: array of string; aMuxFileName: string; aSplittSize: Word; aMessageCallback: TMessageCallback; aStateCallback: TStateCallback);
    destructor Destroy; override;
  end;

  TTeReMuxProcessManager = class(TTeProcessManager)
  protected
    rmpmMuxInFileName: string;
    rmpmMuxInReader: TTeReaderFileStreamThread;
    rmpmMuxInRawFiFo: TTeFiFoBuffer;
    rmpmMuxInPesParser: TTePesParserThread;

    rmpmMuxInPesSplitter: TTePesMuxInSplitter;
    rmpmVideoPesFiFo: TTePesVideoFiFoBuffer;
    rmpmAudioPesFiFo: TTePesAudioFiFoBuffer;

    rmpmMuxOutFileName: string;
    rmpmMuxer: TTePesMuxerThread;
    rmpmMuxOutFiFo: TTeFiFoBuffer;
    rmpmMuxOutWriter: TTeWriterFileStreamThread;

    rmpmSplittSize: Word;

    procedure CreateFiFos; virtual;
    procedure CreateWriterThreads; virtual;
    procedure CreateProcessingThreads; virtual;
    procedure CreateStreamingThreads; virtual;

    procedure DestoryStreamingThreads; virtual;
    procedure DestoryProcessingThreads; virtual;
    procedure DestoryWriterThreads; virtual;
    procedure DestoryFiFos; virtual;
  public
    constructor Create(aMuxInFileName, aMuxOutFileName: string; aSplittSize: Word; aMessageCallback: TMessageCallback; aStateCallback: TStateCallback);
    destructor Destroy; override;
  end;

  TTeSendPesManager = class(TTeProcessManager)
  private
    procedure DestoryProcessingThreads;
  protected
    spmIp: string;

    spmVideoPort: Word;
    spmAudioPort: Word;

    spmVideoFileName: string;
    spmAudioFileName: string;

    spmVideoReader: TTeReaderFileStreamThread;
    spmAudioReader: TTeReaderFileStreamThread;

    spmVideoFiFo: TTeFiFoBuffer;
    spmAudioFiFo: TTeFiFoBuffer;

    spmVideoSender: TTeTCPStreamThread;
    spmAudioSender: TTeTCPStreamThread;

    procedure CreateFiFos; virtual;
    procedure CreateReaderThreads; virtual;
    procedure CreateWriterThreads; virtual;

    procedure DestoryWriterThreads; virtual;
    procedure DestroyReaderThreads; virtual;
    procedure DestoryFiFos; virtual;
  public
    constructor Create(aIp: string; aVideoPort, aAudioPort: Word; aVideoFileName: string; aAudioFileName: string; aMessageCallback: TMessageCallback; aStateCallback: TStateCallback);
    destructor Destroy; override;
  end;

implementation

{ TTeGrabManager }

constructor TTeGrabManager.Create(aIp: string; aVideoID: Integer; aAudioIDs: array of Integer; aMessageCallback: TMessageCallback;
  aStateCallback: TStateCallback);
var
  i                           : Integer;
begin
  gmIp := aIp;
  gmVideoID := aVideoID;
  SetLength(gmAudioIDs, Length(aAudioIDs));
  for i := Low(aAudioIDs) to High(aAudioIDs) do
    gmAudioIDs[i] := aAudioIDs[i];

  SetLength(gmAudioRawFiFos, Length(aAudioIDs));
  SetLength(gmAudioReaders, Length(aAudioIDs));

  inherited Create(aMessageCallback, aStateCallback);

  CreateFiFos;
  CreateWriterThreads;
  CreateProcessingThreads;
  CreateStreamingThreads;
end;

procedure TTeGrabManager.CreateFiFos;
var
  i                           : Integer;
begin
  if gmVideoID <> 0 then
    gmVideoRawFiFo := TTeFiFoBuffer.Create(250 * 1024, 20);
  for i := Low(gmAudioIDs) to High(gmAudioIDs) do
    if gmAudioIDs[i] <> 0 then
      gmAudioRawFiFos[i] := TTeFiFoBuffer.Create(50 * 1024, 20);
end;

procedure TTeGrabManager.CreateProcessingThreads;
begin

end;

procedure TTeGrabManager.CreateStreamingThreads;
var
  i                           : Integer;
begin
  if gmVideoID <> 0 then
    gmVideoReader := TTeHTTPPesStreamThread.Create(AllocateLog('VideoHTTP'), tpTimeCritical, gmIP, 31338, gmVideoID, gmVideoRawFiFo);
  for i := Low(gmAudioIDs) to High(gmAudioIDs) do
    if gmAudioIDs[i] <> 0 then
      gmAudioReaders[i] := TTeHTTPPesStreamThread.Create(AllocateLog('AudioHTTP' + IntToStr(i)), tpTimeCritical, gmIP, 31338, gmAudioIDs[i], gmAudioRawFiFos[i]);
end;

procedure TTeGrabManager.CreateWriterThreads;
begin

end;

procedure TTeGrabManager.DestoryFiFos;
var
  i                           : Integer;
begin
  FreeAndNil(gmVideoRawFiFo);
  for i := Low(gmAudioRawFiFos) to High(gmAudioRawFiFos) do
    FreeAndNil(gmAudioRawFiFos[i]);
end;

procedure TTeGrabManager.DestoryProcessingThreads;
begin

end;

procedure TTeGrabManager.DestoryStreamingThreads;
var
  i                           : Integer;
begin
  FreeAndNil(gmVideoReader);
  for i := Low(gmAudioReaders) to High(gmAudioReaders) do
    FreeAndNil(gmAudioReaders[i]);
end;

procedure TTeGrabManager.DestoryWriterThreads;
begin

end;

destructor TTeGrabManager.Destroy;
begin
  DestoryStreamingThreads;
  DestoryProcessingThreads;
  DestoryWriterThreads;
  DestoryFiFos;
  inherited;
end;

{ TTeDirectGrabManager }

constructor TTeDirectGrabManager.Create(aIp: string; aVideoID: Integer; aAudioIDs: array of Integer;
  aVideoFileName: string; aAudioFilesName: array of string; aStripVideoPes: Boolean;
  aStripAudioPes: array of Boolean; aMessageCallback: TMessageCallback; aStateCallback: TStateCallback);
var
  i                           : Integer;
begin
  dgmVideoFileName := aVideoFileName;
  dgmStripVideoPes := aStripVideoPes;

  Assert(Length(aAudioIDs) = Length(aAudioFilesName));
  Assert(Length(aAudioIDs) = Length(aStripAudioPes));

  SetLength(dgmAudioFileNames, Length(aAudioIDs));
  SetLength(dgmAudioWriters, Length(aAudioIDs));
  SetLength(dgmStripAudioPes, Length(aAudioIDs));
  SetLength(dgmAudioPesParsers, Length(aAudioIDs));
  SetLength(dgmAudioPesFiFos, Length(aAudioIDs));
  for i := Low(aAudioIDs) to High(aAudioIDs) do begin
    dgmAudioFileNames[i] := aAudioFilesName[i];
    dgmStripAudioPes[i] := aStripAudioPes[i];
  end;

  inherited Create(aIp, aVideoID, aAudioIDs, aMessageCallback, aStateCallback);
end;

procedure TTeDirectGrabManager.CreateFiFos;
var
  i                           : Integer;
begin
  inherited;
  if gmVideoID <> 0 then
    if dgmStripVideoPes then
      dgmVideoPesFiFo := TTePesVideoFiFoBuffer.Create(25);
  for i := Low(dgmStripAudioPes) to High(dgmStripAudioPes) do
    if gmAudioIDs[i] <> 0 then
      if dgmStripAudioPes[i] then
        dgmAudioPesFiFos[i] := TTePesAudioFiFoBuffer.Create(25);
end;

procedure TTeDirectGrabManager.CreateProcessingThreads;
var
  i                           : Integer;
begin
  inherited;
  for i := Low(dgmStripAudioPes) to High(dgmStripAudioPes) do
    if gmAudioIDs[i] <> 0 then
      if dgmStripAudioPes[i] then
        dgmAudioPesParsers[i] := TTePesParserThread.Create(AllocateLog('AudioPesParser' + IntToStr(i)), tpNormal, gmAudioRawFiFos[i], dgmAudioPesFiFos[i], True);
  if dgmStripVideoPes then
    if gmVideoID <> 0 then
      dgmVideoPesParser := TTePesParserThread.Create(AllocateLog('VideoPesParser'), tpNormal, gmVideoRawFiFo, dgmVideoPesFiFo, True);
end;

procedure TTeDirectGrabManager.CreateWriterThreads;
var
  i                           : Integer;
begin
  inherited;
  for i := Low(dgmStripAudioPes) to High(dgmStripAudioPes) do
    if gmAudioIDs[i] <> 0 then
      if dgmStripAudioPes[i] then
        dgmAudioWriters[i] := TTeWriterFileStreamThread.Create(AllocateLog('AudioWriter' + IntToStr(i)), tpNormal, dgmAudioFileNames[i], dgmAudioPesFiFos[i], False)
      else
        dgmAudioWriters[i] := TTeWriterFileStreamThread.Create(AllocateLog('AudioWriter' + IntToStr(i)), tpNormal, dgmAudioFileNames[i], gmAudioRawFiFos[i], False);

  if gmVideoID <> 0 then
    if dgmStripVideoPes then
      dgmVideoWriter := TTeWriterFileStreamThread.Create(AllocateLog('VideoWriter'), tpNormal, dgmVideoFileName, dgmVideoPesFiFo, False)
    else
      dgmVideoWriter := TTeWriterFileStreamThread.Create(AllocateLog('VideoWriter'), tpNormal, dgmVideoFileName, gmVideoRawFiFo, False);
end;

procedure TTeDirectGrabManager.DestoryFiFos;
var
  i                           : Integer;
begin
  for i := Low(dgmAudioPesFiFos) to High(dgmAudioPesFiFos) do
    FreeAndNil(dgmAudioPesFiFos[i]);
  FreeAndNil(dgmVideoPesFiFo);
  inherited;
end;

procedure TTeDirectGrabManager.DestoryProcessingThreads;
var
  i                           : Integer;
begin
  for i := Low(dgmAudioPesParsers) to High(dgmAudioPesParsers) do
    FreeAndNil(dgmAudioPesParsers[i]);
  FreeAndNil(dgmVideoPesParser);
  inherited;
end;

procedure TTeDirectGrabManager.DestoryWriterThreads;
var
  i                           : Integer;
begin
  FreeAndNil(dgmVideoWriter);
  for i := Low(dgmAudioWriters) to High(dgmAudioWriters) do
    FreeAndNil(dgmAudioWriters[i]);
  inherited;
end;

{ TTeMuxGrabManager }

constructor TTeMuxGrabManager.Create(aIp: string; aVideoID: Integer; aAudioIDs: array of Integer;
  aMuxFileName: string; aSplittSize: Word; aMessageCallback: TMessageCallback; aStateCallback: TStateCallback);
begin
  mgmSplittSize := aSplittSize;
  mgmMuxFileName := Trim(aMuxFileName);

  SetLength(mgmAudioPesParsers, Length(aAudioIDs));
  SetLength(mgmAudioPesFiFos, Length(aAudioIDs));
  SetLength(mgmAudioProcessors, Length(aAudioIDs));
  SetLength(mgmAudioFrameFiFos, Length(aAudioIDs));
  inherited Create(aIp, aVideoID, aAudioIDs, aMessageCallback, aStateCallback);
end;

procedure TTeMuxGrabManager.CreateFiFos;
var
  i                           : Integer;
begin
  mgmVideoPesFiFo := TTePesVideoFiFoBuffer.Create;
  mgmVideoFrameFiFo := TTePesVideoFiFoBuffer.Create;
  for i := Low(mgmAudioPesFiFos) to High(mgmAudioPesFiFos) do
    if gmAudioIDs[i] <> 0 then begin
      mgmAudioPesFiFos[i] := TTePesAudioFiFoBuffer.Create;
      mgmAudioFrameFiFos[i] := TTePesAudioFiFoBuffer.Create;
    end;
  if mgmMuxFileName <> '' then
    mgmMuxFiFo := TTeFiFoBuffer.Create(0, 0);
  inherited;
end;

procedure TTeMuxGrabManager.CreateProcessingThreads;
var
  i                           : Integer;
begin
  mgmMuxer := TTePesMuxerThread.Create(AllocateLog('Muxer'), tpNormal, mgmAudioFrameFiFos, mgmVideoFrameFiFo, mgmMuxFiFo, mgmSplittSize);
  mgmVideoProcessor := TTeVideoFrameProcessorThread.Create(AllocateLog('VideoProcessor'), tpLower, mgmVideoPesFiFo, mgmVideoFrameFiFo, -1, -1);
  mgmVideoPesParser := TTePesParserThread.Create(AllocateLog('VideoPesParser'), tpNormal, gmVideoRawFiFo, mgmVideoPesFiFo, False);
  for i := Low(mgmAudioPesFiFos) to High(mgmAudioPesFiFos) do
    if gmAudioIDs[i] <> 0 then begin
      mgmAudioProcessors[i] := TTeAudioFrameProcessorThread.Create(AllocateLog('AudioProcessor' + IntToStr(i)), tpLower, mgmAudioPesFiFos[i], mgmAudioFrameFiFos[i]);
      mgmAudioPesParsers[i] := TTePesParserThread.Create(AllocateLog('AudioPesParser' + IntToStr(i)), tpNormal, gmAudioRawFiFos[i], mgmAudioPesFiFos[i], False);
    end;
  inherited;
end;

procedure TTeMuxGrabManager.CreateWriterThreads;
begin
  if mgmMuxFileName <> '' then
    mgmMuxWriter := TTeWriterFileStreamThread.Create(AllocateLog('MuxWriter'), tpNormal, mgmMuxFileName, mgmMuxFiFo, mgmSplittSize > 0);
  inherited;
end;

procedure TTeMuxGrabManager.DestoryFiFos;
var
  i                           : Integer;
begin
  inherited;
  FreeAndNil(mgmMuxFiFo);
  FreeAndNil(mgmVideoFrameFiFo);
  FreeAndNil(mgmVideoPesFiFo);
  for i := Low(mgmAudioFrameFiFos) to High(mgmAudioFrameFiFos) do begin
    FreeAndNil(mgmAudioFrameFiFos[i]);
    FreeAndNil(mgmAudioPesFiFos[i]);
  end;
end;

procedure TTeMuxGrabManager.DestoryProcessingThreads;
var
  i                           : Integer;
begin
  inherited;
  FreeAndNil(mgmVideoPesParser);
  FreeAndNil(mgmVideoProcessor);
  for i := Low(mgmAudioPesParsers) to High(mgmAudioPesParsers) do begin
    FreeAndNil(mgmAudioPesParsers[i]);
    FreeAndNil(mgmAudioProcessors[i]);
  end;
  FreeAndNil(mgmMuxer);
end;

procedure TTeMuxGrabManager.DestoryWriterThreads;
begin
  inherited;
  FreeAndNil(mgmMuxWriter);
end;

{ TTeMuxProcessManager }

constructor TTeMuxProcessManager.Create(aVideoFileName: string; aVideoStartOffset, aVideoEndOffset: Integer; aAudioFileNames: array of string; aMuxFileName: string; aSplittSize: Word; aMessageCallback: TMessageCallback; aStateCallback: TStateCallback);
var
  i                           : Integer;
begin
  mpmSplittSize := aSplittSize;
  mpmVideoFileName := aVideoFileName;
  mpmVideoStartOffset := aVideoStartOffset;
  mpmVideoEndOffset := aVideoEndOffset;

  SetLength(mpmAudioFileNames, Length(aAudioFileNames));
  SetLength(mpmAudioReaders, Length(aAudioFileNames));
  SetLength(mpmAudioRawFiFos, Length(aAudioFileNames));
  SetLength(mpmAudioPesParsers, Length(aAudioFileNames));
  SetLength(mpmAudioPesFiFos, Length(aAudioFileNames));
  SetLength(mpmAudioProcessors, Length(aAudioFileNames));
  SetLength(mpmAudioFrameFiFos, Length(aAudioFileNames));

  for i := Low(aAudioFileNames) to High(aAudioFileNames) do
    mpmAudioFileNames[i] := Trim(aAudioFileNames[i]);

  mpmMuxFileName := Trim(aMuxFileName);
  inherited Create(aMessageCallback, aStateCallback);

  CreateFiFos;
  CreateWriterThreads;
  CreateProcessingThreads;
  CreateStreamingThreads;
end;

procedure TTeMuxProcessManager.CreateFiFos;
var
  i                           : Integer;
begin
  mpmVideoRawFiFo := TTeFiFoBuffer.Create(250 * 1024, 20, 20);
  mpmVideoPesFiFo := TTePesVideoFiFoBuffer.Create(500);
  mpmVideoFrameFiFo := TTePesVideoFiFoBuffer.Create(100);

  for i := Low(mpmAudioFileNames) to High(mpmAudioFileNames) do
    if mpmAudioFileNames[i] <> '' then begin
      mpmAudioRawFiFos[i] := TTeFiFoBuffer.Create(50 * 1024, 20, 20);
      mpmAudioPesFiFos[i] := TTePesAudioFiFoBuffer.Create(250);
      mpmAudioFrameFiFos[i] := TTePesAudioFiFoBuffer.Create(100);
    end;

  if mpmMuxFileName <> '' then
    mpmMuxFiFo := TTeFiFoBuffer.Create(0, 0, 20);
end;

procedure TTeMuxProcessManager.CreateProcessingThreads;
var
  i                           : Integer;
begin
  mpmMuxer := TTePesMuxerThread.Create(AllocateLog('Muxer'), tpLower, mpmAudioFrameFiFos, mpmVideoFrameFiFo, mpmMuxFiFo, mpmSplittSize);
  mpmVideoProcessor := TTeVideoFrameProcessorThread.Create(AllocateLog('VideoFrameProcessor'), tpLower, mpmVideoPesFiFo, mpmVideoFrameFiFo, mpmVideoStartOffset, mpmVideoEndOffset);
  mpmVideoPesParser := TTePesParserThread.Create(AllocateLog('VideoPesParser'), tpLower, mpmVideoRawFiFo, mpmVideoPesFiFo, False);

  for i := Low(mpmAudioFileNames) to High(mpmAudioFileNames) do
    if mpmAudioFileNames[i] <> '' then begin
      mpmAudioProcessors[i] := TTeAudioFrameProcessorThread.Create(AllocateLog('AudioFrameProcessor' + IntToStr(i)), tpLower, mpmAudioPesFiFos[i], mpmAudioFrameFiFos[i]);
      mpmAudioPesParsers[i] := TTePesParserThread.Create(AllocateLog('AudioPesParser' + IntToStr(i)), tpLower, mpmAudioRawFiFos[i], mpmAudioPesFiFos[i], False);
    end;
end;

procedure TTeMuxProcessManager.CreateStreamingThreads;
var
  i                           : Integer;
begin
  mpmVideoReader := TTeReaderFileStreamThread.Create(AllocateLog('VideoReader'), tpLower, mpmVideoFileName, mpmVideoRawFiFo);
  for i := Low(mpmAudioFileNames) to High(mpmAudioFileNames) do
    if mpmAudioFileNames[i] <> '' then
      mpmAudioReaders[i] := TTeReaderFileStreamThread.Create(AllocateLog('AudioReader' + IntToStr(i)), tpLower, mpmAudioFileNames[i], mpmAudioRawFiFos[i]);
end;

procedure TTeMuxProcessManager.CreateWriterThreads;
begin
  if mpmMuxFileName <> '' then
    mpmMuxWriter := TTeWriterFileStreamThread.Create(AllocateLog('MuxWriter'), tpLower, mpmMuxFileName, mpmMuxFiFo, mpmSplittSize > 0);
end;

procedure TTeMuxProcessManager.DestoryFiFos;
var
  i                           : Integer;
begin
  FreeAndNil(mpmMuxFiFo);
  FreeAndNil(mpmVideoFrameFiFo);
  FreeAndNil(mpmVideoPesFiFo);
  FreeAndNil(mpmVideoRawFiFo);

  for i := Low(mpmAudioFrameFiFos) to High(mpmAudioFrameFiFos) do begin
    FreeAndNil(mpmAudioFrameFiFos[i]);
    FreeAndNil(mpmAudioPesFiFos[i]);
    FreeAndNil(mpmAudioRawFiFos[i]);
  end;
end;

procedure TTeMuxProcessManager.DestoryProcessingThreads;
var
  i                           : Integer;
begin
  FreeAndNil(mpmVideoPesParser);
  FreeAndNil(mpmVideoProcessor);
  for i := Low(mpmAudioPesParsers) to High(mpmAudioPesParsers) do begin
    FreeAndNil(mpmAudioPesParsers[i]);
    FreeAndNil(mpmAudioProcessors[i]);
  end;
  FreeAndNil(mpmMuxer);
end;

procedure TTeMuxProcessManager.DestoryStreamingThreads;
var
  i                           : Integer;
begin
  FreeAndNil(mpmVideoReader);
  for i := Low(mpmAudioReaders) to High(mpmAudioReaders) do
    FreeAndNil(mpmAudioReaders[i]);
end;

procedure TTeMuxProcessManager.DestoryWriterThreads;
begin
  FreeAndNil(mpmMuxWriter);
end;

destructor TTeMuxProcessManager.Destroy;
begin
  DestoryStreamingThreads;
  DestoryProcessingThreads;
  DestoryWriterThreads;
  DestoryFiFos;
  inherited;
end;

{ TTeReMuxProcessManager }

constructor TTeReMuxProcessManager.Create(aMuxInFileName, aMuxOutFileName: string; aSplittSize: Word; aMessageCallback: TMessageCallback; aStateCallback: TStateCallback);
begin
  rmpmSplittSize := aSplittSize;
  rmpmMuxOutFileName := aMuxOutFileName;
  rmpmMuxInFileName := aMuxInFileName;
  inherited Create(aMessageCallback, aStateCallback);

  CreateFiFos;
  CreateWriterThreads;
  CreateProcessingThreads;
  CreateStreamingThreads;
end;

procedure TTeReMuxProcessManager.CreateFiFos;
begin
  rmpmMuxInRawFiFo := TTeFiFoBuffer.Create(250 * 1024, 5, 5);

  rmpmVideoPesFiFo := TTePesVideoFiFoBuffer.Create(100);
  rmpmAudioPesFiFo := TTePesAudioFiFoBuffer.Create(50);
  rmpmMuxInPesSplitter := TTePesMuxInSplitter.Create(AllocateLog('MuxInSplitter'), rmpmVideoPesFiFo, rmpmAudioPesFiFo);

  rmpmMuxOutFiFo := TTeFiFoBuffer.Create(0, 0, 2);
end;

procedure TTeReMuxProcessManager.CreateProcessingThreads;
begin
  rmpmMuxer := TTePesMuxerThread.Create(AllocateLog('Muxer'), tpLower, rmpmAudioPesFiFo, rmpmVideoPesFiFo, rmpmMuxOutFiFo, rmpmSplittSize);
  rmpmMuxInPesParser := TTePesParserThread.Create(AllocateLog('MuxInPesParser'), tpLower, rmpmMuxInRawFiFo, rmpmMuxInPesSplitter, False);
end;

procedure TTeReMuxProcessManager.CreateStreamingThreads;
begin
  rmpmMuxInReader := TTeReaderFileStreamThread.Create(AllocateLog('MuxInReader'), tpLower, rmpmMuxInFileName, rmpmMuxInRawFiFo);
end;

procedure TTeReMuxProcessManager.CreateWriterThreads;
begin
  rmpmMuxOutWriter := TTeWriterFileStreamThread.Create(AllocateLog('MuxWriter'), tpLower, rmpmMuxOutFileName, rmpmMuxOutFiFo, rmpmSplittSize > 0);
end;

procedure TTeReMuxProcessManager.DestoryFiFos;
begin
  FreeAndNil(rmpmMuxOutFiFo);
  FreeAndNil(rmpmMuxInPesSplitter);
  FreeAndNil(rmpmAudioPesFiFo);
  FreeAndNil(rmpmVideoPesFiFo);
  FreeAndNil(rmpmMuxInRawFiFo);
end;

procedure TTeReMuxProcessManager.DestoryProcessingThreads;
begin
  FreeAndNil(rmpmMuxInPesParser);
  FreeAndNil(rmpmMuxer);
end;

procedure TTeReMuxProcessManager.DestoryStreamingThreads;
begin
  FreeAndNil(rmpmMuxInReader);
end;

procedure TTeReMuxProcessManager.DestoryWriterThreads;
begin
  FreeAndNil(rmpmMuxOutWriter);
end;

destructor TTeReMuxProcessManager.Destroy;
begin
  DestoryStreamingThreads;
  DestoryProcessingThreads;
  DestoryWriterThreads;
  DestoryFiFos;
  inherited;
end;

{ TTeSendPesManager }

constructor TTeSendPesManager.Create(aIp: string; aVideoPort,
  aAudioPort: Word; aVideoFileName, aAudioFileName: string;
  aMessageCallback: TMessageCallback; aStateCallback: TStateCallback);
begin
  spmIp := aIp;
  spmVideoPort := aVideoPort;
  spmAudioPort := aAudioPort;
  spmVideoFileName := aVideoFileName;
  spmAudioFileName := aAudioFileName;
  inherited Create(aMessageCallback, aStateCallback);

  CreateFiFos;
  CreateWriterThreads;
  CreateReaderThreads;
end;

procedure TTeSendPesManager.CreateFiFos;
begin
  if spmVideoFileName <> '' then
    spmVideoFiFo := TTeFiFoBuffer.Create(250 * 1024, 5, 5);
  if spmAudioFileName <> '' then
    spmAudioFiFo := TTeFiFoBuffer.Create(50 * 1024, 5, 5);
end;

procedure TTeSendPesManager.CreateReaderThreads;
begin
  if spmVideoFileName <> '' then
    spmVideoReader := TTeReaderFileStreamThread.Create(AllocateLog('VideoReader'), tpHigher, spmVideoFileName, spmVideoFiFo);
  if spmAudioFileName <> '' then
    spmAudioReader := TTeReaderFileStreamThread.Create(AllocateLog('AudioReader'), tpHigher, spmAudioFileName, spmAudioFiFo);
end;

procedure TTeSendPesManager.CreateWriterThreads;
begin
  Sleep(1000);
  if spmAudioFileName <> '' then begin
    spmAudioSender := TTeTCPStreamThread.Create(AllocateLog('AudioSender'), tpNormal, spmIp, spmAudioPort, spmAudioFiFo);
    Sleep(500);
  end;
  if spmVideoFileName <> '' then
    spmVideoSender := TTeTCPStreamThread.Create(AllocateLog('VideoSender'), tpNormal, spmIp, spmVideoPort, spmVideoFiFo);
end;

procedure TTeSendPesManager.DestoryFiFos;
begin
  FreeAndNil(spmAudioFiFo);
  FreeAndNil(spmVideoFiFo);
end;

procedure TTeSendPesManager.DestoryProcessingThreads;
begin
  FreeAndNil(spmVideoReader);
  FreeAndNil(spmAudioReader);
end;

procedure TTeSendPesManager.DestoryWriterThreads;
begin
  FreeAndNil(spmVideoSender);
  FreeAndNil(spmAudioSender);
end;

destructor TTeSendPesManager.Destroy;
begin
  inherited;

  DestoryWriterThreads;
  DestroyReaderThreads;
  DestoryFiFos;
end;

procedure TTeSendPesManager.DestroyReaderThreads;
begin

end;

{ TTeReMuxTsProcessManager }

constructor TTeReMuxTsProcessManager.Create(aInTsFileName: string;
  aVideoID: Integer; aAudioIDs: array of Integer; aMuxFileName: string;
  aSplittSize: Word; aMessageCallback: TMessageCallback;
  aStateCallback: TStateCallback);
var
  i: Integer;
begin
  rmtsSplittSize := aSplittSize;
  rmtsMuxFileName := aMuxFileName;
  rmtsTsFileName := aInTsFileName;

  SetLength(rmtsAudioRawFifos, Length(aAudioIDs));
  SetLength(rmtsAudioPesParsers, Length(aAudioIDs));
  SetLength(rmtsAudioPesFiFos, Length(aAudioIDs));
  SetLength(rmtsAudioProcessors, Length(aAudioIDs));
  SetLength(rmtsAudioFrameFiFos, Length(aAudioIDs));

  rmtsVideoID := aVideoID;
  SetLength(rmtsAudioIDs, Length(aAudioIDs));
  for i := Low(aAudioIDs) to High(aAudioIDs) do
    rmtsAudioIDs[i] := aAudioIDs[i];

  inherited Create(aMessageCallback, aStateCallback);

  CreateFiFos;
  CreateWriterThreads;
  CreateProcessingThreads;
  CreateStreamingThreads;
end;

procedure TTeReMuxTsProcessManager.CreateFiFos;
var
  i                           : Integer;
begin
  rmtsTsFiFo := TTeFiFoBuffer.Create(188 * 1024, 5, 5);

  if rmtsVideoID <> 0 then begin
    rmtsVideoRawFiFo := TTeFiFoBuffer.Create(250 * 1024, 20);
    rmtsVideoPesFiFo := TTePesVideoFiFoBuffer.Create;
    rmtsVideoFrameFiFo := TTePesVideoFiFoBuffer.Create;
  end;


  for i := Low(rmtsAudioIDs) to High(rmtsAudioIDs) do
    if rmtsAudioIDs[i] <> 0 then begin
      rmtsAudioRawFiFos[i] := TTeFiFoBuffer.Create(50 * 1024, 20);
      rmtsAudioPesFiFos[i] := TTePesAudioFiFoBuffer.Create;
      rmtsAudioFrameFiFos[i] := TTePesAudioFiFoBuffer.Create;
    end;

  if rmtsMuxFileName <> '' then
    rmtsMuxFiFo := TTeFiFoBuffer.Create(0, 0);
end;

procedure TTeReMuxTsProcessManager.CreateProcessingThreads;
var
  i                           : Integer;
begin
  rmtsMuxer := TTePesMuxerThread.Create(AllocateLog('Muxer'), tpNormal, rmtsAudioFrameFiFos, rmtsVideoFrameFiFo, rmtsMuxFiFo, rmtsSplittSize);
  rmtsVideoProcessor := TTeVideoFrameProcessorThread.Create(AllocateLog('VideoProcessor'), tpLower, rmtsVideoPesFiFo, rmtsVideoFrameFiFo, -1, -1);
  rmtsVideoPesParser := TTePesParserThread.Create(AllocateLog('VideoPesParser'), tpNormal, rmtsVideoRawFiFo, rmtsVideoPesFiFo, False);
  for i := Low(rmtsAudioPesFiFos) to High(rmtsAudioPesFiFos) do
    if rmtsAudioIDs[i] <> 0 then begin
      rmtsAudioProcessors[i] := TTeAudioFrameProcessorThread.Create(AllocateLog('AudioProcessor' + IntToStr(i)), tpLower, rmtsAudioPesFiFos[i], rmtsAudioFrameFiFos[i]);
      rmtsAudioPesParsers[i] := TTePesParserThread.Create(AllocateLog('AudioPesParser' + IntToStr(i)), tpNormal, rmtsAudioRawFiFos[i], rmtsAudioPesFiFos[i], False);
    end;
  rmtsTsTsParser := TTeTsParserThread.Create(AllocateLog('TsParser'),tpNormal,rmtsTsFiFo, rmtsVideoID, rmtsVideoRawFifo, rmtsAudioIDs, rmtsAudioRawFifos);
  inherited;
end;

procedure TTeReMuxTsProcessManager.CreateStreamingThreads;
begin
  rmtsTsReader := TTeReaderFileStreamThread.Create(AllocateLog('TsReader'), tpLower, rmtsTsFileName, rmtsTsFiFo);
end;

procedure TTeReMuxTsProcessManager.CreateWriterThreads;
begin
  rmtsMuxWriter := TTeWriterFileStreamThread.Create(AllocateLog('MuxWriter'), tpLower, rmtsMuxFileName, rmtsMuxFiFo, rmtsSplittSize > 0);
end;

procedure TTeReMuxTsProcessManager.DestoryFiFos;
var
  i                           : Integer;
begin
  FreeAndNil(rmtsMuxFiFo);

  for i := Low(rmtsAudioRawFiFos) to High(rmtsAudioRawFiFos) do begin
    FreeAndNil(rmtsAudioFrameFiFos[i]);
    FreeAndNil(rmtsAudioPesFiFos[i]);
    FreeAndNil(rmtsAudioRawFiFos[i]);
  end;

  FreeAndNil(rmtsVideoFrameFiFo);
  FreeAndNil(rmtsVideoPesFiFo);
  FreeAndNil(rmtsVideoRawFiFo);

  FreeAndNil(rmtsTsFiFo);
end;

procedure TTeReMuxTsProcessManager.DestoryProcessingThreads;
var
  i                           : Integer;
begin
  inherited;
  FreeAndNil(rmtsTsTsParser);
  for i := Low(rmtsAudioPesParsers) to High(rmtsAudioPesParsers) do begin
    FreeAndNil(rmtsAudioPesParsers[i]);
    FreeAndNil(rmtsAudioProcessors[i]);
  end;
  FreeAndNil(rmtsVideoPesParser);
  FreeAndNil(rmtsVideoProcessor);
  FreeAndNil(rmtsMuxer);
end;

procedure TTeReMuxTsProcessManager.DestoryStreamingThreads;
begin
  FreeAndNil(rmtsTsReader);
end;

procedure TTeReMuxTsProcessManager.DestoryWriterThreads;
begin
  FreeAndNil(rmtsMuxWriter);
end;

destructor TTeReMuxTsProcessManager.Destroy;
begin
  DestoryStreamingThreads;
  DestoryProcessingThreads;
  DestoryWriterThreads;
  DestoryFiFos;
  inherited;
end;

end.

