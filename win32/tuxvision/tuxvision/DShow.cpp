//
//  TuxVision
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
#include <streams.h>
#include <strmif.h>

#include "guids.h"
#include "AX_Helper.h"
#include "Dshow.h"
#include "TuxVision.h"
#include "..\\capture\\interface.h"
#include "..\\render\\interface.h"
#include "debug.h"

#define MAX_DEVICES  64
IGraphBuilder        *gpIGraphBuilder       =NULL;
ICaptureGraphBuilder *gpICaptureGraphBuilder=NULL;
IBaseFilter          *gpVCap                =NULL;
TCHAR                gszCaptureFilterName[264];

//---------------------------------------------------------
//
//---------------------------------------------------------
void DebugFreeMediaType(AM_MEDIA_TYPE& mt)
{
    if (mt.cbFormat != 0) 
        {
        CoTaskMemFree((PVOID)mt.pbFormat);
        // Strictly unnecessary but tidier
        mt.cbFormat = 0;
        mt.pbFormat = NULL;
        }
    if (mt.pUnk != NULL) 
        {
        mt.pUnk->Release();
        mt.pUnk = NULL;
        }
}
//---------------------------------------------------------
//
//---------------------------------------------------------
void DumpFilterGraph(IFilterGraph *pGraph)
{
    IEnumFilters *pFilters=NULL;

    //return; //!!BS: debugging only

    dprintf(TEXT("DumpGraph [%x]"), pGraph);

    if (FAILED(pGraph->EnumFilters(&pFilters))) 
		{
		dprintf(TEXT("EnumFilters failed!"));
		}

    IBaseFilter *pFilter=NULL;
    ULONG	n=0;
    while (pFilters->Next(1, &pFilter, &n) == S_OK) 
		{
		FILTER_INFO	info;

		if (FAILED(pFilter->QueryFilterInfo(&info))) 
			{
			dprintf(TEXT("    Filter [%x]  -- failed QueryFilterInfo"), pFilter);
			} 
		else 
			{
			QueryFilterInfoReleaseGraph(info);

			// !!! should QueryVendorInfo here!
		
			dprintf(TEXT("    Filter [%x]  '%ls'"), pFilter, info.achName);

			IEnumPins *pins=NULL;

			if (FAILED(pFilter->EnumPins(&pins))) 
				{
				dprintf(TEXT("EnumPins failed!"));
				} 
			else 
				{
				IPin *pPin=NULL;
				while (pins->Next(1, &pPin, &n) == S_OK) 
					{
					PIN_INFO	info;
					if (FAILED(pPin->QueryPinInfo(&info))) 
						{
						dprintf(TEXT("          Pin [%x]  -- failed QueryPinInfo"), pPin);
						} 
					else 
						{
						QueryPinInfoReleaseFilter(info);
						IPin *pPinConnected = NULL;
						HRESULT hr = pPin->ConnectedTo(&pPinConnected);
						if (pPinConnected) 
							{
							dprintf(TEXT("          Pin [%x]  '%ls' [%sput]") TEXT("  Connected to pin [%x]"),	pPin, info.achName,	info.dir == PINDIR_INPUT ? TEXT("In") : TEXT("Out"), pPinConnected);
							// perhaps we should really dump the type both ways as a sanity
							// check?
							if (info.dir == PINDIR_OUTPUT) 
								{
								AM_MEDIA_TYPE mt;
								hr = pPin->ConnectionMediaType(&mt);
								if (SUCCEEDED(hr)) 
									{
									//DebugDisplayMediaType("Connection type", &mt);
									DebugFreeMediaType(mt);
									}
								}
							} 
						else 
							{
							dprintf(TEXT("          Pin [%x]  '%ls' [%sput]"), pPin, info.achName, info.dir == PINDIR_INPUT ? TEXT("In") : TEXT("Out"));
							}
                        if (pPinConnected!=NULL)
                            {
						    pPinConnected->Release();
                            pPinConnected=NULL;
                            }
						}
					if (pPin!=NULL)
                        {
                        pPin->Release();
                        pPin=NULL;
                        }
					}
                if (pins!=NULL)
                    {
    				pins->Release();
                    pins=NULL;
                    }
				}
			}
        if (pFilter!=NULL)
		    {
            pFilter->Release();
            pFilter=NULL;
            }
		}
        if (pFilters!=NULL)
            {
    		pFilters->Release();
            pFilters=NULL;
            }

}

