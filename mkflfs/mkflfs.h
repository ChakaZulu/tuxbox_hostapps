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
 *   input file-name "test"                 
 *   output file-name "flfs.img"
 *
 */


typedef unsigned char u8;

typedef struct {
	u8 to_next_dir_file_in_group[4] __attribute__ ((aligned (1),packed));
	u8 to_next_dir_file[4] __attribute__ ((aligned (1),packed));
	unsigned int syncFF __attribute__ ((aligned (1),packed));
	u8 typ __attribute__ ((aligned (1),packed));
	u8 flags __attribute__ ((aligned (1),packed));
	unsigned int datum __attribute__ ((aligned (1),packed));
	u8 garbage1[6] __attribute__ ((aligned (1),packed));
	u8 ka __attribute__ ((aligned (1),packed));
	u8 dir_type __attribute__ ((aligned (1),packed));
	u8 garbage2[8] __attribute__ ((aligned (1),packed));
	u8 laenge_dir __attribute__ ((aligned (1),packed));
} dirheader __attribute__ ((aligned (1),packed));

typedef struct {
	u8 to_next_dir_file_in_group[4] __attribute__ ((aligned (1),packed));
	u8 to_first_data_block[4] __attribute__ ((aligned (1),packed));
	unsigned int syncFF __attribute__ ((aligned (1),packed));
	u8 typ __attribute__ ((aligned (1),packed));
	u8 flags __attribute__ ((aligned (1),packed));	
	unsigned int datum __attribute__ ((aligned (1),packed));
        u8 garbage1[6] __attribute__ ((aligned (1),packed));
        u8 ka __attribute__ ((aligned (1),packed));
        u8 file_type __attribute__ ((aligned (1),packed));
        u8 garbage2[8] __attribute__ ((aligned (1),packed));
        u8 laenge_file __attribute__ ((aligned (1),packed));
} fileheader __attribute__ ((aligned (1),packed));

typedef struct {
	unsigned int syncFF __attribute__ ((aligned (1),packed));		//4
	unsigned short next_block_sector __attribute__ ((aligned (1),packed));	//2
	unsigned short next_block_block __attribute__ ((aligned (1),packed));	//2
	unsigned int syncFF2 __attribute__ ((aligned (1),packed));		//4
	unsigned char typ __attribute__ ((aligned (1),packed));			//1
	unsigned char typ2 __attribute__ ((aligned (1),packed));                //1
	unsigned int datum __attribute__ ((aligned (1),packed));		//4
	u8 garbage[4] __attribute__ ((aligned (1),packed));			//4
	unsigned int offset_im_file __attribute__ ((aligned (1),packed));	//4
	unsigned short ulen __attribute__ ((aligned (1),packed));		//2
	unsigned short plen __attribute__ ((aligned (1),packed));		//2
} data_block_header __attribute__ ((aligned (1),packed));

typedef struct {
	unsigned short sync __attribute__ ((aligned (1),packed));
	unsigned short offset __attribute__ ((aligned (1),packed));
	unsigned short len __attribute__ ((aligned (1),packed));
} dirindex;

