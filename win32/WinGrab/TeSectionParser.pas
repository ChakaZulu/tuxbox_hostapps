unit TeSectionParser;

interface

uses
  Classes, SysUtils, TeLogableThread, TePesParser;

type
  TTeSectionParser = class(TObject)
  public
    OutputBuffer: array[0..8192] of Byte;
    OutputPos: Integer;
    OutputLength: Integer;

    OnSectionFound: TNotifyEvent;
    Log: ILog;

    procedure FindSections(InputBuffer: PLongByteArray; Count: Integer);
  end;

implementation

uses
  Winsock2;

type
  PWord = ^Word;

procedure TTeSectionParser.FindSections(InputBuffer: PLongByteArray; Count: Integer);
var
  Current                     : Integer;
begin
  Current := 0;
  while Current < Count do begin
    OutputBuffer[OutputPos] := InputBuffer[Current];
    Inc(OutputPos);
    Inc(Current);
    case OutputPos of
      1, 2: ;
      3: OutputLength := (((OutputBuffer[1] and $0F) shl 8) or OutputBuffer[2]);
    else
      if OutputPos >= OutputLength then begin
        if Assigned(OnSectionFound) then
          OnSectionFound(Self);                             //inform our client...
        OutputPos := 0;
        OutputLength := 0;
      end;
    end;
  end;
end;

end.

