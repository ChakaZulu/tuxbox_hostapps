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
#include <math.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

#include <errno.h>

#define STRING_SIZE 200
#define TMAP_TIME_UNIT 4  // 4 Sekunden
#define VMG_LEN 100
#define VTS_START_DISTANCE 101
#define VTS_END_DISTANCE 500
#define START_VTSM_VOBS 200


#define MAX_AUDIO_STREAM_NUM 8
#define FRAMES_PER_SECOND 25
#define AUDIO_FRAMES_PER_SECOND 32    // 90000 / 2880
#define PLAY_TIME 6 // Stunden Spielzeit -> Tabellengroessen

#define DVD_NUM 3
#define MAX_VOB_PER_DVD 5
#define DVD_SECTOR_NUM 2293000  // abrunden(4,7E9/2048 - 1100)

#define SECTOR_LEN 0x800
#define FIRST_VIDEO_DATA_PER_SECTOR (SECTOR_LEN - 33)
#define STD_VIDEO_DATA_PER_SECTOR (SECTOR_LEN - 23)

#define FIRST_AUDIO_DATA_PER_SECTOR (SECTOR_LEN - 31) 
#define STD_AUDIO_DATA_PER_SECTOR (SECTOR_LEN - 28)   
#define FIRST_DOLBY_DATA_PER_SECTOR (SECTOR_LEN - 35) 
#define STD_DOLBY_DATA_PER_SECTOR (SECTOR_LEN - 32)   

#define AUDIO_BUF_SIZE 1000000
unsigned char AudioBuf[MAX_AUDIO_STREAM_NUM][AUDIO_BUF_SIZE];
#define PACKET_BUF_SIZE 0x10000
unsigned char PacketBuf[PACKET_BUF_SIZE];  // fuer Audio PES-Packets
#define CUT_BUF_SIZE 10000 
#define CUT_TABLE_SIZE 1000

#define VIDEO_BUF_SIZE 5000000
unsigned char VideoBuf[VIDEO_BUF_SIZE];

typedef long long int TimeStampType;
typedef unsigned char TwoByte[2];
typedef unsigned char FourByte[4];
typedef unsigned char OneByte;

#define PTS_TOLERANCE 10
#define GAP_TOLERANCE 100000  // in Pictures / Frames

#define FILE_NAME_LEN 100

const char AudioFileEnding[MAX_AUDIO_STREAM_NUM][5] = {
   ".a0",
   ".a1",
   ".a2",
   ".a3",
   ".a4",
   ".a5",
   ".a6",
   ".a7" 
};

// Vob-Daten
typedef struct {
   char VIDEO_TS_Ifo[50];
   char VIDEO_TS_Bup[50];
   char VTS_01_0_Ifo[50];
   char VTS_01_0_Bup[50];
} IfoFileNameEntry;

   const char VobFileName[DVD_NUM][MAX_VOB_PER_DVD][40] = {
      { "./dvd/001/VIDEO_TS/VTS_01_1.VOB",
        "./dvd/001/VIDEO_TS/VTS_01_2.VOB",
        "./dvd/001/VIDEO_TS/VTS_01_3.VOB",
        "./dvd/001/VIDEO_TS/VTS_01_4.VOB",
        "./dvd/001/VIDEO_TS/VTS_01_5.VOB" },
      { "./dvd/002/VIDEO_TS/VTS_01_1.VOB",
        "./dvd/002/VIDEO_TS/VTS_01_2.VOB",
        "./dvd/002/VIDEO_TS/VTS_01_3.VOB",
        "./dvd/002/VIDEO_TS/VTS_01_4.VOB",
        "./dvd/002/VIDEO_TS/VTS_01_5.VOB" },
      { "./dvd/003/VIDEO_TS/VTS_01_1.VOB",
        "./dvd/003/VIDEO_TS/VTS_01_2.VOB",
        "./dvd/003/VIDEO_TS/VTS_01_3.VOB",
        "./dvd/003/VIDEO_TS/VTS_01_4.VOB",
        "./dvd/003/VIDEO_TS/VTS_01_5.VOB" }
   };


// Ifo-Daten
const IfoFileNameEntry IfoFileNameList[3] = {
   { "./dvd/001/VIDEO_TS/VIDEO_TS.IFO",
     "./dvd/001/VIDEO_TS/VIDEO_TS.BUP",
     "./dvd/001/VIDEO_TS/VTS_01_0.IFO",
     "./dvd/001/VIDEO_TS/VTS_01_0.BUP" },

   { "./dvd/002/VIDEO_TS/VIDEO_TS.IFO",
     "./dvd/002/VIDEO_TS/VIDEO_TS.BUP",
     "./dvd/002/VIDEO_TS/VTS_01_0.IFO",
     "./dvd/002/VIDEO_TS/VTS_01_0.BUP" },

   { "./dvd/003/VIDEO_TS/VIDEO_TS.IFO",
     "./dvd/003/VIDEO_TS/VIDEO_TS.BUP",
     "./dvd/003/VIDEO_TS/VTS_01_0.IFO",
     "./dvd/003/VIDEO_TS/VTS_01_0.BUP" }
};

// Standarteinstellungen:
// Extension: normal
// Language type: not specified
// Language: not specified
// Multichannel extension: not present
// Mode: not specified

#define AUDIO_TYPE_NUM 16

typedef struct {
   OneByte Audio_Attributes[8];
   int FrameLen;
   char String[32];
} AudioTypeEntry;

AudioTypeEntry AudioTypeList[AUDIO_TYPE_NUM] = {
   { { 0x00, 0xc5, 0, 0, 0, 1, 0, 0 }, 0x700, "Dolby AC3 5.1 448 kBit/s" },
   { { 0x00, 0xc1, 0, 0, 0, 1, 0, 0 }, 0x700, "Dolby AC3 2.0 448 kBit/s" },
   { { 0x40, 1, 0, 0, 0, 0, 1, 0 }, 0x60, "MP2-Audio 32 kBit/s" },
   { { 0x40, 1, 0, 0, 0, 0, 1, 0 }, 0x90, "MP2-Audio 48 kBit/s" },
   { { 0x40, 1, 0, 0, 0, 0, 1, 0 }, 0xa8, "MP2-Audio 56 kBit/s" },
   { { 0x40, 1, 0, 0, 0, 0, 1, 0 }, 0xc0, "MP2-Audio 64 kBit/s" },
   { { 0x40, 1, 0, 0, 0, 0, 1, 0 }, 0xe0, "MP2-Audio 80 kBit/s" },
   { { 0x40, 1, 0, 0, 0, 0, 1, 0 }, 0x120, "MP2-Audio 96 kBit/s" },
   { { 0x40, 1, 0, 0, 0, 0, 1, 0 }, 0x150, "MP2-Audio 112 kBit/s" },
   { { 0x40, 1, 0, 0, 0, 0, 1, 0 }, 0x180, "MP2-Audio 128 kBit/s" },
   { { 0x40, 1, 0, 0, 0, 0, 1, 0 }, 0x1e0, "MP2-Audio 160 kBit/s" },
   { { 0x40, 1, 0, 0, 0, 0, 1, 0 }, 0x240, "MP2-Audio 192 kBit/s" },
   { { 0x40, 1, 0, 0, 0, 0, 1, 0 }, 0x2a0, "MP2-Audio 224 kBit/s" },
   { { 0x40, 1, 0, 0, 0, 0, 1, 0 }, 0x300, "MP2-Audio 256 kBit/s" },
   { { 0x40, 1, 0, 0, 0, 0, 1, 0 }, 0x3c0, "MP2-Audio 320 kBit/s" },
   { { 0x40, 1, 0, 0, 0, 0, 1, 0 }, 0x480, "MP2-Audio 384 kBit/s" }
};


#define MP2_TYPE_NUM
typedef struct {
    int BitRate;
    int FrameLen;
    int AudioType; 
} MP2TypeEntry;

MP2TypeEntry MP2Type[16] = {
   {  -1,    -1, -1 },
   {  32,  0x60,  2 },
   {  48,  0x90,  3 },
   {  56,  0xa8,  4 },
   {  64,  0xc0,  5 },
   {  80,  0xe0,  6 },
   {  96, 0x120,  7 },
   { 112, 0x150,  8 },
   { 128, 0x180,  9 },
   { 160, 0x1e0, 10 },
   { 192, 0x240, 11 },
   { 224, 0x2a0, 12 },
   { 256, 0x300, 13 },
   { 320, 0x3c0, 14 },
   { 384, 0x480, 15 },
   {  -1,    -1  -1 }
};

#define VIDEO_TYPE_NUM 16

typedef struct {
   unsigned DVB;
   unsigned DVD;
   char String[32];
} VideoTypeEntry;

// Standarteinstellungen DVD:
// Coding Mode: MPEG2
// Standard: PAL
// Automatic Pan & Sacn: Off
// Automatic Letterbox: Off
// Bit Rate: VBR
// Letterboxed (top & bottom cropped) : Off
// => 0101 aa11 0000 rr00 

const VideoTypeEntry VideoTypeList[VIDEO_TYPE_NUM] = {
   { ((352<<20)|(288<<8)|0x23), 0x530c, "352x288 4/3 25fps" },
   { ((352<<20)|(576<<8)|0x23), 0x5308, "352x576 4/3 25fps" },
   { ((480<<20)|(576<<8)|0x23), 0x5304, "480x576 4/3 25fps (non DVD)" },
   { ((528<<20)|(576<<8)|0x23), 0x5304, "528x576 4/3 25fps (non DVD)" },
   { ((544<<20)|(576<<8)|0x23), 0x5304, "544x576 4/3 25fps (non DVD)" },
   { ((640<<20)|(576<<8)|0x23), 0x5304, "640x576 4/3 25fps (non DVD)" },
   { ((704<<20)|(576<<8)|0x23), 0x5304, "704x576 4/3 25fps" },
   { ((720<<20)|(576<<8)|0x23), 0x5300, "720x576 4/3 25fps" },
   { ((352<<20)|(288<<8)|0x33), 0x5f0c, "352x288 16/9 25fps" },
   { ((352<<20)|(576<<8)|0x33), 0x5f08, "352x576 16/9 25fps" },
   { ((480<<20)|(576<<8)|0x33), 0x5f04, "480x576 16/9 25fps (non DVD)" },
   { ((528<<20)|(576<<8)|0x33), 0x5f04, "528x576 16/9 25fps (non DVD)" },
   { ((544<<20)|(576<<8)|0x33), 0x5f04, "544x576 16/9 25fps (non DVD)" },
   { ((640<<20)|(576<<8)|0x33), 0x5f04, "640x576 16/9 25fps (non DVD)" },
   { ((704<<20)|(576<<8)|0x33), 0x5f04, "704x576 16/9 25fps" },
   { ((720<<20)|(576<<8)|0x33), 0x5f00, "720x576 16/9 25fps" }
};

unsigned char SectorBuf[SECTOR_LEN]; 
int SectorPos;

// Dieser Puffer wird als Ring-Puffer verwaltet
#define VIDEO_DECODING_BUF_SIZE 5000
#define VIDEO_DECODING_BUF_MAX_TRESHOLD 80
#define VIDEO_DECODING_BUF_MIN_TRESHOLD 60
TimeStampType VideoDecodingBuf[VIDEO_DECODING_BUF_SIZE];
int VideoDecodingBufInPos, VideoDecodingBufOutPos;
int VideoDecodingBufMaxSize, VideoDecodingBufMinSize;
TimeStampType SCR_base;
int SCR_extension;


// ======================================================
// Tabellen, die in ParseVideo() ausgefuellt werden:
// ======================================================
#define PIC_LIST_LEN (PLAY_TIME*3600*FRAMES_PER_SECOND)
typedef struct {
   int Skip;
   int Write;        // Write == 0 => Don't Write
   int Picture_Coding_Type;
} PicListEntry;

#define SEQ_LIST_LEN (PLAY_TIME*3600*2)
typedef struct{
   int PicNum;
   TimeStampType StartPTS;  // wie im DBox-Stream
   int DontWrite;
   int VideoType;
} SeqListEntry;


#define VIDEO_CUT_TABLE_LEN 200
typedef struct {
  int TypeSeqNum[VIDEO_TYPE_NUM];
  int Type;
  int fd;
  int BufSize;
  int BufPos;
  int BufLen;   // Anzahl der Schreib-Bytes ab BufPos
  int PicNum;
  int PicPos;
  int SeqPicPos;
  TimeStampType PicPTS;
  int SeqNum;
  int WrittenSeqNum;
  int SeqPos;
  int StreamID;      // 0xe0
  int CutPos;
  int SeqCutPos;
  SeqListEntry Seq[SEQ_LIST_LEN];  // 1 MB
  PicListEntry Pic[PIC_LIST_LEN];  // 6,17 MB
  TimeStampType CutTable[VIDEO_CUT_TABLE_LEN];
  int CutTableLen;
  char FileName[FILE_NAME_LEN];
} VideoType;
VideoType * Video;



// =====================================================
// Tabellen, die von ParseAudio() ausgefuellt werden:
// =====================================================

#define AUDIO_FRAME_LIST_LEN (PLAY_TIME*3600*AUDIO_FRAMES_PER_SECOND)
#define AUDIO_PACKET_LIST_LEN (AUDIO_FRAME_LIST_LEN/4)
#define AUDIO_WRITE_SILENCE 1<<0   // Flag
#define AUDIO_DONT_WRITE 1<<1      // Flag
typedef struct {
   TimeStampType PTS; 
   unsigned short FrameLen;
   unsigned char Flag;
   unsigned char Type;       // AC3, MP2 /Bitrate / Kanalanzahl
} AudioFrameListEntry;

typedef struct {
   int Skip;
   int Write;
} AudioPacketListEntry;


#define AUDIO_SECTOR_LIST_LEN AUDIO_FRAME_LIST_LEN // i.d.R. kuerzer

#define AC3_51_AUDIO 0
#define AC3_20_AUDIO 1
#define AC3_FRAME_LEN 0x700

#define AC3_AUDIO_TYPE 0
#define MP2_AUDIO_TYPE 1

#define MP2_STREAM_ID 0xc0
#define AC3_STREAM_ID 0xbd

unsigned char MP2_Frame[0x240] = { 0xff, 0xfd };
unsigned char AC3_Frame[0x700] = { 0x0b, 0x77  };


typedef struct {
   TimeStampType StartPTS;
   int fd;
   int BufSize;
   int BufPos;
   int BufLen;
   int MainType;      // AC3 / MP2
   int Type;          // AC3/MP2, Bitrate, Channels
   int LastLen;
   int SectorLen;     // Nutzdaten pro Sektor; = konst. ueber Stream
   int FramePos;      // u.a. RealMux()
   int FramePosV;     // SortSectors()
   int FrameNum;
   int FrameLen;      // == AudioTypeList[ Audio.Type ].FrameLen
   TimeStampType FramePTS;
   int FrameBytePos; 
   int PacketPos;
   int PacketNum;
   int StreamID;
   AudioFrameListEntry Frame[AUDIO_FRAME_LIST_LEN];
   AudioPacketListEntry Packet[AUDIO_PACKET_LIST_LEN];
   char FileName[FILE_NAME_LEN];
} AudioListEntry;
AudioListEntry * Audio[MAX_AUDIO_STREAM_NUM];   //1,6 MB
int AudioStreamNum;


// =============================================================
// Tabellen, die von main(), UpdateDSI() ausgfuellt werden
// (Diese Tab. enthaelt keine DontWrite-Sequnezen mehr!)
// =============================================================
typedef struct {
   short First_Ref_Frame_Offset;  // fuer PacketHeader
   unsigned char DeltaFrame;
   unsigned char DeltaFrame_FirstByte;     
   unsigned char MuxCode;
} DVDAudioSectorListEntry; 

typedef struct {
   int LastLen;
   int SectorPos;
   int SectorNum;
   unsigned CurPTS;
   unsigned FirstPTS;
   DVDAudioSectorListEntry Sector[AUDIO_SECTOR_LIST_LEN];
} DVDAudioListEntry;


#define SEQ_PER_DVD 3*3600*2
typedef struct {
   int VOBU_First_Reference_Frame_End_Block;  // DSI
   int VOBU_Second_Reference_Frame_End_Block; // DSI
   int VOBU_Third_Reference_Frame_End_Block;  // DSI
   int Audio_Packet_Offset[MAX_AUDIO_STREAM_NUM]; // DSI
   int SectorPos;       // DSI, PCI, IfoGen
   int LastSectorLen;
   unsigned I_Frame_PTS;  // DSI, PCI, IfoGen
   unsigned I_Frame_DTS;
   int I_P_Distance;
   int Fw_Bw[42];             // DSI
   int BrokenLink;    // WriteFirstVideoSector()
   TimeStampType Cell_Elapsed_Time;  // in PTS-Zyklen
   int VTS_TMAP_Entry;      
} DVDSeqListEntry;

// picture_coding_type
#define I_FRAME 1
#define P_FRAME 2
#define B_FRAME 3

typedef struct {
   unsigned char DeltaPic_FirstByte;
   unsigned char MuxPic;   // HighNibble -> MuxCode: First, Std, LastVideo
                           // LowNibble  -> picture_coding_type
} DVDVideoSectorListEntry;

#define NAVIGATION_SECTOR  0x10  
#define FIRST_VIDEO_SECTOR 0x20  // LowNibble -> picture_coding_type
#define STD_VIDEO_SECTOR   0x30  // LowNibble -> picture_coding_type
#define LAST_VIDEO_SECTOR  0x40  // LowNibble -> picture_coding_type
#define FIRST_AUDIO_SECTOR 0x50
#define STD_AUDIO_SECTOR   0x60  // LowNibble -> AudioStreamNum
#define LAST_AUDIO_SECTOR  0x70  // LowNibble -> AudioStreamNum
#define FIRST_DOLBY_SECTOR 0x80  // LowNibble -> AudioStreamNum
#define STD_DOLBY_SECTOR   0x90  // LowNibble -> AudioStreamNum
#define LAST_DOLBY_SECTOR  0xa0  // LowNibble -> AudioStreamNum

typedef struct {
   char CutFileName[FILE_NAME_LEN];
   char SeqFileName[FILE_NAME_LEN];
   char LogFileName[FILE_NAME_LEN];
   int SeqPos;
   int SeqNum;            // SortSectors()
   int VobCount;          // RealMux()
   int VobSectorNum;
   int SectorPos;
   int SectorNum;         // SortSectors()
   int VideoSectorPos;
   int VideoSectorNum;    // UpdateVideoSectorList()
   DVDSeqListEntry Seq[SEQ_PER_DVD];
   DVDVideoSectorListEntry Video[DVD_SECTOR_NUM];  // 4MB
   DVDAudioListEntry Audio[MAX_AUDIO_STREAM_NUM];
   unsigned char Mux[DVD_SECTOR_NUM+1];  // 2 MB; nur MuxCode
                                         // +1: NavPac + FirstVideoSector 
} DVDType;
DVDType * DVD;

int DVDCount, DVDNum;
TimeStampType Video_DTS_FirstByte; // VobMux() - SCR-Berechnung

TimeStampType long_abs( TimeStampType m)
{
  if (m>=0) return m;
            else return -m;
}

int OneVobMode, CutMode;
int Log_fd, Seq_fd;

void PrintLog( char LogString[] )
{ 
   write( Log_fd, LogString, strlen(LogString) );
}

void PrintSeqTable( int SeqNum, TimeStampType PTS )
{
   char string[STRING_SIZE];
   int pic, sec, min;

   PTS = PTS / Video->PicPTS;  // Anzahl Bilder

   pic = PTS % FRAMES_PER_SECOND;
   PTS = PTS / FRAMES_PER_SECOND;

   sec = PTS % 60;
   PTS = PTS / 60;

   min = PTS % 60;
   PTS = PTS / 60;

   sprintf( string, "%i - %.2lli:%.2i:%.2i.%.2i\n",
                       SeqNum, PTS, min, sec, pic );

   write( Seq_fd, string, strlen(string) );
}
// ===============================================================
// VideoDecodingBuf -> SCR Berchnung
// ===============================================================

void WriteVideoDecodingBuf(TimeStampType DTS)
{
    VideoDecodingBuf[VideoDecodingBufInPos++] = DTS;
    if ( VideoDecodingBufInPos == VIDEO_DECODING_BUF_SIZE ) 
                                       VideoDecodingBufInPos = 0;      
}


int VideoDecodingBufSize_CheckMax()
{
   int size;

   size = VideoDecodingBufInPos - VideoDecodingBufOutPos;
   if ( size < 0 ) size += VIDEO_DECODING_BUF_SIZE;

   if ( size > VideoDecodingBufMaxSize ) VideoDecodingBufMaxSize = size;

   return size;
}

int VideoDecodingBufSize_CheckMin()
{
   int size;

   size = VideoDecodingBufInPos - VideoDecodingBufOutPos;
   if ( size < 0 ) size += VIDEO_DECODING_BUF_SIZE;

   if ( size < VideoDecodingBufMinSize ) VideoDecodingBufMinSize = size;

   return size;
}


