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

program: ggrab version 0.09 by Peter Menzebach <pm-ggrab at menzebach.de>

*/

#include <stdlib.h>
#include <pthread.h>
#include <netdb.h>
#include <iostream>
#include <unistd.h>
#include <string.h>
#include <stdio.h>
#include <time.h>
#include <sys/time.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <sys/ioctl.h>
#include <netinet/in.h>
#include <signal.h>
#include <math.h>
#include "cbuffer.h"
#include "tools.h"
#include "list.h"

#ifdef __CYGWIN__
#include <cygwin/in.h>
#endif


// Some globals TODO eleminate them
int vfd;
int afd;

double	      vcorrect;
unsigned char audio_sid;

class CBuffer vbuf(4000000);
class CBuffer abuf(300000);

//Statistics
int	vrecmax;
int	arecmax;
int	vrecbytes;
int	arecbytes;
double	dtime  = 0;
double	daudio = 0;

//Signalhandler flags
bool	flag_term;
bool	flag_new_file;

//filenames
char    a_basename[256]	= "vts_01_";
int	filenum 	= 1;
char	a_extension[20]	= "vob";


// Default parameters
bool	no_rt_prio 	= false;
int 	nice_increment 	= -10;
bool	vlog 		= false;
bool	alog 		= false;
bool	nosectionsd 	= false;
bool	gcore 		= false;
bool	debug 		= false;

// Reader Threads
pthread_t hv_thread;	
pthread_t ha_thread;	
pthread_t kb_thread;	


int 	toggle_sectionsd(char * p_name);
void  *	readkeyboard (void * p_arg);
void  * readvstream (void * p_arg);
void  * readastream (void * p_arg);
int 	openStream(char * name, int port, int pid);
FILE * 	open_next_output_file(FILE *);
void 	install_signal_handler (void) ;
void 	sighandler (int num);
int 	time_since_last (void);
PROPACK generate_next_video_pp (class xlist * p_list);
PROPACK generate_next_audio_pp (class xlist * p_list);
double 	pes_pts ( const unsigned char * pbuf);
int 	pes_len(const unsigned char * p) ;

