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

program: ggrab version 0.22 by Peter Menzebach <pm-ggrab at menzebach.de>

*/

#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <unistd.h>
#include <pthread.h>
#include <signal.h>
#include <netdb.h>
#include <netinet/in.h>
#ifdef __CYGWIN__
#include <cygwin/in.h>
#endif
#include <sys/socket.h>
#include <sys/fcntl.h>
#include "cbuffer.h"
#include "tools.h"
#include "list.h"
#include "pesstream.h"

//Signalhandler flags
bool	gflag_term;
bool	gflag_new_file;

char    ga_basename[256] = "vts_01_";
char	ga_ext[20] = "vob";
bool	g_realtime = true;

// Default parameters
bool	 gnosectionsd	 = false;

int 	toggle_sectionsd(char * p_name);
void  *	readkeyboard (void * p_arg);
void 	install_signal_handler (void) ;
void 	sighandler (int num);
void 	generate_program_stream (int a_pid[], int anz_pids, char * p_boxname, int port, int udpbase, 
		bool logging, bool debug, long long max_file_size, bool quiet, int duration);
void    generate_nomux_streams (int a_pid[], int anz_pids, char * p_boxname, int port, int udpbase, 
		bool logging, bool debug, long long max_file_size, bool quiet, int duration);
void    generate_raw_audio (int a_pid[], int anz_pids, char * p_boxname, int port, int udpbase, 
		bool logging, bool debug, long long max_file_size, bool quiet, int duration);

