/*
 * $Id: ucodex.c,v 1.2 2002/08/30 23:45:38 obi Exp $
 *
 * extract avia firmware from srec and binary files
 *
 * (C) 2002 by Andreas Oberritter <obi@tuxbox.org>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <openssl/md5.h>

struct ucode_s {
	unsigned char name[13];
	unsigned char version[17];
	size_t size;
	unsigned char md5sum[MD5_DIGEST_LENGTH];
};

struct ucode_type_s {
	unsigned char name[9];
	unsigned char magic[6];
	unsigned int voffset;
	unsigned char vlength;
	struct ucode_s ucodes[5];
};

struct ucode_type_s types[] = {
	{
		"avia500", "\x43\x33\x55\x58\x02", 832, 16,
		{
			{"avia500v083", "08Feb99/17000D83",  92918, "\x96\x5d\x83\x4c\x7b\xb7\x43\xdf\x68\x41\xf4\xfd\xa5\xb4\xe7\x90"},
			{"avia500v090", "28Apr99/10350D90",  92894, "\x10\x8f\xa2\xfa\x0e\xe8\x44\x51\xea\x7e\xa2\xdb\x9a\xda\xa4\x4b"},
			{"avia500v093", "05Oct99/10300D93", 101318, "\xfe\xce\x1d\x33\x24\xe0\x91\x7b\x92\x1d\x81\x44\x90\xd8\xa8\x24"},
			{"avia500v110", "03Nov00/16121D10", 101374, "\x73\x73\xf3\x93\x42\x63\xb3\xc3\xea\x1d\x0f\x50\x0f\x00\x44\xa5"},
			{"", "", 0, ""}
		}
	},{
		"avia600", "\x43\x33\x55\x58\x01", 832, 16,
		{
			{"avia600vb017", "28Jan00/1750b017", 126846, "\xda\x49\x21\x46\xba\x7e\x17\x78\x83\xfe\xad\xaa\x0c\xf8\x9a\xa5"},
			{"avia600vb018", "28Apr00/1514b018", 126878, "\xc3\x1d\xc5\x70\xcf\x94\x1a\xfb\x6f\xc4\x81\x3f\x56\x1a\xa3\x78"},
			{"avia600vb022", "28Nov00/1412b022", 128214, "\x6a\x74\x8f\xb2\x80\x00\x73\x8c\xaf\xeb\x9e\x27\x44\x3a\xc6\x23"},
			{"", "", 0, ""},
			{"", "", 0, ""}
		}
	},{
		"dmx", "\xB0\x09\xA8", 663, 1,
		{
			{"ucode_0000", "\x20", 1024, "\x53\xc5\xbc\x40\x81\xdf\xad\xab\x99\x35\xad\x25\x6e\x4d\x62\x39"},
			{"ucode_0013", "\x3F", 2048, "\x66\x62\x7c\x5d\xdf\x26\x9a\x1f\x3a\x9f\x9f\x3c\x22\xfb\xd4\x1b"},
			{"ucode_0014", "\x2F", 2048, "\x65\x82\xa8\x9e\x7e\x13\xe4\x10\xc3\x66\xe4\x7b\x4e\xf9\xd3\x8e"},
			{"ucode_B107", "\x00", 2048, "\xd4\xc1\x2d\xf0\xd4\xce\x8b\xa9\xeb\x85\x85\x09\xd8\x32\xdf\x65"},
			{"ucode_B121", "\xC4", 2048, "\x4e\x08\x08\x73\x12\x6f\x15\x6a\x0b\x48\x9a\xf1\x76\x52\x06\x20"}
		}
	}
};

unsigned int char2hex (unsigned char * src, unsigned char * dest, unsigned int size) {

	unsigned int count = 0;
	unsigned char tmp[3];

	tmp[2] = 0x00;

	while (count != size) {
		memcpy(tmp, src, 2);
		*dest = strtoul(tmp, NULL, 16);
		src += 2;
		dest++;
		count++;
	}

	return count;
}

int writebuf (unsigned char * filename, unsigned char * buf, unsigned int size, unsigned char * md5sum) {

	/* verbose */
	if (1) {
		unsigned char i;
		unsigned char md[MD5_DIGEST_LENGTH];

		MD5(buf, size, md);

		for (i = 0; i < MD5_DIGEST_LENGTH; i++)
			printf("%02x", md[i]);

		printf("\t%s", filename);

		if (!memcmp(md5sum, md, MD5_DIGEST_LENGTH))
			printf("\tchecksum okay\n");
		else
			printf("\tchecksum mismatch\n");
	}

	/* write */
	if (1) {
		FILE * file = fopen(filename, "w");

		if (file == NULL) {
			perror(filename);
			return EXIT_FAILURE;
		}

		fwrite(buf, size, 1, file);

		if (fclose(file) < 0) {
			perror("fclose");
			return EXIT_FAILURE;
		}
	}

	return EXIT_SUCCESS;
}