int main( int argc, char *argv[] ) {

	PESELEM 	velem;
	PROPACK 	vpack;
	PROPACK 	apack;
	PTS		act_src;
	bool		found;
	int		a,v;
	time_t		now;
	int		msec;
	FILE *  	fp;
	time_t		last 		= 0;
	int 		vpid 		= 0;
	int 		apid 		= 0;
	long long	act_file_size 	= 0;
	time_t		start_time 	= time(0);

	//some default parameters for arguments
	int 		port 		= 31338;
	bool		quiet		= false;
	bool		nomux 		= false;
	char  * 	dbox2name 	= "dbox";
	long long 	max_file_size 	= 2LL * 1024 * 1024 * 1024 - 1;
	time_t 		record_end 	= time(0) + 24 * 3600;


	for (int i = 1; i < argc; i++) {
		if (!strcmp("-o", argv[i])) {
			i++; if (i >= argc) { fprintf(stderr, "need filename for -o\n"); return -1; }
			if (strlen(argv[i]) < 230) {
				strcpy (a_basename, argv[i]);
			}
		} else if (!strcmp("-e", argv[i])) {
			i++; if (i >= argc) { fprintf(stderr, "need extension for -e\n"); return -1; }
			if (strlen(argv[i]) < 20) {
				strcpy (a_extension, argv[i]);
			}
		
		} else if (!strcmp("-m", argv[i])) {
			i++; if (i >= argc) { fprintf(stderr, "need number of minutes for -m\n"); return -1; }
			record_end = time(0) + (int)atol(argv[i])*60;
		
		} else if (!strcmp("-b", argv[i])) {
			i++; if (i >= argc) { fprintf(stderr, "need argument for -b\n"); return -1; }
		        // Parameter obsolete
		
		} else if (!strcmp("-n", argv[i])) {
			i++; if (i >= argc) { fprintf(stderr, "need argument for -n\n"); return -1; }
			nice_increment = atoi(argv[i]);
		
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
			i++; if (i >= argc) { fprintf(stderr, "need two arguments for -p\n"); return -1; }
			sscanf(argv[i], "%x", &vpid);
			i++; if (i >= argc) { fprintf(stderr, "need two arguments for -p\n"); return -1; }
			sscanf(argv[i], "%x", &apid);
		} else if (!strcmp("-q", argv[i])) {
			quiet = true;
		} else if (!strcmp("-nomux", argv[i])) {
			nomux = true;
		} else if (!strcmp("-loop", argv[i])) {
			// obsolete	
		} else if (!strcmp("-1ptspergop", argv[i])) {
			// obsolete	
		} else if (!strcmp("-host", argv[i])) {
			i++; if (i >= argc) { fprintf(stderr, "need argument for -host\n"); return -1; }
			dbox2name = argv[i];
		} else if (!strcmp("-nonfos", argv[i])) {
			// obsolete	
		} else if (!strcmp("-nort", argv[i])) {
			no_rt_prio = true;
		} else if (!strcmp("-vlog", argv[i])) {
			vlog = true;
		} else if (!strcmp("-alog", argv[i])) {
			alog = true;
		} else if (!strcmp("-nos", argv[i])) {
			nosectionsd = true;
		} else if (!strcmp("-core", argv[i])) {
			gcore = true;
		} else if (!strcmp("-debug", argv[i])) {
			debug = true;
		} else if (!strcmp("-h", argv[i])) {

			fprintf(stderr, "ggrab version 0.09, Copyright (C) 2002 Peter Menzebach\n"
			                "ggrab comes with ABSOLUTELY NO WARRANTY; This is free software,\n"
			                "and you are welcome to redistribute it under the conditions of the\n"
			                "GNU Public License, see www.gnu.org\n"
					"inspired by grab from Peter Niemayer and the dbox2 on linux team\n\n"
					"------- mandatory options: ---------\n"
					"-p <vpid> <apid> video and audio pids to receive [none]\n"
					"\n"
					"------- basic options: -------------\n"
					"-host <host>   hostname or ip address [dbox]\n"
					"-port <port>   port number [31338]\n"
					"-o <path>  	path/basename of output files [vts_01_]\n"
					"-e <extension> extension of output files [vob]\n"
					"-m <minutes>   number of minutes to record [24 h]\n"
					"-s <megabyte>  maximum size per recorded file [2000]\n"
					"-q             be quiet\n"
					"\n"
					"------- advanced options: ----------\n"
					"-nort          do not try to enable realtime-scheduling for the reader thread\n"
					"-n <niceinc>   relative nice-level of AV reader thread if -nort (default: -10)\n"
					"-nomux         (not realized up to now) do not multiplex, write 3 seperate files with a/v/pts\n"
					"-vlog          writes raw video stream to \"log.vid\"\n"
					"-alog          writes raw audio stream to \"log.aud\"\n"
					"-nos           No stop of sectionsd\n"
					"-core          generate core dump if error exit\n"
					"-debug         generate core dump if error exit\n"
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
	if (!vpid || !apid) {
		fprintf(stderr, "option -p <vpid> <apid> is mandatory\n");
		fprintf(stderr, "run 'ggrab -h' for usage information\n");
		return -1;
	}	

	// Max size - 3 MB because cut at next Sequence start
	max_file_size -= 1024 * 1024 * 3;

	
	toggle_sectionsd(dbox2name) ;

	vfd = openStream (dbox2name, port, vpid);
	afd = openStream (dbox2name, port, apid);

	pthread_create( & hv_thread, 0, readvstream , 0);
	pthread_create( & ha_thread, 0, readastream , 0);
#ifdef __CYGWIN__
	pthread_create( & kb_thread, 0, readkeyboard , 0);
#endif
	install_signal_handler ();

	class xlist vlist(&vbuf, TYPE_VIDEO);
	class xlist alist(&abuf, TYPE_AUDIO);
	velem = vlist.get_elem();
	vcorrect = velem.pts - VIDEO_FORERUN + 1;


	fp = open_next_output_file (0);

	time_since_last ();
	
	audio_sid = alist.sid(); //TODO dirty 
	vpack = generate_next_video_pp (&vlist);
	

	found = false;
	while (!found) {
		apack = generate_next_audio_pp (&alist);
		if (apack.src_wanted > vpack.src_wanted) {
			found = true;
		}
	}
	
	act_src = vpack.src_wanted;

	while (1) {
		if (act_file_size > max_file_size) {
			flag_new_file = true;
		}

		if (vpack.src_wanted < apack.src_wanted) {
			
			if (act_src > vpack.src_wanted) {
				fill_pp_scr(vpack.p_buffer,act_src);
			}
			else {
				fill_pp_scr(vpack.p_buffer,vpack.src_wanted);
				act_src=vpack.src_wanted;
			}
			
			act_src += vpack.len * 8 / ((double) MPLEX_RATE)  * 90000;
			
			if (flag_term) {
				if (vpack.startflag == START_SEQ) {
					fclose(fp);
					toggle_sectionsd(dbox2name);
					fprintf(stderr,"\n");
					exit (0);
				}
			}
			if (flag_new_file) {
				if (vpack.startflag == START_SEQ) {
					fp = open_next_output_file(fp);
					flag_new_file = false;
					act_file_size = 0;
				}
		        }
			
			fwrite (vpack.p_buffer,vpack.len,1,fp);
			act_file_size += vpack.len;
			vpack = generate_next_video_pp (&vlist);
		}
		else {
			if (act_src > apack.src_wanted) {
				fill_pp_scr(apack.p_buffer,act_src);
			}
			else {
				fill_pp_scr(apack.p_buffer,vpack.src_wanted);
				act_src=apack.src_wanted;
			}
			act_src += apack.len * 8 / ((double) MPLEX_RATE) * 90000;
			
			fwrite (apack.p_buffer,apack.len,1,fp);
			act_file_size += apack.len;
			apack = generate_next_audio_pp (&alist);
		}
//--------------Now some Staticstics
		now = time(0);

		if (now > record_end) {
			flag_term = true;
		}
		if (!quiet) {
			if (now != last) {

				last = now;
				msec = time_since_last () + 1;
				v=vrecbytes;
				a=arecbytes;
				vrecbytes=0;
				arecbytes=0;
				fprintf(stderr, "%02d:%02d  vid %04d kbit/s  aud %03d kbit/s  syn %d  drop %ds ",
					  (int)((now - start_time) / 60),
					  (int)((now - start_time) % 60),
					  (v * 8 / msec),
					  (a * 8 / msec),
					  0,
					  0);

				if(debug) {
					fprintf(stderr, "vh %05d ah %05d dp %5.1f da %5.1f pd %6d vb %4d ab %4d",
					  vrecmax,
					  arecmax,
					  dtime,
					  daudio,
					  gpadding,
					  vbuf.GetByteCount()/1024,
					  abuf.GetByteCount()/1024
				           );
				}
				fprintf(stderr, "\r");
				if (!((now-start_time) % 10)){
					gpadding = 0;
					vrecmax  = 0;
					arecmax  = 0;
					fprintf(stderr,"\n");
				} 
			}
		}
	}
}
		

PROPACK
generate_next_video_pp (class xlist * vlist) {

	static unsigned char a_pp[MAX_PP_LEN]=
	{
		0x00,
		0x00,
		0x01,
		0xba,
		0x00,
		0x00,
		0x00,
		0x00,
		0x00,
		0x01,
		((MPLEX_RATE/400) & 0x3fc000) >> 14,
		((MPLEX_RATE/400) & 0x003fc0) >> 6,
		(((MPLEX_RATE/400) & 0x00003f) << 2) | 3,
		0x00};

	static unsigned char a_pes[]= {
		//----------------------------- Now PES Header
		0x00,
		0x00,
		0x01,
		0xe0,
		((MAX_PP_LEN - 14 - 6) >> 8) & 0xff,
		((MAX_PP_LEN - 14 - 6) & 0xff),
		0x80,
		0x00,
		0x00
	};
		
	static unsigned char *	p_pes = &(a_pp[14]);
	static PTS	      	src_wanted = 0;
	static PROPACK  	ppack = {a_pp, MAX_PP_LEN, 0,NO_START};
	static CBUFPTR		l_act;
	static int		v_restlen;
	static bool		first = true;
	static STARTFLAG	seqstart;
	static PESELEM          velem;
	static bool		flag_set_pts = true;
	int		      	b_restlen;
	unsigned char * 	p_act;
	int			copylen;
	static int		gpics;

	if (first) {
		gpics		= 0;
		first      	= false;
		velem 	   	= vlist->get_elem();
		l_act      	= velem.lptr;
		v_restlen  	= velem.len;
		seqstart   	= velem.startflag;
		ppack.startflag = velem.startflag;
		src_wanted 	= velem.pts - vcorrect - VIDEO_FORERUN;
	}
	
	if (seqstart == NO_START) {
		src_wanted += ((double) (MAX_PP_LEN * 8) / MPLEX_RATE) * 90000.0;
	}

	p_act = a_pp + 14;

	ppack.startflag = seqstart;

	if (seqstart== START_SEQ) { // write system header
		seqstart = NO_START;
		
		static unsigned char system_header[] = {  // TODO Structure not ok, system head contruction not in video....
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

		system_header[15] = audio_sid; // TODO dirty...
		memcpy (p_act, system_header, sizeof(system_header));
		p_act += sizeof(system_header);
	}

	memcpy (p_act, a_pes, sizeof(a_pes));
	p_pes = p_act;
	if (seqstart== START_SEQ) { 
		p_pes[6] |= 0x04; /// Mark data alignment
	}

	fill_pes_len (p_act, MAX_PP_LEN - (p_act -  a_pp + 6));
	
	if (flag_set_pts) {
		flag_set_pts = false;
		fill_pes_pts(p_act,velem.pts - vcorrect);
		p_act += 5;
	}

	p_act += sizeof(a_pes);

	ppack.src_wanted = src_wanted;

	b_restlen = MAX_PP_LEN - (p_act - a_pp);

	while (b_restlen) {
	
		copylen = v_restlen < b_restlen ? v_restlen : b_restlen;
	
		v_restlen -= copylen;
		b_restlen -= copylen;

		
		vbuf.CopyBuffer(l_act, p_act, copylen); 
		
		l_act += copylen;
		p_act += copylen;
	
		if (!v_restlen) {
			gpics ++;
			vlist->discard_elem();
			velem = vlist->get_elem();

			l_act      =  velem.lptr;
			v_restlen  =  velem.len;
		
			if (velem.startflag == START_SEQ) {
				if (fabs(velem.pts - vcorrect - VIDEO_FORERUN - src_wanted) > 90000) {
					fprintf(stderr, "video pts gap = %10.1f s\n", fabs(velem.pts-vcorrect-VIDEO_FORERUN-src_wanted)/90000);
			
				}

				flag_set_pts = true;
				src_wanted   = velem.pts - vcorrect - VIDEO_FORERUN;
			
				dtime = src_wanted / 90000 * 25 - gpics;
				
				seqstart = velem.startflag;
				if (b_restlen) {
					flag_set_pts = true;
					memset (p_act,0,b_restlen);
					b_restlen = 0;
				}
			} 
			else {
				if (b_restlen && (b_restlen < 30)) {
						memset (p_act,0,b_restlen);
						b_restlen = 0;
						flag_set_pts = true;
				}
				
				if (b_restlen && (p_pes[8] == 0)) {
					memmove (p_pes + 9 + 5, p_pes + 9, p_act - (p_pes + 9));
					p_act     += 5;
					b_restlen -= 5;
					fill_pes_pts(p_pes, velem.pts-vcorrect);
				}
			}
		}
	}
	return(ppack);	
}				
				
PROPACK
generate_next_audio_pp (class xlist * alist) {

	static unsigned char a_pp[MAX_PP_LEN]=
	{
		0x00,
		0x00,
		0x01,
		0xba,
		0x00,
		0x00,
		0x00,
		0x00,
		0x00,
		0x01,
		((MPLEX_RATE/400) & 0x3fc000) >> 14,
		((MPLEX_RATE/400) & 0x003fc0) >> 6,
		(((MPLEX_RATE/400) & 0x00003f) << 2) | 3,
		0x00, 
		//----------------------------- Now PES Header
		0x00,
		0x00,
		0x01,
		0xc0,
		((MAX_PP_LEN - 14 - 6) >> 8) & 0xff,
		((MAX_PP_LEN - 14 - 6) & 0xff),
		0x80,
		0x80,
		0x05
	};
	
	static PROPACK ppack = {a_pp, sizeof(a_pp), 0, NO_START};
	static CBUFPTR	l_act;
	static PESELEM  aelem;
	static double	pts_per_byte;
	static double	act_pts;
	static double	last_pes_pts;
	static int	a_restlen;
	static double	xaudio = 0;
	unsigned char * p_act;
	unsigned char * p_pes;
	int		b_restlen;
	int		copylen;
	double		pts;
	int		i;
	unsigned char * pp;
	
		
	p_act = a_pp + 14 + 14;
	p_pes = a_pp + 14;
	

	static bool 	first = true;
	if (first) {
		first 		= false;
		pts_per_byte 	= 90000.0 / (192000.0/8);
		
		// Dirty, but bring first audio frame to beginning of buffer
		while (1) {
			aelem = alist->get_elem();
			if ((aelem.pts - vcorrect - AUDIO_FORERUN) > 5) {
				break;
			}
			alist->discard_elem();
		}
		a_restlen 	= aelem.len;
		act_pts 	= aelem.pts;
		l_act 		= aelem.lptr;
		b_restlen = MAX_PP_LEN - (p_act - a_pp);

		abuf.CopyBuffer(l_act, p_act, b_restlen);

		pp = p_act;
		for (i = 0; i < b_restlen - 4; i++) {
			if (pp[0] == 0xff) {
				if ((pp[1] & 0xfc) == 0xfc) {
					l_act += i;
					a_restlen -=i;
					break;
				}
			}
			pp++;
		}

		if (alist->sid() == 0xbd) {
			p_pes[3] = 0xbd;
		}		
	}		
	
	if (p_pes[3] == 0xbd) {
		p_pes[14] =  0x80;
		p_pes[15] =  0x02;
		p_pes[16] =  0x00;
		p_pes[17] =  0x01;
		p_act += 4;
		pts_per_byte= 0.032 * 90000 / 1792.0;
	}
	
	b_restlen = MAX_PP_LEN - (p_act - a_pp);
	
	pts = act_pts + (aelem.len - a_restlen) * pts_per_byte - vcorrect;


	fill_pes_pts(p_pes,pts);
	
	ppack.src_wanted = pts - AUDIO_FORERUN;

	if (p_pes[3] == 0xbd) {
		xaudio += (double) b_restlen / 1792.0 * 0.032;
	}
	else {
		xaudio += (double) b_restlen / 576 * 0.024;
	}

	daudio = xaudio - ((pts-VIDEO_FORERUN)/90000);

	while (b_restlen) {
		copylen = a_restlen < b_restlen ? a_restlen : b_restlen;
	
		a_restlen -= copylen;
		b_restlen -= copylen;
		
		abuf.CopyBuffer(l_act, p_act, copylen); 
		
		l_act += copylen;
		p_act += copylen;
	
		if (!a_restlen) {
			alist->discard_elem();
			aelem = alist->get_elem();
			last_pes_pts = act_pts;
			act_pts = aelem.pts;
			if (fabs(last_pes_pts-act_pts) > 50000) {
				fprintf(stderr, "audio pts gap = %10.1f\n", fabs(last_pes_pts - act_pts)/90000);
				//act_pts = last_pes_pts + pts_per_byte * (MAX_PP_LEN-28);
			}
			pts_per_byte = (act_pts-last_pes_pts) / aelem.len;
			l_act      =  aelem.lptr;
			a_restlen  =  aelem.len;
		}
	}
	return(ppack);	
}	
	
int
time_since_last () {
	static struct timeval  last;
	static struct timeval  now;
	static struct timezone tz;
	int	               ret;

	gettimeofday (&now, &tz);

	ret =  (now.tv_sec - last.tv_sec) * 1000;
	ret += (now.tv_usec - last.tv_usec) / 1000;

	last = now;

	return(ret);
}	

void install_signal_handler (void) {

	struct sigaction sg;

	sg.sa_handler=sighandler;
	sigemptyset (&sg.sa_mask);
	sg.sa_flags = 0;
#if !defined __CYGWIN__ && !defined __MACOSX__
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
		flag_term = 1;
	}
	if (num == SIGTERM) {
		flag_term = 1;
	}
	if (num == SIGUSR2) {
		flag_new_file = 1;
	}
}

FILE * 
open_next_output_file (FILE * fp) {

	static  char a_filename [256];
	bool	found=false;
	struct  stat stats;

	if (fp) {
		fclose(fp);
	}

	while (!found) {
		sprintf(a_filename,"%s%d.%s",a_basename, filenum, a_extension);
		filenum ++;
		if (!stat(a_filename,&stats)) {
		 	fprintf(stderr,"file %s exists, trying next\n",a_filename);
		}
		else {
			found = true;
		}
	}
#ifdef _LFS64_STDIO
	if (!(fp = fopen64(a_filename,"w"))) {
#else
	if (!(fp = fopen(a_filename,"w"))) {
#endif
		fprintf(stderr,"cannot open %s\n",a_filename);
		errexit("cannot open output file");
	}

	return(fp);
}

	
int openStream(char * name, int port, int pid) {

	struct hostent * hp = gethostbyname(name);
		
	struct sockaddr_in adr;
	memset ((char *)&adr, 0, sizeof(struct sockaddr_in));
				
   	if (hp == 0) {
		errexit("unable to lookup hostname");
	}
		         
	adr.sin_family = AF_INET;
	adr.sin_addr.s_addr = ((struct in_addr *)(hp->h_addr))->s_addr;
	adr.sin_port = htons(port);
		
   	if (adr.sin_addr.s_addr == 0) {
		errexit("unable to lookup hostname");
	}
		         
	int sock = socket(AF_INET, SOCK_STREAM, 0);
	
	if (-1 == connect(sock, (sockaddr*)&adr, sizeof(struct sockaddr_in))) {
		close(sock);
		errexit("error to connect to socket");
	}
	
	char buffer[100];		
	sprintf(buffer, "GET /%x HTTP/1.0\r\n\r\n", pid);
	write(sock, buffer, strlen(buffer));
	
	return sock;
}

void  * readvstream (void * p_arg) {

	unsigned char * pBuf;
	int len;
	int r;
	static int delay = READ_DELAY * 1000;
	FILE * fp;
	time_t	ltime;
	p_arg=0;	

#ifdef __linux__ 
	if (mlockall(MCL_CURRENT | MCL_FUTURE)) {
		fprintf(stderr, "WARNING: unable to lock memory. Swapping may disturb the video read thread\n");			
	}
#endif
		
	bool rt_enabled = false;
	if (!no_rt_prio) {
		struct sched_param sp;
			
		sp.sched_priority = sched_get_priority_max(SCHED_FIFO);
		if ((r = pthread_setschedparam(pthread_self(), SCHED_FIFO, &sp))) {
			fprintf(stderr, "WARNING: cannot enable real-time scheduling for video read thread - will try to renice %d\n",r);
		} else {
			rt_enabled = true;
		}
	}
	
	if (!rt_enabled) {
		if (nice(nice_increment)) {
			fprintf(stderr,"WARNING: video readthread cannot change nice level - continuing\n");
		}
	}

	if (vlog) {
		if((fp = fopen ("log.vid","w")) == 0) {
			errexit ("cannot open Logfile log.vid");
		}
	}

	
	ltime=time(0);

	while (1) {
		len = vbuf.GetNextFillBuffer (&pBuf);
		
		r=read(vfd, pBuf, len);
		if (r > 0) {
			ltime=time(0);
			if (vlog) {
				fwrite(pBuf,r,1,fp);
			}	
			vbuf.CommitFillBuffer(r);
			vrecbytes += r;
			if (r > vrecmax) {
				vrecmax = r;
			}
		}
		else {
			if (r < 0) {
				errexit("Video Read: Read Error");
			}
			if((time(0) - ltime) > 1) {
				fprintf(stderr, "\n\nVideo Read: timeout, len=%d\n",len);
				errexit("Video Read: No Data from Box");
			}
			usleep (delay);
		}
	}
	return(0);
}

void  * readastream (void * p_arg) {

	unsigned char * pBuf;
	int len;
	int r;
	static int delay = READ_DELAY * 1000;
	FILE * fp;
	time_t ltime;
	p_arg=0;	

#ifdef __linux__ 
	if (mlockall(MCL_CURRENT | MCL_FUTURE)) {
		fprintf(stderr, "WARNING: unable to lock memory. Swapping may disturb the audio read thread\n");			
	}
#endif
		
	bool rt_enabled = false;
	if (!no_rt_prio) {
		struct sched_param sp;
			
		sp.sched_priority = sched_get_priority_max(SCHED_FIFO);
		if (pthread_setschedparam(pthread_self(), SCHED_FIFO, &sp)) {
			fprintf(stderr, "WARNING: audio read thead cannot enable real-time scheduling - will try to renice\n");
		} else {
			rt_enabled = true;
		}
	}
	
	if (!rt_enabled) {
		if (nice(nice_increment)) {
			fprintf(stderr,"WARNING: audio read thread cannot change nice level - continuing\n");
		}
	}
	
	if (alog) {
		if((fp = fopen ("log.aud","w")) == 0) {
			errexit ("cannot open Logfile log.aud");
		}
	}
	ltime=time(0);

	while (1) {
		len = abuf.GetNextFillBuffer (&pBuf);
		
		r=read(afd, pBuf, len);
		if (r > 0) {
			ltime=time(0);
			if (alog) {
				fwrite(pBuf,r,1,fp);
			}	
			abuf.CommitFillBuffer(r);
			arecbytes += r;
			if (r > arecmax) {
				arecmax = r;
			}
		}
		else {
			if (r < 0) {
				errexit("Video Read: Read Error");
			}
			if((time(0) - ltime) > 1) {
				fprintf(stderr, "\n\nAudio Read: timeout, len=%d\n",len);
				errexit("Audio Read: No Data from Box");
			}
			usleep (delay);
		}
	}
	return(0);
}

void  * readkeyboard (void * p_arg) {

	int i;
	p_arg=0;
	while (1) {

		i = getchar();
		
		if (i == 'q') {
			flag_term = true;
			return (0);
		}
		if (i == 'n') {
			flag_new_file = true;
		}
	}
}

int toggle_sectionsd(char * p_name) {

	static bool	sectionsd_stopped = false;
	int	r;

	struct hostent * hp = gethostbyname(p_name);
		
	struct sockaddr_in adr;

	if (nosectionsd) return(0);

	
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
	buffer[r]=0;
	close (sock);
	sleep(3);
	return (0);
}
		