HRESULT AddCaptureFilterToGraph(IGraphBuilder *pIGB, IBaseFilter *pCap, TCHAR *name)
{
    HRESULT hr=NOERROR;
    if ((pCap!=NULL)&&(pIGB!=NULL))
        {
        WCHAR wszSrcFileName[264];
        memset(wszSrcFileName,0,264*sizeof(WCHAR));
        MultiByteToWideChar(CP_ACP, 
                            0, 
                            name, 
                            lstrlen(name),
                            wszSrcFileName,  
                            264);

        hr = pIGB->AddFilter(pCap, wszSrcFileName);
        return(hr);
        }
    return(E_FAIL);
}

// enumerate all needed  devices 
//
HRESULT EnumerateDevices(char *videodriver[], 
                              int *vcount, 
                              IGraphBuilder *pIGB, 
                              ICaptureGraphBuilder *pICGB, 
                              int devicenumber ,
                              IBaseFilter **pCap,
                              BOOL isVideo)
{
    ICreateDevEnum *pCreateDevEnum=NULL;
    IEnumMoniker *pEm= NULL;
    IMoniker *pM     = NULL;
    UINT     uIndex  = 0;
    HRESULT  hr      = NOERROR;
    int      cc      = 0;

	int oldv=0x7FFFFFFF;

    if (vcount!=NULL)
        {
        oldv=*vcount;
    	*vcount=-1;
        }

//    for(cc=0;cc<2;cc++)
    for(cc=1;cc<2;cc++)
        {
        hr = CoCreateInstance(CLSID_SystemDeviceEnum, NULL, CLSCTX_INPROC_SERVER, IID_ICreateDevEnum, (void**)&pCreateDevEnum);
        if (SUCCEEDED(hr))
            {
            if (cc==0)
                hr = pCreateDevEnum->CreateClassEnumerator(AM_KSCATEGORY_CAPTURE/*AM_KSCATEGORY_VIDEO*/,	&pEm, 0);
            else
                {
                if (isVideo)
                    hr = pCreateDevEnum->CreateClassEnumerator(CLSID_VideoInputDeviceCategory,	&pEm, 0);
                else
                    hr = pCreateDevEnum->CreateClassEnumerator(CLSID_AudioInputDeviceCategory,	&pEm, 0);
                }

            pCreateDevEnum->Release();
            if (SUCCEEDED(hr)&&(pEm!=NULL)) 
                {
                pEm->Reset();
                ULONG cFetched=0;
                while( (hr = pEm->Next(1, &pM, &cFetched), hr==S_OK) )
                    {
	                IPropertyBag *pBag=NULL;
	                hr = pM->BindToStorage(0, 0, IID_IPropertyBag, (void **)&pBag);
	                if(SUCCEEDED(hr)) 
                        {
	                    VARIANT var;
	                    var.vt = VT_BSTR;
	                    hr = pBag->Read(L"FriendlyName", &var, NULL);
	                    if ( (hr == NOERROR) && (videodriver!=NULL) && (vcount!=NULL) )
                            {
		                    char achName[80];
		                    WideCharToMultiByte(CP_ACP, 0, var.bstrVal, -1, achName, 80, NULL, NULL);
		                    *vcount=(*vcount)+1;
                            #if 0
                            if (cc==0)
                                lstrcpy(videodriver[*vcount],"(WDM)");
                            else
                                lstrcpy(videodriver[*vcount],"(VfW)");
                            #else
                            lstrcpy(videodriver[*vcount],"");
                            #endif        
                            lstrcat(videodriver[*vcount],achName);
		                    SysFreeString(var.bstrVal);
	                        }
	                    pBag->Release();
                        if (vcount!=NULL)
                            {
                            if ((pCap!=NULL)&&(devicenumber==*vcount))
                                hr = pM->BindToObject(0, 0, IID_IBaseFilter, (void**)pCap);
                            }
    	                }
	                pM->Release();
	                uIndex++;
                    if (vcount!=NULL)
                        {
	                    if (*vcount>=oldv)
		                    break;
                        }
                    }
                pEm->Release();
                }    
            }
        }

    return(NOERROR);
}

