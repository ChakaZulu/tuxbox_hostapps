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
 
#include <windows.h>
#include <commdlg.h>
#include <streams.h>
#include <initguid.h>
#include "interface.h"
#include "AudioRawFileRenderer.h"
#include "debug.h"


// Setup data

const AMOVIESETUP_MEDIATYPE sudPinTypes =
{
    &MEDIATYPE_NULL,            // Major type
    &MEDIASUBTYPE_NULL          // Minor type
};

const AMOVIESETUP_PIN sudPins =
{
    L"Input",                   // Pin string name
    FALSE,                      // Is it rendered
    FALSE,                      // Is it an output
    FALSE,                      // Allowed none
    FALSE,                      // Likewise many
    &CLSID_NULL,                // Connects to filter
    L"Output",                  // Connects to pin
    1,                          // Number of types
    &sudPinTypes                // Pin information
};

const AMOVIESETUP_FILTER sudFilter =
{
    &CLSID_DBOXIIAudioRawFileRenderer,                // Filter CLSID
    L"DBOXII AudioRawFileRenderer",                    // String name
    MERIT_DO_NOT_USE,           // Filter merit
    1,                          // Number pins
    &sudPins                    // Pin details
};


//
// DllRegisterSever
//
// Handle the registration of this filter
//
STDAPI DllRegisterServer()
{
    return AMovieDllRegisterServer2( TRUE );

} // DllRegisterServer


//
// DllUnregisterServer
//
STDAPI DllUnregisterServer()
{
    return AMovieDllRegisterServer2( FALSE );

} // DllUnregisterServer


//
//  Object creation stuff
//
CFactoryTemplate g_Templates[]= {
    L"DBOXII AudioRawFileRenderer", &CLSID_DBOXIIAudioRawFileRenderer, CAudioRawFileRenderer::CreateInstance, NULL, &sudFilter
};
int g_cTemplates = 1;


// Constructor

CAudioRawFileRendererFilter::CAudioRawFileRendererFilter(CAudioRawFileRenderer *pFilter,
                         LPUNKNOWN pUnk,
                         CCritSec *pLock,
                         HRESULT *phr) :
    CBaseFilter(NAME("CAudioRawFileRendererFilter"), pUnk, pLock, CLSID_DBOXIIAudioRawFileRenderer),
    m_pAudioRawFileRenderer(pFilter)
{
}


//
// GetPin
//
CBasePin * CAudioRawFileRendererFilter::GetPin(int n)
{
    if (n == 0) 
        {
        return m_pAudioRawFileRenderer->m_pPin;
        } 
    else 
        {
        return NULL;
        }
}


//
// GetPinCount
//
int CAudioRawFileRendererFilter::GetPinCount()
{
    return 1;
}


//
// Stop
//
// Overriden to close the file
//
STDMETHODIMP CAudioRawFileRendererFilter::Stop()
{
    CAutoLock cObjectLock(m_pLock);
    m_pAudioRawFileRenderer->CloseFile();
    return CBaseFilter::Stop();
}


//
// Pause
//
// Overriden to open the file
//
STDMETHODIMP CAudioRawFileRendererFilter::Pause()
{
    CAutoLock cObjectLock(m_pLock);
    m_pAudioRawFileRenderer->OpenFile();
    return CBaseFilter::Pause();
}


//
// Run
//
// Overriden to open the file
//
STDMETHODIMP CAudioRawFileRendererFilter::Run(REFERENCE_TIME tStart)
{
    CAutoLock cObjectLock(m_pLock);
    m_pAudioRawFileRenderer->OpenFile();
    return CBaseFilter::Run(tStart);
}


