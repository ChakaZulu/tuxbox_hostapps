
#define MAXTAG      25
#define MAXTAGDATA 100

struct songinfo {
	bool gotinfo;
	bool valid;
	char track[MAXTAGDATA];
	char artist1[MAXTAGDATA];
	char artist2[MAXTAGDATA];
	char album[MAXTAGDATA];
	char year[MAXTAGDATA];
	char label[MAXTAGDATA];
};

struct id3{
	char tag[3];
	char songname[30];
	char artist[30];
	char album[30];
	char year[4];
	char comment[28];
	unsigned char empty;
	unsigned char tracknum;
	unsigned char genre;
};

HRESULT InitMCE();
HRESULT GetMCEInfo(const char *name, unsigned short port, char *channelName, struct songinfo *mysonginfo);
HRESULT DeInitMCE();