HRESULT OpenInterface(HWND hwnd, HINSTANCE hinst)
{
    char *videodriver[MAX_DEVICES];
    int  vcount=MAX_DEVICES;
    int  vsel=-1;

    HRESULT hr=NOERROR;
    lstrcpy(gszCaptureFilterName,"DBOXII Capture");
    

	hr = CoCreateInstance(CLSID_FilterGraph, NULL, CLSCTX_INPROC_SERVER, IID_IGraphBuilder, (void **)&gpIGraphBuilder);
	if (SUCCEEDED(hr)&&(gpIGraphBuilder!=NULL))
    	hr = CoCreateInstance(CLSID_CaptureGraphBuilder, NULL, CLSCTX_INPROC_SERVER, IID_ICaptureGraphBuilder, (void **)&gpICaptureGraphBuilder);
    if (SUCCEEDED(hr)&&(gpICaptureGraphBuilder!=NULL))
        hr=gpICaptureGraphBuilder->SetFiltergraph(gpIGraphBuilder);


    if (SUCCEEDED(hr))
        {
        int  i=0;
        for(i=0;i<MAX_DEVICES;i++)
	        videodriver[i]=(char *)malloc(264);

        hr =EnumerateDevices(videodriver, &vcount, gpIGraphBuilder, gpICaptureGraphBuilder, -1, NULL, TRUE);   
        for(i=0;i<=vcount;i++)
            {
            if (!lstrcmp(videodriver[i],gszCaptureFilterName))
                {
                vsel=i;
                break;
                }
            }
        if (vsel>=0)
            {
            hr =EnumerateDevices(videodriver, &vcount, gpIGraphBuilder, gpICaptureGraphBuilder, vsel, &gpVCap, TRUE);   
            if (SUCCEEDED(hr))
                hr=AddCaptureFilterToGraph(gpIGraphBuilder, gpVCap, gszCaptureFilterName);
            }

        else
            hr=E_FAIL;
        
        for(i=0;i<MAX_DEVICES;i++)
	        free(videodriver[i]);
        }

    return(hr);
}

HRESULT ConnectVideoWindow(IGraphBuilder *pFg, HWND hwnd, RECT *pRect, BOOL is16By9)
{
    HRESULT       hr=NOERROR;
    IVideoWindow  *pVideoWindow=NULL;  
    IMediaEventEx *pMediaEvent=NULL;  


	if (pFg==NULL)
		return(E_POINTER);
    
    hr = pFg->QueryInterface(IID_IVideoWindow, (void **)&pVideoWindow);
    if (hr == NOERROR) 
        {
        if (pVideoWindow==NULL)
	        return(FALSE);
        hr=pVideoWindow->put_Owner((long)hwnd);    // We own the window now
        hr=pVideoWindow->put_WindowStyle(WS_CHILD);    // you are now a child
        
        if (pRect!=NULL)
            {
            int w=pWidth(pRect);
            int h=pHeight(pRect);
            int l=pRect->left;
            int t=pRect->top;
            if (is16By9)
                {
                int hh=((9*w)/16);
                if (hh<h)
                    t=t+(h-hh)/2;
                h=hh;
                }
//            hr=pVideoWindow->SetWindowPosition(pRect->left,pRect->top, pWidth(pRect),pHeight(pRect));
            hr=pVideoWindow->SetWindowPosition(l,t,w,h);
            }
        
        hr=pVideoWindow->put_Visible(OATRUE);
        hr=pVideoWindow->put_MessageDrain ((OAHWND)hwnd);     
        }
    else 
        return(E_FAIL);


    hr = pFg->QueryInterface(IID_IMediaEventEx, (void **)&pMediaEvent);  
    if (SUCCEEDED(hr)) 
       pMediaEvent->SetNotifyWindow((LONG)hwnd, WM_GRAPHNOTIFY, 0);

    RELEASE(pVideoWindow);
    RELEASE(pMediaEvent);

	return(hr);
}


