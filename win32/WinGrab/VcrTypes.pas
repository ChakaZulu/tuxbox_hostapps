////////////////////////////////////////////////////////////////////////////////
//
// $Log: VcrTypes.pas,v $
// Revision 1.1  2004/07/02 14:06:35  thotto
// initial
//
//

unit VcrTypes;

interface

uses
  StdCtrls;

const
  VideoFileExt = '.mpv';
  AudioFileExt = '.mp2';
  Mgeg2FileExt = '.m2p';
  DivXFileExt  = '.avi';
  EpgFileExt   = '.HTML';

type e_VCRStates = (  CMD_VCR_UNKNOWN     = 0,
                      CMD_VCR_RECORD      = 1,
                      CMD_VCR_STOP        = 2,
                      CMD_VCR_PAUSE       = 3,
                      CMD_VCR_RESUME      = 4,
                      CMD_VCR_AVAILABLE   = 5 );

type T_RecordingData = record
  bIsPreview   : Boolean;
  iMuxerSyncs  : Integer;
  cmd          : e_VCRStates;
  channel_id   : String;
  apids        : array [0..9] of Integer;
  vpid         : integer;
  mode         : integer;
  epgid        : String;
  channelname  : String;
  epgtitle     : String;
  epgsubtitle  : String;
  epg          : String;
  filename     : String;
  dbConnection : String;
  //transform ...
  bDVDx        : Boolean;
  sDVDxPath    : String;
  bMoviX       : Boolean;
  sMoviXPath   : String;
  //burn a ISO ...
  bCDRwBurn    : Boolean;
  sIsoPath     : String;
  sCDRwDevId   : String;
  sCDRwSpeed   : String;
  //StateMessages send to ...
  HWndMsgList  : Integer;
end;

implementation

end.
