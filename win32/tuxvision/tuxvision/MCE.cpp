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

#include <winsock2.h>
#include <streams.h>
#include <string.h>
#include <stdio.h>
#include <io.h>
#include <stdlib.h>
#include <math.h>
#include <process.h>
#include <time.h>

#include "debug.h"
#include "ccircularbuffer.h"
#include "MCE.h"

//!!BS (n/t)httpd is really a bloody bastard ...
#if 1
    #define _CRLFCRLF_ "\r\n\r\n"
    #define _CRLF_     "\r\n"
#else
    #define _CRLFCRLF_ "\n\n"
    #define _CRLF_     "\n"
#endif
//!!BS (n/t)httpd is really a bloody bastard ...

CCircularBuffer *pHTMLCircularBuffer=NULL;

#define MAXTAG      25
#define MAXTAGDATA 100

struct songinfo {
	bool gotinfo;
	bool valid;
	char track[MAXTAGDATA];
	char artist1[MAXTAGDATA];
	char artist2[MAXTAGDATA];
	char album[MAXTAGDATA];
	char year[MAXTAGDATA];
	char label[MAXTAGDATA];
} mysonginfo;

struct s_id3{
	char tag[3];
	char songname[30];
	char artist[30];
	char album[30];
	char year[4];
	char comment[28];
	unsigned char empty;
	unsigned char tracknum;
	unsigned char genre;
}id3;


HRESULT InitSockets(void)
{
    int retval=-1;
    WSADATA WSAData;
    retval = WSAStartup(MAKEWORD(1,1), &WSAData);
    return(retval);
}

void DeInitSockets(void)
{
    WSACleanup();
}


HRESULT InitMCE()
{
    InitSockets();
    
    pHTMLCircularBuffer=new CCircularBuffer();
    pHTMLCircularBuffer->Initialize(512*1024, 1);

    return(NOERROR);
}

HRESULT DeInitMCE()
{
    if (pHTMLCircularBuffer)
        delete pHTMLCircularBuffer;

    DeInitSockets();

    return(NOERROR);
}

int OpenSocket(const char *name, unsigned short port)
{
    HRESULT hr=NOERROR;
    int ret=0;
	
	struct hostent * hp = gethostbyname(name);
		
	struct sockaddr_in adr;
	memset ((char *)&adr, 0, sizeof(struct sockaddr_in));

    if (hp==NULL)
        return(SOCKET_ERROR);
				
	adr.sin_family = AF_INET;
	adr.sin_addr.s_addr = ((struct in_addr *)(hp->h_addr))->s_addr;
	adr.sin_port = htons(port);
		
   if (adr.sin_addr.s_addr == 0) {
		dprintf("unable to lookup hostname !");
		return(SOCKET_ERROR);
	}
		         
	int sock = socket(AF_INET, SOCK_STREAM, 0);

	if (SOCKET_ERROR == connect(sock, (sockaddr*)&adr, sizeof(struct sockaddr_in))) 
        {
		dprintf("connect failed !");
		closesocket(sock);
		return(SOCKET_ERROR);
	    }
    return(sock);
}

HRESULT WaitForSocketData(SOCKET sock, unsigned long *avail, long tim)
{
    int ret=0;
    int count=tim/10;
    int i=0;

    if (avail==NULL)
        return(E_POINTER);
    *avail=0;

    for(i=0;i<count;i++)
        {
        Sleep(10);
        ret=ioctlsocket(sock, FIONREAD, avail);
        if (ret<0)
            return(E_FAIL);
        if (*avail>0)
            break;
        }

    return(NOERROR);
}

HRESULT ReadCompleteDataFromSocket(SOCKET s)
{
    HRESULT hr=NOERROR;
    unsigned long avail=0;
    int ret=0;
    int i=0;

    if (!pHTMLCircularBuffer)
        return(E_UNEXPECTED);
    pHTMLCircularBuffer->Clear();

    hr=WaitForSocketData(s, &avail, 1000);
    if (FAILED(hr)||(avail==0))
        return(hr);

    while(TRUE)  
        {
        if ((ret==0)&&(avail>0))
            {
            char rbuffer[1024];
            ZeroMemory(rbuffer,sizeof(rbuffer));
            ret=recv(s,rbuffer,sizeof(rbuffer),0);
            if (ret>0)
                {
                if (!pHTMLCircularBuffer->canWrite(ret))
                    return(E_UNEXPECTED);
                pHTMLCircularBuffer->Write((BYTE *)rbuffer, ret);
                i=0;
                }
            }
        ret=WaitForSocketData(s, &avail, 1000);
        if (ret<0)
            break;
        if (i++>10)
            break;
        }

    return(NOERROR);
}

