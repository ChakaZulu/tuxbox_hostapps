/*
        Unix picserver for use with dbox2 neutrino GUI

        Copyright (C) 2005 Zwen@tuxbox.org

        License: GPL

        This program is free software; you can redistribute it and/or modify
        it under the terms of the GNU General Public License as published by
        the Free Software Foundation; either version 2 of the License, or
        (at your option) any later version.

        This program is distributed in the hope that it will be useful,
        but WITHOUT ANY WARRANTY; without even the implied warranty of
        MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
        GNU General Public License for more details.

        You should have received a copy of the GNU General Public License
        along with this program; if not, write to the Free Software
        Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
*/

#include <stdio.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <sys/time.h>
#include <pthread.h>
#include <jpeglib.h>
#include <setjmp.h>
/* the interface definition file (a copy from neutrino/driver/pictureviewer/picv_client_server.h) */
#include "picv_client_server.h"

#define BUFFERLEN 8192
#define MIN(a,b) ((a)>(b)?(b):(a))

/* log printf */
#define lprintf(fmt, args...) {if(debug){print_timestamp(); fprintf(stderr, fmt, ## args);}}
/* error printf */
#define eprintf(fmt, args...) {print_timestamp(); fprintf(stderr, fmt, ## args);}


int debug;
int replace;
char replace_from[PICV_CLIENT_SERVER_PATHLEN];
char replace_to[PICV_CLIENT_SERVER_PATHLEN];
int do_simple_resize;

void print_timestamp()
{
	struct timeval tv;
	struct timezone tz;
	gettimeofday(&tv, &tz);
	struct tm *t=localtime(&tv.tv_sec);
	fprintf(stderr, "%04d%02d%02d %02d:%02d:%02d.%02d ", t->tm_year+1900, t->tm_mon+1, t->tm_mday,
			  t->tm_hour, t->tm_min, t->tm_sec, tv.tv_usec /10000);
}
void diep(char *s)
{
	print_timestamp();
	perror(s);
	exit(1);
}
void t_perror(char *s)
{
	print_timestamp();
	perror(s);
}

/* libjpeg stuff ... */
struct r_jpeg_error_mgr
{
	struct jpeg_error_mgr pub;
	jmp_buf envbuffer;
};
void jpeg_cb_error_exit(j_common_ptr cinfo)
{
	struct r_jpeg_error_mgr *mptr;
	mptr=(struct r_jpeg_error_mgr*) cinfo->err;
	(*cinfo->err->output_message) (cinfo);
	longjmp(mptr->envbuffer,1);
}