HRESULT CloseInterface(HWND hwnd)
{
    HRESULT hr=NOERROR;
    RELEASE(gpVCap);
    DestroyGraph(gpIGraphBuilder);
    RELEASE(gpICaptureGraphBuilder);
    RELEASE(gpIGraphBuilder);
    return(hr);
}

HRESULT RebuildGraph()
{
    HRESULT hr=NOERROR;
    hr=DestroyGraph(gpIGraphBuilder);
    if (FAILED(hr))
        return(hr);
    hr=AddCaptureFilterToGraph(gpIGraphBuilder, gpVCap, gszCaptureFilterName);
    if (FAILED(hr))
        return(hr);
    return(hr);
}

HRESULT CreatePreviewGraph()
{
    RECT            rc;
    HRESULT         hr=NOERROR;
    IBaseFilter     *pDemux=NULL;
    IBaseFilter     *pVideoDecoder=NULL;
    IBaseFilter     *pAudioDecoder=NULL;
    IBaseFilter     *pVideoRenderer=NULL;
    IBaseFilter     *pAudioRenderer=NULL;
    IBaseFilter     *pTee=NULL;
    IBaseFilter     *pDeInterlace=NULL;
    IReferenceClock *pClk=NULL;
    IMediaFilter    *pMediaFilter=NULL;
    IPCLECommands   *pIDemux=NULL;

    //hr=DestroyGraph(gpIGraphBuilder);
    //if (FAILED(hr))
    //    return(hr);
    //hr=AddCaptureFilterToGraph(gpIGraphBuilder, gpVCap, gszCaptureFilterName);
    hr=RebuildGraph();
    if (FAILED(hr))
        return(hr);

    hr=LoadFilterByCLSID(gpIGraphBuilder, CLSID_PCLE_DEMUX2, &pDemux, L"DeMultiplexer");

    if (SUCCEEDED(hr))
        {
        hr = pDemux->QueryInterface (IID_IPCLECommands, (LPVOID*) &pIDemux);
        if (SUCCEEDED(hr))
            {
            LONGLONG val=48000;
            pIDemux->Command (Cmd_SetDefaultAudioSampleFrequency, 48000, 0, NULL);
            pIDemux->Command (Cmd_GetDefaultAudioSampleFrequency, 0, 0, &val);

            //pIDemux->Command (Cmd_TSEnableMpegPSOutput, TRUE, 0, NULL);
            }
        RELEASE(pIDemux);
        hr=NOERROR;
        }

    if (SUCCEEDED(hr))
        hr = LoadFilterByCLSID (gpIGraphBuilder, CLSID_InfTee, &pTee, L"InfTee");
    if (SUCCEEDED(hr))
        hr=TryConnectingFilters(gpIGraphBuilder, gpVCap, 2, pTee, 0, TRUE);

    if (SUCCEEDED(hr))
        hr=TryConnectingFilters(gpIGraphBuilder, pTee, 0, pDemux, 0, TRUE);
    if (SUCCEEDED(hr))
        hr=LoadFilterByCLSID(gpIGraphBuilder, CLSID_PCLE_MPEGVideoDecoder2, &pVideoDecoder, L"VideoDecoder");

    if (SUCCEEDED(hr))
        hr=TryConnectingFilters(gpIGraphBuilder, pDemux, 0, pVideoDecoder, 0, TRUE);
    if (SUCCEEDED(hr))
        hr=LoadFilterByCLSID(gpIGraphBuilder, CLSID_PinnacleVideoRenderer, &pVideoRenderer, L"VideoRenderer");

    if (SUCCEEDED(hr))
        hr=LoadFilterByCLSID(gpIGraphBuilder, CLSID_DeInterlace, &pDeInterlace, L"DeInterlace");
    if (SUCCEEDED(hr))
        hr=TryConnectingFilters(gpIGraphBuilder, pVideoDecoder, 0, pDeInterlace, 0, TRUE);

    if (SUCCEEDED(hr))
        hr=TryConnectingFilters(gpIGraphBuilder, pDeInterlace, 0, pVideoRenderer, 0, TRUE);

    if (SUCCEEDED(hr))
        hr=LoadFilterByCLSID(gpIGraphBuilder, CLSID_MPADecoder, &pAudioDecoder, L"AudioDecoder");
    if (SUCCEEDED(hr))
        hr=TryConnectingFilters(gpIGraphBuilder, pDemux, 1, pAudioDecoder, 0, TRUE);

    if (SUCCEEDED(hr))
        hr=LoadFilterByCLSID(gpIGraphBuilder, CLSID_DSoundRender, &pAudioRenderer, L"AudioRenderer");
    if (SUCCEEDED(hr))
        hr=TryConnectingFilters(gpIGraphBuilder, pAudioDecoder, 0, pAudioRenderer, 0, TRUE);

#if 1
    if (SUCCEEDED(hr))           
        {
        pAudioRenderer->QueryInterface (IID_IReferenceClock, (LPVOID*) &pClk);
        if (pClk!=NULL)
            {
            gpIGraphBuilder->QueryInterface (IID_IMediaFilter, (LPVOID*)&pMediaFilter);
            if (pMediaFilter!=NULL)
                pMediaFilter->SetSyncSource (pClk);
            }
        RELEASE(pClk);
        RELEASE(pMediaFilter);
        }
#endif

    RELEASE(pDeInterlace);
    RELEASE(pTee);
    RELEASE(pVideoRenderer);
    RELEASE(pVideoDecoder);
    RELEASE(pAudioRenderer);
    RELEASE(pAudioDecoder);
    RELEASE(pDemux);

    GetClientRect(ghWndVideo, &rc);

    if (SUCCEEDED(hr))
        hr=ConnectVideoWindow(gpIGraphBuilder, ghWndVideo, &rc, gIs16By9);

    if (SUCCEEDED(hr))
        hr=SetDeInterlacerState(gUseDeInterlacer);

    DumpFilterGraph(gpIGraphBuilder);

    return(NOERROR);
}