int main( int argc, char *argv[] ) {

	int		a_pid[10];
#ifdef __CYGWIN__
	pthread_t 	kb_thread;
#endif
	int		anz_pids 	= 0;;
	int		port 		= 31338;;
	bool		quiet 		= false;
	bool		logging		= false;
	int		udpbase		= 0;
	bool		debug		= false;

	//some default parameters for arguments
	char  * 	dbox2name 	= "dbox";
	time_t 		duration	= 24 * 3600;
	long long 	max_file_size   = 2LL * 1024 * 1024 * 1024 - 1;
	enum {MPEG_PP, MPEG_PES, MPEG_RAW} rectype = MPEG_PP;

	for (int i = 1; i < argc; i++) {
		if (!strcmp("-o", argv[i])) {
			i++; if (i >= argc) { fprintf(stderr, "need filename for -o\n"); return -1; }
			if (strlen(argv[i]) < 230) {
				strcpy (ga_basename, argv[i]);
			}
		} else if (!strcmp("-e", argv[i])) {
			i++; if (i >= argc) { fprintf(stderr, "need extension for -e\n"); return -1; }
			if (strlen(argv[i]) < 20) {
				strcpy (ga_ext, argv[i]);
			}
		
		} else if (!strcmp("-m", argv[i])) {
			i++; if (i >= argc) { fprintf(stderr, "need number of minutes for -m\n"); return -1; }
				duration = (int)atol(argv[i])*60;
		
		} else if (!strcmp("-b", argv[i])) {
			i++; if (i >= argc) { fprintf(stderr, "need argument for -b\n"); return -1; }
		        // Parameter obsolete
		
		} else if (!strcmp("-n", argv[i])) {
			i++; if (i >= argc) { fprintf(stderr, "need argument for -n\n"); return -1; }
			// Parameter obsolete	
		} else if (!strcmp("-s", argv[i])) {
			i++; if (i >= argc) { fprintf(stderr, "need max size in MB argument for -s\n"); return -1; }
			if (atoi(argv[i]) < 5) {
				fprintf(stderr,"min file size 5 MB ignoring -s\n");
			}
			else {
				max_file_size = 1024LL*1024LL*((long long)atoi(argv[i]));
			}
		
		} else if (!strcmp("-port", argv[i])) {
			i++; if (i >= argc) { fprintf(stderr, "need argument for -port\n"); return -1; }
			port = atoi(argv[i]);
			
		} else if (!strcmp("-p", argv[i])) {
			anz_pids = 0;
			while (anz_pids < 10) {
				i++; 
				if (i >= argc || *(argv[i]) == '-') {
					i--;
					break;
				}
				sscanf(argv[i], "%x", &(a_pid[anz_pids++]));
			}
		} else if (!strcmp("-q", argv[i])) {
			quiet = true;
		} else if (!strcmp("-pes", argv[i])) {
			rectype = MPEG_PES;
		} else if (!strcmp("-raw", argv[i])) {
			rectype = MPEG_RAW;
		} else if (!strcmp("-loop", argv[i])) {
			gloop = true;	
		} else if (!strcmp("-1ptspergop", argv[i])) {
			// obsolete	
		} else if (!strcmp("-host", argv[i])) {
			i++; if (i >= argc) { fprintf(stderr, "need argument for -host\n"); return -1; }
			dbox2name = argv[i];
		} else if (!strcmp("-nonfos", argv[i])) {
			// obsolete	
		} else if (!strcmp("-nort", argv[i])) {
			g_realtime = false;	
		} else if (!strcmp("-log", argv[i])) {
			logging = true;
		} else if (!strcmp("-nos", argv[i])) {
			gnosectionsd = true;
		} else if (!strcmp("-core", argv[i])) {
			gcore = true;
		} else if (!strcmp("-debug", argv[i])) {
			debug = true;
		} else if (!strcmp("-udp", argv[i])) {
			udpbase = UDPBASE;
			if ((i+1) < argc) {
				if (atoi(argv[i+1]) > 1023) {
					i++;
					udpbase = atoi(argv[i]);
				}
			}
		} else if (!strcmp("-h", argv[i])) {

			fprintf(stderr, "ggrab version 0.22, Copyright (C) 2002 Peter Menzebach\n"
			                "ggrab comes with ABSOLUTELY NO WARRANTY; This is free software,\n"
			                "and you are welcome to redistribute it under the conditions of the\n"
			                "GNU Public License, see www.gnu.org\n"
					"inspired by grab from Peter Niemayer and the dbox2 on linux team\n\n"
					"------- mandatory options: ---------\n"
					"-p <pid1> <pid2> <pidn> video and audio pids to receive [none]\n"
					"\n"
					"------- basic options: -------------\n"
					"-host <host>   hostname or ip address [dbox]\n"
					"-port <port>   port number [31338]\n"
					"-o <path>      path/basename of output files [vts_01_]\n"
					"-o -           output to stdout\n"
					"-e <extension> extension of output files [vob]\n"
					"-m <minutes>   number of minutes to record [24 h]\n"
					"-s <megabyte>  maximum size per recorded file [2000]\n"
					"-q             be quiet\n"
					"\n"
					"------- advanced options: ----------\n"
					"-pes           write PES (1 video, n audio)\n" 
					"               streams in different files\n"
					"-raw           write raw audio frames\n"
					"-log           writes raw input stream to \"log.n\"\n"
					"-nos           No stop of sectionsd\n"
					"-core          generate core dump if error exit\n"
					"-debug         generate debug information\n"
					"-loop          Looping output files basename1/2\n"
					"-udp [uport]   UDP Streaming, (experimental)[30000]\n"
					"-nort          Disable Real Time Scheduling for read threads\n"
					"\n"
					"------- handled signals: -----------\n"
					"SIGUSR2        force write to next file\n"
					"\n"
					"values in square brackets indicate default settings if available\n"
					);
			return -1;

		} else {

			fprintf(stderr, "unknown option '%s'\n", argv[i]);
			fprintf(stderr, "run 'ggrab -h' for usage information\n");
			return -1;
		}
	}
	if (anz_pids == 0) {
		fprintf(stderr, "need at least one pid\n");
		fprintf(stderr, "run 'ggrab -h' for usage information\n");
		return -1;
	}
	
	// Max size - 3 MB because cut at next Sequence start
	max_file_size -= 1024 * 1024 * 3;

	
	toggle_sectionsd(dbox2name) ;

#ifdef __CYGWIN__
	pthread_create( & kb_thread, 0, readkeyboard , 0);
#endif
	install_signal_handler ();

	switch (rectype) {
		
		case MPEG_PP:
			generate_program_stream (a_pid, anz_pids, dbox2name, port, udpbase, logging, debug, max_file_size, quiet, duration); 
			break;
		case MPEG_PES:
			generate_nomux_streams (a_pid, anz_pids, dbox2name, port, udpbase, logging, debug, max_file_size, quiet, duration); 
			break;
		case MPEG_RAW:
			generate_raw_audio (a_pid, anz_pids, dbox2name, port, udpbase, logging, debug, max_file_size, quiet, duration); 
			break;
		default:
			exit(1);
	}
}

