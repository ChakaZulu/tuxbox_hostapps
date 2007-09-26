/*
 *   mkflfs.c flfs creater (dbox-II-project)
 *
 *   Homepage: http://dbox2.elxsi.de
 *
 *   Copyright (C) 2000-2003 Dennis Noermann (dennis.noermann@noernet.de)
 *
 *   Lizense is GPL
 *
 *   done by the work of tmbinc,yps,guido,gillem,hunz,jolt,field,derget
 *   (and all people i missed here)
 *
 *   code works, and does not need any more fixxes ore workarounds
 *   dont send me emails whith feature requests
 *
 *
 *   This programm is only made to make a 128 Kbyte uge flfs whith a bootloader
 *   (ppcboot/uboot) that boots linux on dbox2.
 *   It uses all the knowlage that is used to do this
 *   (dbox2 bootloader is not real Inteligent)
 *
 *   It cant be compared whith the real flfs filesystem used by Betanova
 *   and its not done for helping Hacking the Betanova.
 *
 *   It uses LZO Realtime Data Compression done by Markus F.X.J. Oberhumer
 *   see http://www.oberhumer.com/opensource/lzo/ for more information on it
 *
 *   compile-line "gcc -o mkflfs mkflfs.c minilzo.c"
 *
 *   Usage:
 *        mkflfs <type> [-o <outputfile> ] [<inputfile>]
 * 
 *   where type=1x or 2x. 
 *
 *   For compatibility with a previous version, inputfile and outputfile
 *   default to "test" and "flfs.img" respectivelly.
 *
 */

#include <endian.h>
#include <stdio.h>
#include "mkflfs.h"
#include <string.h>
#include "minilzo.h"
#include "lzoconf.h"

/*-----------------------------------------------------------------------------*/
#define IN_LEN          (4096L)
#define OUT_LEN         (IN_LEN + IN_LEN / 64 + 16 + 3)

static lzo_byte in  [ IN_LEN ];
static lzo_byte out [ OUT_LEN ];

#define HEAP_ALLOC(var,size) \
        long __LZO_MMODEL var [ ((size) + (sizeof(long) - 1)) / sizeof(long) ]

static HEAP_ALLOC(wrkmem,LZO1X_1_MEM_COMPRESS);
/*-----------------------------------------------------------------------------*/
#if __BYTE_ORDER == __BIG_ENDIAN
#define SWAP_WORD(x) (x)
#else
#define SWAP_WORD(x) \
 temp = x >> 8; \
 temp = temp | (x << 8 ); \
 x = temp;
#include <byteswap.h>
#endif

u8 input[262144];
u8 sector_00[131072];

u8 superblock_1x[] =
	{
		0xf0, 0xa4, 0x03, 0x01, 0x00, 0x3f, 0x00, 0x02, 0x74, 0x75, 0x78, 0x62, 0x6f, 0x78, 0x66, 0x73,
		0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0xff, 0xff
	};

u8 superblock_2x[] =
	{
		0xf0, 0xa4, 0x03, 0x01, 0x00, 0x7e, 0x00, 0x02, 0x74, 0x75, 0x78, 0x62, 0x6f, 0x78, 0x66, 0x73,
		0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0xff, 0xff
	};


u8 sector_ende_00[] =
	{	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  0xFF, 0xFF, 0xC3, 0xFE };
u8 sector_ende_63[] =
	{	0xff, 0xff, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00, 0x3f,  0xFF, 0xc0, 0xC3, 0xFF };

u8 syncff[4] = {0xff,0xff,0xff,0xff};

unsigned short temp = 0;
int data,chksum,data_00,chksum_00;
unsigned short blockNR = 0;
unsigned short ulen,plen,last_ulen;
unsigned int offset;
int normal_size , lzo_size;
int mode;

unsigned short blockNR_os = 14;

char inputfilename[255];
char outputfilename[255];

