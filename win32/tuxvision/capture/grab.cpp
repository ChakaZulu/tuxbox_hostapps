//
//  DBOXII Capture Filter
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

#include "ccircularbuffer.h"
#include "Remuxer.h"
#include "grab.h"

#include "debug.h"

// -------------------------------------------
char         *gChannelNameList[MAX_LIST_ITEM];
__int64       gChannelIDList[MAX_LIST_ITEM];
__int64       gTotalChannelCount=-1;
// -------------------------------------------
BOOL          gfTerminateThread=FALSE;
BOOL          gfThreadAborted=FALSE;
unsigned long ghAVReadThread=0;
void  __cdecl AVReadThread(void *thread_arg);

int gSocketVideoPES=0;
int gSocketAudioPES=0;

CCircularBuffer *CVideoBuffer=NULL;
CCircularBuffer *CAudioBuffer=NULL;
CCircularBuffer *CMultiplexBuffer=NULL;

Remuxer         *CRemuxer=NULL;
BOOL            gIsVideoConnected=FALSE;
BOOL            gIsAudioConnected=FALSE;
BOOL            gIsMultiplexerConnected=FALSE;

volatile __int64         gTotalVideoDataCount=0;
volatile __int64         gTotalAudioDataCount=0;
__int64         gLastVideoDataCount=0;
__int64         gLastAudioDataCount=0;
long            gLastAVBitrateRequest=0;

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

int isDataAvailable(int socket, unsigned long size)
{
    int ret;
    unsigned long avail;

    ret=ioctlsocket(socket, FIONREAD, &avail);

    if (ret!=NULL)
        return(FALSE);

    if (avail>=size)
        return(TRUE);
    return(FALSE);
}

//-----------------------------------------------------------
// Function: GetBuf()
//
// nOptval: SO_SNDBUF, SO_RCVBUF
//-----------------------------------------------------------
#define MAX_MTU 1460

int  GetBufTCP (SOCKET hSock, int nBigBufSize, int nOptval)
{
    int nRet, nTrySize, nFinalSize = 0;
    
    for (nTrySize=nBigBufSize; nTrySize > MAX_MTU; nTrySize >>= 1) 
    {
        nRet = setsockopt (hSock, SOL_SOCKET, nOptval, (char FAR*) &nTrySize, sizeof (int));
        if (nRet == SOCKET_ERROR) 
        {
            int WSAErr = WSAGetLastError();
            if ((WSAErr==WSAENOPROTOOPT) || (WSAErr==WSAEINVAL))
                break;
        } 
        else 
        {
            nRet = sizeof (int);
            getsockopt (hSock, SOL_SOCKET, nOptval, (char FAR *) &nFinalSize, &nRet);
            break;
        }
    }
    return (nFinalSize);
} /* end GetBuf() */

int openPES(const char * name, unsigned short port, int pid, int bsize)
{
    int ret=0;
	dprintf("opening PES %s:%d PID %d", name, (int)port, pid);
	
	struct hostent * hp = gethostbyname(name);
		
	struct sockaddr_in adr;
	memset ((char *)&adr, 0, sizeof(struct sockaddr_in));

    if (hp==NULL)
        return(SOCKET_ERROR);
				
	adr.sin_family = AF_INET;
	adr.sin_addr.s_addr = ((struct in_addr *)(hp->h_addr))->s_addr;
	adr.sin_port = htons(port);
		
    if (adr.sin_addr.s_addr == 0) 
        {
		dprintf("unable to lookup hostname !");
		return(SOCKET_ERROR);
	    }
		         
	int sock = socket(AF_INET, SOCK_STREAM, 0);
	
	if (SOCKET_ERROR == connect(sock, (sockaddr*)&adr, sizeof(struct sockaddr_in))) 
        {
		dprintf("connect failed !");
		EmptySocket(sock);
        closesocket(sock);
		return(SOCKET_ERROR);
	    }
	
	char buffer[264];		
	wsprintf(buffer, "GET /%x HTTP/1.0\r\n\r\n", pid);
	
    ret=GetBufTCP (sock, bsize, SO_RCVBUF);
    dprintf("Requested Buffer:%lu, granted Buffer:%lu",bsize,ret);

    ret=send(sock, buffer, strlen(buffer),0);

	return sock;
}