// ---------------------------------------------------    
// !!BS: blind copied from mrec
// ---------------------------------------------------    
void decode_string(char * string)
{
	char * oldstr = string;
	char * newstr = string;
	char num[5];
	unsigned char code;
	int i;

	while(true)
	{
		if (*oldstr == '\0')
			break;
		if ((*oldstr == '&') && (*(oldstr+1) == '#'))
		{
			oldstr += 2;
			for (i = 0; *oldstr != ';'; i++)
			{
				num[i] = *oldstr++;
			}
			num[i] = '\0';
			code = (char) atoi(num);
			switch (code) 
			{
				case 180:	*newstr++ = '\'';
						break;
				default:	*newstr++ = code;
			}
			oldstr++;
		}
		else
		{
			*newstr++ = *oldstr++;
		}
	}
	*newstr = '\0';
}

HRESULT GetMCEInfo(const char *name, unsigned short port, char *channelName)
{
    HRESULT hr=NOERROR;
    int ret=0;
	
    dprintf("GetMCEInfo from %s:%d ", name, (int)port);

	int sock = OpenSocket(name, port);
    if (sock==SOCKET_ERROR)
        return(E_FAIL);
	
	char wbuffer[4096];		
	char wbody[4096];		

    ZeroMemory(wbuffer, sizeof(wbuffer));
    ZeroMemory(wbody, sizeof(wbody));

#if 0
    wsprintf(wbuffer, "GET /EPG/%s.shtml HTTP/1.0"_CRLF_, channelName);
    wsprintf(wbody,   "User-Agent: BS"_CRLF_
                      "Host: %s"_CRLF_
                      "Pragma: no-cache"_CRLF_
                      "Accept: image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, */*"_CRLFCRLF_,
                       name);
#else	
    wsprintf(wbuffer, "GET /EPG/%s.shtml HTTP/1.0"_CRLFCRLF_, channelName);
#endif

    lstrcat(wbuffer,wbody);
    ret=send(sock, wbuffer, strlen(wbuffer),0);


    hr=ReadCompleteDataFromSocket(sock);

    if (SUCCEEDED(hr))
        {
        long len=0;
        pHTMLCircularBuffer->Remain(0, &len);
        if (len>0)
            {
            char *rbuffer=(char *)malloc(len+2);
            ZeroMemory(rbuffer, len+2);
            pHTMLCircularBuffer->Read(0, (BYTE *)rbuffer, len);

            // ---------------------------------------------------    
            // !!BS: blind copied from mrec
            // ---------------------------------------------------    
            char *urlbufptr=rbuffer;
           	char tag[MAXTAG];
	        char tagdata[MAXTAGDATA];
	        char *cpptr=NULL;
	        char *tagptr=NULL;
            int  i=0;

            while(true)
            {
	            if ((urlbufptr = strstr(urlbufptr, "div id")) == NULL)
		            break;

	            urlbufptr += 8;
	            tagptr = tag;
	            for (cpptr = urlbufptr, i = 0; *cpptr != '\"'; cpptr++, i++)
	            {
		            if (i < MAXTAG-1)
			            *tagptr++ = *cpptr;
	            }
	            *tagptr = '\0';

	            urlbufptr = strstr(urlbufptr, ">");
	            urlbufptr++;
	            tagptr = tagdata;
	            for (cpptr = urlbufptr, i = 0; *cpptr != '<'; cpptr++, i++)
	            {
		            if (i < MAXTAGDATA-1)
			            *tagptr++ = *cpptr;
	            }
	            *tagptr = '\0';
	            decode_string(tagdata);

	            if (strcmp(tag, "track") == 0)
	            {
		            if (strcmp(tagdata, mysonginfo.track) == 0)
		            {
			            dprintf("MCE data not valid ...");
		            }
		            strncpy(mysonginfo.track, tagdata, MAXTAGDATA);
	            }
	            if (strcmp(tag, "album") == 0)
	            {
		            strncpy(mysonginfo.album, tagdata, MAXTAGDATA);
	            }
	            if (strcmp(tag, "label") == 0)
	            {
		            strncpy(mysonginfo.label, tagdata, MAXTAGDATA);
	            }
	            if (strcmp(tag, "year") == 0)
	            {
		            strncpy(mysonginfo.year, tagdata, MAXTAGDATA);
	            }
	            if (strcmp(tag, "artist1") == 0)
	            {
		            strncpy(mysonginfo.artist1, tagdata, MAXTAGDATA);
	            }
	            if (strcmp(tag, "artist2") == 0)
	            {
		            strncpy(mysonginfo.artist2, tagdata, MAXTAGDATA);
	            }

            }
            // ---------------------------------------------------    
            //
            // ---------------------------------------------------    
            free(rbuffer);
            }
        }

    closesocket(sock);

    return(NOERROR);
}

