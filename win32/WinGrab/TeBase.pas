unit TeBase;

interface

uses
  SysUtils;

type
  ETeError = class(Exception);

  TTeMessageEvent = procedure(aMsg: string) of object;

implementation

end.

