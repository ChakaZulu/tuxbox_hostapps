#define MAX_PP_LEN	2048          // Program Packet Rate
#define MPLEX_RATE	10080000     
#define VIDEO_FORERUN 	14000         // Viedo Vorlauf in 90kHz
#define AUDIO_FORERUN 	3600          // Audio Vorlauf in 90 kHz
#define READ_DELAY	20            // Read Delay in ms

typedef enum STARTFLAG {NO_START=0, START_SEQ, START_GOP};

typedef double PTS;
typedef struct {
	unsigned char * p_buffer;
	int		len;
	PTS		src_wanted;
	STARTFLAG	startflag;
} PROPACK;




PTS pes_pts (const unsigned char * p_buffer);
int pes_len (const unsigned char * p_buffer);

void fill_pes_len(unsigned char * p_pes, int len);
void fill_pes_pts(unsigned char * p_pes, double pts);
void fill_pp_scr (unsigned char * p_pp, double scr);

void errexit(char* p_text);
