//////////////////////////////////////
//
// $Log: DelTools.pas,v $
// Revision 1.1  2004/07/02 13:32:40  thotto
// initial
//
//
unit DelTools;
{==============================================================================}
                                   interface
{==============================================================================}
uses
      Graphics
     ,classes
     ,controls
     ,StdCtrls
     ,ShellAPI
     ,ShellObj
     ,Windows
     ,Messages
     ,SysUtils
     ,Forms
     ,Menus
     ,ExtCtrls
     ,ComCtrls
     ,MyRegApi
     ,Variants
     ;

type
  x12               = string[12];
  x30               = string[30];
  x80               = string[80];
  x128              = string[128];
  __int64           = Array[0..1] of DWORD;

{------------------------------------------------------------------------------}
Procedure GetLastErrorString(var Text: String);

{------------------------------------------------------------------------------}
procedure SizeForTaskBar(MyForm: TForm);
{------------------------------------------------------------------------------}
function  EscapePressed(key:word):boolean;
(* return TRUE if "key" is ESCAPE *)
{------------------------------------------------------------------------------}
function  ReturnPressed(key:word):boolean;
(* return TRUE if "key" is RETURN *)
{------------------------------------------------------------------------------}
procedure SetAllCursorsOnForm(f:tForm;crXXX:TCursor);
(* set all cursors on a form to a new crXXX *)
{------------------------------------------------------------------------------}
procedure SetAllClickOnForm(f:tForm;c:tNotifyEvent);
(* set "OnClick" properties of special classes to "c" *)
{------------------------------------------------------------------------------}
function  CaptionHeight:integer;
(* return caption height of window *)
{------------------------------------------------------------------------------}
procedure CreateListBoxHorzScrollbar(l:tListBox);
(* create an horizontal scroll bar for listbox "l" *)
{------------------------------------------------------------------------------}
procedure DoEvents;
(* keep Windows alive *)
{------------------------------------------------------------------------------}
procedure Delay(ms:Cardinal);
(* delay "ms" milliseconds *)
{------------------------------------------------------------------------------}
function  ListBoxSelected(var l:tListBox):integer;
(* return index of item that is just selected in Listbox "l";
   return -1 if nothing selected
 *)
{------------------------------------------------------------------------------}
function  ListBoxSelectedItem(var l:tListBox):string;
(* return item that is just selected in Listbox "l";
   return '' if no item is selected
*)
{------------------------------------------------------------------------------}
function  ShellExecute(handle:integer;Exe,Par,Dir:x80):integer;
(* execute DOS or Windows program; shell around the API call *)
{------------------------------------------------------------------------------}
function  MemoSetCursor(M:TMemo;lin,col,len:word):boolean;
(* highlight byte "col" in line "lin" of a memo control in length "len" *)
{------------------------------------------------------------------------------}
function MemoGoToText(M:TMemo;Txt: String):boolean;
(* Goto "Txt" in a Memo and select this Text *)
{------------------------------------------------------------------------------}
function  MemoGetCursor(M:TMemo;var lin,col,len:word):boolean;
(* get highlighted bytes of a memo control into "lin", "col", "len" *)
{------------------------------------------------------------------------------}
procedure ReplaceinMemo(M:TMemo;s:x128);
(* replace current selection by "s"
   or - if no selection - insert "s" at cursor position
   in a memo control
 *)
{------------------------------------------------------------------------------}
function  FillMemoFromFile(M:TMemo;const FileName:string):boolean;
(* read a text file into a memo *)
{------------------------------------------------------------------------------}
function FillRichEditFromFile(M:TRichEdit;const FileName:string):boolean;

{------------------------------------------------------------------------------}
function RichEditSaveText(M:TRichEdit;const FileName:string):boolean;

{------------------------------------------------------------------------------}
procedure CenterWindow(f:tForm);
(* center a window *)
{------------------------------------------------------------------------------}
procedure MaximizeForm(f:tForm);
(* maximize a window; is sometimes necessary;
   if you set for example the WindowState property for a window
   with BorderStyle=bsDialog in the object inspector
   -> nothing happens when the window is shown
*)
{------------------------------------------------------------------------------}
Function  RemoveNull( Tmp: String ): String;
{------------------------------------------------------------------------------}
function  ReplaceChar( InStr: String; ToReplace: Char; ReplaceWith: String ): String;
{------------------------------------------------------------------------------}
function  ReplaceSubString( InStr: String; ToReplace, ReplaceWith: String ): String;
{------------------------------------------------------------------------------}
procedure _Trim(var Str: String);
{------------------------------------------------------------------------------}
procedure STrim(var Str: ShortString);
{------------------------------------------------------------------------------}
Function  ReverseFind(SubString: Char; SearchString: String): Integer;
{------------------------------------------------------------------------------}

{------------------------------------------------------------------------------}
Function  SizeOfFile(FileName: String): DWORD;
{------------------------------------------------------------------------------}
Function  DriveExist(Drive: Char): Boolean;
{------------------------------------------------------------------------------}
Function  DirExist(Directory: String): Boolean;
{------------------------------------------------------------------------------}
Function  DirLevel(Directory: String): Integer;
{------------------------------------------------------------------------------}
function  MakeFile(const src: String): Boolean;
{------------------------------------------------------------------------------}

function  CopyFile(const src, dest: String): Integer;
{------------------------------------------------------------------------------}
function  MoveFile(const src, dest: String): Integer;
{------------------------------------------------------------------------------}

function  SHCopyFile(       const src, dest: String; hwnd : HWND = 0): Boolean;
{------------------------------------------------------------------------------}
function  SHMoveFile(       const src, dest: String; hwnd : HWND = 0): Boolean;
{------------------------------------------------------------------------------}
function  SHDeleteFile(     const src      : String; hwnd : HWND = 0): Boolean;
{------------------------------------------------------------------------------}
function  SHRenameFile(     const src, dest: String; hwnd : HWND = 0): Boolean;
{------------------------------------------------------------------------------}
function  SHDeleteDirectory(const DirName: string;   hwnd : HWND = 0): Boolean;


{------------------------------------------------------------------------------}
Function  IsLegaleFilename(const Src: String): Boolean;
{------------------------------------------------------------------------------}
Function  CheckLegaleFilename(var Name: String): Boolean;
{------------------------------------------------------------------------------}
Function  GetDriveString(Lw: Char): String;
{------------------------------------------------------------------------------}
function  NetworkVolume(DriveChar: Char): string;
{------------------------------------------------------------------------------}
function  VolumeID(DriveChar: Char): string;
{------------------------------------------------------------------------------}
function  GetCDromID( Lw: Char ): String;
{------------------------------------------------------------------------------}
function  CD_LockDrive(NeedLock: Boolean): Boolean;
{------------------------------------------------------------------------------}
function  PortIn(IOAddr : WORD) : BYTE;
{------------------------------------------------------------------------------}
procedure PortOut(IOAddr : WORD; Data : BYTE);
{------------------------------------------------------------------------------}
FUNCTION  GetFirstCdDrive(var CD_Drive: Char): Boolean;
{------------------------------------------------------------------------------}
Function  SameName(N1, N2 : String) : Boolean;
{ Function to compare filespecs. }

