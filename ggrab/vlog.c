#include <stdio.h>
int
main (int argc, char * argv[]) {
int i,r;
unsigned char * pp;
int pics;
FILE * fp;
static unsigned char a_buf[1000000];
	if (argc != 2) {
		fprintf(stderr,"Syntax: vlog <logfile>\n");
		exit(1);
	}
	fp = fopen (argv[1],"r");

	if (!fp) {
		fprintf(stderr,"Cannot open %s\n",argv[1]);
		exit(1);
	}


		
	while (1) {
		r = fread(a_buf,1,1000000,fp);
		pp=a_buf;
		for (i = 0; i < r-4; i++) {
			if (pp[0] == 0){
				if (pp[1] == 0) {
					if(pp[2] == 1) {
						if (pp[3] < 0x30 && pp[3] != 0) {
							printf("I");
						}
						else {
							printf ("%02X ",pp[3]);
						}
						if(pp[3] == 0) {
							pics ++;
						}
						if(pp[3] == 0xb3) {
							printf ("\n");
							pics = 0;
						}
						if(pp[3] == 0x00) {
							printf ("\n");
						
						}
					}
				}
			}
			pp++;
		}
	}
}
