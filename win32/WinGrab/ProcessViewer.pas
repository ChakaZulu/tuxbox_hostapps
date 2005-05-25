{
	ProcessViewer Unit V1.0
	by Leo, March 2001

	See the file ProcessViewer.txt for informations about the properties and methods.
}

unit ProcessViewer;

interface

uses
	Windows, Dialogs, SysUtils, Classes, ShellAPI, TLHelp32, Forms;

const
	SleepForReCheck=5000;

type TProcessInfo=record
	FileName: string;
	Caption: string;
	Visible: boolean;
	Handle: DWord;
	PClass: string;
	ThreadID: DWord;
	PID: DWord;
end;


var
	DateiList,CaptionList,VisibleList,HandleList,ClassList,ThreadIdList,PIDList: TStringList;
	ProcessInfo: array of TProcessInfo;

function EnumWindowsProc(hWnd: HWND; lParam: LPARAM): Bool; stdcall;
function KillProcessByPID(PID: DWord): boolean;
function KillProcessByFileName(FileName: string; KillAll: boolean): boolean;
procedure GetProcessList;
function GetFileNameFromHandle(Handle: hwnd):string;
function IsFileActive(FileName: String): boolean;

implementation

procedure GetProcessList;
var
	i,Laenge: integer;
begin
DateiList.Clear;
HandleList.Clear;
ClassList.Clear;
CaptionList.Clear;
VisibleList.Clear;
ThreadIdList.Clear;
PIDList.Clear;
EnumWindows(@EnumWindowsProc, 0);
Laenge:=DateiList.Count;
SetLength(ProcessInfo,Laenge);
for i:=0 to Laenge-1 do
begin
	DateiList[i]:=UpperCase(DateiList[i]);
	with ProcessInfo[i] do
	begin
		FileName:=DateiList[i];
		Caption:=CaptionList[i];
		Visible:=VisibleList[i]='1';
		Handle:=StrToInt64(HandleList[i]);
		PClass:=ClassList[i];
		ThreadID:=StrToInt64(ThreadIdList[i]);
		PID:=StrToInt64(PIDList[i]);
	end;
end;
end;

function IsFileActive(FileName: String): boolean;
var
	i: integer;
begin
result:=false;
if FileName='' then exit;
GetProcessList;
FileName:=UpperCase(ExtractFileName(FileName));
for i:=0 to Length(ProcessInfo)-1 do
begin
	if Pos(FileName,ProcessInfo[i].FileName)>0 then
	begin
		result:=true;
		break;
	end;
end;
end;

function GetFileNameFromHandle(Handle: hwnd):string;
var
	PID: DWord;
	aSnapShotHandle: THandle;
	ContinueLoop: Boolean;
	aProcessEntry32: TProcessEntry32;
begin
GetWindowThreadProcessID(Handle, @PID);
aSnapShotHandle := CreateToolHelp32SnapShot(TH32CS_SNAPPROCESS, 0);
aProcessEntry32.dwSize := SizeOf(aProcessEntry32);
ContinueLoop := Process32First(aSnapShotHandle, aProcessEntry32);
while Integer(ContinueLoop) <> 0 do
begin
	if aProcessEntry32.th32ProcessID = PID then
	begin
		result:=aProcessEntry32.szExeFile;
		break;
	end;
	ContinueLoop := Process32Next(aSnapShotHandle, aProcessEntry32);
end;
CloseHandle(aSnapShotHandle);
end;

function EnumWindowsProc(hWnd: HWND; lParam: LPARAM): Bool;
var
	Capt,Cla: array[0..255] of char;
	Datei: string;
	ident: dword;
begin
GetWindowText(hWnd, Capt, 255);
GetClassName(hwnd,Cla,255);
ThreadIdList.Add(IntToStr(GetWindowThreadProcessId(hwnd,nil)));
Datei:=GetFileNameFromhandle(hwnd);
DateiList.Add(Datei);
HandleList.Add(IntToStr(HWnd));
if IsWindowVisible(HWnd) then VisibleList.Add('1') else VisibleList.Add('0');
ClassList.Add(Cla);
CaptionList.Add(Capt);
GetWindowThreadProcessId(StrToInt(HandleList[HandleList.Count-1]),@ident);
PIDList.Add(IntToStr(ident));
Result:=true;
end;

function KillProcessByPID(PID : DWord): boolean;
var
	myhandle : THandle;
	i: integer;
begin
myhandle := OpenProcess(PROCESS_TERMINATE, False, PID);
TerminateProcess(myhandle, 0);
for i:=0 to SleepForReCheck do Application.ProcessMessages; //Genug Zeit geben
GetProcessList;
Result:=PIDList.IndexOf(IntToStr(PID))=-1;
end;

function KillProcessByFileName(FileName: string; KillAll: boolean): boolean;
var
	i: integer;
	FileFound: boolean;
begin
result:=false;
if FileName='' then exit;
FileName:=UpperCase(ExtractFileName(FileName));
result:=true;
GetProcessList;
if KillAll then
begin
	//Kill all
	FileFound:=false;
	repeat
		GetProcessList;
		FileFound:=false;
		for i:=0 to DateiList.Count-1 do
		begin
			if Pos(Filename,DateiList[i])>0 then
			begin
				FileFound:=true;
				break;
			end;
		end;
		if i<DateiList.Count then
		begin
			if not KillProcessByPID(StrToInt64(PIDList[i])) then
			begin
				result:=false;
				exit;
			end;
		end;
	until not FileFound;
end else
begin
	//Kill one
	for i:=0 to DateiList.Count-1 do
	begin
		if Pos(Filename,DateiList[i])>0 then break;
	end;
	if i<DateiList.Count then
	begin
		if not KillProcessByPID(StrToInt64(PIDList[i])) then
		begin
			result:=false;
			exit;
		end;
	end;
end;
end;

initialization
DateiList:=TStringList.Create;
HandleList:=TStringList.Create;
ClassList:=TStringList.Create;
CaptionList:=TStringList.Create;
VisibleList:=TStringList.Create;
ThreadIdList:=TStringList.Create;
PIDList:=TStringList.Create;

finalization
DateiList.Free;
HandleList.Free;
ClassList.Free;
CaptionList.Free;
VisibleList.Free;
ThreadIdList.Free;
PIDList.Free;

end.
