#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <netinet/in.h>

#include "ani.h"
#include "bmp.h"

int main(int argc, char **argv) {
	FILE *fbmp, *fani;

	struct bmp_header bh;
	//struct bmp_color *colors;
	long int line_size, bmpline_size, image_size;
	unsigned char *image;

	struct ani_header ah;
	lcd_raw_buffer raw;
	lcd_packed_buffer packed;
	int i;
	//int y, x, ofs, bit1, bit2;

	if (argc < 4) {
		fprintf(stderr, "bmp2ani (C) 2001 by Ge0rG\n");
		fprintf(stderr, "	%s delay out.ani in0.bmp [in1.bmp ...]\n",
		    argv[0]);
		exit(1);
	}
	printf("bmp2ani (C) 2001 by Ge0rG\n\n");

	memcpy(ah.magic, "LCDA", 4);
	ah.format = htons(0);
	ah.width = htons(120);
	ah.height = htons(64);
	ah.count = htons(argc-3);
	ah.delay = htonl(atol(argv[1]));

	printf("[%s] Creating ani (120x64, %i pics, %i µs delay):\n", argv[2],
	    ntohs(ah.count), ntohl(ah.delay));

	fani = fopen(argv[2], "w");
	fwrite(&ah, 1, sizeof(ah), fani);

	for (i = 3; i<argc; i++) {
		printf("[%s] Adding %s...\n", argv[2], argv[i]);

		if ((fbmp = fopen(argv[i], "r"))==NULL) {
			perror("fopen(BMP_FILE)");
			exit(2);
		}
		if (fread(&bh, 1, sizeof(bh), fbmp)!=sizeof(bh)) {
			perror("fread(BMP_HEADER)");
			exit(3);
		}
		if ((bh._B!='B')||(bh._M!='M')) {
			fprintf(stderr, "Bad Magic (not a BMP file).\n");
			exit(4);
		}

		// 4 * 2^bit_count
		fseek(fbmp, 4<<bh.bit_count, SEEK_CUR);

		// image
		line_size = (bh.width*bh.bit_count / 8);
		bmpline_size = (line_size + 3) & ~3;
		image_size = bmpline_size*bh.height;

		image = malloc(image_size);
		if (fread(image, 1, image_size, fbmp)!=image_size) {
			perror("fread(BMP_IMAGE)");
			exit(6);
		}
		fclose(fbmp);
		
		if ((bh.width != 120) || (bh.height != 64)) {
			printf("BMP not 120x64 - aborting\n");
			exit(7);
		}
		if (bh.compression != 0)
			printf("WARNING: Image is compressed - result unpredictable.\n");

		bmp2raw(bh, image, raw);
		free(image);

		raw2packed(raw, packed);

		fwrite(&packed, 1, sizeof(packed), fani);
	}

	fclose(fani);
	printf("[%s] ready.\n", argv[2]);
	return 0;
}
