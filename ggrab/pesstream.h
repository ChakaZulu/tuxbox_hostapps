
int 	openStream(char * name, int port, int pid, int udpport, int * udpsocket);
void  * readstream (class pesstream & ss);


class pesstream {

	public:
		pesstream (S_TYPE stype, char * p_boxname, int pid, int port, int udpport, bool log, bool debug);
		~pesstream(void);
		int get_sid (void);
		void set_sid (int sid);
		PTS get_start_pts (void);
		void get_pp_stats (char * p_buffer, int len);
		void set_pts_offset (PTS pts);
		void fill_video_pp (class propack * p_pp);
		void fill_audio_pp (class propack * p_pp);
		void fill_pp(class propack * p_pp);
		int  fill_raw_audio (unsigned char *  p_buf);
		int  fill_pes_packet (unsigned char *  p_buf);
	
		friend void * readstream (class pesstream & b);


	private:
		static int		m_st_nr;
		int			m_nr;
		enum S_TYPE		m_stype;
		class CBuffer *		mp_cbuf;
		class xlist *		mp_list;

		pthread_t		mh_thread;

		CBUFPTR			ml_act;
		PESELEM			m_elem;
		int			m_restlen;
		unsigned char		m_sid;

		int			m_fd;
		int			m_fd_udp;
		
		
	
		bool			m_first;
		bool			m_log;

		PTS			m_correct;

		// Statistics
		bool			m_debug;
		double			m_delta;
		int			m_packloss;
		int			m_recbytes;
		int			m_recmax;
		int			m_padding;
		struct	timeval		m_last_time;

		// Some Specialties Video
		PTS			m_scr_wanted;
		STARTFLAG		m_startflag;
			
		bool			m_flag_set_pts;

		// Statistics Video
		int			m_pics;
		

		// Some Specialties for Audio
		PTS			m_pts_per_byte;
		PTS			m_act_pts;
		PTS			m_last_pts;

		// Statistics Audio
		double			m_xaudio;
};
