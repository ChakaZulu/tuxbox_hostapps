unit WinGrabEngine_TLB;

// ************************************************************************ //
// WARNUNG                                                                    
// -------                                                                    
// Die in dieser Datei deklarierten Typen wurden aus Daten einer Typbibliothek
// generiert. Wenn diese Typbibliothek explizit oder indirekt (über eine     
// andere Typbibliothek) reimportiert wird oder wenn die Anweisung            
// 'Aktualisieren' im Typbibliotheks-Editor während des Bearbeitens der     
// Typbibliothek aktiviert ist, wird der Inhalt dieser neu generiert und alle 
// manuell vorgenommenen Änderungen gehen verloren.                           
// ************************************************************************ //

// PASTLWTR : $Revision: 1.1 $
// Datei generiert am 27.01.2002 23:03:43 aus der unten beschriebenen Typbibliothek.

// ************************************************************************ //
// Typbib: C:\Programming\prj\WinGrab\WinGrabEngine.tlb (1)
// IID\LCID: {DA688C28-F019-40C0-967C-49C336EF3D53}\0
// Hilfedatei: 
// AbhLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\System32\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\WINDOWS\System32\STDVCL40.DLL)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit muss ohne typüberprüfte Zeiger compiliert werden. 
interface

uses Windows, ActiveX, Classes, Graphics, OleServer, OleCtrls, StdVCL;

// *********************************************************************//
// In dieser Typbibliothek deklarierte GUIDS . Es werden folgende         
// Präfixe verwendet:                                                     
//   Typbibliotheken     : LIBID_xxxx                                     
//   CoClasses           : CLASS_xxxx                                     
//   DISPInterfaces      : DIID_xxxx                                      
//   Non-DISP interfaces : IID_xxxx                                       
// *********************************************************************//
const
  // Haupt- und Nebenversionen der Typbibliothek
  WinGrabEngineMajorVersion = 1;
  WinGrabEngineMinorVersion = 0;

  LIBID_WinGrabEngine: TGUID = '{DA688C28-F019-40C0-967C-49C336EF3D53}';

  IID_IWinGrabLibrary: TGUID = '{71245F70-63D5-4D00-99D5-488E42E6ABCA}';
  CLASS_WinGrabLibrary: TGUID = '{9509ADD1-89F3-4D49-9533-87DC552451D3}';
  IID_IWinGrabGrabControl: TGUID = '{DFD28733-9E43-48C8-892D-045BC5804BF5}';
  CLASS_WinGrabGrabControl: TGUID = '{DC82D502-BE83-46A0-B61A-1F11543F3E6C}';
  IID_IWinGrabProcessCallback: TGUID = '{AEAAA5C1-7D5B-45C0-B966-5AD0063C95AF}';
  IID_IWinGrabReader: TGUID = '{B12450B0-ED76-429B-88A5-FFDEA948B9B0}';
  CLASS_WinGrabReader: TGUID = '{188FDD28-0A3A-414D-8E68-F9D4AA142BC8}';
type

// *********************************************************************//
// Forward-Deklaration von in der Typbibliothek definierten Typen         
// *********************************************************************//
  IWinGrabLibrary = interface;
  IWinGrabLibraryDisp = dispinterface;
  IWinGrabGrabControl = interface;
  IWinGrabGrabControlDisp = dispinterface;
  IWinGrabProcessCallback = interface;
  IWinGrabProcessCallbackDisp = dispinterface;
  IWinGrabReader = interface;
  IWinGrabReaderDisp = dispinterface;

// *********************************************************************//
// Deklaration von in der Typbibliothek definierten CoClasses             
// (HINWEIS: Hier wird jede CoClass zu ihrer Standardschnittstelle        
// zugewiesen)                                                            
// *********************************************************************//
  WinGrabLibrary = IWinGrabLibrary;
  WinGrabGrabControl = IWinGrabGrabControl;
  WinGrabReader = IWinGrabReader;


