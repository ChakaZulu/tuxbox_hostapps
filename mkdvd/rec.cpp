/*
   Copyright (c) 2003 Harald Maiss
   
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA. 

*/ 

#define _LARGEFILE64_SOURCE 1  

#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <unistd.h>
#include <pthread.h>
#include <signal.h>
#include <netdb.h>
#include <netinet/in.h>
#ifdef __CYGWIN__
#include <cygwin/in.h>
#define O_LARGEFILE 0
#endif
#include <sys/socket.h>
#include <sys/fcntl.h>


#include <errno.h>
#include <sys/poll.h>
#include <sys/types.h>
#include <sys/stat.h>

#include <fcntl.h>
#include <arpa/inet.h>
#include <netdb.h>

#include <sys/time.h>
#include <time.h>
#include "udpstreampes.h"


#define STREAM_BUF_PACKET_NUM 120  
#define STREAM_BUF_NUM 15
#define WRITE_READ_DISTANCE 5

const int NextStreamBuf[STREAM_BUF_NUM] =
                        {1,2,3,4,5,6,7,8,9,10,11,12,13,14,0};
const int ReadWriteBuf[STREAM_BUF_NUM][STREAM_BUF_NUM] = { 
             {0,0,0,0,0,0,0,0,0,0,1,1,1,1,1},
             {1,0,0,0,0,0,0,0,0,0,0,1,1,1,1},
             {1,1,0,0,0,0,0,0,0,0,0,0,1,1,1},
             {1,1,1,0,0,0,0,0,0,0,0,0,0,1,1},
             {1,1,1,1,0,0,0,0,0,0,0,0,0,0,1},
             {1,1,1,1,1,0,0,0,0,0,0,0,0,0,0},
             {0,1,1,1,1,1,0,0,0,0,0,0,0,0,0},
             {0,0,1,1,1,1,1,0,0,0,0,0,0,0,0},
             {0,0,0,1,1,1,1,1,0,0,0,0,0,0,0},
             {0,0,0,0,1,1,1,1,1,0,0,0,0,0,0},
             {0,0,0,0,0,1,1,1,1,1,0,0,0,0,0},
             {0,0,0,0,0,0,1,1,1,1,1,0,0,0,0},
             {0,0,0,0,0,0,0,1,1,1,1,1,0,0,0},
             {0,0,0,0,0,0,0,0,1,1,1,1,1,0,0},
             {0,0,0,0,0,0,0,0,0,1,1,1,1,1,0} };

int NextSPktBuf[MAX_SPKT_BUF_NUM];

struct {
  unsigned char Buf[MAX_SPKT_BUF_NUM][SPKT_BUF_PACKET_NUM];
  int WritePkt;
  int WriteBuf;
  int ReadPkt;
  int ReadBuf;
  unsigned BufNum;
} SPkt;


//typedef unsigned char StreamBufType[][NET_DATA_PER_PACKET]; 

typedef struct {
   unsigned char *Buf[STREAM_BUF_NUM];
   int BufCount[STREAM_BUF_NUM];
   int PacketStatus[STREAM_BUF_NUM][AV_BUF_FACTOR*STREAM_BUF_PACKET_NUM];
   int ReadBuf;
   int WriteBuf;
   int BufSize;
   int BufPacketNum;
   int fd;
   int Stopped;
} StreamType;

StreamType Stream[MAX_PID_NUM];
int StreamNum;
pthread_t StreamThread;
int StreamStopped;
int Log_fd;
 
const char StreamFileEnding[MAX_PID_NUM][5] = {
   ".m2v",
   ".a0",
   ".a1",
   ".a2",
   ".a3",
   ".a4",
   ".a5",
   ".a6",
   ".a7" 
};

char StreamFileName[MAX_PID_NUM][100];

struct {
   struct sockaddr_in Addr;
   struct hostent * hp;
   int Socket; 
   int Port;
   char String[STRING_SIZE];
   int Pid[MAX_PID_NUM];		
   int Stopped;
   pthread_t Thread;
   char Hostname[100];
   int tty_fd;
   char ttyName[100];
   pthread_t ttyThread;
} DBox;

struct {
   struct sockaddr_in Addr;
   socklen_t AddrLen;
   struct hostent * hp;
   int Socket;
   int Port;
   unsigned char Buf[DATA_PER_PACKET];
   pid_t ProcessID;
   pthread_t Thread;
   int Stopped;
   int Timeout;
   int Priority;
} Udp;