{------------------------------------------------------------------------------}
Function  GetIconIndex(ExeFileName: String; var IconIndex: Integer): Boolean;
{------------------------------------------------------------------------------}
procedure GetExeIcon(var Ico: TIcon; ExeFileName: String; IconIndex: Integer);
{------------------------------------------------------------------------------}
Function  GetIconFromRes(IcoName: String; var Ico: TIcon): Boolean;

{------------------------------------------------------------------------------}
Function  IsBitSet ( const Val: Cardinal; const TheBit: BYTE ): Boolean;
Function  BitSetOn ( const Val: Cardinal; const TheBit: BYTE ): Cardinal;
Function  BitSetOff( const Val: Cardinal; const TheBit: BYTE ): Cardinal;
Function  BitToggle( const Val: Cardinal; const TheBit: BYTE ): Cardinal;

{------------------------------------------------------------------------------}
function  IsArc(FName: String):Integer; // ZIP=1, ARJ=2, RAR=3, None=0
{------------------------------------------------------------------------------}
function  _GetShortPathName(longPath: String):String;
{------------------------------------------------------------------------------}
function  StrToHex(str: String; len: byte):String;
{------------------------------------------------------------------------------}
function  ByteToHex(x: byte):String;
{------------------------------------------------------------------------------}
function  WinExecAndWait(exeName, params : string):Boolean;
{------------------------------------------------------------------------------}
FUNCTION  Is_Win95 : Boolean;
{------------------------------------------------------------------------------}
Procedure RepaintDesktop;
{------------------------------------------------------------------------------}

{------------------------------------------------------------------------------}
Function TimeAdd(SourceTime, TimeToAdd: Variant): Variant;
{------------------------------------------------------------------------------}


const
  NotSelected       = -1;
  yes               = true;
  no                = false;

  dtFloppy          = DRIVE_REMOVABLE;
  dtFixed           = DRIVE_FIXED;
  dtNetwork         = DRIVE_REMOTE;
  dtCDROM           = DRIVE_CDROM;
  dtRAM             = DRIVE_RAMDISK;
   
var
  m_hApp: DWORD;
  
{==============================================================================}
                                 implementation
{==============================================================================}
{------------------------------------------------------------------------------}
function zf(l:Cardinal;dp:word):x30;
var i : byte;
begin
 str(l:dp,Result);
 for i:=1 to length(Result) do if Result[i]=#32 then Result[i]:='0';
end;
{------------------------------------------------------------------------------}
function FillRichEditFromFile(M:TRichEdit;const FileName:string):boolean;
(* read a text file into a RichEdit *)
begin
  M.Lines.LoadFromFile(FileName);
  M.SetFocus;
  M.Modified := False;
  Result:=yes;
end;
{------------------------------------------------------------------------------}


function RichEditSaveText(M:TRichEdit;const FileName:string):boolean;
begin
  M.Lines.SaveToFile(FileName);
  M.SetFocus;
  M.Modified := False;
  Result:=yes;
end;
{------------------------------------------------------------------------------}

function FillMemoFromFile(M:TMemo;const FileName:string):boolean;
(* read a text file into a memo *)
var   f                 : text;
      line              : string;
begin
 Result:=no;
 AssignFile(f,FileName);
 Reset(f);
 if ioresult<>0 then exit;
 with M,Lines do
 begin
  Clear;
  while not eof(f) do
  begin
   ReadLN(f,line);
   add(line);
  end;
 end;
 close(f);
 Result:=yes;
end;
{------------------------------------------------------------------------------}
function EscapePressed(key:word):boolean;
begin
 Result:=(key=vk_Escape);
end;
{------------------------------------------------------------------------------}
function ReturnPressed(key:word):boolean;
begin
 Result:=(key=vk_Return);
end;
{------------------------------------------------------------------------------}
procedure SetAllClickOnForm(f:tForm;c:tNotifyEvent);
(* set all onclick properties to "c" *)
var i : word;
begin
 with f do
 begin
  for i:=0 to ComponentCount-1 do
  begin
   if Components[i] is tPanel then tPanel(Components[i]).OnClick:=c;
   if Components[i] is tLabel then tLabel(Components[i]).OnClick:=c;
   if Components[i] is tImage then tImage(Components[i]).OnClick:=c;
  end;
  f.OnClick:=c;
 end;
end;
{------------------------------------------------------------------------------}
procedure SetAllCursorsOnForm;
var i : word;
begin
 with f do
 begin
  for i:=0 to ComponentCount-1 do
   if Components[i] is tControl then
    tControl(Components[i]).Cursor:=crXXX;
  f.Cursor:=crXXX;
 end;
end;
{------------------------------------------------------------------------------}
function CaptionHeight:integer;
begin
 CaptionHeight := GetSystemMetrics(SM_CYCAPTION);
end;
{------------------------------------------------------------------------------}
procedure CreateListBoxHorzScrollbar(l:tListBox);
begin
 SendMessage(l.handle,lb_SetHorizontalExtent,1000,Cardinal(0));
end;
{------------------------------------------------------------------------------}
procedure ChangeWindowSizeAndPos(f:tForm;maximize:boolean);
var   l,t,w,h           : integer;
begin
 with f do
 if not maximize then
 begin
  l:=(Screen.Width-Width) div 2;
  t:=(Screen.Height-Height) div 2;
  w:=Width;
  h:=Height;
 end else
 begin
  l:=0;
  t:=0;
  w:=Screen.Width;
  h:=Screen.Height;
 end;
 f.SetBounds(l,t,w,h);
end;
{------------------------------------------------------------------------------}
procedure CenterWindow;
begin
 ChangeWindowSizeAndPos(f,no);
end;
{------------------------------------------------------------------------------}
procedure MaximizeForm;
begin
 ChangeWindowSizeAndPos(f,yes);
end;
{------------------------------------------------------------------------------}
procedure ReplaceinMemo;
begin
 s:=s+#0;
 with M do perform(EM_REPLACESEL,0,Cardinal(@s[1]));
end;
{------------------------------------------------------------------------------}
procedure DoEvents;
begin
  Application.ProcessMessages;
end;
{------------------------------------------------------------------------------}
procedure Delay(ms: Cardinal);
var 
  tickcount: Cardinal;
begin
 TickCount := GetTickCount;
 while Cardinal(GetTickCount) - tickcount < ms do DoEvents;
end;
{------------------------------------------------------------------------------}
function MemoGetCursor(M:TMemo;var lin,col,len:word):boolean;
var   i,l,sta       : word;
begin
 MemoGetCursor:= False;
 with M,Lines do
 begin
  sta:=SelStart;
  len:=SelLength;
  (* no selected area *)
  if (len=0) then exit;
  lin:=1;
  for i:=0 to Count do
  begin
   l:=length(Lines[i])+2;
   if l<=sta then dec(sta,l) else break;
   inc(lin);
  end;
  col:=sta+1;
 end;
 MemoGetCursor:= True;
