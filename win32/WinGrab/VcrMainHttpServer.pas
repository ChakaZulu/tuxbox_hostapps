////////////////////////////////////////////////////////////////////////////////
//
// $Log: VcrMainHttpServer.pas,v $
// Revision 1.1  2004/07/02 14:02:37  thotto
// initial
//
//

////////////////////////////////////////////////////////////////////////////////
//
//  HTTP-Server to send mpeg streams back to the DBox ...
//
procedure TfrmMain.IdHTTPServerCommandGet(AThread:      TIdPeerThread;
                                          RequestInfo:  TIdHTTPRequestInfo;
                                          ResponseInfo: TIdHTTPResponseInfo);
begin
  Beep;
end;

type
  TIdHTTPResponseInfoHack = class(TIdHTTPResponseInfo);

procedure TfrmMain.IdHTTPServerCommandOther(Thread: TIdPeerThread;
                                            const asCommand, asData, asVersion: string);
var
  LResponseInfo               : TIdHTTPResponseInfoHack;
//  FileStream                  : TFileStream;
//  BytesRead                   : Integer;
//  Buffer                      : array[Word] of Byte;
  i                           : Integer;
  Output                      : TTeBufferPage;
  OutputStream                : TTeFiFoBuffer;
begin
  LResponseInfo := TIdHTTPResponseInfoHack(TIdHTTPResponseInfo.Create(Thread.Connection));
  try
    _OutputStreamLock.Enter;
    try
      LResponseInfo.FHeaders.Values['Server']         := Application.Title; // .RawHeaders.Values
      LResponseInfo.FHeaders.Values['Content-Length'] := IntToStr(High(Integer));
      LResponseInfo.FHeaders.Values['Connection']     := 'close';
      LResponseInfo.FHeaders.Values['Content-Type']   := 'video/mpeg';
      LResponseInfo.ContentType                       := 'video/mpeg';
      LResponseInfo.FServerSoftware                   := Application.Title;
      if not LResponseInfo.HeaderHasBeenWritten then
      begin
        LResponseInfo.WriteHeader;
      end;

      if LResponseInfo.FResponseNo = 404 then
        exit;

      OutputStream := TTeFiFoBuffer.Create(0, 0, 250);
      if not assigned(_OutputStream) then
        _OutputStream := TObjectList.Create;

      _OutputStream.Add(OutputStream);
    finally
      _OutputStreamLock.Leave;
    end;

    try
      i := 0;
      //---------------------------------------------
      repeat
        Output := OutputStream.GetReadPage(False);
        if Output = nil then
        begin
          Sleep(100);
          Inc(i);
        end else
        try
          with LResponseInfo.FConnection do
          begin
            WriteBuffer(Output.Memory^, Output.Size);
            i := 0;
          end;
        finally
          Output.Finished;
        end;
      until i = 100;
      //---------------------------------------------
    finally
      _OutputStreamLock.Enter;
      try
        if Assigned(_OutputStream) then
        begin
          _OutputStream.Remove(OutputStream);
          if _OutputStream.Count < 1 then
            FreeAndNil(_OutputStream);
        end;
      finally
        _OutputStreamLock.Leave;
      end;
      FreeAndNil(OutputStream);
    end;
  finally
    LResponseInfo.Free;
  end;
end;
//
//  HTTP-Server to send stream back to the DBox ...
//
////////////////////////////////////////////////////////////////////////////////