unsigned RevByteOrder (unsigned  k) 
{
  return (( k & 0xff000000)>>24) | 
          ((k & 0x00ff0000)>>8) |
          ((k & 0x0000ff00)<<8) |
          ((k & 0x000000ff)<<24) ;         
}

void * PrintTimeStamp( char message[] )
{
   time_t time_cur;
   tm *time_tm;
   char logline[STRING_SIZE];

   time_cur = time(NULL);
   time_tm = localtime(&time_cur);

   sprintf(logline, "%2i:%.2i.%.2i - %s", time_tm->tm_hour,
                                            time_tm->tm_min,
                                            time_tm->tm_sec,
                                            message );
   write( Log_fd, logline, strlen(logline)); 

   return 0;
}


void * ttyLogger( void * Ptr )
{
   char c, *StrPtr;
   char ttyString[STRING_SIZE], string[STRING_SIZE];

   DBox.tty_fd = open(DBox.ttyName, O_RDONLY|O_NOCTTY);
   if (DBox.tty_fd == -1) {
      perror("ttyLogger() - open");
      exit(-1);
   }

   while(true) {
      StrPtr = ttyString;
      while (StrPtr-ttyString < STRING_SIZE) {
         if ( 1 == read(DBox.tty_fd, &c, 1) ) {
            if (c == '\n') continue;
            if (c == '\r') break;
            *StrPtr++ = c;
         } else {
            perror("ttyLogger() - read");
            exit(-1);
         }
      }
      *StrPtr++ = '\n';
      *StrPtr++ = 0;

      sprintf( string, "DBox tty: %s", ttyString);
      PrintTimeStamp ( string );
   }
   return 0;  // wir nie erreicht
}


void * StreamWriter( void * Ptr )
{
   int u, v;   
   int written, towrite, writelen, readpos;
   int StopCount, LostPackets, ReadBuf, WrittenStreams;
   char string[STRING_SIZE];  

   for ( u=0; u<StreamNum; u++) Stream[u].Stopped = 0;

   do {
      usleep(100000);
      WrittenStreams = 0;
      do {
         for ( u=0; u<StreamNum; u++) {
            if (Stream[u].Stopped) {
               WrittenStreams++;
            } else {
               ReadBuf = Stream[u].ReadBuf;
               if ( Udp.Stopped || 
                      ReadWriteBuf[ReadBuf][Stream[u].WriteBuf] ) {
                  ReadBuf = NextStreamBuf[ReadBuf];
                  Stream[u].ReadBuf = ReadBuf;
                  if ( Udp.Stopped && (ReadBuf == Stream[u].WriteBuf) ) 
                                                    Stream[u].Stopped = 1;
                  towrite = Stream[u].BufSize;
                  LostPackets = 0;
                  for (v=0; v<Stream[u].BufPacketNum; v++ ) {
                     if ( !Stream[u].PacketStatus[ReadBuf][v] ) {
                        if ( Udp.Stopped && (ReadBuf == Stream[u].WriteBuf) ) {
                           towrite = v * NET_DATA_PER_PACKET;
                           break;
                        } else {
                           LostPackets++;
                        } 
                     }
                     Stream[u].PacketStatus[ReadBuf][v] = 0;
                  }
                  if (LostPackets) {
                     sprintf( string, "StreamWriter() - stream %u, %u packets lost\n", 
                            u, LostPackets );
                     PrintTimeStamp( string );
                  }
               
                  // mehrere 60k-write's, weil sonst Pakete verloren gehen 
                  writelen = 40 * NET_DATA_PER_PACKET; 
                  readpos = 0;
                  while( towrite > 0 ) {
                     if ( writelen > towrite ) writelen = towrite; 
                     written = write ( Stream[u].fd,
                                 Stream[u].Buf[ReadBuf] + readpos,
                                 writelen );
                     if ( written == -1 ) {
                        sprintf(string, "StreamWriter - write error stream %u\n", u);
                        PrintTimeStamp( string );
                        exit(-1);
                     }
                     towrite -= written;
                     readpos += written;
                     usleep( 2000 );
                  } 
               } else {
                  WrittenStreams++;
               }
            } 
         }
      } while ( WrittenStreams < StreamNum );
      StopCount=0;
      for (u=0; u<StreamNum; u++) {
         if (Stream[u].Stopped) StopCount++;
      }
   } while ( StopCount < StreamNum );
   
   // Clean-Up   
   for ( u=0; u<StreamNum; u++) {
      close (Stream[u].fd);
      for ( v=0; v<STREAM_BUF_NUM; v++ ) free( Stream[u].Buf[v]);
   }
   StreamStopped = 1;
   pthread_exit(0);

   return 0;  // wegen Warning
}