end;
{------------------------------------------------------------------------------}
function MemoSetCursor(M:TMemo;lin,col,len:word):boolean;
(* highlight text starting in line "lin" in column "col" in length "len";
   we scroll to the line in question and set the properties
   "SelStart" and "SelLength"
 *)
var   i,l           : word;
begin
 Result:= False;
 with M,Lines do
 begin
  (* line outside memo text ? *)
  if (lin=0) or (lin>Count) then exit;
  (* init length counter *)
  l:=0;
  if lin>1 then
  (* count length of lines before "lin";
     the length of each item must be increased by 2 because of CR/LF
   *)
  begin
   for i:=0 to lin-2 do inc(l,length(Lines[i])+2);
   Perform(EM_LINESCROLL,0,MakeLong(lin,0));
   DoEvents;
  end;
  SelStart:=l+col-1;
  SelLength:=len;
  Result:= True;
 end;
end;

{------------------------------------------------------------------------------}

function MemoGoToText(M:TMemo;Txt: String):boolean;
var
  L,
  C : Cardinal;
begin
  Result:= False;
  Txt:= UpperCase(Txt);
  with M do
  begin
    for L:= 1 to Lines.Count-1 do
    begin
      C:= Pos(Txt, UpperCase(Lines[L]));
      if C <> 0 then
      begin
        Result:= MemoSetCursor(M,L,C, Length(Txt));
        SelLength:= 0;
        exit;
      end;
    end;
  end;
end;
{------------------------------------------------------------------------------}
function ShellExecute(handle:integer;Exe,Par,Dir:x80):integer;
begin
 Exe:=Exe+#0;
 Par:=Par+#0;
 Dir:=Dir+#0;
 ShellExecute:= ShellExecute(handle,Exe,Par,Dir);
end;
{------------------------------------------------------------------------------}
function ListBoxSelectedItem(var l:tListBox):string;
var
  Value : integer;
begin
  Result:='';
  Value:=ListBoxSelected(l);
  if Value=NotSelected then exit;
  Result:=l.items.strings[Value];