/*------------------------------------------------------------------*/
int compress_lzo(int a,u8 *daten)
{
	int r;
	lzo_uint in_len;
	lzo_uint out_len;

	if (lzo_init() != LZO_E_OK)
	{
		printf("lzo_init() failed !!!\n");
		return 3;
	}

	in_len = ulen;
	memcpy(&in[0], &daten[offset], (long)ulen);

	r = lzo1x_1_compress(in,in_len,out,&out_len,wrkmem);
	if (r == LZO_E_OK)
	{

		//printf("compressed %lu bytes into %lu bytes\n",
		//      (long) in_len, (long) out_len);
		plen=(unsigned short)out_len;
	}
	else
	{
		/* this should NEVER happen */
		printf("internal error - compression failed: %d\n", r);
		return 2;
	}
	/* check for an incompressible block */
	if (out_len >= in_len)
	{
		printf("This block contains incompressible data.\n");
		return 0;
	}
	return 1;
}
/*------------------------------------------------------------------*/
void write_to_file()
{
	int i;
	FILE* pFile=fopen(outputfilename, "w");
	if (pFile == 0)
	{
		fprintf(stderr, "Fatal error; could not open output file ``%s''\n",
				outputfilename);
		exit(2);
	}

	for(i=0; i< 131072; i++)
		putc(sector_00[i], pFile);
	fclose(pFile);
}
/*------------------------------------------------------------------*/
unsigned int read_from_file()
{
	int i;
	unsigned int size;
	FILE* pFile=fopen(inputfilename, "r");
	if (pFile == 0)
	{
		fprintf(stderr, "Fatal error; could not open input file ``%s''\n",
				inputfilename);
		exit(2);
	}
	fseek(pFile, 0, SEEK_END);
	size=(unsigned int)ftell(pFile);
	fseek(pFile, 0, 0);

	printf("groesse         : %d\n",size);

	for(i=0; i< size; i++)
		input[i]=fgetc(pFile);
	fclose(pFile);

	return size;
}
/*------------------------------------------------------------------*/
void dir_index(unsigned short offset,unsigned short len,int gross)
{
	unsigned short sync;
	dirindex index;

	if (gross==0)
	{
		sync=0x7b00;
	}
	else
	{
		sync=0x7b01;
	}

	SWAP_WORD(offset);
	SWAP_WORD(len);
	SWAP_WORD(sync);

	index.sync=sync;
	index.offset=offset;
	index.len=len;

	memcpy(&sector_00[chksum-6],&index, 6);
	chksum = chksum -6 ;
}
/*-------------------------------------------------------------*/
void mkdir(char nahme[256],int no_next_in_group,int empty,int os_inside)
{
	dirheader dirheader0;
	int dir_name_laenge = strlen(nahme);
	u8 dirheader_komplett[35+dir_name_laenge];
	int i;
	printf("%s liegt an %d\n",nahme,blockNR);

	blockNR++;

	if  (no_next_in_group==1)
	{
		for(i=0;i<4;i++)
			dirheader0.to_next_dir_file_in_group[i]=0xff;
	}
	else
	{
		dirheader0.to_next_dir_file_in_group[0]=0x00;
		dirheader0.to_next_dir_file_in_group[1]=0x00;
		dirheader0.to_next_dir_file_in_group[2]=0x00;
		dirheader0.to_next_dir_file_in_group[3]=blockNR+1;
	}


	if (empty==1)
	{
		if (no_next_in_group==1)
		{
			for(i=0;i<4;i++)
				dirheader0.to_next_dir_file[i]=0x00;
		}
		else
		{
			for(i=0;i<4;i++)
				dirheader0.to_next_dir_file[i]=0xff;
		}
	}
	else
	{
		dirheader0.to_next_dir_file[0]=0x00;
		dirheader0.to_next_dir_file[1]=0x00;
		dirheader0.to_next_dir_file[2]=0x00;
		if (os_inside==1)
		{
			dirheader0.to_next_dir_file[3]=blockNR_os;
		}
		else
		{
			dirheader0.to_next_dir_file[3]=blockNR;
		}
	}

	dirheader0.syncFF=0xffffffff;
	dirheader0.typ=0xf1;
	dirheader0.flags=0xfd;
	dirheader0.datum=0x00;
	for(i=0;i<6;i++)
		dirheader0.garbage1[i]=0x00;
	dirheader0.ka=0x01;
	dirheader0.dir_type=0xed;
	for(i=0;i<8;i++)
		dirheader0.garbage2[i]=0x00;
	dirheader0.laenge_dir=strlen(nahme);

	memcpy(&dirheader_komplett,&dirheader0,sizeof(dirheader0));
	memcpy(&dirheader_komplett[35],nahme,strlen(nahme));
	memcpy(&sector_00[data], dirheader_komplett, sizeof(dirheader_komplett));

	dir_index(data,(unsigned short)sizeof(dirheader_komplett),0);
	data=data + sizeof(dirheader_komplett);

	printf("dirheader0         : %d\n",sizeof(dirheader0));
	printf("dir_name_laenge    : %d\n",dir_name_laenge);
	printf("dirheader_komplett : %d\n",sizeof(dirheader_komplett));
	printf("data		   : %d\n",data);
	printf("dir_index	   : %d\n",sizeof(dir_index));
}
/*-------------------------------------------------------------*/