// *********************************************************************//
// Schnittstelle: IWinGrabLibrary
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {71245F70-63D5-4D00-99D5-488E42E6ABCA}
// *********************************************************************//
  IWinGrabLibrary = interface(IDispatch)
    ['{71245F70-63D5-4D00-99D5-488E42E6ABCA}']
    function  StartDirectGrab(const aIP: WideString; aVideoPID: Integer; aAudioPIDs: OleVariant; 
                              const aVideoFileName: WideString; aAudioFileNames: OleVariant; 
                              aStripVideoPes: WordBool; aStripAudioPes: OleVariant): IDispatch; safecall;
    function  StartMuxGrab(const aIP: WideString; aVideoPID: Integer; aAudioPIDs: OleVariant; 
                           const aMuxFileName: WideString; aSplittSize: Integer): IDispatch; safecall;
    function  StartDirectGrabEx(const aIP: WideString; aVideoPID: Integer; aAudioPIDs: OleVariant; 
                                const aVideoFileName: WideString; aAudioFileNames: OleVariant; 
                                aStripVideoPes: WordBool; aStripAudioPes: OleVariant; 
                                const aCallback: IWinGrabProcessCallback): IWinGrabGrabControl; safecall;
    function  StartMuxGrabEx(const aIP: WideString; aVideoPID: Integer; aAudioPIDs: OleVariant; 
                             const aMuxFileName: WideString; aSplittSize: Integer; 
                             const aCallback: IWinGrabProcessCallback): IWinGrabGrabControl; safecall;
    function  StartMux(const aVideoFileName: WideString; aVideoStartOffset: Integer; 
                       aVideoEndOffset: Integer; aAudioFileNames: OleVariant; 
                       const aMuxFileName: WideString; aSplittSize: Integer): IDispatch; safecall;
    function  StartMuxEx(const aVideoFileName: WideString; aVideoStartOffset: Integer; 
                         aVideoEndOffset: Integer; aAudioFileNames: OleVariant; 
                         const aMuxFileName: WideString; aSplittSize: Integer; 
                         const aCallback: IWinGrabProcessCallback): IWinGrabGrabControl; safecall;
  end;

// *********************************************************************//
// DispIntf:  IWinGrabLibraryDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {71245F70-63D5-4D00-99D5-488E42E6ABCA}
// *********************************************************************//
  IWinGrabLibraryDisp = dispinterface
    ['{71245F70-63D5-4D00-99D5-488E42E6ABCA}']
    function  StartDirectGrab(const aIP: WideString; aVideoPID: Integer; aAudioPIDs: OleVariant; 
                              const aVideoFileName: WideString; aAudioFileNames: OleVariant; 
                              aStripVideoPes: WordBool; aStripAudioPes: OleVariant): IDispatch; dispid 1;
    function  StartMuxGrab(const aIP: WideString; aVideoPID: Integer; aAudioPIDs: OleVariant; 
                           const aMuxFileName: WideString; aSplittSize: Integer): IDispatch; dispid 2;
    function  StartDirectGrabEx(const aIP: WideString; aVideoPID: Integer; aAudioPIDs: OleVariant; 
                                const aVideoFileName: WideString; aAudioFileNames: OleVariant; 
                                aStripVideoPes: WordBool; aStripAudioPes: OleVariant; 
                                const aCallback: IWinGrabProcessCallback): IWinGrabGrabControl; dispid 4;
    function  StartMuxGrabEx(const aIP: WideString; aVideoPID: Integer; aAudioPIDs: OleVariant; 
                             const aMuxFileName: WideString; aSplittSize: Integer; 
                             const aCallback: IWinGrabProcessCallback): IWinGrabGrabControl; dispid 5;
    function  StartMux(const aVideoFileName: WideString; aVideoStartOffset: Integer; 
                       aVideoEndOffset: Integer; aAudioFileNames: OleVariant; 
                       const aMuxFileName: WideString; aSplittSize: Integer): IDispatch; dispid 3;
    function  StartMuxEx(const aVideoFileName: WideString; aVideoStartOffset: Integer; 
                         aVideoEndOffset: Integer; aAudioFileNames: OleVariant; 
                         const aMuxFileName: WideString; aSplittSize: Integer; 
                         const aCallback: IWinGrabProcessCallback): IWinGrabGrabControl; dispid 6;
  end;

// *********************************************************************//
// Schnittstelle: IWinGrabGrabControl
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {DFD28733-9E43-48C8-892D-045BC5804BF5}
// *********************************************************************//
  IWinGrabGrabControl = interface(IDispatch)
    ['{DFD28733-9E43-48C8-892D-045BC5804BF5}']
    procedure Stop; safecall;
    function  CreateReader: IWinGrabReader; safecall;
  end;

// *********************************************************************//
// DispIntf:  IWinGrabGrabControlDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {DFD28733-9E43-48C8-892D-045BC5804BF5}
// *********************************************************************//
  IWinGrabGrabControlDisp = dispinterface
    ['{DFD28733-9E43-48C8-892D-045BC5804BF5}']
    procedure Stop; dispid 1;
    function  CreateReader: IWinGrabReader; dispid 2;
  end;

