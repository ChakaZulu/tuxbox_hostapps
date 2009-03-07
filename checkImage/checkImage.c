/*
   $Id: checkImage.c,v 1.8 2009/03/07 18:28:03 rhabarber1848 Exp $

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

#include "checkImage.h"
#include <libgen.h>
void usage(char* name)
{
    fprintf(stderr, "%s - $Revision: 1.8 $\n",name);
	fprintf(stderr, "Check images for bad magics\n\n");
	fprintf(stderr, "Usage: %s [OPTION] <imagefile>\n\n", name);
	fprintf(stderr, "Options:\n");
	fprintf(stderr, "-h : display this help\n\n");
	fprintf(stderr, "-d : enable debug output\n");
#ifdef SKIP_UBOOT
	fprintf(stderr, "-f : u-boot is at first partition\n");
	fprintf(stderr, "-l : u-boot is at last partition\n");
#endif
	fprintf(stderr, "-v : enable verbose output\n\n");
	exit(1);
}

int getSize(int fd)
{
	int size = lseek( fd, 0, SEEK_END );
	return size;
}

void badImage(int fd)
{
	printf("%s!!! If you flash this image these bytes cause 'no system' !!!%s\n",ANSI_BGRED, ANSI_NORM);
	putchar('\a');
	close(fd);
	exit(2);
}

void badMagic(char* msg)
{
	bad=1;
	DPRINT(" <- %s!", msg);
}

void printError(int fd, char* msg)
{
	perror(msg);
	close(fd);
	exit(1);
}

void printImageInfo(char* filename, int imgsize, char* fstype)
{
	printf("Check image for bad magic bytes:\n\n");
	printf("Imagename.: %s\n", basename(filename));
	printf("Imagesize.: %d bytes\n", imgsize);
	printf("Flashtype.: %s\n", flashtype);
	printf("Filesystem: %s\n", fstype);
}

int getFlashType(int fd, int imgsize)
{
	int pos = CHECKOFFSET;
	int checkIntervall = CHECKINTERVAL_1X;
	unsigned char value[23];

    while ( pos <= imgsize)
    {
		if(lseek(fd, pos, SEEK_SET) == -1)
			printError(fd, "Lseek on destination failed");

		if(read(fd, value, 23) == -1)
			printError(fd, "Read on destination failed");

		if (
					value[0]  == 0x20 && value[1]  == 0x00 && value[2]  == 0x27 && value[3]  == 0x7b &&
					value[4]  == 0x00 && value[5]  == 0x00 && value[6]  == 0x00 && value[7]  == 0x00 &&
					value[8]  == 0x20 && value[9]  == 0x00 && value[10] == 0x00 && value[11] == 0x00 &&
					value[12] == 0x00 && value[13] == 0x00 && value[14] == 0x00 && value[15] == 0x00 &&
					value[16] == 0x00 && value[17] == 0x00 && value[18] == 0x00 && value[19] == 0xff &&
					value[20] == 0xff && value[21] == 0xc3 && value[22] == 0xfe
				)
		{
			strcpy(flashtype,"1x Flash");
			checkIntervall = CHECKINTERVAL_1X;
		} else if (
					value[0]  == 0x00 && value[1]  == 0xff && value[2]  == 0xff && value[3]  == 0x00 &&
					value[4]  == 0x00 && value[5]  == 0x00 && value[6]  == 0x00 && value[7]  == 0x00 &&
					value[8]  == 0x00 && value[9]  == 0x00 && value[10] == 0x00 && value[11] == 0x00 &&
					value[12] == 0x00 && value[13] == 0x00 && value[14] == 0x3f && value[15] == 0xff &&
					value[16] == 0xff && value[17] == 0xff && value[18] == 0xc0 && value[19] == 0xc3 &&
					value[20] == 0xfe && value[21] == 0xc3 && value[22] == 0xff
				)
		{
		    strcpy(flashtype,"2x Flash");
		    checkIntervall = CHECKINTERVAL_2X;
		}

		pos = pos + CHECKINTERVAL_1X;
	}
	return checkIntervall;
}

char* getFilesystemType(int fd)
{
	int pos = 0;
	unsigned char value[32];

	if(lseek(fd, pos, SEEK_SET) == -1)
		printError(fd, "\nLseek on destination failed\n");

	if(read(fd, value, 32) == -1)
		printError(fd, "\nRead on destination failed\n");

	if (value[0] == 0x73 && value[1] == 0x71 && value[2] == 0x73 && value[3] == 0x68)
		return "squashfs";

	else if (value[0] == 0x19 && value[1] == 0x85)
		return "jffs2";
	else if (
				value[16] == 0x43 && value[17] == 0x6F && value[18] == 0x6d && value[19] == 0x70 &&
				value[20] == 0x72 && value[21] == 0x65 && value[22] == 0x73 && value[23] == 0x73 &&
				value[24] == 0x65 && value[25] == 0x64 && value[26] == 0x20 && value[27] == 0x52 &&
				value[28] == 0x4f && value[29] == 0x4d && value[30] == 0x46 && value[31] == 0x53
			)
		return "cramfs";
	else if (
				value[8]  == 0x74 && value[9]  == 0x75 && value[10] == 0x78 && value[11] == 0x62 &&
				value[12] == 0x6f && value[13] == 0x78 && value[14] == 0x66 && value[15] == 0x73
			)
	{
		strcpy(flashtype,"1x Flash");
		return "flfs";
	}
	else if (
				value[16] == 0x74 && value[17] == 0x75 && value[20] == 0x78 && value[21] == 0x62 &&
				value[24] == 0x6f && value[25] == 0x78 && value[28] == 0x66 && value[29] == 0x73
			)
	{
		strcpy(flashtype,"2x Flash");
		return "flfs";
	}
	else
		return "unknown";
}

void scanBadMagic(int fd, int imgsize)
{
	int pos = CHECKOFFSET;
	unsigned char value[23];
	int checkIntervall = getFlashType(fd, imgsize);

	while ( pos <= imgsize)
	{
		if(lseek(fd, pos, SEEK_SET) == -1)
			printError(fd, "\nLseek on destination failed\n");

		if(read(fd, value, 23) == -1)
			printError(fd, "\nRead on destination failed\n");

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
					value[0]  == 0x20 && value[1]  == 0x00 && value[2]  == 0x27 && value[3]  == 0x7b &&
					value[4]  == 0x00 && value[5]  == 0x00 && value[6]  == 0x00 && value[7]  == 0x00 &&
					value[8]  == 0x20 && value[9]  == 0x00 && value[10] == 0x00 && value[11] == 0x00 &&
					value[12] == 0x00 && value[13] == 0x00 && value[14] == 0x00 && value[15] == 0x00 &&
					value[16] == 0x00 && value[17] == 0x00 && value[18] == 0x00 && value[19] == 0xff &&
					value[20] == 0xff && value[21] == 0xc3 && value[22] == 0xfe
				)
		    DPRINT(" <- this is u-boot 1x");
		else if (
					value[0]  == 0x00 && value[1]  == 0xff && value[2]  == 0xff && value[3]  == 0x00 &&
					value[4]  == 0x00 && value[5]  == 0x00 && value[6]  == 0x00 && value[7]  == 0x00 &&
					value[8]  == 0x00 && value[9]  == 0x00 && value[10] == 0x00 && value[11] == 0x00 &&
					value[12] == 0x00 && value[13] == 0x00 && value[14] == 0x3f && value[15] == 0xff &&
					value[16] == 0xff && value[17] == 0xff && value[18] == 0xc0 && value[19] == 0xc3 &&
					value[20] == 0xfe && value[21] == 0xc3 && value[22] == 0xff
				)
		    DPRINT(" <- this is u-boot 2x");
		else
		{
			if (value[1] <= 0xFE && (value[21] >= 0xc0 && value[21] <=0xc4) && ((value[22] &0x0f) == 0x06 || (value[22] &0x0f) == 0x0e))
				badMagic("bad magic in flash #1");

			if (value[0] <= 0xFE && (value[19] >= 0xc0 && value[19] <=0xc4) && ((value[20] &0x0f) == 0x06 || (value[20] &0x0f) == 0x0e))
				badMagic("bad magic in flash #2");

 			if (value[11] <= 0xFE && (value[21] >= 0xc0 && value[21] <=0xc4) && ((value[22] &0x0f) == 0x06 || (value[22] &0x0f) == 0x0e))
				badMagic("bad magic");
		}

		DPRINT("\n");

	pos = pos + checkIntervall;

	}

	if (bad)
		badImage(fd);
}

void checkImage(char* filename)
{
	// first open the image file
	int fd;
	if((fd = open(filename, O_RDWR)) == -1)
	{
		perror("Could not open image file");
		exit(1);
	}

	// get filesize
	int imgsize = getSize(fd);

	// check image size
	if (imgsize > MAXIMAGESIZE )
	{
		printf("check '%s' \n", basename(filename));
		printf("%s!!! Flash size exceeded, if you flash this image you may get 'no system' !!!%s\n",ANSI_BGRED, ANSI_NORM);
		putchar('\a');
		close(fd);
		exit(3);
	}

	// print info
	if (verbose || debug)
	{
		getFlashType(fd, imgsize);
		if (imgsize == MAXIMAGESIZE)
		{
			printImageInfo(basename(filename), imgsize, "complete image");
		} else {
			printImageInfo(basename(filename), imgsize, getFilesystemType(fd));
		}
	}
	else
		printf("check '%s' for bad magic bytes.\n", basename(filename));

	VPRINT("\n");

	// now lets check for BadMagics
	scanBadMagic(fd, imgsize);

	close(fd);
}

int main(int argc, char *argv[])
{
	while (1)
	{
		int c;

#ifdef SKIP_UBOOT
		if ((c = getopt(argc, argv, "dfhlv")) < 0)
			break;
#else
		if ((c = getopt(argc, argv, "dhv")) < 0)
			break;
#endif

		switch (c) {
			case 'd': debug=1;
					break;

			case 'h': usage((char*)basename(argv[0]));
					break;

			case 'v': verbose=1;
					break;
#ifdef SKIP_UBOOT
			case 'f': skipuboot = 0x01ffe9;
					break;

			case 'l': skipuboot = 0x7dffe9;
					break;
#endif
		}
	}

	if(optind > argc-1)
		usage((char*)basename(argv[0]));

	char* filename = argv[optind];

	checkImage(filename);

	DPRINT("\n");

	printf("No bad magic bytes found\n");
	DPRINT("\n");

	return 0;
}