void mkfile(char nahme[256],u8 *daten,unsigned int size,int dummy)
{
	fileheader fileheader0;
	data_block_header data_block_header0;
	int i,blockzahl,a,ret;
	int last = 0;
	int bla = 0;
	unsigned short s63 = 0x3f;
	unsigned short blockNR_backup;

	if (dummy==1)
	{
		blockNR_backup=blockNR + 1;
		blockNR=51;
	}
	else
	{
		blockNR++;
	}

	for(i=0;i<4;i++)
		fileheader0.to_next_dir_file_in_group[i]=0xff;
	fileheader0.to_first_data_block[0]=0x00;
	fileheader0.to_first_data_block[1]=0x00;
	fileheader0.to_first_data_block[2]=0x00;
	fileheader0.to_first_data_block[3]=blockNR;
	fileheader0.syncFF=0xffffffff;
	fileheader0.typ=0xd0;  //f0 unpacket , d0 packet
	fileheader0.flags=0xfd;
	fileheader0.datum=0x00;
	for(i=0;i<6;i++)
		fileheader0.garbage1[i]=0x00;
	fileheader0.ka=0x01;
	fileheader0.file_type=0xb6;
	for(i=0;i<8;i++)
		fileheader0.garbage2[i]=0x00;
	fileheader0.laenge_file=strlen(nahme);

	dir_index(data,strlen(nahme)+35,0);
	memcpy(&sector_00[data],&fileheader0,35);
	data = data + 35;
	memcpy(&sector_00[data],nahme,strlen(nahme));
	data = data + strlen(nahme);


	if (dummy==1)
	{
		blockNR=blockNR_backup;
		return;
	}

	ulen = 0x1000;

	blockzahl = size/ulen;
	if (size-blockzahl*ulen!=0)
	{
		last_ulen=size-blockzahl*ulen;
		printf("last_ulen : %d\n",last_ulen);
		blockzahl = blockzahl + 1;
		last = 1;
	}

	blockNR++;

	normal_size = 0;
	lzo_size = 0;
	for(a=0;a<blockzahl;a++)
	{
		offset = a * ulen;


		if ((last==1) && (a==blockzahl-1))
		{
			ulen=last_ulen;
			printf("letzter block\n");
		}

		ret = compress_lzo(a,daten);

		//printf("blockzahl %d  offset %d  ulen %d  plen %d\n",a,offset,ulen,plen);

		data_block_header0.syncFF=0xffffffff;

		if (a<blockzahl-1)
		{
			if (mode==1 && bla==2)
			{
				SWAP_WORD(s63);
				data_block_header0.next_block_sector=s63;
				SWAP_WORD(s63);
			}
			else
			{
				data_block_header0.next_block_sector=0x00;
			}
		}
		else
		{
			data_block_header0.next_block_sector=0xffff;
		}

		SWAP_WORD(blockNR);
		if (a<blockzahl-1)
		{
			data_block_header0.next_block_block=blockNR;
		}
		else
		{
			data_block_header0.next_block_block=0xffff;
		}
		SWAP_WORD(blockNR);
		data_block_header0.syncFF2=0xffffffff;

		data_block_header0.typ=0x75;  //75 = compressed f5 = uncompressed


		if (a<blockzahl-1)
		{
			data_block_header0.typ2=0xfd;
		}
		else
		{
			data_block_header0.typ2=0xff;
		}

		data_block_header0.datum=0x00;
		for(i=0;i<4;i++)
			data_block_header0.garbage[i]=0x00;
#if __BYTE_ORDER == __BIG_ENDIAN
		data_block_header0.offset_im_file=offset;
#else
		data_block_header0.offset_im_file=bswap_32(offset);
#endif
		SWAP_WORD(plen);
		SWAP_WORD(ulen);
		data_block_header0.ulen=ulen;
		data_block_header0.plen=plen;
		SWAP_WORD(ulen);
		SWAP_WORD(plen);


		if (data<0xffff)
		{
			dir_index(data,plen+30,0);
		}
		else
		{
			if (mode==0)
			{
				dir_index(data,plen+30,1);
			}
			else
			{
				dir_index(data,plen+30,0);
			}
		}

		memcpy(&sector_00[data],&data_block_header0,30);
		data = data + 30;
		memcpy(&sector_00[data], &out,plen);
		data = data + plen;

		blockNR++;

		printf("blockNR %d",blockNR);
		if (chksum-data<4200)
		{
			sector_00[data-plen-30+5] = 0x3f;
			sector_00[data-plen-30+7] = 0x00;
			printf("data %d , chksum %d\n",data,chksum);
			printf("hier müsst es nun im sector 63 weitergehen bei 2x\n");
			bla=1;
			data_00=data;
			chksum_00=chksum;
			blockNR=1;
		}

		if (bla==1)
		{
			bla=2;
			data=65536;
			chksum = 131072;
			memcpy(&sector_00[chksum - 14],sector_ende_63 ,sizeof(sector_ende_63));
			chksum=chksum - 14;
		}

		normal_size = normal_size + ulen;
		lzo_size = lzo_size + plen;
	}

}

