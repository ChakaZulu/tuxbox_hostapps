////////////////////////////////////////////////////////////////////////////////
//
// $Log: VcrDivXchk.pas,v $
// Revision 1.1  2004/07/02 14:21:21  thotto
// initial
//
//
unit VcrDivXchk;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, ComCtrls, StdCtrls, ExtCtrls,
  JclShell,
  JclSysInfo,
  IdGlobal,
  DelTools;

type
  TFrmDivXchk = class(TForm)
    Panel1: TPanel;
    lblFileName: TLabel;
    ProgressBar: TProgressBar;
    StartupTimer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure StartupTimerTimer(Sender: TObject);

  private
    function  CheckDivX(sAviFile: String): Boolean;
    procedure ZeroAlign(Var Text : String);
    function  CheckOtherIndex(Var Input : File) : Cardinal;

  public
    { Public declarations }
    
  end;

Function CheckDivXFile(sAviFile: String): Boolean;

var
  FrmDivXchk: TFrmDivXchk;
  strAviFile: String;
  bRes      : Boolean;


implementation

{$R *.dfm}

{#####################################################################}

Function CheckDivXFile(sAviFile: String): Boolean;
var
  OldCur : TCursor;
begin
  OldCur:= Screen.Cursor;
  Result := false;
  bRes   := false;
  try
    Screen.Cursor:= crDefault;
    Application.CreateForm(TFrmDivXchk, FrmDivXchk);
    strAviFile := sAviFile;
    FrmDivXchk.ShowModal;
    Result := bRes;
  finally
    FrmDivXchk.Free;
    Screen.Cursor:= OldCur;
  end;
end;


procedure TFrmDivXchk.FormCreate(Sender: TObject);
begin
  StartupTimer.Enabled := true;
end;

procedure TFrmDivXchk.StartupTimerTimer(Sender: TObject);
begin
  try
    StartupTimer.Enabled := false;
    lblFileName.Caption  := 'checking '+ExtractFileName(strAviFile);
    bRes:= CheckDivX(strAviFile);
  finally
    FrmDivXchk.Close;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
//
//
//
procedure TFrmDivXchk.ZeroAlign(Var Text : String);
Var
  i	: Integer;
begin
	For i:=1 To Length(Text) Do
  	If Text[i]=' ' Then Text[i]:='0';
end;

////////////////////////////////////////////////////////////////////////////////
//
//
//
function TFrmDivXchk.CheckOtherIndex(Var Input : File) : Cardinal;
Var	Position,i	:	Cardinal;
		OldPosition	:	Cardinal;
    Buffer			:	Array [0..32800] of Byte;
    Text				:	String[2];
    Text2				:	String[4];
    Temp				:	Integer;
Const
  	KeyFrame  :	Longint = 16;
    NormFrame	:	Longint = 0;
    Number		:	Set of char =['0'..'9'];
begin
	OldPosition:=FilePos(Input);
  Seek(Input,FileSize(Input)-32768);
  BlockRead(Input,Buffer,32768);
  Text2:='    ';
  i:=32768;
  Repeat
	  Move(Buffer[i],Text2[1],4);
    Text:=Copy(Text2,3,2);
  	Dec(i);
  Until (i<0) Or
        ( ((Text='dc') Or
           (Text='db') Or
           (Text='wb')) And
          ((Text2[1] In Number) And
           (Text2[2] In Number)) ) Or
        (Text2='idx1');

  If (((Text='dc') Or (Text='db') Or (Text='wb')) And ((Text2[1] In Number) And (Text2[2] In Number))) Then
  Begin
  	Move(Buffer[i-15],Text2[1],4);
    Text:=Copy(Text2,3,2);
    If (((Text='dc') Or (Text='db') Or (Text='wb')) And ((Text2[1] In Number) And (Text2[2] In Number))) Then
    Begin
		  Position:=FileSize(Input);
		  i:=32768;
		  If Position>32768 Then
		  Repeat
				Dec(Position,32764);
		    Seek(Input,Position);
		    BlockRead(Input,Buffer,32768,Temp);
		    i:=Temp;
		    Repeat
					Dec(i);
		      Move(Buffer[i],Text2[1],4);
		    Until (i<1) Or (Text2='idx1');
			Until (Position<32768) Or (Text2='idx1');
		  If (Position<32768) And (Text2<>'idx1') Then
		  Begin
		  	i:=Position;
		    Position:=0;
		    Seek(Input,0);
		    Repeat
					Dec(i);
		      Move(Buffer[i],Text2[1],4);
		    Until (i<1) Or (Text2='idx1');
		  End;
		  Seek(Input,OldPosition);
		  If Text2='idx1' Then
        Result:=Position+i
		  Else
        Result:=0;
    End Else
      Result:=0;
  End Else
    Result:=0;
end;

////////////////////////////////////////////////////////////////////////////////
//
//
//
function TFrmDivXchk.CheckDivX(sAviFile: String): Boolean;
var
  Input       				: File;
  i,j,k								:	Cardinal;
  Size,Position				:	Cardinal;
  Scale,Rate					:	Cardinal;
  StreamStart					:	Cardinal;
  IndexStart					:	Cardinal;
  StreamSize					:	Cardinal;
  AVISize							:	Cardinal;
  Difference					:	Cardinal;
  IndexDifference			:	Cardinal;
  Frame,Time					:	Cardinal;
  LastIndexPosition		:	Cardinal;
  LastBackupPosition	:	Cardinal;
  LastFrame,LastIndex	:	Cardinal;
  Item								:	Cardinal;
  Errors							:	Cardinal;
  FrameType						:	Cardinal;
  KeyType							:	Cardinal;
  Interleaved		  	  : Boolean;
  OnTop								:	Boolean;
  Logging							:	Boolean;
  CommandLine					:	Boolean;
  CfgStay							:	Boolean;
  CfgClear						:	Boolean;
  CfgCList						:	Boolean;
  CfgKeep							:	Boolean;
  CfgCut							:	Boolean;
  CfgLog							:	Boolean;
  CfgDir							:	String;
  CfgDest							:	String;
  ConfigDir						:	String;
  Text,Hour,Minute		: String;
  Second							:	String;
  Text2								:	String[2];
  Codec								:	String[4];
  Chunkname						:	String[8];
  Temp								: integer;
  Buffer							:	Array [0..32800] Of Byte;
  strFileName,
  strFileSize : String;
  
Const
  KeyFrame  :	Longint = 16;
  NormFrame	:	Longint = 0;
  Number		:	Set of char =['0'..'9'];

Label BError;
Label BStartRead;

begin
  Result:= False;
  try
    Errors := 0;
    AssignFile(Input,sAviFile);
    {$I-}
    FileMode:=0;
    Reset(Input,1);
    FileMode:=2;
    {$I+}
    If IOResult<>0 Then
    Begin
      OutputDebugString(PChar(' Can not open the file.'));
      lblFileName.Caption  := 'Can not open file '+ExtractFileName(strAviFile);
      Sleep(2000);
      Beep;
      Exit;
    End;

    // read header of the complete input file ...
    Seek(Input,4);
    BlockRead(Input,AVISize,4);
    BlockRead(Input,ChunkName[1],8);
    ChunkName[0]:=#8;
    If ChunkName <>'AVI LIST' Then
    Begin
      OutputDebugString(PChar(' This is not an AVI file.'));
      CloseFile(Input);
      lblFileName.Caption  := 'keine AVI-Datei '+ExtractFileName(strAviFile);
      Sleep(2000);
      Beep;
      Exit;
    End;
    
    Chunkname[0]:=#4;
    Codec[0]:=#4;
    Seek(Input,112);
    BlockRead(Input,Codec[1],4);
    Codec:=UpperCase(Codec);
    Seek(Input,128);
    BlockRead(Input,Scale,4);
    BlockRead(Input,Rate,4);
    Position:=16;
    Size:=0;
    Repeat
      Position:=Position+Size;
      Seek(Input,Position);
      BlockRead(Input,Size,4);
      BlockRead(Input,Chunkname[1],4);
      Inc(Position,8);
    Until Chunkname='movi';
    StreamStart:=Position-4;
    StreamSize:=Size;
    IndexStart:=CheckOtherIndex(Input);
    If IndexStart=0 Then IndexStart:=FileSize(Input);
    Chunkname:='idx1';
    Position:=4;
    i:=0;
    Frame:=0;
    Difference:=0;
    IndexDifference:=0;
    Interleaved:=False;
    Seek(Input,0);
    strFileSize := IntToStr(FileSize(Input) div 1024);
    strFileName := ExtractFileName(strAviFile);

    Repeat // read rest of the complete input file ...

    	ProgressBar.Position := Position Div ((FileSize(Input)-StreamStart) Div 100);
      lblFileName.Caption  := 'geprüft '+IntToStr(Position div 1024)+' / '+strFileSize+' KB'+#13#10+'von AVI-Datei "'+strFileName+'"';
      DoEvents;

      If StreamStart+Position>IndexStart Then
        Seek(Input,IndexStart)
      Else
        Seek(Input,StreamStart+Position);

BStartRead:
      If Not Eof(Input) Then
      Begin
        BlockRead(Input,Chunkname[1],4,Temp);
        If ChunkName='LIST' Then
        Begin
          Seek(Input,FilePos(Input)+8);
          Inc(Position,12);
          Goto BStartRead;
        End;
        If ChunkName='JUNK' Then
        Begin
          BlockRead(Input,Size,4);
          Position:=Position+Size+8;
          Inc(Difference,(Size+8));
          If StreamStart+Position>IndexStart Then
            Seek(Input,IndexStart)
          Else
            Seek(Input,StreamStart+Position);
          Goto BStartRead;
        End;
        Text2:=Copy(ChunkName,3,2);
        If (Copy(ChunkName,1,2)='ix') Or (Text2='ix') Then
        Begin
          Inc(Position,16);
          If StreamStart+Position>IndexStart Then
            Seek(Input,IndexStart)
          Else
            Seek(Input,StreamStart+Position);
          Interleaved:=True;
          Goto BStartRead;
        End;
        If Not Eof(Input) Then
        Begin
          If ((ChunkName[1] In Number) And (ChunkName[2] In Number)) And
             ((Text2='dc') Or (Text2='db') Or (Text2='wb')) Then
          Begin
            If (Text2='dc') Or (Text2='db') Then
            Begin
              If Frame=0 Then
              Begin
                BlockRead(Input,Size,4);
                BlockRead(Input,KeyType,4);
                If KeyType=65536 Then
                  KeyType:=1
                Else
                  If KeyType=$b0010000 Then
                    KeyType:=2
                  Else
                    KeyType:=3;
                Seek(Input,FilePos(Input)-8);
              End;
              Inc(Frame);
            End;
            If Interleaved Then
            Begin
              Seek(Input,FilePos(Input)-16);
              Dec(Position,16);
              Interleaved:=False;
            End;
            BlockRead(Input,Size,4,Temp);
            If (Size<0) And (Temp=4) Then
            Begin
              Inc(Position,4);
              If StreamStart+Position>IndexStart Then
                Seek(Input,IndexStart)
              Else
                Seek(Input,StreamStart+Position);
              BlockRead(Input,Chunkname[1],4,Temp);
              If ChunkName='LIST' Then
              Begin
                Seek(Input,FilePos(Input)+8);
                Inc(Position,12);
                Goto BStartRead;
              End;
              If ChunkName='JUNK' Then
              Begin
                BlockRead(Input,Size,4);
                Position:=Position+Size+8;
                If StreamStart+Position>IndexStart Then
                  Seek(Input,IndexStart)
                Else
                  Seek(Input,StreamStart+Position);
                Goto BStartRead;
              End;
              If StreamStart+Position>IndexStart Then
                Seek(Input,IndexStart)
              Else
                Seek(Input,StreamStart+Position);
              Goto BError;
            End;
            If Not Eof(Input) Then
            Begin
              If Size>0 Then
                BlockRead(Input,FrameType,4)
              Else
                FrameType:=64;
              j:=(((Position+Size) Div 2)+((Position+Size) Mod 2))*2+8;
              If StreamStart+j-1>IndexStart Then
                Seek(Input,IndexStart)
              Else
                Seek(Input,StreamStart+j-1);
              If Not Eof(Input) Then
              Begin

                Text2:=Copy(ChunkName,3,2);

                j:=Position;
                Position:=(((Position+Size) Div 2)+((Position+Size) Mod 2))*2+8;
                If StreamStart+j>IndexStart Then
                  Seek(Input,IndexStart)
                Else
                  Seek(Input,StreamStart+j);
                Inc(i);
              End;
            End;
          End Else
          Begin

BError:

            If Chunkname<>'idx1' Then
            Begin
              Inc(Errors);
              Str(Frame,Text);
              Time:=(Frame*Scale) Div Rate;
              Str(Time Div 3600:2,Hour);
              Str(Time Div 60:2,Minute);
              Str(Time Mod 60:2,Second);
              ZeroAlign(Hour);
              ZeroAlign(Minute);
              ZeroAlign(Second);
              Text:=' Corrupted data detected at frame '+Text+' ('+Hour+':'+Minute+':'+Second+')';
              OutputDebugString(PChar(Text));
              Str(StreamStart+Position,Text);
              Text:=' Error offset: '+Text+' ($'+IntToHex(StreamStart+Position,8)+')';
              OutputDebugString(PChar(Text));
              IndexDifference := (FilePos(Output) - LastIndexPosition) Div 16;
              Dec(i,IndexDifference+1);
              j:=Position;
              Repeat
                If StreamStart+Position>IndexStart Then
                  Seek(Input,IndexStart)
                Else
                  Seek(Input,StreamStart+Position);
                If Not Eof(Input) Then
                Begin
                  BlockRead(Input,Buffer[1],32768,Temp);
                  k:=1;
                  Repeat
                    If ((Chr(Buffer[k])='d') Or (Chr(Buffer[k])='w')) Then
                    Begin
                      If ((Chr(Buffer[k+1])='c') Or (Chr(Buffer[k+1])='b')) Then
                      Begin
                        If StreamStart+Position+k-3>IndexStart Then
                          Seek(Input,IndexStart)
                        Else
                          Seek(Input,StreamStart+Position+k-3);
                        If Not Eof(Input) Then BlockRead(Input,ChunkName[1],4);
                        If Not Eof(Input) Then BlockRead(Input,Size,4);
                        If Not Eof(Input) Then BlockRead(Input,FrameType,4);
                      End;
                    End;
                    Inc(k);
                    Text2:=Copy(ChunkName,3,2);
                  Until (((Text2='dc') Or (Text2='db')) And ((ChunkName[1] In Number) And
                        (ChunkName[2] In Number)) And (((KeyType=1) And (FrameType=65536))
                        Or ((KeyType=2) And (FrameType=$b0010000))
                        Or ((KeyType=3) And (FrameType And 64=0))))
                        Or (Chunkname='idx1') Or (k>Temp);

                  Inc(Position,k-3);
                End;

                DoEvents;

                Text2:=Copy(ChunkName,3,2);
              Until (((Text2='dc') Or (Text2='db') Or (Text2='wb')) And
                    ((ChunkName[1] In Number) And (ChunkName[2] In Number))
                    And (((KeyType=1) And (FrameType=65536))
                    Or ((KeyType=2) And (FrameType=$b0010000))
                    Or ((KeyType=3) And (FrameType And 64=0))))
                    Or (Chunkname='idx1') Or Eof(Input);

              If Not Eof(Input) Then
              begin
                Dec(Position)
              end Else
              Begin
                Inc(i,IndexDifference-2);
              End;
            End Else
            Begin
              Seek(Input,FilePos(Input)+6);
              ChunkName[0]:=#2;
              BlockRead(Input,ChunkName[1],2);
              Seek(Input,FilePos(Input)-8);
              If (ChunkName='dc') Or (ChunkName='wb') Or (ChunkName='db') Then
              Begin
                ChunkName[0]:=#4;
                ChunkName:='idx1';
              End Else
              Begin
                ChunkName[0]:=#4;
                ChunkName:='0000';
                Goto BError;
              End;
            End;
          End;
        End;
      End;

      DoEvents;

    Until (Eof(Input)) Or (ChunkName='idx1'); // read rest of the complete input file ...
    CloseFile(Input);

    if Errors = 0 then
    begin
      Result := True;
    end;
    OutputDebugString(PChar(' Number of errors: '+IntToStr(Errors)+' in "'+ExtractFileName(sAviFile)+'"'));

  except
    on E: Exception do OutputDebugString(PChar(E.Message));
  end;
end;

end.