end;
{------------------------------------------------------------------------------}
function ListBoxSelected(var l:tListBox):integer;
begin
 (* return index number of selected item; it's -1 if no selection *)
 Result:=l.ItemIndex;
end;
{------------------------------------------------------------------------------}
function ReplaceSubString( InStr: String; ToReplace, ReplaceWith: String ): String;
var
  Tmp: String;
begin
  Tmp:= '';
  if Pos(ToReplace,InStr)<>0 then
  begin
    Tmp:= InStr;
    while Pos(ToReplace,Tmp)<>0 do
    begin
      Tmp:= Copy(Tmp,1,Pos(ToReplace,Tmp)-1) + ReplaceWith + Copy(Tmp,Pos(ToReplace,Tmp)+Length(ToReplace),MaxInt);
    end;
    Result:= Tmp;
  end else
  begin
    Result:= InStr;
  end;
end;
{------------------------------------------------------------------------------}
function ReplaceChar( InStr: String; ToReplace: Char; ReplaceWith: String ): String;
var
  i  : Integer;
  Tmp: String;
begin
  Tmp:= '';
  if Pos(ToReplace,InStr)<>0 then
  begin
    for i:= 1 to Length(InStr) do
    begin
      if InStr[i]=ToReplace then
      begin
        Tmp:= Tmp + ReplaceWith;
      end else
      begin
        Tmp:= Tmp + InStr[i];
      end;
    end;
    Result:= Tmp;
  end else
  begin
    Result:= InStr;
  end;
end;
{------------------------------------------------------------------------------}
procedure _Trim(var Str: String);
var
  i: Integer;
begin
  if Str='' then exit;
  for i:= Length(Str) downto 1 do
  begin
    if Str[i]<>' ' then break;
  end;
  Str:= copy(Str, 1, i);
end;

{------------------------------------------------------------------------------}

procedure STrim(var Str: ShortString);
var
  i: Integer;
begin
  if Str='' then exit;
  for i:= Length(Str) downto 1 do
  begin
    if Str[i]<>' ' then break;
  end;
  Str:= copy(Str, 1, i);
end;

{------------------------------------------------------------------------------}

function VolumeID(DriveChar: Char): string;
var
  OldErrorMode: Integer;
  NotUsed, VolFlags: Cardinal;
  Buf: array [0..MAX_PATH] of Char;
begin
  Result:= 'nicht verfügbar!';
  if NOT DriveExist(DriveChar) then exit;
  OldErrorMode := SetErrorMode(SEM_FAILCRITICALERRORS);
  try
    GetVolumeInformation(PChar(DriveChar + ':\'),
                         Buf,
                         sizeof(Buf),
                         nil,
                         NotUsed,
                         VolFlags,
                         nil,
                         0);
    SetString(Result, Buf, StrLen(Buf));
    if DriveChar < 'a' then
      Result := AnsiUpperCase(Result)
    else
      Result := AnsiLowerCase(Result);
{    Result := Format('[%s]',[Result]);  }
  finally
    SetErrorMode(OldErrorMode);
  end;
end;

{------------------------------------------------------------------------------}

function NetworkVolume(DriveChar: Char): string;
var
  Buf       : Array [0..MAX_PATH] of Char;
  DriveStr  : array [0..3] of Char;
  BufferSize: Integer;
begin
  Result:= 'nicht verfügbar!';
  if NOT DriveExist(DriveChar) then exit;
  BufferSize := sizeof(Buf);
  FillChar(Buf, BufferSize, #0);
  DriveStr[0] := DriveChar;
  DriveStr[1] := ':';
  DriveStr[2] := #0;
{ ToDo !!!
  if WNetGetConnection(DriveStr, Buf, BufferSize) = WN_SUCCESS then
  begin
    SetString(Tmp, Buf, BufferSize);
    SetLength(Tmp, Pos(#0,Tmp)-1);
    Result:= Tmp;
    if DriveChar < 'a' then
    begin
      Result := AnsiUpperCase(Result);
    end else
    begin
      Result := AnsiLowerCase(Result);
    end;
  end else
  begin
    Result := VolumeID(DriveChar);
  end;
}
  Result := Format('[%s]',[Result]);
end;

{-----------------------------------------------------------------------}

function GetCDromID(Lw: Char): String;
var
  OldErrorMode: Integer;
  NotUsed, VolFlags: Cardinal;
  Tmp: String;
  Buf: array [0..3] of BYTE;
begin
  Result:= 'nicht verfügbar!';
  if NOT DriveExist(Lw) then exit;
  OldErrorMode := SetErrorMode(SEM_FAILCRITICALERRORS);
  try
    GetVolumeInformation(PChar(Lw + ':\'),
                         nil,
                         0,
                         @Buf,
                         NotUsed,
                         VolFlags,
                         nil,
                         0);
    if Is_Win95 then Tmp:= Format('%02X%02X%02X%02X',[Buf[3],Buf[2],Buf[1],Buf[0]])
                else Tmp:= Format('%02X%02X%02X%02X',[Buf[0],Buf[1],Buf[2],Buf[3]]);
    Tmp:= ReplaceChar(Tmp, ' ', '0');
    Result:= Tmp;
  finally
    SetErrorMode(OldErrorMode);
  end;
end;

{-----------------------------------------------------------------------}

type
  TPreventMediaRemoval = Record
    PreventMediaRemoval: Boolean;
  end;

function CD_LockDrive(NeedLock: Boolean): Boolean;
const
  IOCTL_DISK_MEDIA_REMOVAL = $21D00001;
var
  Ok                 : Boolean;
  PreventMediaRemoval: TPreventMediaRemoval;
  // Specifies whether the media
  // is to be locked (if TRUE)
  // or not (if FALSE)
  hDevice            : THandle;
  InBufferSize       : DWORD;
  BytesReturned      : DWORD;
  Tmp                : String;
  Lw                 : Char;
begin
  Ok:= FALSE;
  PreventMediaRemoval.PreventMediaRemoval:= NeedLock;

  try
//    hDevice:= INVALID_HANDLE_VALUE;
    if NOT GetFirstCdDrive(Lw) then
    begin
      Result:= FALSE;
      exit;
    end;
    Tmp:= '\\.\'+Lw+':'#0;
    if Is_Win95 then
    begin
      hDevice:= CreateFile( @Tmp[1],                   // address of name of the file
                            0,                         // access (read-write) mode
                            0,                         // share mode
                            nil,                       // address of security descriptor
                            CREATE_NEW,                // how to create
                            FILE_FLAG_DELETE_ON_CLOSE, // file attributes
                            0 );                 // handle of file with attributes to copy

    end else
    begin
      hDevice:= CreateFile( @Tmp[1],
                            GENERIC_READ    OR GENERIC_WRITE,
                            FILE_SHARE_READ OR FILE_SHARE_WRITE,
                            nil,
                            OPEN_EXISTING,
                            FILE_FLAG_OVERLAPPED,
                            0 );

    end;
    
GetLastErrorString(Tmp);

    if( (hDevice<>INVALID_HANDLE_VALUE) AND (BytesReturned=ERROR_SUCCESS) )then
    begin
      InBufferSize:= SizeOf(TPreventMediaRemoval);
      Ok:= DeviceIoControl(hDevice,                  // handle to device of interest
                           IOCTL_DISK_MEDIA_REMOVAL, // control code of operation to perform
                           @PreventMediaRemoval,     // pointer to buffer to supply input data
                           InBufferSize,             // size of input buffer
                           nil,                      // pointer to buffer to receive output data
                           0,                        // size of output buffer
                           BytesReturned,            // pointer to variable to receive output byte count
                           nil );                    // pointer to overlapped structure for asynchronous operation

      CloseHandle(hDevice);

BytesReturned:= GetLastError;
GetLastErrorString(Tmp);

    end;
  except
  end;

  Result:= Ok;
end;

{------------------------------------------------------------------------------}

Function DriveExist(Drive: Char): Boolean;
var
  DirName: TSearchRec;
  Ok     : Integer;
begin
  Ok:= -1;
  try
    Ok:= SysUtils.FindFirst(Drive+':\*.*', faAnyFile, DirName);
  finally
    SysUtils.FindClose(DirName);
    if Ok=0 then Result:= True
            else Result:= False;
  end;
end;

{------------------------------------------------------------------------------}

Function DirExist(Directory: String): Boolean;
var
  DirName: TSearchRec;
  Ok     : Integer;
begin
  Result:= False;
  if Directory='' then exit;

  Ok:= -1;
  try
    if Directory[Length(Directory)] <> '\' then
      Directory:= Directory + '\';
    Ok:= SysUtils.FindFirst(Directory+'*.*', faDirectory, DirName);
  finally
    SysUtils.FindClose(DirName);
    if Ok=0 then Result:= True
            else Result:= False;
  end;
end;

{------------------------------------------------------------------------------}

Function  IsLegaleFilename(const Src: String): Boolean;
begin
  if ( (Pos('*',Src)<>0) OR (Pos('?',Src)<>0) OR (Pos('|',Src)<>0) OR (Pos('<',Src)<>0) OR (Pos('>',Src)<>0) OR (Pos('[',Src)<>0) OR (Pos(']',Src)<>0) OR (Pos('{',Src)<>0) OR (Pos('}',Src)<>0)) then
    Result:= FALSE
  else
    Result:= TRUE;
end;

{------------------------------------------------------------------------------}

Function CheckLegaleFilename(var Name: String): Boolean;
var
  i : Integer;
  Work,
  Tmp : String;
begin
  Result:= FALSE;
  Tmp:= Name;
  if Tmp='' then exit;
  Result:= TRUE;
  for i:= 1 to Length(Tmp) do
  begin
    if(i<>2)then
      if(Tmp[i]=':')then continue;
    if ( (Tmp[i]='*') OR (Tmp[i]='?') OR (Tmp[i]='|') OR (Tmp[i]='<') OR (Tmp[i]='>') OR (Tmp[i]='[') OR (Tmp[i]=']') OR (Tmp[i]='{') OR (Tmp[i]='}') OR (Tmp[i]='/')) then
    begin
      Result:= FALSE;
    end else
    begin
      Work:= Work + Tmp[i];
    end;
  end;
  Name:= Work;
end;

{------------------------------------------------------------------------------}

Function ReverseFind(SubString: Char; SearchString: String): Integer;
var
  i: Integer;
begin
  Result:= 0;
  if SearchString='' then
    exit;
  if SubString='' then
    exit;

  for i:= Length(SearchString) downto 1 do
  begin
    if SearchString[i]= SubString then
    begin
      Result:= i;
      exit;
    end;
  end;
end;

{------------------------------------------------------------------------------}

Function  GetDriveString(Lw: Char): String;
var
  DriveNum : Integer;
  DriveType: DWORD;
  DriveBits: set of 0..25;
begin
  Integer(DriveBits) := GetLogicalDrives;
  DriveNum := Ord(UpCase(Lw))-Ord('A');
  if not (DriveNum in DriveBits) then
  begin
    Result:= '';
  end else
  begin
    DriveType := GetDriveType(PChar(Lw + ':\'));
    case DriveType of
      DRIVE_REMOVABLE:   
                  begin
                    Result:= Format('%s: Diskette %s',[Lw, VolumeID(Lw)]);
                  end;
      DRIVE_CDROM    :
                  begin
                    Result:= Format('%s: CD-ROM %s',[Lw, AnsiUpperCase(VolumeID(Lw)) + ' ' + GetCDromID(Lw)]);
                  end;
      DRIVE_REMOTE   :
                  begin
                    Result:= Format('%s: Netzwerk %s',[Lw, NetworkVolume(Lw)]);
                  end;
    else
      Result:= Format('%s: Festplatte %s',[Lw, UpperCase(VolumeID(Lw))]);
    end;
  end;
end;

{------------------------------------------------------------------------------}

FUNCTION  GetFirstCdDrive(var CD_Drive: Char): Boolean;
Var
  ch       : Char;
  DriveType: DWORD;
begin
  for ch:='C' to 'Z' do
  begin
    DriveType := GetDriveType(PChar(ch + ':\'));
    if DriveType = DRIVE_CDROM then
    begin
      CD_Drive:= ch;
      Result:= TRUE;
      exit;
    end;
  end;
  CD_Drive:= 'Y';
  Result:= FALSE;
end;

{------------------------------------------------------------------------------}
function CopyFile(const src, dest: String): Integer;
{ returns 0 if good copy, or a negative error code }
Const
   SE_CreateError   = -1;  { error in open of outfile }
   SE_CopyError     = -2;  { read or write error during copy }
   SE_OpenReadError = -3;  { error in open of infile }
   SE_SetDateError  = -4;  { error setting date/time of outfile }
Var
   S,
   T: TFileStream;
Begin
   if NOT IsLegaleFilename(Src) then
   begin
     Result:= SE_OpenReadError;
     exit;
   end;
   if NOT IsLegaleFilename(Dest) then
   begin
     Result:= SE_CreateError;
     exit;
   end;

   Result := 0;
   try
     S := TFileStream.Create( src, fmOpenRead );
   except
     Result:=SE_OpenReadError;
     exit;
   end;

   try
     T := TFileStream.Create( dest, fmOpenWrite or fmCreate );
   except
     Result := SE_CreateError;
     S.Free;  { S was already made - free it }
     exit;
   end;

   try
     T.CopyFrom(S, S.Size ) ;
   except
     Result := SE_CopyError;
     S.Free;
     T.Free;
     exit;
   end;
   SHChangeNotify(SHCNE_UPDATEDIR, SHCNF_FLUSH, nil, nil);

   try
     FileSetDate(T.Handle, FileGetDate( S.Handle ));
   except
     Result := SE_SetDateError;
   end;

   S.Free;
   T.Free;
End;

{------------------------------------------------------------------------------}

function MoveFile(const src, dest: String): Integer;
{ returns 0 if good copy, or a negative error code }
var
  Ok: Integer;
begin
  Ok:= CopyFile(src, dest);
  if Ok = 0 then
  begin
    DeleteFile(src);
  end;
  Result:= Ok;
end;

{------------------------------------------------------------------------------}

function MakeFile(const src: String): Boolean;
Var
   T: TFileStream;
Begin
  Result := TRUE;

  if NOT IsLegaleFilename(Src) then
  begin
    Result:= FALSE;
    exit;
  end;

  try
    T := TFileStream.Create( Src, fmOpenWrite or fmCreate );
  except
    Result := FALSE;
    exit;
  end;
//   SHChangeNotify(SHCNE_UPDATEDIR, SHCNF_FLUSH, nil, nil);
  T.Free;
End;

{------------------------------------------------------------------------------}

Function IsBitSet ( const Val: Cardinal; const TheBit: BYTE ): Boolean;
begin
  Result:= Boolean((Val AND (1 shl TheBit)) <> 0);
end;

{------------------------------------------------------------------------------}

Function BitSetOn ( const Val: Cardinal; const TheBit: BYTE ): Cardinal;
begin
  Result:= Val OR (1 shl TheBit);
end;

{------------------------------------------------------------------------------}

Function BitSetOff( const Val: Cardinal; const TheBit: BYTE ): Cardinal;
begin
  Result:= Val AND ((1 shl TheBit) XOR $FFFFFFFF);
end;

{------------------------------------------------------------------------------}

Function BitToggle( const Val: Cardinal; const TheBit: BYTE ): Cardinal;
begin
  Result:= Val XOR (1 shl TheBit);
end;

{------------------------------------------------------------------------------}

Function  DirLevel( Directory: String): Integer;
var
  Tmp : String;
  i,L : Integer;
begin
  Result:= 0;

  if Directory=''         then exit;
  if Pos('\',Directory)=0 then exit;

  Tmp:= Directory;
  L  := 0;
  Tmp:= ReplaceChar(Tmp, '/', '\');
  for i:=1 to Length(Tmp) do
  begin
    if Tmp[i]='\' then inc(L);
  end;
  if (Length(Tmp)=3) AND (L=1) then L:=0;
  Result:= L;
end;

{------------------------------------------------------------------------------}

function WinExecAndWait(exeName, params : string):Boolean;
var
   startUpInfo  : TStartupInfo;
   processInfo  : TProcessInformation;
   TempPath,
   exeCmd       : string;
Begin
   exeCmd := exeName + ' ' + params;
   // Initialise the StartUpInfo record
   FillChar(startUpInfo, SizeOf(startUpInfo), Chr(0));
   StartUpInfo.cb := SizeOf( StartUpInfo );
   StartUpInfo.dwFlags     := STARTF_USESHOWWINdoW;
   StartUpInfo.wShowWindow := SW_HIDE;
   TempPath:= ExtractFilePath(ExpandFileName(Application.ExeName));
   // Spawn the process out.
   if CreateProcess( nil,
                     PChar(exeCmd),
                     nil,
                     nil,
                     false,
                     CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS,
                     nil,
                     PChar(TempPath),
                     startUpInfo,
                     processInfo)
   then result := true
   else result := false;

   // Wait for the old process to finish.
   If WaitForSingleObject(processInfo.hProcess,3000) = WAIT_TIMEOUT then
   begin
     Beep;
     TerminateProcess(processInfo.hProcess,0);
   end;
end;

{------------------------------------------------------------------------------}

function ByteToHex(x: byte):String;
const
  Digits : array [0..15] of char = '0123456789ABCDEF';
begin
  ByteToHex:=Concat(Digits[x shr 4],Digits[x and 15]);
end;

{------------------------------------------------------------------------------}

function StrToHex(str: String; len: byte):String;
var
  NewStr : String;
  Index  : Word;
begin
  NewStr:= '';
  For Index:=1 to len do
    NewStr:=NewStr+ByteToHex(Ord(str[Index]));
  StrToHex := NewStr;
end;

{------------------------------------------------------------------------------}

function IsArc(FName: String):Integer; // ZIP=1, ARJ=2, RAR=3, LHARC=4, None=0
var
  ArcFile   : file;
  ArcID     : Integer;
  IDarr     : Array[1..64] of Char;
  IDStr     : String;
  BytesRead : Integer;
  IDStrh    : String;

  function CheckID(Offset: byte; IDhex: String): Boolean;
  begin
    CheckID := Copy (IDStrh, Offset, Length (IDhex)) = IDhex;
  end;

begin
  ArcID := 0;  {If no archive}
  FName:= copy(FName,1,Pos('.',FName)+3);

  {look for EXTENSION}
  if Lowercase(ExtractFileExt(FName))='.zip' then ArcID:=1 else
  if Lowercase(ExtractFileExt(FName))='.arj' then ArcID:=2 else
  if Lowercase(ExtractFileExt(FName))='.rar' then ArcID:=3 else
  if Lowercase(ExtractFileExt(FName))='.lzh' then ArcID:=4 else
//  if Lowercase(ExtractFileExt(FName))='.'+FormOptions.Edit1.Text then ArcID:=4 else
  begin
    if NOT FileExists(FName) then
    begin
      Result:= 0;
      exit;
    end;

    {$I-}
    AssignFile(ArcFile, FName);
    System.FileMode:=fmOpenRead;
    Reset(ArcFile,1);
    {$I+}
    if IOResult=0 then
    begin
      try
        BlockRead(ArcFile, IDarr, SizeOf (IDarr), BytesRead);
      finally
        CloseFile(ArcFile);
      end;
      SetLength(IDStr,64);
      Move (IDarr[1], IDStr[1], BytesRead);
      IDStrh:=StrToHex(IDStr,64);

{RAR SFX}

      if CheckID (1, '4D5A95001300000002003C1CFFFF7D03800000000E0031021C0000005253465'+
                     '8FFFFBAF1022E8916E800B430CD218B2E02FFFF008B1E2C008EDAA316008C0614')
      then ArcID := 3
      else

{ARJ SFX}

      if CheckID (1, '4D5A0A001E0000000200640FFFFF3D05800000000E0088031C000000524A535'+
                     '8FFFFBA40042E89163A02B430CD218B2E02FFFF008B1E2C008EDAA390008C068E')
      then ArcID := 2
      else

      if CheckID (1, '4D5AD1000B0000000200120EFFFFCB01800000000E0035011C000000524A535'+
                     '8FFFFBA62012E89163A02B430CD218B2E02FFFF008B1E2C008EDAA390008C068E')
      then ArcID := 2
      else
      
      if CheckID (1, '4D5AEA00240000000200F50FFFFF9106800000000E0056041C000000524A535'+
                     '8FFFFBA5E052E89163A02B430CD218B2E02FFFF008B1E2C008EDAA390008C068E')
      then ArcID := 2 
      else

{ZIP SFX}

      if CheckID (1, '4D5AEF01190000000600D10CFFFF2003000400000001F0FF1E0000000001436'+
                     'F7079726967687420313938392D3139393020504B5741524520496E632E20416C')
      then ArcID := 1
      else
      if CheckID (1, '4D5A76010600000002000206FFFFF0FF706700000001F0FF1E0000000000000'+
                     '0B87067A34E0CBF560CB9705F2BCF32C0F3AAB430CD21A3520CA12C00A3500CE8')
      then ArcID := 1 
      else
      if CheckID (1, '4D5A99011F0001000600890CFFFF0000206100000001F0FF520000001411504'+
                     'B4C49544520436F70722E20313939302D393220504B5741524520496E632E2041')
      then ArcID := 1 
      else
      if CheckID (1, '4D5ABA01060000000200890B0010F0FF1CC000000001F0FF1E0000000000000'+
                     '0B91CBABF9A0C2BCF32C0F3AAB430CD21A302BA892614BAE83300B8A80AE8D401')
      then ArcID := 1
      else
      if CheckID (1, '4D5AF5011E0001000600890CFFFF0000B05F00000001F0FF520000001411504'+
                     'B4C49544520436F70722E20313939302D393220504B5741524520496E632E2041')
      then ArcID := 1 
      else

      if not CheckID (1, '4D5A') then  { If file is .EXE, go no further. }
      begin

{ZIP}
        if CheckID (1, '504B0304')  {PK..}
           then ArcID := 1 else

{RAR}
        if CheckID (1, '526172')  {Rar}
           then ArcID := 3 else

{ARJ}
        if CheckID (1, '60EA')  {`ê}
           then ArcID := 2;
       end;
    end;
  end;
  IsArc := ArcID;
end;

{------------------------------------------------------------------------------}

function _GetShortPathName(longPath: String):String;
var p  : Array[0..255] of Char;
begin
  p:='';
  GetShortPathName(PChar(ExtractFilePath(longPath)),p,DWord(SizeOf(p)));
  _GetShortPathName:=StrPas(p)+ExtractFileName(longPath);
end;

{------------------------------------------------------------------------------}

function PortIn(IOAddr : WORD) : BYTE;
begin
  if Is_Win95 then
  begin
    asm
        mov dx,IOAddr
        in  al,dx
        mov result,al
    end;
  end;
end;

{------------------------------------------------------------------------------}

procedure PortOut(IOAddr : WORD; Data : BYTE);
begin
  if Is_Win95 then
  begin
    asm
        mov  dx,IOAddr
        mov  al,Data
        out  dx,al
    end;
  end;
end;

{------------------------------------------------------------------------------}

FUNCTION  Is_Win95 : Boolean;
var
  Plattform: DWORD;
begin
  Plattform:= Win32Platform;
  if NOT(Plattform = VER_PLATFORM_WIN32_WINDOWS)then
  begin
    // Win_NT or Win32s
    Result:= FALSE;
  end else
  begin
    Result:= TRUE;
  end;
end;

{------------------------------------------------------------------------------}

Function RemoveNull( Tmp: String ): String;
begin
  Result:= Tmp;
  if Tmp='' then exit;
  if Pos(#0, Tmp)>1  then
    Result:= copy(Tmp,1,Pos(#0,Tmp));
end;

{------------------------------------------------------------------------------}

Function TimeAdd(SourceTime, TimeToAdd: Variant): Variant;
var
  SHour, SMin, SSec, SMSec: WORD; //Source
  AHour, AMin, ASec, AMSec: WORD; //ToAdd
  RHour, RMin, RSec, RMSec: WORD; //Result
begin
  Result:= Null;
  if( (SourceTime <> Null) AND (TimeToAdd <> Null) )then
  begin
    try
      DecodeTime(SourceTime, SHour, SMin, SSec, SMSec);
      DecodeTime(TimeToAdd,  AHour, AMin, ASec, AMSec);
      RMSec:= SMSec + AMSec;
      while RMSec > 999 do
      begin
        dec(RMSec,1000);
        inc(ASec);
      end;
      RSec := SSec  + ASec;
      while RSec > 59 do
      begin
        dec(RSec,60);
        inc(AMin);
      end;
      RMin := SMin  + AMin;
      while RMin > 59 do
      begin
        dec(RMin,60);
        inc(AHour);
      end;
      RHour:= SHour + AHour;
      while RHour > 23 do
      begin
        dec(RHour,24);
      end;

      Result:= EncodeTime(RHour, RMin, RSec, RMSec);
    except
    end;
  end;
end;

{------------------------------------------------------------------------------}

Procedure GetLastErrorString(var Text: String);
var
  dwErr: DWORD;
  Tmp  : Array[0..256] of Char;
begin
  try
    dwErr:= LoWord(GetLastError);
    FillChar( Tmp, SizeOf(Tmp), 0 );
    FormatMessage( FORMAT_MESSAGE_FROM_SYSTEM, // source and processing options
                   nil,                        // address of  message source
                   dwErr,                      // requested message identifier
                   0,                          // language identifier for requested message
                   @Tmp[0],                    // address of message buffer
                   SizeOf(Tmp)-1,              // maximum size of message buffer
                   nil                         // address of array of message inserts
                  );
    Text:= Tmp;
  except
  end;
end;

{------------------------------------------------------------------------------}

Function GetIconIndex(ExeFileName: String; var IconIndex: Integer): Boolean;
var
  sfi: TShFileInfo;
  MustDel: Boolean;
begin
  IconIndex:= 0;
  if( (NOT FileExists(ExeFileName)) AND (NOT DirExist(ExeFileName)) )then
  begin
    MakeFile(ExeFileName);
    MustDel:= True;
  end else
  begin
    MustDel:= False;
  end;
  try
    if shgetfileinfo(pchar(ExeFileName),0,sfi,sizeof(tshfileinfo),shgfi_sysiconindex or shgfi_smallicon)=0 then
    begin
      Result:= FALSE;
    end else
    begin
      IconIndex:= sfi.iicon;
      Result:= TRUE;
    end;
  finally
    if MustDel then
      SysUtils.DeleteFile(ExeFileName);
  end;
end;

{------------------------------------------------------------------------------}

procedure GetExeIcon(var Ico: TIcon; ExeFileName: String; IconIndex: Integer);
var
  Tmp: String;
begin
  Ico.Handle:= ExtractIcon(m_hApp, @ExeFileName[1], IconIndex);
  if Ico.Handle = 0 then
    GetLastErrorString(Tmp);
end;

{------------------------------------------------------------------------------}

Function  GetIconFromRes(IcoName: String; var Ico: TIcon): Boolean;
begin
  Result:= FALSE;

/// !!! BAUSTELLE !!!

end;

{------------------------------------------------------------------------------}

Function SameName(N1, N2 : String) : Boolean;
{
  Function to compare filespecs.

  Wildcards allowed in either name.
  Filenames should be compared seperately from filename extensions by using
     seperate calls to this function
        e.g.  FName1.Ex1
              FName2.Ex2
              are they the same?
              they are if SameName(FName1, FName2) AND SameName(Ex1, Ex2)

  Wildcards work the way DOS should've let them work (eg. *XX.DAT doesn't
  match just any file...only those with 'XX' as the last two characters of
  the name portion and 'DAT' as the extension).

  This routine calls itself recursively to resolve wildcard matches.

}
Var
   P1, P2 : Integer;
   Match  : Boolean;
Begin
   P1    := 1;
   P2    := 1;
   Match := TRUE;

   If (Length(N1) = 0) and (Length(N2) = 0) then
      Match := True
   else
      If Length(N1) = 0 then
         If N2[1] = '*' then
            Match := TRUE
         else
            Match := FALSE
      else
         If Length(N2) = 0 then
            If N1[1] = '*' then
               Match := TRUE
            else
               Match := FALSE;

   While (Match = TRUE) and (P1 <= Length(N1)) and (P2 <= Length(N2)) do
      If (N1[P1] = '?') or (N2[P2] = '?') then begin
         Inc(P1);
         Inc(P2);
      end {then}
      else
         If N1[P1] = '*' then begin
            Inc(P1);
            If P1 <= Length(N1) then begin
               While (P2 <= Length(N2)) and Not SameName(Copy(N1,P1,Length(N1)-P1+1), Copy(N2,P2,Length(N2)-P2+1)) do
                  Inc(P2);
               If P2 > Length(N2) then
                  Match := FALSE
               else begin
                  P1 := Succ(Length(N1));
                  P2 := Succ(Length(N2));
               end {if};
            end {then}
            else
               P2 := Succ(Length(N2));
         end {then}
         else
            If N2[P2] = '*' then begin
               Inc(P2);
               If P2 <= Length(N2) then begin
                  While (P1 <= Length(N1)) and Not SameName(Copy(N1,P1,Length(N1)-P1+1), Copy(N2,P2,Length(N2)-P2+1)) do
                     Inc(P1);
                  If P1 > Length(N1) then
                     Match := FALSE
                  else begin
                     P1 := Succ(Length(N1));
                     P2 := Succ(Length(N2));
                  end {if};
               end {then}
               else
                  P1 := Succ(Length(N1));
            end {then}
            else
               If UpCase(N1[P1]) = UpCase(N2[P2]) then begin
                  Inc(P1);
                  Inc(P2);
               end {then}
               else
                  Match := FALSE;

   If P1 > Length(N1) then begin
      While (P2 <= Length(N2)) and (N2[P2] = '*') do
         Inc(P2);
      If P2 <= Length(N2) then
         Match := FALSE;
   end {if};

   If P2 > Length(N2) then begin
      While (P1 <= Length(N1)) and (N1[P1] = '*') do
         Inc(P1);
      If P1 <= Length(N1) then
         Match := FALSE;
   end {if};

   SameName := Match;

End {SameName};


{------------------------------------------------------------------------------}

Function  SizeOfFile(FileName: String): DWORD;
var
  OldFileMode: BYTE;
  F          : File of BYTE;
 begin
  Result:=  DWORD(-1);
  if FileExists(FileName) then
  begin
    OldFileMode:= FileMode;
    AssignFile(F, FileName);
    FileMode:= 0; // ReadOnly
    try
      Reset(F);
      Result:= FileSize(F);
    finally
      CloseFile(F);
      FileMode:= OldFileMode;
    end;
  end else
  begin
    if DirExist(FileName) then
    begin
      Result:= 0;
    end;
  end;
end;

{------------------------------------------------------------------------------}

Procedure RepaintDesktop;
begin
  try
    InvalidateRect(0, nil, TRUE);
  finally
    DoEvents;
  end;

end;

{-----------------------------------------------------------------------}

procedure SizeForTaskBar(MyForm: TForm);
var
  TaskBarHandle: HWnd;    { Handle to the Win95 Taskbar }
  TaskBarCoord:  TRect;   { Coordinates of the Win95 Taskbar }
  CxScreen,               { Width of screen in pixels }
  CyScreen,               { Height of screen in pixels }
  CxFullScreen,           { Width of client area in pixels }
  CyFullScreen,           { Heigth of client area in pixels }
  CyCaption:     Integer; { Height of a window's title bar in pixels }
begin
  TaskBarHandle := FindWindow('Shell_TrayWnd',Nil); { Get Win95 Taskbar handle }
  if TaskBarHandle = 0 then { We're running Win 3.x or WinNT w/o Win95 shell, do nothing }
    exit
  else { We're running Win95 or WinNT w/Win95 shell }
    begin
      MyForm.WindowState := wsNormal;
      GetWindowRect(TaskBarHandle,TaskBarCoord);      { Get coordinates of Win95 Taskbar }
      CxScreen      := GetSystemMetrics(SM_CXSCREEN); { Get various screen dimensions and set form's width/height }
      CyScreen      := GetSystemMetrics(SM_CYSCREEN);
      CxFullScreen  := GetSystemMetrics(SM_CXFULLSCREEN);
      CyFullScreen  := GetSystemMetrics(SM_CYFULLSCREEN);
      CyCaption     := GetSystemMetrics(SM_CYCAPTION);
      MyForm.Width  := CxScreen - (CxScreen - CxFullScreen) + 1;
      MyForm.Height := CyScreen - (CyScreen - CyFullScreen) + CyCaption + 1;
      MyForm.Top    := 0;
      MyForm.Left   := 0;
      if (TaskBarCoord.Top = -2) and (TaskBarCoord.Left = -2) then { Taskbar on either top or left }
        if TaskBarCoord.Right > TaskBarCoord.Bottom then { Taskbar on top }
          MyForm.Top  := TaskBarCoord.Bottom
        else { Taskbar on left }
          MyForm.Left := TaskBarCoord.Right;
    end;
end;


{------------------------------------------------------------------------------}

function SHDeleteFile(     const src: String; hwnd : HWND): Boolean;
var
  Struct   : TSHFileOpStruct;
  pFromc   : array[0..257] of char;
  Resultval: integer;
begin
  Result := False;
  try
   if FileExists(src) then
   begin
     fillchar(Struct,sizeof(Struct),0);
     fillchar(pfromc,sizeof(pfromc),0);
     StrPcopy(pfromc,expandfilename(src));
     Struct.wnd   := hwnd;
     Struct.wFunc := FO_DELETE;
     Struct.pFrom := pFromC;
     Struct.fFlags:= FOF_ALLOWUNDO + FOF_NOCONFIRMATION + FOF_NOERRORUI;
     if hwnd = 0 then
     begin
       Struct.fFlags:= Struct.fFlags + FOF_SILENT;
     end;
     Resultval := ShFileOperation(Struct);
     if Resultval = 0 then
     begin
       Result := true;
     end else
     begin
       OutputDebugString(PChar( 'result is ' + IntToStr(Resultval)));
     end;
     DoEvents;
   end;
  except
    on E: Exception do OutputDebugString(PChar(E.Message));
  end;
end;

{------------------------------------------------------------------------------}


function SHDeleteDirectory(const DirName: string; hwnd : HWND): Boolean;
var
  strucFileOp : TSHFileOpStruct;
  pFromc      : array[0..257] of char;
  Resultval   : Integer;
begin
  Result:= FALSE;
  try
    if not DirExist(DirName) then
    begin
       exit;
    end else
    begin
      fillchar(strucFileOp,sizeof(strucFileOp),0);
      fillchar(pfromc,sizeof(pfromc),0);
      StrPcopy(pfromc,expandfilename(DirName));
      strucFileOp.wnd   := hwnd;
      strucFileOp.wFunc := FO_DELETE;
      strucFileOp.pFrom := pFromC;
      strucFileOp.fFlags:= FOF_NOCONFIRMATION + FOF_NOERRORUI + FOF_ALLOWUNDO;
      if hwnd = 0 then
      begin
        strucFileOp.fFlags:= strucFileOp.fFlags + FOF_SILENT;
      end;

      Resultval:= ShFileOperation(strucFileOp);
      if Resultval = 0 then
      begin
        Result := true;
      end else
      begin
        OutputDebugString(PChar( 'result is ' + IntToStr(Resultval)));
      end;
      DoEvents;
    end;
  except
    on E: Exception do OutputDebugString(PChar(E.Message));
  end;
end;
{------------------------------------------------------------------------------}
function SHCopyFile(const src, dest: String; hwnd : HWND): Boolean;
var
  strucFileOp : TSHFileOpStruct;
  Resultval   : integer;
begin
  Result := false;
  try
    fillchar(strucFileOp,sizeof(strucFileOp),0);
    strucFileOp.Wnd   := hwnd;
    strucFileOp.pFrom := PChar(src);
    strucFileOp.pTo   := PChar(dest);
    strucFileOp.wFunc := FO_COPY;
    strucFileOp.fFlags:= FOF_NOCONFIRMATION + FOF_NOERRORUI +FOF_ALLOWUNDO;
    if hwnd = 0 then
    begin
      strucFileOp.fFlags:= strucFileOp.fFlags + FOF_SILENT;
    end;

    Resultval:= ShFileOperation(strucFileOp);
    if Resultval = 0 then
    begin
      Result := true;
    end else
    begin
      OutputDebugString(PChar( 'result is ' + IntToStr(Resultval)));
    end;
    DoEvents;
  except
    on E: Exception do OutputDebugString(PChar(E.Message));
  end;
end;

{------------------------------------------------------------------------------}
function SHMoveFile(const src, dest: String; hwnd : HWND): Boolean;
var
  strucFileOp : TSHFileOpStruct;
  Resultval   : integer;
begin
  Result := false;
  try
    fillchar(strucFileOp,sizeof(strucFileOp),0);
    strucFileOp.Wnd   := hwnd;
    strucFileOp.pFrom := PChar(src);
    strucFileOp.pTo   := PChar(dest);
    strucFileOp.wFunc := FO_MOVE;
    strucFileOp.fFlags:= FOF_NOCONFIRMATION + FOF_NOERRORUI +FOF_ALLOWUNDO;
    if hwnd = 0 then
    begin
      strucFileOp.fFlags:= strucFileOp.fFlags + FOF_SILENT;
    end;

    Resultval:= ShFileOperation(strucFileOp);
    if Resultval = 0 then
    begin
      Result := true;
    end else
    begin
      OutputDebugString(PChar( 'result is ' + IntToStr(Resultval)));
    end;
    DoEvents;
  except
    on E: Exception do OutputDebugString(PChar(E.Message));
  end;
end;

{------------------------------------------------------------------------------}
function SHRenameFile(const src, dest: String; hwnd : HWND): Boolean;
var
  strucFileOp : TSHFileOpStruct;
  Resultval   : integer;
begin
  Result := false;
  try
    fillchar(strucFileOp,sizeof(strucFileOp),0);
    strucFileOp.Wnd   := hwnd;
    strucFileOp.pFrom := PChar(src);
    strucFileOp.pTo   := PChar(dest);
    strucFileOp.wFunc := FO_RENAME;
    strucFileOp.fFlags:= FOF_NOCONFIRMATION + FOF_NOERRORUI +FOF_ALLOWUNDO;
    if hwnd = 0 then
    begin
      strucFileOp.fFlags:= strucFileOp.fFlags + FOF_SILENT;
    end;

    Resultval:= ShFileOperation(strucFileOp);
    if Resultval = 0 then
    begin
      Result := true;
    end else
    begin
      OutputDebugString(PChar( 'result is ' + IntToStr(Resultval)));
    end;
    DoEvents;
  except
    on E: Exception do OutputDebugString(PChar(E.Message));
  end;
end;


{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}

begin
  {Init-Code}
  m_hApp:= Application.Handle;
end.



