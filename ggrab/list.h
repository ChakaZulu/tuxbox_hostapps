typedef double PTS;

typedef struct {
	CBUFPTR 	lptr;
	int		len;
	PTS     	pts;
	STARTFLAG	startflag;	
} PESELEM;

class xlist {


	public:
					xlist(class CBuffer *, S_TYPE);
		void			discard_elem(void);
		PESELEM			get_elem(void);
	 	unsigned char		sid(void);	
	 	S_TYPE 			type(void);	
		int			actcount(void);

		PESELEM  		m_list [100];
		int			m_maxcount;
		int			m_actcount;
		struct CBuffer * 	m_pbuffer;		
		pthread_mutex_t		m_mutexlock;
		pthread_cond_t		m_condreadwait;
		unsigned char 		m_sid;
		pthread_t		m_hthread;
		S_TYPE			m_type;
		


		
}; 
void *			m_fill_video (class xlist *);
void *			m_fill_audio (class xlist *);
