//
//  DBOXII Audio RawFileRenderer
//  
//  Rev.0.0 Bernd Scharping 
//  bernd@transputer.escape.de
//
/*
* This program is free software; you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by 
* the Free Software Foundation; either version 2, or (at your option)
* any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program; see the file COPYING.  If not, write to
* the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
*/

struct ID3{
	char tag[3];
	char songname[30];
	char artist[30];
	char album[30];
	char year[4];
	char comment[28];
	unsigned char empty;
	unsigned char tracknum;
	unsigned char genre;
};

class CAudioRawFileRendererInputPin;
class CAudioRawFileRenderer;
class CAudioRawFileRendererFilter;


// Main filter object

class CAudioRawFileRendererFilter : public CBaseFilter
                                    
{
    CAudioRawFileRenderer * const m_pAudioRawFileRenderer;

public:

    // Constructor
    CAudioRawFileRendererFilter(CAudioRawFileRenderer *pDump,
                LPUNKNOWN pUnk,
                CCritSec *pLock,
                HRESULT *phr);

    // Pin enumeration
    CBasePin * GetPin(int n);
    int GetPinCount();

    // Open and close the file as necessary
    STDMETHODIMP Run(REFERENCE_TIME tStart);
    STDMETHODIMP Pause();
    STDMETHODIMP Stop();
};


//  Pin object

class CAudioRawFileRendererInputPin : public CRenderedInputPin
{
    CAudioRawFileRenderer    * const m_pAudioRawFileRenderer;           // Main renderer object
    CCritSec * const m_pReceiveLock;    // Sample critical section
public:

    CAudioRawFileRendererInputPin(CAudioRawFileRenderer *pDump,
                  LPUNKNOWN pUnk,
                  CBaseFilter *pFilter,
                  CCritSec *pLock,
                  CCritSec *pReceiveLock,
                  HRESULT *phr);

    // Do something with this media sample
    STDMETHODIMP Receive(IMediaSample *pSample);
    STDMETHODIMP EndOfStream(void);
    STDMETHODIMP ReceiveCanBlock();

    // Check if the pin can support this specific proposed type and format
    HRESULT CheckMediaType(const CMediaType *);

    // Break connection
    HRESULT BreakConnect();

    // Track NewSegment
    STDMETHODIMP NewSegment(REFERENCE_TIME tStart,
                            REFERENCE_TIME tStop,
                            double dRate);

    REFERENCE_TIME m_reftimeStart;
    REFERENCE_TIME m_reftimeEnd;

};


//  CAudioRawFileRenderer object which has filter and pin members

class CAudioRawFileRenderer : public CUnknown, 
                              public IFileSinkFilter,
                              public IMediaSeeking,
                              public IDBOXIIAudioRawFileRenderer
{
    friend class CAudioRawFileRendererFilter;
    friend class CAudioRawFileRendererInputPin;

    CAudioRawFileRendererFilter *m_pFilter;         // Methods for filter interfaces
    CAudioRawFileRendererInputPin *m_pPin;          // A simple rendered input pin
    CCritSec m_Lock;                // Main renderer critical section
    CCritSec m_ReceiveLock;         // Sublock for received samples
    CPosPassThru *m_pPosition;      // Renderer position controls
    HANDLE m_hFile;                 // Handle to file for dumping
    LPOLESTR m_pFileName;           // The filename where we dump to
    WCHAR    m_pOldFileName[264];
    ID3      m_OldID3;
public:
    DECLARE_IUNKNOWN

    CAudioRawFileRenderer(LPUNKNOWN pUnk, HRESULT *phr);
    ~CAudioRawFileRenderer();

    static CUnknown * WINAPI CreateInstance(LPUNKNOWN punk, HRESULT *phr);

    //Write data streams to a file
    HRESULT Write(PBYTE pbData,LONG lData);

    //IFileSinkFilter
    STDMETHODIMP SetFileName(LPCOLESTR pszFileName,const AM_MEDIA_TYPE *pmt);
    STDMETHODIMP GetCurFile(LPOLESTR * ppszFileName,AM_MEDIA_TYPE *pmt);

    //IMediaSeeking
	STDMETHODIMP GetCapabilities(unsigned long *);
	STDMETHODIMP CheckCapabilities(unsigned long *);
	STDMETHODIMP IsFormatSupported(const struct _GUID *);
	STDMETHODIMP QueryPreferredFormat(struct _GUID *);
	STDMETHODIMP GetTimeFormatA(struct _GUID *);
	STDMETHODIMP IsUsingTimeFormat(const struct _GUID *);
	STDMETHODIMP SetTimeFormat(const struct _GUID *);
	STDMETHODIMP GetDuration(__int64 *);
	STDMETHODIMP GetStopPosition(__int64 *);
	STDMETHODIMP GetCurrentPosition(__int64 *);
	STDMETHODIMP ConvertTimeFormat(__int64 *,const struct _GUID *,__int64,const struct _GUID *);
	STDMETHODIMP SetPositions(__int64 *,unsigned long,__int64 *,unsigned long);
	STDMETHODIMP GetPositions(__int64 *,__int64 *);
	STDMETHODIMP GetAvailable(__int64 *,__int64 *);
	STDMETHODIMP SetRate(double);
	STDMETHODIMP GetRate(double *);
	STDMETHODIMP GetPreroll(__int64 *);

    HRESULT      getCurrentFileSize(__int64 *size);


    STDMETHODIMP setParameter(__int64 command, __int64  data1, __int64  data2, __int64 data3);
    STDMETHODIMP getParameter(__int64 command, __int64 *data1, __int64 *data2);

    int          m_SplitMode;
    int          m_IsDiscontinuity;

private:

    // Overriden to say what interfaces we support where
    STDMETHODIMP NonDelegatingQueryInterface(REFIID riid, void ** ppv);

    // Open and write to the file
    HRESULT OpenFile();
    HRESULT CloseFile();

    struct  _GUID m_TimeFormat;
    __int64       m_CurrentFileSize;
};