void install_signal_handler (void) {

	struct sigaction sg;

	sg.sa_handler=sighandler;
	sigemptyset (&sg.sa_mask);
	sg.sa_flags = 0;
#ifdef __linux__ 
	sg.sa_restorer = 0;
#endif
	
	if (sigaction(SIGTERM, & sg, 0)) {
		errexit ("Set Handler SIGTERM");
	}
	if (sigaction(SIGINT, & sg, 0)) {
		errexit ("Set Handler SIGINT");
	}
	if (sigaction(SIGUSR2, & sg, 0)) {
		errexit ("Set Handler SIGUSR2");
	}
	if (sigaction(SIGUSR1, & sg, 0)) {
		errexit ("Set Handler SIGUSR1");
	}
}

void sighandler (int num) {

	if (num == SIGINT) {
		gflag_term = 1;
	}
	if (num == SIGTERM) {
		gflag_term = 1;
	}
	if (num == SIGUSR2) {
		gflag_new_file = 1;
	}
}

void  * readkeyboard (void * p_arg) {

	int i;
	p_arg=0;
	while (1) {

		i = getchar();
		
		if (i == 'q') {
			gflag_term = true;
			return (0);
		}
		if (i == 'n') {
			gflag_new_file = true;
		}
	}
}

int toggle_sectionsd(char * p_name) {

	static bool	sectionsd_stopped = false;
	int	r;
	int	flags;

	struct hostent * hp = gethostbyname(p_name);
		
	struct sockaddr_in adr;

	if (gnosectionsd) return(0);
	
	memset ((char *)&adr, 0, sizeof(struct sockaddr_in));
				
   	if (hp == 0) {
		errexit("unable to lookup hostname");
	}
		         
	adr.sin_family = AF_INET;
	adr.sin_addr.s_addr = ((struct in_addr *)(hp->h_addr))->s_addr;
	adr.sin_port = htons(80);
		
   	if (adr.sin_addr.s_addr == 0) {
		errexit("unable to lookup hostname");
	}
		         
	int sock = socket(AF_INET, SOCK_STREAM, 0);
	
	if (-1 == connect(sock, (sockaddr*)&adr, sizeof(struct sockaddr_in))) {
		close(sock);
		errexit("error to connect to socket");
	}
	flags = fcntl(sock, F_GETFL, 0);
	flags |= O_NONBLOCK;
	fcntl(sock, F_SETFL, flags );


	char buffer[100];	
	if (sectionsd_stopped) {
		sprintf(buffer, "GET /control/zapto?startsectionsd HTTP/1.0\r\n\r\n");
		sectionsd_stopped=false;
	}
	else {
		sprintf(buffer, "GET /control/zapto?stopsectionsd HTTP/1.0\r\n\r\n");
		sectionsd_stopped=true;
	}
	write(sock, buffer, strlen(buffer));

	sleep(1);
	r=read(sock, buffer, 100);
	close (sock);
	return (0);
}