void usage()
{
	fprintf(stderr, "usage: mkflfs <type> [-o <outputfile> ] [<inputfile>]\n"
			"where type=1x or 2x\n");
	exit(1);
}

int main(int argc, char **argv)
{
	int i,ii,q;
	unsigned int size;
	char root_dir[] = {"root"};
	//char lostfound_dir[] = {"lost+found"};
	char platform_dir[] = {"platform"};
	char sagem_dbox2_dir[] = {"sagem-dbox2"};
	char nokia_dbox2_dir[] = {"nokia-dbox2"};
	char philips_dbox2_dir[] = {"philips-dbox2"};
	char mpc8xx_dbox2_dir[] = {"mpc8xx-dbox2"};
	char kernel_dir[] = {"kernel"};
	char os_file[] = {"os"};
	u8 tmp0[65536];
	u8 tmp1[65536];
	u8 bla2[4];

	if (argc < 2)
		usage();

	if (strcmp("1x",argv[1]) == 0)
		mode = 0;
	else if (strcmp("2x",argv[1]) == 0)
		mode = 1;
	else
		usage();

	if ((argc == 2) || strcmp(argv[2], "-o") != 0)
		strcpy(outputfilename, "flfs.img");
	else
	{
		if (argc < 4)
			usage();
		strcpy(outputfilename, argv[3]);
		argc -= 2;
		argv += 2;
	}

	strcpy(inputfilename, argc == 2 ? "test" : argv[2]);

	if (argc > 3)
		usage();

	size=read_from_file();

	if (mode==0)
	{
		data = 0;
		chksum = 131072;
		memcpy(&sector_00[0], superblock_1x, sizeof(superblock_1x) );
		data=data + sizeof(superblock_1x);
	}
	else
	{
		data = 0;
		chksum = 65536;
		memcpy(&sector_00[0], superblock_2x, sizeof(superblock_2x) );
		data=data + sizeof(superblock_2x);
	}


	memcpy(&sector_00[chksum - 14],sector_ende_00 ,sizeof(sector_ende_00));
	chksum=chksum - 14;
	blockNR++;
	dir_index(0x00,0x20,0);

	mkdir(root_dir,1,0,0);
	//mkdir(lostfound_dir,0,1,0);
	mkdir(root_dir,1,0,0);
	mkdir(platform_dir,1,0,0);

	mkdir(sagem_dbox2_dir,0,0,0);
	mkdir(kernel_dir,1,0,1);
	mkdir(nokia_dbox2_dir,0,0,0);
	mkdir(kernel_dir,1,0,1);
	mkdir(philips_dbox2_dir,0,0,0);
	mkdir(kernel_dir,1,0,1);
	mkdir(mpc8xx_dbox2_dir,0,0,0);
	mkdir(kernel_dir,1,0,1);
	mkdir(kernel_dir,1,0,1);

	mkfile(os_file,0,0,1);  //dummy os_file
	mkfile(os_file,input,size,0); //real os_file

	if (mode==0)
	{
		for(i=data;i<chksum;i++)
			sector_00[i]=0xff;
		sector_00[chksum]=0xfb;
		printf("1x flfs erstellt\n");
	}
	else
	{
		for(i=data;i<chksum;i++)
			sector_00[i]=0xff;
		sector_00[chksum]=0xfb;
		for(i=data_00;i<chksum_00;i++)
			sector_00[i]=0xff;
		sector_00[chksum_00]=0xfb;
		memcpy(&tmp0,&sector_00,65536);
		memcpy(&tmp1,&sector_00[65536],65536);
		q=0;
		for (ii=0; ii<64*1024;)
		{
			bla2[0]=tmp0[ii];
			bla2[1]=tmp0[ii+1];
			bla2[2]=tmp1[ii];
			bla2[3]=tmp1[ii+1];
			memcpy(&sector_00[q],&bla2,4);
			q=q+4;
			ii=ii+2;
		}
		printf("2x flfs erstellt\n");
	}

	printf("blockNR          : %d\n",blockNR);
	printf("normal_size  %d  lzo_size  %d\n",normal_size,lzo_size);

	if (lzo_size > 131072)
	{
		fprintf(stderr, "ERROR: lzo_size to big!\n");
		exit(3);
	}

	write_to_file();

	return 0;
}


