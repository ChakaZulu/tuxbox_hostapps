#include <stdio.h>
#include <pthread.h>
#include <errno.h>
#include <time.h>
#include "tools.h"
#include "cbuffer.h"
#include "list.h"

void * m_fill_video (void * p_arg) {

	unsigned char	a_buffer[16];
	unsigned char   sid;
	static	struct  timespec timeout;
	PTS		pts = -1.0;
	bool		found=false;
	CBUFPTR		lstart;
	CBUFPTR		lptr = 0;
	int		len;
	STARTFLAG	startflag;
	class xlist *   p_this = (class xlist *) p_arg;

	while (!found) {
		lptr = p_this->m_pbuffer->SearchStreamId(lptr,0,0,0, &sid);
		if ((sid & 0xf0) == 0xe0) {
			p_this->m_pbuffer->CopyBuffer(lptr, a_buffer);
			p_this->m_sid = sid;	
			pts = pes_pts(a_buffer);
		}

		if ((sid == 0xb3) && (pts >= 0)) {
			found = true;
			lstart = lptr;
			startflag=START_SEQ;
		}
		p_this->m_pbuffer->DiscardToPtr(lptr);
		lptr ++;
	}
			
	while (1) {
		pthread_mutex_lock (& (p_this->m_mutexlock));
		
		if (p_this->m_actcount == p_this->m_maxcount) {
			timeout.tv_sec = time(0) + 5;
			if (pthread_cond_timedwait(& (p_this->m_condreadwait), & (p_this->m_mutexlock), & timeout) == ETIMEDOUT) {
				errexit ("m_fill_video: timeout waiting with all buffers filled");
			}
		}
		pthread_mutex_unlock (& (p_this->m_mutexlock));
	
		lptr = p_this->m_pbuffer->SearchStreamId(lptr + 1,0,0xe0,0xf0, &sid);

		len = p_this->m_pbuffer->RemovePadding(lstart, lptr-lstart);
	
		pthread_mutex_lock (& (p_this->m_mutexlock));
	
		p_this->m_list[p_this->m_actcount].pts		= pts;
		p_this->m_list[p_this->m_actcount].lptr		= lstart;
		p_this->m_list[p_this->m_actcount].startflag	= startflag;
		p_this->m_list[p_this->m_actcount].len		= len;
		p_this->m_actcount ++;

		pthread_mutex_unlock (& (p_this->m_mutexlock));
		pthread_cond_broadcast(&(p_this->m_condreadwait));
		
		p_this->m_pbuffer->CopyBuffer(lptr, a_buffer);
		pts = pes_pts(a_buffer);
		startflag = NO_START;
		
		lstart = p_this->m_pbuffer->SearchStreamId(lptr + 1,0,0,0,&sid);

		p_this->m_pbuffer->CopyBuffer(lstart, a_buffer);

		if (sid == 0xb3) {
			startflag = START_SEQ;
		}
		if (sid == 0xb8) {
			startflag = START_GOP;
		}
		
	}	
}