void ReadDecodingBuf()
{
   while( VideoDecodingBuf[VideoDecodingBufOutPos] < SCR_base ) {
      if (VideoDecodingBufInPos == VideoDecodingBufOutPos ) break;            
      VideoDecodingBufOutPos++;
      if ( VideoDecodingBufOutPos == VIDEO_DECODING_BUF_SIZE ) 
                                       VideoDecodingBufOutPos = 0;
   }
}

void NextSCR()
// SCR um den Betrag erhoehen, der fuer einen Sektor (2048 Byte) 
// bei 1260000 Byte/s benoetigt wird.
// 27 000 000 * 2048 / 1260000 = 146 * 300 + 85,7
{
   SCR_extension += 86;
   SCR_base += 146;
   if( SCR_extension >= 300) {
      SCR_extension -= 300;
      SCR_base++;
   }
}

// =================================================================
// ParseAudio()
// =================================================================

typedef struct {
   TimeStampType CurPTS;
   TimeStampType PTS;
   int FrameNum;
   int TypeFrameNum[AUDIO_TYPE_NUM];
   int Type[10];
   int FrameLen[10];
   int NetPacketLen;
   int PacketHeaderLen;
   int PacketBufSize;
   int PacketBufPos;
   int Break;
} AudioData;

int CheckAudioPacketHeader( int Str, AudioData *data )
{
   unsigned char PES_header_data_length;
   int PES_packet_length;
   TimeStampType PTS;
 
   if( !(AudioBuf[Str][Audio[Str]->BufPos] == 0 &&
       AudioBuf[Str][Audio[Str]->BufPos+1] == 0 &&
       AudioBuf[Str][Audio[Str]->BufPos+2] == 1 && 
       AudioBuf[Str][Audio[Str]->BufPos+3] == Audio[Str]->StreamID) ) {
       return -1;
   }     
   Audio[Str]->BufPos += 4;
 
   PES_packet_length = (AudioBuf[Str][Audio[Str]->BufPos++]<<8); 
   PES_packet_length = PES_packet_length | AudioBuf[Str][Audio[Str]->BufPos++]; 

   Audio[Str]->BufPos += 2; 
   PES_header_data_length = AudioBuf[Str][Audio[Str]->BufPos++];
          
   PTS =       ((AudioBuf[Str][Audio[Str]->BufPos++] & 0x0ellu)<<29);   // 29=30-1
   PTS = PTS |  (AudioBuf[Str][Audio[Str]->BufPos++]<<22);              // 22=30-8
   PTS = PTS | ((AudioBuf[Str][Audio[Str]->BufPos++] & 0xfellu)<<14);   // 14=15-1
   PTS = PTS |  (AudioBuf[Str][Audio[Str]->BufPos++]<<7);               // 7=15-8
   PTS = PTS | ((AudioBuf[Str][Audio[Str]->BufPos++] & 0xfellu)>>1);

   if ( (PTS + 3600*90000) < Video->Seq[0].StartPTS ) PTS += 0x200000000llu; 

   data->CurPTS = PTS;   

   Audio[Str]->BufPos += PES_header_data_length-5;
    
   data->NetPacketLen = PES_packet_length - PES_header_data_length - 3;
   data->PacketHeaderLen = PES_header_data_length + 9;

   return 0;
}
   
void ReadAudioBuf( int Str )
{
 
   int i,j, len;
   const unsigned char Sequence_Error_Code[4] = { 0x00, 0x00, 0x01, 0xb4 };

   if ( Audio[Str]->BufPos > AUDIO_BUF_SIZE/2 ) {

      memcpy( AudioBuf[Str], &AudioBuf[Str][Audio[Str]->BufPos], 
                            Audio[Str]->BufSize - Audio[Str]->BufPos);

      len = read(Audio[Str]->fd, 
            &AudioBuf[Str][Audio[Str]->BufSize - Audio[Str]->BufPos], 
            Audio[Str]->BufPos);
      if (len == -1) {
         PrintLog( "ReadAudioBuf() - read\n");
         exit(-1);
      }

      Audio[Str]->BufSize = Audio[Str]->BufSize - Audio[Str]->BufPos + len;
      Audio[Str]->BufPos = 0;

      j=0;
      for( i=Audio[Str]->BufSize; i<AUDIO_BUF_SIZE; i++) {
         AudioBuf[Str][i] = Sequence_Error_Code[j];
         j++;
         if ( j==4 ) j=0;
      }
   }
}


int DoAudioPacketSync( int Str )
// BufPos bleibt auf dem Begin des Sync-Worts stehen
{  
   while ( !(AudioBuf[Str][Audio[Str]->BufPos] == 0 &&
             AudioBuf[Str][Audio[Str]->BufPos+1] == 0 &&
             AudioBuf[Str][Audio[Str]->BufPos+2] == 1 )) 
                                              Audio[Str]->BufPos++;
      
   return AudioBuf[Str][Audio[Str]->BufPos+3];            
}


void DoMP2FrameSync( int Str,  AudioData *data )
{
   char string[STRING_SIZE];
   int i, Offset;

   for( i=0; i<data->NetPacketLen; i++ ) {
      if (  (AudioBuf[Str][Audio[Str]->BufPos] == 0xff) &&
           ((AudioBuf[Str][Audio[Str]->BufPos+1] & 0xfe) == 0xfc ) ) break;
      Audio[Str]->BufPos++;
   }
   if ( i == data->NetPacketLen ) {
      PrintLog("DoMP2FrameSync() - can't sync\n");
      exit(-1);
   } 
   Offset = i;
   Audio[Str]->Packet[0].Skip = Audio[Str]->BufPos;
   Audio[Str]->Packet[0].Write = data->NetPacketLen - i;
   Audio[Str]->PacketPos = 1;
  
   sprintf( string, "MP2 first frame offset: %i\n", Offset);
   PrintLog( string );

   Audio[Str]->FramePTS = 2160;
   Audio[Str]->MainType = MP2_AUDIO_TYPE;
   data->PacketBufSize = data->NetPacketLen - Offset;
   memcpy( PacketBuf, &AudioBuf[Str][ Audio[Str]->BufPos ], data->PacketBufSize);
   Audio[Str]->BufPos += data->PacketBufSize;
}

void DoAC3FrameSync( int Str,  AudioData *data )
{
   Audio[Str]->Packet[0].Skip = Audio[Str]->BufPos;
   Audio[Str]->Packet[0].Write = data->NetPacketLen;
   Audio[Str]->PacketPos = 1;

   Audio[Str]->FramePTS = 2880;
   Audio[Str]->MainType = AC3_AUDIO_TYPE; 

   data->PacketBufSize = data->NetPacketLen;
   memcpy( PacketBuf, &AudioBuf[Str][ Audio[Str]->BufPos ], data->PacketBufSize);
   Audio[Str]->BufPos += data->PacketBufSize;
}
  
void DiscardAudioPacket( int Str, AudioData * data)
{
   PrintLog("DiscardAudioPacket()\n");   
}

void ParseMP2Frames( int Str,  AudioData *data )
{
   int bit_rate_index;

   data->FrameNum = 0;
   data->PacketBufPos = 0;
   do {
     if ( (PacketBuf[data->PacketBufPos] != 0xff) ||
         ((PacketBuf[data->PacketBufPos+1] & 0xfe) != 0xfc) ) {
         PrintLog("ParseMP2Frames() - frame sync error\n");
         DiscardAudioPacket( Str, data);
         data->Break = 1;
         return;
      }
      bit_rate_index = (PacketBuf[data->PacketBufPos+2] & 0xf0)>>4;
      if (MP2Type[ bit_rate_index ].AudioType == -1 ) {
         PrintLog("ParseMP2Frames() - illegal MP2 bitrate\n");
         exit(-1);
      }
      if ( (PacketBuf[data->PacketBufPos+2] & 0x0c) != 0x04 ) {
         PrintLog("DoMP2FrameSync() - sampling frequency != 48kHz\n");
         exit(-1);
      }
      data->Type[ data->FrameNum ] = MP2Type[ bit_rate_index].AudioType;
      data->FrameLen[ data->FrameNum ] = MP2Type[ bit_rate_index].FrameLen;
      data->TypeFrameNum[MP2Type[ bit_rate_index].AudioType]++;
      data->PacketBufPos += MP2Type[ bit_rate_index].FrameLen;
      data->FrameNum++;
   } while ( data->PacketBufPos+3 <= data->PacketBufSize);
   if (data->PacketBufPos > data->PacketBufSize ) {
      data->FrameNum--;
      data->PacketBufPos -= MP2Type[bit_rate_index].FrameLen;
      data->TypeFrameNum[MP2Type[ bit_rate_index].AudioType]--;
   }
}

void ParseAC3Frames( int Str,  AudioData *data )
{
   data->FrameNum = 0;
   data->PacketBufPos = 0;
   while ( data->PacketBufPos + AC3_FRAME_LEN <= data->PacketBufSize ) {
      if ( (PacketBuf[data->PacketBufPos] != 0x0b) ||
         (PacketBuf[data->PacketBufPos+1] != 0x77) ) {
         PrintLog("ParseAC3Frames() - frame sync error\n");
         DiscardAudioPacket( Str, data);
         data->Break = 1;
         return;
      }
      if ( (PacketBuf[data->PacketBufPos+6]&0xe0) == 0xe0 ) {
          // audio coding mode 3/2
         data->TypeFrameNum[AC3_51_AUDIO]++;
         data->Type[data->FrameNum] = AC3_51_AUDIO;
      } else {
         data->TypeFrameNum[AC3_20_AUDIO]++;
         data->Type[data->FrameNum] = AC3_20_AUDIO;
      }     
      data->PacketBufPos += AC3_FRAME_LEN;
      data->FrameLen[ data->FrameNum ] = AC3_FRAME_LEN;
      data->FrameNum++;
   }
}

void VideoSeqAudioCut( int Str, AudioData * data )
// Video->Seq[].DontWrite;
{
   #define AUDIO_CUT_TABLE_LEN 100
   int i, CutTablePos, SearchType;
   CutTablePos = 0;
   TimeStampType CutTable[AUDIO_CUT_TABLE_LEN];
   int CutTableLen;
   char string[STRING_SIZE];

   int AudioType, AudioTypeFrameNum;
   
   AudioType = 0;
   AudioTypeFrameNum = data->TypeFrameNum[0];
   for ( i=1; i<AUDIO_TYPE_NUM; i++ ) { 
      if ( data->TypeFrameNum[i] > data->TypeFrameNum[ AudioType ] ) {
         AudioType = i;
         AudioTypeFrameNum = data->TypeFrameNum[i];
      }
   }
   Audio[Str]->FrameLen = AudioTypeList[ AudioType ].FrameLen;
   Audio[Str]->Type = AudioType;
   sprintf( string, "Stream %i: %s (%i)\n", Str, 
             AudioTypeList[ AudioType ].String, Audio[Str]->Type ); 
   PrintLog( string );
  
   // PTS's der Schnittpunkt ermitteln
   SearchType = 1;
   for (i=0; i<Audio[Str]->FrameNum; i++ ) {
      if ( !(Audio[Str]->Frame[i].Flag & AUDIO_WRITE_SILENCE) ) {
         if (SearchType) {
            if ( Audio[Str]->Frame[i].Type == AudioType ) {
               CutTable[CutTablePos++] = Audio[Str]->Frame[i].PTS;
               SearchType = 0;
             }
         } else {
            if ( Audio[Str]->Frame[i].Type != AudioType ) {
               CutTable[CutTablePos++] = Audio[Str]->Frame[i].PTS;
               SearchType = 1;
             }
         }
      } 
   }
   // der letzte Schnittpunkt muss hinter dem Videoende liegen
   CutTable[CutTablePos++] = 0x800000000llu;  
   if (CutTablePos >= AUDIO_CUT_TABLE_LEN) {
      PrintLog("VideoSeqAudioCut() - AUDIO_CUT_TABLE_LEN too small\n");
      return;
   }
   CutTableLen = CutTablePos;
   
   // Video->Seq[].DontWrite
   CutTablePos = 0;
   SearchType = 1;
   for ( i=0; i<Video->SeqNum; i++) {
      if (Video->Seq[i].DontWrite ) continue;

      if ( SearchType ) {
         if ( CutTable[CutTablePos] > 
              (Video->Seq[i].StartPTS + 4 * Video->PicPTS ) ) {
            Video->Seq[i].DontWrite = 1;
         } else {
            SearchType = 0;
            CutTablePos++;
         }
      } else {
         if (CutTable[CutTablePos] <
              (Video->Seq[i].StartPTS + 
              (Video->Seq[i].PicNum-4) * Video->PicPTS) ) {
             Video->Seq[i].DontWrite = 1;
             SearchType = 1;
             CutTablePos++;
         }
      }
   } 
}


int ParseAudio ( int Str)
// Audio[]->Frame[].Skip
//               .Flag
// Audio[]->FramePTS
//        ->FrameLen
//        ->FrameNum
//        ->StreamID
//        ->Type
{
   int i, len;
   unsigned char StreamID;
   AudioData data;
   char string[STRING_SIZE];
   int SilenceFrames;
   TimeStampType StartPTS;

   Audio[Str]->fd = open(Audio[Str]->FileName, O_RDONLY|O_LARGEFILE);
   if (Audio[Str]->fd == -1) {
      return -1;
   }
  
   Audio[Str]->BufPos = AUDIO_BUF_SIZE; // stream_buf vollstaendig fuellen 
   Audio[Str]->BufSize = AUDIO_BUF_SIZE;
   ReadAudioBuf( Str );
   
   Audio[Str]->BufPos--;
   do { 
      Audio[Str]->BufPos++;
      StreamID = DoAudioPacketSync( Str );
      if ( StreamID == 0xb4 &&       // Sequence_Error_Code
           Audio[Str]->BufPos+4 >= Audio[Str]->BufSize ) return -1;
      
      ReadAudioBuf(Str );
   } while ( (StreamID & 0xf0) != MP2_STREAM_ID && StreamID != AC3_STREAM_ID );
   
   Audio[Str]->StreamID = StreamID;  // bei MP2 incl. StreamNr

   data.PTS = Video->Seq[0].StartPTS; // damit Audio nicht spaeter startet
                                     // als Video => WriteSilence
   data.Break = 0;    // Workaround, um das Programm bei Syncfehlern
                      // nicht abbrechen zu muessen
                       

   CheckAudioPacketHeader( Str, &data );   
   if ( (StreamID & 0xf0) == MP2_STREAM_ID ) {
      DoMP2FrameSync( Str, &data );
   } else {   // AC3_STREAM_ID
      DoAC3FrameSync( Str, &data );
   }
   for(i=0; i<AUDIO_TYPE_NUM; i++) data.TypeFrameNum[i] = 0;
      

   while (true) {
      // PTS Luecken mit Stille auffuellen
      SilenceFrames = 0;
      StartPTS = data.PTS;
      while ( (data.PTS + PTS_TOLERANCE) < data.CurPTS ) {
         Audio[Str]->Frame[Audio[Str]->FramePos].Flag = AUDIO_WRITE_SILENCE;
         Audio[Str]->Frame[Audio[Str]->FramePos].PTS = data.PTS;
         Audio[Str]->Frame[Audio[Str]->FramePos].Type = 0; // wird bei Silence ignoriert
         Audio[Str]->FramePos++;
         data.PTS += Audio[Str]->FramePTS;
         SilenceFrames++;
      }
      if (SilenceFrames) {
         sprintf(string, "ParseAudio() - Stream %i - %i frames silence %llx - %llx\n",
                                             Str, SilenceFrames, StartPTS, data.PTS);
         PrintLog( string );
      }
      data.PTS = data.CurPTS;

      if ( Audio[Str]->MainType == MP2_AUDIO_TYPE ) ParseMP2Frames( Str, &data );
                                              else  ParseAC3Frames( Str, &data ); 
      if (data.Break) break;

      len = data.PacketBufSize - data.PacketBufPos;
      memcpy( PacketBuf, &PacketBuf[data.PacketBufPos], len );
      data.PacketBufSize = len;

      for (i=0; i<data.FrameNum; i++) {
         Audio[Str]->Frame[Audio[Str]->FramePos+i].Flag = 0;
         Audio[Str]->Frame[Audio[Str]->FramePos+i].PTS = data.PTS;
         Audio[Str]->Frame[Audio[Str]->FramePos+i].Type = data.Type[i];
         Audio[Str]->Frame[Audio[Str]->FramePos+i].FrameLen = data.FrameLen[i];
         data.PTS += Audio[Str]->FramePTS;
      }
      Audio[Str]->FramePos += data.FrameNum;

      if ( CheckAudioPacketHeader( Str, &data ) ) {
         if ( Audio[Str]->BufPos+4 >= Audio[Str]->BufSize ) break;
         PrintLog("ParseAudio() - Packet sync error\n");
         break;
      }
      if ( data.PacketBufSize ) {
         data.CurPTS -= Audio[Str]->FramePTS;  // wg. Frame vom letzten Paket
      }
      memcpy( &PacketBuf[data.PacketBufSize], 
              &AudioBuf[Str][Audio[Str]->BufPos], data.NetPacketLen);
      data.PacketBufSize += data.NetPacketLen;
      Audio[Str]->BufPos += data.NetPacketLen;
      if ( Audio[Str]->BufPos+4 >= Audio[Str]->BufSize ) break;
      
      Audio[Str]->Packet[Audio[Str]->PacketPos].Skip = data.PacketHeaderLen;
      Audio[Str]->Packet[Audio[Str]->PacketPos].Write = data.NetPacketLen;

      Audio[Str]->PacketPos++;
      ReadAudioBuf( Str );
   }  // Ende Hauptschleife

   Audio[Str]->PacketNum = Audio[Str]->PacketPos;
   Audio[Str]->FrameNum = Audio[Str]->FramePos;
   if (Audio[Str]->FrameNum <= 0) {
      PrintLog( "ParseAudio() - no valid frames\n");
      exit(-1);
   } 
 //  for (i=0; i<Audio[Str]->PacketNum; i++) {
 //    printf("Packet %i %i\n", Audio[Str]->Packet[i].Skip,
 //                             Audio[Str]->Packet[i].Write );
 //  }

   sprintf(string, "Stream %i FrameNum: %i\n", Str, Audio[Str]->FrameNum);
   PrintLog( string );    

   // Dummy-Abschluss.Frame
   Audio[Str]->Frame[Audio[Str]->FramePos].Flag = AUDIO_WRITE_SILENCE;
   Audio[Str]->Frame[Audio[Str]->FramePos].PTS = data.PTS;
   Audio[Str]->Frame[Audio[Str]->FramePos].Type = 0;
   Audio[Str]->FramePos++;

   // DVB-StreamNr auf DVD-StreamNr aendern -> Write...AudioSector()   
   if ( Audio[Str]->MainType == MP2_AUDIO_TYPE ) {
      StreamID = Audio[Str]->StreamID & 0xf0;
      Audio[Str]->StreamID = StreamID | Str;
   } 
   VideoSeqAudioCut ( Str, &data );
   close( Audio[Str]->fd );

   return 0;
}

// =================================================================
// Virtual Mux
// =================================================================