void generate_program_stream (int a_pid[], int anz_pids, char * p_boxname, int port, int udpbase, 
			bool logging, bool debug, long long max_file_size, bool quiet, int duration) {

	static unsigned char a_sheader[12 + 10 * 3] = { 
							0, 
							0, 
							1, 
							0xbb,
							0,
							12, // Length header						
							0x80 | (((MPLEX_RATE/400) & 0x3f8000) >> 15),
							        ((MPLEX_RATE/400) & 0x007f80) >> 7,
							       (((MPLEX_RATE/400) & 0x00007f) << 1) | 0x01,
							(1<<2), // 1 audio stream,
							0xe1, // video lock, audio lock, 1 video stream
							0x7f, // no rate restriction
							0xe0, // sid video
							0xc0 | 0x20 | ((512 & 0x1f00) >> 8), //video buffer
							               (512 & 0x00ff),
							0, 
							0xc0 | 0x00 | (((8*1024/128) & 0x1f00) >> 8 ), //audio buffer
							               ((8*1024/128) & 0x00ff)
	};


	class pesstream * 	p_st[10];
	class pesstream * 	p_act_st;
	class propack * 	p_pp[10];
	class propack * 	p_act_pp;

	FILE * 			fp = 0;
	int			i;
	int			nextindex = 0;
	long long		act_file_size=0;
	PTS			act_scr = 0;
	PTS			startpts;
	PTS			min_scr;
	PTS			pscr;
	unsigned char		sid;
	unsigned char * 	p_act;
	time_t			start_time = time(0);
	time_t			now;
	time_t			last = 0;
	static char		a_buffer[100];
	int			seq = 1;

	toggle_sectionsd(p_boxname);

	p_st[0] = new class pesstream (S_VIDEO, p_boxname, a_pid[0],  port, udpbase + 0, logging, debug, g_realtime);
	p_pp[0] = new class propack;

	startpts = p_st[0]->get_start_pts () - VIDEO_FORERUN - 1;	
	p_st[0]->set_pts_offset(startpts);
	
	anz_pids = (anz_pids) < 10 ? anz_pids : 10;
	
	p_act = a_sheader;
	
	*(p_act + 5) = 9 + (anz_pids - 1) * 3;
	*(p_act + 9) = (anz_pids - 1) << 2; 

	sid    = 0xc0;
	p_act += 15;
	
	for (i = 1; i < anz_pids; i++) {
		p_st[i] = new class pesstream (S_AUDIO, p_boxname, a_pid[i],  port, udpbase + i, logging, debug, g_realtime);
		p_pp[i] = new class propack;

		if (p_st[i]->get_sid() != 0xbd) {
			p_st[i]->set_sid (sid++);
		}
		
		p_st[i]->set_pts_offset(startpts);
		p_st[i]->fill_pp(p_pp[i]);
		
		*p_act++ = p_st[i]->get_sid();
		*p_act++ = 0xc0 | 0x00 | (((8*1024/128) & 0x1f00) >> 8 );
		*p_act++ = ((8*1024/128) & 0x00ff);
		
	}

	memcpy(p_pp[0]->get_pact(), a_sheader, p_act- a_sheader);
	p_pp[0]->commitlen(p_act - a_sheader);
	p_st[0]->fill_pp(p_pp[0]);
	
	fp = open_next_output_file (fp, ga_basename, ga_ext, seq);	

	while (1) {
		
		if (act_file_size > max_file_size) {
			gflag_new_file = true;
		}
		
		min_scr = 1ULL << 33;
		for (i = 0; i < anz_pids; i++) {

			pscr = p_pp[i]->get_scr_wanted();
                                                                                                                        
			if (pscr < min_scr) {
				min_scr   = pscr;
				nextindex = i;
			}
		}
		p_act_pp  = p_pp[nextindex];
		p_act_st  = p_st[nextindex];

		if (gflag_term && (nextindex == 0) && p_pp[0]->get_startflag() == START_SEQ) {
			fclose(fp);
			toggle_sectionsd(p_boxname);
			exit(0);
		}

		if (gflag_new_file && (nextindex == 0) && p_pp[0]->get_startflag() == START_SEQ) {
			fp = open_next_output_file (fp, ga_basename, ga_ext, seq);
			gflag_new_file = false;
			act_file_size = 0;
		}
		
		if (act_scr < p_act_pp->get_scr_wanted()) {
			act_scr = p_act_pp->get_scr_wanted();
		}
		

		p_act_pp->fill_scr(act_scr);
		act_scr += (double) MAX_PP_LEN * 8 / ((double) MPLEX_RATE)  * 90000;
	
		fwrite(p_act_pp->get_bufptr(), p_act_pp->get_len(), 1, fp);
		act_file_size += p_act_pp->get_len();

		p_act_pp->reset();
		p_act_st->fill_pp(p_act_pp);

		now = time(0);
		
		if (now != last) {
			last = now;
			
			if ((now - start_time) > duration) {
				gflag_term = true;
			}
			
			if (!quiet) {
				fprintf(stderr, "%03d:%02d",
					  (int)((now - start_time) / 60),
					  (int)((now - start_time) % 60));

				for (i = 0; i < anz_pids; i++) {
					p_st[i]->get_pp_stats(a_buffer, 100);
					fprintf(stderr, " %s", a_buffer);
				}
				if (!((now-start_time) % 10)) {
					fprintf(stderr,"\n");
				}
				else {
					fprintf(stderr, "\r");
				}			
			}
		}
	}
}
	