long file_size (FILE * file) {

	long size;

	if (fseek(file, 0, SEEK_END) == -1) {
		perror("fseek");
		return -1;
	}

	size = ftell(file);

	if (size == -1) {
		perror("ftell");
		return -1;
	}

	rewind(file);

	return size;
}

int main (int argc, char ** argv) {

	FILE * file;
	int probe;

	unsigned char * buf;
	long buf_size;

	unsigned int i, j;

	unsigned char * psrc = NULL;
	unsigned char * pdest = NULL;

	if (argc < 2) {
		printf("usage: %s <file>\n", argv[0]);
		return EXIT_FAILURE;
	}

	/* read file into buffer */
	file = fopen(argv[1], "r");

	if (file == NULL) {
		perror(argv[1]);
		return EXIT_FAILURE;
	}

	probe = fgetc(file);

	if (ungetc(probe, file) != probe) {
		printf("ungetc failed\n");
		return EXIT_FAILURE;
	}

	buf_size = file_size(file);

	if (buf_size < 0)
		return EXIT_FAILURE;

	buf = (unsigned char *) malloc(buf_size);

	if (buf == NULL) {
		printf("malloc failed\n");
		return EXIT_FAILURE;
	}

	/* Motorola S-Record; binary data in text format */
	if (probe == 'S') {
		unsigned char linebuf[515];
		unsigned char addrlen;

		pdest = buf;

		while (fgets(linebuf, sizeof(linebuf), file) != NULL) {

			switch ((linebuf[0] << 8) | linebuf[1]) {
			case 0x5331:
				addrlen = 4;
				break;
			case 0x5332:
				addrlen = 6;
				break;
			case 0x5333:
				addrlen = 8;
				break;
			default:
				continue;
			}

			linebuf[4] = 0;
			pdest += char2hex(linebuf + 4 + addrlen, pdest, strtoul(linebuf + 2, NULL, 16) - (addrlen / 2) - 1);
		}

		buf_size = pdest - buf;
	}

	/* binary data */
	else {
		if ((fread(buf, buf_size, 1, file) != 1) || (ferror(file) != 0)) {
			printf("fread failed: %d\n", ferror(file));
			free(buf);
			return EXIT_FAILURE;
		}
	}

	if (fclose(file) < 0) {
		perror("fclose");
		return EXIT_FAILURE;
	}

	/* search for ucodes in buffer */
	for (psrc = buf; psrc < buf + buf_size; psrc++)
		for (i = 0; i < sizeof(types) / sizeof(struct ucode_type_s); i++)
			if (!memcmp(psrc, types[i].magic, strlen(types[i].magic))) {
				for (j = 0; j < sizeof(types[i].ucodes) / sizeof(struct ucode_s); j++)
					if ((types[i].ucodes[j].size != 0) && (!memcmp(psrc + types[i].voffset, types[i].ucodes[j].version, types[i].vlength))) {
						writebuf(types[i].ucodes[j].name, psrc, types[i].ucodes[j].size, types[i].ucodes[j].md5sum);
						psrc += types[i].ucodes[j].size;
						break;
					}
				if (j == sizeof(types[i].ucodes) / sizeof(struct ucode_s))
					printf("unknown %s ucode. please report.\n", types[i].name);
			}

	free(buf);

	return EXIT_SUCCESS;
}

