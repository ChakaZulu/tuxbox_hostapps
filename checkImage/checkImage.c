/*
   $Id: checkImage.c,v 1.4 2005/03/03 23:08:17 mogway Exp $

   Check images for bad magics

   The idea is based on this thread:
   http://forum.tuxbox.org/forum/viewtopic.php?t=36032

   Copyright (C) 2005 mogway <mogway@yadi.org>

   License: GPL

   This program is free software; you can redistribute it and/or
   modify it under the terms of the GNU General Public License
   as published by the Free Software Foundation; either version 2
   of the License, or (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
   Or, point your browser to http://www.gnu.org/copyleft/gpl.html

*/

#include <unistd.h>
#include <stdio.h>
#include <fcntl.h>
#include <stdlib.h>
#include <string.h>

#define DPRINT(s, args...)		do { if(debug) printf(s, ## args); } while(0)

#define CHECKOFFSET 131049
#define CHECKINTERVAL 131072

int debug = 0;
int bad   = 0;
int skipuboot = 0;

void usage(char* name)
{
    fprintf(stderr, "%s - $Revision: 1.4 $\n",name);
	fprintf(stderr, "Check images for bad magics\n\n");
	fprintf(stderr, "Usage: %s [OPTION] <imagefile>\n\n", name);
	fprintf(stderr, "Options:\n");
	fprintf(stderr, "-h : display this help\n\n");
	fprintf(stderr, "-d : enable debug output\n");
	fprintf(stderr, "-f : u-boot is at first partition\n");
	fprintf(stderr, "-l : u-boot is at last partition\n\n");
	exit(1);
}

int getsize(int fd)
{
	int size = lseek( fd, 0, SEEK_END );
	return size;
}

void badimage(int fd)
{
	printf("!!! If you flash this image these bytes cause 'no system' !!!\n");
	putchar('\a');
	close(fd);
	exit(2);
}

void badmagic(char* msg)
{
	bad=1;
	DPRINT(" <- %s!", msg);
}

void printerror(int fd, char* msg)
{
	perror(msg);
	close(fd);
	exit(1);
}

void checkimage(char* filename)
{
	int fd;
	int pos = CHECKOFFSET;

	unsigned char value[23];

	if((fd = open(filename, O_RDWR)) == -1)
	{
		perror("Could not open image file");
		exit(1);
	}

	int imgsize = getsize(fd);

	printf("check '%s' for bad magic bytes.\n", basename(filename));

	DPRINT("\n");

	while ( pos <= imgsize)
	{
		if(lseek(fd, pos, SEEK_SET) == -1)
			printerror(fd, "Lseek on destination failed");

		if(read(fd, value, 23) == -1)
			printerror(fd, "Read on destination failed");

		if (debug)
		{
			printf("0x%06x | ", pos);
			printf("%02x %02x %02x %02x %02x  ", value[0],  value[1],  value[2],  value[3],  value[4]);
			printf("%02x %02x %02x %02x %02x  ", value[5],  value[6],  value[7],  value[8],  value[9]);
			printf("%02x %02x %02x %02x %02x  ", value[10], value[11], value[12], value[13], value[14]);
			printf("%02x %02x %02x %02x %02x  ", value[15], value[16], value[17], value[18], value[19]);
			printf("%02x %02x %02x",             value[20], value[21], value[22]);
		}

		if (pos == skipuboot)
			DPRINT(" <- skip u-boot");
		else if (
					value[0]  == 0x20 && value[1]  == 0x00 && value[2]  == 0x27 && value[3]  == 0x7b && value[4]  == 0x00 &&
					value[5]  == 0x00 && value[6]  == 0x00 && value[7]  == 0x00 && value[8]  == 0x20 && value[9]  == 0x00 &&
					value[10] == 0x00 && value[11] == 0x00 && value[12] == 0x00 && value[13] == 0x00 && value[14] == 0x00 &&
					value[15] == 0x00 && value[16] == 0x00 && value[17] == 0x00 && value[18] == 0x00 && value[19] == 0xff &&
					value[20] == 0xff && value[21] == 0xc3 && value[22] == 0xfe
				)
		    DPRINT(" <- this is u-boot 1x");
		else if (
					value[0]  == 0x00 && value[1]  == 0xff && value[2]  == 0xff && value[3]  == 0x00 && value[4]  == 0x00 &&
					value[5]  == 0x00 && value[6]  == 0x00 && value[7]  == 0x00 && value[8]  == 0x00 && value[9]  == 0x00 &&
					value[10] == 0x00 && value[11] == 0x00 && value[12] == 0x00 && value[13] == 0x00 && value[14] == 0x3f &&
					value[15] == 0xff && value[16] == 0xff && value[17] == 0xff && value[18] == 0xc0 && value[19] == 0xc3 &&
					value[20] == 0xfe && value[21] == 0xc3 && value[22] == 0xff
				)
		    DPRINT(" <- this is u-boot 2x");
		else
		{
			if (value[1] <= 0xFE && (value[21] >= 0xc0 && value[21] <=0xc4) && ((value[22] &0x0f) == 0x06 || (value[22] &0x0f) == 0x0e))
				badmagic("bad magic in flash #1");

 			if (value[0] <= 0xFE && (value[19] >= 0xc0 && value[19] <=0xc4) && ((value[20] &0x0f) == 0x06 || (value[20] &0x0f) == 0x0e))
 				badmagic("bad magic in flash #2");

 			if (value[11] <= 0xFE && (value[21] >= 0xc0 && value[21] <=0xc4) && ((value[22] &0x0f) == 0x06 || (value[22] &0x0f) == 0x0e))
 				badmagic("bad magic");
 		}

		DPRINT("\n");

	pos = pos + CHECKINTERVAL;
	}

	if (bad)
 		badimage(fd);

	close(fd);
}

int main(int argc, char *argv[])
{
	while (1)
	{
		int c;
		if ((c = getopt(argc, argv, "dfhl")) < 0)
			break;
		switch (c) {
			case 'd': debug=1;
					break;

			case 'f': skipuboot = 0x01ffe9;
					break;

			case 'h': usage((char*)basename(argv[0]));
					break;

			case 'l': skipuboot = 0x7dffe9;
					break;
		}
	}

	if(optind > argc-1)
		usage((char*)basename(argv[0]));

	char* filename = argv[optind];

	checkimage(filename);

	DPRINT("\n");

	printf("No bad magic bytes found\n");
	return 0;
}