//
//  Definition of CAudioRawFileRendererInputPin
//
CAudioRawFileRendererInputPin::CAudioRawFileRendererInputPin(CAudioRawFileRenderer *pCFilter,
                             LPUNKNOWN pUnk,
                             CBaseFilter *pFilter,
                             CCritSec *pLock,
                             CCritSec *pReceiveLock,
                             HRESULT *phr) :

    CRenderedInputPin(NAME("CAudioRawFileRendererInputPin"),
                  pFilter,                   // Filter
                  pLock,                     // Locking
                  phr,                       // Return code
                  L"Input"),                 // Pin name
    m_pReceiveLock(pReceiveLock),
    m_pAudioRawFileRenderer(pCFilter)
{
    m_reftimeStart=-1;
    m_reftimeEnd  =-1;
}


//
// CheckMediaType
//
// Check if the pin can support this specific proposed type and format
//
HRESULT CAudioRawFileRendererInputPin::CheckMediaType(const CMediaType *)
{
    return S_OK;
}


//
// BreakConnect
//
// Break a connection
//
HRESULT CAudioRawFileRendererInputPin::BreakConnect()
{
    if (m_pAudioRawFileRenderer->m_pPosition != NULL) {
        m_pAudioRawFileRenderer->m_pPosition->ForceRefresh();
    }
    return CRenderedInputPin::BreakConnect();
}


//
// ReceiveCanBlock
//
// We don't hold up source threads on Receive
//
STDMETHODIMP CAudioRawFileRendererInputPin::ReceiveCanBlock()
{
    return S_FALSE;
}


//
// Receive
//
// Do something with this media sample
//
STDMETHODIMP CAudioRawFileRendererInputPin::Receive(IMediaSample *pSample)
{
    CAutoLock lock(m_pReceiveLock);
    PBYTE pbData;
    HRESULT hr=NOERROR;

    // Has the filter been stopped yet
    if (m_pAudioRawFileRenderer->m_hFile == INVALID_HANDLE_VALUE) 
        {
        return NOERROR;
        }


    REFERENCE_TIME tStart, tStop;
    hr=pSample->GetTime(&tStart, &tStop);
    if (m_reftimeStart<0)
        {
        if (SUCCEEDED(hr))
            m_reftimeStart=tStart;
        else
            {
            m_reftimeStart=0;
            m_reftimeEnd=0;
            }
        }

    if (SUCCEEDED(hr))
        m_reftimeEnd=tStop;

    // Copy the data to the file

    hr = pSample->GetPointer(&pbData);
    if (FAILED(hr)) 
        {
        return hr;
        }
    
    if (m_pAudioRawFileRenderer->m_CurrentFileSize>0)
        hr=m_pAudioRawFileRenderer->Write(pbData, pSample->GetActualDataLength());
    else
        {
        //!!BS: ok, this is the very first chunk of audio data we receive, so lets
        //!!BS: try to sychronize with a header marker
        long len=pSample->GetActualDataLength();
        int i=0;
        for(i=0;i<len-1;i++)
            {
            if (pbData[i]==0xFF)
                if ((pbData[i+1]&0xF0)==0xF0)
                    {
                    pbData+=i;
                    len-=i;
                    hr=m_pAudioRawFileRenderer->Write(pbData, len);
                    break;
                    }
            }
        //!!BS: if we bail out here somesthing was wrong (no header was found), but keep
        //!!BS: on smiling and wait for the next chunk of data ...
        hr=NOERROR;
        }

    if (pSample->IsDiscontinuity()==S_OK)
        {
        dprintf("Discontinuity detected");
        m_pAudioRawFileRenderer->m_IsDiscontinuity=TRUE;
        m_pAudioRawFileRenderer->setParameter(CMD_SPLITEVENT, 0, 0, 0);
        m_pAudioRawFileRenderer->m_IsDiscontinuity=FALSE;
        }

    return(hr);
}



//
// EndOfStream
//
STDMETHODIMP CAudioRawFileRendererInputPin::EndOfStream(void)
{
    CAutoLock lock(m_pReceiveLock);
    return CRenderedInputPin::EndOfStream();

} // EndOfStream


