/*
This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

program: ggrabfe version 0.01 by Axel Buehning <mail at diemade.de>
*/

#include <stdlib.h>
#include <netdb.h>
#include <iostream>
#include <unistd.h>
#include <string.h>
#include <stdio.h>
#include <time.h>
#include <sys/socket.h>
#include <sys/wait.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <signal.h>
#ifdef __CYGWIN__
#include <cygwin/in.h>
#endif
#include "sserver.h"


#define BUFLEN 10240

void zapto (char *, int onidsid);
int AnalyzeXMLRequest(char *szXML, RecordingData   *rdata);

int main(int argc, char * argv[])
{
	RecordingData recdata;
	struct sockaddr_in  servaddr;
	struct sockaddr_in  dbox_addr;
	socklen_t 	    sock_len;
	int ListenSocket, ConnectionSocket;
	u_short Port = 4000;
	char buf[BUFLEN];
	int rc;
	int pid = 0;
	char * a_arg[50];
	char a_grabname[256];
	char a_dboxname[256];
	char a_vpid[20];
	char a_apid[20];
	int	i;

	a_arg[0] = a_grabname;
	a_arg[1] = "-p";
	a_arg[2] = a_vpid;
	a_arg[3] = a_apid;
	a_arg[4] = "-host";
	a_arg[5] = a_dboxname;
	a_arg[6] = "-nos";


	strcpy (a_grabname,argv[0]);
	if (strrchr(a_grabname,'/')){
		strcpy (strrchr(a_grabname,'/') + 1, "ggrab");
	}
	else {
		strcpy(a_grabname,"ggrab");
	}
#ifdef __CYGWIN__
	strcat(a_grabname,".exe");
#endif
	for (i = 1; i < argc; i++) {
		a_arg[i+6]=argv[i];
	}
	a_arg[i+6] = 0;
	
	//network-setup
	ListenSocket = socket(AF_INET, SOCK_STREAM, 0);
	memset(&servaddr, 0, sizeof(servaddr));
	servaddr.sin_family = AF_INET;
	servaddr.sin_addr.s_addr = htonl(INADDR_ANY);
	servaddr.sin_port = htons(Port);

	i = 0;
	while ((rc = bind(ListenSocket, (sockaddr *)&servaddr, sizeof(struct sockaddr_in))))
	{
		fprintf(stderr, "bind to port %d failed, RC=%d...\n",Port, rc);
		if (i == 10) {
			fprintf(stderr, "Giving up\n");
			exit(1);
		}
		fprintf(stderr, "%d. try, wait for 2 s\n",i++);
		sleep(2);
	}

	if (listen(ListenSocket, 5))
	{
		fprintf(stderr,"listen failed\n");
		exit(1);
	}
	printf("server startet\n");


	do
	{
		if((ConnectionSocket = accept(ListenSocket, (sockaddr *)(&dbox_addr), &sock_len)) == -1){
			fprintf(stderr,"accept failed\n");
			exit(1);
		}

		strcpy(a_dboxname,inet_ntoa(dbox_addr.sin_addr));

		do
		{
			rc = recv(ConnectionSocket, buf, BUFLEN, 0);
			if ((rc > 0))
			{
				AnalyzeXMLRequest(buf, &recdata);

				switch (recdata.cmd) 
				{
					case CMD_VCR_UNKNOWN:
						fprintf(stderr, "VCR_UNKNOWN NOT HANDLED\n");
						break;
					case CMD_VCR_RECORD:
						fprintf(stderr, "********************** START RECORDING **********************\n");
						fprintf(stderr, "ONIDSID     : %x\n", recdata.onidsid);
						fprintf(stderr, "APID        : %x\n", recdata.apid);
						fprintf(stderr, "VPID        : %x\n", recdata.vpid);
						fprintf(stderr, "CHANNELNAME : %s\n", recdata.channelname);
						fprintf(stderr, "***********************************************************\n");
						sprintf(a_vpid,"0x%03x",recdata.vpid);	
						sprintf(a_apid,"0x%03x",recdata.apid);
						// zapto (a_dboxname, recdata.onidsid); funktioniert noch nicht
						pid = fork();
						if (pid == -1) {
							fprintf(stderr, "fork process failed\n");
							break;
						}
						if (pid == 0) {
							execv (a_arg[0], a_arg);
							fprintf(stderr, "execv failed\n");
							exit(1);
						}
						break;
					case CMD_VCR_STOP:
						if (pid > 0) {
							if(kill(pid,SIGINT)) {
								printf ("ggrab process not killed\n");
							}
							waitpid(pid,0,0);
							fprintf(stderr,"\nStop recording\n");
						}
						break;
					case CMD_VCR_PAUSE:
						fprintf(stderr, "VCR_PAUSE NOT HANDLED\n");
						break;
					case CMD_VCR_RESUME:
						fprintf(stderr, "VCR_RESUME NOT HANDLED\n");
						break;
					case CMD_VCR_AVAILABLE:
						fprintf(stderr, "VCR_AVAIABLE NOT HANDLED\n");
						break;
					default:
						fprintf(stderr, "unknown VCR command\n");
						break;
				}
			}
		} while((rc > 0));
	} while (true);

	return 0;
}


/* Shameless stolen from TuxVision */
char* ParseForString(char *szStr, char *szSearch, int ptrToEnd)
{
    char *p=NULL;
    p=strstr(szStr, szSearch);
    if (p==NULL)
        return(NULL);
    if (!ptrToEnd)
        return(p);
    else
        return(p+strlen(szSearch));
    
}

