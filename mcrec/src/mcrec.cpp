// vim:ts=4:sw=4:ai:sc:
// ####################################################################
//
// Musicchoice-Recorder for Tuxbox users
//
// see README for details on who-wrote-what within this software
//
// ####################################################################

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

#define VERSION "0.18beta"

#include "SigHandler.h"
#include "Remuxer.h"
#include "StopWatch.h"
#include "SongDB.h"


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <unistd.h>
#include <sys/poll.h>

#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>

#include <sched.h>
#include <sys/mman.h>

#include <ctype.h>
#include <pthread.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

// ####################################################################

#define AUDIO_BUF_SIZE ( 0x0800)
#define AUX_BUF_SIZE   (   0x20)

#define ALIGN4(x) ( (((long)(x)) +2) & (~0x3) )

// ####################################################################

class AVBuf {
public:

	pthread_mutex_t mutex;
	
	bool resync; // if packets were lost before this buffer, resync is set to true;
	
	unsigned long audio_valid;
	unsigned long aux_valid;
	
	unsigned char audio[AUDIO_BUF_SIZE];
	unsigned char aux  [AUX_BUF_SIZE];
	
	void clear(void) {
		resync = false;
		audio_valid = 0;
		aux_valid = 0;
	}
	
	bool is_used(void) const {
		if (audio_valid || aux_valid || resync) return true;
		return false;
	}
	
	AVBuf(void) {
		pthread_mutex_init(&mutex, 0);
		clear();
	}
	
};

// ####################################################################
// data shared between main and reader thread:

unsigned long num_avbufs;
AVBuf * avbufs;

volatile long new_read_size_audio = AUDIO_BUF_SIZE/2; // full for AC3, half for MPEG audio...

int nice_increment;
bool no_rt_prio;

volatile bool thread_started;

volatile bool terminate_avread_thread;

volatile bool avread_thread_failed;
volatile bool avread_thread_ended;

volatile bool new_display_available = false;

pthread_t avrthread;

// ######## MASH bla
// yes there are a lot of ugly globals;-) I don't care! Do you?

volatile bool sinfthread_started, sinfthread_ended;
pthread_t sinfthread = 0;
char *progname = NULL;
char *dbprogname = NULL;
char *urlbuffer;
char *urlbufptr;
const char *dbox2name = NULL;
char *dbox2str = NULL;
Remuxer remuxer;
char *fname_output = "mcrec_";      // default output filename stem
char *basefilename = NULL;
char *basedir = NULL;
char *mchost = "localhost";
char *mcbaseurl = "/";
char *mcurlext = ".html";
char *extension = NULL;
char *proxy = NULL;
int proxyport = 0;
bool log2file = false;
FILE *logfile;
bool debug = false;
bool rmdub = false;
bool usedb = false;
bool epg = true;
bool disableminhack = false;
bool ignore_sync = true;
int udpport = 0;
int udpsock = -1;
int plsum = 0;
int packetloss;
int pnr;
int moption = 0;
char recvbuf[1500];
char *p_act;
int rest;

#define SONGDBNAME "mcrec.songdb"
SongDB *mcrecsongdb;

#define MAXTAG 25
#define MAXTAGDATA 100

// songinfo structure holds all the data from musicchoice EPG
// fetched == true if EPG was requested for current song
// valid == true if EPG was received successfully
struct songinfo {
	bool fetched;
	bool valid;
	char track[MAXTAGDATA];
	char artist1[MAXTAGDATA];
	char artist2[MAXTAGDATA];
	char album[MAXTAGDATA];
	char year[MAXTAGDATA];
	char label[MAXTAGDATA];
} mysonginfo;

//ID3v1.1 structure
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

void logprintf(const char *fmt, ...);

// ####################################################################
// network reading functions for Linux on dbox2 by Felix Domke,
// some modifications by Peter Niemayer

int dvb_audio_pes;

int openPES(const char * name, unsigned short port, int pid, int udpport, int *udpsock)
{
	if (udpport)
		logprintf("opening %s:%d PID 0x%x via UDP port %d\n", name, (int)port, pid, udpport);
	else
		logprintf("opening %s:%d PID 0x%x via TCP\n", name, (int)port, pid);
	
	struct hostent * hp = gethostbyname(name);
		
	struct sockaddr_in adr;
	memset ((char *)&adr, 0, sizeof(struct sockaddr_in));
				
	*udpsock = 0;
	if (udpport)
	{
		*udpsock = socket(AF_INET, SOCK_DGRAM, 0);
		memset(&adr, 0, sizeof(adr));
		adr.sin_family = AF_INET;
		adr.sin_addr.s_addr = htonl(INADDR_ANY);
		adr.sin_port = htons(udpport);
		bind(*udpsock, (sockaddr *)&adr, sizeof(struct sockaddr_in));
	}
		
	adr.sin_family = AF_INET;
	adr.sin_addr.s_addr = ((struct in_addr *)(hp->h_addr))->s_addr;
	adr.sin_port = htons(port);
		
	if (adr.sin_addr.s_addr == 0) {
		logprintf("unable to lookup hostname");
		return -1;
	}
		         
	int sock = socket(AF_INET, SOCK_STREAM, 0);
	
	if (-1 == connect(sock, (sockaddr*)&adr, sizeof(struct sockaddr_in))) {
		perror("connect");
		close(sock);
		return -1;
	}
	
	char buffer[100];		
	if (udpport)
	{
		sprintf(buffer, "GET /%x,%d HTTP/1.0\r\n\r\n", pid, udpport);
	}
	else
	{
		sprintf(buffer, "GET /%x HTTP/1.0\r\n\r\n", pid);
	}
	write(sock, buffer, strlen(buffer));
	
	return sock;
}

int readPES(int fd, unsigned char *buffer, int len)
{
// Note from Peter to Felix: I better don't touch your code here,
// but it looks dirty: You better check errno==EINTR and try
// again when this was the cause for read() returning early.
// Furthermore: Wouldn't a non-block read be better, here?

	int left=len;
	int r=0;
	unsigned char *buf=buffer;
	//int tries=3;
	if (udpport)
	{
		if (!rest)
		{
			if (len > 1500)
			{
				r = recv(fd, buf, left, 0);
				if (r > 0)
					r -= 4;
				packetloss = pnr++ - ntohl(*((int *)(buffer + r)));
				plsum += packetloss;
			}
			else
			{
				rest = recv(fd, recvbuf, 1500, 0);
				if (rest > 0)
					rest -= 4;
				packetloss = pnr++ - ntohl(*((int *)(recvbuf + rest)));
				p_act = recvbuf;
			}
		}
		if (rest)
		{
			if (rest > 0)
			{
				r = rest > len ? len : rest;
				memcpy (buffer, p_act, r);
				rest  -= r;
				p_act += r;
			}
			else
			{
				r = rest;
				rest = 0;
			}
		}
				
//		fprintf(stderr, "%d: %d,%d\n", pnr, r, left);

		return r;
	}
	else
	{
		while (left>0)
		{
			r=read(fd, buf, left);
			if (r<=0)
				return r;
			buf+=r;
			left-=r;

			if (r<1000)
				break;
		}
		return len-left;
	}
}