//
// NewSegment
//
// Called when we are seeked
//
STDMETHODIMP CAudioRawFileRendererInputPin::NewSegment(REFERENCE_TIME tStart,
                                       REFERENCE_TIME tStop,
                                       double dRate)
{
    m_reftimeStart=-1;
    m_reftimeEnd  =-1;
    return S_OK;

} // NewSegment


//
//  CAudioRawFileRenderer class
//
CAudioRawFileRenderer::CAudioRawFileRenderer(LPUNKNOWN pUnk, HRESULT *phr) :
    CUnknown(NAME("CAudioRawFileRenderer"), pUnk),
    m_pFilter(NULL),
    m_pPin(NULL),
    m_pPosition(NULL),
    m_hFile(INVALID_HANDLE_VALUE),
    m_pFileName(0)
{
    m_pFilter = new CAudioRawFileRendererFilter(this, GetOwner(), &m_Lock, phr);
    if (m_pFilter == NULL) 
        {
        *phr = E_OUTOFMEMORY;
        return;
        }

    m_pPin = new CAudioRawFileRendererInputPin(this,GetOwner(),
                               m_pFilter,
                               &m_Lock,
                               &m_ReceiveLock,
                               phr);
    if (m_pPin == NULL) 
        {
        *phr = E_OUTOFMEMORY;
        return;
        }

    ZeroMemory(&m_OldID3, sizeof(struct ID3));
    ZeroMemory(&m_pOldFileName, sizeof(m_pOldFileName));
    m_SplitMode=OPT_SPLIT_EVENT;
    m_IsDiscontinuity=FALSE;
}


//
// SetFileName
//
// Implemented for IFileSinkFilter support
//
STDMETHODIMP CAudioRawFileRenderer::SetFileName(LPCOLESTR pszFileName,const AM_MEDIA_TYPE *pmt)
{
    // Is this a valid filename supplied

    CheckPointer(pszFileName,E_POINTER);
    if(wcslen(pszFileName) > MAX_PATH)
        return ERROR_FILENAME_EXCED_RANGE;

    // Take a copy of the filename

//    m_pFileName = new WCHAR[1+lstrlenW(pszFileName)];
    m_pFileName = new WCHAR[264];
    if (m_pFileName == 0)
        return E_OUTOFMEMORY;
    lstrcpyW(m_pFileName,pszFileName);

    // Create the file then close it

    HRESULT hr = OpenFile();
    CloseFile();
    return hr;

} // SetFileName


//
// GetCurFile
//
// Implemented for IFileSinkFilter support
//
STDMETHODIMP CAudioRawFileRenderer::GetCurFile(LPOLESTR * ppszFileName,AM_MEDIA_TYPE *pmt)
{
    CheckPointer(ppszFileName, E_POINTER);
    *ppszFileName = NULL;
    if (m_pFileName != NULL) 
        {
        *ppszFileName = (LPOLESTR)QzTaskMemAlloc(sizeof(WCHAR) * (1+lstrlenW(m_pFileName)));
        if (*ppszFileName != NULL) 
            {
            lstrcpyW(*ppszFileName, m_pFileName);
            }
        }

    if(pmt) 
        {
        ZeroMemory(pmt, sizeof(*pmt));
        pmt->majortype = MEDIATYPE_NULL;
        pmt->subtype = MEDIASUBTYPE_NULL;
        }
    
    m_TimeFormat=TIME_FORMAT_MEDIA_TIME;

    return S_OK;

} // GetCurFile


// Destructor

CAudioRawFileRenderer::~CAudioRawFileRenderer()
{
    CloseFile();
    delete m_pPin;
    delete m_pFilter;
    delete m_pPosition;
    delete m_pFileName;
}