int openPS(const char * name, unsigned short port, int vpid, int apid, int bsize)
{
    int ret=0;
	dprintf("opening PS %s:%d APID %d, VPID %d", name, (int)port, apid, vpid);
	
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
		EmptySocket(sock);
		closesocket(sock);
		return(SOCKET_ERROR);
	    }
	
	char buffer[264];		
	wsprintf(buffer, "GET /%x %x HTTP/1.0\r\n\r\n", apid,vpid);
	
    ret=GetBufTCP (sock, bsize, SO_RCVBUF);
    dprintf("Requested Buffer:%lu, granted Buffer:%lu",bsize,ret);

    ret=send(sock, buffer, strlen(buffer),0);

	return sock;
}

char *MYstrstr(char *str, char *token)
{
    int i,j;

    if (token==NULL)
        return(NULL);

    if (str==NULL)
        return(NULL);

    int tlen=lstrlen(token);
    if (tlen==0)
        return(NULL);

    int slen=lstrlen(str);
    if (slen==0)
        return(NULL);

    if (slen<tlen)
        return(NULL);

    for(i=0;i<=(slen-tlen);i++)
        {
        int found=1;
        for(j=0;j<tlen;j++)
            {
            if (str[i+j]!=token[j])
                {
                found=0;
                break;
                }
            }
        if (found)
            return(str+i+tlen);
        }

    return(NULL);
}

HRESULT EmptySocket(SOCKET s)
{
    int ret=0;
    unsigned long avail=0;
// -------------------------------------------------------------------
    {
	LINGER ling;
	ling.l_onoff=1;
	ling.l_linger=5;
	setsockopt(s,SOL_SOCKET,SO_LINGER,(LPSTR)&ling,sizeof(ling));
    }
    
    ret=ioctlsocket(s, FIONREAD, &avail);

    while(avail>0)
        {
        if (ret==0)
            {
            char *rbuffer=(char *)malloc(avail);
            ret=recv(s,rbuffer,avail,0);
            free(rbuffer);
            }
        ret=ioctlsocket(s, FIONREAD, &avail);
        }
// -------------------------------------------------------------------
    return(ret);
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
		EmptySocket(sock);
		closesocket(sock);
		return(SOCKET_ERROR);
	    }
    return(sock);
}

HRESULT SetChannel(const char *name, unsigned short port, unsigned long channel)
{
    HRESULT hr=NOERROR;
    int i=0;
    int ret=0;
    unsigned long avail;

    dprintf("SetChannel from %s:%d ", name, (int)port);
    	
	int sock = OpenSocket(name, port);
    if (sock==SOCKET_ERROR)
        return(E_FAIL);
	
	char wbuffer[1024];		
	char wbody[1024];		

    wsprintf(wbuffer, "GET /control/zapto?%lu HTTP/1.0\r\n", channel);
    wsprintf(wbody,   "User-Agent: BS\r\n"
                      "Host: %s\r\n"
                      "Pragma: no-cache\r\n"
                      "Accept: image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, */*\r\n"
                      "\r\n", name);
	

    lstrcat(wbuffer,wbody);
    ret=send(sock, wbuffer, strlen(wbuffer),0);

    Sleep(250);

    hr=E_FAIL;
    ret=ioctlsocket(sock, FIONREAD, &avail);
//    while(avail>0)
    while(TRUE)
        {
        if ((ret==0)&&(avail>0))
            {
            int pos=0;
            char *p1=NULL;
            char *p2=NULL;
            char rbuffer[1024];
            ZeroMemory(rbuffer, sizeof(rbuffer));
            ret=recv(sock,rbuffer,sizeof(rbuffer),0);
            //dprintf("------");
            //dprintf(rbuffer);
            if (!strcmp(rbuffer,"ok"))
                {
                hr=NOERROR;
                break;
                }
            p1=MYstrstr(rbuffer,"\n\n");
            if (p1!=NULL)
                {
                if (!strcmp(p1,"ok"))
                    {
                    hr=NOERROR;
                    break;
                    }
                p2=MYstrstr(p1,"\n");
                }
            if (p2!=NULL)
                {
                if (!strcmp(p2,"ok"))
                    {
                    hr=NOERROR;
                    break;
                    }
                }
            //dprintf("------");
            }
        ret=ioctlsocket(sock, FIONREAD, &avail);
        if (ret<0)
            break;
        if (i++>20)
            break;
        Sleep(250);
        }

    EmptySocket(sock);
    closesocket(sock);

    return(hr);
}