int SortSectors()
{
   unsigned VideoDTS, AudioDTS[MAX_AUDIO_STREAM_NUM];
   unsigned SeqAudioDTS[MAX_AUDIO_STREAM_NUM];
   unsigned CurDTS;
   int SeqAudioPos[MAX_AUDIO_STREAM_NUM];
   int VideoPos, SeqPos, AudioPos[MAX_AUDIO_STREAM_NUM], Sel;
   int AudioMuxPos[MAX_AUDIO_STREAM_NUM];
   int SeqAudioMuxPos[MAX_AUDIO_STREAM_NUM];
   int Offset;
   unsigned char MuxCode;
   //TimeStampType StartDTS;
   int i, j, k;   

   VideoDTS = 3 * Video->PicPTS;
   VideoPos = 0;
   SeqPos = -1;


   for (i=0; i<AudioStreamNum;i++) {
     AudioDTS[i] = 4 * Video->PicPTS; //DVD->Audio[i].FirstPTS;???
     AudioPos[i] = 0;
   }
     
   for (i=0; i<DVD_SECTOR_NUM; i++) {
      CurDTS = VideoDTS;
      Sel = -1;
     
      for (j=0; j<AudioStreamNum; j++ ) {
         if( AudioDTS[j] < CurDTS ) {
            Sel = j;
            CurDTS = AudioDTS[j];
         }
      }

      if (Sel == -1 ) {
         if (VideoPos == DVD->VideoSectorNum) { 
            DVD->SectorNum = i;
            DVD->SeqNum = SeqPos+1;

            // Dummy Sequenz
            DVD->Seq[DVD->SeqNum].SectorPos = i;
            DVD->Seq[DVD->SeqNum].I_Frame_DTS = VideoDTS;
            DVD->Seq[DVD->SeqNum].I_Frame_PTS = VideoDTS + 
                       DVD->Seq[SeqPos].I_P_Distance * Video->PicPTS; 
            return 0;
         }
         MuxCode = DVD->Video[VideoPos].MuxPic;
         if ( (MuxCode & 0xf0) == FIRST_VIDEO_SECTOR ) {
            SeqPos++;
            DVD->Seq[SeqPos].SectorPos = i;
            DVD->Seq[SeqPos].I_Frame_DTS = VideoDTS;
            DVD->Seq[SeqPos].I_Frame_PTS = VideoDTS + 
                       DVD->Seq[SeqPos].I_P_Distance * Video->PicPTS; 
            for (k=0; k<AudioStreamNum; k++) {
               SeqAudioDTS[k] = AudioDTS[k];
               SeqAudioPos[k] = AudioPos[k];
               SeqAudioMuxPos[k] = AudioMuxPos[k];
               DVD->Seq[SeqPos].Audio_Packet_Offset[k] = 0x3fff;
            }
            DVD->Mux[i++] = NAVIGATION_SECTOR;
            DVD->Mux[i] = MuxCode;
         } else {
            DVD->Mux[i] = MuxCode;
         }
         VideoDTS += DVD->Video[VideoPos++].DeltaPic_FirstByte * Video->PicPTS;
      } else {
         //if (AudioPos[Sel] < DVD->Audio[Sel].SectorNum ) { s.u.
         if ( (DVD->Seq[SeqPos].Audio_Packet_Offset[Sel] == 0x3fff) &&
            ( 2 * abs(AudioDTS[Sel] - DVD->Seq[SeqPos].I_Frame_PTS ) <=
                                             Audio[Sel]->FramePTS ) ) {
            DVD->Seq[SeqPos].Audio_Packet_Offset[Sel] =
                                  i - DVD->Seq[SeqPos].SectorPos;
         }  
         AudioMuxPos[Sel] = i;
         Audio[Sel]->FramePosV += 
           DVD->Audio[Sel].Sector[AudioPos[Sel]].DeltaFrame;
         AudioDTS[Sel] += DVD->Audio[Sel].Sector[AudioPos[Sel]].
                         DeltaFrame_FirstByte * Audio[Sel]->FramePTS;
         
         DVD->Mux[i] = DVD->Audio[Sel].Sector[AudioPos[Sel]].MuxCode;
         AudioPos[Sel]++;
         if (AudioPos[Sel] == AUDIO_SECTOR_LIST_LEN ) {
            PrintLog( "SortSectors() - AUDIO_SECTOR_LIST_LEN too small\n");
            exit(-1);
         }
         if (AudioPos[Sel] == DVD->Audio[Sel].SectorNum ) {
            AudioDTS[Sel] = 0x80000000;
         }
      }
   }
   DVD->SeqNum = SeqPos;
   DVD->SectorNum = DVD->Seq[SeqPos].SectorPos;   

   i = 0; 
   j = 0;  
   while ( i < SeqPos ) {
      Video->WrittenSeqNum++;
      if ( !(Video->Seq[j++].DontWrite) ) i++;
   }


   for (k=0; k<AudioStreamNum; k++) {
     Offset = DVD->Audio[k].Sector[SeqAudioPos[k]].First_Ref_Frame_Offset;
     if (Offset ) {
       DVD->Audio[k].LastLen = Audio[k]->SectorLen + Offset;
     } else { // Sonderfall: DTS_FirstByte == PTS
       DVD->Audio[k].LastLen = Audio[k]->SectorLen + Audio[k]->FrameLen;
       Audio[k]->FramePosV++;
     }     
     while (SeqAudioDTS[k] > VideoDTS) {
        Audio[k]->FramePosV--;
        SeqAudioDTS[k] -= Audio[k]->FramePTS;
        DVD->Audio[k].LastLen -= Audio[k]->FrameLen; 
     }
     DVD->Mux[ SeqAudioMuxPos[k] ] = LAST_AUDIO_SECTOR | k;
   }

   return 1;
}

void UpdateVideoSectorList()
// DVD->Video[].DeltaPic_FirstByte
//            .MuxPic
// DVD->VideoSectorNum
// DVD->Seq[].I_P_Distance
// Video->Pic[].Write/Skip bei DontWrite
{
   int Sector, DVDSeq;
   int PicPos;       // Video->PicPosV (vgl. Audio)
   int PicFirstByte;   // des naechsten Pictures relativ zum FirstByte
                       // des naechsten Sektors
   int i,k;
   int Get_I_P_Distance;
   char string[STRING_SIZE];

   PicPos = 0;   // Video->Pic[] 
   DVDSeq=0;       // DVD->Seq[]
   Sector=0;       // DVD->Video[]

   for ( k=0; k<Video->WrittenSeqNum; k++) {
      PicPos += Video->Seq[k].PicNum;
   }

   for( k=Video->WrittenSeqNum; k< Video->SeqNum; k++) { 
      if ( Video->Seq[k].DontWrite ) {
         for (i=0; i<Video->Seq[k].PicNum; i++) {
            Video->Pic[PicPos].Skip += Video->Pic[PicPos].Write;
            Video->Pic[PicPos].Write = 0;
            PicPos++;
         }
      } else {
         if (Video->Pic[PicPos].Picture_Coding_Type != I_FRAME ) {
            PrintLog( "UpdateVideoSectorList() - I frame expected\n");
            exit(-1);
         }
         Get_I_P_Distance = 1;
         PicFirstByte = Video->Pic[PicPos].Write -
                                      FIRST_VIDEO_DATA_PER_SECTOR;
         DVD->Video[Sector].DeltaPic_FirstByte=0;
         DVD->Video[Sector].MuxPic = FIRST_VIDEO_SECTOR | I_FRAME;
         
         for (i=0; i<Video->Seq[k].PicNum; i++) {
            while (PicFirstByte > 0 ) {
               Sector++;                        
               if (Sector == DVD_SECTOR_NUM ) {
                  DVD->VideoSectorNum = DVD_SECTOR_NUM+1;
                  return;
               }
               PicFirstByte -= STD_VIDEO_DATA_PER_SECTOR;
               DVD->Video[Sector].DeltaPic_FirstByte=0;
               DVD->Video[Sector].MuxPic = STD_VIDEO_SECTOR | 
                                 Video->Pic[PicPos].Picture_Coding_Type;
            }
            PicPos++;
            PicFirstByte += Video->Pic[PicPos].Write;
            DVD->Video[Sector].DeltaPic_FirstByte++;
            if (Get_I_P_Distance && 
                (Video->Pic[PicPos].Picture_Coding_Type == P_FRAME) ) {
                Get_I_P_Distance = 0;
                DVD->Seq[DVDSeq].I_P_Distance = i+1;              
            }
         }
         if (Get_I_P_Distance) {
            sprintf( string, "UpdateVideoSectorList() - P frame expected Seq %i\n",
                           DVDSeq);
            PrintLog( string );
            DVD->Seq[DVDSeq].I_P_Distance = Video->Seq[k].PicNum;              

         }

     // Primiere == 3; ARD == 2
     //    if (DVD->Seq[DVDSeq].I_P_Distance != 3 ) {
     //       sprintf( string, "UpdateVideoSectorList() - I_P_Distance == %i\n", 
     //                         DVD->Seq[DVDSeq].I_P_Distance );
     //       PrintLog( string );
     //    }

         DVD->Video[Sector].MuxPic = LAST_VIDEO_SECTOR | 
                              Video->Pic[PicPos-1].Picture_Coding_Type;
         DVD->Seq[DVDSeq].LastSectorLen = STD_VIDEO_DATA_PER_SECTOR +
                                 PicFirstByte - Video->Pic[PicPos].Write;
         DVDSeq++;
         Sector++;
      }   
   }
   DVD->VideoSectorNum = Sector;
}

void UpdateAudioSectorList(int Str)
// DVD->Audio[].Sector[].First_Ref_Frame_Offset
//                     .DeltaFrame_FirstByte
//                     .DeltaFrame
// DVD->Audio[].SectorNum
{
   int Sector, FrameFirstByte, FirstDataPerSector, StdDataPerSector;
   unsigned char FirstMuxCode, StdMuxCode, LastMuxCode;
   int i;
   char string[STRING_SIZE];

   if (Audio[Str]->MainType == MP2_AUDIO_TYPE ) {
      FirstDataPerSector = FIRST_AUDIO_DATA_PER_SECTOR;
      StdDataPerSector = STD_AUDIO_DATA_PER_SECTOR;
      FirstMuxCode = FIRST_AUDIO_SECTOR | Str;
      StdMuxCode = STD_AUDIO_SECTOR | Str;
      LastMuxCode = LAST_AUDIO_SECTOR | Str;
   } else if (Audio[Str]->MainType == AC3_AUDIO_TYPE ) {
      FirstDataPerSector = FIRST_DOLBY_DATA_PER_SECTOR;
      StdDataPerSector = STD_DOLBY_DATA_PER_SECTOR;
      FirstMuxCode = FIRST_DOLBY_SECTOR | Str;
      StdMuxCode = STD_DOLBY_SECTOR | Str;
      LastMuxCode = LAST_DOLBY_SECTOR | Str;
   } else {
       PrintLog("UpdateAudioSectorList() - illegal Audio[]->Type\n");
   }

   // Berechnung DVD->Audio[].Sector[].DeltaFrame_FirstByte
   Sector = 0;
   FrameFirstByte = Audio[Str]->FrameLen - FirstDataPerSector;
   DVD->Audio[Str].Sector[Sector].DeltaFrame_FirstByte = 0;
   DVD->Audio[Str].Sector[Sector].MuxCode = FirstMuxCode;   

   for (i=0; i<Audio[Str]->FrameNum; i++) {
      if ( Audio[Str]->Frame[i].Flag & AUDIO_DONT_WRITE ) { 
          continue;
      }
      if (FrameFirstByte > 0 ) { // Annahme: SectorSize > FrameLen      
         Sector++;
         if (Sector == AUDIO_SECTOR_LIST_LEN) break;
         DVD->Audio[Str].Sector[Sector].DeltaFrame_FirstByte = 0;
         DVD->Audio[Str].Sector[Sector].MuxCode = StdMuxCode;   
         FrameFirstByte -= StdDataPerSector;
      }
       
      FrameFirstByte += Audio[Str]->FrameLen;
      DVD->Audio[Str].Sector[Sector].DeltaFrame_FirstByte++;
   }

   // Berechnung DVD->Audio[].Sector[].DeltaFrame
   Sector=0;
   FrameFirstByte = - FirstDataPerSector;
   DVD->Audio[Str].Sector[Sector].DeltaFrame = 0;
   DVD->Audio[Str].Sector[Sector].First_Ref_Frame_Offset = 0;

   for (i=0; i<Audio[Str]->FrameNum; i++) {
      if ( Audio[Str]->Frame[i].Flag & AUDIO_DONT_WRITE ) continue;
      if (FrameFirstByte >= 0 ) { // Annahme: SectorSize > FrameLen      
         Sector++;
         if (Sector == AUDIO_SECTOR_LIST_LEN) break;
         DVD->Audio[Str].Sector[Sector].DeltaFrame = 0;
         DVD->Audio[Str].Sector[Sector].First_Ref_Frame_Offset = 
                                                      FrameFirstByte;
         FrameFirstByte -= StdDataPerSector;
      }
      FrameFirstByte += Audio[Str]->FrameLen;
      DVD->Audio[Str].Sector[Sector].DeltaFrame++;
   }
   if (FrameFirstByte <= 0) {
      DVD->Audio[Str].LastLen = StdDataPerSector + FrameFirstByte;
   } else {
      Sector++;
      if ( Sector < AUDIO_SECTOR_LIST_LEN ) {
         DVD->Audio[Str].LastLen = FrameFirstByte;
      }
   }
   if ( Sector == 0 ) {
      sprintf( string, "UpdateAudioSectorList() - Stream %i - no sectors\n", Str);
      PrintLog( string );
      exit(-1);
   }
   DVD->Audio[Str].Sector[Sector-1].MuxCode = LastMuxCode;   
   DVD->Audio[Str].SectorNum = Sector;
}



// ================================================================
// RealMux() Unterprogramme
// ================================================================

void PacketWriteAudio ( int n, unsigned char Dest[], int Num, int Write)
// n -> StreamNum
// Dateiende wird nie ganz erreicht
// danach zeigt Audio[]->SectorPos auf den naechsten gueltigen Sektor
// Write == 1 -> Daten kopieren
//       == 0 -> Daten nur ueberspringen

{// Sonderfall: write Silence

   int len;
   char string[STRING_SIZE];

   while (Num) {
      if ( Audio[n]->BufLen >= Num ) {
         if (Write) 
            memcpy( Dest, &AudioBuf[n][Audio[n]->BufPos], Num );
         Audio[n]->BufLen -= Num;
         Audio[n]->BufPos += Num;
         Num = 0;  // Schleifen-Abbruch
      } else {
         if (Write)
            memcpy( Dest, &AudioBuf[n][ Audio[n]->BufPos], Audio[n]->BufLen );
         Num -= Audio[n]->BufLen;
         Audio[n]->BufPos += Audio[n]->BufLen;
         Dest = &Dest[Audio[n]->BufLen];

         Audio[n]->BufPos += Audio[n]->Packet[ Audio[n]->PacketPos ].Skip;
         Audio[n]->BufLen =  Audio[n]->Packet[ Audio[n]->PacketPos ].Write;
         Audio[n]->PacketPos++;

         while ((int)Audio[n]->BufSize <= Audio[n]->BufPos ) {
            Audio[n]->BufPos -= Audio[n]->BufSize;

            Audio[n]->BufSize = 
               read (Audio[n]->fd, AudioBuf[n], AUDIO_BUF_SIZE);
            if (Audio[n]->BufSize == -1  ||
               Audio[n]->BufSize == 0 ) {  // letzter read: Size < SIZE != 0
               PrintLog( "WriteAudio() - read stream 2\n");
               Audio[n]->BufSize = AUDIO_BUF_SIZE;      
               memset(&AudioBuf[n], 0, AUDIO_BUF_SIZE);
               // exit(-1);
            }
         }

         if ((int)Audio[n]->BufSize < (Audio[n]->BufPos + Audio[n]->BufLen) ) {
            len = Audio[n]->BufSize - Audio[n]->BufPos;

            if (Audio[n]->BufSize > Audio[n]->BufPos ) {
               if (Write) 
                  memcpy (&AudioBuf[n], &AudioBuf[n][Audio[n]->BufPos], len);

               Audio[n]->BufSize = read (Audio[n]->fd, 
                          &AudioBuf[n][len],
                          Audio[n]->BufPos);
               if (Audio[n]->BufSize == -1 ||
                   Audio[n]->BufSize == 0 )   { // letzter read: Size < Pos != 0
                  PrintLog( "WriteAudio() - read stream 1\n");
                  Audio[n]->BufSize = AUDIO_BUF_SIZE;      // exit(-1)
                  memset(&AudioBuf[n], 0, AUDIO_BUF_SIZE); //  - " -
                  // exit(-1);
               }
               Audio[n]->BufSize += len;
               if (Audio[n]->BufSize != AUDIO_BUF_SIZE ) {
                  sprintf( string, "WriteAudio() - end of audio stream %i - 2\n", n);
                  PrintLog( string );
               }
               Audio[n]->BufPos = 0;
            } 
         }
      }
   }
}


void FrameWriteAudio ( int n, unsigned char Dest[], int Num)
{
   if ( Audio[n]->Frame[ Audio[n]->FramePos ].Flag & 
                                                AUDIO_WRITE_SILENCE) { 
      switch( Audio[n]->MainType ) {
         case MP2_AUDIO_TYPE:
            memcpy( Dest, &MP2_Frame[Audio[n]->FrameBytePos], Num );
            break;
         case AC3_AUDIO_TYPE:
            memcpy( Dest, &AC3_Frame[Audio[n]->FrameBytePos], Num );
            break;
         default:
            PrintLog( "FrameWriteAudio() - illegale silence frame type\n");
            exit(-1);
      }
   } else {
      PacketWriteAudio( n, Dest, Num, 1);
   }
   Audio[n]->FrameBytePos += Num;
}

void WriteAudio ( int n, unsigned char Dest[], int Num)
{
   int len;

   while( Num ) {
      len = Audio[n]->Frame[ Audio[n]->FramePos ].FrameLen - Audio[n]->FrameBytePos;
      if ( Num <= len ) {
         FrameWriteAudio( n, Dest, Num );
         Num = 0;
      } else {
         FrameWriteAudio( n, Dest, len );
         Dest = &Dest[len];
         Num -= len;
         Audio[n]->FramePos++;
         while ( Audio[n]->Frame[ Audio[n]->FramePos ].Flag & 
                                              AUDIO_DONT_WRITE ) {   
            if ( !(Audio[n]->Frame[ Audio[n]->FramePos ].Flag & 
                                                AUDIO_WRITE_SILENCE) ) {
                PacketWriteAudio(n, Dest, 
                    Audio[n]->Frame[ Audio[n]->FramePos ].FrameLen, 0);
                Audio[n]->FramePos++;
            }
         }
         Audio[n]->FrameBytePos = 0;
      }
   }
}
      
void WriteVideo ( unsigned char Dest[], int Num)
// Dateiende wird nie ganz erreicht
{
   int len;
   char string[STRING_SIZE];

   while (Num) {
      if ( Video->BufLen >= Num ) {
         memcpy( Dest, &VideoBuf[Video->BufPos], Num );
         Video->BufLen -= Num;
         Video->BufPos += Num;
         Num = 0;
      } else {
         memcpy( Dest, &VideoBuf[Video->BufPos], Video->BufLen );
         Num -= Video->BufLen;
         Video->BufPos += Video->BufLen;
         Dest = &Dest[Video->BufLen];
         Video->PicPos++;

         while ( !Video->Pic[ Video->PicPos ].Write ) {
            Video->BufPos += Video->Pic[ Video->PicPos ].Skip;
            Video->PicPos++;
         }
         Video->BufPos += Video->Pic[ Video->PicPos ].Skip;
         Video->BufLen =  Video->Pic[ Video->PicPos ].Write;

         while ((int)Video->BufSize <= Video->BufPos) {
             Video->BufPos -= Video->BufSize;
             Video->BufSize = 
                  read (Video->fd, VideoBuf, VIDEO_BUF_SIZE);
             if (Video->BufSize == -1  ||
                Video->BufSize == 0 ) {  // letzter read: Size < SIZE != 0
                PrintLog( "WriteVideo() - read stream 2\n");
                exit(-1);
             }
             if (Video->BufSize != VIDEO_BUF_SIZE ) {
               if (Video->BufSize < (Video->BufPos + Video->BufLen) ) {
                  PrintLog( "WriteVideo() - read stream 3\n");
                  exit(-1);
               } else {
                   sprintf( string, "WriteVideo() - end of video stream 1 %i\n",
                                      Video->BufPos);
                   PrintLog( string );
                }   
             }
         }

         if ((int)Video->BufSize < (Video->BufPos + Video->BufLen) ) {
            len = Video->BufSize - Video->BufPos;
            memcpy (VideoBuf, &VideoBuf[Video->BufPos], len );
            Video->BufSize = read (Video->fd, 
                          &VideoBuf[len],
                          Video->BufPos );
            if (Video->BufSize == -1 ||
               Video->BufSize == 0 )   { // letzter read: Size < Pos != 0
               PrintLog( "WriteVideo() - read stream 1\n");
               exit(-1);
            }
            Video->BufPos = 0;  
            Video->BufSize += len;
            if (Video->BufSize != VIDEO_BUF_SIZE ) {
               PrintLog( "WriteVideo() - end of video stream 2\n");
            }
         }
      }
   }
}

void WritePackHeader(unsigned char pack_stuffing_length)
{
   int i;
   TimeStampType base;
   int extension;

   base = SCR_base;
   extension = SCR_extension;

   SectorBuf[0] = 0;
   SectorBuf[1] = 0;
   SectorBuf[2] = 1;
   SectorBuf[3] = 0xba;

   SectorBuf[9] = (unsigned char)((extension & 0x7f)<<1) | 0x01;
   extension = extension >> 7;
   SectorBuf[8] = (unsigned char)(extension & 0x03) |
                           0x04 |
                           (unsigned char)((base & 0x1fllu)<<3);
   base = base>>5;          
   SectorBuf[7] = (unsigned char)(base & 0xffllu);
   base = base>>8;
   SectorBuf[6] = (unsigned char)(base & 0x03llu) |
                           0x04 |
                           (unsigned char)(base & 0x7cllu)<<1;
   base = base>>7;
   SectorBuf[5] = (unsigned char)(base & 0xffllu);
   base = base>>8;
   SectorBuf[4]   = (unsigned char)(base & 0x03llu) |
                           0x44 |
                           (unsigned char)(base & 0x1cllu)<<1;

   SectorBuf[10] = 0x01;
   SectorBuf[11] = 0x89;
   SectorBuf[12] = 0xc3;  // program_mux_rate: 1260000 Byte/s
    
   SectorBuf[13] = pack_stuffing_length & 0x07 | 0xf8;
   SectorPos = 14;   

   for( i=0; i<pack_stuffing_length; i++) SectorBuf[SectorPos++] = 0xff;
}