unsigned char* jpeg_decode(char* filename, int* width, int* height, int wanted_width, int wanted_height)
{
	struct jpeg_decompress_struct cinfo;
	struct jpeg_decompress_struct *ciptr;
	struct r_jpeg_error_mgr emgr;
	unsigned char *bp, *buffer;
	int px,py,c;
	FILE *fh;
	JSAMPLE *lb;
	unsigned char id[10];

	fh=fopen(filename, "r");
	if(fh==NULL)
	{
		eprintf("Error opening file: %s\n", filename);
		return NULL;
	}
	fread(id,10,1,fh);
	fseek(fh, 0, SEEK_SET);
	*width=0;
	*height=0;
	if(!(id[6]=='J' && id[7]=='F' && id[8]=='I' && id[9]=='F') &&
		!(id[0]==0xff && id[1]==0xd8 && id[2]==0xff))
	{
		eprintf("Error %s is no JPEG!\n", filename);
		return NULL;
	}
	ciptr=&cinfo;
	ciptr->err=jpeg_std_error(&emgr.pub);
	emgr.pub.error_exit=jpeg_cb_error_exit;
	if(setjmp(emgr.envbuffer)==1)
	{
		// FATAL ERROR - Free the object and return...
		jpeg_destroy_decompress(ciptr);
		fclose(fh);
		eprintf("Error jpeg internal\n");
		return NULL;
	}

	jpeg_create_decompress(ciptr);
	jpeg_stdio_src(ciptr,fh);
	jpeg_read_header(ciptr,TRUE);

/*	ciptr->dct_method=JDCT_IFAST;
	ciptr->out_color_space=JCS_RGB;
	ciptr->do_fancy_upsampling=FALSE;
	ciptr->do_block_smoothing=FALSE;*/

	if((int)ciptr->image_width/8 >= wanted_width ||
		(int)ciptr->image_height/8 >= wanted_height)
		ciptr->scale_denom=8;
	else if((int)ciptr->image_width/4 >= wanted_width ||
			  (int)ciptr->image_height/4 >= wanted_height)
		ciptr->scale_denom=4;
	else if((int)ciptr->image_width/2 >= wanted_width ||
			  (int)ciptr->image_height/2 >= wanted_height)
		ciptr->scale_denom=2;
	else
		ciptr->scale_denom=1;

	ciptr->scale_num=1;
//	ciptr->scale_denom=3;
	
	jpeg_start_decompress(ciptr);

	px=ciptr->output_width; py=ciptr->output_height;
	c=ciptr->output_components;
	if(c==3)
	{
		lb=(JSAMPLE*)(*ciptr->mem->alloc_small)((j_common_ptr) ciptr,JPOOL_PERMANENT,c*px);
		buffer = (unsigned char*) malloc(px*py*3);
		bp=buffer;
		while(ciptr->output_scanline < ciptr->output_height)
		{
			jpeg_read_scanlines(ciptr, &lb, 1);
			memcpy(bp,lb,px*c);
			bp+=px*c;
		}

	}
	else
		buffer=NULL;
	jpeg_finish_decompress(ciptr);
	jpeg_destroy_decompress(ciptr);
	*width=px;
	*height=py;
	fclose(fh);
	return buffer;
}

/* resize funtions */
unsigned char * color_average_resize(unsigned char * orgin,int ox,int oy,int dx,int dy)
{
	lprintf("color_average_resize {\n");
	unsigned char *cr,*p,*q;
	int i,j,k,l,ya,yb;
	int sq,r,g,b;
	float f1,f2;
	cr=(unsigned char*) malloc(dx*dy*3);
	if(cr==NULL)
	{
		eprintf("resize error: malloc\n");
		return orgin;
	}
	p=cr;
	f1=ox/dx;
	f2=oy/dy;
	
	int xa_v[dx];
	for(i=0;i<dx;i++)
		xa_v[i] = (int)(i*ox/dx);
	int xb_v[dx+1];
	for(i=0;i<dx;i++)
	{
		xb_v[i]=(int)((i+1)*ox/dx);
		if(xb_v[i]>=ox)
			xb_v[i]=ox-1;
	}
	for(j=0;j<dy;j++)
	{
		ya=(int)(j*oy/dy);
		yb=(int)((j+1)*oy/dy); if(yb>=oy)                yb=oy-1;
		for(i=0;i<dx;i++,p+=3)
		{
			for(l=ya,r=0,g=0,b=0,sq=0;l<=yb;l++)
			{
				q=orgin+((l*ox+xa_v[i])*3);
				for(k=xa_v[i];k<=xb_v[i];k++,q+=3,sq++)
				{
					r+=q[0]; g+=q[1]; b+=q[2];
				}
			}
			p[0]=r/sq; p[1]=g/sq; p[2]=b/sq;
		}
	}
	free(orgin);
	lprintf("color_average_resize }\n");
	return(cr);
}
unsigned char * simple_resize(unsigned char * orgin,int ox,int oy,int dx,int dy)
{
	lprintf("simple_resize {\n");
	unsigned char *cr,*p,*l;
	int i,j,k,ip;
	cr=(unsigned char*) malloc(dx*dy*3); 
	if(cr==NULL)
	{
		eprintf("Error: malloc\n");
		return(orgin);
	}
	l=cr;

	for(j=0;j<dy;j++,l+=dx*3)
	{
 		p=orgin+(j*oy/dy*ox*3);
		for(i=0,k=0;i<dx;i++,k+=3)
		{
			ip=i*ox/dx*3;
			memcpy(l+k, p+ip, 3);
		}
	}
	free(orgin);
	lprintf("simple_resize }\n");
	return(cr);
}

