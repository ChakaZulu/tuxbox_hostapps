#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <math.h>
#include <pthread.h>
#include <netdb.h>
#include <errno.h>
#include <signal.h>
#include <sys/time.h>
#include <sys/socket.h>
#include <sys/mman.h>
#include <netinet/in.h>
#ifdef __CYGWIN__
#include <cygwin/in.h>
#endif
#include "tools.h"
#include "cbuffer.h"
#include "list.h"
#include "pesstream.h"


pesstream::pesstream (S_TYPE stype, char * p_boxname, int pid, int port, int udpport, bool logging, bool debug, bool realtime) {

	static struct 	timezone tz;
	int 		bufsiz;
	
	m_nr		= m_st_nr++;
	m_stype 	= stype;
	m_first 	= true;
	m_debug 	= debug;
	m_log 		= logging;
	m_pics		= 0;
	m_correct 	= 0;
	m_delta		= 0;
	m_packloss	= 0;
	m_recbytes	= 0;
	m_recmax 	= 0;
	m_pics		= 0;
	m_last_pts	= 0;
	m_act_pts	= 0;
	m_xaudio	= 0;
	m_padding	= 0;
	m_realtime	= realtime;
	


	if (stype == S_AUDIO) {
		bufsiz = 200000;
	}
	else {
		bufsiz = 4000000;
	}
	mp_cbuf = new CBuffer (bufsiz);
	
	m_fd = openStream(p_boxname, port, pid, udpport, &m_fd_udp); 
	
	pthread_create( & mh_thread, 0, (void * (*)(void *)) readstream , (void *) this);
	
	mp_list = new xlist (mp_cbuf, m_stype);

	m_sid = mp_list->sid();	

	gettimeofday (&m_last_time, &tz);

}

pesstream::~pesstream(void) {
	m_st_nr--;
	close(m_fd);
	close(m_fd_udp);
	
	delete mp_list;
	delete mp_cbuf;
}

int pesstream::get_sid () {
	return (m_sid);
}
void pesstream::set_sid (int sid) {
	m_sid = sid;
}

PTS pesstream::get_start_pts () {
	
	PESELEM el;

	while (1) {
		el = mp_list->get_elem();
		if (el.startflag == START_SEQ) {
			break;
		}
	}
	return (el.pts);
}

