#include <stdio.h>
#include <stdlib.h>
#include "tools.h"

double pes_pts(const unsigned char * p) {
	if (0 == (p[7] & 0x80)) {
		return -1.0; // no PTS available
	}
	
	unsigned  res = 0;
	double ret=0;
	if (p[9] & 0x08) {
		ret += 0x100000000ULL; // for the 32. bit
	}
	
	res |= (p[9]  & 0x06) << 29;
	res |= p[10]          << 22;
	res |= (p[11] & 0xfe) << 14;
	res |= p[12]          << 7;
	res |= (p[13] & 0xfe) >> 1;
	
	ret += res;	
	return res;
}


int pes_len(const unsigned char * p) {
	return (((p[4]<< 8) & (0xff00)) + p[5]);
}


unsigned clock_ref(const unsigned char *p) {

	unsigned a;

	a = 0;
	a +=  (p[8] >> 3) & 0x1f;
	a +=   p[7] << 5;
	a +=  (p[6] & 0x03) << 13;
	a += ((p[6] >> 3) & 0x1f) << 15;
	a +=   p[5] << 20;
	a +=  (p[4] & 3) << 28;
	a += ((p[4] >> 3) & 0x03) << 30;

	return (a);
}

void
fill_pes_pts(unsigned char * p_pes, double pts) {

	unsigned long long a;
	
	if (pts > 0x1ffffffffULL) {
		pts -= 0x200000000ULL + 1;
	}

	if (pts < 0) {
	 	pts = 0;
        }

	a = (unsigned long long) pts;

	p_pes[7] |= 0x80;
	p_pes[8]  = 5;
	p_pes[9]  = 0x20 | ((a & 0x1c0000000ULL) >> 29) | 0x01;
	p_pes[10] =        ((a & 0x03fc00000ULL) >> 22);
	p_pes[11] =        ((a & 0x0003f8000ULL) >> 14) | 0x01;
	p_pes[12] =        ((a & 0x000007f80ULL) >>  7);
	p_pes[13] =        ((a & 0x1c000007fULL) >>  1) | 0x01;
}
	
void
fill_pes_len(unsigned char * p_pes, int len) {
	
	if (len > 0xffff) {
		errexit ("fill_pes_len: len > 0xffff");
	}

	p_pes[4] = (len >> 8) & 0xff;
	p_pes[5] = len & 0xff;
}

void 
fill_pp_scr (unsigned char * p_pp, double scr) {

	unsigned long long a;
	
	if (scr > 0x1ffffffffULL) {
		scr -= 0x200000000ULL;
	}

	if (scr < 0) {
		scr = 0;
	}

	a = (unsigned long long) scr;

	p_pp[4] = 0x40 | ((a & 0x1c0000000ULL) >> 27) | 0x04 | ((a & 0x030000000ULL) >> 28);
	p_pp[5] =        ((a & 0x00ff00000ULL) >> 20);
	p_pp[6] =        ((a & 0x0000f8000ULL) >> 12) | 0x04 | ((a & 0x000006000ULL) >> 13);
	p_pp[7] =        ((a & 0x000001fe0ULL) >>  5);
	p_pp[8] =        ((a & 0x00000001fULL) <<  3) | 0x04;
	p_pp[9] = 0x01;       
}

void errexit (char * str) {
	fprintf (stderr,"%s\n",str);
	exit (1);
}