HRESULT GetChannel(const char *name, unsigned short port, unsigned long *channel)
{
    HRESULT hr=NOERROR;
    int ret=0;
    unsigned long avail;
	
    *channel=0;
    dprintf("GetChannel from %s:%d ", name, (int)port);

	int sock = OpenSocket(name, port);
    if (sock==SOCKET_ERROR)
        return(E_FAIL);
	
	char wbuffer[1024];		
	char wbody[1024];		

    wsprintf(wbuffer, "GET /control/zapto HTTP/1.0\r\n");
    wsprintf(wbody,   "User-Agent: BS\r\n"
                      "Host: %s\r\n"
                      "Pragma: no-cache\r\n"
                      "Accept: image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, */*\r\n"
                      "\r\n", name);
	

    lstrcat(wbuffer,wbody);
    ret=send(sock, wbuffer, strlen(wbuffer),0);

    Sleep(250);

    ret=ioctlsocket(sock, FIONREAD, &avail);
    while(avail>0)
        {
        if (ret==0)
            {
            int pos=0;
            char *p1=NULL;
            char rbuffer[1024];
            ZeroMemory(rbuffer,sizeof(rbuffer));
            ret=recv(sock,rbuffer,sizeof(rbuffer),0);
            p1=MYstrstr(rbuffer,"\n\n");
            if (p1!=NULL)
                {
                pos=strlen(p1)-1;
                if (pos>0)
                    p1[pos]=0;
                *channel=atol(p1);
                //dprintf(p1);
                }
            }
        ret=ioctlsocket(sock, FIONREAD, &avail);
        }


	EmptySocket(sock);
    closesocket(sock);

    if (*channel==0)
        return(E_FAIL);
    else
        return(NOERROR);
}

HRESULT GetChannelInfo(const char *name, unsigned short port, unsigned long channel, char *info)
{
    HRESULT hr=NOERROR;
    int ret=0;
    int i=0;
    unsigned long avail;
	
    lstrcpy(info,"");

    dprintf("GetChannelInfo from %s:%d ", name, (int)port);

	int sock = OpenSocket(name, port);
    if (sock==SOCKET_ERROR)
        return(E_FAIL);
	
	char wbuffer[1024];		
	char wbody[1024];		

    wsprintf(wbuffer, "GET /control/epg?%lu HTTP/1.0\r\n", channel);
    wsprintf(wbody,   "User-Agent: BS\r\n"
                      "Host: %s\r\n"
                      "Pragma: no-cache\r\n"
                      "Accept: image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, */*\r\n"
                      "\r\n", name);
	

    lstrcat(wbuffer,wbody);
    ret=send(sock, wbuffer, strlen(wbuffer),0);

      while(TRUE)  
        {
        if ((ret==0)&&(avail>0))
            {
            int pos=0;
            char *p1=NULL;
            char *p2=NULL;
            char rbuffer[1024];
            ZeroMemory(rbuffer,sizeof(rbuffer));
            ret=recv(sock,rbuffer,sizeof(rbuffer),0);
// ---------------------------------------------------    
            if (!strncmp(rbuffer,"HTTP",4))
                {
                p1=MYstrstr(rbuffer,"\n\n");
                }
            else
                {
                p2=MYstrstr(rbuffer,"\n\n");
                if (p2!=NULL)
                    p1=p2;
                else
                    p1=rbuffer; 
                if (p1!=NULL)
                    {
                    if (*p1=='\n')
                        p1++;
                    }
                }
// ---------------------------------------------------    
            if (p1!=NULL)
                p2=MYstrstr(p1,"\n");
            if (p2!=NULL)
                {
                p2--;
                *p2=0;
                lstrcpyn(info, p1, 264);
                break;
                //dprintf(p1);
                }
            }
        ret=ioctlsocket(sock, FIONREAD, &avail);
        if (ret<0)
            break;
        if (i++>20)
            break;
        Sleep(250);
        }


	EmptySocket(sock);
    closesocket(sock);

    if (lstrlen(info)==0)
        return(E_FAIL);
    else
        return(NOERROR);
}


