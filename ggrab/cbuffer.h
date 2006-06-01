typedef long long CBUFPTR;
extern void errexit(char *);
extern int gpadding;


class CBuffer {
	public:
		CBuffer(int size=100000);
		~CBuffer();

		int 		GetNextFillBuffer(unsigned char ** ppBuf);
		void		CommitFillBuffer (int len);
		CBUFPTR		GetActPtr(void);
		void		DiscardToPtr(CBUFPTR ptr);
		CBUFPTR		SearchStreamId(CBUFPTR ptr, int len, unsigned char pattern, unsigned char mask, unsigned char * p_id=0);
		int		GetByteCount(void);
		int             CopyBuffer(CBUFPTR ptr, unsigned char * pBuf, int len=16);
		int 		RemovePadding(CBUFPTR lptr, int len);
		

	private:
		unsigned char * 	m_pBuf;
		unsigned char * 	m_pIn;
		unsigned char * 	m_pOut;
		int			m_size;
		CBUFPTR 		m_lIn;
		CBUFPTR			m_lOut;
		pthread_mutex_t		m_mutexlock;
		pthread_cond_t		m_condreadwait;
		
};

		
		
		