void WriteTimestamp(TimeStampType Timestamp,
                    unsigned char Signature)
{
   SectorBuf[SectorPos+4] = (unsigned char)((Timestamp & 0x7fllu)<<1) | 0x01;
   Timestamp = Timestamp >> 7;
   SectorBuf[SectorPos+3] = (unsigned char)(Timestamp & 0xffllu);
   Timestamp = Timestamp >> 8;
   SectorBuf[SectorPos+2] = (unsigned char)((Timestamp & 0x7fllu)<<1) | 0x01;
   Timestamp = Timestamp >> 7;
   SectorBuf[SectorPos+1] = (unsigned char)(Timestamp & 0xffllu);
   Timestamp = Timestamp >> 8;
   SectorBuf[SectorPos]   = (unsigned char)((Timestamp & 0x07llu)<<1) | 
                                                           Signature | 0x01;
   SectorPos += 5;
}


// ==============================================================
// Unterprogramme: WriteNavigationSector()
// ==============================================================

typedef struct {
   OneByte Sub_Stream_ID; 
   FourByte this_lba;
   TwoByte Macrovision;
   TwoByte Reserved_1;
   FourByte Prohibited_U_OP;
   FourByte VOBU_Start_PTS;
   FourByte VOBU_End_PTS;
   FourByte End_PTS_of_VOBU_if_SequenceEndCode;
   FourByte Cell_Elapsed_Time;
   OneByte International_Standard_Recoding_Code[32];
   OneByte Reserved_2[730];
   OneByte Recording_Information[6];
   OneByte Reserved_3[183];
} Presentation_Control_Information_Type;

typedef struct {
   OneByte Sub_Stream_ID;
   FourByte SCR;
   FourByte this_lba;
   FourByte VOBU_End_Adress;
   FourByte VOBU_First_Reference_Frame_End_Block;
   FourByte VOBU_Second_Reference_Frame_End_Block;
   FourByte VOBU_Third_Reference_Frame_End_Block;
   TwoByte VOB_ID;
   OneByte Reserved_1;
   OneByte Cell_ID;
   FourByte Cell_Elapsed_Time;
// 0x0427:
   OneByte Reserved_2[12];
// 0x0433:
   FourByte First_I_Frame_PTS;
   FourByte Last_Frame_PTS;
// 0x043b:
   OneByte Reserved_3[182]; 
// 0x04f1:
   FourByte Fw_Bw_Information[42];
// 0x0599:
   TwoByte Offset_to_Audio_Packet_for_Audio_Stream[8];
   FourByte Offset_to_SubP_Packet_for_SubP_Stream[32];
   OneByte Reserved_4[471];
} Data_Search_Information_Type;  

Presentation_Control_Information_Type *PCI;
Data_Search_Information_Type *DSI;


void WriteFourByte( FourByte Target, int Value)
{
   Target[3] = Value & 0xff;
   Value = Value>>8;
   Target[2] = Value & 0xff;
   Value = Value>>8;
   Target[1] = Value & 0xff;
   Value = Value>>8;
   Target[0] = Value & 0xff;
}

void WriteTwoByte( TwoByte Target, int Value)
{
   Target[1] = Value & 0xff;
   Value = Value>>8;
   Target[0] = Value & 0xff;
}

void WriteBytes( OneByte Target[], OneByte Source[], int Num)
{
   int i;
   for(i=0; i<Num; i++) {
      Target[i] = Source[i];
   }
}

void WriteString( char Target[], char Source[], int Num)
{
   int i;
   for(i=0; i<Num; i++) {
      Target[i] = Source[i];
   }
}


void WriteTimeBCD( FourByte Target, TimeStampType PTS)
{
   unsigned char c;
   TimeStampType fps;

   PTS = PTS / Video->PicPTS;  // Anzahl Bilder

   fps = PTS % FRAMES_PER_SECOND;
   fps = (fps % 10) + 16 * (fps / 10);
   Target[3] = 0x40 + fps;
   PTS = PTS / FRAMES_PER_SECOND;

   c = PTS % 10;
   PTS = PTS / 10;
   Target[2] = (PTS % 6)<<4 | c;
   PTS = PTS / 6;

   c = PTS % 10;
   PTS = PTS / 10;
   Target[1] = (PTS % 6)<<4 | c;
   PTS = PTS / 6;

   c = PTS % 10;
   PTS = PTS / 10;
   Target[0] = (PTS & 0x0f)<<4 | c;
}

void WriteSystemHeader()
{  
   SectorBuf[SectorPos++] = 0;
   SectorBuf[SectorPos++] = 0;
   SectorBuf[SectorPos++] = 1;
   SectorBuf[SectorPos++] = 0xbb;  // private_stream_2

   SectorBuf[SectorPos++] = 0x00;
   SectorBuf[SectorPos++] = 0x12;

   SectorBuf[SectorPos++] = 0x80;  // rate_bound: 1260000 Byte/s
   SectorBuf[SectorPos++] = 0xc4;
   SectorBuf[SectorPos++] = 0xe1;
 

   SectorBuf[SectorPos++] = 0x00;  // audio_bound: 0 (6 Bit) 
                                  // AC3 zaehlt nich als ISO-Audio
                                  // fixed_flag: 0
                                  // CSPS_flag: 0

   SectorBuf[SectorPos++] = 0xe1;  // system_audio_lock_flag: 1
                                  // system_video_lock_flag: 1
                                  // video_bound: 1 (5 Bit)

   SectorBuf[SectorPos++] = 0x7f;  // undefined, reserved

   SectorBuf[SectorPos++] = 0xb9;  // all video streams
   SectorBuf[SectorPos++] = 0xe0;  // P-STD_buffer_size_bound =
   SectorBuf[SectorPos++] = 0xe8;  //                232*1024 Byte

   SectorBuf[SectorPos++] = 0xb8;  // all audio streams
   SectorBuf[SectorPos++] = 0xc0;  // P-STD_buffer_size_bound =
   SectorBuf[SectorPos++] = 0x20;  //                  32*128 Byte

   SectorBuf[SectorPos++] = 0xbd;  // private_stream_1 -> AC3
   SectorBuf[SectorPos++] = 0xe0;  // P-STD_buffer_size_bound =
   SectorBuf[SectorPos++] = 0x3a;  //                 58*1024 Byte

   SectorBuf[SectorPos++] = 0xbf;  // private_stream_2 -> NavigationData
   SectorBuf[SectorPos++] = 0xe0;  // P-STD_buffer_size_bound =
   SectorBuf[SectorPos++] = 0x02;  //                  2*1024 Byte
}


void WritePresentationControlInformation()
{
   unsigned u;

   SectorBuf[SectorPos++] = 0;
   SectorBuf[SectorPos++] = 0;
   SectorBuf[SectorPos++] = 1;
   SectorBuf[SectorPos++] = 0xbf;  // private_stream_2

   SectorBuf[SectorPos++] = 
        sizeof(Presentation_Control_Information_Type)>>8;
   SectorBuf[SectorPos++] = 
        sizeof(Presentation_Control_Information_Type) & 0xff;

   PCI = (Presentation_Control_Information_Type*)(&SectorBuf[SectorPos]);

   for (u=0; u<sizeof(Presentation_Control_Information_Type); u++) 
                                       SectorBuf[SectorPos++] = 0x00;

   (*PCI).Sub_Stream_ID = 0;
   WriteFourByte( (*PCI).this_lba, DVD->SectorPos);
   WriteFourByte( (*PCI).VOBU_Start_PTS, 
               DVD->Seq[DVD->SeqPos].I_Frame_PTS );
   WriteFourByte( (*PCI).VOBU_End_PTS, 
               DVD->Seq[DVD->SeqPos+1].I_Frame_PTS);   
   WriteTimeBCD( (*PCI).Cell_Elapsed_Time,  
               DVD->Seq[DVD->SeqPos].Cell_Elapsed_Time );
}

void WriteDataSearchInformation()
{
   int i;
   unsigned u;

   SectorBuf[SectorPos++] = 0;
   SectorBuf[SectorPos++] = 0;
   SectorBuf[SectorPos++] = 1;
   SectorBuf[SectorPos++] = 0xbf;  // private_stream_2

   SectorBuf[SectorPos++] = sizeof(Data_Search_Information_Type)>>8;
   SectorBuf[SectorPos++] = sizeof(Data_Search_Information_Type) & 0xff;

   DSI = (Data_Search_Information_Type*)(&SectorBuf[SectorPos]);

   for (u=0; u<sizeof(Data_Search_Information_Type); u++) 
                                  SectorBuf[SectorPos++] = 0x00;

   (*DSI).Sub_Stream_ID = 1;  
   WriteFourByte( (*DSI).SCR, SCR_base);    
   WriteFourByte( (*DSI).this_lba, DVD->SectorPos);

   WriteFourByte( (*DSI).VOBU_End_Adress, 
            DVD->Seq[DVD->SeqPos+1].SectorPos -
            DVD->SectorPos - 1 ); 

   WriteTwoByte( (*DSI).VOB_ID, 1);
   (*DSI).Cell_ID = 1;
   WriteTimeBCD( (*DSI).Cell_Elapsed_Time, 
                 DVD->Seq[DVD->SeqPos].Cell_Elapsed_Time );

   WriteFourByte( (*DSI).First_I_Frame_PTS, DVD->Seq[0].I_Frame_PTS);

   WriteFourByte( (*DSI).Last_Frame_PTS, DVD->Seq[DVD->SeqNum].I_Frame_PTS -
                                                           Video->PicPTS  );
 

   // Fw_Bw_Information aus Fw_Bw_List kopieren
   for( i=0; i<42; i++ ) {
      WriteFourByte( (*DSI).Fw_Bw_Information[i],
             DVD->Seq[DVD->SeqPos].Fw_Bw[i] );
   }

   WriteFourByte( (*DSI).VOBU_First_Reference_Frame_End_Block,
     DVD->Seq[DVD->SeqPos].VOBU_First_Reference_Frame_End_Block);
                    
   WriteFourByte( (*DSI).VOBU_Second_Reference_Frame_End_Block,
    DVD->Seq[DVD->SeqPos].VOBU_Second_Reference_Frame_End_Block);

   WriteFourByte( (*DSI).VOBU_Third_Reference_Frame_End_Block,
    DVD->Seq[DVD->SeqPos].VOBU_Third_Reference_Frame_End_Block);


   for( i=0; i<AudioStreamNum; i++) {    
       WriteTwoByte( (*DSI).Offset_to_Audio_Packet_for_Audio_Stream[i],
        DVD->Seq[DVD->SeqPos].Audio_Packet_Offset[i] );                                             
    }
}


void WriteNavigationSector()
{
   WritePackHeader(0);
   WriteSystemHeader();
   WritePresentationControlInformation();
   WriteDataSearchInformation();
}

// =============================================================
// Write Video Sector
// =============================================================

void WriteFirstVideoSector()
{
   WritePackHeader(0);
   
   SectorBuf[SectorPos++] = 0;
   SectorBuf[SectorPos++] = 0;
   SectorBuf[SectorPos++] = 1;
   SectorBuf[SectorPos++] = Video->StreamID;

   SectorBuf[SectorPos++] = 0x07;   // PES_packet_length
   SectorBuf[SectorPos++] = 0xec;   // = SECTOR_LEN - 14 - (4 + 2)

   SectorBuf[SectorPos++] = 0x84; // PES_scrambling_control: 00 - not scrambled
                                 // PES_priority: 0
                                 // data_alignment_indicator: 1
                                 // copyright: 0
                                 // original_or_copy: 0

   SectorBuf[SectorPos++] = 0xc0; // PTS_DTS_Flag: 11 - PTS and DTS
                                 // ESCR_flag: 0
                                 // ES_rate_flag: 0
                                 // DSM_trick_mode_flag: 0
                                 // additional_copy_info_flag: 0
                                 // PES_CRC_flag: 0
                                 // PES_extension_flag: 0 

   SectorBuf[SectorPos++] = 10;    // PES_header_data_length

   WriteTimestamp( DVD->Seq[DVD->SeqPos].I_Frame_PTS, 0x30); 
   WriteTimestamp( DVD->Seq[DVD->SeqPos].I_Frame_DTS, 0x10 ); 

   WriteVideo( &SectorBuf[SectorPos], FIRST_VIDEO_DATA_PER_SECTOR );
   SectorPos += FIRST_VIDEO_DATA_PER_SECTOR;

}

void WriteStdVideoSector()
{
   WritePackHeader(0);
            
   SectorBuf[SectorPos++] = 0;
   SectorBuf[SectorPos++] = 0;
   SectorBuf[SectorPos++] = 1;
   SectorBuf[SectorPos++] = Video->StreamID;

   SectorBuf[SectorPos++] = 0x07;   // PES_packet_length
   SectorBuf[SectorPos++] = 0xec;   // = SECTOR_LEN - 14 - (4 + 2)

   SectorBuf[SectorPos++] = 0x80; // PES_scrambling_control: 00 - not scrambled
                                 // PES_priority: 0
                                 // data_alignment_indicator: 0
                                 // copyright: 0
                                 // original_or_copy: 0

   SectorBuf[SectorPos++] = 0x00; // PTS_DTS_Flag: 00 - no PTS or DTS
                                 // ESCR_flag: 0
                                 // ES_rate_flag: 0
                                 // DSM_trick_mode_flag: 0
                                 // additional_copy_info_flag: 0
                                 // PES_CRC_flag: 0
                                 // PES_extension_flag: 0 

   SectorBuf[SectorPos++] = 0;    // PES_header_data_length

   WriteVideo( &SectorBuf[SectorPos], STD_VIDEO_DATA_PER_SECTOR );
   SectorPos += STD_VIDEO_DATA_PER_SECTOR;
}

void WritePaddingPacket(unsigned short Length)
{
   int i;

   SectorBuf[SectorPos++] = 0;
   SectorBuf[SectorPos++] = 0;
   SectorBuf[SectorPos++] = 1;
   SectorBuf[SectorPos++] = 0xbe;

   SectorBuf[SectorPos++] = Length >> 8;
   SectorBuf[SectorPos++] = Length & 0xff;

   for (i=0; i<Length; i++) SectorBuf[SectorPos++] = 0xff;
}

void WriteLastVideoSector()
{
  // Fall1: voller Sektor
  // Fall2: fast voller Sektor (1..7 Byte leer)
  // Fall3: Standart Sektor

   int VideoLen, PaddingLen;
   VideoLen = DVD->Seq[DVD->SeqPos].LastSectorLen;
   PaddingLen = STD_VIDEO_DATA_PER_SECTOR - VideoLen;
   
   if (PaddingLen < 8) {
      WritePackHeader(PaddingLen);
   } else {
      WritePackHeader(0);
   }     

   SectorBuf[SectorPos++] = 0;
   SectorBuf[SectorPos++] = 0;
   SectorBuf[SectorPos++] = 1;
   SectorBuf[SectorPos++] = Video->StreamID;

   SectorBuf[SectorPos++] = (VideoLen+3)>>8;   // PES_packet_length
   SectorBuf[SectorPos++] = (VideoLen+3) & 0xff; 

   SectorBuf[SectorPos++] = 0x80; // PES_scrambling_control: 00 - not scrambled
                                 // PES_priority: 0
                                 // data_alignment_indicator: 0
                                 // copyright: 0
                                 // original_or_copy: 0

   SectorBuf[SectorPos++] = 0x00; // PTS_DTS_Flag: 00 - no PTS or DTS
                                 // ESCR_flag: 0
                                 // ES_rate_flag: 0
                                 // DSM_trick_mode_flag: 0
                                 // additional_copy_info_flag: 0
                                 // PES_CRC_flag: 0
                                 // PES_extension_flag: 0 

   SectorBuf[SectorPos++] = 0;    // PES_header_data_length

   WriteVideo( &SectorBuf[SectorPos], VideoLen );
   SectorPos += VideoLen;

   if (PaddingLen >= 8) WritePaddingPacket(PaddingLen-6);

}

// =============================================================
// Write Audio Sector
// =============================================================

void WriteFirstAudioSector( int Stream )
{
   WritePackHeader(0);    // 14 Byte

   SectorBuf[SectorPos++] = 0;
   SectorBuf[SectorPos++] = 0;
   SectorBuf[SectorPos++] = 1;
   SectorBuf[SectorPos++] = Audio[Stream]->StreamID;

   SectorBuf[SectorPos++] = 0x07;   // PES_packet_length
   SectorBuf[SectorPos++] = 0xec;   // = SECTOR_LEN - 14 - (4 + 2)

   SectorBuf[SectorPos++] = 0x80; // PES_scrambling_control: 00 - not scrambled
                                 // PES_priority: 0
                                 // data_alignment_indicator: 0
                                 // copyright: 0
                                 // original_or_copy: 0

   SectorBuf[SectorPos++] = 0x81; // PTS_DTS_Flag: 10 - PTS only
                                 // ESCR_flag: 0
                                 // ES_rate_flag: 0
                                 // DSM_trick_mode_flag: 0
                                 // additional_copy_info_flag: 0
                                 // PES_CRC_flag: 0
                                 // PES_extension_flag: 1 

   SectorBuf[SectorPos++] = 8;    // PES_header_data_length



   WriteTimestamp(DVD->Audio[Stream].CurPTS, 0x80);

   SectorBuf[SectorPos++] = 0x1e;  // PES_private_data_flag: 0
                                  // pack_header_field_flag: 0
                                  // program_packet_sequnce_counter_flag: 0
                                  // P-STD_buffer_flag: 1
                                  // 3 reserved
                                  // PES_extension_flag_2: 0

   SectorBuf[SectorPos++] = 0x60;  // P-STD_buffer_size_bound =
   SectorBuf[SectorPos++] = 0x3a;  //                 58*1024 Byte
   // bis hierher 31 Byte

   WriteAudio(Stream, &SectorBuf[SectorPos], FIRST_AUDIO_DATA_PER_SECTOR );

   SectorPos += FIRST_AUDIO_DATA_PER_SECTOR; 
}


void WriteStdAudioSector( int Stream )
{
   WritePackHeader(0);   // 14 Byte

   SectorBuf[SectorPos++] = 0;
   SectorBuf[SectorPos++] = 0;
   SectorBuf[SectorPos++] = 1;
   SectorBuf[SectorPos++] = Audio[Stream]->StreamID;

   SectorBuf[SectorPos++] = 0x07;   // PES_packet_length
   SectorBuf[SectorPos++] = 0xec;   // = SECTOR_LEN - 14 - (4 + 2)

   SectorBuf[SectorPos++] = 0x80; // PES_scrambling_control: 00 - not scrambled
                                 // PES_priority: 0
                                 // data_alignment_indicator: 0
                                 // copyright: 0
                                 // original_or_copy: 0

   SectorBuf[SectorPos++] = 0x80; // PTS_DTS_Flag: 10 - PTS only
                                 // ESCR_flag: 0
                                 // ES_rate_flag: 0
                                 // DSM_trick_mode_flag: 0
                                 // additional_copy_info_flag: 0
                                 // PES_CRC_flag: 0
                                 // PES_extension_flag: 0 

   SectorBuf[SectorPos++] = 5;    // PES_header_data_length

   WriteTimestamp(DVD->Audio[Stream].CurPTS, 0x80);
   // bis hierher 28 Byte

   WriteAudio(Stream, &SectorBuf[SectorPos], STD_AUDIO_DATA_PER_SECTOR );

   SectorPos += STD_AUDIO_DATA_PER_SECTOR; 
}


void WriteLastAudioSector(int Stream)
{
  // Fall1: voller Sektor
  // Fall2: fast voller Sektor (1..7 Byte leer)
  // Fall3: Standart Sektor

   int LastLen;
   LastLen = DVD->Audio[Stream].LastLen;

   int PaddingLen;
   PaddingLen = STD_AUDIO_DATA_PER_SECTOR - LastLen;
   
   if (PaddingLen < 8) {
      WritePackHeader(PaddingLen);
   } else {
      WritePackHeader(0);
   }     

   SectorBuf[SectorPos++] = 0;
   SectorBuf[SectorPos++] = 0;
   SectorBuf[SectorPos++] = 1;
   SectorBuf[SectorPos++] = Audio[Stream]->StreamID;

   SectorBuf[SectorPos++] = (LastLen+11)>>8;   // PES_packet_length
   SectorBuf[SectorPos++] = (LastLen+11) & 0xff; 

   SectorBuf[SectorPos++] = 0x80; // PES_scrambling_control: 00 - not scrambled
                                 // PES_priority: 0
                                 // data_alignment_indicator: 0
                                 // copyright: 0
                                 // original_or_copy: 0

   SectorBuf[SectorPos++] = 0x80; // PTS_DTS_Flag: 10 - PTS only
                                 // ESCR_flag: 0
                                 // ES_rate_flag: 0
                                 // DSM_trick_mode_flag: 0
                                 // additional_copy_info_flag: 0
                                 // PES_CRC_flag: 0
                                 // PES_extension_flag: 0 

   SectorBuf[SectorPos++] = 5;    // PES_header_data_length

   WriteTimestamp(DVD->Audio[Stream].CurPTS, 0x80);

   WriteAudio(Stream, &SectorBuf[SectorPos], LastLen );
                     
   SectorPos += LastLen;   

   if (PaddingLen >= 8) WritePaddingPacket(PaddingLen-6);
}

