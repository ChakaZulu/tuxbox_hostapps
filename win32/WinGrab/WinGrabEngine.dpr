library WinGrabEngine;

uses
  ComServ,
  WinGrabLibrary in 'WinGrabLibrary.pas' {WinGrabLibrary: CoClass},
  WinGrabGrabControl in 'WinGrabGrabControl.pas' {WinGrabGrabControl: CoClass},
  WinGrabReader in 'WinGrabReader.pas' {WinGrabReader: CoClass};
exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
