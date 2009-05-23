#ifndef _MKSERIALIMG_H
#define _MKSERIALIMG_H

#pragma pack(1)
struct DataHeader
{
	char valid;
	char model_name[30];
	char p_or_d;
	char da;
	char f_or_e;
	unsigned int size;
	char dummy;
};

struct _serial_image_header
{
	unsigned int header_crc32;
	unsigned int image_size;
};
#pragma pack()

extern int mkserialimg( void );

#endif