//
// CreateInstance
//
// Provide the way for COM to create a filter
//
CUnknown * WINAPI CAudioRawFileRenderer::CreateInstance(LPUNKNOWN punk, HRESULT *phr)
{
    CAudioRawFileRenderer *pNewObject = new CAudioRawFileRenderer(punk, phr);
    if (pNewObject == NULL) 
        {
        *phr = E_OUTOFMEMORY;
        }
    return pNewObject;

} // CreateInstance


//
// NonDelegatingQueryInterface
//
// Override this to say what interfaces we support where
//
STDMETHODIMP CAudioRawFileRenderer::NonDelegatingQueryInterface(REFIID riid, void ** ppv)
{
    CheckPointer(ppv,E_POINTER);
    CAutoLock lock(&m_Lock);


	CheckPointer(ppv,E_POINTER);
	
    if (riid == IID_IFileSinkFilter) 
        {
        return GetInterface((IFileSinkFilter *) this, ppv);
        }
    else 
    if (riid == IID_IBaseFilter || riid == IID_IMediaFilter || riid == IID_IPersist) 
        {
	    return m_pFilter->NonDelegatingQueryInterface(riid, ppv);
        }
    else 
    if (riid == IID_IMediaSeeking) 
        {
        return GetInterface((IMediaSeeking *) this, ppv);
        }
    if (riid == IID_IDBOXIIAudioRawFileRenderer) 
        {
        return GetInterface((IDBOXIIAudioRawFileRenderer *) this, ppv);
        }

    return CUnknown::NonDelegatingQueryInterface(riid, ppv);

} // NonDelegatingQueryInterface


//
// OpenFile
//
// Opens the file ready for writing
//
HRESULT CAudioRawFileRenderer::OpenFile()
{
    TCHAR *pFileName = NULL;

    // Is the file already opened
    if (m_hFile != INVALID_HANDLE_VALUE) 
        {
        return NOERROR;
        }

    // Has a filename been set yet
    if (m_pFileName == NULL) 
        {
        return ERROR_INVALID_NAME;
        }

    // Convert the UNICODE filename if necessary

#if defined(WIN32) && !defined(UNICODE)
    char convert[MAX_PATH];
    if(!WideCharToMultiByte(CP_ACP,0,m_pFileName,-1,convert,MAX_PATH,0,0))
        return ERROR_INVALID_NAME;
    pFileName = convert;
#else
    pFileName = m_pFileName;
#endif

    // Try to open the file

    m_hFile = CreateFile((LPCTSTR) pFileName,   // The filename
                         GENERIC_WRITE,         // File access
                         
                         (DWORD) 0,             // Share access   
                         //FILE_SHARE_READ|FILE_SHARE_WRITE,             // Share access
                         
                         NULL,                  // Security
                         CREATE_ALWAYS,         // Open flags
                         (DWORD) 0,             // More flags
                         NULL);                 // Template

    if (m_hFile == INVALID_HANDLE_VALUE) 
        {
        DWORD dwErr = GetLastError();
        return HRESULT_FROM_WIN32(dwErr);
        }

    m_CurrentFileSize=0;

    return S_OK;

} // Open

//
// Write
//
// Write stuff to the file
//
HRESULT CAudioRawFileRenderer::Write(PBYTE pbData,LONG lData)
{
    DWORD dwWritten=0;

    if (!WriteFile(m_hFile,(PVOID)pbData,(DWORD)lData,&dwWritten,NULL)) 
        {
        DWORD dwErr = GetLastError();
        return HRESULT_FROM_WIN32(dwErr);
        }

    m_CurrentFileSize+=dwWritten;

    return S_OK;
}

//
// CloseFile
//
// Closes any file we have opened
//
HRESULT CAudioRawFileRenderer::CloseFile()
{
    if (m_hFile == INVALID_HANDLE_VALUE) 
        {
        return NOERROR;
        }

    CloseHandle(m_hFile);
    m_hFile = INVALID_HANDLE_VALUE;
    return NOERROR;

} // Open


