#ifndef __GUIDS_H__
#define __GUIDS_H__

// --------------------------------------------------------------------------
// MPEGVideoDecoder
// --------------------------------------------------------------------------
DEFINE_GUID(CLSID_PCLE_MPEGVideoDecoder2, 
0x4fed19d5, 0xcd87, 0x459e, 0x97, 0xe6, 0x56, 0x6b, 0xa0, 0xe2, 0xc6, 0x7f);

// --------------------------------------------------------------------------
// VideoDeInterlacer
// --------------------------------------------------------------------------
DEFINE_GUID(CLSID_DeInterlace, 
0x64dad9c2, 0x7d8a, 0x478f, 0x9b, 0xdc, 0xa2, 0x9e, 0xce, 0xdf, 0xec, 0x19);

DEFINE_GUID(IID_IDeInterlace, 
0x86aa9ce5, 0x5d13, 0x4c7e, 0x81, 0x97, 0x30, 0xf2, 0x2c, 0x25, 0x63, 0x50);

DECLARE_INTERFACE_(IDeInterlace,IUnknown)
{
STDMETHOD(setParameter) (THIS_ int command, DWORD value1, DWORD value2, DWORD *value3) PURE;
STDMETHOD(getParameter) (THIS_ int command, DWORD value1, DWORD value2, DWORD *value3) PURE;
};

#define CMD_DEINTERLACE_RGB24BITMAP 1
#define CMD_DEINTERLACE             2
#define CMD_TEMPORALFILTER          3

// --------------------------------------------------------------------------
// MPEGAudioDecoder
// --------------------------------------------------------------------------
DEFINE_GUID(CLSID_MPADecoder,
0xefc5a84, 0x7f47, 0x4ee7, 0xbf, 0xfb, 0xe8, 0x12, 0x90, 0x54, 0x18, 0x44);

// --------------------------------------------------------------------------
// VideoRenderer
// --------------------------------------------------------------------------
DEFINE_GUID(CLSID_PinnacleVideoRenderer,
0x11c012c1, 0x5563, 0x11d3, 0x8d, 0x66, 0x0, 0xaa, 0x0, 0xa0, 0x18, 0x93);

// --------------------------------------------------------------------------
// AV RawFileWriter
// --------------------------------------------------------------------------
DEFINE_GUID(CLSID_RAWWriter,
0x7c069d00, 0x777a, 0x11d3, 0xae, 0xe3, 0x0, 0x60, 0x8, 0x57, 0xee, 0xd8);

DEFINE_GUID(CLSID_SimpleSink,0x82febb53, 
0xbed7, 0x4e94, 0xb2, 0xa4, 0xc3, 0xa3, 0x47, 0x94, 0x95, 0x1b);

DEFINE_GUID(IID_ISimpleSink,
0x50a3b39a, 0x5b2c, 0x4684, 0xae, 0x9d, 0x6c, 0x5a, 0x77, 0x96, 0x88, 0xb6);

DECLARE_INTERFACE_(ISimpleSink,IUnknown)
{
    STDMETHOD_(ULONG,setSegmentSize) (ULONG ulSegmentSize) PURE;
    STDMETHOD(setDiskFreeArea) (LONGLONG lMinFreeSize) PURE;
    STDMETHOD_(ULONG,getSegmentSize) (void) PURE;
    STDMETHOD(getSegmentList) (void** pSegmentList) PURE;   //!!BS: slightly modified ;-)
    STDMETHOD(writeReferenceFile) (LPCTSTR pszFileName, REFERENCE_TIME rtRecStart, REFERENCE_TIME rtRecStop) PURE;
    STDMETHOD(setMessageHandler) (DWORD dwThreadId) PURE;
    STDMETHOD(createSegmentList) (void** pSegList) PURE;    //!!BS: slightly modified ;-)

    STDMETHOD(setMaxFileSize)  (THIS_ __int64 size, DWORD event) PURE;
    STDMETHOD(getCurrentFileSize)  (THIS_ __int64 *size) PURE;
};

// ----------------------------------------------------------------------------

// --------------------------------------------------------------------------
// DeMultiplexer
// --------------------------------------------------------------------------
DEFINE_GUID(CLSID_PCLE_DEMUX2, 
0xad119551, 0xe651, 0x4587, 0x82, 0x3e, 0xb0, 0xac, 0x99, 0x79, 0x84, 0xad);

DEFINE_GUID(IID_IPCLECommands, 
0xd9fb2240, 0x687a, 0x11d4, 0xbf, 0xb1, 0x0, 0x10, 0x5a, 0xa8, 0x5, 0xc4);

typedef enum 
{
    Cmd_GetVersion,
    Cmd_SetGrabFrame,
    Cmd_GetGrabFrame, 
    Cmd_EnableAdvancedFeatures,
    // Enable additional output pins.
    // Parameter:
    //       lparam1: BOOL bEnable
    //       lparam2: -
    //       pllparam3: -
    Cmd_GetPosition,
    // Set available seek range (needed for timeshift).
    // Parameter:
    //       lparam1: -
    //       lparam2: -
    //       pllparam3:  struct { LONGLONG llTimeStart, llTimeEnd; }
    Cmd_SetAvailable,
    // Set first available input file offset 
    // Parameter:
    //       pllparam3:  LONGLONG offset
    Cmd_SetFileStart,
    Cmd_SetSCRCorrection,
    Cmd_DebugOut,
    Cmd_GetPTSLateness,
    Cmd_SetNotifyThreadId,
    Cmd_TSSelectServiceType,
    Cmd_TSResetProgramInfo,
    Cmd_TSEnableTSOutput,
    Cmd_TSEnableMpegPSOutput,
    Cmd_GetOutputQueueLevels,
    Cmd_EnableGOPTimeFixNTSC,
    Cmd_SetDefaultAudioSampleFrequency,
    Cmd_GetDefaultAudioSampleFrequency,
} ECommand;

DECLARE_INTERFACE_(IPCLECommands, IUnknown)
{
   STDMETHOD(Command)  (ECommand cmd, LPARAM lParam1, LPARAM lParam2, LONGLONG* param3) PURE;     
};
// --------------------------------------------------------------------------


#endif