HRESULT ControlPlaybackOnDBOX(const char *name, unsigned short port, int active)
{
    HRESULT hr=NOERROR;
    int ret=0;
	
    dprintf("ControlPlaybackOnDBOX from %s:%d ", name, (int)port);

	int sock = OpenSocket(name, port);
    if (sock==SOCKET_ERROR)
        return(E_FAIL);
	
	char wbuffer[1024];		
	char wbody[1024];		


    if (active==0)
        {
	    //wsprintf(wbuffer, "GET /control/zapto?startsectionsd HTTP/1.0\r\n");
	    wsprintf(wbuffer, "GET /control/zapto?startplayback HTTP/1.0\r\n");
        }
    else
    if (active==1)
	    wsprintf(wbuffer, "GET /control/zapto?stopsectionsd HTTP/1.0\r\n");
    else
	    wsprintf(wbuffer, "GET /control/zapto?stopplayback HTTP/1.0\r\n");


    wsprintf(wbody,   "User-Agent: BS\r\n"
                      "Host: %s\r\n"
                      "Pragma: no-cache\r\n"
                      "Accept: image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, */*\r\n"
                      "\r\n", name);
	

    lstrcat(wbuffer,wbody);
    ret=send(sock, wbuffer, strlen(wbuffer),0);

	EmptySocket(sock);
    closesocket(sock);

    if (ret>0)
        return(NOERROR);
    else
        return(E_FAIL);

}

HRESULT RetrievePIDs(int *vpid, int *apid, const char *name, unsigned short port)
{
    HRESULT hr=NOERROR;
    int ret=0;
    unsigned long avail;
	
    *apid=0;
    *vpid=0;
    
    dprintf("retrieving PIDs from %s:%d ", name, (int)port);
	
	int sock = OpenSocket(name, port);
    if (sock==SOCKET_ERROR)
        return(E_FAIL);
	
	char wbuffer[1024];		
	char wbody[1024];		
	wsprintf(wbuffer, "GET /control/zapto?getpids HTTP/1.0\r\n");

    wsprintf(wbody,   "User-Agent: BS\r\n"
                      "Host: %s\r\n"
                      "Pragma: no-cache\r\n"
                      "Accept: image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, */*\r\n"
                      "\r\n", name);
	

    lstrcat(wbuffer,wbody);
    ret=send(sock, wbuffer, strlen(wbuffer),0);

    Sleep(250);

    ret=ioctlsocket(sock, FIONREAD, &avail);
    if (avail<=0)
        {
	    EmptySocket(sock);
        closesocket(sock);
        return(E_FAIL);
        }

    while(avail>0)
        {
        if (ret==0)
            {
            int pos=0;
            unsigned int i;
            char *p1=NULL;
            char *p2=NULL;
            char rbuffer[1024];
            ZeroMemory(rbuffer, sizeof(rbuffer));
            ret=recv(sock,rbuffer,sizeof(rbuffer),0);
            //dprintf("------");
            //dprintf(rbuffer);
            p1=MYstrstr(rbuffer,"\n\n");
            if (p1!=NULL)
                p2=MYstrstr(p1,"\n");
            if (p1!=NULL)
                {
                for(i=0;i<strlen(p1);i++)
                    if (p1[i]=='\n') {p1[i]=0;break;}
                *vpid=atoi(p1);
                }
            if (p2!=NULL)
                {
                for(i=0;i<strlen(p2);i++)
                    if (p2[i]=='\n') {p2[i]=0;break;}
                *apid=atoi(p2);
                }
            //dprintf("------");
            }
        ret=ioctlsocket(sock, FIONREAD, &avail);
        }

	EmptySocket(sock);
    closesocket(sock);
	return(hr);
}