// =============================================================
// Write Dolby Sector
// =============================================================

void WriteFirstDolbySector( int Stream )
{
   WritePackHeader(0);// 14 Byte

   SectorBuf[SectorPos++] = 0;
   SectorBuf[SectorPos++] = 0;
   SectorBuf[SectorPos++] = 1;
   SectorBuf[SectorPos++] = Audio[Stream]->StreamID;

   SectorBuf[SectorPos++] = 0x07;   // PES_packet_length
   SectorBuf[SectorPos++] = 0xec;   // = SECTOR_LEN - 14 - (4 + 2)

   SectorBuf[SectorPos++] = 0x80; // PES_scrambling_control: 00 - not scrambled
                                 // PES_priority: 0
                                 // data_alignment_indicator: 0
                                 // copyright: 0
                                 // original_or_copy: 0

   SectorBuf[SectorPos++] = 0x81; // PTS_DTS_Flag: 10 - PTS only
                                 // ESCR_flag: 0
                                 // ES_rate_flag: 0
                                 // DSM_trick_mode_flag: 0
                                 // additional_copy_info_flag: 0
                                 // PES_CRC_flag: 0
                                 // PES_extension_flag: 1 

   SectorBuf[SectorPos++] = 8;    // PES_header_data_length



   WriteTimestamp(DVD->Audio[Stream].CurPTS, 0x80);

   SectorBuf[SectorPos++] = 0x1e;  // PES_private_data_flag: 0
                                  // pack_header_field_flag: 0
                                  // program_packet_sequnce_counter_flag: 0
                                  // P-STD_buffer_flag: 1
                                  // 3 reserved
                                  // PES_extension_flag_2: 0

   SectorBuf[SectorPos++] = 0x60;  // P-STD_buffer_size_bound =
   SectorBuf[SectorPos++] = 0x3a;  //                 58*1024 Byte

   // diese Daten sind DVD-spezifisch 
   SectorBuf[SectorPos++] = 0x80 | Stream;  
   SectorBuf[SectorPos++] = 2;     // Frame Headers (-> 0b 77)
   SectorBuf[SectorPos++] = 
           DVD->Audio[Stream].Sector[ DVD->Audio[Stream].SectorPos ].
                                             First_Ref_Frame_Offset >> 8;
   SectorBuf[SectorPos++] = 
           DVD->Audio[Stream].Sector[ DVD->Audio[Stream].SectorPos ].
                                           First_Ref_Frame_Offset & 0xff;
   // bis hierher 35 Byte

   WriteAudio(Stream, &SectorBuf[SectorPos], FIRST_DOLBY_DATA_PER_SECTOR );

   SectorPos += FIRST_DOLBY_DATA_PER_SECTOR; 
}


void WriteStdDolbySector( int Stream )
{
   WritePackHeader(0);  // 14 Byte

   SectorBuf[SectorPos++] = 0;
   SectorBuf[SectorPos++] = 0;
   SectorBuf[SectorPos++] = 1;
   SectorBuf[SectorPos++] = Audio[Stream]->StreamID;

   SectorBuf[SectorPos++] = 0x07;   // PES_packet_length
   SectorBuf[SectorPos++] = 0xec;   // = SECTOR_LEN - 14 - (4 + 2)

   SectorBuf[SectorPos++] = 0x80; // PES_scrambling_control: 00 - not scrambled
                                 // PES_priority: 0
                                 // data_alignment_indicator: 0
                                 // copyright: 0
                                 // original_or_copy: 0

   SectorBuf[SectorPos++] = 0x80; // PTS_DTS_Flag: 10 - PTS only
                                 // ESCR_flag: 0
                                 // ES_rate_flag: 0
                                 // DSM_trick_mode_flag: 0
                                 // additional_copy_info_flag: 0
                                 // PES_CRC_flag: 0
                                 // PES_extension_flag: 0 

   SectorBuf[SectorPos++] = 5;    // PES_header_data_length



   WriteTimestamp(DVD->Audio[Stream].CurPTS, 0x80);

   // diese Daten sind DVD-spezifisch 
   SectorBuf[SectorPos++] = 0x80 | Stream; 
   SectorBuf[SectorPos++] = 2;     // Frame Headers (-> 0b 77)
   SectorBuf[SectorPos++] = 
           DVD->Audio[Stream].Sector[ DVD->Audio[Stream].SectorPos ].
                                             First_Ref_Frame_Offset >> 8;
   SectorBuf[SectorPos++] = 
           DVD->Audio[Stream].Sector[ DVD->Audio[Stream].SectorPos ].
                                           First_Ref_Frame_Offset & 0xff;
   // bis hierher 32 Byte

   WriteAudio(Stream, &SectorBuf[SectorPos], STD_DOLBY_DATA_PER_SECTOR );

   SectorPos += STD_DOLBY_DATA_PER_SECTOR; 
}


void WriteLastDolbySector(int Stream)
{
  // Fall1: voller Sektor
  // Fall2: fast voller Sektor (1..7 Byte leer)
  // Fall3: Standart Sektor

   int LastLen;
   LastLen = DVD->Audio[Stream].LastLen;

   int PaddingLen;
   PaddingLen = STD_DOLBY_DATA_PER_SECTOR - LastLen;
   
   if (PaddingLen < 8) {
      WritePackHeader(PaddingLen);
   } else {
      WritePackHeader(0);
   }     

   SectorBuf[SectorPos++] = 0;
   SectorBuf[SectorPos++] = 0;
   SectorBuf[SectorPos++] = 1;
   SectorBuf[SectorPos++] = Audio[Stream]->StreamID;

   SectorBuf[SectorPos++] = (LastLen+11)>>8;   // PES_packet_length
   SectorBuf[SectorPos++] = (LastLen+11) & 0xff; 

   SectorBuf[SectorPos++] = 0x80; // PES_scrambling_control: 00 - not scrambled
                                 // PES_priority: 0
                                 // data_alignment_indicator: 0
                                 // copyright: 0
                                 // original_or_copy: 0

   SectorBuf[SectorPos++] = 0x80; // PTS_DTS_Flag: 10 - PTS only
                                 // ESCR_flag: 0
                                 // ES_rate_flag: 0
                                 // DSM_trick_mode_flag: 0
                                 // additional_copy_info_flag: 0
                                 // PES_CRC_flag: 0
                                 // PES_extension_flag: 0 

   SectorBuf[SectorPos++] = 5;    // PES_header_data_length

   WriteTimestamp(DVD->Audio[Stream].CurPTS, 0x80);

   // diese Daten sind DVD-spezifisch 
   SectorBuf[SectorPos++] = 0x80 | Stream; 
   SectorBuf[SectorPos++] = 2;     // Frame Headers (-> 0b 77)

   SectorBuf[SectorPos++] = 
    DVD->Audio[Stream].Sector[ DVD->Audio[Stream].SectorPos ].
                                            First_Ref_Frame_Offset >> 8;
   SectorBuf[SectorPos++] = 
    DVD->Audio[Stream].Sector[ DVD->Audio[Stream].SectorPos ].
                                            First_Ref_Frame_Offset & 0xff;

   WriteAudio(Stream, &SectorBuf[SectorPos], LastLen );
                     
   SectorPos += LastLen;   

   if (PaddingLen >= 8) WritePaddingPacket(PaddingLen-6);
}


// =============================================================
int VobMux()
{


   int vob_fd;
   int i, Stream;
   unsigned char MuxCode;
   char string[STRING_SIZE];


   vob_fd = open(VobFileName[DVDCount][DVD->VobCount],
                    O_WRONLY|O_CREAT|O_TRUNC|O_LARGEFILE, 
                    S_IRUSR | S_IRGRP | S_IROTH | S_IWUSR | S_IWGRP | S_IWOTH );
 
   if (vob_fd == -1) {
      sprintf( string, "VobMux() - open VOB %i, DVD %i\n",
                         DVD->VobCount, DVDCount );
      PrintLog( string );
      exit(-1); 
   }


   for ( i=0; i< DVD->VobSectorNum; i++) {
      MuxCode = DVD->Mux[DVD->SectorPos] & 0xf0;
      Stream = DVD->Mux[DVD->SectorPos] & 0x0f;
      
      switch (MuxCode ) {
         case NAVIGATION_SECTOR:
            DVD->SeqPos++;
            SCR_base = DVD->Seq[DVD->SeqPos].I_Frame_PTS - 6 * Video->PicPTS;
            SCR_extension = 0;
            VideoDecodingBufInPos = 0;
            VideoDecodingBufOutPos = 0;

            WriteNavigationSector();
           
            break;
  
         case FIRST_VIDEO_SECTOR:
            WriteFirstVideoSector();
            WriteVideoDecodingBuf( Video_DTS_FirstByte );
            Video_DTS_FirstByte += DVD->Video[DVD->VideoSectorPos].
                                  DeltaPic_FirstByte * Video->PicPTS; 
            DVD->VideoSectorPos++;
            break;

         case STD_VIDEO_SECTOR:
            WriteStdVideoSector();
            WriteVideoDecodingBuf( Video_DTS_FirstByte );
            Video_DTS_FirstByte += DVD->Video[DVD->VideoSectorPos].
                                  DeltaPic_FirstByte * Video->PicPTS; 
            DVD->VideoSectorPos++;
            break;
   
         case LAST_VIDEO_SECTOR:
            WriteLastVideoSector();
            WriteVideoDecodingBuf( Video_DTS_FirstByte );
            Video_DTS_FirstByte += DVD->Video[DVD->VideoSectorPos].
                                  DeltaPic_FirstByte * Video->PicPTS; 
            DVD->VideoSectorPos++;
            break;
  
         case FIRST_AUDIO_SECTOR:
            WriteFirstAudioSector( Stream );
            DVD->Audio[Stream].CurPTS += 
               DVD->Audio[Stream].Sector[DVD->Audio[Stream].SectorPos++].
                  DeltaFrame * Audio[Stream]->FramePTS;
            break;   
 
       case STD_AUDIO_SECTOR:
            WriteStdAudioSector( Stream );
            DVD->Audio[Stream].CurPTS += 
               DVD->Audio[Stream].Sector[DVD->Audio[Stream].SectorPos++].
                  DeltaFrame * Audio[Stream]->FramePTS;
            break;   
 
         case LAST_AUDIO_SECTOR:
            WriteLastAudioSector(Stream);
            DVD->Audio[Stream].CurPTS += 
               DVD->Audio[Stream].Sector[DVD->Audio[Stream].SectorPos++].
                    DeltaFrame * Audio[Stream]->FramePTS;
            break;  

         case FIRST_DOLBY_SECTOR:
            WriteFirstDolbySector( Stream );
            DVD->Audio[Stream].CurPTS += 
               DVD->Audio[Stream].Sector[DVD->Audio[Stream].SectorPos++].
                  DeltaFrame * Audio[Stream]->FramePTS;
            break;   
 
       case STD_DOLBY_SECTOR:
            WriteStdDolbySector( Stream );
            DVD->Audio[Stream].CurPTS += 
               DVD->Audio[Stream].Sector[DVD->Audio[Stream].SectorPos++].
                  DeltaFrame * Audio[Stream]->FramePTS;
            break;   
 
         case LAST_DOLBY_SECTOR:
            WriteLastDolbySector(Stream);
            DVD->Audio[Stream].CurPTS += 
               DVD->Audio[Stream].Sector[DVD->Audio[Stream].SectorPos++].
                    DeltaFrame * Audio[Stream]->FramePTS;
            break;  

         default:
            PrintLog( "VobMux() - unknown mux code\n");
            exit(-1);
      }
      
      if (SectorPos != SECTOR_LEN ) {
         PrintLog( "VobMux() - SectorPos error\n");
         exit(-1);
      }

      if (SECTOR_LEN != write( vob_fd, SectorBuf, SECTOR_LEN) ) {
         sprintf( string, "VobMux() - write Sector %i, DVD %i\n",
                                          DVD->SectorPos, DVDCount);
         PrintLog( string );
         exit(-1);
      }   

      // SCR Berechnung; 
      NextSCR();
      ReadDecodingBuf();
      if ( VideoDecodingBufSize_CheckMax() > 
                            VIDEO_DECODING_BUF_MAX_TRESHOLD) {
         while ( VideoDecodingBufSize_CheckMin() > 
                                  VIDEO_DECODING_BUF_MIN_TRESHOLD) {
            NextSCR();
            ReadDecodingBuf();
         }
      }

      DVD->SectorPos++;
      if (DVD->SectorPos == DVD->SectorNum ) {
         close (vob_fd);
         return 0;
      }
   }

   close (vob_fd);
   return 1;
}

void OpenStreamFiles()
{
   char string[STRING_SIZE];   

   Video->fd = open(Video->FileName, O_RDONLY| O_LARGEFILE);
   if (Video->fd == -1) {
      PrintLog( "OpenStreamFiles() - open video\n");
      exit(-1);
   }
   Video->PicPos = -1;
   Video->BufPos = VIDEO_BUF_SIZE;
   Video->BufLen = 0;
   Video->BufSize = VIDEO_BUF_SIZE;

   for(int i=0; i<AudioStreamNum; i++) { 
      Audio[i]->fd = open(Audio[i]->FileName, O_RDONLY| O_LARGEFILE);
      if (Audio[i]->fd == -1) {
         sprintf(string, "OpenStreamFiles() - open audio %i\n", i);
         PrintLog( string );
         exit (-1);
      }
      Audio[i]->FrameBytePos = 0;
      Audio[i]->PacketPos = 0;
      Audio[i]->FramePos = -1;
      Audio[i]->FramePosV = 0;
      Audio[i]->BufPos = AUDIO_BUF_SIZE; 
      Audio[i]->BufLen = 0;
      Audio[i]->BufSize = AUDIO_BUF_SIZE;
   }
}

// ================================================================
void RealMux()
{
   int i;


   for (i=0; i< AudioStreamNum; i++) {
          DVD->Audio[i].SectorPos = 0;
          DVD->Audio[i].CurPTS = 4*Video->PicPTS; //DVD->Audio[i].FirstPTS;
   }

   Video_DTS_FirstByte = 3*Video->PicPTS;  // s. SortSectors()
   DVD->VobCount = 0;
   DVD->SectorPos = 0;
   DVD->VideoSectorPos = 0;
   DVD->SeqPos = -1;
   while ( VobMux() ) DVD->VobCount++;
}

// =================================================================
void UpdateDSI()
{
   const int Fw_Bw_DeltaPTS[42] =  {
                   0,
           120*90000,
            60*90000,
            30*90000,
            10*90000,
            15*45000,
            14*45000,
            13*45000,
            12*45000,
            11*45000,
            10*45000,
             9*45000,
             8*45000,
             7*45000,
             6*45000,
             5*45000,
             4*45000,
             3*45000,
             2*45000,
             1*45000,
                   0,
                   0,
             1*45000,
             2*45000,
             3*45000,
             4*45000,
             5*45000,
             6*45000,
             7*45000,
             8*45000,
             9*45000,
            10*45000,
            11*45000,
            12*45000,
            13*45000,
            14*45000,
            15*45000,
            10*90000,
            30*90000,
            60*90000,
           120*90000,
                   0
   };

   typedef int Fw_Bw_SeqDelta_Type[SEQ_PER_DVD][42];
   Fw_Bw_SeqDelta_Type * Fw_Bw_SeqDelta;
   Fw_Bw_SeqDelta = (Fw_Bw_SeqDelta_Type*)malloc(sizeof(Fw_Bw_SeqDelta_Type));


   TimeStampType DeltaPTS, LastDeltaPTS, CellElapsedPTS, 
                 TMAP_PTS, NominalPTS; 
   char string[STRING_SIZE];
   int i, j, k;

   // ==============================================================
   // Cell Elapsed Time
   // ==============================================================
   // Bei einer normgerechten DVD ist jede GOP/Sequenz gleich lang 
   // (z.B. 15 Bilder). Die "Time unit" in der VTS_TMAPTI betraegt dann
   // 6 Sek. -> 6 Sek. x 25 fps = 10 * 15 Bilder = 150 Bilder. Bei Digital-TV
   // variiert die Bildanzahl (12-18 Bilder). Damit die Zeiger in der
   // VTS_TMAPTI immer auf eine Sequenz mit der EXAKT passenden Zeit verweisen,
   // werden die Zeiten gerundet. 

   Seq_fd = open( DVD->SeqFileName, 
          O_CREAT|O_WRONLY, 
          S_IRGRP|S_IRUSR|S_IROTH|S_IWGRP|S_IWUSR|S_IWOTH );
   if (Log_fd == -1) {
      PrintLog("UpdateDSI() - ERROR open seq");
      exit(-1);
   }
   
   DVD->Seq[0].Cell_Elapsed_Time = 0;
   PrintSeqTable( 0, 0 );
   TMAP_PTS = 90000 * TMAP_TIME_UNIT;
   LastDeltaPTS = TMAP_PTS;
   for( i=1; i<DVD->SeqNum; i++) {
      CellElapsedPTS = DVD->Seq[i].I_Frame_PTS - DVD->Seq[0].I_Frame_PTS;
      PrintSeqTable( i, CellElapsedPTS );
      DeltaPTS = long_abs( TMAP_PTS - CellElapsedPTS);
      if (DeltaPTS > LastDeltaPTS) {
         if( !OneVobMode )  
            DVD->Seq[i-1].Cell_Elapsed_Time = TMAP_PTS;
         DVD->Seq[i-1].VTS_TMAP_Entry = 1;
         TMAP_PTS += 90000 * TMAP_TIME_UNIT;
         DeltaPTS = long_abs(TMAP_PTS - CellElapsedPTS);
      }
      LastDeltaPTS = DeltaPTS;
      DVD->Seq[i].VTS_TMAP_Entry = 0;
      DVD->Seq[i].Cell_Elapsed_Time = CellElapsedPTS;
   }
   close(Seq_fd);


   // ==============================================================
   // EndSector Reference Frame
   // ==============================================================
   j = 0;
   sprintf( string, "DVDSectorNum %i\n", DVD->SectorNum );
   PrintLog( string );

   for (i=0; i<DVD->SeqNum; i++) {
      // I-Frame suchen
      while ( DVD->Mux[j] != ( FIRST_VIDEO_SECTOR | I_FRAME ) ) j++;
      
      if ( j != DVD->Seq[i].SectorPos + 1 ) {  // +1 wg. NavPack
         PrintLog( "UpdateDSI() - I frame expected\n");
         exit(-1);
      }
      j++;  // wg. First -> StdVideoSector
      // massgeblich fuer den Picture_Coding_Type ist das erste
      // Byte eines Sectors.
      while ( DVD->Mux[j]  == ( STD_VIDEO_SECTOR | I_FRAME ) ) j++;
      DVD->Seq[i].VOBU_First_Reference_Frame_End_Block = 
                                     j - 1 - DVD->Seq[i].SectorPos;

      while ( DVD->Mux[j]  != ( STD_VIDEO_SECTOR | P_FRAME ) ) j++;
      while ( DVD->Mux[j]  == ( STD_VIDEO_SECTOR | P_FRAME ) ) j++;
      if (j>= DVD->Seq[i+1].SectorPos ) {
         j = DVD->Seq[i+1].SectorPos;
         DVD->Seq[i].VOBU_Second_Reference_Frame_End_Block = 0; 
         DVD->Seq[i].VOBU_Third_Reference_Frame_End_Block = 0;
         PrintLog( "UpdateDSI() - no P-frame\n");
         continue;
       } 


      DVD->Seq[i].VOBU_Second_Reference_Frame_End_Block = 
                                     j - 1 - DVD->Seq[i].SectorPos;

      while ( DVD->Mux[j]  != ( STD_VIDEO_SECTOR | P_FRAME ) ) j++;
      while ( DVD->Mux[j]  == ( STD_VIDEO_SECTOR | P_FRAME ) ) j++;
      if (j>= DVD->Seq[i+1].SectorPos ) {
         j = DVD->Seq[i+1].SectorPos;
         DVD->Seq[i].VOBU_Third_Reference_Frame_End_Block = 0;
         PrintLog( "UpdateDSI() - no P-frame\n");
         continue;
      } 
      DVD->Seq[i].VOBU_Third_Reference_Frame_End_Block = 
                                     j - 1 - DVD->Seq[i].SectorPos;

   }

   // ==============================================================
   // Forward - Backward Information
   // ==============================================================
   #define BIT31 0x80000000
   #define BIT30 0x40000000

   // naechste Sequenz
   for (i=0; i< DVD->SeqNum-1; i++ ) {  
      DVD->Seq[i].Fw_Bw[0] = (DVD->Seq[i+1].SectorPos -
                            DVD->Seq[i].SectorPos ) | BIT31;
      DVD->Seq[i].Fw_Bw[20] = DVD->Seq[i].Fw_Bw[0];
      (*Fw_Bw_SeqDelta)[i][20] = 0;
   }
   DVD->Seq[DVD->SeqNum-1].Fw_Bw[0]  = 0xbfffffff;
   DVD->Seq[DVD->SeqNum-1].Fw_Bw[20] = 0x3fffffff;
   (*Fw_Bw_SeqDelta)[DVD->SeqNum-1][20] = 0;

   // vorherige Sequenz  
   (*Fw_Bw_SeqDelta)[0][21] = 0;
   DVD->Seq[0].Fw_Bw[21] = 0x3fffffff;
   DVD->Seq[0].Fw_Bw[41] = 0xbfffffff;
   for (i=1; i< DVD->SeqNum; i++ ) {
      (*Fw_Bw_SeqDelta)[i][21] = 0;  
      DVD->Seq[i].Fw_Bw[21] = (DVD->Seq[i].SectorPos -
                              DVD->Seq[i-1].SectorPos ) | BIT31;
      DVD->Seq[i].Fw_Bw[41] = DVD->Seq[i].Fw_Bw[21];
   }

   int NoSeqFound;

   // Vorwaerts PTS
   for( k=1; k<20; k++) {
      for( i=0; i< DVD->SeqNum-1; i++) {
         NominalPTS = DVD->Seq[i].I_Frame_PTS  + Fw_Bw_DeltaPTS[k];
         LastDeltaPTS = abs(NominalPTS - DVD->Seq[i+1].I_Frame_PTS); 
         NoSeqFound = 1;
         for( j=i+1; j<DVD->SeqNum-1; j++ ) {
            DeltaPTS = abs (NominalPTS - DVD->Seq[j+1].I_Frame_PTS);
            if( DeltaPTS > LastDeltaPTS ) {
               NoSeqFound = 0;
               DVD->Seq[i].Fw_Bw[k] = (DVD->Seq[j].SectorPos -
                                      DVD->Seq[i].SectorPos ) | BIT31;
               (*Fw_Bw_SeqDelta)[i][k] = j - i;
           
               break;
            } else {
              LastDeltaPTS = DeltaPTS;
            }
         }  // j
         if( NoSeqFound ) {
            for ( j=i; j< DVD->SeqNum; j++ ) {
               DVD->Seq[j].Fw_Bw[k] = 0x3fffffff;
               (*Fw_Bw_SeqDelta)[j][k] = 0;
            }
            break;
         }
      }  // i
   } // k        


   // Rueckwaerts PTS
   for( k=22; k<41; k++) {
      for( i=DVD->SeqNum-1; i>0; i--) {
         NominalPTS = DVD->Seq[i].I_Frame_PTS  - Fw_Bw_DeltaPTS[k];
         LastDeltaPTS = abs(NominalPTS - DVD->Seq[i-1].I_Frame_PTS);  
         NoSeqFound = 1;
         for( j=i-1; j>0; j-- ) {
            DeltaPTS = abs (NominalPTS - DVD->Seq[j-1].I_Frame_PTS);
            if( DeltaPTS > LastDeltaPTS ) {
               NoSeqFound = 0;
               DVD->Seq[i].Fw_Bw[k] = (DVD->Seq[i].SectorPos -
                                      DVD->Seq[j].SectorPos ) | BIT31;
               (*Fw_Bw_SeqDelta)[i][k] = i - j;
               break;
            } else {
               LastDeltaPTS = DeltaPTS;
            }
         }  // j
         if( NoSeqFound ) {
            for ( j=i; j>=0; j-- ) {
               DVD->Seq[j].Fw_Bw[k] = 0x3fffffff;
               (*Fw_Bw_SeqDelta)[j][k] = 0;
            }
            break;
         }
      }  // i
   } // k        

   // BIT30 setzen, falls sich eine Luecke zwischen zwei 
   // Referenz-Sequenzen befindet

   for (k=1; k<20; k++) {
      for( i=0; i< DVD->SeqNum; i++ ) {
         if ( (*Fw_Bw_SeqDelta)[i][k] && 
              (((*Fw_Bw_SeqDelta)[i][k] - (*Fw_Bw_SeqDelta)[i][k+1]) > 1) ) {
              // == 0 ist moegliche wg. 18 Frames/Seq > 0,5 Sek
             DVD->Seq[i].Fw_Bw[k] = DVD->Seq[i].Fw_Bw[k] | BIT30;
         }
      }
   }

   for (k=22; k<41; k++) {
      for( i=0; i< DVD->SeqNum; i++ ) {
         if ( (*Fw_Bw_SeqDelta)[i][k] && 
              (((*Fw_Bw_SeqDelta)[i][k] - (*Fw_Bw_SeqDelta)[i][k-1]) > 1) ) {
              // == 0 ist moegliche wg. 18 Frames/Seq > 0,5 Sek
            DVD->Seq[i].Fw_Bw[k] = DVD->Seq[i].Fw_Bw[k] | BIT30;
         }
      }
   }
   free(Fw_Bw_SeqDelta);
}