void * UdpReceiver( void * Ptr)
{
   int RetVal, Str;
   unsigned char *WritePtr, *ReadPtr;
   PacketHeaderType *PacketHeader;
   int Packet, BufPacket, BufCount, LastBufCount, LastPacket, StreamBuf;
   char string[STRING_SIZE];
   unsigned u;

   Udp.ProcessID = getpid();        

   PacketHeader = (PacketHeaderType*)(Udp.Buf);
   ReadPtr = &(Udp.Buf[sizeof(PacketHeaderType)]);
   // letztes Packet wird im Header mit einem Status gekennzeichent

   LastPacket = 0;
   do {
      RetVal = recvfrom ( Udp.Socket, Udp.Buf, DATA_PER_PACKET, 0, 
                          (struct sockaddr*)&(Udp.Addr), &(Udp.AddrLen)  ); 
   
//      fprintf( Log_fd, "%u %u %u %u %x\n", PacketHeader->Packet,
//                                        PacketHeader->Status,
//                                        PacketHeader->SPktBuf,
//                                        PacketHeader->Stream,
//                                        PacketHeader->StreamPacket ); 
   
      if ( -1 == RetVal ) {
         perror("UdpReceiver() - recvfrom()" ); 
         continue;
      }
      Udp.Timeout = 0;
      if ( DATA_PER_PACKET != RetVal ) {
         sprintf(string, "UdpReceiver() - recvfrom() illegal length %i\n", RetVal ); 
         PrintTimeStamp( string );
         continue;
      }
      
      if ( PacketHeader->SPktBuf >= SPkt.BufNum) {
     //    sprintf(string, "%i %i\n", PacketHeader->SPktBuf,
     //                               SPkt.BufNum ); 
     //    PrintTimeStamp( string );
         PrintTimeStamp("UdpReceiver() - PacketHeader->SPktBuf too large\n");
         continue;
      }

      if ( PacketHeader->SPktBuf != SPkt.WriteBuf ) {
         for (u=1; u<SPkt.BufNum; u++) {
            SPkt.WriteBuf=NextSPktBuf[SPkt.WriteBuf];
            if (SPkt.ReadBuf == SPkt.WriteBuf ) {
               PrintTimeStamp("UdpReceiver() - super packet buffer overflow (1)\n");
               // Sollte nie passieren!
               // Gibt nur bei Packet-Resends Probleme
               continue;  
            }
            if ( PacketHeader->SPktBuf == SPkt.WriteBuf ) break;
         }
      }

      if ( PacketHeader->Packet >= SPKT_BUF_PACKET_NUM) {
         PrintTimeStamp("UdpReceiver() - PacketHeader->Packet too large\n");
         continue;
      }
      SPkt.Buf[PacketHeader->SPktBuf][PacketHeader->Packet] = 1;
      Str = PacketHeader->Stream;
      if ( Str >= StreamNum) {
         PrintTimeStamp("UdpReceiver() - PacketHeader->Stream too large");
         continue;
      }
   
      Packet = RevByteOrder(PacketHeader->StreamPacket);
      BufPacket = Packet % Stream[Str].BufPacketNum;
      BufCount = Packet / Stream[Str].BufPacketNum;
      LastBufCount = Stream[Str].BufCount[ Stream[Str].WriteBuf ];

      if ( BufCount > LastBufCount ) {
        for (u=1; u<WRITE_READ_DISTANCE; u++) {   // Buffer Overflow???
           LastBufCount++;
           Stream[Str].WriteBuf = NextStreamBuf[ Stream[Str].WriteBuf ];
           Stream[Str].BufCount[ Stream[Str].WriteBuf ] = LastBufCount;
           if (LastBufCount == BufCount ) break;
        }
      }

      if (u==WRITE_READ_DISTANCE) {
         PrintTimeStamp("UdpReceiver() - BufCount too large\n");
         continue;
      }

      for (StreamBuf=0; StreamBuf<STREAM_BUF_NUM; StreamBuf++) {
         if (BufCount == Stream[Str].BufCount[StreamBuf] ) break;
      } 
      if ( StreamBuf == STREAM_BUF_NUM ) continue;  
         // Fehlermerldung bei StreamWriter "...packets lost"
         // => es kann unabhaengig von ReadBuf geschrieben werden 
    
      WritePtr = Stream[Str].Buf[StreamBuf] +
                    BufPacket * NET_DATA_PER_PACKET ;
      Stream[Str].PacketStatus[StreamBuf][BufPacket] = 1; 
    
      memcpy ( WritePtr, ReadPtr, NET_DATA_PER_PACKET); 
                   
      switch ( PacketHeader->Status ) {
         case 1:  // letztes Packet eines Superpackets
            SPkt.WriteBuf = NextSPktBuf[SPkt.WriteBuf];
            if (SPkt.ReadBuf == SPkt.WriteBuf ) {
               PrintTimeStamp("UdpReceiver() - super packet buffer overflow (2)\n");
               // Sollte nie passieren!
               // Gibt nur bei Packet-Resends Probleme  
            }
            break;
         case 2:  // letztes Packet
            LastPacket = 1;
            break;             
      }                                        
   } while( !LastPacket );
   close ( Udp.Socket );
   Udp.Stopped = 1;
   pthread_exit(0);

   return 0;   // wegen warning
}
   