// ####################################################################
// AV reader thread for dbox2 / EtherNet

void * AVReadThreadDBox2(void * thread_arg)
{
#ifndef __CYGWIN__
	if (mlockall(MCL_CURRENT | MCL_FUTURE))
		fprintf(stderr, "WARNING: unable to lock memory. Swapping may disturb the avread_thread\n");
#endif

	bool rt_enabled = false;
	if (!no_rt_prio)
	{
		struct sched_param sp;
			
		sp.sched_priority = sched_get_priority_max(SCHED_FIFO);
		if (pthread_setschedparam(avrthread, SCHED_FIFO, &sp) < 0)
		{
			fprintf(stderr, "WARNING: cannot enable real-time scheduling - will try to renice\n");
		}
		else
			rt_enabled = true;
	}
	if (!rt_enabled)
		if (::nice(nice_increment))
			fprintf(stderr,"WARNING: avread_thread cannot change nice level - continuing\n");

	// ---------------------------

#ifndef __CYGWIN__	
	sigset_t newmask;
	sigemptyset(&newmask);
	sigaddset(&newmask, SIGINT);
	sigaddset(&newmask, SIGTERM);
	sigaddset(&newmask, SIGHUP);
	sigaddset(&newmask, SIGUSR1);
	sigaddset(&newmask, SIGUSR2);
	
	if (pthread_sigmask(SIG_BLOCK, &newmask, 0))
	{
		fprintf(stderr,"cannot block signals\n");
		avread_thread_failed = true;
		avread_thread_ended = true;
		return NULL;
	}
#endif	

	// ---------------------------
	
	// ---------------------------
	
	struct pollfd pollfds[1];
	if (udpport)
		pollfds[0].fd = udpsock;
	else
		pollfds[0].fd = dvb_audio_pes;
	pollfds[0].events = POLLIN;
	
	long read_size_audio = new_read_size_audio;
	
	
	// ---------------------------
	
	unsigned long rec_idx = 0; // avbuf to use next
	
	pthread_mutex_lock(& avbufs[rec_idx].mutex); // lock mutex for avbuf to use next
	
	thread_started = true;
	
	avbufs[rec_idx].clear();
	avbufs[rec_idx].resync = true; // always a new start at the beginning..

	// ##############################################

	
	time_t last_second = 0;
	
	bool up_to_current = false;
	
	for (;;)
	{
				
		if (terminate_avread_thread)
			break;
		
		StopWatch poll_timer;
		int pres = ::poll(pollfds, 1, 100);
		if (pres < 0)
		{
			if (errno == EINTR)
				continue;
			logprintf("poll failed\n");
			avread_thread_failed = true;
			avread_thread_ended = true;
			return NULL;			
		}
		if (poll_timer.stop() > 10)
			up_to_current = true;
		
		if (pollfds[0].revents & POLLIN)
		{
			if (udpport)
				read_size_audio = readPES(udpsock, avbufs[rec_idx].audio, new_read_size_audio);
			else
				read_size_audio = readPES(dvb_audio_pes, avbufs[rec_idx].audio, new_read_size_audio);
			if (read_size_audio <= 0)
			{
				logprintf("receive audio failed\n");
				avread_thread_failed = true;
				avread_thread_ended = true;
				return NULL;
			}
			
			if (up_to_current)
				avbufs[rec_idx].audio_valid = read_size_audio;
		}


		// polls done, look for avbufs to pass

		if ( avbufs[rec_idx].audio_valid )
		{
			// ok, get the next avbuf and release the current one (that is filled)

			unsigned long next_idx = rec_idx + 1;
			if (next_idx >= num_avbufs)
				next_idx = 0;

			if (pthread_mutex_trylock(& avbufs[next_idx].mutex))
			{
				logprintf("WARNING: avbuf overrun, lost data: %ld audio\n",
						  avbufs[rec_idx].audio_valid);

				// we have to stay with the current buffer :-(
				avbufs[rec_idx].clear();
				avbufs[rec_idx].resync = true;
			}
			else
			{
				// we could get the last buffer - check whether it is unused

				if (avbufs[next_idx].is_used())
				{
					pthread_mutex_unlock(& avbufs[next_idx].mutex);

					logprintf("WARNING: avbuf overrun, lost data: %ld aux %ld audio\n",
							  avbufs[rec_idx].aux_valid,
							  avbufs[rec_idx].audio_valid);

					// we have to stay with the current buffer :-(
					avbufs[rec_idx].clear();
					avbufs[rec_idx].resync = true;
				}
				else
				{					
					// let's release our last one and use the new one, now...
					pthread_mutex_unlock(& avbufs[rec_idx].mutex);
					rec_idx = next_idx;
				}
			}
		}
		
		time_t now = time(0);
		if (now != last_second)
		{
			last_second = now;
		}
		
		// end of thread main loop, here
	}
	
	// waiting for the last requests to be answered isn't sensible for dbox2 network read...		
	
	pthread_mutex_unlock(& avbufs[rec_idx].mutex);
	// fprintf(stderr, "AVReadThread terminating normally\n");
		
	avread_thread_ended = true;
	
	//_exit(0);
	return 0;
}

//#######
//####### MASH routines
//#######

//### logprintf writes to stderr and to logfile if set
//###

void logprintf(const char *fmt, ...)
{
	va_list ap;
	
	va_start(ap, fmt);
	vfprintf(stderr, fmt, ap);
	if (logfile) vfprintf(logfile, fmt, ap);
	va_end(ap);
}

//### getsimpleURL generic function for requesting URLs from <host>
//### URL must include full request (eg: "GET / HTTP/1.0\r\n\r\n")
//### returns empty buffer on error or complete response including headers
//### caller must free the returnd buffer!!

char * getsimpleURL(const char * host, const char * URL, int mcport)
{
	struct hostent *ptrh;
	struct protoent *ptrp;
	struct sockaddr_in sad;
	int sd;
	int port;
	int n;
	int bufsize, offset = 0;
	char *buffer;

	// initial buffersize = 2050
	bufsize = 2050;
	buffer = (char *)malloc(bufsize);

	char *urlbufptr = buffer;
	*buffer = '\0';

	// usual socket, connect bla
	memset((char *)&sad, 0, sizeof(sad));
	sad.sin_family = AF_INET;

	port = mcport;
	sad.sin_port = htons((u_short)port);

	ptrh = gethostbyname(host);
	if (!ptrh) return(buffer);
	memcpy(&sad.sin_addr, ptrh->h_addr, ptrh->h_length);

	ptrp = getprotobyname("tcp");
	if (!ptrp) return(buffer);

	sd = socket(PF_INET, SOCK_STREAM, ptrp->p_proto);
	if (connect(sd, (struct sockaddr *)&sad, sizeof(sad)) == 0)
	{
		// send request
		write(sd, URL, strlen(URL));

		// and receive max first 1024 byte
		n = recv(sd, buffer, 1024, 0);

		offset += n;
		while (n > 0)
		{
			//increase buffersize by count of received bytes
			bufsize += n;
			//and realloc buffer
			buffer = (char *)realloc(buffer, bufsize);
			urlbufptr = buffer + offset;

			//and get some more stuff
			n = recv(sd, urlbufptr, 1024, 0);
			offset += n;
		}
		close(sd);
		urlbufptr = buffer + offset;
		*urlbufptr = '\0';
	}

	urlbufptr = buffer + 9;			//position of HTTP responsecode

	//was the response code "200" -> if not return empty buffer
	if (strncmp(urlbufptr, "200", 3) != 0)
		*buffer = '\0';

	return(buffer);
}