// =================================================================
// ParseVideo()
// =================================================================

void ReadVideoBuf()
// bei Stream-Ende VideoBuf[] mit Sequence_Error_Code auffuellen
// Video->BufSize
{
   int len;
   int i,j;
   const unsigned char Sequence_Error_Code[4] = { 0x00, 0x00, 0x01, 0xb4 };

   if ( Video->BufPos > VIDEO_BUF_SIZE/2 ) {

      memcpy( VideoBuf, &VideoBuf[Video->BufPos], 
                                        Video->BufSize - Video->BufPos);

      len = read(Video->fd, 
            &VideoBuf[Video->BufSize - Video->BufPos], Video->BufPos);
      if (len == -1) {
         PrintLog( "ReadVideoBuf() - read");
         exit(-1);
      }

      Video->BufSize = Video->BufSize - Video->BufPos + len;
      Video->CutPos -= Video->BufPos;
      Video->BufPos = 0;

      j=0;
      for( i=Video->BufSize; i<VIDEO_BUF_SIZE; i++) {
         VideoBuf[i] = Sequence_Error_Code[j];
         j++;
         if (j == 4) j=0; 
      }
   }
}

TimeStampType VideoPESPacketHeader()
{
   unsigned char PES_header_data_length;
   TimeStampType PTS; 
   
   Video->BufPos += 4; 
   PES_header_data_length = VideoBuf[Video->BufPos++];
          
   PTS =       ((VideoBuf[Video->BufPos++] & 0x0ellu)<<29);   // 29=30-1
   PTS = PTS |  (VideoBuf[Video->BufPos++]<<22);              // 22=30-8
   PTS = PTS | ((VideoBuf[Video->BufPos++] & 0xfellu)<<14);   // 14=15-1
   PTS = PTS |  (VideoBuf[Video->BufPos++]<<7);               // 7=15-8
   PTS = PTS | ((VideoBuf[Video->BufPos++] & 0xfellu)>>1);
      
   Video->BufPos += PES_header_data_length-5;

   if ( (Video->SeqPos > 0) &&
        ((PTS + 3600 * 90000) < Video->Seq[0].StartPTS) ) PTS += 0x200000000llu;

   return PTS;
}

unsigned char DoVideoSync()
{    
   while ( !(VideoBuf[Video->BufPos] == 0 &&
             VideoBuf[Video->BufPos+1] == 0 &&
             VideoBuf[Video->BufPos+2] == 1 )) Video->BufPos++;
   
   Video->BufPos += 4;         
   return VideoBuf[Video->BufPos-1];
}

int GetVideoType()
{
   unsigned TypeCode; 
   int i;

   TypeCode = VideoBuf[Video->BufPos++];
   TypeCode = (TypeCode<<8) | VideoBuf[Video->BufPos++];
   TypeCode = (TypeCode<<8) | VideoBuf[Video->BufPos++];
   TypeCode = (TypeCode<<8) | VideoBuf[Video->BufPos++];
   
   for (i=0; i<VIDEO_TYPE_NUM; i++) {
      if( TypeCode == VideoTypeList[i].DVB ) {
         Video->TypeSeqNum[i]++;
         Video->Seq[Video->SeqPos].VideoType = i;
         return 0;
      }
   }
   return -1;
}

void ParseVideo()
// Video->Seq[].PicNum
//            .StartPTS
// Video->Pic[].Skip
//            .Write
//            .Picture_Coding_Type
// Video->SeqNum
// Video->PicNum
// Video->StreamID
// Video->PicPTS
// Video->TypeSeqNum[]
// Video->Type

{
   unsigned char StreamID; 
   int DoResync;
   TimeStampType CurPTS, EndPTS;
   int i, Num;
   char string[STRING_SIZE];

   // Sequenzen mit fps != 25 werden mit DontWrite gekennzeichnet
   Video->PicPTS = 90000 / FRAMES_PER_SECOND;  // = 3600 

   for( i=0; i<VIDEO_TYPE_NUM; i++) Video->TypeSeqNum[i] = 0;

   Video->fd = open(Video->FileName, O_RDONLY| O_LARGEFILE);
   if (Video->fd == -1) {
       // PrintLog( "ParseVideo() - open\n"); 
       exit (-1);
   }

   Video->BufPos = VIDEO_BUF_SIZE;
   Video->BufSize = VIDEO_BUF_SIZE;
   ReadVideoBuf();
 
   Video->CutPos = 0;
   Video->SeqPos = 0;
   Video->PicPos = 0;
   Video->SeqCutPos = 0;
   Video->SeqPicPos = 0;

   DoResync = 1; // true
   do { 
      StreamID = DoVideoSync();
      if (Video->BufPos >= (Video->BufSize-1000) ) {
         PrintLog("ParseVideo() - can't sync to 00 00 01 ex\n");
         exit(-1);
      }
   } while ( (StreamID & 0xf0) != 0xe0 );
   Video->StreamID = StreamID;    // Premiere 0xe0; ARD 0xe7
   
   while(true)  { 

      if ( (StreamID == 0xb4)  &&     // Sequence_Error_Code -> DoVideoSync()
           (Video->BufPos >= Video->BufSize) )  break;

      if (DoResync) {
         
         if ( StreamID == Video->StreamID ) {   // PES-Packet
            CurPTS = VideoPESPacketHeader();     
            if (  VideoBuf[Video->BufPos] == 0 &&
                  VideoBuf[Video->BufPos+1] == 0 &&
                  VideoBuf[Video->BufPos+2] == 1 && 
                  VideoBuf[Video->BufPos+3] == 0xb3 ) { // Sequence_Start_Code
               Video->BufPos += 4;
               if ( !GetVideoType() ) {  
                  DoResync = 0;
                  Video->Pic[Video->PicPos].Skip = Video->BufPos-8 - Video->CutPos;
                  Video->CutPos = Video->BufPos-8;
               }
               ReadVideoBuf();
            }
         }
         StreamID = DoVideoSync();
      } else {
         if (StreamID == 0x00 ) {   // picture_start_code
            int temporal_reference; 
            temporal_reference = VideoBuf[Video->BufPos++]<<2; 
            temporal_reference = temporal_reference | 
                                 ((VideoBuf[Video->BufPos]&0xc0)>>6);

            Video->Pic[Video->PicPos].Picture_Coding_Type = 
                                  (VideoBuf[Video->BufPos++]&0x38)>>3;

            if ( Video->Pic[Video->PicPos].Picture_Coding_Type == I_FRAME ) {
               Video->Seq[Video->SeqPos].StartPTS = 
                               CurPTS - temporal_reference * Video->PicPTS; 
            } else {
               if ( abs ( Video->Seq[Video->SeqPos].StartPTS +
                          temporal_reference * Video->PicPTS - CurPTS ) >
                                                        PTS_TOLERANCE ) {
                  DoResync = 1;
                  Video->CutPos = Video->SeqCutPos;
                  Video->PicPos = Video->SeqPicPos;
                  sprintf( string, "%llx: ParseVideo() - dropping sequence 1\n",
                                                         CurPTS ); 
                  PrintLog( string );
               }
            }
            StreamID = DoVideoSync();
         } else if ( StreamID == Video->StreamID ) { // PES-Packer -> Bildende

            Video->Pic[Video->PicPos].Write = Video->BufPos - 4 - Video->CutPos;
            Video->CutPos = Video->BufPos - 4;
            Video->PicPos++;
            CurPTS = VideoPESPacketHeader();
                
            Video->Pic[Video->PicPos].Skip = Video->BufPos - Video->CutPos;
            Video->CutPos = Video->BufPos;
         
            StreamID = VideoBuf[Video->BufPos+3];
            if ( !(VideoBuf[Video->BufPos] == 0 &&
                VideoBuf[Video->BufPos+1] == 0 &&
                VideoBuf[Video->BufPos+2] == 1 && 
                (StreamID == 0x00 || StreamID == 0xb3)) ) {
               DoResync = 1; // true
               Video->CutPos = Video->SeqCutPos;
               Video->PicPos = Video->SeqPicPos;
               StreamID = DoVideoSync();
               sprintf( string, "%llx: ParseVideo() - dropping sequence 2\n",
                                                                   CurPTS );
               PrintLog ( string ); 
            } else {
               Video->BufPos += 4;
            }
 
         } else if (StreamID == 0xb3 ) {  // sequence_header_code

            Video->Seq[Video->SeqPos].PicNum = Video->PicPos - Video->SeqPicPos;
            Video->SeqPicPos = Video->PicPos;
            Video->SeqCutPos = Video->CutPos;
            Video->SeqPos++;
            if (GetVideoType() ) {
               DoResync = 1;
               sprintf ( string, "%llx: ParseVideo() - dropping sequence 3\n", 
                                                                      CurPTS);
               PrintLog( string );
            }
            StreamID = DoVideoSync();
            ReadVideoBuf();       
         } else { // Sync-Worte die nicht ausgewertet werden z.B. Slices
            StreamID = DoVideoSync();
         }
      }
   }  // while(true)
   Video->StreamID = 0xe0;
   
   Video->SeqNum = Video->SeqPos-1;   // sonst error WriteVideo() - read 1
   Video->PicNum = Video->SeqPicPos;
   Video->WrittenSeqNum = 0;

   if ( !Video->SeqNum ) {
      PrintLog( "ParseVideo() - no valid sequences\n");
      exit(-1);
   }

   // Video-Typ mit der groesseten Sequenz-Anzahl bestimmen
   Video->Type = 0;
   Num = Video->TypeSeqNum[0];
   for (i=1; i<VIDEO_TYPE_NUM; i++) {
      if( Num < Video->TypeSeqNum[i] ) {
         Video->Type = i;
         Num = Video->TypeSeqNum[i];
      } 
   }
   sprintf (string, "VideoType: %s\n", VideoTypeList[ Video->Type ].String );
   PrintLog( string );

   // Alle Sequenzen mit falschem Video-Typ => DontWrite
   for (i=0; i<Video->SeqNum; i++) {
      if( Video->Seq[i].VideoType == Video->Type ) {
         Video->Seq[i].DontWrite = 0;
      } else {
         Video->Seq[i].DontWrite = 1;
      }
   }

   // nicht koninuierlich Frames mit Dont'Write kennzeichnen
   EndPTS = Video->Seq[0].StartPTS + Video->Seq[0].PicNum * Video->PicPTS;
   for ( i=1; i<Video->SeqNum; i++) {
      if ( (Video->Seq[i].StartPTS < (EndPTS - PTS_TOLERANCE) ) ||
           (Video->Seq[i].StartPTS > (EndPTS + GAP_TOLERANCE * Video->PicPTS)) ) {
            // ueberlappende Video-Sequenzen/grosse Luecken sollten nie vorkommen
            sprintf( string, "ParseVideo() - video sequence overlap/big gap %llx - %llx\n",
                                        Video->Seq[i].StartPTS, EndPTS);
            PrintLog( string );
            Video->Seq[i].DontWrite = 1;
      } else {
        EndPTS = Video->Seq[i].StartPTS + 
                            Video->Seq[i].PicNum * Video->PicPTS;
      }
   }
}  

// ========================================================================
// Cut Audio Streams
// =======================================================================
void EvalCutFile()
{
    int i,j, k;
    int Cut_fd, SeqCount, CutSize;
    char CutBuf[CUT_BUF_SIZE];
    int CutTable[CUT_TABLE_SIZE];
    int DontWrite;
 
    Cut_fd = open(DVD->CutFileName, O_RDONLY);
    if (Cut_fd == -1) {
        PrintLog("EvalCutTable() - ERROR open");
        exit(-1);
    }

    CutSize = read(Cut_fd, CutBuf, CUT_BUF_SIZE);
    if ( CutSize == CUT_BUF_SIZE) {
       PrintLog("EvalCutTable() - CUT_BUF_SIZE zu klein\n");
       exit(-1);
    } else if (CutSize == -1 ) {
       PrintLog("EvalCutTable() - read\n");
       exit(-1);
    }

    close(Cut_fd);

    i=0; j=0;
    while(true) {
       if( 1 == sscanf(&CutBuf[i], "%i", &SeqCount) ) {
          CutTable[j++] = SeqCount;
          if( j == CUT_TABLE_SIZE) {
             PrintLog("EvalCutTable() - CUT_BUF_SIZE zu klein\n");
             exit(-1);
          }
       }
       while( CutBuf[i] != '\n' && i<CutSize) i++;
       i++; 
       if (i == CutSize) break;  //Dateiende abfangen
    }
    CutTable[j++] = 0x7fffffff;

    DontWrite = 1;
    j=0; k=0;
    for (i=0; i<Video->SeqNum; i++) {
       if(!Video->Seq[i].DontWrite) {
          if ( CutTable[j] == k ) {
            j++;
            if (DontWrite) DontWrite = 0;
                      else DontWrite = 1;
          }
          Video->Seq[i].DontWrite = DontWrite;
          k++;
       }
    }
}

void UpdateCutTable()
// Video->CutTable[]
// Video->CutTableLen
{
   int i, CutTablePos, SearchDontWrite;
   TimeStampType EndPTS;
   char string[STRING_SIZE];

   CutTablePos = 0;
   SearchDontWrite = 0;
   for ( i=0; i<Video->SeqNum; i++ ) {
      if (SearchDontWrite) {
         if (Video->Seq[i].StartPTS > (EndPTS + PTS_TOLERANCE) ) {
            Video->CutTable[CutTablePos++] = EndPTS;
            SearchDontWrite = 0;
            i--;
         } else if ( Video->Seq[i].DontWrite) {
            Video->CutTable[CutTablePos++] = Video->Seq[i].StartPTS;
            SearchDontWrite = 0;
            EndPTS += Video->Seq[i].PicNum * Video->PicPTS;
         } else {
            EndPTS += Video->Seq[i].PicNum * Video->PicPTS;
         }
      } else {
         if ( !Video->Seq[i].DontWrite ) {
            EndPTS = Video->Seq[i].StartPTS;
            Video->CutTable[CutTablePos++] = EndPTS;
            EndPTS += Video->Seq[i].PicNum * Video->PicPTS;
            SearchDontWrite = 1;
         }
      }
   }
   Video->CutTable[CutTablePos++] = 0x800000000llu;
   if ( CutTablePos >= VIDEO_CUT_TABLE_LEN ) {
      PrintLog( "UpdateCutTable() - VIDEO_CUT_TABLE_LEN too small\n");
      exit(-1);
   }
   Video->CutTableLen = CutTablePos;
   for ( i=0; i<Video->CutTableLen; i++) {
     sprintf( string, "CutTable %i: %llx\n", i, Video->CutTable[i] );
     PrintLog( string );
   }
}


