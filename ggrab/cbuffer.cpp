#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#include <errno.h>
#include "cbuffer.h"

CBuffer::CBuffer(int size) {
	
	m_pBuf=(unsigned char *) malloc(size+3);
	
	if (!m_pBuf) {
		errexit("Fehler malloc Puffer");
	}

	m_pIn  		= m_pBuf;
	m_pOut 		= m_pBuf;
	m_size 		= size;
	m_lIn 		= 0;
	m_lOut 		= 0;
	
	pthread_mutex_init (&m_mutexlock, NULL);
	pthread_cond_init (&m_condreadwait, NULL);
}

CBuffer::~CBuffer() {
	free(m_pBuf);
}

int CBuffer::GetNextFillBuffer(unsigned char ** ppBuf) {
	int len;
	
	pthread_mutex_lock (& m_mutexlock);
	
	*ppBuf=m_pIn;
	
	if (m_pOut > m_pIn) {
		len = m_pOut - m_pIn;
	}
	else {
		len = m_pBuf + m_size - m_pIn;
	}
	if ((m_lIn - m_lOut + len) == m_size) {
		len --;
	}
	
	pthread_mutex_unlock (& m_mutexlock);
	
	return (len);
}

void CBuffer::CommitFillBuffer(int len) {

	pthread_mutex_lock (& m_mutexlock);
	
	m_pIn 		+= len;
	m_lIn		+= len;

	if (m_pIn == (m_pBuf + m_size)) {
		m_pIn -= m_size;
	}
	pthread_mutex_unlock (& m_mutexlock);
	pthread_cond_broadcast(&m_condreadwait);
	
}

CBUFPTR CBuffer::GetActPtr (void) {
	
	return (m_lOut);
}

void CBuffer::DiscardToPtr(CBUFPTR ptr) {
	
	pthread_mutex_lock (& m_mutexlock);
	
	int bytes = ptr - m_lOut;

	if ((ptr < m_lOut) || (ptr > m_lIn)) {
		fprintf (stderr, "ptr:%lld lIn:%lld lOut:%lld\n", ptr, m_lIn, m_lOut);
		errexit ("Underrun at DiscardToPtr");
	}		


	m_lOut  = ptr;
	m_pOut += bytes;

	if (m_pOut >= (m_pBuf + m_size)) {
		m_pOut -= m_size;
	}
	pthread_mutex_unlock (& m_mutexlock);
}
		
int CBuffer::GetByteCount(void) {
	
	int bytes;
	
	pthread_mutex_lock (& m_mutexlock);

	bytes = m_lIn - m_lOut;

	pthread_mutex_unlock (& m_mutexlock);
	
	return (bytes);
}

CBUFPTR CBuffer::SearchStreamId (CBUFPTR ptr, int len, unsigned char pattern, unsigned char mask, unsigned char * p_id) {

	bool 			found = false;
	unsigned char * 	p_act;
	int			lens;
	int			len2;
	CBUFPTR                 lfound = -1;
	static timespec		timeout;

	pthread_mutex_lock (& m_mutexlock);
	
	if (len == 0) {
		// special: len = 0 -> large search with max buffersize 
		len = m_size;
	}
	
	if ((ptr < m_lOut) || (ptr > m_lIn)) {
		fprintf (stderr, "ptr:%lld lIn:%lld lOut:%lld\n", ptr, m_lIn, m_lOut);
		errexit ("Pufferfehler SearchStreamID");
	}

	p_act = m_pOut + (ptr - m_lOut);

	if (p_act >= (m_pBuf + m_size)) {
		p_act -= m_size;
	}
	
	while (!found && len) {
		if (p_act <= m_pIn) {
			len2 = m_pIn - p_act - 3;
			len2 = (len2 > 0)?len2:0;
			lens = (len2 > len)?len:len2;
			len -= lens;
			while ((lens > 0) && !found) {
				if ( (p_act[0] == 0) 
				  && (p_act[1] == 0)
				  && (p_act[2] == 1)
				  && ((p_act[3] & mask) == pattern)
				  ) {
					lfound = m_lIn - (m_pIn - p_act);
					found = true;
				}
				else {
					p_act ++;
					lens --;
				}
			}
		}
		else {
			len2 = m_pBuf + m_size - p_act;
			if ((m_pIn - m_pBuf) >= 3) {
				memcpy (m_pBuf + m_size, m_pBuf, 3);
			}		
			else {
				len2 -= 3;
				if (len2 < 0) {
					len2 = 0;
				}
			}
			
			lens = (len2 > len)?len:len2;
			len -= lens;
			
			while ((lens > 0) && !found) {
				if ( (p_act[0] == 0) 
				  && (p_act[1] == 0)
				  && (p_act[2] == 1)
				  && ((p_act[3] & mask) == pattern)
				  ) {
					found = true;
					lfound = m_lOut + p_act - m_pOut;
				}
				else {
					p_act ++;
					lens --;
				}
			}
			
			if (p_act ==  (m_pBuf + m_size)) {
			 	p_act -= m_size;
				continue;
			}
			 	
		}
		
		if (!found && len) {
			timeout.tv_sec = time(0) + 5;
			if (pthread_cond_timedwait(& m_condreadwait, & m_mutexlock, & timeout) == ETIMEDOUT) {
				errexit ("SearchStreamId: timeout wait for data");
			}
		}
	}
	pthread_mutex_unlock (& m_mutexlock);
	if (found && p_id) {
		*p_id = p_act[3];
	}
	return (lfound);
}


int CBuffer::CopyBuffer(CBUFPTR ptr, unsigned char * p_buf, int len)  {


	unsigned char * 	p_act;
	int			len2;
	int			lens;
	static timespec		timeout;
	
	pthread_mutex_lock (& m_mutexlock);
	
	if (ptr < m_lOut ) {
		fprintf (stderr,"ptr:%lld, lIn:%lld, lOut:%lld\n",ptr,m_lIn,m_lOut);
		errexit ("CopyBuffer: data not avaiable in buffer");
	}

	while ((ptr+len) > m_lIn) {
		timeout.tv_sec = time(0) + 5;
		if (pthread_cond_timedwait(& m_condreadwait, & m_mutexlock, & timeout) == ETIMEDOUT) {
			errexit ("CopyBuffer: timeout waiting for data");
		}
	}
	p_act = m_pOut + (ptr - m_lOut);
		
	if (p_act >= (m_pBuf + m_size)) {
		p_act -= m_size;
	}
		
	if (p_act > m_pIn) {
		len2 = m_pBuf + m_size - p_act; 
		lens = (len2 > len)?len:len2;
		len  -= lens;

		memcpy (p_buf, p_act, lens);
		p_buf += lens;

		p_act = m_pBuf;
	}

	if (len > 0) { 
		memcpy (p_buf, p_act, len);
		len = 0;
	}
	pthread_mutex_unlock (& m_mutexlock);
	return (1);
}			
