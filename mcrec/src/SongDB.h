// vim:ts=4:sw=4:ai

#ifndef SongDB_h
#define SongDB_h

#ifdef __GNUG__
#pragma interface
#endif

class SongDB {
protected:
	
	char * DBName;

	struct SongEntry {
		struct SongEntry *nextsong;
		char * songname;
		int songsize;
	};
		
	struct SongEntry *mcrecsongs;
	int modified;

public:
	
	SongDB(void);
	int loaddb(char * filename);
	int writedb(void);
	int searchentry(char * songname, int songsize);
	int addentry(char * songname, int songsize);
	~SongDB(void);
};


#endif // SongDB_h