HRESULT CheckBoxStatus(const char *name, unsigned short port)
{
#pragma warning (disable : 4018)

    fd_set fd_write, fd_except;
    struct timeval tv;
    HRESULT hr=NOERROR;
    int ret=0;

    dprintf("CheckBoxStatus from %s:%d ", name, (int)port);
	
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

    u_long val=1;
    //put socket to nonblocking mode
    ret=ioctlsocket (sock, FIONBIO, &val);

	ret=connect(sock, (sockaddr*)&adr, sizeof(struct sockaddr_in));

    FD_ZERO(&fd_write);
    FD_SET((int)sock, &fd_write);
    FD_ZERO(&fd_except);
    FD_SET((int)sock, &fd_except);
    tv.tv_sec =5;
    tv.tv_usec=0;
    ret=select (0, NULL, &fd_write, &fd_except, &tv);

	EmptySocket(sock);
    closesocket(sock);

    if (ret<=0)
        return(SOCKET_ERROR);
    return(NOERROR);

#pragma warning (default : 4018)
}

HRESULT RetrieveStreamInfo(int *width, int *height, const char *name, unsigned short port)
{
    HRESULT hr=NOERROR;
    int ret=0;
    unsigned long avail;
	
    *width=0;
    *height=0;
    
    dprintf("RetrieveStreamInfo from %s:%d ", name, (int)port);

	int sock = OpenSocket(name, port);
    if (sock==SOCKET_ERROR)
        return(E_FAIL);
	
	char wbuffer[1024];		
	char wbody[1024];		
	wsprintf(wbuffer, "GET /control/info?streaminfo HTTP/1.0\r\n");

    wsprintf(wbody,   "User-Agent: BS\r\n"
                      "Host: %s\r\n"
                      "Pragma: no-cache\r\n"
                      "Accept: image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, */*\r\n"
                      "\r\n", name);
	

    lstrcat(wbuffer,wbody);
    ret=send(sock, wbuffer, strlen(wbuffer),0);

    Sleep(250);

    ret=ioctlsocket(sock, FIONREAD, &avail);
    if (avail<=0)
        {
	    EmptySocket(sock);
        closesocket(sock);
        return(E_FAIL);
        }

    while(avail>0)
        {
        if (ret==0)
            {
            int pos=0;
            unsigned int i;
            char *p1=NULL;
            char *p2=NULL;
            char rbuffer[1024];
            ZeroMemory(rbuffer, sizeof(rbuffer));
            ret=recv(sock,rbuffer,sizeof(rbuffer),0);
            //dprintf("------");
            //dprintf(rbuffer);
            p1=MYstrstr(rbuffer,"\n\n");
            if (p1!=NULL)
                p2=MYstrstr(p1,"\n");
            if (p1!=NULL)
                {
                for(i=0;i<strlen(p1);i++)
                    if (p1[i]=='\n') {p1[i]=0;break;}
                *width=atoi(p1);
                }
            if (p2!=NULL)
                {
                for(i=0;i<strlen(p2);i++)
                    if (p2[i]=='\n') {p2[i]=0;break;}
                *height=atoi(p2);
                }
            //dprintf("------");
            }
        ret=ioctlsocket(sock, FIONREAD, &avail);
        }

	EmptySocket(sock);
    closesocket(sock);
	return(hr);
}

