/*
 * $Id: ucodex.c,v 1.4 2002/09/03 22:50:07 obi Exp $
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
	unsigned char name[21];
	unsigned char version[17];
	size_t size;
	unsigned char md5sum[MD5_DIGEST_LENGTH];
};

struct ucode_type_s {
	unsigned char name[10];
	unsigned char magic[6];
	unsigned int voffset;
	unsigned char vlength;
	struct ucode_s ucodes[19];
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
			{"avia600vb016", "18Nov99/1355b016", 138906, "\x6f\xd4\x53\x84\xd7\x05\x28\x9a\x2f\xc8\xf2\x12\xb2\x85\x5f\x5c"},
			{"avia600vb017", "28Jan00/1750b017", 126846, "\xda\x49\x21\x46\xba\x7e\x17\x78\x83\xfe\xad\xaa\x0c\xf8\x9a\xa5"},
			{"avia600vb018", "28Apr00/1514b018", 126878, "\xc3\x1d\xc5\x70\xcf\x94\x1a\xfb\x6f\xc4\x81\x3f\x56\x1a\xa3\x78"},
			{"avia600vb022", "28Nov00/1412b022", 128214, "\x6a\x74\x8f\xb2\x80\x00\x73\x8c\xaf\xeb\x9e\x27\x44\x3a\xc6\x23"},
			{"avia600vb028", "26Mar02/1501b028", 128174, "\xf8\x57\x7c\x6a\x70\x56\x59\x0c\xa5\x84\x75\x20\xd8\x13\x39\xfc"},
			{"", "", 0, ""}
		}
	},{
		"dmx", "\xB0\x09\xA8", 663, 1,
		{
			{"ucode_0000", "\x20", 1024, "\x53\xc5\xbc\x40\x81\xdf\xad\xab\x99\x35\xad\x25\x6e\x4d\x62\x39"},
			{"ucode_0013", "\x3F", 2048, "\x66\x62\x7c\x5d\xdf\x26\x9a\x1f\x3a\x9f\x9f\x3c\x22\xfb\xd4\x1b"},
			{"ucode_0014", "\x2F", 2048, "\x65\x82\xa8\x9e\x7e\x13\xe4\x10\xc3\x66\xe4\x7b\x4e\xf9\xd3\x8e"},
			{"ucode_001A", "\x51", 2048, "\xe8\xfb\x83\x44\x66\xd3\x4c\xb7\x5b\xb0\xe6\x4e\xf0\x8b\x55\x44"},
			{"ucode_B107", "\x00", 2048, "\xd4\xc1\x2d\xf0\xd4\xce\x8b\xa9\xeb\x85\x85\x09\xd8\x32\xdf\x65"},
			{"ucode_B121", "\xC4", 2048, "\x4e\x08\x08\x73\x12\x6f\x15\x6a\x0b\x48\x9a\xf1\x76\x52\x06\x20"},
			{"", "", 0, ""}
		}
	}
#if 0
	,{
		"cam-alpha", "\xC8\xA5", 65681, 15,
		{
			{"cam_01_01_001D",      "V 01.01.001D   ", 131072, "\xff\x6f\xaf\xbd\x2a\xa1\xf2\x9a\xfe\x23\x2a\x72\xfa\xc5\x78\x70"},
			{"cam_01_01_001E",      "V 01.01.001E   ", 131072, "\x7b\x9b\x72\x78\x66\x23\xe3\x75\x03\x35\xc7\x9a\xf0\x44\xe7\x18"},
			{"cam_01_01_002E",      "V 01.01.002E   ", 131072, "\xbe\x7f\x1b\xeb\x1b\xb4\x37\xb7\xf7\xc9\x9f\x8e\x5a\x96\x88\x82"},
			{"cam_01_01_003E",      "V 01.01.003E   ", 131072, "\xa8\x68\x9d\x88\xe0\xd2\xdf\x12\xa1\x57\x32\xc9\x8f\x86\x5b\x11"},
			{"cam_01_01_004D",      "V 01.01.004D   ", 131072, "\xc4\x2d\x67\x53\x79\x4d\xd9\x51\x46\xea\xc3\x1f\x2a\x65\xb5\x16"},
			{"cam_01_01_004E",      "V 01.01.004E   ", 131072, "\x43\x36\xe7\xd3\xfe\xd4\x3c\x9e\x06\x32\x10\xbc\xdc\x95\xd2\x3e"},
			{"cam_01_01_004F",      "V 01.01.004F   ", 131072, "\xc7\x34\x20\x7d\xde\xa7\xb8\xce\xaf\xa2\x50\x5f\x13\x60\xf3\xbf"},
			{"cam_01_01_005D",      "V 01.01.005D   ", 131072, "\xbe\x4b\x0f\x38\x55\x7c\x41\x6c\xe0\x4e\x7f\xa3\xfa\x63\x4f\x95"},
			{"cam_01_01_005E",      "V 01.01.005E   ", 131072, "\x99\x7b\x1f\x85\x8f\x1e\xfe\xe5\x25\xe6\x84\x25\x58\xed\xbe\x3c"},
			{"cam_01_01_005F",      "V 01.01.005F   ", 131072, "\xa5\x98\x48\x25\xff\x55\x4e\xa5\x30\xef\xc4\x73\x3f\xfd\x74\x73"},
			{"cam_01_02_002D",      "V 01.02.002D   ", 131072, "\x19\x05\x39\x06\x36\xe7\x0c\x96\x65\x74\xa3\x29\x8a\x1b\x89\xc3"},
			{"cam_01_02_002E",      "V 01.02.002E   ", 131072, "\x7f\x56\xe6\x93\xa9\x16\xb3\x9a\x6e\x27\x34\xdc\x9b\x5a\xab\x7a"},
			{"cam_01_02_002F",      "V 01.02.002F   ", 131072, "\x70\x4c\xb8\xd9\x96\x5b\xab\xbd\xc7\xd4\xe7\xca\xe6\xe5\x58\x4e"},
			{"cam_01_02_105D",      "V 01.02.105D   ", 131072, "\xf2\x7e\xda\x69\x8c\x20\x2d\x17\xaf\x7b\x9b\xab\x83\x97\x3e\x8c"},
			{"cam_01_02_105E",      "V 01.02.105E   ", 131072, "\xba\xc1\x97\x0b\x0e\x86\x5c\x00\x01\x5b\x3d\x78\xa2\x09\xb5\xbf"},
			{"cam_01_02_105F",      "V 01.02.105F   ", 131072, "\xc5\x10\x74\xb2\xed\xf6\xc1\x4e\x0b\xb9\x9e\xe3\xed\x8b\x9c\x47"},
			{"cam_NOKIA_PRODTEST2", "NOKIA PRODTEST2", 131072, "\x16\xc5\xe1\xeb\xa0\xcf\xe6\x3f\x2b\xbc\x64\x8e\x16\x44\xc8\x83"},
			{"cam_STREAMHACK",      "STREAMHACK     ", 131072, "\x42\x0b\xaf\x44\x7b\xfd\x52\x9a\x79\x4b\xb3\x6e\xf8\x0f\x16\x52"},
			{"", "", 0, ""}
		}
	}
#endif
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
		free(buf);
		return EXIT_FAILURE;
	}

	/* search for ucodes in buffer */
	for (psrc = buf; psrc < buf + buf_size; psrc++)
		for (i = 0; i < sizeof(types) / sizeof(struct ucode_type_s); i++)
			if ((psrc - buf + strlen(types[i].magic) <= buf_size) &&
				(!memcmp(psrc, types[i].magic, strlen(types[i].magic)))) {
				for (j = 0; types[i].ucodes[j].size != 0; j++)
					if ((0) || ((psrc + types[i].voffset - buf + types[i].vlength <= buf_size) &&
						(!memcmp(psrc + types[i].voffset, types[i].ucodes[j].version, types[i].vlength)))) {
						writebuf(types[i].ucodes[j].name, psrc, types[i].ucodes[j].size, types[i].ucodes[j].md5sum);
						psrc += types[i].ucodes[j].size - 1;
						break;
					}
				if (types[i].ucodes[j].size == 0)
					printf("unknown %s ucode. please report.\n", types[i].name);
			}

	free(buf);
	return EXIT_SUCCESS;
}