char* ExtractQuotedString(char *szStr, char *szResult, int ptrToEnd)
{
    int i=0;
    int len=strlen(szStr);
    strcpy(szResult,"");
    for(i=0;i<len;i++)
        {
        if (szStr[i]=='\"')
            {
            char *pe=NULL;
            char *ps=szStr+i+1;      
            pe=ParseForString(ps, "\"", 1);
            if (pe==NULL)
                return(NULL);

            memcpy(szResult,ps, pe-ps-1);
            szResult[pe-ps-1]=0;                       
            if (ptrToEnd)
                return(pe);
            else
                return(ps);
            }
        }
    return(NULL);
}

int AnalyzeXMLRequest(char *szXML, RecordingData   *rdata)
{
    char *p1=NULL;
    char *p2=NULL;
    char *p3=NULL;
    char szcommand[264]="";
    char szonidsid[264]="";
    char szapid[264]="";
    char szvpid[264]="";
    char szchannelname[264]="";
    int hr=false;

    if ( (szXML==NULL) || (rdata==NULL) )
        return(false);

    rdata->apid=0;
    rdata->vpid=0;
    rdata->cmd=CMD_VCR_UNKNOWN;
    rdata->onidsid=0;
    strcpy(rdata->channelname,"");

    p1=ParseForString(szXML,"<record ", 1);
    if (p1!=NULL)
        {
        p2=ParseForString(p1,"command=", 1);
        p1=NULL;
        if (p2!=NULL)
            p3=ExtractQuotedString(p2, szcommand, 1);
        if (p3!=NULL)
            p1=ParseForString(p3,">", 1);
        }

    if (p1!=NULL)
        {
        p2=ParseForString(p1,"<channelname>", 1);
        p3=p2;
        p1=NULL;
        if (p2!=NULL)
            {
            p1=ParseForString(p2,"</channelname>", 0);
            if (p1!=NULL)
                {
                memcpy(szchannelname,p3,p1-p3);
                szchannelname[p1-p3]=0;
                hr=true;
                }
            }
        }

    if (p1!=NULL)
        {
        p2=ParseForString(p1,"<onidsid>", 1);
        p3=p2;
        p1=NULL;
        if (p2!=NULL)
            {
            p1=ParseForString(p2,"</onidsid>", 0);
            if (p1!=NULL)
                {
                memcpy(szonidsid,p3,p1-p3);
                szonidsid[p1-p3]=0;
                hr=true;
                }
            }
        }
    
    p2=ParseForString(szXML,"<videopid>", 1);
    if (p2!=NULL)
        {
        p3=p2;
        p1=NULL;
        p1=ParseForString(p2,"</videopid>", 0);
        if (p1!=NULL)
            {
            memcpy(szvpid,p3,p1-p3);
            szvpid[p1-p3]=0;
            hr=true;
            }
        }

    p2=ParseForString(szXML,"<audiopids selected=", 1);
    if (p2!=NULL)
        {
        p3=ExtractQuotedString(p2, szapid, 1);
        if (p3!=NULL)
            p1=ParseForString(p3,">", 1);
        }

    if (!hr)
        return(hr);

    strcpy(rdata->channelname, szchannelname);

    if (strlen(szvpid)>0)
        rdata->vpid=atoi(szvpid);

    if (strlen(szapid)>0)
        rdata->apid=atoi(szapid);

    if (!strcmp(szcommand,"record"))
        rdata->cmd=CMD_VCR_RECORD;
    if (!strcmp(szcommand,"stop"))
        rdata->cmd=CMD_VCR_STOP;
    if (!strcmp(szcommand,"pause"))
        rdata->cmd=CMD_VCR_PAUSE;
    if (!strcmp(szcommand,"resume"))
        rdata->cmd=CMD_VCR_RESUME;
    if (!strcmp(szcommand,"available"))
        rdata->cmd=CMD_VCR_AVAILABLE;

    rdata->onidsid=atol(szonidsid);

    return(hr);
}


void zapto(char * p_dboxname, int onidsid) {

	int r;
	struct hostent * hp = gethostbyname(p_dboxname);
		
	struct sockaddr_in adr;

	
	memset ((char *)&adr, 0, sizeof(struct sockaddr_in));
				
   	if (hp == 0) {
		fprintf(stderr,"unable to lookup hostname");
		exit(1);
	}
		         
	adr.sin_family = AF_INET;
	adr.sin_addr.s_addr = ((struct in_addr *)(hp->h_addr))->s_addr;
	adr.sin_port = htons(80);
		
   	if (adr.sin_addr.s_addr == 0) {
		fprintf(stderr,"unable to lookup hostname");
		exit(1);
	}
		         
	int sock = socket(AF_INET, SOCK_STREAM, 0);
	
	if (-1 == connect(sock, (sockaddr*)&adr, sizeof(struct sockaddr_in))) {
		close(sock);
		fprintf(stderr,"error to connect to socket");
		exit(1);
	}
	
	char buffer[100];	
	sprintf(buffer, "GET /control/zapto?%d HTTP/1.0\r\n\r\n",onidsid);
	
	write(sock, buffer, strlen(buffer));

	sleep(1);
	r=read(sock, buffer, 100);
	buffer[r]=0;
	fprintf(stderr, buffer);
	close (sock);

}
