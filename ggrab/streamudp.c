/*
* Calling:
 * GET /<pid>  \r\n -> for tcp opration
 * GET /<pid>,<udpport> \r\n -> for udp operation, tcp connection ist maintained as control connection
 * to end udp streaming
*/
#include <stdio.h>
#include <stdlib.h>
#include <sys/ioctl.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <sys/signal.h>
#include <sys/wait.h>
#include <errno.h>
#include <string.h>

#include <ost/dmx.h>
#include <ost/frontend.h>
#include <ost/sec.h>
#include <ost/video.h>


//#define DEBUG
#define UDP_SEND_LEN	(1470+1478)
#define BSIZE		(1024*16)
#define DMX_BUFFER_SIZE (1024*1024)

#ifdef DEBUG
static FILE * fp_err;
#endif

void send_udp(int fd, int port);

int main(int argc, char **argv)
{
	int fd,port,ppid,flags;
	unsigned short pid;
	struct 			dmxPesFilterParams flt; 
	char buffer[BSIZE], *bp;
	unsigned char c;
	
	bp = buffer;
	while ((bp-buffer) < BSIZE) {

		read(STDIN_FILENO, &c, 1);

		if ((*bp++=c)=='\n')
			break;
	}

	*bp++ = 0;

	bp = buffer;
	if (!strncmp(buffer, "GET /", 5))
	{
		printf("HTTP/1.1 200 OK\r\nServer: d-Box network\r\n\r\n");
		bp += 5;
	}
	sscanf(bp, "%hx", &pid);
	
	port = 0;
	if ((bp=strchr(bp,',')) != 0) {
		bp++;
		sscanf(bp, "%d", &port);
	}

#ifdef DEBUG
	char a_buffer[20];
	sprintf(a_buffer,"/tmp/streampes%d.log",pid);
	fp_err = fopen(a_buffer,"w");
#endif
	
	fflush(stdout);
	
	fd=open("/dev/dvb/card0/demux0", O_RDWR);

	if (fd < 0) {
#ifdef DEBUG
		perror("/dev/dvb/card0/demux0");
#endif
		return -fd;
	}
	
	ioctl(fd, DMX_SET_BUFFER_SIZE, DMX_BUFFER_SIZE);

	flt.pid=pid;
	flt.input=DMX_IN_FRONTEND;
	flt.output=DMX_OUT_TAP;
	flt.pesType=DMX_PES_OTHER;
	flt.flags=0;
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
/*Geht noch nicht wg. Bug im Demux Device	
	flags = fcntl(fd,F_GETFL,0);
	if (flags == -1) {
		return (errno);
	}
	fcntl(fd,F_SETFL, flags | O_NONBLOCK);
*/	
	if (port > 1023) {
		ppid = fork();
		if (ppid == 0) {
			send_udp (fd, port);
		} 
		else if (ppid > 0) {
			while (read(STDIN_FILENO,buffer,1) >= 0);
		 	kill (ppid,SIGINT);
		 	exit(waitpid(ppid,0,0));
		}
		else {
#ifdef DEBUG
			fprintf(fp_err,"error cannot fork\n");
#endif
			return(-1);
		}
	}
	else {
		setpriority(PRIO_PROCESS,0,-10);
		while (1) {
			int pr = 0, r;
			int tr = BSIZE;
			while (tr) {
				if ((r=read(fd, buffer+pr, tr)) <= 0) {
					if (errno == EAGAIN) {
						sleep (10000);
						continue;
					}
#ifdef DEBUG
					fprintf(fp_err,"error read demux %d\n", errno);
#endif
					sleep (10000);
					continue;
				}
				pr+=r;
				tr-=r;
			}

			if (write(STDOUT_FILENO, buffer, r) != r) {
#ifdef DEBUG
				fprintf(fp_err,"error write stdout %d\n",errno);
#endif
				break;
			}
		}
	}

	close(fd);
	return 0;
}

void
send_udp (int fd, int port) {
	int			pnr = 0;
	int                     sockfd;
        struct sockaddr_in      cli_addr, serv_addr;
	int			addr_len = sizeof (serv_addr);
	static	char 		buffer[UDP_SEND_LEN];

	setpriority(PRIO_PROCESS,0,-10);
	
	if(getpeername(STDOUT_FILENO, (struct sockaddr *) &serv_addr, &addr_len)) {
#ifdef DEBUG
		fprintf(fp_err,"error: getpeername\n");
#endif
		exit(-1);
	}

	serv_addr.sin_family      = AF_INET;
	serv_addr.sin_port        = htons(port);

	if ( (sockfd = socket(AF_INET, SOCK_DGRAM, 0)) < 0) {
#ifdef DEBUG
		fprintf(fp_err,"error: socket\n");
#endif
		exit(-1);
	}

	memset((char *) &cli_addr,0, sizeof(cli_addr));
	cli_addr.sin_family      = AF_INET;
	cli_addr.sin_addr.s_addr = htonl(INADDR_ANY);
	cli_addr.sin_port        = htons(0);

	if (bind(sockfd, (struct sockaddr *) &cli_addr, sizeof(cli_addr)) < 0) {
#ifdef DEBUG
		fprintf(fp_err,"error: bind\n");
#endif
		exit(-1);
	}
	
	while (1) {
		int pr=0, r;
		int tr=UDP_SEND_LEN-4;
		while (tr) {
			if ((r=read(fd, buffer+pr, tr)) <= 0) {
				if (errno == EAGAIN) {
					usleep(10000); //wait for 10 ms = max. 10 kb 
					continue;
				}
#ifdef DEBUG
				fprintf(fp_err,"error: read demux : %d\n", errno);
#endif
				continue;
			}
			pr+=r;
			tr-=r;
		}
		*((int *)(&(buffer[UDP_SEND_LEN-4])))=pnr++;	
		if (sendto(sockfd, buffer, UDP_SEND_LEN, 0, (struct sockaddr *) &serv_addr, addr_len) < 0) {
#ifdef DEBUG
			fprintf(fp_err,"error: sendto: %d\n", errno);
#endif
			continue;
		}
	}
}