void  * m_fill_audio (void * p_arg) {

	unsigned char	a_buffer[16];
	unsigned char   sid;
	static	struct  timespec timeout;
	PTS		pts = -1.0;
	bool		found=false;
	CBUFPTR		lstart;
	int		len;
	CBUFPTR		lptr = 0;
	class xlist *   p_this = (class xlist *) p_arg;

	while (!found) {
		lptr = p_this->m_pbuffer->SearchStreamId(lptr,0,0,0, &sid);
		if (((sid & 0xe0) == 0xc0) || sid == 0xbd) {
			p_this->m_pbuffer->CopyBuffer(lptr, a_buffer);
			pts = pes_pts(a_buffer);
			p_this->m_sid = sid;	
			p_this->m_pbuffer->CopyBuffer(lptr+pes_len(a_buffer) + 6, a_buffer);
			if (a_buffer[3] == sid) {
				found = true;	
				lstart = lptr + 9 + a_buffer[8];
				len = pes_len(a_buffer) - 3 - a_buffer[8];
			}
		}
		lptr ++;
	}
			
	while (1) {
		pthread_mutex_lock (& (p_this->m_mutexlock));
		
		if (p_this->m_actcount == p_this->m_maxcount) {
			timeout.tv_sec = time(0) + 5;
			if (pthread_cond_timedwait(& (p_this->m_condreadwait), & (p_this->m_mutexlock), & timeout) == ETIMEDOUT) {
				errexit ("m_fill_audio: timeout waiting with all buffers filled");
			}
		}
		p_this->m_list[p_this->m_actcount].pts		= pts;
		p_this->m_list[p_this->m_actcount].lptr		= lstart;
		p_this->m_list[p_this->m_actcount].startflag	= NO_START;
		p_this->m_list[p_this->m_actcount].len		= len;
		p_this->m_actcount ++;

		pthread_mutex_unlock (& (p_this->m_mutexlock));
		pthread_cond_broadcast(&(p_this->m_condreadwait));

		lptr = lstart + len;
		found = false;
		while (!found) {
			lptr = p_this->m_pbuffer->SearchStreamId(lptr,0,sid,0xff);
			p_this->m_pbuffer->CopyBuffer(lptr, a_buffer);
			pts = pes_pts(a_buffer);
			if (pes_len(a_buffer) > 9000) {
				fprintf(stderr,"m_fill_audio: not plausible audio length: %u\n",pes_len(a_buffer));
			}
			else {
				p_this->m_pbuffer->CopyBuffer(lptr+pes_len(a_buffer) + 6, a_buffer);
				if (a_buffer[3] == sid) {
					found = true;	
					lstart = lptr + 9 + a_buffer[8];
					len = pes_len(a_buffer) - 3 - a_buffer[8];
				}
				else {
					fprintf(stderr,"m_fill_audio: next audio frame failed, found: %02X\n", a_buffer[3]);
				}
			}
			lptr ++;
		}
	}	
}

xlist::xlist (struct CBuffer * pBuf, int type) {

	m_pbuffer = pBuf;

	pthread_cond_init(&m_condreadwait, 0);
	pthread_mutex_init(&m_mutexlock, 0);


	m_actcount = 0;
	m_maxcount = 100;

	if (type == TYPE_VIDEO) {
		pthread_create( & m_hthread,0, m_fill_video, this);
	}
	else {
		pthread_create( & m_hthread,0, m_fill_audio, this);
	}
}

void
xlist::discard_elem (void) {

	int		i;

	m_pbuffer->DiscardToPtr(m_list[0].lptr);
	
	pthread_mutex_lock (& m_mutexlock);  

	for (i = 1; i < m_actcount; i++) {
		m_list[i-1] = m_list [i];
	}

	m_actcount--;

	pthread_mutex_unlock (& m_mutexlock);
	pthread_cond_broadcast(&m_condreadwait);
}

PESELEM
xlist::get_elem (void) {

	PESELEM ret;	
	static struct timespec timeout;
	
	pthread_mutex_lock (& m_mutexlock);  
	while (m_actcount == 0) {
		timeout.tv_sec = time(0) + 5;
		if (pthread_cond_timedwait(& m_condreadwait, & m_mutexlock, & timeout) == ETIMEDOUT) {
			errexit ("xlist::getelem timeout wait for data");
		}
	}
	ret = m_list[0];
	pthread_mutex_unlock (& m_mutexlock);

	return (ret);
}

unsigned char 
xlist::sid(void) {
	static struct timespec timeout;
	unsigned char mysid;
	pthread_mutex_lock (& m_mutexlock);  
	while (m_actcount == 0) {
		timeout.tv_sec = time(0) + 5;
		if (pthread_cond_timedwait(& m_condreadwait, & m_mutexlock, & timeout) == ETIMEDOUT) {
			errexit ("xlist::sid: timeout wait for data");
		}
	}
	
	pthread_mutex_unlock (& m_mutexlock);

	if (m_sid != 0xbd) {
		mysid = 0xc0;
	}
	else {
		mysid = 0xbd;
	}
	
	return(mysid);
}