void pesstream::fill_video_pp (class propack * p_pp) {

	static unsigned char a_pes[]= {
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
	int		      	b_restlen;
	unsigned char * 	p_act;
	int			copylen;
	unsigned char *		p_pes;
	int			commitlen;

	if (m_first) {
		m_pics		= 0;
		m_first      	= false;
		m_elem 	   	= mp_list->get_elem();
		ml_act      	= m_elem.lptr;
		m_restlen  	= m_elem.len;
		m_startflag   	= m_elem.startflag;
		m_scr_wanted 	= m_elem.pts - m_correct - VIDEO_FORERUN;
		m_flag_set_pts  = true;
	}
	
	if (m_startflag == NO_START) {
		m_scr_wanted += ((double) (MAX_PP_LEN * 8) / MPLEX_RATE) * 90000.0;
	}
	
	p_pp->set_scr_wanted (m_scr_wanted);
	p_pp->set_startflag (m_startflag);

	m_startflag = NO_START;

	p_act 	  = p_pp->get_pact();
	b_restlen = p_pp->get_restlen();
	commitlen = b_restlen;

	memcpy (p_act, a_pes, sizeof(a_pes));
	
	p_pes = p_act;

	fill_pes_len(p_pes, b_restlen - 6);

	p_act     += 9;
	b_restlen -= 9;
	
	if (m_startflag == START_SEQ) { 
		p_pes[6] |= 0x04; /// Mark data alignment
	}

	if (m_flag_set_pts) {
		m_flag_set_pts = false;
		fill_pes_pts(p_pes, m_elem.pts - m_correct);
		p_act     += 5;
		b_restlen -= 5;
	}

	while (b_restlen) {
	
		copylen = m_restlen < b_restlen ? m_restlen : b_restlen;
	
		m_restlen -= copylen;
		b_restlen -= copylen;

		
		mp_cbuf->CopyBuffer(ml_act, p_act, copylen); 
		
		ml_act += copylen;
		p_act  += copylen;
	
		if (!m_restlen) {
			m_pics ++;
			mp_list->discard_elem();
			m_elem = mp_list->get_elem();
			ml_act     =  m_elem.lptr;
			m_restlen  =  m_elem.len;
		
			if (m_elem.startflag == START_SEQ) {
				if (fabs(m_elem.pts - m_correct - VIDEO_FORERUN - m_scr_wanted) > 90000) {
					fprintf(stderr, "video pts gap = %10.1f s\n", fabs(m_elem.pts-m_correct-VIDEO_FORERUN-m_scr_wanted)/90000);
			
				}
				m_startflag = m_elem.startflag;

				m_flag_set_pts = true;
				m_scr_wanted   = m_elem.pts - m_correct - VIDEO_FORERUN;
			
				m_delta = m_scr_wanted / 90000 - (double) m_pics / 25.0;
				

				if (b_restlen) {
					m_flag_set_pts = true;
					memset (p_act,0,b_restlen);
					b_restlen = 0;
				}
			} 
			else {
				if (b_restlen && (b_restlen < 30)) {
						memset (p_act,0,b_restlen);
						b_restlen = 0;
						m_flag_set_pts = true;
				}
				
				if (b_restlen && (p_pes[8] == 0)) {
					memmove (p_pes + 9 + 5, p_pes + 9, p_act - (p_pes + 9));
					p_act     += 5;
					b_restlen -= 5;
					fill_pes_pts(p_pes, m_elem.pts-m_correct);
				}
			}
		}
	}
	p_pp->commitlen(commitlen);
}				
				
void pesstream::fill_audio_pp (class propack * p_pp) {

	static unsigned char a_pes[]=
	{
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


	unsigned char * p_act;
	unsigned char * p_pes;
	int		b_restlen;
	int		copylen;
	double		pts;
	int		i;
	int		commitlen;
	unsigned char * pp;

	p_act 	  = p_pp->get_pact();
	b_restlen = p_pp->get_restlen();
	commitlen = b_restlen;

	memcpy (p_act, a_pes, sizeof (a_pes));
	p_pes  = p_act;
	fill_pes_len(p_pes, b_restlen - 6);
	p_pes[3] = m_sid;
	p_act     += 14;
	b_restlen -= 14;
		
	if (m_first) {
		m_first 	= false;
		m_pts_per_byte 	= 90000.0 / (192000.0/8);
		
		
		while (1) {
			m_elem = mp_list->get_elem();
			if ((m_elem.pts - m_correct) > VIDEO_FORERUN) {
				break;
			}
			mp_list->discard_elem();
		}
		m_restlen 	= m_elem.len;
		m_act_pts 	= m_elem.pts;
		ml_act 		= m_elem.lptr;

		mp_cbuf->CopyBuffer(ml_act, p_act, b_restlen);

		pp = p_act;
		if (m_sid != 0xbd) {
			// Dirty, but bring first audio frame to beginning of buffer
			for (i = 0; i < b_restlen - 4; i++) {
				if (pp[0] == 0xff) {
					if ((pp[1] & 0xfc) == 0xfc) {
						ml_act    += i;
						m_restlen -= i;
						if (m_restlen < 0) {
							errexit("Begin of audio frame not found");
						}
						break;
					}
				}
				pp++;
			}
		}
	}		
	
	if (p_pes[3] == 0xbd) {
		p_pes[14] =  0x80;
		p_pes[15] =  0x02;
		p_pes[16] =  0x00;
		p_pes[17] =  0x01;
		p_act 	  += 4;
		b_restlen -= 4;
		m_pts_per_byte= 0.032 * 90000 / 1792.0;
	}
	
	pts = m_act_pts + (m_elem.len - m_restlen) * m_pts_per_byte - m_correct;

	fill_pes_pts(p_pes,pts);
	
	p_pp->set_scr_wanted(pts - AUDIO_FORERUN);

	if (p_pes[3] == 0xbd) {
		m_xaudio += (double) b_restlen / 1792.0 * 0.032;
	}
	else {
		m_xaudio += (double) b_restlen / 576 * 0.024;

		// xaudio wrong for 44,1 kHz
	}

	m_delta = m_xaudio - (pts / 90000);

	while (b_restlen) {
		copylen    = m_restlen < b_restlen ? m_restlen : b_restlen;
	
		m_restlen -= copylen;
		b_restlen -= copylen;
		
		mp_cbuf->CopyBuffer(ml_act, p_act, copylen); 
		
		ml_act += copylen;
		p_act  += copylen;
	
		if (!m_restlen) {
			mp_list->discard_elem();
			m_elem = mp_list->get_elem();
			m_last_pts   = m_act_pts;
			m_act_pts    = m_elem.pts;
			ml_act       = m_elem.lptr;
			m_restlen    = m_elem.len;
		
			if (fabs(m_last_pts - m_act_pts) > 50000) {
				fprintf(stderr, "audio pts gap = %10.1f\n", fabs(m_last_pts - m_act_pts)/90000);
			}
			else {
				m_pts_per_byte = (m_act_pts - m_last_pts) / m_elem.len;
			}
		}
	}
	p_pp->commitlen(commitlen);
	
}

void pesstream::fill_pp(class propack * p_pp) {

	if(m_stype == S_VIDEO) {
		fill_video_pp(p_pp);
	}
	else {
		fill_audio_pp(p_pp);
	}
}

int pesstream::fill_pes_packet (unsigned char * p_buf) {
	
	static unsigned char a_pes[]=
	{
		0x00,
		0x00,
		0x01,
		0xc0,
	        0x00,	
	        0x00,	
		0x80,
		0x80,
		0x05
	};


	unsigned char * p_act = p_buf;
	unsigned char * pp;
	int		i;
	int		b_restlen;

	if (m_restlen == 0) {
		if (mp_list->actcount() == 1) {
			return(0);
		}
		m_flag_set_pts = true; 
		if (!m_first) {
			mp_list->discard_elem();
		}
		m_elem = mp_list->get_elem();
		m_restlen    = m_elem.len;
		m_act_pts    = m_elem.pts;
		ml_act       = m_elem.lptr;
	}

	if (m_first) {
		m_first = false;

		if (mp_list->type() == S_VIDEO) {
			while (1) {
				if (m_elem.startflag == START_SEQ) {
					break;
				}
				mp_list->discard_elem();
				m_elem = mp_list->get_elem();
			}
			m_act_pts    = m_elem.pts;
			ml_act       = m_elem.lptr;
			m_restlen    = m_elem.len;
		}
		else {
			b_restlen = 65535 - 5 - 3;
			b_restlen = m_restlen < b_restlen ? m_restlen:b_restlen;

			if (m_sid != 0xbd) {
			// Dirty, but bring first audio frame to beginning of buffer
				mp_cbuf->CopyBuffer(ml_act, p_act, b_restlen);
				pp = p_act;
				for (i = 0; i < b_restlen - 4; i++) {
					if (pp[0] == 0xff) {
						if ((pp[1] & 0xfc) == 0xfc) {
							ml_act    += i;
							m_restlen -= i;
							m_act_pts += (double) i * (90000.0 / (192000.0/8));
							break;
						}
					}
					pp++;
				}
			}
		}
	}

	b_restlen = 65535;

	memcpy (p_act, a_pes, sizeof(a_pes));

	p_act[3] = m_sid;
	
	if (m_flag_set_pts) {
		m_flag_set_pts = false;
		fill_pes_pts(p_act,m_act_pts);
		p_act += 5;
		b_restlen -= 5;
	}
	p_act     += 9;
	b_restlen -= 9;
	
	b_restlen = m_restlen < b_restlen ? m_restlen:b_restlen;
	
	mp_cbuf->CopyBuffer(ml_act, p_act, b_restlen);
	
	m_restlen -= b_restlen;
	ml_act     +=b_restlen;

	fill_pes_len (p_buf, (p_act - p_buf) + b_restlen - 6);
	
	return (p_act - p_buf + b_restlen);
}

int pesstream::fill_raw_audio (unsigned char * p_buf) {

	unsigned char * p_act = p_buf;
	unsigned char * pp;
	int		i;
	int		b_restlen;

	if (m_restlen == 0) {
		if (mp_list->actcount() == 1) {
			return(0);
		}
		if (!m_first) {
			mp_list->discard_elem();
		}
		m_elem = mp_list->get_elem();
		m_restlen    = m_elem.len;
		ml_act	     = m_elem.lptr;
	}

	if (m_first) {
		m_first = false;

		b_restlen = 65535;
		b_restlen = m_restlen < b_restlen ? m_restlen:b_restlen;

		if (m_sid != 0xbd) {
		// Dirty, but bring first audio frame to beginning of buffer
			mp_cbuf->CopyBuffer(ml_act, p_act, b_restlen);
			pp = p_act;
			for (i = 0; i < b_restlen - 4; i++) {
				if (pp[0] == 0xff) {
					if ((pp[1] & 0xfc) == 0xfc) {
						ml_act    += i;
						m_restlen -= i;
						break;
					}
				}
				pp++;
			}
		}
	}
	
	b_restlen = 65535;
	
	b_restlen = m_restlen < b_restlen ? m_restlen:b_restlen;

	mp_cbuf->CopyBuffer(ml_act, p_act, b_restlen);
	
	m_restlen -= b_restlen;
	ml_act     +=b_restlen;

	return (p_act - p_buf + b_restlen);
}

void pesstream::set_pts_offset (PTS pts) {
	m_correct = pts;
	
}

void pesstream::get_pp_stats (char * p_buffer, int len) {
	
	static struct 	timezone tz;
	struct timeval	now;
	int		msec;
	
	gettimeofday (&now, &tz);

	msec  =  (now.tv_sec - m_last_time.tv_sec) * 1000;
	msec += (now.tv_usec - m_last_time.tv_usec) / 1000;
	msec ++;

	if(m_stype == S_VIDEO) {
		m_padding = gpadding;
	}

	if (len < 50) {
		errexit("Wrong length");
	}

	if (m_debug) {
		sprintf(p_buffer,"rt:%04d bf:%05d dd:%5.1lf pd:%6d rb:%4d pl:%4d",
			(m_recbytes * 8 / msec),	// Data Rate
			m_recmax,			// Maximal read size
			m_delta,			// Stream Delta
			m_padding,		        // Discarded Padding Bytes
			mp_cbuf->GetByteCount()/1024,   // Fill Size of CBuffer
			m_packloss			// UDP packet loss
		       );
	}
	else {
		sprintf(p_buffer,"rt:%04d",
			(m_recbytes * 8 / msec));	// Data Rate
	}
	m_last_time = now;
	
	m_recbytes = 0;
	m_recmax   = 0;
	m_padding  = 0;
	gpadding   = 0;
}
	
int pesstream::m_st_nr;
		
int openStream(char * name, int port, int pid, int udpport, int * udpsocket) {

	struct hostent * hp = gethostbyname(name);
		
	struct sockaddr_in adr;
	memset ((char *)&adr, 0, sizeof(struct sockaddr_in));
			
	*udpsocket = 0;
	if (udpport > 1023) {
		*udpsocket = socket(AF_INET, SOCK_DGRAM, 0);
		memset(&adr, 0, sizeof(adr));
		adr.sin_family = AF_INET;
		adr.sin_addr.s_addr = htonl(INADDR_ANY);
		adr.sin_port = htons(udpport);
		bind(*udpsocket, (sockaddr *)&adr, sizeof(struct sockaddr_in));
	}
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
	if (udpport > 1023) { 
		sprintf(buffer, "GET /%x,%d HTTP/1.0\r\n\r\n", pid, udpport);
	}
	else {
		sprintf(buffer, "GET /%x HTTP/1.0\r\n\r\n", pid);
	}
	
	write(sock, buffer, strlen(buffer));

	return sock;
}

void  * readstream (class pesstream & ss) {

 	unsigned char * pBuf;	
	unsigned char * p_act = 0;
	int 		len;
	int 		r=0;
	int 		rest = 0;
	int 		pnr = 0;
	FILE * 		fp=0;
	
	unsigned char * a_buf = new unsigned char[UDP_MSG_LEN];

	if (ss.m_realtime) {
#ifdef __linux__ 
		if (mlockall(MCL_CURRENT | MCL_FUTURE)) {
			fprintf(stderr, "WARNING: unable to lock memory. Swapping may disturb the read thread\n");			
		}
#endif

/*		struct sched_param sp;
			
		sp.sched_priority = sched_get_priority_max(SCHED_FIFO);
		if ((r = pthread_setschedparam(pthread_self(), SCHED_FIFO, &sp))) {
			fprintf(stderr, "WARNING: cannot enable real-time scheduling for read thread %d\n",r);
		}	
*/
		nice(-10);
	}
	if (ss.m_log) {
		char a_logname[10];
		sprintf(a_logname, "log.%d", ss.m_nr);

		if((fp = fopen (a_logname, "w")) == 0) {
			errexit ("cannot open Logfile");
		}
	}
	
	while (1) {
		len = ss.mp_cbuf->GetNextFillBuffer (&pBuf);

		if (ss.m_fd_udp) {
			if (!rest) {
				if (len > UDP_MSG_LEN) {
					r = recv(ss.m_fd_udp, pBuf, len, 0);
					if (r > 0) {
						r -=4;
					}
					ss.m_packloss = pnr++ - ntohl(*((int *) (pBuf + r)));
				}
				else {
					rest = recv(ss.m_fd_udp, a_buf, UDP_MSG_LEN, 0);
					if (rest > 0) {
						rest -=4;
					}
					ss.m_packloss = pnr++ - ntohl(*((int *) (a_buf + r)));
					p_act = a_buf;
				}
			}
			if (rest) {
				if (rest > 0) {
					r = rest > len ? len : rest;
					memcpy (pBuf, p_act, r);
					rest  -= r;
					p_act += r;
				}
				else {
					r = rest;
					rest = 0;
				}
			}
		}
		else {
			r = read(ss.m_fd, pBuf, len);
		}
	
		if (r > 0) {
			if (ss.m_log) {
				fwrite(pBuf,r,1,fp);
			}	
			ss.mp_cbuf->CommitFillBuffer(r);
			ss.m_recbytes += r;
			if (r > ss.m_recmax) {
				ss.m_recmax = r;
			}
		}
		else {
			if (r < 0) {
				if (errno != EINTR) {
					return(0);
				}
			}
		}
	}
	return(0);
}