// ----------------------------------------------------------------------------
// IMediaSeeking implementation

HRESULT CAudioRawFileRenderer::GetCapabilities(unsigned long *cap)
{
	dprintf("GetCapabilities"); 
	*cap=AM_SEEKING_CanGetCurrentPos;
	return(S_OK);  
}


HRESULT CAudioRawFileRenderer::CheckCapabilities(unsigned long *cap)
{
	dprintf("CheckCapabilities"); 
	if (*cap==AM_SEEKING_CanGetCurrentPos)
		return(S_OK);  
	return(S_FALSE);  
}


HRESULT CAudioRawFileRenderer::IsFormatSupported(const struct _GUID *fmt)
{
	dprintf("IsFormatSupported"); 

	if (IsEqualGUID(*fmt,TIME_FORMAT_MEDIA_TIME))
		return(S_OK);
	if (IsEqualGUID(*fmt,TIME_FORMAT_BYTE))
		return(S_OK);

	return(S_FALSE);  
}


HRESULT CAudioRawFileRenderer::QueryPreferredFormat(struct _GUID *fmt)
{
	*fmt=TIME_FORMAT_MEDIA_TIME;
	return(S_OK);  
}


HRESULT CAudioRawFileRenderer::GetTimeFormatA(struct _GUID *fmt)
{
	*fmt=m_TimeFormat;
	return(S_OK);  
}


HRESULT CAudioRawFileRenderer::IsUsingTimeFormat(const struct _GUID *fmt)
{
	if (IsEqualGUID(*fmt,m_TimeFormat))
		return(S_OK);
	return(S_FALSE);  
}


HRESULT CAudioRawFileRenderer::SetTimeFormat(const struct _GUID *fmt)
{
	if (IsEqualGUID(*fmt,TIME_FORMAT_MEDIA_TIME))
        {
        m_TimeFormat=TIME_FORMAT_MEDIA_TIME;
		return(S_OK);
        }
    else
	if (IsEqualGUID(*fmt,TIME_FORMAT_BYTE))
        {
        m_TimeFormat=TIME_FORMAT_BYTE;
		return(S_OK);
        }
	return(S_FALSE);  
}


HRESULT CAudioRawFileRenderer::GetDuration(__int64 *duration)
{
    if (m_TimeFormat==TIME_FORMAT_BYTE)
        {
        return(getCurrentFileSize(duration));
        }
    else
    if (m_TimeFormat==TIME_FORMAT_MEDIA_TIME)
        {
        *duration = m_pPin->m_reftimeEnd - m_pPin->m_reftimeStart;      
	    return(S_OK);  
        }
    return(E_FAIL);
}


HRESULT CAudioRawFileRenderer::GetStopPosition(__int64 *pos)
{
    if (m_TimeFormat==TIME_FORMAT_BYTE)
        {
        return(getCurrentFileSize(pos));
        }
	*pos=m_pPin->m_reftimeEnd;
	return(S_OK);  
}


HRESULT CAudioRawFileRenderer::GetCurrentPosition(__int64 *pos)
{
	dprintf("GetCurrentPosition"); 
    if (m_TimeFormat==TIME_FORMAT_BYTE)
        {
        return(getCurrentFileSize(pos));
        }
    if (m_TimeFormat==TIME_FORMAT_MEDIA_TIME)
        {
	    *pos=m_pPin->m_reftimeEnd;
	    return(S_OK);
        }
    return(E_FAIL);
}


HRESULT CAudioRawFileRenderer::ConvertTimeFormat(__int64 *,const struct _GUID *,__int64,const struct _GUID *)
{
	return(E_NOTIMPL);  
}


HRESULT CAudioRawFileRenderer::SetPositions(__int64 *,unsigned long,__int64 *,unsigned long)
{
	return(E_NOTIMPL);  
}