char * getURL(const char * host, const char * URL)
{
	return(getsimpleURL(host, URL, 80));
}

char * getmcURL(const char * host, const char * URL)
{
	int tmpsize;
	char *tmpURL;
	char *rc;

	tmpsize = strlen(host) + strlen(URL) + 100;
	tmpURL = (char *)malloc(tmpsize);
	
	if (proxy)
	{
		strcpy(tmpURL, "GET http://");
		strcat(tmpURL, host);
		strcat(tmpURL, URL);
		strcat(tmpURL, " HTTP/1.0\r\nPragma: no-cache\r\nCache-Control: no-cache, max-age=0\r\n\r\n");
		rc = getsimpleURL(proxy, tmpURL, proxyport);
	}
	else
	{
		strcpy(tmpURL, "GET ");
		strcat(tmpURL, URL);
		strcat(tmpURL, " HTTP/1.0\r\nHost: ");
		strcat(tmpURL, host);
		strcat(tmpURL, "\r\n\r\n");
		rc = getsimpleURL(host, tmpURL, 80);
	}
	free(tmpURL);
	return(rc);
}

//### getDBox2Channel fetches info about running channel
//###                 and tries to find it in "mcrec.prog" to build the EPG-URL
//###                 finally it returns the apid for the current channel

int getDBox2Channel(const char * dbox2name)
{
	char *progptr;
	char *eolptr;
	int apid;
	char *urlbuffer;
	char *urlbufptr;
	char *copyptr;
	char *progidstr;
	FILE *progfile;
	size_t rs;
	struct stat mcstat;

	logprintf("requesting current program ID...");

	urlbuffer = getURL(dbox2name, "GET /control/zapto HTTP/1.0\r\n\r\n");

	if(*urlbuffer == '\0')
	{
		logprintf("unable to connect to dbox\n");
		exit(0);
	}

	if ((urlbufptr = strstr(urlbuffer, "\r\n\r\n")) == NULL)
	{
		logprintf("end of HTTP-Headers not found!\n");
		exit(0);
	}
	urlbufptr += 4;

	if ((eolptr = strstr((const char *) urlbufptr, "\n")) == NULL)
	{
		logprintf("can't find requested data in answer!\n");
		exit(0);
	}
	progidstr = (char *)malloc(eolptr - urlbufptr + 3);
	copyptr = progidstr;
	*copyptr++ = '\n';
	while (urlbufptr < eolptr)
		*copyptr++ = *urlbufptr++;
	*copyptr++ = ' ';
	*copyptr = '\0';

	logprintf("got: %s\n", progidstr+1);
	free(urlbuffer);

	urlbuffer = getURL(dbox2name, "GET /control/channellist HTTP/1.0\r\n\r\n");

	if ((urlbufptr = strstr(urlbuffer, "\r\n\r\n")) == NULL)
	{
		logprintf("end of HTTP-Headers not found!\n");
		exit(0);
	}
	urlbufptr += 3;

	if ((progptr = strstr((const char *)urlbufptr, progidstr)) == NULL)
	{
		logprintf("progid not found in channellist!\n");
		exit(0);
	}
	progptr += strlen(progidstr);
	eolptr = strstr((const char *) progptr, "\n");
	dbprogname = (char *)malloc(eolptr - progptr + 1);
	copyptr = dbprogname;
	while(progptr < eolptr)
		*copyptr++ = *progptr++;
	while (*(copyptr-1) == ' ')
		copyptr--;
	*copyptr = '\0';

	free(urlbuffer);

	logprintf("channel name: %s ...searching URL-database...\n", dbprogname);

	if ((stat("mcrec.progs", &mcstat) == 0) &&
		((progfile = fopen("mcrec.progs", "r")) != NULL))
	{
		urlbuffer = (char *)malloc(mcstat.st_size + 1);

		rs = fread(urlbuffer, 1, mcstat.st_size, progfile);
		urlbuffer[rs] = '\0';
		if ((urlbufptr = strstr(urlbuffer, dbprogname)) != NULL)
		{
			urlbufptr = strstr(urlbufptr, "=");
			urlbufptr++;
			if((eolptr = strstr(urlbufptr, "\n")) != NULL)
				*eolptr = '\0';
			progname = (char *)malloc(eolptr - urlbufptr + 1);
			strcpy(progname, urlbufptr);
		}
		else
		{
			logprintf("channel not found in mcrec.progs!\nNo EPG available\n");
		}
		fclose(progfile);
		free(urlbuffer);
	}
	else
	{
		logprintf("mcrec.progs not found!\n");
		exit(0);
	}
	if (progname)
		logprintf("musicchoice EPG-URL: /EPG/%s.shtml\n", progname);

	urlbuffer = getURL(dbox2name, "GET /control/zapto?getpids HTTP/1.0\r\n\r\n");

	if ((urlbufptr = strstr(urlbuffer, "\r\n\r\n")) == NULL)
	{
		logprintf("end of HTTP-Headers not found!\n");
		exit(0);
	}
	urlbufptr += 4;

	if ((urlbufptr = strstr(urlbufptr, "\n")) == NULL)
	{
		logprintf("requested data not found!\n");
		exit(0);
	}
	urlbufptr++;
	sscanf (urlbufptr, "%d", &apid);
	logprintf("selected apid: 0x%x\n", apid);

	free(urlbuffer);
	free(progidstr);

	return(apid);
}

//### build mc-URL from apid
//### currently not used!
void soption2url(int search)
{
	char *eolptr;
	char *urlbuffer;
	char *urlbufptr;
	FILE *pidfile;
	size_t rs;
	struct stat mcstat;
	char searchstr[20];
	
	sprintf (searchstr, "0x%08x", search);
	logprintf("tsidapid: %s ...searching URL-database...\n", searchstr);

	if ((stat("mcrec.pids", &mcstat) == 0) &&
		((pidfile = fopen("mcrec.pids", "r")) != NULL))
	{
		urlbuffer = (char *)malloc(mcstat.st_size + 1);

		rs = fread(urlbuffer, 1, mcstat.st_size, pidfile);
		urlbuffer[rs] = '\0';
		if ((urlbufptr = strstr(urlbuffer, searchstr)) != NULL)
		{
			urlbufptr = strstr(urlbufptr, "=");
			urlbufptr++;
			if((eolptr = strstr(urlbufptr, "\n")) != NULL)
				*eolptr = '\0';
			progname = (char *)malloc(eolptr - urlbufptr + 1);
			strcpy(progname, urlbufptr);
		}
		else
		{
			logprintf("channel not found in mcrec.pids!\nNo EPG available\n");
		}
		fclose(pidfile);
		free(urlbuffer);
	}
	else
	{
		logprintf("mcrec.pids not found!\n");
		exit(0);
	}
	if (progname)
		logprintf("musicchoice EPG-URL: /EPG/%s.shtml\n", progname);

}