HRESULT CreateCaptureGraph()
{
    char  szFilename[264];
    WCHAR wszFilename[264];
    HRESULT hr=NOERROR;
    IBaseFilter *pFileWriter=NULL;
    IBaseFilter *pTee=NULL;
    IFileSinkFilter *pFileSink=NULL;

    if (!gRecNoPreview)
        {
        hr=CreatePreviewGraph();
        if (FAILED(hr))
            return(hr);
        }
    else
        {
        hr=RebuildGraph();
        if (FAILED(hr))
            return(hr);
        }

    ZeroMemory(wszFilename,sizeof(wszFilename));

    if (lstrlen(gszDestinationFile)==0)
        lstrcpy(gszDestinationFile, "DBOXIICapture");
    _makepath(szFilename, NULL, gszDestinationFolder, gszDestinationFile, "mpg" );

    MultiByteToWideChar(CP_ACP, 
                        0, 
                        szFilename, 
                        lstrlen(szFilename),
                        wszFilename,  
                        264);

    hr=LoadFilterByCLSID(gpIGraphBuilder, CLSID_RAWWriter, &pFileWriter, L"FileWriter");
    if (SUCCEEDED(hr))
        hr=pFileWriter->QueryInterface(IID_IFileSinkFilter, (void **)&pFileSink);
    if (SUCCEEDED(hr))
        hr=pFileSink->SetFileName(wszFilename,NULL);

    if (!gRecNoPreview)
        {
        if (SUCCEEDED(hr))
            hr=gpIGraphBuilder->FindFilterByName(L"InfTee", &pTee);
        if (SUCCEEDED(hr))
            hr=TryConnectingFilters(gpIGraphBuilder, pTee, 1, pFileWriter, 0, TRUE);
        }
    else
        {
            hr=TryConnectingFilters(gpIGraphBuilder, gpVCap, 2, pFileWriter, 0, TRUE);
        }

	RELEASE(pFileSink);
    RELEASE(pTee);
    RELEASE(pFileWriter);

    return(hr);
}