HRESULT CAudioRawFileRenderer::GetPositions(__int64 *cur,__int64 *stop)
{
    if (m_TimeFormat==TIME_FORMAT_BYTE)
        {
        __int64 val=0;
        HRESULT hr=getCurrentFileSize(&val);
        *cur=val;
        *stop=val;
        return(hr);
        }

	*cur=m_pPin->m_reftimeEnd;
	*stop=m_pPin->m_reftimeEnd;
	dprintf("GetPositions"); 
	return(S_OK);  
}


HRESULT CAudioRawFileRenderer::GetAvailable(__int64 *etime,__int64 *ltime)
{
	*etime=0;
	*ltime=0;
	return(S_OK);  
}


HRESULT CAudioRawFileRenderer::SetRate(double)
{
	return(S_OK);  
}


HRESULT CAudioRawFileRenderer::GetRate(double *rate)
{
	*rate=1;
	return(S_OK);  
}


HRESULT CAudioRawFileRenderer::GetPreroll(__int64 *pre)
{
	*pre=0;
	return(S_OK);  
}

HRESULT CAudioRawFileRenderer::getCurrentFileSize(__int64 *size)
{
    if (!size)
        return(E_POINTER);
    *size = m_CurrentFileSize;
    return(NOERROR);
}

STDMETHODIMP CAudioRawFileRenderer::setParameter(__int64 command, __int64  data1, __int64  data2, __int64 data3)
{
    CAutoLock lock(&m_ReceiveLock);
    
    HRESULT hr=NOERROR;

    switch(command)
        {
        case CMD_SPLITEVENT:
        if ( 
            ((m_SplitMode==OPT_SPLIT_DISCONTINUITY)&&m_IsDiscontinuity) ||
             (m_SplitMode==OPT_SPLIT_EVENT)
           )
            {
            CloseFile();
            dprintf("SplitEvent");
            if (lstrlenW(m_pOldFileName)>0)
                {
                char str[264]="";
                char strOld[264]="";
                DWORD dwWritten=0;
                DWORD result=0;
                HANDLE hFile=INVALID_HANDLE_VALUE;

		        WideCharToMultiByte(CP_ACP, 0, m_pFileName   , -1, str   , 264, NULL, NULL);
		        WideCharToMultiByte(CP_ACP, 0, m_pOldFileName, -1, strOld, 264, NULL, NULL);
                MoveFile(str, strOld);

                hFile = CreateFile( strOld,   // The filename
                                    GENERIC_WRITE,         // File access
                                    (DWORD) 0,             // Share access
                                    NULL,                  // Security
                                    OPEN_EXISTING,         // Open flags
                                    FILE_ATTRIBUTE_NORMAL,             // More flags
                                    NULL);                 // Template
                if (INVALID_HANDLE_VALUE!=hFile)
                    {
                    result=SetFilePointer(hFile, 0, NULL, FILE_END); 
                    LockFile(hFile, result, 0, result + sizeof(m_OldID3), 0); 
                    result=WriteFile(hFile,(PVOID)&m_OldID3,(DWORD)sizeof(m_OldID3),&dwWritten,NULL);
                    UnlockFile(hFile, result, 0, result + sizeof(m_OldID3), 0); 
                    CloseHandle(hFile);
                    }
                
                }
            OpenFile();
            }
            break;

        case CMD_SPLITDATA:
            {
            dprintf("SplitData");
            lstrcpyW(m_pOldFileName, (WCHAR *)data2);
            CopyMemory(&m_OldID3, (struct ID3 *)data1, sizeof(struct ID3));
            }
            break;
        
        case CMD_SPLITMODE:
            m_SplitMode=(int)data1;
            break;

        default:
            hr=E_NOTIMPL;
            break;
        }
    return(hr);
}

STDMETHODIMP CAudioRawFileRenderer::getParameter(__int64 command, __int64 *data1, __int64 *data2)
{
    HRESULT hr=E_NOTIMPL;
    return(hr);
}
