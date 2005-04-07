#include <stdio.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>

#include "picv_client_server.h"
#define MIN(a,b) ((a)>(b)?(b):(a))
#define BUFFERLEN 8000



void diep(char *s)
{
	perror(s);
	exit(1);
}


int main(int argn, char** argv)
{
	FILE* input_file;
	struct sockaddr_in si_other, si_me;
	int s, i, slen=sizeof(si_other);
	int bytes,rest,len;
	uint32_t lenbytes,lenbytes_n;
	unsigned char* data;
	char path[PICV_CLIENT_SERVER_PATHLEN];
	unsigned char* buffer[BUFFERLEN];
	struct pic_data pd;

	if (argnr !=4 )
		fprintf(stderr,"usage: test_client <server> <port> <picture>");

	strncpy(path, argv[3], PICV_CLIENT_SERVER_PATHLEN-1);
	path[PICV_CLIENT_SERVER_PATHLEN]=0;
	
	if ((s=socket(AF_INET, SOCK_STREAM, IPPROTO_TCP))==-1)
		diep("socket");

	memset((char *) &si_other, sizeof(si_other), 0);
	si_other.sin_family = AF_INET;
	si_other.sin_port = htons(atoi(argv[2]));
	if (inet_aton(argv[1], &si_other.sin_addr)==0) {
		fprintf(stderr, "inet_aton() failed\n");
		exit(1);
	}
	memset((char *) &si_me, sizeof(si_me), 0);
	si_me.sin_family = AF_INET;
	si_me.sin_port = htons(0);

	/* connect to picserver */
	if (connect(s, (struct sockaddr *) &si_other, slen)==-1)
		 diep("connect()");

	/* 1. Send full path of picture */
	if (send(s, path, PICV_CLIENT_SERVER_PATHLEN, 0)==-1)
		diep("send()");

	/* 2. Send desired image size */
	pd.width=htonl(720);
	pd.height=htonl(576);
	if (send(s, &pd, sizeof(pd), 0)==-1)
		diep("send()");

	/* 3. receive final picture size and depth */
	if (recv(s, &pd, sizeof(pd), 0) < sizeof(pd))
			diep("recv pic desc");
	len=ntohl(pd.bpp) / 8 * ntohl(pd.width) * ntohl(pd.height);
	unsigned char* pic = (unsigned char*) malloc(len);
	unsigned char* workptr=pic;
	rest = len;
	fprintf(stderr, "Result pic: %d/%d/%d\n",ntohl(pd.width),ntohl(pd.height),ntohl(pd.bpp));
	/* Receive pic */
	while (rest > 0)
	{
		bytes=recv(s, workptr, MIN(BUFFERLEN,rest), 0);
		if (bytes==0)
			return 0;
		workptr+=bytes;
		rest-=bytes;
	}
	/* Pic is now in memory(pic) */
	printf("Done\n");
	//fwrite(pic, len, 1, stdout);
	close(s);
	return 0;
}


