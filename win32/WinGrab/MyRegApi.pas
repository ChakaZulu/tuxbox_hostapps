////////////////////////////////////////////////////////////////////////////////
//
// $Log: MyRegApi.pas,v $
// Revision 1.1  2004/07/02 13:57:40  thotto
// initial
//
//

unit MyREGAPI;

{-----------------------------------------------------------------------}

interface

{-----------------------------------------------------------------------}

uses
  SysUtils
  ,Windows
  ,Messages
  ,Classes
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,StdCtrls
  ,Buttons
  ,ExtCtrls
  ,RegConst
  ;

{-----------------------------------------------------------------------}

Function  WriteRegKey(KeyRoot: hKey; SubKey, KeyValue, KeyStr: String): Boolean;
Function  ReadRegKey( KeyRoot: hKey; SubKey, KeyValue: String; var KeyStr: String): Boolean;
Procedure RegRenameTable( szOldTable, szNewTable: String );
Procedure RegEraseTable( szTable: String );

{-----------------------------------------------------------------------}

implementation

{-----------------------------------------------------------------------}

function WriteRegKey(KeyRoot: hKey; SubKey, KeyValue, KeyStr: String): Boolean;
var
  sz_KeyString: String[255];
  l_RetVal    : LongInt;
  KeyHandle   : hKey;
begin
  result:= FALSE;
  if SubKey   = '' then exit;
  if KeyValue = '' then exit;
  if KeyRoot  = 0  then KeyRoot:= HKEY_LOCAL_MACHINE;
  sz_KeyString := SubKey+#0;
  l_RetVal := RegCreateKey(KeyRoot, @sz_KeyString[1], KeyHandle);
  If l_RetVal = ERROR_SUCCESS Then
  begin
    sz_KeyString := KeyStr+#0;
    KeyValue := KeyValue+#0;
    RegSetValueEx(KeyHandle,
                  @KeyValue[1],
                  0,
                  1,
                  @sz_KeyString[1],
                  Length(sz_KeyString));
    RegCloseKey(KeyHandle);
    result:= TRUE;
  end;
end;

{-----------------------------------------------------------------------}

function ReadRegKey( KeyRoot: hKey; SubKey, KeyValue: String; var KeyStr: String): Boolean;
var
  sz_Buffer   : String[255];
  sz_KeyString: String[255];
  l_RetVal    : LongInt;
  KeyHandle   : hKey;
  dwType      : DWORD;
  dwSize      : DWORD;
begin
  result:= FALSE;
  if SubKey   = '' then exit;
  if KeyValue = '' then exit;
  if KeyRoot  = 0  then KeyRoot:= HKEY_LOCAL_MACHINE;
  sz_KeyString := SubKey+#0;
  l_RetVal := RegOpenKey(KeyRoot, @sz_KeyString[1], KeyHandle);
  If l_RetVal = ERROR_SUCCESS Then
  begin
    sz_KeyString:= KeyStr+#0;
    dwSize   := SizeOf(sz_Buffer);
    FillChar(sz_Buffer, dwSize, 32);
    inc(dwSize);
    KeyValue    := KeyValue+#0;
    l_RetVal := RegQueryValueEx(KeyHandle,
                                @KeyValue[1],
                                nil,
                                @dwType,
                                @sz_Buffer,
                                @dwSize);
    If l_RetVal = ERROR_SUCCESS Then
    begin
      if dwSize > 0 then
      begin
        SetString(KeyStr, PChar(@sz_Buffer[0]), Integer(dwSize));
        SetLength(KeyStr, dwSize-1);
        Result:= TRUE;
      end;
    end;
    RegCloseKey(KeyHandle);
  end;
end;

{-----------------------------------------------------------------------}

Function  RegFindTable( szTable: String; var szValueName: String ): Boolean;
var
  sz_KeyString : String[255];
  sz_Buffer    : String[255];
  dwBufferSize : DWORD;
  sz_DataString: String[255];
  dwDataSize   : DWORD;
  l_RetVal     : DWORD;
  KeyRoot      : hKey;
  KeyHandle    : hKey;
  iValue       : DWORD;
begin
  Result:= FALSE;
  KeyRoot:= HKEY_LOCAL_MACHINE;
  sz_KeyString := 'Software\Tom\Das_Buch\Alias'+#0;
  l_RetVal := RegOpenKey(KeyRoot, @sz_KeyString[1], KeyHandle);
  If l_RetVal = ERROR_SUCCESS Then
  begin
    iValue:= 0;
    repeat
      dwBufferSize:= SizeOf(sz_Buffer);
      FillChar(sz_Buffer,dwBufferSize,0);
      dwDataSize:= SizeOf(sz_DataString);
      FillChar(sz_DataString,dwDataSize,0);
      l_RetVal:= RegEnumValue( KeyHandle,         // handle of key to query
                               iValue,            // index of value to query
                               @sz_Buffer[1],     // address of buffer for value string
                               dwBufferSize,      // address for size of value buffer
                               nil,               // reserved
                               nil,               // address of buffer for type code
                               @sz_DataString[1], // address of buffer for value data
                               @dwDataSize );
      SetLength(sz_Buffer, dwBufferSize);
      SetLength(sz_DataString, dwDataSize-1);
      if szTable = sz_DataString then
      begin
        szValueName:= sz_Buffer;
        Result:= TRUE;
        l_RetVal:= ERROR_NO_MORE_ITEMS;
      end;
      inc(iValue);
    until( l_RetVal<>ERROR_SUCCESS );
    RegCloseKey(KeyHandle);
  end;   
end;

{-----------------------------------------------------------------------}

function  DeleteRegValue(KeyRoot: hKey; SubKey, KeyValue: String): Boolean;
var
  sz_KeyString: String[255];
  l_RetVal    : LongInt;
  KeyHandle   : hKey;
begin
  result:= FALSE;
  if SubKey   = '' then exit;
  if KeyValue = '' then exit;
  if KeyRoot  = 0  then KeyRoot:= HKEY_LOCAL_MACHINE;
  sz_KeyString := SubKey+#0;
  l_RetVal := RegOpenKey(KeyRoot, @sz_KeyString[1], KeyHandle);
  If l_RetVal = ERROR_SUCCESS Then
  begin
    KeyValue := KeyValue+#0;
    RegDeleteValue( KeyHandle, @KeyValue[1] );
    RegCloseKey(KeyHandle);
  end;
end;

{-----------------------------------------------------------------------}

Procedure RegRenameTable( szOldTable, szNewTable: String );
var
  szValueName: String;
begin
  if RegFindTable(szOldTable,szValueName) then
  begin
    WriteRegKey(HKEY_LOCAL_MACHINE, 'Software\Tom\Das_Buch\Alias', szValueName, szNewTable);
  end;
end;

{-----------------------------------------------------------------------}

Procedure RegEraseTable( szTable: String );
var
  szValueName: String;
begin
  if RegFindTable(szTable,szValueName) then
  begin
    DeleteRegValue(HKEY_LOCAL_MACHINE, 'Software\Tom\Das_Buch\Alias', szValueName);
  end;
end;

{-----------------------------------------------------------------------}

end.