void CutAudioStream( int Str)
// Audio[]->Frame[].Flag;  AUDIO_DONT_WRITE
// Die Audio-Streams starten spaetestens bei der selben PTS
// wie der Video-Stream (s. ParseAudio() )
// Die Audio-Streams haben keine Luecken > PTS_TOLERANCE
// aufeinander folgende Frame(gruppen) koennen sich aber ueberlappen
{
   int i, CutTablePos, SearchDontWrite;
   TimeStampType CutPTS, EndPTS;
   TimeStampType DeltaPTSWrite, DeltaPTSDontWrite, DeltaPTS;
  
   CutTablePos = 0;
   CutPTS = Video->CutTable[CutTablePos++];

   DeltaPTS = 0;
   SearchDontWrite = 0;

   for( i=0; i<Audio[Str]->FrameNum; i++) {
      if (SearchDontWrite) {
         if ( 2ll*long_abs(CutPTS - EndPTS) <= Audio[Str]->FramePTS) {
            SearchDontWrite = 0;
            DeltaPTS = EndPTS + DeltaPTS - CutPTS; 
            CutPTS = Video->CutTable[CutTablePos++];
         } else {
            DeltaPTSDontWrite = DeltaPTS + Audio[Str]->Frame[i+1].PTS -
                        Audio[Str]->Frame[i].PTS;

            DeltaPTSWrite = DeltaPTSDontWrite - Audio[Str]->FramePTS;

            if ( long_abs(DeltaPTSWrite) <= long_abs(DeltaPTSDontWrite) ) {
               DeltaPTS = DeltaPTSWrite;
               EndPTS += Audio[Str]->FramePTS;
            } else {
               DeltaPTS = DeltaPTSDontWrite; 
               Audio[Str]->Frame[i].Flag = AUDIO_DONT_WRITE;
            }      
         }
      } else {
         if ( 2ll*( CutPTS - Audio[Str]->Frame[i].PTS+DeltaPTS) <=
                            Audio[Str]->FramePTS  ) {
            DeltaPTS = Audio[Str]->Frame[i].PTS+DeltaPTS - CutPTS;
            EndPTS = CutPTS+Audio[Str]->FramePTS;
            SearchDontWrite = 1;
            CutPTS = Video->CutTable[CutTablePos++];
            i--;
         } else {
            Audio[Str]->Frame[i].Flag = AUDIO_DONT_WRITE;
         }
      }
   }
}
// =======================================================================
// WriteIfoFiles()
// =======================================================================



typedef struct {
   char Identifier[12];
   FourByte Last_Sector_of_VTS;
   OneByte Reserved1[12];
   FourByte Last_Sector_of_VTSI;
   TwoByte Specification_Version_Number;  // 0011 = v1.1
   FourByte Category;
   OneByte Reserved2[90];
   FourByte End_Byte_of_VTSI_MAT;
   OneByte Reserved3[60];
   FourByte Start_Sector_of_VTSM_VOBS;
   FourByte Start_Sector_of_VTSTT_VOBS;
   FourByte Start_Offset_of_VTS_PTT_SRPT;
   FourByte Start_Offset_of_VTS_PGCIT;
   FourByte Start_Offset_of_VTSM_PGCI_UT;
   FourByte Start_Offset_of_VTS_TMAPT;
   FourByte Start_Offset_of_VTSM_C_ADT;
   FourByte Start_Offset_of_VTSM_VOBU_ADMAP;
   FourByte Start_Offset_of_VTS_C_ADT;
   FourByte Start_Offset_of_VTS_VOBU_ADMAP;
   OneByte Reserved4[24];
// 0x0100:
   TwoByte Video_Attributes_of_VTSM_VOBS;
   TwoByte Number_of_Audio_Streams_in_VTSM_VOBS;
   OneByte VTSM_Audio_Attributes[10][8];
   TwoByte Number_of_SubP_Streams_in_VTSM_VOBS;
   OneByte VTSM_SubP_Stream_Attributes[1][6];
   OneByte Reserved5[164];
//0x200:
   TwoByte Video_Attributes_of_VTSTT_VOBS;
   TwoByte Number_of_Audio_Streams_in_VTSTT_VOBS;
   OneByte VTSTT_Audio_Attributes[8][8];
   OneByte Reserved6[16];
   TwoByte Number_of_SubP_Streams_in_VTSTT_VOBS;
   OneByte VTSTT_SubP_Stream_Attributes[32][6];
   TwoByte Reserved7;
   OneByte Multichannel_Extension[8][24];
   OneByte Reserved8[1064];
} VTSI_MAT_Type;   // sizeof = 2048

// ==========================================================
typedef struct {
   TwoByte Number_of_TTU_in_VTS;  // TTU: Title Unit Search Pointer
   TwoByte Reserved;
   FourByte End_Byte_of_PTT_SRPT_Table;
   FourByte TTU_1_Start_Byte;
} VTS_PTT_SRPT_Header;

typedef struct {
  TwoByte Program_Chain_Number;   // PGCN
  TwoByte Program_Number;         // PG
} VTS_PTT_SRPT_Entry;

typedef struct {
  VTS_PTT_SRPT_Header Hdr;
  VTS_PTT_SRPT_Entry Tbl;
} VTS_PTT_SRPT_Type;

// ======================================================
typedef struct {
   TwoByte Number_of_VTS_PGCI_SRP;
   TwoByte Reserved;
   FourByte End_Byte_of_VTS_PGCI_SRP_Table;
   OneByte VTS_PGC_1_Category_Mask;
   OneByte VTS_PGC_1_Category;
   TwoByte VTS_PGC_1_Category_Parental_ID_Mask;
   FourByte VTS_PGCI_1_Start_Byte;
} VTS_PGCIT_Header;

typedef struct {
   TwoByte Reserved1;
   OneByte Number_of_Programms;
   OneByte Number_of_Cells;
   FourByte Playback_Time;
   FourByte Prohibited_User_Operations;
   TwoByte Audio_Stream_Status[8];
   FourByte SubP_StreamStatus[32];
   TwoByte Next_PGC_Number;
   TwoByte Previous_PGC_Number;
   TwoByte Go_Up_PGC_Number;
   OneByte Still_Time_in_Seconds;
   OneByte PG_Playback_Mode;
   OneByte Color_Y_Cr_CB[16][4];
   TwoByte PGC_Command_Table_Start_Byte;
   TwoByte PGC_Program_Map_Start_Byte;
   TwoByte Cell_Playback_Information_Table_Start_Byte;
   TwoByte Cell_Position_Information_Table_Start_Byte;
} VTS_PGCIT_Entry;

typedef struct {
   OneByte Entry_Cell_Number;
   OneByte Reserved;
} PGC_Program_Map_Entry;

typedef struct {
   OneByte Cell_Type;
   OneByte Cell_Restricted;
   OneByte Still_Time;
   OneByte Command_Nr;
   FourByte Playback_Time;
   FourByte Entry_Point_Sector;
   FourByte First_ILVU_VOBU_End_Sector;
   FourByte Start_Sector_of_Last_VOBU;
   FourByte Last_Sector_of_This_Cell;
} Cell_Playback_Information_Table_Entry;

typedef struct {
   TwoByte Has_VOB_ID;
   OneByte Reserved;
   OneByte Has_Cell_ID;
} Cell_Position_Information_Table_Entry;

typedef struct {
  VTS_PGCIT_Header Hdr;
  VTS_PGCIT_Entry Tbl;
  PGC_Program_Map_Entry PGC_Program_Map;
  Cell_Playback_Information_Table_Entry Cell_Playback;
  Cell_Position_Information_Table_Entry Cell_Position; 
} VTS_PGCIT_Type;

// ======================================================
typedef struct {
   TwoByte Number_of_VTS_TMAP;
   TwoByte Reserved;
   FourByte End_Byte_of_VTS_TMAP_Table;
   FourByte TMAP_1_Start_Byte;
} VTS_TMAPT_Header;

typedef struct {
   OneByte Time_Unit;  // in Sekunden
   OneByte Reserved;
   TwoByte Number_of_Entries_in_Time_Map;
   FourByte Sector[1];   // Groesse wird beim Ausfuellen nicht geprueft
                         // 1 -> fuer Groessenberechnung der Gesamttabelle
} VTS_TMAPT_Entry;

typedef struct {
   VTS_TMAPT_Header Hdr;
   VTS_TMAPT_Entry Tbl;
} VTS_TMAPT_Type;

// ======================================================
typedef struct {
   TwoByte Number_of_VOB_in_VTS_VOBS;
   TwoByte Reserved1;
   FourByte End_Byte_of_VTS_C_ADT_Table;
   TwoByte Cell_1_VOB_ID;
   OneByte Cell_1_Cell_ID;
   OneByte Reserved2;
   FourByte Cell_1_Start_Sector;
   FourByte Cell_1_End_Sector;
} VTS_C_ADT_Type;

// ======================================================
typedef struct {
   FourByte End_Byte_of_VTS_VOBU_ADMAP;
   FourByte Sector[1];
} VTS_VOBU_ADMAP_Type;

// ======================================================
typedef struct {
    char Identifier[12];       // "DVDVIDEO-VMG"
    FourByte Last_Sector_of_VMG;   
    OneByte Reserved1[12];
    FourByte Last_Sector_of_VMGI;
    TwoByte Specification_Version_Number;  // 0011 = v1.1
    TwoByte Regional_Code_Mask;   // 0x40 -> Alle Regionen
    TwoByte Category;   // 0000
    TwoByte Number_of_Volumes;  // 0001
    TwoByte This_Volume; // 0001
    OneByte Disc_Side; // 01
    OneByte Reserved2[19];
    TwoByte Number_of_Title_Sets; // 0001
    char Provider_ID[32]; // "PREMIERE"
    OneByte Pos_Code[32];
    FourByte End_Byte_of_VMGI_MAT;
    FourByte First_Play_PGC_Start_Byte;
    OneByte Reserved3[56];
    FourByte Start_Sector_of_VMGM_VOBS;
    FourByte Start_Offset_of_VMG_PTT_SRPT;
    FourByte Start_Offset_of_VMGM_PGCI_UT;
    FourByte Start_Offset_of_VMG_PTL_MAIT;
    FourByte Start_Offset_of_VMG_VTS_ATRT;
    FourByte Start_Offset_of_VMG_TXTDT_MG;
    FourByte Start_Offset_of_VMGM_C_ADT;
    FourByte Start_Offset_of_VMGM_VOBU_ADMAP;
    OneByte Reserved4[32];
    TwoByte Video_Attributes_of_VMGM_VOBS;
    TwoByte Number_of_Auido_Streams_in_VMG_VOBS;
    OneByte VMGM_Audio_Attributes[10][8];
    TwoByte Number_of_SubP_Stream_Attributes;
    OneByte VMGM_SubP_Stream_Attributes[1][6];
    OneByte Reserved5[164+256+256]; 
} VMGM_MAT_Type;  // sizeof=1024

typedef struct {
   TwoByte Number_of_Pre_Commands;
   TwoByte Number_of_Post_Commands;
   TwoByte Number_of_Cell_Commands;
   TwoByte Size_of_Command_Table_in_Bytes;
   OneByte Pre_Command[8];
} PGC_Command_Table_Entry;

typedef struct {
   TwoByte Reserved1;
   OneByte Number_of_Programms;
   OneByte Number_of_Cells;
   FourByte Playback_Time;
   FourByte Prohibited_User_Operations;
   TwoByte Audio_Stream_Status[8];
   FourByte SubP_Stream_Status[32];
   TwoByte Next_PGC_Number;
   TwoByte Previous_PGC_Number;
   TwoByte Go_Up_PGC_Number;
   OneByte Still_Time_in_Seconds;
   OneByte PG_Playback_Mode;  
   OneByte Color_Y_Cr_CB[16][4];
   TwoByte PGC_Command_Table_Start_Byte;
   TwoByte PGC_Program_Map_Start_Byte;
   TwoByte Cell_Playback_Information_Table_Start_Byte;
   TwoByte Cell_Position_Information_Table_Start_Byte;
} Program_Chain_Type;

typedef struct {
   VMGM_MAT_Type VMG;
   Program_Chain_Type PGC;
   PGC_Command_Table_Entry CMD;  // Sonderfall: eine PGC
} VMGI_MAT_Type;

typedef struct {
   OneByte Title_Playback_Type;
   OneByte Number_of_Angles;
   TwoByte Number_of_Chapters;
   TwoByte Parental_ID_Field;
   OneByte Title_Set_Number;
   OneByte Title_Set_Title_Number;
   FourByte Title_Set_Starting_Sector;
} Title_Play_Map_Entry;

typedef struct {
   TwoByte Number_of_Title_Play_Maps;
   TwoByte Reserved;
   FourByte Length_of_Table;
   Title_Play_Map_Entry TPM;
} VMG_PTT_SRPT_Type;  //Sonderfall: ein Title

typedef struct {
   FourByte Attribute_End_Byte;
   FourByte CAT_Application_Type;
   TwoByte Video_Attributes_of_Menu;
   TwoByte Number_of_Audio_Streams_in_Menu;
   OneByte Audio_Attributes_of_Menu[10][8];
   TwoByte Number_of_SubP_Streams_in_Menu;
   OneByte SubP_Attributes_of_Menue[170];
   TwoByte Video_Attributes_of_Title;
   TwoByte Number_of_Audio_Streams_in_Title;
   OneByte Title_Audio_Attributes[8][8];
   OneByte Reserved1[16];
   TwoByte Number_of_SubP_Streams_in_Title;
   OneByte Reserved[256+170];
} Video_Title_Set_Entry;

typedef struct {
   TwoByte Number_of_Video_Title_Sets;
   TwoByte Reserved;
   FourByte End_Byte_of_VTS_ATR_Table;
   FourByte VTS_1_Attribute_Start_Byte;
} VMG_VTS_ATRT_Header;

typedef struct {
   VMG_VTS_ATRT_Header Hdr;
   Video_Title_Set_Entry VTS;
} VMG_VTS_ATRT_Type;


#define VIDEO_TS_SIZE 10
#define VTS_01_0_SIZE 200

struct {
   // VIDEO_TS
   VMGI_MAT_Type *VMGI_MAT;
   VMG_PTT_SRPT_Type *VMG_PTT_SRPT;
   VMG_VTS_ATRT_Type *VMG_VTS_ATRT;
   int VMG_PTT_SRPT_Offset;
   int VMG_VTS_ATRT_Offset;
   int VIDEO_TS_Len;

   // VTS_01_0
   VTSI_MAT_Type *VTSI_MAT;
   VTS_PTT_SRPT_Type *VTS_PTT_SRPT;
   VTS_PGCIT_Type *VTS_PGCIT;
   VTS_TMAPT_Type *VTS_TMAPT;
   VTS_C_ADT_Type *VTS_C_ADT;
   VTS_VOBU_ADMAP_Type *VTS_VOBU_ADMAP;
   int VTS_PTT_SRPT_Offset;
   int VTS_PGCIT_Offset;
   int VTS_TMAPT_Offset;
   int VTS_C_ADT_Offset;
   int VTS_VOBU_ADMAP_Offset;
   int VTS_01_0_Len;
   int Total_Playback_Time;
   int Start_Sector_of_Last_VOBU;
   int Last_Sector_of_This_Cell;
   OneByte VIDEO_TS[VIDEO_TS_SIZE*SECTOR_LEN];
   OneByte VTS_01_0[VTS_01_0_SIZE*SECTOR_LEN];
   int Video_Attributes;
   OneByte Audio_Attributes[MAX_AUDIO_STREAM_NUM][8];
} Ifo;


void Write_VIDEO_TS()
{
   int video_ts_fd;
   char string[STRING_SIZE]; 

   // VIDEO_TS.IFO
   video_ts_fd = open(IfoFileNameList[DVDCount].VIDEO_TS_Ifo, 
                   O_WRONLY|O_CREAT|O_TRUNC, 
                    S_IRUSR | S_IRGRP | S_IROTH | S_IWUSR | S_IWGRP | S_IWOTH );
   if (video_ts_fd == -1) {
      sprintf(string, "Write_VIDEO_TS() - IFO open: %s\n", strerror(errno));
      PrintLog( string );
      exit(-1);
   }
   
   if(Ifo.VIDEO_TS_Len * SECTOR_LEN != 
        write(video_ts_fd, Ifo.VIDEO_TS, Ifo.VIDEO_TS_Len * SECTOR_LEN) ) {
      PrintLog( "Write_VIDEO_TS() - IFO write\n");
      exit(-1);
   } 

   close(video_ts_fd); 

   // VIDEO_TS.BUP
   video_ts_fd = open(IfoFileNameList[DVDCount].VIDEO_TS_Bup, 
                   O_WRONLY|O_CREAT|O_TRUNC, 
                    S_IRUSR | S_IRGRP | S_IROTH | S_IWUSR | S_IWGRP | S_IWOTH );
   if (video_ts_fd == -1) {
      sprintf(string, "Write_VIDEO_TS() - IFO open: %s\n", strerror(errno));
      PrintLog(string);
      exit(-1);
   }
   
   if(Ifo.VIDEO_TS_Len * SECTOR_LEN != 
        write(video_ts_fd, Ifo.VIDEO_TS, Ifo.VIDEO_TS_Len * SECTOR_LEN) ) {
      PrintLog( "Write_VIDEO_TS() - IFO write\n");
      exit(-1);
   } 

   close(video_ts_fd); 
}

void Write_VTS_01_0()
{
   int vts_01_0_fd;
   char string[STRING_SIZE];


   // VTS_01_0.IFO
   vts_01_0_fd = open(IfoFileNameList[DVDCount].VTS_01_0_Ifo, 
                   O_WRONLY|O_CREAT|O_TRUNC, 
                   S_IRUSR | S_IRGRP | S_IROTH | S_IWUSR | S_IWGRP | S_IWOTH );

   if (vts_01_0_fd == -1) {
      sprintf(string, "Write_VTS_01_0() - IFO open: %s\n", strerror(errno));
      PrintLog( string );
      exit(-1);
   }
   
   if(Ifo.VTS_01_0_Len * SECTOR_LEN != 
        write(vts_01_0_fd, Ifo.VTS_01_0, Ifo.VTS_01_0_Len * SECTOR_LEN) ) {
      PrintLog( "Write_VTS_01_0() - IFO write\n");
      exit(-1);
   } 

   close(vts_01_0_fd); 

   // VTS_01_0.BUP
   vts_01_0_fd = open(IfoFileNameList[DVDCount].VTS_01_0_Bup, 
                   O_WRONLY|O_CREAT|O_TRUNC, 
                   S_IRUSR | S_IRGRP | S_IROTH | S_IWUSR | S_IWGRP | S_IWOTH );

   if (vts_01_0_fd == -1) {
      sprintf(string, "Write_VTS_01_0() - IFO open: %s\n", strerror(errno));
      PrintLog( string );
      exit(-1);
   }
   
   if(Ifo.VTS_01_0_Len * SECTOR_LEN != 
        write(vts_01_0_fd, Ifo.VTS_01_0, Ifo.VTS_01_0_Len * SECTOR_LEN) ) {
      PrintLog( "Write_VTS_01_0() - IFO write\n");
      exit(-1);
   } 

   close(vts_01_0_fd); 
}


int Update_First_Play_PGC()
{
   OneByte Pre_Command[8] = 
       { 0x30, 0x02, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00 };  // ???

   WriteTimeBCD( (*Ifo.VMGI_MAT).PGC.Playback_Time, 0);
   WriteTwoByte( (*Ifo.VMGI_MAT).PGC.PGC_Command_Table_Start_Byte,
                                          sizeof(Program_Chain_Type) );

   WriteTwoByte( (*Ifo.VMGI_MAT).CMD.Number_of_Pre_Commands, 1);
   WriteTwoByte( (*Ifo.VMGI_MAT).CMD.Size_of_Command_Table_in_Bytes,
                                   sizeof(PGC_Command_Table_Entry)-1 );
   WriteBytes( (*Ifo.VMGI_MAT).CMD.Pre_Command, Pre_Command, 8);

   return 1;
} 

int Update_VMG_PTT_SRPT()
{
   WriteTwoByte( (*Ifo.VMG_PTT_SRPT). Number_of_Title_Play_Maps, 1);
   WriteFourByte( (*Ifo.VMG_PTT_SRPT).Length_of_Table, 
                                          sizeof(VMG_PTT_SRPT_Type)-1 );

   (*Ifo.VMG_PTT_SRPT).TPM.Title_Playback_Type = 0x14;  // ???
   (*Ifo.VMG_PTT_SRPT).TPM.Number_of_Angles = 1;
   WriteTwoByte( (*Ifo.VMG_PTT_SRPT).TPM.Number_of_Chapters, 1);
   (*Ifo.VMG_PTT_SRPT).TPM.Title_Set_Number = 1;
   (*Ifo.VMG_PTT_SRPT).TPM.Title_Set_Title_Number = 1;    
   WriteFourByte( (*Ifo.VMG_PTT_SRPT).TPM.Title_Set_Starting_Sector,
                                                    VTS_START_DISTANCE );  
  
   return 1;
}

int Update_VMG_VTS_ATRT()
{
   WriteTwoByte( (*Ifo.VMG_VTS_ATRT).Hdr.Number_of_Video_Title_Sets, 1);
   WriteFourByte( (*Ifo.VMG_VTS_ATRT).Hdr.End_Byte_of_VTS_ATR_Table,
                                       sizeof( VMG_VTS_ATRT_Type ) - 1);
   WriteFourByte( (*Ifo.VMG_VTS_ATRT).Hdr.VTS_1_Attribute_Start_Byte,
                                        sizeof( VMG_VTS_ATRT_Header ) );

   WriteFourByte( (*Ifo.VMG_VTS_ATRT).VTS.Attribute_End_Byte,
                                   sizeof( Video_Title_Set_Entry ) - 1);
   WriteTwoByte( (*Ifo.VMG_VTS_ATRT).VTS.Video_Attributes_of_Menu, 
                                                   Ifo.Video_Attributes );
   WriteTwoByte( (*Ifo.VMG_VTS_ATRT).VTS.Video_Attributes_of_Title, 
                                                   Ifo.Video_Attributes );
   WriteTwoByte( (*Ifo.VMG_VTS_ATRT).VTS.Number_of_Audio_Streams_in_Title, 
                                                            AudioStreamNum);

   for (int i=0; i<AudioStreamNum; i++) {
      WriteBytes( (*Ifo.VMG_VTS_ATRT).VTS.Title_Audio_Attributes[i],
                                                Ifo.Audio_Attributes[i], 8);
   }

   return 1;
}