HRESULT RetrieveChannelList(const char *name, unsigned short port, char *szName, __int64 *count)
{
    HRESULT hr=NOERROR;
    int ret=0;
    unsigned long avail;
	
    if (*count<0)
        {
        dprintf("RetrieveChannelList from %s:%d ", name, (int)port);
    
        gTotalChannelCount=-1;

        for(int i=0;i<MAX_LIST_ITEM;i++)
            {
            if (gChannelNameList[i]!=NULL)
                free(gChannelNameList[i]);
            gChannelNameList[i]=NULL;
            gChannelIDList[i]=0;
            }

	    int sock = OpenSocket(name, port);
        if (sock==SOCKET_ERROR)
            return(E_FAIL);
	    
	    char wbuffer[1024];		
	    char wbody[1024];		
	    wsprintf(wbuffer, "GET /control/channellist HTTP/1.0\r\n");

        wsprintf(wbody,   "User-Agent: BS\r\n"
                          "Host: %s\r\n"
                          "Pragma: no-cache\r\n"
                          "Accept: image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, */*\r\n"
                          "\r\n", name);
	    

        lstrcat(wbuffer,wbody);
        ret=send(sock, wbuffer, strlen(wbuffer),0);

        Sleep(250);

        ret=ioctlsocket(sock, FIONREAD, &avail);
        if (avail<=0)
            {
    		EmptySocket(sock);
            closesocket(sock);
            return(E_FAIL);
            }

        while(avail>0)
            {
            if (ret==0)
                {
                int pos=0;
                unsigned int i;
                int srbuffer=1024*1024;
                char *p1=NULL;
                char *p2=NULL;
                char *rbuffer=(char *)malloc(srbuffer);
                ZeroMemory(rbuffer,srbuffer);
                ret=recv(sock,rbuffer,srbuffer-1,0);
                //dprintf("------");
                //dprintf(rbuffer);
                p1=MYstrstr(rbuffer,"\n\n");
                if (gTotalChannelCount>=(MAX_LIST_ITEM-1))
                    break;
                while (p1!=NULL)
                    {
                    if (*p1!=0)
                        {
                        unsigned int k;
                        unsigned long lval=0;
                        char *sval=NULL;
                        if (gTotalChannelCount>=(MAX_LIST_ITEM-1))
                            break;
                        gTotalChannelCount++;
                        for(i=0;i<strlen(p1);i++)
                            if (p1[i]=='\n') {p2=p1+i+1;p1[i]=0;break;}
                        dprintf(p1);
                        sscanf(p1,"%lu", &lval);
                        sval=p1;
                        for(k=0;k<strlen(p1)-1;k++)   
                            {
                            if (p1[k]==' ')
                                {
                                sval=p1+k+1;
                                break;
                                }
                            }
                        gChannelNameList[gTotalChannelCount]=(char *)malloc(264);
                        lstrcpyn(gChannelNameList[gTotalChannelCount], sval, 264);
                        gChannelIDList[gTotalChannelCount]=lval;
                        p1=p2;
                        }
                    else
                        break;
                    }
                //dprintf("------");
                free(rbuffer);
                }
            ret=ioctlsocket(sock, FIONREAD, &avail);
            }

		EmptySocket(sock);
        closesocket(sock);
        *count=gTotalChannelCount;
        return(hr);
        }

    if (*count>gTotalChannelCount)
        {
        *count=-1;
        return(E_FAIL);
        }
    else
        {
        __int64 index=*count;
        lstrcpyn(szName, gChannelNameList[index], 264);
        *count=gChannelIDList[index];
        }

	return(hr);
}

int FindStartCode(BYTE *buffer, int size, DWORD code)
{
    int i=0;
    int c0= code     &0x000000FF;
    int c1=(code>>8) &0x000000FF;
    int c2=(code>>16)&0x000000FF;
    int c3=(code>>24)&0x000000FF;
    for(i=0;i<size-3;i++)
        {
        if (buffer[i]==c3)
            if (buffer[i+1]==c2)
                if (buffer[i+2]==c1)
                    if (buffer[i+3]==c0)
                        return(i);
        }
    return(-1);
}

int FindStartCodesVideo(BYTE *buffer, int size)
{
    int off1=0;
    off1=FindStartCode(buffer+off1,size,0x000001B3);
//    off1=FindStartCode(buffer+off1,size,0x000001E0);
    if (off1>=0)
        return(off1);

    return(-1);
}

int FindStartCodesAudio(BYTE *buffer, int size)
{
    int off1=0;
    off1=FindStartCode(buffer+off1,size,0x000001C0);
    if (off1>=0)
        return(off1);

    return(-1);
}

