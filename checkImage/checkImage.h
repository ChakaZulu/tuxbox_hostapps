/*
   $Id: checkImage.h,v 1.2 2005/07/29 23:31:34 mogway Exp $

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

#ifndef __checkImage__
#define __checkImage__

#include <unistd.h>
#include <stdio.h>
#include <fcntl.h>
#include <stdlib.h>
#include <string.h>

#define DPRINT(s, args...)		do { if(debug) printf(s, ## args); } while(0)
#define VPRINT(s, args...)		do { if(verbose || debug) printf(s, ## args); } while(0)

#define CHECKOFFSET      131049     // start at 0x1ffe9
#define CHECKINTERVAL_1X 131072     // 1x Flash offset 128 Kb
#define CHECKINTERVAL_2X 65536      // 2x Flash offset 64 Kb
#define MAXIMAGESIZE     8257536

#define ANSI_BGRED       "\033[41m"
#define ANSI_NORM        "\033[0m"

// enable manual skip of u-boot
//#define SKIP_UBOOT

int debug          = 0;
int verbose        = 0;
int bad            = 0;
int skipuboot      = 0;

char flashtype[25] = "unknown";


void badImage(int fd);
void printError(int fd, char* msg);
void badMagic(char* msg);
void usage(char* name);

void printImageInfo(char* filename, int imgsize, char* fstype);
void scanBadMagic(int fd, int imgsize);
void checkImage(char* filename);

int getFlashType(int fd, int imgsize);
int getSize(int fd);

char* getFilesystemType(int fd);

#endif