void Update_VMGM_MAT()
{
   char VMG_Identifier[13] = "DVDVIDEO-VMG";
   // char Provider_ID[32] = "PREMIERE";

   WriteString( (*Ifo.VMGI_MAT).VMG.Identifier, VMG_Identifier, 12);
   WriteFourByte( (*Ifo.VMGI_MAT).VMG.Last_Sector_of_VMG, VMG_LEN); 
   WriteFourByte( (*Ifo.VMGI_MAT).VMG.Last_Sector_of_VMGI, Ifo.VIDEO_TS_Len-1);
   WriteTwoByte( (*Ifo.VMGI_MAT).VMG.Specification_Version_Number, 0x0011); // v1.1
   WriteTwoByte( (*Ifo.VMGI_MAT).VMG.Regional_Code_Mask, 0x0040); // alle Regionen
   WriteTwoByte( (*Ifo.VMGI_MAT).VMG.Number_of_Volumes, 1);
   WriteTwoByte( (*Ifo.VMGI_MAT).VMG.This_Volume, 1);
   (*Ifo.VMGI_MAT).VMG.Disc_Side = 1;
   WriteTwoByte( (*Ifo.VMGI_MAT).VMG.Number_of_Title_Sets, 1);
   // WriteString( (*Ifo.VMGI_MAT).VMG.Provider_ID, Provider_ID, 32);
   WriteFourByte( (*Ifo.VMGI_MAT).VMG.End_Byte_of_VMGI_MAT, 
                                          sizeof(VMGI_MAT_Type) - 1);
   WriteFourByte( (*Ifo.VMGI_MAT).VMG.First_Play_PGC_Start_Byte,
                                             sizeof(VMGM_MAT_Type) );

   WriteFourByte( (*Ifo.VMGI_MAT).VMG.Start_Offset_of_VMG_PTT_SRPT,
                                            Ifo.VMG_PTT_SRPT_Offset ); 
   WriteFourByte( (*Ifo.VMGI_MAT).VMG.Start_Offset_of_VMG_VTS_ATRT,
                                            Ifo.VMG_VTS_ATRT_Offset );
   WriteTwoByte( (*Ifo.VMGI_MAT).VMG.Video_Attributes_of_VMGM_VOBS,
                                               Ifo.Video_Attributes );
}

void Update_VIDEO_TS()
{
   for (int i=0; i< VIDEO_TS_SIZE*SECTOR_LEN; i++) Ifo.VIDEO_TS[i] = 0;

   Ifo.VMGI_MAT = (VMGI_MAT_Type*)Ifo.VIDEO_TS;
   Ifo.VMG_PTT_SRPT_Offset = Update_First_Play_PGC();
   Ifo.VMG_PTT_SRPT = 
       (VMG_PTT_SRPT_Type*)((int)Ifo.VMGI_MAT +
                                 Ifo.VMG_PTT_SRPT_Offset * SECTOR_LEN);
     
   Ifo.VMG_VTS_ATRT_Offset = Ifo.VMG_PTT_SRPT_Offset + Update_VMG_PTT_SRPT();
   
   Ifo.VMG_VTS_ATRT =
      (VMG_VTS_ATRT_Type*)((int)Ifo.VMGI_MAT + 
                                       Ifo.VMG_VTS_ATRT_Offset * SECTOR_LEN);

   Ifo.VIDEO_TS_Len = Ifo.VMG_VTS_ATRT_Offset + Update_VMG_VTS_ATRT();
  
   Update_VMGM_MAT();
}

int Update_VTSI_MAT()
{
   char VTS_Identifier[13] = "DVDVIDEO-VTS";

   WriteString( (*Ifo.VTSI_MAT).Identifier, VTS_Identifier, 12);

   WriteTwoByte( (*Ifo.VTSI_MAT).Specification_Version_Number, 0x0011); // v1.1
   WriteFourByte( (*Ifo.VTSI_MAT).End_Byte_of_VTSI_MAT, 
                                          sizeof(VTSI_MAT_Type) - 1);
   WriteTwoByte( (*Ifo.VTSI_MAT).Video_Attributes_of_VTSM_VOBS,
                                              Ifo.Video_Attributes );
   WriteTwoByte( (*Ifo.VTSI_MAT).Video_Attributes_of_VTSTT_VOBS,
                                              Ifo.Video_Attributes );
  
   WriteTwoByte( (*Ifo.VTSI_MAT).Number_of_Audio_Streams_in_VTSTT_VOBS, 
                                                         AudioStreamNum);

   for (int i=0; i<AudioStreamNum; i++) {
      WriteBytes( (*Ifo.VTSI_MAT).VTSTT_Audio_Attributes[i],
                                              Ifo.Audio_Attributes[i], 8);
   }
   
   return 1;
}

int Update_VTS_PTT_SRPT()
{
   WriteTwoByte( (*Ifo.VTS_PTT_SRPT).Hdr.Number_of_TTU_in_VTS, 1 );
   WriteFourByte( (*Ifo.VTS_PTT_SRPT).Hdr.End_Byte_of_PTT_SRPT_Table,
                                         sizeof(VTS_PTT_SRPT_Type) - 1 );
   WriteFourByte( (*Ifo.VTS_PTT_SRPT).Hdr.TTU_1_Start_Byte,
                                           sizeof(VTS_PTT_SRPT_Header) );
   WriteTwoByte( (*Ifo.VTS_PTT_SRPT).Tbl.Program_Chain_Number, 1 );
   WriteTwoByte( (*Ifo.VTS_PTT_SRPT).Tbl.Program_Number, 1 );

   return 1;
}

const int Audio_Stream_Status_List[8] = 
   { 0x8000, 0x8100, 0x8200, 0x8300, 0x8400, 0x8500, 0x8600, 0x8700 };

int Update_VTS_PGCIT()
{
   // Header
   WriteTwoByte( (*Ifo.VTS_PGCIT).Hdr.Number_of_VTS_PGCI_SRP, 1 );
   WriteFourByte( (*Ifo.VTS_PGCIT).Hdr.End_Byte_of_VTS_PGCI_SRP_Table,
                                            sizeof(VTS_PGCIT_Type) -1 );

   (*Ifo.VTS_PGCIT).Hdr.VTS_PGC_1_Category_Mask = 0x81;  // ???
 
   WriteFourByte( (*Ifo.VTS_PGCIT).Hdr.VTS_PGCI_1_Start_Byte,
                                            sizeof(VTS_PGCIT_Header) );

   // Program Chain
   (*Ifo.VTS_PGCIT).Tbl.Number_of_Programms = 1;
   (*Ifo.VTS_PGCIT).Tbl.Number_of_Cells = 1;
   WriteTimeBCD( (*Ifo.VTS_PGCIT).Tbl.Playback_Time, Ifo.Total_Playback_Time);

   for ( int i=0; i<AudioStreamNum; i++) {
      WriteTwoByte( (*Ifo.VTS_PGCIT).Tbl.Audio_Stream_Status[i], 
                                      Audio_Stream_Status_List[i]); // ???
   }

   WriteTwoByte( (*Ifo.VTS_PGCIT).Tbl.PGC_Program_Map_Start_Byte,
                                            sizeof(VTS_PGCIT_Entry) );
   WriteTwoByte( (*Ifo.VTS_PGCIT).Tbl.Cell_Playback_Information_Table_Start_Byte, 
                                           sizeof(VTS_PGCIT_Entry) +
                                           sizeof(PGC_Program_Map_Entry) );
   WriteTwoByte( (*Ifo.VTS_PGCIT).Tbl.Cell_Position_Information_Table_Start_Byte,
                              sizeof(VTS_PGCIT_Entry) +
                              sizeof(PGC_Program_Map_Entry) +
                              sizeof(Cell_Playback_Information_Table_Entry) );

   // PGC Program Map
   (*Ifo.VTS_PGCIT).PGC_Program_Map.Entry_Cell_Number = 1;

   // Cell Playback
   (*Ifo.VTS_PGCIT).Cell_Playback.Cell_Type = 0x02; // ???
   WriteTimeBCD( (*Ifo.VTS_PGCIT).Cell_Playback.Playback_Time,
                                              Ifo.Total_Playback_Time );
   WriteFourByte( (*Ifo.VTS_PGCIT).Cell_Playback.Start_Sector_of_Last_VOBU,
                                            Ifo.Start_Sector_of_Last_VOBU);     
   WriteFourByte( (*Ifo.VTS_PGCIT).Cell_Playback.Last_Sector_of_This_Cell,
                                            Ifo.Last_Sector_of_This_Cell);
   
   // Cell Position
   WriteTwoByte( (*Ifo.VTS_PGCIT).Cell_Position.Has_VOB_ID, 1);
   (*Ifo.VTS_PGCIT).Cell_Position.Has_Cell_ID = 1;

   return 1;
}

int Update_VTS_TMAPT()
{
   int VTS_TMAPT_Size;


   WriteTwoByte( (*Ifo.VTS_TMAPT).Hdr.Number_of_VTS_TMAP, 1);
   WriteFourByte( (*Ifo.VTS_TMAPT).Hdr.TMAP_1_Start_Byte,
                                     sizeof(VTS_TMAPT_Header) );

   (*Ifo.VTS_TMAPT).Tbl.Time_Unit = TMAP_TIME_UNIT;

   // Sektorlist ausfuellen
   int i = 0;
   int j = 0;

   for  (j=0; j< DVD->SeqNum; j++ ) {
      if (DVD->Seq[j].VTS_TMAP_Entry) {
         WriteFourByte( (*Ifo.VTS_TMAPT).Tbl.Sector[i], 
                                        DVD->Seq[j].SectorPos);
         i++;
      }
   }
   i--;
   (*Ifo.VTS_TMAPT).Tbl.Sector[i][0] += 0x80; // Discontinuity Entry

   WriteTwoByte( (*Ifo.VTS_TMAPT).Tbl.Number_of_Entries_in_Time_Map, i+1 );

   VTS_TMAPT_Size = sizeof( VTS_TMAPT_Type) +
                    sizeof( FourByte ) * i;

   WriteFourByte( (*Ifo.VTS_TMAPT).Hdr.End_Byte_of_VTS_TMAP_Table, 
                                                       VTS_TMAPT_Size-1 );

   if (VTS_TMAPT_Size % SECTOR_LEN ) {
      return VTS_TMAPT_Size / SECTOR_LEN + 1;
   } else {
      return VTS_TMAPT_Size / SECTOR_LEN;
   }
}

int Update_VTS_C_ADT()
{
   WriteTwoByte( (*Ifo.VTS_C_ADT).Number_of_VOB_in_VTS_VOBS, 1);
   WriteFourByte( (*Ifo.VTS_C_ADT).End_Byte_of_VTS_C_ADT_Table,
                                        sizeof(VTS_C_ADT_Type) - 1 );
   WriteTwoByte( (*Ifo.VTS_C_ADT).Cell_1_VOB_ID, 1);
   (*Ifo.VTS_C_ADT).Cell_1_Cell_ID = 1;
   WriteFourByte( (*Ifo.VTS_C_ADT).Cell_1_End_Sector, 
                                            Ifo.Last_Sector_of_This_Cell );
  
   return 1;
}

int Update_VTS_VOBU_ADMAP()
{
   int VTS_VOBU_ADMAP_Size = sizeof(VTS_VOBU_ADMAP_Type) +
                                       (DVD->SeqNum-2) * sizeof(FourByte);
   WriteFourByte( (*Ifo.VTS_VOBU_ADMAP).End_Byte_of_VTS_VOBU_ADMAP,
                                                VTS_VOBU_ADMAP_Size-1 );

   for (int i=0; i < DVD->SeqNum-1; i++ ) {
      WriteFourByte( (*Ifo.VTS_VOBU_ADMAP).Sector[i],
                                                 DVD->Seq[i].SectorPos );
   }
   if (VTS_VOBU_ADMAP_Size % SECTOR_LEN ) {
      return VTS_VOBU_ADMAP_Size / SECTOR_LEN + 1;
   } else {
      return VTS_VOBU_ADMAP_Size / SECTOR_LEN;
   }
}

void Update_VTS_Remaining()
{
   WriteFourByte( (*Ifo.VTSI_MAT).Last_Sector_of_VTS,
                           Ifo.Last_Sector_of_This_Cell+ VTS_END_DISTANCE );
   WriteFourByte( (*Ifo.VTSI_MAT).Last_Sector_of_VTSI, Ifo.VTS_01_0_Len-1);
   WriteFourByte( (*Ifo.VTSI_MAT).Start_Sector_of_VTSM_VOBS, 
                                                   START_VTSM_VOBS );
   WriteFourByte( (*Ifo.VTSI_MAT).Start_Sector_of_VTSTT_VOBS, 
                                                   START_VTSM_VOBS );
   WriteFourByte( (*Ifo.VTSI_MAT).Start_Offset_of_VTS_PTT_SRPT,
                                               Ifo.VTS_PTT_SRPT_Offset ); 
   WriteFourByte( (*Ifo.VTSI_MAT).Start_Offset_of_VTS_PGCIT,
                                                Ifo.VTS_PGCIT_Offset ); 
   WriteFourByte( (*Ifo.VTSI_MAT).Start_Offset_of_VTS_TMAPT,
                                                Ifo.VTS_TMAPT_Offset ); 
   WriteFourByte( (*Ifo.VTSI_MAT).Start_Offset_of_VTS_C_ADT,
                                                Ifo.VTS_C_ADT_Offset ); 
   WriteFourByte( (*Ifo.VTSI_MAT).Start_Offset_of_VTS_VOBU_ADMAP,
                                            Ifo.VTS_VOBU_ADMAP_Offset ); 

}

void Update_VTS_01_0()
{

   for (int i=0; i< VTS_01_0_SIZE*SECTOR_LEN; i++) Ifo.VTS_01_0[i] = 0;
   Ifo.VTSI_MAT = (VTSI_MAT_Type*)Ifo.VTS_01_0;
   Ifo.VTS_PTT_SRPT_Offset = Update_VTSI_MAT();

   Ifo.VTS_PTT_SRPT = 
      (VTS_PTT_SRPT_Type*)((int)Ifo.VTSI_MAT + 
                                 Ifo.VTS_PTT_SRPT_Offset * SECTOR_LEN);

   Ifo.VTS_PGCIT_Offset = Ifo.VTS_PTT_SRPT_Offset + Update_VTS_PTT_SRPT();
   Ifo.VTS_PGCIT = 
      (VTS_PGCIT_Type*)((int)Ifo.VTSI_MAT + Ifo.VTS_PGCIT_Offset * SECTOR_LEN);

   Ifo.VTS_TMAPT_Offset = Ifo.VTS_PGCIT_Offset + Update_VTS_PGCIT();
   Ifo.VTS_TMAPT =
      (VTS_TMAPT_Type*)((int)Ifo.VTSI_MAT + Ifo.VTS_TMAPT_Offset * SECTOR_LEN);

   Ifo.VTS_C_ADT_Offset = Ifo.VTS_TMAPT_Offset + Update_VTS_TMAPT();
   Ifo.VTS_C_ADT =
      (VTS_C_ADT_Type*)((int)Ifo.VTSI_MAT + Ifo.VTS_C_ADT_Offset * SECTOR_LEN);

   Ifo.VTS_VOBU_ADMAP_Offset = Ifo.VTS_C_ADT_Offset + Update_VTS_C_ADT();
   Ifo.VTS_VOBU_ADMAP =
       (VTS_VOBU_ADMAP_Type*)((int)Ifo.VTSI_MAT + 
                                   Ifo.VTS_VOBU_ADMAP_Offset * SECTOR_LEN);

   Ifo.VTS_01_0_Len = Ifo.VTS_VOBU_ADMAP_Offset + Update_VTS_VOBU_ADMAP(); 

   Update_VTS_Remaining();
}


void WriteIfoFiles()
{
   Ifo.Video_Attributes = VideoTypeList[ Video->Type ].DVD;
   for (int i=0; i<AudioStreamNum; i++) {
      WriteBytes( Ifo.Audio_Attributes[i], 
                  AudioTypeList[ Audio[i]->Type ].Audio_Attributes, 8);
   }
 

   Ifo.Total_Playback_Time = DVD->Seq[DVD->SeqNum-1].I_Frame_PTS -
                             DVD->Seq[0].I_Frame_PTS;

   Ifo.Start_Sector_of_Last_VOBU = DVD->Seq[DVD->SeqNum-2].SectorPos;
   Ifo.Last_Sector_of_This_Cell = DVD->Seq[DVD->SeqNum-1].SectorPos - 1;

   Update_VIDEO_TS();
   Write_VIDEO_TS();

   Update_VTS_01_0();
   Write_VTS_01_0();
}

// =======================================================================
int main( int argc, char * argv[] )
{
   int Video_unfinished;
   char string[STRING_SIZE];
   int i;
   unsigned u;

   char BaseFileName[100];
   strcpy( BaseFileName, "stream" );

   OneVobMode = 0;
   CutMode = 0;

   for (int i = 1; i < argc; i++) {
      if (!strcmp("-f", argv[i])) {
         i++; if (i >= argc) { fprintf(stderr, "need filename for -f\n"); exit(-1); }
         strcpy( BaseFileName, argv[i]);
      } else if (!strcmp("-cut", argv[i])) {
         CutMode = 1;
      } else if (!strcmp("-onevob", argv[i])) {
         OneVobMode = 1; 
      } else {
         fprintf(stderr, "unknown option '%s'\n", argv[i]);
         fprintf(stderr, "------- known options: ---------\n"
	 "-f stream                     basename of input files\n"
         "-onevob                       write all data to one vob-file\n"
         "-cut                          read cut-info form <basename>.cut\n"
         );
         exit(-1);
      }
   }

   // Speicher anfordern
   Video = (VideoType*)malloc( sizeof(VideoType) );
   DVD = (DVDType*)malloc( sizeof(DVDType) );
   for (u=0; u<MAX_AUDIO_STREAM_NUM; u++)
       Audio[u] = (AudioListEntry*)malloc( sizeof(AudioListEntry) );


   // Dateinamen erstellen
   strcpy( Video->FileName, BaseFileName );
   strcat( Video->FileName, ".m2v" );
   strcpy( DVD->CutFileName, BaseFileName );
   strcat( DVD->CutFileName, ".cut" );
   strcpy( DVD->LogFileName, BaseFileName );
   strcat( DVD->LogFileName, ".log" );
   strcpy( DVD->SeqFileName, BaseFileName );
   strcat( DVD->SeqFileName, ".seq" );

   for (i=0; i<MAX_AUDIO_STREAM_NUM; i++) {
      strcpy( Audio[i]->FileName, BaseFileName );
      strcat( Audio[i]->FileName, AudioFileEnding[i] );
   } 

   if (OneVobMode ) {
      DVD->VobSectorNum = DVD_SECTOR_NUM;
   } else {
      DVD->VobSectorNum = 512*1024-1;
   }

   Log_fd = open( DVD->LogFileName, 
          O_CREAT|O_APPEND|O_WRONLY, 
          S_IRGRP|S_IRUSR|S_IROTH|S_IWGRP|S_IWUSR|S_IWOTH );
   if (Log_fd == -1) {
      PrintLog("main() - ERROR open log");
      exit(-1);
   }


   ParseVideo();
  
   AudioStreamNum=0;
   while ( !ParseAudio(AudioStreamNum) ) AudioStreamNum++;

   if ( !AudioStreamNum ) {
      PrintLog( "main() - no valid audio streams\n");
      exit(-1);
   }
 
   sprintf(string, "AudioStreamNum %i\n", AudioStreamNum);
   PrintLog( string );

   if( CutMode ) EvalCutFile();
   UpdateCutTable();

   for( i=0; i<AudioStreamNum; i++) CutAudioStream(i);

   DVDCount=0;
   OpenStreamFiles();
 
   for(i=0; i<AudioStreamNum; i++) {
      UpdateAudioSectorList(i);
   }

  do {
      UpdateVideoSectorList();
      Video_unfinished = SortSectors();;
      UpdateDSI();
      RealMux();
      WriteIfoFiles();
      DVDCount++;
   } while (Video_unfinished);
  
   PrintLog("main() - regular program end\n"); 

   close(Log_fd);
   free(Video);
   free(DVD);
   for (u=0; u<MAX_AUDIO_STREAM_NUM; u++) free( Audio[u] );
   return 0;
}