// Eine Textzeile von DBox.Socket nach DBox.String lesen
void RecvLine( char String[] )
{
   char c, *StrPtr;

   StrPtr = String;
   while (StrPtr-String < STRING_SIZE) {
      if ( 1 == read(DBox.Socket, &c, 1) ) {
         if ((*StrPtr++=c) == '\n') break;
      } else {
         perror("RecvLine() - recv");
         exit(-1);
      }
   }
   *StrPtr++ = 0;
}

void * TcpReceiver( void * Ptr )
{
   char string[STRING_SIZE], TcpString[STRING_SIZE];

   do {
      RecvLine( TcpString );
      sprintf(string, "from DBox: %s", TcpString);
      PrintTimeStamp( string );
   } while ( strncmp(TcpString, "EXIT", 4) );  
   DBox.Stopped = 1;
   pthread_exit(0);

   return 0; // wegen Warning
}     


pid_t mainProcessID;

int main(int argc, char * argv[] ) 
{
   char AVString[MAX_PID_NUM+1];
   int  RetVal, LostPackets;
   int u, v, w;
   int i;
   unsigned k;
   char string[STRING_SIZE];

   mainProcessID = getpid();
	
   // *****************************************************
   // Kommandozeile auswerten
   // *****************************************************

   char StartDateStr[15], StartTimeStr[10], EndTimeStr[10];
   char BaseFileName[100];
   int Bouquet, Channel;  
   int RadioMode, TimeMode;
   int ExtraPidNum;
   int ExtraPid[MAX_PID_NUM];
   char ExtraAVString[MAX_PID_NUM+1];
   char ExtraString[200];
   int day, month, year, start_hour, start_min, end_hour, end_min;
   struct tm Time;
   time_t StartTime, EndTime; 
   unsigned IP1, IP2, IP3, IP4;
   int IpMode, LogMode, ttyMode, TimeoutOffMode, ZapMode;

   strcpy( DBox.ttyName, "/dev/ttyS1" );  
   strcpy( BaseFileName, "stream" );
   strcpy( DBox.Hostname, "dbox" );
   Bouquet = 0;   // PID Mode
   Channel = 1;
   DBox.Port = 31340;
   Udp.Port =  31341;
   RadioMode = 1;
   TimeMode = 0;
   ExtraPidNum = 0;
   IpMode = 0;
   LogMode = 0;
   ttyMode = 0;
   ZapMode = 0;
   TimeoutOffMode = 0;
   Log_fd = STDOUT_FILENO;
   SPkt.BufNum = 16;

   for (int i = 1; i < argc; i++) {
      if (!strcmp("-o", argv[i])) {
         i++; if (i >= argc) { fprintf(stderr, "need filename for -o\n"); exit(-1); }
         strcpy( BaseFileName, argv[i]);
      } else if (!strcmp("-tcp", argv[i])) {
         i++; if (i >= argc) { fprintf(stderr, "need tcp port for -tcp\n"); exit(-1); }
	 DBox.Port = atoi(argv[i]);
      } else if (!strcmp("-udp", argv[i])) {
         i++; if (i >= argc) { fprintf(stderr, "need udp port for -udp\n"); exit(-1); }
	 Udp.Port = atoi(argv[i]);
      } else if (!strcmp("-host", argv[i])) {
         i++; if (i >= argc) { fprintf(stderr, "need argument for -host\n"); exit(-1); }
         strcpy( DBox.Hostname, argv[i]);
      } else if (!strcmp("-time", argv[i])) {
         i++; if (i >= argc) { fprintf(stderr, "need date for -time\n"); exit(-1); }
         strcpy( StartDateStr, argv[i]);
         i++; if (i >= argc) { fprintf(stderr, "need start time for -time\n"); exit(-1); }
         strcpy( StartTimeStr, argv[i]);
         i++; if (i >= argc) { fprintf(stderr, "need end time for -time\n"); exit(-1); }
         strcpy( EndTimeStr, argv[i]);

         // bei %i wird die fuehrende 0 als oktal interpretiert!!
         if ( 3 != sscanf( StartDateStr, "%u.%u.%u", &day, &month, &year ) ) { 
            fprintf( stderr, "-time: illegal date format\n");
            exit(-1);
         }
         if ( 2 != sscanf( StartTimeStr, "%u:%u", &start_hour, &start_min ) ) {
            fprintf( stderr, "-time: illegal start time format\n");
            exit(-1);
         }
         if ( 2 != sscanf( EndTimeStr, "%u:%u", &end_hour, &end_min ) ) {
            fprintf( stderr, "-time: illegal end time format\n");
            exit(-1);
         }
         TimeMode = 1;

      } else if (!strcmp("-tv", argv[i])) {
         i++; if (i >= argc) { fprintf(stderr, "need bouquet for -tv\n"); exit(-1); }
	 Bouquet = atoi(argv[i]);
         i++; if (i >= argc) { fprintf(stderr, "need channel for -tv\n"); exit(-1); }
	 Channel = atoi(argv[i]);
         RadioMode = 0;
      } else if (!strcmp("-ra", argv[i])) {
         i++; if (i >= argc) { fprintf(stderr, "need bouquet for -ra\n"); exit(-1); }
	 Bouquet = atoi(argv[i]);
         i++; if (i >= argc) { fprintf(stderr, "need channel for -ra\n"); exit(-1); }
	 Channel = atoi(argv[i]);
      } else if (!strcmp("-vp", argv[i])) {
         i++; if (i >= argc) { fprintf(stderr, "need pid for -vp\n"); exit(-1); }
         sscanf(argv[i], "%x", &(ExtraPid[ExtraPidNum]) );
         ExtraAVString[ExtraPidNum++] = 'v';
      } else if (!strcmp("-ap", argv[i])) {
         i++; if (i >= argc) { fprintf(stderr, "need pid for -ap\n"); exit(-1); }
         sscanf(argv[i], "%x", &(ExtraPid[ExtraPidNum]) );
         ExtraAVString[ExtraPidNum++] = 'a';
      } else if (!strcmp("-ip", argv[i])) {
         i++; if (i >= argc) { fprintf(stderr, "need ip address for -ip\n"); exit(-1); }
         if ( 4 != sscanf(argv[i], "%u.%u.%u.%u", &IP1, &IP2, &IP3, &IP4) ) {
             fprintf( stderr, "illegal ip address for -ip\n"); exit(-1); }
         IpMode = 1;
      } else if (!strcmp("-tty", argv[i])) {
         i++; if (i >= argc) { fprintf(stderr, "need tty name for -tty\n"); exit(-1); }
         strcpy( DBox.ttyName, argv[i]);
         ttyMode = 1;
      } else if (!strcmp("-log", argv[i])) {
         LogMode = 1; 
      } else if (!strcmp("-toff", argv[i])) {
         TimeoutOffMode = 1; 
      } else if (!strcmp("-zap", argv[i])) {
         ZapMode = 1; 
      } else if (!strcmp("-buf", argv[i])) {
         i++; if (i >= argc) { fprintf(stderr, "need buffer num for -buf\n"); exit(-1); }
         sscanf(argv[i], "%u", &(SPkt.BufNum) );
         if (SPkt.BufNum > MAX_SPKT_BUF_NUM || SPkt.BufNum < 5) {
            fprintf(stderr, "-buf buffer num too large/small\n"); exit(-1); }
      } else {
         fprintf(stderr, "unknown option '%s'\n", argv[i]);
         fprintf(stderr, "------- known options: ---------\n"
         "-time 01.01.03 10:00 11:00    recording times\n"
         "-tv 1 3                       record tv + zapit bouquet, channel\n"
         "-ra 1 3                       record radio + zapit bouquet, channel\n"
	 "-o stream                     basename of output files\n"
         "-host dbox                    dbox hostname\n"
         "-udp 31341                    udp port\n"
         "-tcp 31340                    tcp port\n"
         "-vp 1ff                       extra video pid\n"
         "-ap 201                       extra audio pid\n"
         "-ip 192.168.0.100             ip address of network card connected to dbox\n"
         "-tty /dev/ttyS1               tty device connected to dbox\n"
         "-log                          log to <basename>.log\n"
         "-toff                         UDP data timeout detection off\n"
         "-zap                          zap only (no streaming!)\n"
         "-buf 16                       number of dbox transmit buffers\n"
         );
         exit(-1);
      }
   }

   if (Bouquet == 0 && ExtraPidNum == 0) {
      printf("Bouquet         : " );
      if ( 1 != scanf("%u", &Bouquet) ) { 
         fprintf(stderr, "ERROR: unsigned integer expected\n");
         exit(-1);
      }
      if ( Bouquet == 0 ) { 
         fprintf(stderr, "ERROR: Bouquet == 0 not allowed\n");
         exit(-1);
      }
      printf("Channel         : " );
      if( 1 != scanf("%u", &Channel) ) {
         fprintf(stderr, "ERROR: unsigned integer expected\n");
         exit(-1);
      }
      if( !TimeMode  ) {
         printf("Start Date      : " );
         if ( 3 != scanf( "%u.%u.%u", &day, &month, &year ) ) { 
            fprintf( stderr, "ERROR: format dd.mm.yy expected\n");
            exit(-1);
         }
         printf("Start Time      : " );   
         if ( 2 != scanf( "%u:%u", &start_hour, &start_min ) ) {
            fprintf( stderr, "ERROR: format hh:mm expected\n");
            exit(-1);
         }
         printf("End Time        : " );
         if ( 2 != scanf( "%u:%u", &end_hour, &end_min ) ) {
            fprintf( stderr, "ERROR: format hh:mm expected\n");
            exit(-1);
         }
         TimeMode = 1;
         RadioMode = 0;
      }
   }
 
   if ( TimeMode ) {
      Time.tm_sec=0;
      Time.tm_min=start_min;
      Time.tm_hour=start_hour;
      Time.tm_mday=day;
      Time.tm_mon=month-1;
      if(year > 1900) {
          Time.tm_year = year - 1900;
      } else {
          Time.tm_year = year + 100;
      }
      Time.tm_isdst = -1;
      StartTime = mktime(&Time);

      Time.tm_min=end_min;
      Time.tm_hour=end_hour;
      EndTime = mktime(&Time);
      if (EndTime < StartTime) {
         EndTime += 24 * 60 * 60;
      }

      if (EndTime < time(NULL) ) ZapMode=1;
   } else {
      StartTime = 0;
      EndTime = time(NULL) + 60;
   }

   for (k=0; k< SPkt.BufNum-1; k++) NextSPktBuf[k] = k+1;
   NextSPktBuf[ SPkt.BufNum-1 ] = 0;

   ExtraAVString[ExtraPidNum] = 0;

   // Dateinamen erstellen
   for (i=0; i<MAX_PID_NUM; i++) {
     strcpy( StreamFileName[i], BaseFileName );
     strcat( StreamFileName[i], StreamFileEnding[i] );
   } 
   if (LogMode) {
      strcat( BaseFileName, ".log" );
      Log_fd = open( BaseFileName, 
          O_CREAT|O_TRUNC|O_WRONLY, 
          S_IRGRP|S_IRUSR|S_IROTH|S_IWGRP|S_IWUSR|S_IWOTH);

      if (Log_fd == -1) {
         perror("main() - open log");
         exit(-1);
      }
   }

   if (ttyMode) {
      if ( -1 == pthread_create( &(DBox.ttyThread), 0, ttyLogger, 0 ) ) {
         perror("main() - pthread_create ttyLogger");
         exit(-1);
      }
   }    
 
   // *****************************************************
   // TCP-Verbindung zur DBox herstellen
   // *****************************************************

   DBox.hp = gethostbyname(DBox.Hostname);
   if (DBox.hp == 0) {
      perror("main() - gethostbyname dbox");
      exit(-1);
   }

   memset ((char *)&(DBox.Addr), 0, sizeof(struct sockaddr_in));
   DBox.Addr.sin_family = AF_INET;
   DBox.Addr.sin_addr.s_addr = ((struct in_addr *)(DBox.hp->h_addr))->s_addr;
   DBox.Addr.sin_port = htons((unsigned short int)(DBox.Port));

   if (DBox.Addr.sin_addr.s_addr == 0) {
      fprintf(stderr, "main() - lookup hostname dbox\n");
      exit(-1);
   }
		         
   DBox.Socket = socket(AF_INET, SOCK_STREAM, 0);
   if ( -1 == DBox.Socket ) {
      perror("main() - socket dbox");
      exit(-1);
   }

   if ( -1 == connect(DBox.Socket, (sockaddr*)&(DBox.Addr), 
                                     sizeof(struct sockaddr_in)) ) {
      perror("main() - connect dbox");
      exit(-1);
   }
	
   // *************************************************
   // Umschalt-Befehl an die DBox schicken 
   // *************************************************
   if (ExtraPidNum) {
      sprintf(ExtraString, "%s", ExtraAVString);
      for(i=0; i<ExtraPidNum; i++) {
         sprintf( string, " %x", ExtraPid[i]);
         strcat(ExtraString, string);  
      }
   } else {
      ExtraString[0] = 0;
   }
   
   if (RadioMode) {
      sprintf(DBox.String, "AUDIO %i %i %i %i %s\n", 
                         Udp.Port, SPkt.BufNum, Bouquet, Channel, ExtraString);
   } else {
      sprintf(DBox.String, "VIDEO %i %i %i %i %s\n", 
                      Udp.Port, SPkt.BufNum, Bouquet, Channel, ExtraString);
   }

   if( -1 == write(DBox.Socket, DBox.String, strlen(DBox.String)) ) {
      perror("main() - write VIDEO/AUDIO/PID");
      exit(-1);
   }
   sprintf(string, "to DBox: %s", DBox.String);
   PrintTimeStamp( string );

   while (true) {  
      RecvLine( DBox.String ); 
      sprintf(string, "from DBox: %s", DBox.String);
      PrintTimeStamp( string ); 
      if ( !strncmp( DBox.String, "EXIT", 4) ) exit(-1);
      if ( !strncmp( DBox.String, "PID", 3 ) ) break;
   }

   RetVal = sscanf( DBox.String, "%s %s %u %x %x %x %x %x %x %x %x %x",
                  string, AVString, &StreamNum, 
                  &(DBox.Pid[0]), &(DBox.Pid[1]), &(DBox.Pid[2]), 
                  &(DBox.Pid[3]), &(DBox.Pid[4]), &(DBox.Pid[5]), 
                  &(DBox.Pid[6]), &(DBox.Pid[7]), &(DBox.Pid[8]) );
   if (RetVal < 4 || RetVal > (MAX_PID_NUM+3) || 
       (RetVal != StreamNum + 3) ) {
      PrintTimeStamp("main() - illegal answer to VIDEO/AUDIO/PID\n" );
      exit(-1);
   } 

   DBox.Stopped = 0;
   if ( -1 == pthread_create( &(DBox.Thread), 0, TcpReceiver, 0 ) ) {
      perror("main() - pthread_create TcpReceiver");
      exit(-1);
   } 

   if (ZapMode) {
     Udp.Stopped = 1;
     StreamStopped = 1;
   } else {

   // *****************************************************
   // UdpReceiver einrichten
   // *****************************************************

   if (IpMode) {
      Udp.Addr.sin_addr.s_addr = ( (IP4<<24) | (IP3<<16) | (IP2<<8) | IP1 );
   } else {
      if( -1 == gethostname( string, STRING_SIZE ) ) {
         perror("main() - gethostname");
         exit(-1);
      }

      Udp.hp = gethostbyname( string );
      if (Udp.hp == 0) {
         perror("main() - gethostbyname host");
         exit(-1);
      }
      Udp.Addr.sin_addr.s_addr = ((struct in_addr *)(Udp.hp->h_addr))->s_addr;
   }

   Udp.Addr.sin_family = AF_INET;
   Udp.Addr.sin_port = htons((unsigned short int)(Udp.Port));

   Udp.Socket = socket(AF_INET, SOCK_DGRAM, 0);
   if ( -1 == Udp.Socket ) {
      perror("main() - socket host");
      exit(-1);
   }
   Udp.AddrLen = sizeof(struct sockaddr_in);
   if ( -1 == bind( Udp.Socket, (struct sockaddr*)&(Udp.Addr), 
                                                   Udp.AddrLen )) {
      perror ("main() - bind host\n");
      exit(-1);
   }

   SPkt.WriteBuf = 0;
   SPkt.ReadBuf = 0;

   // ***************************************************
   // UdpReceiver und WriteStream Thread's straten
   // ***************************************************

   for ( u=0; u<StreamNum; u++) {   
      Stream[u].fd = open(StreamFileName[u],
                O_WRONLY|O_CREAT|O_TRUNC|O_LARGEFILE, 
                S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH | S_IWOTH );

      if (Stream[u].fd == -1) {
         perror("main() - open stream file");
         exit(-1); 
      }
      Stream[u].ReadBuf = STREAM_BUF_NUM-1;
      Stream[u].WriteBuf = 0;
      if ( AVString[u] == 'v' ) {
         Stream[u].BufPacketNum = 
           AV_BUF_FACTOR * STREAM_BUF_PACKET_NUM;
      } else {
         Stream[u].BufPacketNum = STREAM_BUF_PACKET_NUM;
      }
      Stream[u].BufSize = Stream[u].BufPacketNum * NET_DATA_PER_PACKET;
      for( v=0; v<STREAM_BUF_NUM; v++) {       
         for (w=0; w<Stream[u].BufPacketNum; w++) {
            Stream[u].PacketStatus[v][w] = 0;
         }
         Stream[u].BufCount[v] = -1;
         Stream[u].Buf[v] = (unsigned char*)malloc( Stream[u].BufSize );
         if ( Stream[u].Buf[v] == 0 ) {
            fprintf (stderr, "StreamWriter() - unable to malloc Buf %i\n", u );
            exit(-1);
         }
      }
      Stream[u].BufCount[0] = 0;
   }

   StreamStopped = 0;
   if ( -1 == pthread_create( &(StreamThread), 0, StreamWriter, 0 ) ) {
      perror("main() - pthread_create StreamWriter");
      exit(-1);
   } 

   Udp.Stopped = 0;
   if ( -1 == pthread_create( &(Udp.Thread), 0, UdpReceiver, 0 ) ) {
      perror("main() - pthread_create UdpReceiver");
      exit(-1);
   }

   // ****************************************************
   // Streaming starten
   // ****************************************************

   // auf Startzeitpunkt warten
   i = StartTime - time(NULL);
   if ( i > 0 ) sleep(i);

   sprintf(DBox.String, "START\n" );
   write(DBox.Socket, DBox.String, strlen(DBox.String));
   sprintf(string, "to DBox: %s", DBox.String);
   PrintTimeStamp( string );

   Udp.Timeout = 0;
   while( time(NULL) <= EndTime ) {
      while ( SPkt.ReadBuf != SPkt.WriteBuf ) {
         LostPackets = 0;
         for (u=0; u<SPKT_BUF_PACKET_NUM; u++) {
            if ( SPkt.Buf[ SPkt.ReadBuf][u] != 1 ) {
               LostPackets++;
               string[u] = 'y';
             } else {
               string[u] = 'n';
             }
         }
         string[SPKT_BUF_PACKET_NUM] = 0;
         if (LostPackets != 0 ) {
            sprintf(DBox.String, "RESEND %u %s\n", SPkt.ReadBuf, string);
            if( -1 == write(DBox.Socket, DBox.String, strlen(DBox.String)) ) {
                perror("main() - write RESEND");
            }
            sprintf(string, "to DBox: RESEND %i packets\n", LostPackets);
            PrintTimeStamp( string );
         }
         for (u=0; u<SPKT_BUF_PACKET_NUM; u++) 
                           SPkt.Buf[SPkt.ReadBuf][u] = 0; 

         SPkt.ReadBuf = NextSPktBuf[SPkt.ReadBuf];
      }
      if( DBox.Stopped ) exit(-1);
      usleep(300000);
      if ( !TimeoutOffMode ) {
         if ( ( !RadioMode && Udp.Timeout >= 40) ||  // 12 Sek.
                Udp.Timeout >= 100 ) {           
            Udp.Stopped = 1; 
            PrintTimeStamp( "UDP Timeout\n" );
            break;
         } 
      }

      Udp.Timeout++; 
   }
   } // if (!ZapMode)

   sprintf(DBox.String, "STOP\n" );
   write(DBox.Socket, DBox.String, strlen(DBox.String));
   sprintf(string, "to DBox: %s", DBox.String);
   PrintTimeStamp( string );

   if (ttyMode) {
      pthread_cancel( DBox.ttyThread );
      close( DBox.tty_fd);
   }

   for( u=0; u<150; u++) {
     if ( StreamStopped && DBox.Stopped && Udp.Stopped ) break;
     usleep(100000);
   }
   sprintf(string, "Stopped: %i %i %i\n", Udp.Stopped, DBox.Stopped, StreamStopped );
   PrintTimeStamp( string );

   if ( Udp.Stopped == 0 ) {
      Udp.Stopped = 1;
      sleep(15);
      sprintf(string, "Stopped: %i %i %i\n", Udp.Stopped, DBox.Stopped, StreamStopped );
      PrintTimeStamp( string );
   }

   // Clean-Up
   if(Log_fd != STDOUT_FILENO) close (Log_fd);
   close( DBox.Socket );
   exit(0);
} 
