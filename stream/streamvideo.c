// TCP Video/Audio - PES Streamer
//#include <iostream.h> /* wofür? */
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

#define BLOCKSIZE_AUDIO 1000
#define BLOCKSIZE_VIDEO 1400

int main(int argc, char *argv[])
{
  
  char *aname=argv[2], *vname=argv[1];
  int audiofd, videofd;
  fd_set writefds;
  int sockfda,sockfdv;
  struct sockaddr_in dest_addra, dest_addrv;
  
  unsigned char audiobuf[BLOCKSIZE_AUDIO], videobuf[BLOCKSIZE_VIDEO];
  int rbaudio;  //  Read Bytes Audio
  int rbvideo;  //         and Video
  int bytes_senta;
  int bytes_sentv;

  audiofd = open(aname, O_RDONLY, S_IRWXU);
  videofd = open(vname, O_RDONLY, S_IRWXU); 

        sockfda = socket(AF_INET, SOCK_STREAM, 0);
        dest_addra.sin_family = AF_INET;
        dest_addra.sin_port = htons(DEST_PORT_AUDIO);
        dest_addra.sin_addr.s_addr = inet_addr(DEST_IP);
        memset(&(dest_addra.sin_zero), '\0', 8);
	fcntl(sockfda, F_SETFL, O_NONBLOCK );
        connect(sockfda, (struct sockaddr *)&dest_addra, sizeof(struct sockaddr));
	
        sockfdv = socket(AF_INET, SOCK_STREAM, 0);
        dest_addrv.sin_family = AF_INET;
        dest_addrv.sin_port = htons(DEST_PORT_VIDEO);
        dest_addrv.sin_addr.s_addr = inet_addr(DEST_IP);
        memset(&(dest_addrv.sin_zero), '\0', 8);
	fcntl(sockfdv, F_SETFL, O_NONBLOCK );
        connect(sockfdv, (struct sockaddr *)&dest_addrv, sizeof(struct sockaddr));


//Create FD_SET's for select
FD_ZERO(&writefds);
FD_SET(sockfda,&writefds);
FD_SET(sockfdv,&writefds);

// 500ms muss der Audio vor Video kommen
rbaudio=read(audiofd, audiobuf, BLOCKSIZE_AUDIO);
bytes_senta = send(sockfda, audiobuf, rbaudio, 0);
usleep(500000);

/* shouldn't be necessary */
/*
rbvideo=read(videofd, videobuf, BLOCKSIZE_VIDEO);
bytes_sentv = send(sockfdv, videobuf, rbvideo, 0); 
*/

 while(1) {
   if (select(7, 0, &writefds, 0 ,NULL)>0)
     {
       if (FD_ISSET(sockfda, &writefds)) {
	 rbaudio=read(audiofd, audiobuf, BLOCKSIZE_AUDIO);
	 if(!(bytes_senta = send(sockfda, audiobuf, rbaudio, 0))) {
	  printf("Audio: EOF reached\n");
	  break;
	 }
       }
       if (FD_ISSET(sockfdv, &writefds)) {
	 rbvideo=read(videofd, videobuf, BLOCKSIZE_VIDEO);
	 if(!(bytes_sentv = send(sockfdv, videobuf, rbvideo, 0))) {
	   printf("Video: EOF reached\n");
	   break;
	 }
       }
     }
   FD_SET(sockfda,&writefds);
   FD_SET(sockfdv,&writefds);
 }
 close(videofd);
 close(audiofd);
 close(sockfdv);
 close(sockfda);
return 0;
}