HRESULT SetDeInterlacerState(long useDeInterlacer)
{
    IBaseFilter *pFilter=NULL;
    IDeInterlace *pI =NULL;

    HRESULT hr=NOERROR;
    hr=gpIGraphBuilder->FindFilterByName(L"DeInterlace", &pFilter);

    if (SUCCEEDED(hr))
        hr=pFilter->QueryInterface(IID_IDeInterlace,(void **)&pI);
    if (SUCCEEDED(hr))
        pI->setParameter(CMD_DEINTERLACE, useDeInterlacer, 0, NULL);

    RELEASE(pI);
	RELEASE(pFilter);
    return(hr);
}

HRESULT GetCaptureFileSize(__int64 *size)
{
    IBaseFilter *pFileWriter=NULL;
    ISimpleSink *pSink=NULL;
    HRESULT hr=NOERROR;
    if (size==NULL)
        return(E_POINTER);

    if (gpIGraphBuilder==NULL)
        return(E_POINTER);

    hr=gpIGraphBuilder->FindFilterByName(L"FileWriter", &pFileWriter);
    if (SUCCEEDED(hr))
        pFileWriter->QueryInterface(IID_ISimpleSink, (void **)&pSink);
    if (SUCCEEDED(hr))
        hr=pSink->getCurrentFileSize(size);

    RELEASE(pSink);
    RELEASE(pFileWriter);
    return(hr);
}

HRESULT GetResyncCount(__int64 *val)
{
    IDBOXIICapture *pSource=NULL;
    HRESULT hr=NOERROR;

    if (val==NULL)
        return(E_POINTER);

    *val=0;

    if (gpIGraphBuilder==NULL)
        return(E_POINTER);

    if (gpVCap==NULL)
        return(E_POINTER);

    hr=gpVCap->QueryInterface(IID_IDBOXIICapture, (void **)&pSource);

    if (SUCCEEDED(hr))
        hr=pSource->getParameter(CMD_GETSYNCCOUNT, val, NULL);

    RELEASE(pSource);
    return(hr);
}

HRESULT GetCurrentBitrates(__int64 *val, __int64 *val2)
{
    IDBOXIICapture *pSource=NULL;
    HRESULT hr=NOERROR;

    if (val==NULL)
        return(E_POINTER);

    *val=0;

    if (gpIGraphBuilder==NULL)
        return(E_POINTER);

    if (gpVCap==NULL)
        return(E_POINTER);

    hr=gpVCap->QueryInterface(IID_IDBOXIICapture, (void **)&pSource);

    if (SUCCEEDED(hr))
        hr=pSource->getParameter(CMD_GETBITRATE, val, val2);

    RELEASE(pSource);
    return(hr);
}