/* convert RGB888 to RGB555 */
unsigned char * to555(unsigned char * orgin,int size)
{
	int i;
	unsigned char* np = (unsigned char*)malloc(size*2);
	for(i=0 ; i < size ; i++)
	{
		np[i*2]   = ((orgin[3*i]   >> 1) & 0x7C) | (orgin[3*i+1] >> 6);
		np[i*2+1] = ((orgin[3*i+1] << 2) & 0xE0) | (orgin[3*i+2] >> 3);
	}
	free(orgin);
	return np;
}
void c32_15(unsigned char r, unsigned char g , unsigned char b , unsigned char* d)
{
		*d     = ((r >> 1) & 0x7C) | (g >> 6);
		*(d+1) = ((g << 2) & 0xE0) | (b >> 3);
}

/*
	This is an implementation of the floyd steinberg error diffusion algorithm
	adapted for 24bit to 15bit color reduction.

	For a description of the base alorithm see e.g.: 
	http://www.informatik.fh-muenchen.de/~schieder/graphik-01-02/slide0264.html
	*/

#define FS_CALC_ERROR_COMMON(color, index) \
				p1 = p2 = (ptr[index] + (this_line_error_##color[ix]>>4)); \
				if(p1>255)p1=255; if(p1<0)p1=0; \
				color = (p1 & 0xF8) | 0x4; \
				error = p2 - color; \

#define FS_CALC_ERROR_RIGHT(color, index) \
				FS_CALC_ERROR_COMMON(color,index) \
				this_line_error_##color[ix+1] += (error * 7); \
				next_line_error_##color[ix-1] += (error * 3); \
				next_line_error_##color[ix]   += (error * 5); \
				next_line_error_##color[ix+1] += error;
				
#define FS_CALC_ERROR_LEFT(color, index) \
				FS_CALC_ERROR_COMMON(color,index) \
				this_line_error_##color[ix-1] += (error * 7); \
				next_line_error_##color[ix+1] += (error * 3); \
				next_line_error_##color[ix]   += (error * 5); \
				next_line_error_##color[ix-1] += error;
				
unsigned char * to555_floyd_steinberg_err_diff(unsigned char * orgin,int x, int y)
{
	int odd_line=1;
	int ix,iy, error, p1, p2;
	unsigned char r,g,b;
	unsigned char *ptr, *dst;
	unsigned char* np = (unsigned char*)malloc(x*y*2);
	int *this_line_error_r;
	int *this_line_error_g;
	int *this_line_error_b;
	int *next_line_error_r;
	int *next_line_error_g;
	int *next_line_error_b;
	int *save_error_r;
	int *save_error_g;
	int *save_error_b;
	int *error1_r = (int*)malloc((x+2)*sizeof(int));
	int *error1_g = (int*)malloc((x+2)*sizeof(int));
	int *error1_b = (int*)malloc((x+2)*sizeof(int));
	int *error2_r = (int*)malloc((x+2)*sizeof(int));
	int *error2_g = (int*)malloc((x+2)*sizeof(int));
	int *error2_b = (int*)malloc((x+2)*sizeof(int));
	
	lprintf("Start error diffusion\n");
	
	this_line_error_r = error1_r;
	this_line_error_g = error1_g;
	this_line_error_b = error1_b;
	next_line_error_r = error2_r;
	next_line_error_g = error2_g;
	next_line_error_b = error2_b;
	memset (this_line_error_r, 0 , (x+2) * sizeof(int));
	memset (this_line_error_g, 0 , (x+2) * sizeof(int));
	memset (this_line_error_b, 0 , (x+2) * sizeof(int));
	memset (next_line_error_r, 0 , (x+2) * sizeof(int));
	memset (next_line_error_g, 0 , (x+2) * sizeof(int));
	memset (next_line_error_b, 0 , (x+2) * sizeof(int));
	ptr = orgin;
	dst = np;

	for(iy=0 ; iy < y ; iy++)
	{
		save_error_r = this_line_error_r;
		this_line_error_r = next_line_error_r;
		next_line_error_r = save_error_r;
		save_error_g = this_line_error_g;
		this_line_error_g = next_line_error_g;
		next_line_error_g = save_error_g;
		save_error_b = this_line_error_b;
		this_line_error_b = next_line_error_b;
		next_line_error_b = save_error_b;
		memset (next_line_error_r, 0 , (x+2) * sizeof(int));
		memset (next_line_error_g, 0 , (x+2) * sizeof(int));
		memset (next_line_error_b, 0 , (x+2) * sizeof(int));
		
		if(odd_line)
		{
			for(ix=1 ; ix <= x ; ix++)
			{
				FS_CALC_ERROR_RIGHT(r,0);
				FS_CALC_ERROR_RIGHT(g,1);
				FS_CALC_ERROR_RIGHT(b,2);
				c32_15(r,g,b,dst);
				ptr+=3;
				dst+=2;
			}
			odd_line=0;
		}
		else
		{
			ptr+=(x-1)*3;
			dst+=(x-1)*2;
			for(ix=x ; ix >= 1 ; ix--)
			{
				FS_CALC_ERROR_LEFT(r,0);
				FS_CALC_ERROR_LEFT(g,1);
				FS_CALC_ERROR_LEFT(b,2);
				c32_15(r,g,b,dst);
				ptr-=3;
				dst-=2;
			}
			ptr+=x*3;
			dst+=x*2;
			odd_line=1;
		}
	}
	free(orgin);
	free(error1_r);
	free(error1_g);
	free(error1_b);
	free(error2_r);
	free(error2_g);
	free(error2_b);
	lprintf("End error diffusion\n");
	return np;
}
/* do string mapping */
void convert(char* str)
{
	if(strncmp(str, replace_from, strlen(replace_from))==0)
	{
		char s[PICV_CLIENT_SERVER_PATHLEN];
		strcpy(s, replace_to);
		strncpy(s + strlen(replace_to), str + strlen(replace_from), PICV_CLIENT_SERVER_PATHLEN - strlen(replace_to));
		s[PICV_CLIENT_SERVER_PATHLEN]=0;
		strcpy(str, s);
	}
}

/* the server thread (spawned for every connection) */
void* ServerThread(void* socket)
{
	int  bytes, rest, width, height, w_width, w_height, nx, ny;
	unsigned char *workptr, *img;
	char filename[PICV_CLIENT_SERVER_PATHLEN];
	struct pic_data pd;
	
	int s2 = *((int*) socket);

	/* 1. Get filename of image to be decoded from client */	
	if(recv(s2, &filename, PICV_CLIENT_SERVER_PATHLEN, 0)==-1)
	{
		t_perror("recv filename");
		close(s2);
		pthread_exit(NULL);
	}
	lprintf("Pic: %s\n", filename);
	/* map filename to local filename */
	convert(filename);
	lprintf("Pic (trans): %s\n", filename);

	/* 2. Get desired destination geometry of pic (width/height) */
	if(recv(s2, &pd, sizeof(pd), 0)==-1)
	{
		t_perror("recv pdata");
		close(s2);
		pthread_exit(NULL);
	}
	w_width=ntohl(pd.width);
	w_height=ntohl(pd.height);
	lprintf("Wanted size: width %d height: %d\n", w_width, w_height);

	/* decode image via libjpeg */
	lprintf("Start decoding %s\n", filename);
	img=jpeg_decode(filename, &width, &height, w_width, w_height);
	if (img==NULL)
	{
		close(s2);
		pthread_exit(NULL);
	}
	lprintf("End decoding %s\n", filename);

	lprintf("Image width: %d , height: %d\n", width, height);
	nx=w_width;
	ny=w_height;

	/* resize image to desired geometry */
	lprintf("Start resizing\n");
	if(width!=nx && height!=ny)
		if(do_simple_resize)
			img=simple_resize(img, width, height, nx, ny);
		else
			img=color_average_resize(img, width, height, nx, ny);
	lprintf("End resizing\n");

	/* convert RGB888 (24 bit) to RGB555 (16bit) */
	lprintf("Start downsampling\n");
//	img=to555(img, nx * ny);
	img=to555_floyd_steinberg_err_diff(img, nx, ny);
	lprintf("End downsampling\n");
	lprintf("pic size\n",time(NULL), nx*ny*2);

	/* 3. Send back final picture geometry */
	pd.bpp=htonl(16);
	pd.width=htonl(nx);
	pd.height=htonl(ny);
	bytes=send(s2, &pd, sizeof(pd), 0);
	if((unsigned int) bytes< sizeof(pd))
	{
		t_perror("writing back pic desc");
		close(s2);
		pthread_exit(NULL);
	}

	/* 4. send back picture data */
	lprintf("Sending back final pic\n");
	rest=nx*ny*2;
	workptr=img;
	while (rest>0)
	{
		bytes=send(s2, workptr, MIN(rest,BUFFERLEN), 0);
		if(bytes==-1)
		{
			t_perror("writing back");
			break;
		}
		else
		{
			workptr+=bytes;
			rest-=bytes;
		}
	}
	free(img);

	lprintf("pic sent back\n");
	close(s2);
	return NULL;
}
char* mybasename(char* src)
{
	char* p;
	p = strrchr (src, '/');
	if (p == NULL)
		return src;
	else
		return p + 1;
}

void usage(char* name)
{
	fprintf(stderr, "\nUsage: %s [-d] [-r \"<replace>,<to>\"] <port>\n\n", name);
	fprintf(stderr, "-d : enable debug log (stderr)\n");
	fprintf(stderr, "-r : replace token <replace> with <to> at beginning of path of requested picture\n");
	fprintf(stderr, "-s : use simple resize algorithm (instead of more complex one)\n\n");
	fprintf(stderr, "e.g.: %s -d -r \"/mnt,/data\" 12345\n\n", name);

}
int main(int argnr, char** argv)
{
	struct sockaddr_in si_me, si_other;
	socklen_t slen=sizeof(si_other);
	int s1,s2;
	
	debug=0;
	replace=0;
	do_simple_resize=0;

	/* cmd line parsing */
	while (1) 
	{
	
		int c;  
		if ((c = getopt(argnr, argv, "dr:s")) < 0)
			break;
		switch (c) {
			case 'd': debug=1;
				break;
			case 'r': 
			{
				replace=1;
				char* delim=strchr(optarg, ',');
				int len=(delim-optarg);
				strncpy(replace_from, optarg, MIN(PICV_CLIENT_SERVER_PATHLEN,len));
				replace_from[MIN(PICV_CLIENT_SERVER_PATHLEN,len)]=0;
				strncpy(replace_to, delim+1, PICV_CLIENT_SERVER_PATHLEN);
				replace_to[PICV_CLIENT_SERVER_PATHLEN]=0;
				lprintf("Replace [%s] with [%s]\n", replace_from, replace_to);
			}
			break;
			case 's': do_simple_resize=1;
		}
	}

	if(optind > argnr-1)
	{
		usage((char*)mybasename(argv[0]));
		exit(1);
	}
	int port = atoi(argv[optind]);
	if(port <= 0)
	{
		usage((char*)mybasename(argv[0]));
		exit(1);
	}

	/* network stuff , create socket bind to local port ... */
	if((s1=socket(AF_INET, SOCK_STREAM, IPPROTO_TCP))==-1)
		diep("socket");

	memset((char *) &si_me, sizeof(si_me), 0);
	si_me.sin_family = AF_INET;
	si_me.sin_port = htons(port);
	si_me.sin_addr.s_addr = htonl(INADDR_ANY);
	if(bind(s1, (struct sockaddr *) &si_me, sizeof(si_me))==-1)
		diep("bind");
	if (listen(s1,3)==-1)
		diep("listen");

	/* server loop */
	while(1)
	{
		if ((s2=accept(s1, (struct sockaddr *) &si_other, &slen))==-1)
		{
			t_perror("accept");
			continue;
		}
		lprintf("Connect from %s:%d\n", 
				  inet_ntoa(si_other.sin_addr), ntohs(si_other.sin_port));
		pthread_t	thread;
		if (pthread_create(&thread, NULL, ServerThread, (void*) &s2)!=0)
		{
			t_perror("pthread_create\n");
		}
	}
	return 0;
}