void __cdecl AVReadThread(void *thread_arg)
{	
    BOOL wait=TRUE;
	int ret=0;
    int off=0;
    unsigned char *bufferVideo=NULL;
    int  bufferlenVideo=VIDEO_BUFFER_SIZE;
    unsigned char *bufferAudio=NULL;
    int  bufferlenAudio=AUDIO_BUFFER_SIZE;
    BOOL firstAudio=TRUE;
    BOOL firstVideo=TRUE;

    bufferVideo=(unsigned char *)malloc(bufferlenVideo);
    bufferAudio=(unsigned char *)malloc(bufferlenAudio);


    dprintf("AVReadThread started ...");

    for (;;) 
        {
		if (gfTerminateThread) 
			break;

        wait=TRUE;
        ret=0;

        if (gSocketVideoPES>0)
            {
            if (CVideoBuffer==NULL)
                {
                dprintf("Thread Video error");
                break;
                }

            if (isDataAvailable(gSocketVideoPES, bufferlenVideo))
                {
                ret=recv(gSocketVideoPES, (char *)bufferVideo, bufferlenVideo, 0);
                if (ret>0)
                    {
                    gTotalVideoDataCount+=ret;

                    #if USE_REMUX
                    if (gIsMultiplexerConnected)
                        CRemuxer->supply_video_data(bufferVideo, ret);
                    #endif

                    if (firstVideo)
                        {
                        off=FindStartCodesVideo(bufferVideo, ret);
                        if (off>=0)
                            {
                            if (gIsVideoConnected)
                                {
                                CVideoBuffer->Write(bufferVideo+off, ret-off);
                                }
                            /*
                            #if USE_REMUX
                            if (gIsMultiplexerConnected)
                                CRemuxer->supply_video_data(bufferVideo+off, ret-off);
                            #endif
                            */
                            firstVideo=FALSE;
                            }
                        }
                    else
                        {
                        if (gIsVideoConnected)
                            {
                            CVideoBuffer->Write(bufferVideo, ret);
                            }
                        /*
                        #if USE_REMUX
                        if (gIsMultiplexerConnected)
                            CRemuxer->supply_video_data(bufferVideo, ret);
                        #endif
                        */
                        }
                    wait=FALSE;
                    }
                }
            }

        if (gSocketAudioPES>0)
            {
            if (CAudioBuffer==NULL)
                {
                dprintf("Thread Audio error");
                break;
                }

            if (isDataAvailable(gSocketAudioPES, bufferlenAudio))
                {
                ret=recv(gSocketAudioPES, (char *)bufferAudio, bufferlenAudio, 0);
                if (ret>0)
                    {
                    gTotalAudioDataCount+=ret;

                    #if USE_REMUX
                    if (gIsMultiplexerConnected)
                        CRemuxer->supply_audio_data(bufferAudio, ret);
                    #endif

                    if (firstAudio)
                        {
                        off=FindStartCodesAudio(bufferAudio, ret);
                        if (off>=0)
                            {
                            if (gIsAudioConnected)
                                {
                                CAudioBuffer->Write(bufferAudio+off, ret-off);
                                }
                            /*
                            #if USE_REMUX
                            if (gIsMultiplexerConnected)
                                CRemuxer->supply_audio_data(bufferAudio+off, ret-off);
                            #endif
                            */
                            firstAudio=FALSE;
                            }
                        }
                    else
                        {
                        if (gIsAudioConnected)
                            {
                            CAudioBuffer->Write(bufferAudio, ret);
                            }
                        /*
                        #if USE_REMUX
                        if (gIsMultiplexerConnected)
                            CRemuxer->supply_audio_data(bufferAudio, ret);
                        #endif
                        */
                        }
                    wait=FALSE;
                    }
                }
            }
        
        if (ret<0)
            break;

        
        #if USE_REMUX
        if (!wait)
            if (gIsMultiplexerConnected)
	            CRemuxer->write_mpg(NULL);
        #endif
        
        if (wait)
            Sleep(5);
        }

    gfThreadAborted=TRUE;

    free(bufferVideo);
    free(bufferAudio);
}

void DeInitStreaming()
{
    gfTerminateThread=TRUE;
    Sleep(500);
    
    if (gSocketVideoPES>0)
        {
        //EmptySocket(gSocketVideoPES);
        closesocket(gSocketVideoPES);
        }
    gSocketVideoPES=0;

    if (gSocketAudioPES>0)
        {
        //EmptySocket(gSocketAudioPES);
        closesocket(gSocketAudioPES);
        }
    gSocketAudioPES=0;

    if (CVideoBuffer)
        {
        CVideoBuffer->Interrupt();
        CVideoBuffer->DeInitialize();
        delete CVideoBuffer;
        CVideoBuffer=NULL;
        }

    if (CAudioBuffer)
        {
        CAudioBuffer->Interrupt();
        CAudioBuffer->DeInitialize();
        delete CAudioBuffer;
        CAudioBuffer=NULL;
        }
    
    if (CMultiplexBuffer)
        {
        CMultiplexBuffer->Interrupt();
        CMultiplexBuffer->DeInitialize();
        delete CMultiplexBuffer;
        CMultiplexBuffer=NULL;
        }

    if (CRemuxer)
        {
        delete CRemuxer;
        CRemuxer=NULL;
        }
}

