#include <stdio.h>
#include <stdlib.h>
#include <sys/ioctl.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <time.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/poll.h>
#include <sys/socket.h>
#include <errno.h>
#include <string.h>

#include <ost/dmx.h>
#include <ost/frontend.h>
#include <ost/sec.h>
#include <ost/video.h>

#define BSIZE					 1024*16

int main(int argc, char **argv)
{
	int fd, pid, port;
	int pnr = 0;
	struct dmxPesFilterParams flt; 
	char buffer[BSIZE], *bp;
	int                     sockfd;
        struct sockaddr_in      cli_addr, serv_addr;
	int	addr_len = sizeof (serv_addr);

	
	bp=buffer;
	while (bp-buffer < BSIZE)
	{
		unsigned char c;
		read(1, &c, 1);
		if ((*bp++=c)=='\n')
			break;
	}
	*bp++=0;
	
	bp=buffer;
	if (!strncmp(buffer, "GET /", 5))
	{
		printf("HTTP/1.1 200 OK\r\nServer: d-Box network\r\n\r\n"); // Content-Type: video/mpeg\r\n\r\n");
		bp+=5;
	}
	fflush(stdout);
	sscanf(bp, "%x %d", &pid, &port);

	if(getpeername(0, (struct sockaddr *) &serv_addr, &addr_len)) {
		perror("getpeername");
	}
	

	serv_addr.sin_family      = AF_INET;
        serv_addr.sin_port        = htons(port);

	if ( (sockfd = socket(AF_INET, SOCK_DGRAM, 0)) < 0)
                perror("client: can't open datagram socket");

        /*
         * Bind any local address for us.
         */

        memset((char *) &cli_addr,0, sizeof(cli_addr));    /* zero out */
        cli_addr.sin_family      = AF_INET;
        cli_addr.sin_addr.s_addr = htonl(INADDR_ANY);
        cli_addr.sin_port        = htons(0);
        if (bind(sockfd, (struct sockaddr *) &cli_addr, sizeof(cli_addr)) < 0)
                perror("client: can't bind local address");

	fd=open("/dev/dvb/card0/demux0", O_RDWR);
	if (fd<0)
	{
		perror("/dev/dvb/card0/demux0");
		return -fd;
	}
	ioctl(fd, DMX_SET_BUFFER_SIZE, 1024*1024);
	printf("pid: %x\n", pid);
	flt.pid=pid;
	flt.input=DMX_IN_FRONTEND;
	flt.output=DMX_OUT_TAP;
	flt.pesType=DMX_PES_OTHER;
	flt.flags=0;
	printf("pid %x\n", pid);
	if (ioctl(fd, DMX_SET_PES_FILTER, &flt)<0)
	{
		perror("DMX_SET_PES_FILTER");
		return errno;
	}
	if (ioctl(fd, DMX_START, 0)<0)
	{
		perror("DMX_SET_PES_FILTER");
		return errno;
	}

	while (1)
	{
		int pr=0, r;
		int tr=1440;
		while (tr)
		{
			if ((r=read(fd, buffer+pr, tr))<=0)
				continue;
			pr+=r;
			tr-=r;
		}
        	*((int *)(&(buffer[1440])))=pnr++;	
		sendto(sockfd, buffer, 1444, 0, (struct sockaddr *) &serv_addr, addr_len);

//		if(!(pnr%1000)) {
//			fprintf(stdout,"i\n");
//			fflush(stdout);
//		}
	}
        close(sockfd);
	
	close(fd);
	return 0;
}