//### switchchannel does what it's name suggests

int switchchannel(const char *dbox2name, int channel)
{
	char *urlbuffer, *urlptr, *helpptr;
	int i, rc = 0;
	unsigned long long chid;
	char *channelname;
	char switchreq[100];

	urlbuffer = getURL(dbox2name, "GET /control/channellist HTTP/1.0\r\n\r\n");

	if ((urlptr = strstr(urlbuffer, "\r\n\r\n")) == NULL)
	{
		logprintf("end of HTTP-Headers not found!\n");
		exit(0);
	}
	urlptr += 4;

	channel--;

	for(i = 0; i < channel; i++)
	{	
		if (urlptr)
		{
			if ((urlptr = strchr(urlptr, '\n')) != NULL)
				urlptr++;
		}
	}

	if (urlptr)
	{
		if ((helpptr = strchr(urlptr, '\n')))
			*helpptr = '\0';
		helpptr = strchr(urlptr, ' ');
		helpptr++;
		channelname = helpptr;
		sscanf(urlptr, "%llx", &chid);
		logprintf("trying to switch to %s ... ", channelname);
		snprintf(switchreq,
			 sizeof(switchreq),
			 "GET /control/zapto?0x%llx HTTP/1.0\r\n\r\n",
			 chid);
		helpptr = getURL(dbox2name, switchreq);
		if (strstr(helpptr, "ok"))
			logprintf("done.\n");
		else
		{
			logprintf("failed.\n");
			rc = 1;
		}
		if (helpptr)
			free(helpptr);
	}
	else
	{
		logprintf("channelswitching failed!\n");
		rc = 1;
	}
	
	if (urlbuffer)
		free(urlbuffer);
	return(rc);
}

//### decode_string decode the &#<num>; stuff to regular chars...hopefully;-)
//###               currently only code 180 is known

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

//## dbox2msg is responsible for displaying info on TV
//##          msg wird zuvor (soweit bekannt) urlencoded

void dbox2msg(const char *msg)
{
	char *realmsg;
	char *kmsg;
	char *dummybuf;

	realmsg = (char *)malloc(strlen(msg) * 3);

	strcpy(realmsg, "GET /control/message?nmsg=");
	kmsg = realmsg + strlen(realmsg);

	while(*msg != '\0')
	{
		switch(*msg)
		{
			case ' ':	*kmsg++ = '%';
						*kmsg++ = '2';
						*kmsg++ = '0';
						break;
			case '\n':	*kmsg++ = '%';
						*kmsg++ = '0';
						*kmsg++ = 'A';
						break;
			case '&':	*kmsg++ = '%';
						*kmsg++ = '2';
						*kmsg++ = '6';
						break;
			default:	*kmsg++ = *msg;
		}
		msg++;
	}
	*kmsg = '\0';
	strcat(realmsg, " HTTP/1.0\r\n\r\n");

	dummybuf = getURL(dbox2name, realmsg);
	free(dummybuf);
	free(realmsg);
}
	
//### songinfo_thread fetches the EPG from musicchoice.co.uk
//###                 fills songinfo struct and id3 info
//###                 and finally displays it on TV