HRESULT InitPSStreaming(int vpid, int apid, char *IPAddress, int Port) 
{

    if ((vpid>0)&&(apid>0))
        {
        CVideoBuffer=new CCircularBuffer();
        CVideoBuffer->Initialize(VIDEO_BUFFER_SIZE * BUFFER_COUNT, 1);
        CVideoBuffer->Clear();

	    gSocketVideoPES = openPS(IPAddress, Port, vpid, apid, VIDEO_BUFFER_SIZE);
	    if (gSocketVideoPES < 0) 
            return(E_FAIL);

        CAudioBuffer=NULL;
        CMultiplexBuffer=NULL;
        }
    else
        return(E_FAIL);

	
    gfTerminateThread=FALSE;
	ghAVReadThread=_beginthread(AVReadThread , 0, NULL);
    SetThreadPriority((HANDLE)ghAVReadThread, THREAD_PRIORITY_ABOVE_NORMAL);
//    SetPriorityClass(GetCurrentProcess(),HIGH_PRIORITY_CLASS);


	return(NOERROR);
}

HRESULT InitStreaming(int vpid, int apid, char *IPAddress, int Port) 
{

    if (vpid>0)
        {
        CVideoBuffer=new CCircularBuffer();
        CVideoBuffer->Initialize(VIDEO_BUFFER_SIZE * BUFFER_COUNT, 1);
        CVideoBuffer->Clear();

	    gSocketVideoPES = openPES(IPAddress, Port, vpid, VIDEO_BUFFER_SIZE);
	    if (gSocketVideoPES < 0) 
            return(E_FAIL);
        }
    else
        {
        CVideoBuffer=NULL;
        gSocketVideoPES=0;
        }

    if (apid>0)
        {
        CAudioBuffer=new CCircularBuffer();
        CAudioBuffer->Initialize(AUDIO_BUFFER_SIZE * BUFFER_COUNT, 1);
        CAudioBuffer->Clear();

	    gSocketAudioPES = openPES(IPAddress, Port, apid, AUDIO_BUFFER_SIZE);
	    if (gSocketAudioPES < 0) 
            return(E_FAIL);
        }
    else
        {
        CAudioBuffer=NULL;
        gSocketAudioPES=0;
        }


    if ((apid>0)&&(vpid>0))
        {
        CMultiplexBuffer=new CCircularBuffer();
        CMultiplexBuffer->Initialize( (AUDIO_BUFFER_SIZE+VIDEO_BUFFER_SIZE) * BUFFER_COUNT, 1);
        CMultiplexBuffer->Clear();
        }
    else
        {
        CMultiplexBuffer=NULL;
        }


#if USE_REMUX
	CRemuxer= new Remuxer();
	CRemuxer->one_pts_per_gop = FALSE;
	CRemuxer->playtime_offset = 0.0;
    CRemuxer->system_clock_ref_start = CRemuxer->system_clock_ref;
    CRemuxer->total_bytes_written = 0;
    CRemuxer->m_framePTS=0;
    CRemuxer->perform_resync();		
    //gOutputFile=fopen("E:\\TEST_MUX.MPG","wb");
#endif
	
    gLastAVBitrateRequest=timeGetTime();
    gLastVideoDataCount=0;
    gLastAudioDataCount=0;
    gTotalVideoDataCount=0;
    gTotalAudioDataCount=0;

    gfThreadAborted=FALSE;
    gfTerminateThread=FALSE;
	ghAVReadThread=_beginthread(AVReadThread , 0, NULL);
    SetThreadPriority((HANDLE)ghAVReadThread, THREAD_PRIORITY_ABOVE_NORMAL);
//    SetPriorityClass(GetCurrentProcess(),HIGH_PRIORITY_CLASS);


	return(NOERROR);
}

