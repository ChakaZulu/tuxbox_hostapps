program WinGrabCmd;
{$APPTYPE CONSOLE}

uses
  SysUtils,
  TeGrabManager;

var
  i, j                        : Integer;
  S, t                        : string;

  ip                          : string;
  vpid                        : Integer;
  apid                        : array of Integer;
  split                       : Integer;
  outfile                     : string;

begin
  WriteLn('WinGrabCmd - Kommandozeilenversion von WinGrab v0.7m');
  WriteLn('====================================================');
  if FindCmdLineSwitch('?', ['-', '/'], True) or FindCmdLineSwitch('help', ['-', '/'], True) then begin
    WriteLn('Aufrufparameter:');
    WriteLn('/ip:xxx.xxx.xxx.xxx - selbsterklärend');
    WriteLn('/vpid:123 - dezimal (oder hex mit $ABC)');
    WriteLn('/apid:123 - dezimal (oder hex mit $ABC) darf mehrmals vorkommen');
    WriteLn('/split:123 - optional - splittgröße in mb');
    WriteLn('/out:filename - wo soll das gemuxte denn hin?');
    exit;
  end;

  ip := '';
  vpid := 0;
  apid := nil;
  split := 0;
  outfile := '';

  for i := 1 to ParamCount do begin
    s := ParamStr(i);
    if not (s[1] in ['-', '/']) then begin
      WriteLn('Unbekannter Parameter: ', s);
      exit;
    end;

    Delete(s, 1, 1);
    j := Pos(':', s);
    if j < 2 then begin
      WriteLn('Unbekannter Parameter: ', s);
      exit;
    end;

    t := Copy(s, j + 1, High(Integer));
    Delete(s, j, High(Integer));

    if SameText(s, 'ip') then begin
      if ip <> '' then begin
        WriteLn('Parameter mehrmals definiert: ip');
        exit;
      end;
      ip := t;
    end
    else
      if SameText(s, 'vpid') then begin
        if vpid <> 0 then begin
          WriteLn('Parameter mehrmals definiert: vpid');
          exit;
        end;
        vpid := StrToIntDef(t, 0);
        if vpid = 0 then begin
          WriteLn('Parameter ungültig: ', s);
          exit;
        end;
      end
      else
        if SameText(s, 'apid') then begin
          j := StrToIntDef(t, 0);
          if j = 0 then begin
            WriteLn('Parameter ungültig: ', s);
            exit;
          end;
          SetLength(apid, Length(apid) + 1);
          apid[High(apid)] := j;
        end
        else
          if SameText(s, 'split') then begin
            if split <> 0 then begin
              WriteLn('Parameter mehrmals definiert: split');
              exit;
            end;
            split := StrToIntDef(t, 0);
            if split = 0 then begin
              WriteLn('Parameter ungültig: ', s);
              exit;
            end;
          end
          else
            if SameText(s, 'out') then begin
              if outfile <> '' then begin
                WriteLn('Parameter mehrmals definiert: out');
                exit;
              end;
              outfile := t;
            end
            else
              if j < 2 then begin
                WriteLn('Unbekannter Parameter: ', s);
                exit;
              end;
  end;

  if ip = '' then begin
    WriteLn('Parameter fehlt: ip');
    exit;
  end;

  if vpid = 0 then begin
    WriteLn('Parameter fehlt: vpid');
    exit;
  end;

  if Length(apid) < 1 then begin
    WriteLn('Parameter fehlt: apid');
    exit;
  end;

  if outfile = '' then begin
    WriteLn('Parameter fehlt: outfile');
    exit;
  end;

  with TTeMuxGrabManager.Create(ip, vpid, apid, outfile, split, nil, nil) do try
    WriteLn('');
    WriteLn('Enter zum beenden der aufnahme...');
    ReadLn;
  finally
    Free;
  end;
end.