void * songinfo_thread(void * thread_arg)
{
	char *mcURL;
	char tag[MAXTAG];
	char *cpptr;
	char *tagptr;
	char tagdata[MAXTAGDATA];
	char msg[1000];
	char *urlbufptr;
	char *urlbuffer;
	int i, reqlen, slp = 5;
	bool gotnew, getmsgdisplayed = false;
	const char * getmsg = "fetching songinfo\nplease stand by...\n\n\n\n\n\n\n";
	
	//do not block thread_signals on Cygwin. doesn't work there
#ifndef __CYGWIN__
	sigset_t newmask;
	sigemptyset(&newmask);
	sigaddset(&newmask, SIGINT);
	sigaddset(&newmask, SIGTERM);
	sigaddset(&newmask, SIGHUP);
	sigaddset(&newmask, SIGUSR1);
	sigaddset(&newmask, SIGUSR2);
	
	if (pthread_sigmask(SIG_BLOCK, &newmask, 0)) {
		fprintf(stderr,"cannot block signals\n");
		avread_thread_failed = true;
		avread_thread_ended = true;
		return NULL;
	}
#endif	

	// ---------------------------

	sinfthread_started = true;

	sleep(1);

	//allocate request and build it
	reqlen = strlen(mchost) + strlen(mcbaseurl) + strlen(progname) + 
			 strlen(mcurlext) + 25;
	mcURL = (char *)malloc(reqlen);

	strcpy(mcURL, mcbaseurl);
	strcat(mcURL, progname);
	strcat(mcURL, mcurlext);

//	fprintf(stderr, "%s, %s", mchost, mcURL);

	//try as long as needed
	while(!mysonginfo.valid)
	{
		urlbuffer = getmcURL(mchost, mcURL);

		if (*urlbuffer == '\0')
		{
			logprintf("unable to fetch EPG...retrying            \n");
			if ((!getmsgdisplayed) && (!moption))
			{
				dbox2msg(getmsg);
				getmsgdisplayed = true;
			}
			sleep(slp);
			if (slp < 30) 
				slp += 5;
			continue;
		}

//		fprintf(stderr, "%s", urlbuffer);
		urlbufptr = urlbuffer;
		gotnew = true;

		while(true)
		{
			//parse HTML-response for wanted data
			//first search the div id tags
			if ((urlbufptr = strstr(urlbufptr, "div id")) == NULL)
				break;

			//then extract name of tag
			urlbufptr += 8;
			tagptr = tag;
			for (cpptr = urlbufptr, i = 0; *cpptr != '\"'; cpptr++, i++)
			{
				if (i < MAXTAG-1)
					*tagptr++ = *cpptr;
			}
			*tagptr = '\0';

			//and then the tagdata
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

			//now look what we got and store it
			if (strcmp(tag, "track") == 0)
			{
				//except we got the same as before
				if (strcmp(tagdata, mysonginfo.track) == 0)
				{
					if ((!getmsgdisplayed) && (!moption))
					{
						dbox2msg(getmsg);
						getmsgdisplayed = true;
					}
					logprintf("EPG not updated yet...waiting...           \n");
					sleep(slp);
					if (slp < 30) 
						slp += 5;
					gotnew = false;

					//set fetched again to avoid immediate restart of songinfo_thread
					mysonginfo.fetched = true;
					continue;
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
		free(urlbuffer);

		if (!gotnew)
			continue;

		//set ID3 data
		id3.tag[0] = 'T';
		id3.tag[1] = 'A';
		id3.tag[2] = 'G';
		memset(id3.songname,0,sizeof(id3.songname));
		strncpy(id3.songname, mysonginfo.track, sizeof(id3.songname));

		memset(id3.artist,0,sizeof(id3.artist));
		strncpy(id3.artist, mysonginfo.artist1, sizeof(id3.artist));
		
		memset(id3.album,0,sizeof(id3.album));
		strncpy(id3.album, mysonginfo.album, sizeof(id3.album));
		
		memset(id3.year,0,sizeof(id3.year));
		strncpy(id3.year, mysonginfo.year, sizeof(id3.year));
		
		memset(id3.comment,0,sizeof(id3.comment));
		strncpy(id3.comment, mysonginfo.label, sizeof(id3.comment));

		id3.empty = '\0';
		id3.tracknum = '\0';
		id3.genre = (unsigned char)0xFF;

		//log it
		logprintf("\ntrack:   %s\n", mysonginfo.track);
		logprintf("artist1: %s\n", mysonginfo.artist1);
		logprintf("artist2: %s\n", mysonginfo.artist2);
		logprintf("album:   %s\n", mysonginfo.album);
		logprintf("label:   %s\n", mysonginfo.label);
		logprintf("year:    %s\n", mysonginfo.year);

		if (!moption)
		{
			//and display it on TV
			strcpy(msg, "currently playing on ");
			strcat(msg, dbprogname);
			strcat(msg, "\nartist:   "); 
			strcat(msg, mysonginfo.artist1);
			if (strlen(mysonginfo.artist2) > 0)
			{
				strcat(msg, "\n            ");
				strcat(msg, mysonginfo.artist2);
			}
			strcat(msg, "\ntrack:   ");
			strcat(msg, mysonginfo.track);
			strcat(msg, "\nalbum:  ");
			strcat(msg, mysonginfo.album);
			strcat(msg, "\nlabel:    ");
			strcat(msg, mysonginfo.label);
			if (strlen(mysonginfo.year) > 0)
			{
				strcat(msg, "\nyear:    ");
				strcat(msg, mysonginfo.year);
			}
			else
				strcat(msg, "\n");
			if (strlen(mysonginfo.artist2) == 0)
				strcat(msg, "\n");
			if(!remuxer.mpp_started)
				strcat(msg, "\n\nwaiting for next sync...");
			else
				strcat(msg, "\n\nRECORDING!");

			dbox2msg(msg);
		}
		mysonginfo.valid = true;
	}
	free(mcURL);

	sinfthread_started = false;
	sinfthread_ended = true;
	return(0);
}

//### get_song_info launches the song_info_thread
//###

void get_song_info()
{

	if ((epg) && (!sinfthread) && (progname))
	{
		sinfthread_started = false;
		sinfthread_ended = false;
//		pthread_attr_t sinfthread_attr;
//		pthread_attr_setdetachstate(&sinfthread_attr, PTHREAD_CREATE_DETACHED);

		mysonginfo.fetched = true;
		mysonginfo.valid = false;

		pthread_create(&sinfthread, 0, songinfo_thread, 0);
	}
	else
		if (!epg)
		{
			mysonginfo.fetched = true;
			logprintf("EPG disabled by option!\n");
		}
}

//### replacecritchars replaces characters not usable for filenames

void replacecritchars(char *workstring)
{
	char *ptr;
	ptr = workstring;
	while (*ptr != '\0')
	{
		switch(*ptr)
		{
			case '?':
			case '*':
			case '\\':
			case '/': 	*ptr = '_';
						break;

			case '"':	*ptr = '\'';
						break;
		}
		ptr++;
	}
}


//### finish_file does all this fancy filename setting, moving, removing stuff
//###

void finish_file(char * filename)
{
	FILE *song;
	char *newname, *newfile, *dbname;
	struct stat mcstat;
	int namelen, filelen;
	int i;
	char filenum[4];
	int currfs;

	if (mysonginfo.valid)
	{
		namelen = strlen(mysonginfo.artist1) + strlen(mysonginfo.track) +
					strlen(extension) + 5;
		newfile = (char *)malloc(namelen);

		filelen = strlen(basedir) + strlen(progname) + namelen + 21;
		newname = (char *)malloc(filelen);

		strcpy(newname, basedir);
		strcat(newname, "finished/");
		if (stat(newname, &mcstat) != 0)
			mkdir(newname, 0777);
		strcat(newname, progname);
        if (stat(newname, &mcstat) != 0)
            mkdir(newname, 0777);

		strcat(newname, "/");

		strcpy(newfile, mysonginfo.artist1);
		strcat(newfile, " - ");
		strcat(newfile, mysonginfo.track);
		dbname = strdup(newfile);
		strcat(newfile, ".");
		strcat(newfile, extension);

		replacecritchars(newfile);
		strcat(newname, newfile);

		song = fopen(filename, "a");
		fwrite(&id3, sizeof(id3), 1, song);
		fclose(song);

		stat(filename, &mcstat);
		currfs = mcstat.st_size;

		if (usedb)
		{
			if (mcrecsongdb->searchentry(dbname, currfs))
			{
				logprintf("file already in recorddb.\n removing file: %s\n",newname);
				unlink(filename);
				free(dbname);
				free(newname);
				free(newfile);
				return;
			}
			else
				mcrecsongdb->addentry(dbname, currfs);
		}
		free(dbname);
		
		if (stat(newname, &mcstat) == 0)
		{
			if ((rmdub) && (currfs == mcstat.st_size))
			{
				logprintf("file of same name and size found.\nremoving dublicate: %s\n",newname);
				unlink(filename);
				free(newname);
				free(newfile);
				return;
			}
			newname[strlen(newname)-4] = '\0';
			i = 1;
			while(true)
			{
				sprintf(filenum, "_%02d", i);
				strcat(newname, filenum);
				strcat(newname, ".mp2");
				if (stat(newname, &mcstat) != 0)
					break;
				else
				{
					if (++i > 99)
					{
						logprintf("too much copies of song. can't rename: %s\n",newname);
						return;
					}
					newname[strlen(newname)-7] = '\0';
				}
			}
		}

		logprintf("finished recording...\nmoving file to: %s\n", newname);

		rename(filename, newname);
		free(newname);
		free(newfile);
	}
}

//### readrcfile gets defaults from mcrec.rc
//###

void readrcfile()
{
	FILE * rcfile;
	char * config;
	int	size;
	char * parm;
	char * parmdata;
	char * parmptr, * copyptr;
	char * rcptr;
	struct stat rcstat;

	if (stat("mcrec.rc", &rcstat) != 0)
		return;

	config = (char *)malloc(rcstat.st_size + 1);

	if ((rcfile = fopen("mcrec.rc", "r")) != NULL)
	{
		rcptr = config;
		copyptr = config;
		size = fread(config, 1, rcstat.st_size, rcfile);
		*(config + size) = '\0';
		while(true)
		{
			// get option
			if ((rcptr = strstr(copyptr, "=")) == NULL)
				break;
			parm = (char *)malloc(rcptr - copyptr + 1);
			parmptr = parm;
			while(copyptr < rcptr)
				*parmptr++ = *copyptr++;
			*parmptr = '\0';
			copyptr++;

			// get value
			if ((rcptr = strstr(copyptr, "\n")) == NULL)
			{
				free(parm);
				break;
			}
			parmdata = (char *)malloc(rcptr - copyptr + 1);
			parmptr = parmdata;
			while(copyptr < rcptr)
				*parmptr++ = *copyptr++;
			*parmptr = '\0';
			copyptr++;

//			fprintf(stderr, "%s; %s\n", parm, parmdata);

			// set option
			if (strcmp(parm, "dbox2name") == 0)
			{
				dbox2str = (char *)malloc(strlen(parmdata)+1);
				strcpy(dbox2str, parmdata);
				dbox2name = dbox2str;
			}
			if (strcmp(parm, "basedir") == 0)
			{
				basedir = (char *)malloc(strlen(parmdata)+1);
				strcpy(basedir, parmdata);
				parmptr--;
				if (*parmptr != '/')
					strcat(basedir, "/");
			}
			if (strcmp(parm, "basefilename") == 0)
			{
				basefilename = (char *)malloc(strlen(parmdata)+1);
				strcpy(basefilename, parmdata);
				fname_output = basefilename;
			}
			if (strcmp(parm, "mchost") == 0)
			{
				mchost = (char *)malloc(strlen(parmdata)+1);
				strcpy(mchost, parmdata);
			}
			if (strcmp(parm, "mcbaseurl") == 0)
			{
				mcbaseurl = (char *)malloc(strlen(parmdata)+1);
				strcpy(mcbaseurl, parmdata);
			}
			if (strcmp(parm, "mcurlext") == 0)
			{
				mcurlext = (char *)malloc(strlen(parmdata)+1);
				strcpy(mcurlext, parmdata);
			}
			if (strcmp(parm, "proxy") == 0)
			{
				if (strlen(parmdata) > 0)
				{
					proxy = (char *)malloc(strlen(parmdata)+1);
					strcpy(proxy, parmdata);
				}
			}
			if (strcmp(parm, "proxyport") == 0)
			{
				proxyport = atoi(parmdata);
			}
			if (strcmp(parm, "extension") == 0)
			{
				extension = (char *)malloc(strlen(parmdata)+1);
				strcpy(extension, parmdata);
			}
			if (strcmp(parm, "log2file") == 0)
			{
				log2file = true;
			}
			free(parm);
			free(parmdata);
		}
		fclose(rcfile);
	}
	free(config);
}


// ####################################################################

int main( int argc, char *argv[] ) {
	
	long av_bufmem = 8 * 1024 * 1024;  // default size for av-reception buffer  
	nice_increment = -10;              // default nice-level adjustment for receiving thread
	int  channel = -1;                 // default channel to record (-1 means "current channel")
	bool quiet = false;
	
	long checkpoint = 10*60;
	int dbox2port = 31338;
	int apid = -1;
//	int tsid;
	bool one_pts_per_gop = false;
	no_rt_prio = false;
	int rc;
	char * urlbuffer;

	readrcfile();
	
	for (int i = 1; i < argc; i++) {
		
		if (!strcmp("-o", argv[i])) {
			i++; if (i >= argc) { fprintf(stderr, "need filename for -o\n"); return -1; }
			fname_output = argv[i];
		
		} else if (!strcmp("-p", argv[i])) {
			i++; if (i >= argc) { fprintf(stderr, "need pathname for -p\n"); return -1; }
			basedir = argv[i];
		
		} else if (!strcmp("-b", argv[i])) {
			i++; if (i >= argc) { fprintf(stderr, "need argument for -b\n"); return -1; }
			
			av_bufmem = atol(argv[i]) * 1024 * 1024;
		
		} else if (!strcmp("-n", argv[i])) {
			i++; if (i >= argc) { fprintf(stderr, "need argument for -n\n"); return -1; }
			
			nice_increment = atoi(argv[i]);
		
		} else if (!strcmp("-c", argv[i])) {
			i++;
			if (i >= argc) 
			{ 
				fprintf(stderr, "need argument for -c\n"); return -1; 
			}
			
			if (channel != -1)
			{
				fprintf(stderr, "channel already set by other option\n"); return -1;
			}
			else
				channel = atoi(argv[i]);
		
		} else if (!strcmp("-port", argv[i])) {
			i++; if (i >= argc) { fprintf(stderr, "need argument for -port\n"); return -1; }
			
			dbox2port = atoi(argv[i]);
			
		} else if (!strcmp("-q", argv[i])) {
			quiet = true;
		
		} else if (!strcmp("-l", argv[i])) {
			log2file = true;
		
		} else if (!strcmp("-d", argv[i])) {
			debug = true;
		
		} else if (!strcmp("-r", argv[i])) {
			rmdub = true;
		
		} else if (!strcmp("-a", argv[i])) {
			usedb = true;
		
		} else if (!strcmp("-e", argv[i])) {
			epg = false;
		
		} else if (!strcmp("-h", argv[i])) {
			disableminhack = false;
		
		} else if (!strcmp("-u", argv[i])) {
			udpport = 30000;
			i++;
			if (i < argc)
				if (argv[i][0] != '-')
				{
					udpport = atoi(argv[i]);
					if (udpport < 1024)
					{
						fprintf(stderr, "port > 1023 needed for udp\n");
						return -1;
					}
				}
				else
					i--;
			
		} else if (!strcmp("-m", argv[i])) {
			i++;
			if (i < argc)
				if (argv[i][0] != '-')
				{
					if (channel != -1)
					{
						fprintf(stderr, "channel already set by other option\n"); return -1;
					}
					moption = 1;
					channel = atoi(argv[i]);
//					sscanf(argv[i], "%x", &moption);
//					tsid = (moption & 0xFFFF0000) >> 16;
//					apid = moption & 0x0000FFFF;
//					logprintf("%x, %x, %x\n", moption, tsid, apid);
				}
				else
				{
					fprintf(stderr, "parameter missing\n");
					return -1;
				}
		
		} else if (!strcmp("-host", argv[i])) {
			i++; if (i >= argc) { fprintf(stderr, "need argument for -host\n"); return -1; }
			
			dbox2name = argv[i];			
			
		} else if (!strcmp("-nort", argv[i])) {
			no_rt_prio = true;
			
		} else {
			
			fprintf(stderr, "unknown option '%s'\n", argv[i]);
			fprintf(stderr, "------- known options: ---------\n"
                     "-l              log messages to file\n"
					 "-r              remove files of same size and name\n"
					 "-a              remove files based on record database\n"
					 "-e              do not fetch EPG information from the net\n"
					 "-h              disable 38-40 Minutes hack\n"
					 "-u [port]       use ggrab-like udp streaming\n"
					 "-m <channel>    multi mode (read Changes.txt for information)\n"
			         "-o <filename>   basename of output files (default: 'mcrec_')\n"
					 "-p <basepath>   basepath to put all files into\n"
					 "-q              quiet operation (no progress, just error/checkpoint output)\n"
					 "-c <channel>    channel to record (default: -1 == don't switch)\n"
					 "-host <name|ip> hostname or IP address of dbox2 (enables dbox2 mode)\n"
					 "-port <port>    port number to use for dbox2 mode (default = 31338)\n"
					 "-b <MB>         number of MB to use as AV buffer memory (default: 8)\n"
					 "-nort           do not try to enable realtime-scheduling for AV reader thread\n"
					 "-n <niceinc>    relative nice-level of AV reader thread if -nort (default: -10)\n"
					 "-d              debug messages\n"
					 "\n"
					);
			return -1;
		}
	}

	fprintf(stderr, "mcrec "VERSION" by Wolfgang Breyha\n");
		
	if ((!dbox2name) || (!basedir) || (!basefilename))
	{
		fprintf(stderr, "missing value! please check your mcrec.rc\n");
		return -1;
	}
	
	if (!extension)
		extension = strdup("mp2");

	if (!moption)
	{
		if (log2file)
		{
			logfile = fopen("mcrec.log", "a");
			setvbuf(logfile, (char *)NULL, _IOLBF, 0);
		}
	}

	if (proxy)
		logprintf("using proxyserver %s:%d!\n", proxy, proxyport);

	//indeed, we want to listen to the radio;-)
	logprintf("switching to radiomode...");

//	urlbuffer = getURL(dbox2name, "GET /control/zapto?mode=RADIO HTTP/1.0\n");
	urlbuffer = getURL(dbox2name, "GET /fb/controlpanel.dbox2?radiomode HTTP/1.0\r\n\r\n");
	free(urlbuffer);

	logprintf("done\n");

	if (channel > 0)
		if (switchchannel(dbox2name, channel))
			exit(0);
	
	apid = getDBox2Channel(dbox2name);

	if (moption && udpport)
		udpport += apid;

	logprintf("using path: %s\n", basedir);
	
	//init songdb
	if ((progname) && (usedb))
	{
		int songdblen = strlen(SONGDBNAME) + strlen(basedir) + strlen(progname) + 20;
		char *songdbfname = (char *)malloc(songdblen);
		strcpy(songdbfname, basedir);
		strcat(songdbfname, "finished/");
		strcat(songdbfname, progname);
		strcat(songdbfname, "/");
		strcat(songdbfname, SONGDBNAME);
		logprintf("initializing songdb (%s)...", songdbfname);
		mcrecsongdb = new SongDB;
		mcrecsongdb->loaddb(songdbfname);
		logprintf("done\n");
	}
	
	mysonginfo.fetched = false;
	get_song_info();
	mysonginfo.fetched = false;
	
	// ----------------------------------------
	// open the files to be written
	
	int fname_mpg_counter = 1;
	
	char fname_mpp[1024]; fname_mpp[0] = 0;
	
	char fname_mpg_num[10];
	char fname_apid[10];

	sprintf(fname_mpg_num, "%d", fname_mpg_counter);
	sprintf(fname_apid, "%x_", apid);
	
	strcpy(fname_mpp, basedir);
	strncat(fname_mpp, fname_output, 1000);
	strncat(fname_mpp, fname_apid, 1000);
	strcat(fname_mpp, fname_mpg_num);
	strcat(fname_mpp, ".mp2");
	
	FILE * file_mpp = 0;
	
	if ( (file_mpp = fopen(fname_mpp,"w")) == NULL )
	{
		logprintf("unable to open %s\n", fname_mpp);
		return -1;
	}
	else
		logprintf("writing to file: %s\n", fname_mpp);
	
	// -------------------------------------------
	// setup remuxer
	
	
	
	// aux synchronization is not quite as good as with new method...
	remuxer.allowed_frame_pts_skew = 0.8 * 90000.0;
	
	remuxer.one_pts_per_gop = one_pts_per_gop;
	
	// -------------------------------------------
	// find / open / initialize the device
	
	if (apid <= 0) {
		fprintf(stderr, "invalid or no apid specified\n");
		return -1;
	}
	
	dvb_audio_pes = openPES(dbox2name, dbox2port, apid, udpport, &udpsock);
	if (dvb_audio_pes < 0) return -1;

	// -----------------------------------------------------------------------
	// start the AV reading thread

	num_avbufs = av_bufmem / sizeof(AVBuf);

	avbufs = new AVBuf[num_avbufs];
	if (!avbufs) {
		fprintf(stderr,"unable to allocate %ld bytes for avbufs\n",
		        ((long)sizeof(AVBuf)*num_avbufs)
				 );
		return -1;
	}

	avrthread = 0;
	
	terminate_avread_thread = false;
	avread_thread_failed = false;
	avread_thread_ended = false;
	thread_started = false;
	
	pthread_create( &avrthread, 0, AVReadThreadDBox2 , 0);
	
	SigFlags sigflags;
	
	if (SigFlags::handlers[SIGUSR1].activate()) {
		fprintf(stderr,"unable to handle SIGUSR1\n");
	}

	if (SigFlags::handlers[SIGUSR2].activate()) {
		fprintf(stderr,"unable to handle SIGUSR2\n");
	}
	
	// ----------------------------------------

	fprintf(stderr,"waiting for first data to become available\n");
	
	// first busy-wait until thread_started is signaled
	for (;;) {
		if (thread_started) {
			break;
		}
		
		if (SigFlags::flags[SIGINT] || SigFlags::flags[SIGTERM]) {
			
			SigFlags::flags[SIGINT] = 0;
			SigFlags::flags[SIGTERM] = 0;

			fprintf(stderr, "terminating on signal from user\n");
			
			terminate_avread_thread = true;			
		}
		
		if (avread_thread_ended) {
			fprintf(stderr, "avread_thread ended unexpectedly to main program\n");
			break;
		}
		
		usleep(10 * 1000); // wait 10ms
	}
	
	// ----------------------------------------
	
	if (!terminate_avread_thread && !avread_thread_ended) {
		
		//fprintf(stderr,"entering main loop\n");
		
		unsigned long long received_avbufs = 0;
		unsigned long long received_audio = 0;

		unsigned long long last_received_audio = 0;
		
		//unsigned long long grabbed_audio_packets = 0;
		
		unsigned long read_idx = 0;
		
		
		time_t start_second = time(0);
		time_t last_second = start_second+1;
		time_t song_start_second = 0;
		
		// main loop
		
		for (;;)
		{
			
			if (avread_thread_ended) {
				fprintf(stderr, "\navread_thread ended unexpectedly to main program\n");
				break;
			}
		
			if (sinfthread_ended) {
				sinfthread_ended = false;
				pthread_join(sinfthread, NULL);
				sinfthread = 0;
			}
	
			if (SigFlags::flags[SIGINT] || SigFlags::flags[SIGTERM]) {

				SigFlags::flags[SIGINT] = 0;
				SigFlags::flags[SIGTERM] = 0;

				//fprintf(stderr, "\nterminating avread on users request\n");
				
				break;			
			}

			if (SigFlags::flags[SIGUSR1]) {
				SigFlags::flags[SIGUSR1] = 0;
				
				fprintf(stderr,"\nperforming resync on users request (SIGUSR1)          \n");
				remuxer.perform_resync();
			}
			
			// try to lock a filled avbuf with incoming data
			AVBuf & avbuf = avbufs[read_idx];
			
			if (pthread_mutex_trylock(& avbuf.mutex)) {
				
				// we cannot lock it yet - so no new data - ok, we'll wait.			
				usleep(10 * 1000); // wait 10ms
				
			} else {
				
				// great, new data available!
				
				received_avbufs += 1;
				
				if (avbuf.resync) {
					fprintf(stderr,"resyncing at request of reader thread\n");
					remuxer.perform_resync();
				}

				if (avbuf.audio_valid)
				{
					received_audio += avbuf.audio_valid;

					remuxer.supply_audio_data(avbuf.audio, avbuf.audio_valid);

					rc = remuxer.write_mpp(file_mpp);
					if (rc == -1)
					{
						logprintf("\nfailed to write .mpp file\n");
						break;
					}
					if (rc == 0)
						remuxer.remove_audio_packets(remuxer.audio_packets_avail); 

					if ((remuxer.mpp_started) && !(mysonginfo.fetched))
					{
						get_song_info();
						song_start_second = time(0);
					}

					if (remuxer.audioresync)
					{
						fname_mpg_counter++;

						remuxer.total_bytes_written = 0;
						fclose(file_mpp);

						finish_file(fname_mpp);

						fname_mpp[0] = 0;
						strcpy(fname_mpp, basedir);
						strncat(fname_mpp, fname_output, 1000);
						strncat(fname_mpp, fname_apid, 1000);
						sprintf(fname_mpg_num, "%d", fname_mpg_counter);
						strcat(fname_mpp, fname_mpg_num);
						strcat(fname_mpp, ".mp2");
							
						if ( (file_mpp = fopen(fname_mpp,"w")) == NULL )
						{
							logprintf("unable to open %s\n",fname_mpp);
							return -1;
						}
						else
							logprintf("writing to file: %s\n", fname_mpp);

						remuxer.audioresync = false;
						mysonginfo.fetched = false;

						rc = remuxer.write_mpp(file_mpp);
						if (rc == -1)
						{
							logprintf("\nfailed to write .mpp file\n");
							break;
						}
						if (rc == 0)
							remuxer.remove_audio_packets(remuxer.audio_packets_avail);
					}

					// need this awful trick to make both MPEG and AC3 sound work... how ugly... :-(
					if (remuxer.wanted_audio_stream == STREAM_PRIVATE_1)
					{
						new_read_size_audio = AUDIO_BUF_SIZE;
					}
					else
					{
						new_read_size_audio = AUDIO_BUF_SIZE / 2;							
					}
					
				}
				
				
				// release the buffer, we had it long enough
				avbuf.clear();
				
				pthread_mutex_unlock(& avbuf.mutex);
				
				// up for the next avbuf!
				read_idx += 1;
				if (read_idx >= num_avbufs)
				{
					read_idx = 0;
				}
				
					
/*				static bool was_synced_before = false;
				
				if (remuxer.resync) was_synced_before = false;
					
				// let the remuxer try to emit MPEG-2 data...
				rc = remuxer.write_mpp(file_mpp);
				if (rc == -1)
				{
					fprintf(stderr, "\nerror while writing to %s\n", fname_mpp);
					break;					
				}
				if (rc == 0)
				{
               		remuxer.remove_audio_packets(remuxer.audio_packets_avail);
					remuxer.audioresync = false;
				}
				
				if (!remuxer.resync) was_synced_before = true;
*/			}
			
			// do some things once per second

			
			time_t now = time(0);
			if (now != last_second)
			{
				last_second = now;
				
				//double bandw_audio = ((received_audio-last_received_audio)*8)/1000.0;
				double tbandw_audio = (received_audio*8ULL)/((now-start_second)*1000.0);
				
				last_received_audio = received_audio;
				
				long seconds_spent = now - start_second;
				int minutes_spent = seconds_spent / 60;
				int seconds_rem   = seconds_spent % 60;

				int song_min_spent = 0;
				int song_sec_rem = 0;

				if (song_start_second != 0)
				{
					seconds_spent = now - song_start_second;
					song_min_spent = seconds_spent / 60;
					song_sec_rem = seconds_spent % 60;
				}
				
				if (received_audio)
				{
					if (!quiet || (seconds_spent % checkpoint) == 0)
					{
						fprintf(stderr, "%02d:%02d songtime: %02d:%02d  audio %ld kbit/s %d,%d          \r",
						        minutes_spent, seconds_rem,
								song_min_spent, song_sec_rem,
								  (long)tbandw_audio, pnr, plsum
								 );
					}
					if (!disableminhack)
					{
						ignore_sync = false;
						int modsongtime = seconds_spent % 2345;
						if ((modsongtime < 60) || (modsongtime > 2280))
							ignore_sync = true;
					}
				}
			}
			
			// end of main loop
		}

		// ----------------------------------------
		// emit statistics

		fprintf(stderr, "\n"); 

	}
		
	
	// ----------------------------------------

	terminate_avread_thread = true;

	if (file_mpp) fclose(file_mpp);
	
	usleep(10 * 1000); // wait 10ms
	SigFlags::flags[SIGINT] = 0;
	SigFlags::flags[SIGTERM] = 0;
	
	
	// busy-wait until avread_thread has ended
	for (;;)
	{
		if (avread_thread_ended)
		{
			break;
		}
		
		if (SigFlags::flags[SIGINT] || SigFlags::flags[SIGTERM])
		{
			
			SigFlags::flags[SIGINT] = 0;
			SigFlags::flags[SIGTERM] = 0;

			fprintf(stderr,"terminating program - but avread_thread is still alive!\n");
			break;
		}
		
		usleep(10 * 1000); // wait 10ms
	}
	
	// ----------------------------------------
	
	// avthread is gone or ignored...

	//fprintf(stderr,"stopping stream and closing device\n");
	
	if (dvb_audio_pes >= 0) close(dvb_audio_pes);
	if (udpsock >= 0) close(udpsock);

	//fprintf(stderr,"main program is finished\n");

	if (usedb)
	{
		logprintf("writing songdb...");
		mcrecsongdb->writedb();
		logprintf("done\n");
	}
	
	if (dbox2str)
		free(dbox2str);
	if (basedir)
		free(basedir);
	if (basefilename)
		free(basefilename);
	if (mchost)
		free(mchost);
	if (mcbaseurl)
		free(mcbaseurl);
	if (mcurlext)
		free(mcurlext);
	if (progname)
		free(progname);
	if (dbprogname)
		free(dbprogname);
	if (logfile)
		fclose(logfile);
  
	return 0;
}