// *********************************************************************//
// Schnittstelle: IWinGrabProcessCallback
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {AEAAA5C1-7D5B-45C0-B966-5AD0063C95AF}
// *********************************************************************//
  IWinGrabProcessCallback = interface(IDispatch)
    ['{AEAAA5C1-7D5B-45C0-B966-5AD0063C95AF}']
    procedure OnMessage(const aMessage: WideString); safecall;
    procedure OnStateChange(const aName: WideString; const aState: WideString); safecall;
  end;

// *********************************************************************//
// DispIntf:  IWinGrabProcessCallbackDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {AEAAA5C1-7D5B-45C0-B966-5AD0063C95AF}
// *********************************************************************//
  IWinGrabProcessCallbackDisp = dispinterface
    ['{AEAAA5C1-7D5B-45C0-B966-5AD0063C95AF}']
    procedure OnMessage(const aMessage: WideString); dispid 1;
    procedure OnStateChange(const aName: WideString; const aState: WideString); dispid 2;
  end;

// *********************************************************************//
// Schnittstelle: IWinGrabReader
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B12450B0-ED76-429B-88A5-FFDEA948B9B0}
// *********************************************************************//
  IWinGrabReader = interface(IDispatch)
    ['{B12450B0-ED76-429B-88A5-FFDEA948B9B0}']
    procedure WaitForData; safecall;
    function  ReadData(aDest: Integer; aMaxSize: Integer): Integer; safecall;
  end;

// *********************************************************************//
// DispIntf:  IWinGrabReaderDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B12450B0-ED76-429B-88A5-FFDEA948B9B0}
// *********************************************************************//
  IWinGrabReaderDisp = dispinterface
    ['{B12450B0-ED76-429B-88A5-FFDEA948B9B0}']
    procedure WaitForData; dispid 1;
    function  ReadData(aDest: Integer; aMaxSize: Integer): Integer; dispid 2;
  end;

// *********************************************************************//
// Die Klasse CoWinGrabLibrary stellt eine Methode Create und CreateRemote zur      
// Verfügung, um Instanzen der Standardschnittstelle IWinGrabLibrary, dargestellt von
// CoClass WinGrabLibrary, zu erzeugen. Diese Funktionen können                     
// von einem Client verwendet werden, der die CoClasses automatisieren    
// möchte, die von dieser Typbibliothek dargestellt werden.               
// *********************************************************************//
  CoWinGrabLibrary = class
    class function Create: IWinGrabLibrary;
    class function CreateRemote(const MachineName: string): IWinGrabLibrary;
  end;

// *********************************************************************//
// Die Klasse CoWinGrabGrabControl stellt eine Methode Create und CreateRemote zur      
// Verfügung, um Instanzen der Standardschnittstelle IWinGrabGrabControl, dargestellt von
// CoClass WinGrabGrabControl, zu erzeugen. Diese Funktionen können                     
// von einem Client verwendet werden, der die CoClasses automatisieren    
// möchte, die von dieser Typbibliothek dargestellt werden.               
// *********************************************************************//
  CoWinGrabGrabControl = class
    class function Create: IWinGrabGrabControl;
    class function CreateRemote(const MachineName: string): IWinGrabGrabControl;
  end;

// *********************************************************************//
// Die Klasse CoWinGrabReader stellt eine Methode Create und CreateRemote zur      
// Verfügung, um Instanzen der Standardschnittstelle IWinGrabReader, dargestellt von
// CoClass WinGrabReader, zu erzeugen. Diese Funktionen können                     
// von einem Client verwendet werden, der die CoClasses automatisieren    
// möchte, die von dieser Typbibliothek dargestellt werden.               
// *********************************************************************//
  CoWinGrabReader = class
    class function Create: IWinGrabReader;
    class function CreateRemote(const MachineName: string): IWinGrabReader;
  end;

implementation

uses ComObj;

class function CoWinGrabLibrary.Create: IWinGrabLibrary;
begin
  Result := CreateComObject(CLASS_WinGrabLibrary) as IWinGrabLibrary;
end;

class function CoWinGrabLibrary.CreateRemote(const MachineName: string): IWinGrabLibrary;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_WinGrabLibrary) as IWinGrabLibrary;
end;

class function CoWinGrabGrabControl.Create: IWinGrabGrabControl;
begin
  Result := CreateComObject(CLASS_WinGrabGrabControl) as IWinGrabGrabControl;
end;

class function CoWinGrabGrabControl.CreateRemote(const MachineName: string): IWinGrabGrabControl;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_WinGrabGrabControl) as IWinGrabGrabControl;
end;

class function CoWinGrabReader.Create: IWinGrabReader;
begin
  Result := CreateComObject(CLASS_WinGrabReader) as IWinGrabReader;
end;

class function CoWinGrabReader.CreateRemote(const MachineName: string): IWinGrabReader;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_WinGrabReader) as IWinGrabReader;
end;

end.
