#define MAX_PP_LEN	2048			// Program Packet Size
#define MPLEX_RATE	10080000     
#define VIDEO_FORERUN 	18000			// Video Vorlauf in 90kHz
#define AUDIO_FORERUN 	4500			// Audio Vorlauf in 90 kHz
#define UDPBASE		30000	      		// UDP Base Port
#define UDP_MSG_LEN     65536			// UDP Message-Laenge
#define TIMEOUT_QUEUE	3

extern bool gcore;
extern bool gloop;

typedef enum STARTFLAG {NO_START=0, START_SEQ, START_GOP};

typedef double PTS;

PTS 	pes_pts (const unsigned char * p_buffer);
int 	pes_len (const unsigned char * p_buffer);
FILE *  open_next_output_file (FILE * fp, char * p_basename, char * p_ext, int & seq);

void 	fill_pes_len(unsigned char * p_pes, int len);
void 	fill_pes_pts(unsigned char * p_pes, PTS pts);
void 	fill_pp_scr (unsigned char * p_pp, PTS scr);

void 	errexit(char* p_text);



typedef enum {
	S_UNDEF,
	S_VIDEO,
	S_AUDIO
} S_TYPE;

class propack {
	public:
		propack (void) {
			static unsigned char a_pheader[] =
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
				0x00
			};

			memcpy (ma_buffer, a_pheader, 14);
			mp_act = ma_buffer + 14;
			m_len = sizeof(ma_buffer);

		}

		inline void reset(void) {
			mp_act = ma_buffer + 14;
			m_len  = sizeof(ma_buffer);
		}
		
		inline void set_scr_wanted(PTS pts) {
			m_scr_wanted = pts;
		}

		inline void fill_scr(PTS scr) {
			fill_pp_scr(ma_buffer, scr);
		}
		
		inline PTS get_scr_wanted(void) {
			return (m_scr_wanted);
		}
		
		inline int get_len(void) {
			return (m_len);
		}
		
		inline int get_restlen (void) {
			return (sizeof(ma_buffer) - (mp_act-ma_buffer));
		}
		
		inline void commitlen(int clen) {
			mp_act += clen;
		}
		inline unsigned char * get_pact(void) {
			return(mp_act);
		}
		inline unsigned char * get_bufptr(void) {
			return (ma_buffer);
		}
		inline void set_startflag (STARTFLAG startflag) {
			m_startflag = startflag;
		}
		inline STARTFLAG get_startflag (void) {
			return (m_startflag);
		}
		
	
	private:
		unsigned char   ma_buffer[MAX_PP_LEN];
		unsigned char * mp_act;
		int		m_len;
		PTS		m_scr_wanted;
		STARTFLAG	m_startflag;
};