void generate_nomux_streams (int a_pid[], int anz_pids, char * p_boxname, int port, int udpbase, bool logging, bool debug, long long max_file_size, bool quiet, int duration) {

	class pesstream * 	p_st[10];
	char * 			p_basename[10];
	int			seq[10];
	FILE * 			fp[10];
	long long		act_file_size[10];
	int			i;
	time_t			start_time = time(0);
	time_t			now;
	time_t			last = 0;
	static unsigned char	a_buffer[65536];		
	int			len;
	unsigned char		sid;

	toggle_sectionsd(p_boxname);

	anz_pids = (anz_pids) < 10 ? anz_pids : 10;


	sid = 0xc0;
	for (i = 0; i < anz_pids; i++) {
		p_st[i] = new class pesstream (S_UNDEF, p_boxname, a_pid[i],  port, udpbase + i, logging, debug, g_realtime);
		p_basename[i] = new char[256];
		sprintf(p_basename[i], "%ss%d_p", ga_basename, i);
		seq[i] 		 = 0;
		fp[i] 		 = 0;
		act_file_size[i] = 0;
		fp[i]		 = open_next_output_file (fp[i], p_basename[i], ga_ext, seq[i]);
		if ((p_st[i]->get_sid() & 0xe0) == 0xc0) {
			p_st[i]->set_sid(sid++);
		}
	}


	while (1) {
		if (gflag_term) {
			for (i = 0; i < anz_pids; i++) {
				fclose(fp[i]);
			}
			toggle_sectionsd(p_boxname);
			exit(0);
		}
	
		for (i = 0; i < anz_pids; i++) {
			len = 1;
			while (len) {
				len = p_st[i]->fill_pes_packet (a_buffer);
			
				if (gflag_new_file || (act_file_size[i] + len > max_file_size)) {
					fp[i] = open_next_output_file (fp[i], p_basename[i], ga_ext, seq[i]);
					gflag_new_file = false;
				}
			
				if (len) {
					if (fwrite (a_buffer,1,len,fp[i]) == 0) {
						errexit ("generate_nomux_streams: fwrite failed");
					}
				}
			}
		}
		usleep (20000);

		now = time(0);
		
		if (now != last) {
			last = now;
			
			if ((now - start_time) > duration) {
				gflag_term = true;
			}
			
			if (!quiet) {
				fprintf(stderr, "%03d:%02d",
					  (int)((now - start_time) / 60),
					  (int)((now - start_time) % 60));

				for (i = 0; i < anz_pids; i++) {
					p_st[i]->get_pp_stats((char *) a_buffer, 100);
					fprintf(stderr, " %s", a_buffer);
				}
				if (!((now-start_time) % 10)) {
					fprintf(stderr,"\n");
				}
				else {
					fprintf(stderr, "\r");
				}			
			}
		}
	}
}

void generate_raw_audio (int a_pid[], int anz_pids, char * p_boxname, int port, int udpbase, bool logging, bool debug, long long max_file_size, bool quiet, int duration) {

	class pesstream * 	p_st[10];
	char * 			p_basename[10];
	int			seq[10];
	FILE * 			fp[10];
	long long		act_file_size[10];
	int			i;
	time_t			start_time = time(0);
	time_t			now;
	time_t			last = 0;
	static unsigned char	a_buffer[65536];		
	int			len;

	toggle_sectionsd(p_boxname);

	anz_pids = (anz_pids) < 10 ? anz_pids : 10;
	

	for (i = 0; i < anz_pids; i++) {
		p_st[i] = new class pesstream (S_AUDIO, p_boxname, a_pid[i],  port, udpbase + i, logging, debug, g_realtime);
		p_basename[i] = new char[256];
		sprintf(p_basename[i], "%ss%d_p", ga_basename, i);
		seq[i] 		 = 0;
		fp[i] 		 = 0;
		act_file_size[i] = 0;
		fp[i]		 = open_next_output_file (fp[i], p_basename[i], "mpg", seq[i]);
	}


	while (1) {
		if (gflag_term) {
			for (i = 0; i < anz_pids; i++) {
				fclose(fp[i]);
			}
			toggle_sectionsd(p_boxname);
			exit(0);
		}
		for (i = 0; i < anz_pids; i++) {

			len = 1;
			while (len) {
				len = p_st[i]->fill_raw_audio (a_buffer);
			
				if (gflag_new_file || (act_file_size[i] + len > max_file_size)) {
					fp[i] = open_next_output_file (fp[i], p_basename[i], ga_ext, seq[i]);
					gflag_new_file = false;
				}
				
				if(len) {			
					if (fwrite (a_buffer,1,len,fp[i]) == 0) {
						errexit ("generate_raw_audio: fwrite failed");
					}
				}
				act_file_size[i] += len;
			}
		}

		usleep (20000);

		now = time(0);
		
		if (now != last) {
			last = now;
			
			if ((now - start_time) > duration) {
				gflag_term = true;
			}
			
			if (!quiet) {
				fprintf(stderr, "%03d:%02d",
					  (int)((now - start_time) / 60),
					  (int)((now - start_time) % 60));

				for (i = 0; i < anz_pids; i++) {
					p_st[i]->get_pp_stats((char *) a_buffer, 100);
					fprintf(stderr, " %s", a_buffer);
				}
				if (!((now-start_time) % 10)) {
					fprintf(stderr,"\n");
				}
				else {
					fprintf(stderr, "\r");
				}			
			}
		}
	}
}
