/*
   $Id: checkImage.c,v 1.2 2005/03/01 00:47:29 mogway Exp $

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

#define CHECKOFFSET 131049
#define CHECKINTERVAL 131072

int debug = 0;
int bad   = 0;
int skipuboot = 0x01ffe9;

void usage(char* name)
{
	fprintf(stderr, "Usage: %s <imagefile>\n", name);
	fprintf(stderr, "Check images for bad magics\n\n");
	fprintf(stderr, "-d : enable debug output\n");
	fprintf(stderr, "-f : u-boot is at first partition (default)\n");
	fprintf(stderr, "-l : u-boot is at last partition\n\n");
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
	if (debug)
		printf(" <- %s!", msg);
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

	if (debug)
		printf("\n");

	while ( pos <= imgsize)
	{
		if(lseek(fd, pos, SEEK_SET) == -1)
			printerror(fd, "Lseek on destination failed");

		if(read(fd, value, 23) == -1)
			printerror(fd, "Read on destination failed");

		if (debug)
			printf("0x%06x | %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x", pos, value[0], value[1], value[2], value[3], value[4], value[5], value[6], value[7], value[8], value[9], value[10], value[11], value[12], value[13], value[14], value[15], value[16], value[17], value[18], value[19], value[20], value[21], value[22]);

		if (pos == skipuboot)
		{
			if (debug)
 				printf(" <- skip u-boot");
		}
		else
		{
			if (value[1] <= 0xFE && (value[21] >= 0xc0 && value[21] <=0xc4) && ((value[22] &0x0f) == 0x06 || (value[22] &0x0f) == 0x0e))
				badmagic("bad magic in flash #1");

 			if (value[0] <= 0xFE && (value[19] >= 0xc0 && value[19] <=0xc4) && ((value[20] &0x0f) == 0x06 || (value[20] &0x0f) == 0x0e))
 				badmagic("bad magic in flash #2");

 			if (value[11] <= 0xFE && (value[21] >= 0xc0 && value[21] <=0xc4) && ((value[22] &0x0f) == 0x06 || (value[22] &0x0f) == 0x0e))
 				badmagic("bad magic");
 		}

		if (debug)
 			printf("\n");

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
		if ((c = getopt(argc, argv, "dfl")) < 0)
			break;
		switch (c) {
			case 'd': debug=1;
				  break;

			case 'f': skipuboot = 0x01ffe9;
				  break;

			case 'l': skipuboot = 0x7dffe9;
				  break;
		}
	}

	if(optind > argc-1)
	{
		usage((char*)basename(argv[0]));
		exit(1);
	}

	char* filename = argv[optind];

	checkimage(filename);

	if (debug)
 		printf("\n");

	printf("No bad magic bytes found\n");
	return 0;
}
