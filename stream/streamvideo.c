// TCP Video/Audio - PES Streamer
#include <iostream.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/wait.h>
#include <signal.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/time.h>

#define DEST_IP   "192.168.1.10"
#define DEST_PORT_AUDIO 40001
#define DEST_PORT_VIDEO 40000

int main(int argc, char *argv[])
{

char *aname=argv[2];
char *vname=argv[1];

int audiofd;
int videofd;
audiofd = open(aname, O_RDONLY, S_IRWXU);
videofd = open(vname, O_RDONLY, S_IRWXU);

char audiobuf[2500];
char videobuf[2500];
int rbaudio;  //  Received Bytes Audio
int rbvideo;  //             and Video
int bytes_senta;
int bytes_sentv;

        int sockfda;
        struct sockaddr_in dest_addra;
        sockfda = socket(AF_INET, SOCK_STREAM, 0);
        dest_addra.sin_family = AF_INET;
        dest_addra.sin_port = htons(DEST_PORT_AUDIO);
        dest_addra.sin_addr.s_addr = inet_addr(DEST_IP);
        memset(&(dest_addra.sin_zero), '\0', 8);
	fcntl(sockfda, F_SETFL, O_NONBLOCK );
        connect(sockfda, (struct sockaddr *)&dest_addra, sizeof(struct sockaddr));
	
	int sockfdv;
        struct sockaddr_in dest_addrv;
        sockfdv = socket(AF_INET, SOCK_STREAM, 0);
        dest_addrv.sin_family = AF_INET;
        dest_addrv.sin_port = htons(DEST_PORT_VIDEO);
        dest_addrv.sin_addr.s_addr = inet_addr(DEST_IP);
        memset(&(dest_addrv.sin_zero), '\0', 8);
	fcntl(sockfdv, F_SETFL, O_NONBLOCK );
        connect(sockfdv, (struct sockaddr *)&dest_addrv, sizeof(struct sockaddr));


//Create FD_SET's for select
fd_set writefds;
FD_ZERO(&writefds);
FD_SET(sockfda,&writefds);
FD_SET(sockfdv,&writefds);

// 500ms muss der Audio vor Video kommen
rbaudio=read(audiofd, audiobuf, 10);
bytes_senta = send(sockfda, audiobuf, rbaudio, 0);
usleep(500);
rbvideo=read(videofd, videobuf, 10);
bytes_sentv = send(sockfdv, videobuf, rbvideo, 0); 


while(1) 
    if (select(7, 0, &writefds, 0 ,NULL)!=-1)
{
	rbaudio=read(audiofd, audiobuf, 10);
	rbvideo=read(videofd, videobuf, 10);
	bytes_sentv = send(sockfdv, videobuf, rbvideo, 0);
	bytes_senta = send(sockfda, audiobuf, rbaudio, 0);
}
    else  {
		if (FD_ISSET(sockfdv, &writefds)!=-1) { rbvideo=read(videofd, videobuf, 10); bytes_sentv = send(sockfdv, videobuf, rbvideo, 0); }
                if (FD_ISSET(sockfda, &writefds)!=-1) { rbaudio=read(audiofd, audiobuf, 10); bytes_senta = send(sockfda, audiobuf, rbaudio, 0); }
	}
			
return 0;
}


	 
