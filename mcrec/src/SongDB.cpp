// vim:ts=4:sw=4:ai

#ifdef __GNUG__
#pragma implementation
#endif

#include "SongDB.h"

#include <errno.h>
#include <strings.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

SongDB::SongDB(void)
{
	DBName = NULL;
	mcrecsongs = NULL;
	modified = false;
}

SongDB::~SongDB(void)
{
	struct SongEntry *currsong, *nextsong;

	currsong = mcrecsongs;
	while(currsong)
	{
		nextsong = currsong->nextsong;
		free(currsong);
		currsong = nextsong;
	}
}

int SongDB::loaddb(char * filename)
{
	FILE *dbfile;
	char tmpname[1024];
	int tmpsize, count = 0;
	struct SongEntry *currsong;

	currsong = NULL;
	DBName = strdup(filename);
	if ((dbfile = fopen(DBName, "r")) != NULL)
	{
		while ((fscanf(dbfile, "%512[^\n\r]\n%d\n", tmpname, &tmpsize)) != EOF)
		{
			count++;	
//			printf("%s, %d\n", tmpname, tmpsize);
			if (!mcrecsongs)
			{
				currsong = (struct SongEntry *)malloc(sizeof(struct SongEntry));
				mcrecsongs = currsong;
			}
			else
			{
				currsong->nextsong = (struct SongEntry *)malloc(sizeof(struct SongEntry));
				currsong = currsong->nextsong;
			}
			currsong->nextsong = NULL;
			currsong->songname = strdup(tmpname);
			currsong->songsize = tmpsize;
		}
		fclose(dbfile);
		fprintf(stderr, "\n   %d entries...", count);
		return(0);
	}
	else
		return(-1);
}

int SongDB::writedb(void)
{
	FILE *dbfile;
	struct SongEntry *currsong;

	if (!modified)
		return(0);
	currsong = mcrecsongs;

	if ((dbfile = fopen(DBName, "w")) != NULL)
	{
		while(currsong)
		{
			fprintf(dbfile, "%s\n%d\n", currsong->songname, currsong->songsize);
			currsong = currsong->nextsong;
		}
		fclose(dbfile);
		return(0);
	}
	else
		return(-1);
}


int SongDB::searchentry(char * songname, int songsize)
{
	struct SongEntry *currsong;

	currsong = mcrecsongs;
	while(currsong)
	{
		if((currsong->songsize == songsize) &&
		   (!(strcmp(currsong->songname, songname))))
		{
			return(1);
		}
		currsong = currsong->nextsong;
	}
	return(0);
}

int SongDB::addentry(char * songname, int songsize)
{
	FILE *dbfile;
	struct SongEntry *currsong;

	if (!mcrecsongs)
	{
		mcrecsongs = (struct SongEntry *)malloc(sizeof(struct SongEntry));
		currsong = mcrecsongs;
	}
	else
	{
		currsong = mcrecsongs;
		while(currsong->nextsong)
			currsong = currsong->nextsong;

		currsong->nextsong = (struct SongEntry *)malloc(sizeof(struct SongEntry));
		currsong = currsong->nextsong;
	}
	currsong->nextsong = NULL;
	currsong->songname = strdup(songname);
	currsong->songsize = songsize;
	if ((dbfile = fopen(DBName, "a")) != NULL)
	{
		fprintf(dbfile, "%s\n%d\n", currsong->songname, currsong->songsize);
		fclose(dbfile);
	}
	modified = true;
	return(0);
}
