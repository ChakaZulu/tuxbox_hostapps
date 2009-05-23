#include <stdio.h>

#include "common.h"
#include "mkusbimg.h"
#include "main.h"
#include "crc32.h"
#include "args.h"

#define IMG_MAGIC	(('F'<<24)|('i'<<16)|('m'<<8)|('g'<<0))

#define DATA_OFFSET	0x1000
#define BUF_SIZE	DATA_OFFSET		// must be same with data_offset???
#define HEADER_SIZE	DATA_OFFSET
#define H_NAME_SIZE	32

struct _image_header
{
	unsigned int header_crc;	/* crc from 4 ~ HEADER_SIZE */
	unsigned int magic;		/* magic number. IMG_MAGIC */
	unsigned int structure_size;	/* size of this structure */

	unsigned int vendor_id;		/* vender id */
	unsigned int product_id;	/* product id */

	unsigned int hw_model;		/* MY_HW_MODEL */
	unsigned int hw_version;

	unsigned int start_addr;	/* start address of write to flash. */
	unsigned int erase_size;	/* erase size from start_addr */

	unsigned int data_offset;	/* offset of acture data */
	unsigned int data_size;		/* size of acture data */
	unsigned int data_crc;		/* crc from data_offset ~ (data_offset+data_size) */

	char name[H_NAME_SIZE];		/* name of this image */
};

struct _image_header_old
{
	unsigned int header_crc;
	unsigned int magic;
	unsigned int structure_size;

	unsigned int vendor_id;
	unsigned int product_id;

	unsigned int hw_model;
	unsigned int hw_version;
	unsigned int sw_model;
	unsigned int sw_version;

	unsigned int data_offset;
	unsigned int data_size;
	unsigned int data_crc;
};

static unsigned int vendor_id;
static unsigned int product_id;
static unsigned int hw_model;
static unsigned int hw_version;
static unsigned int sw_model;
static unsigned int sw_version;
static unsigned int start_addr;
static unsigned int erase_size;
static char *image_name = "";

define_main_argument( vendor_id		, AT_UINT	, &vendor_id	);
define_main_argument( product_id	, AT_UINT	, &product_id	);
define_main_argument( hw_model		, AT_UINT	, &hw_model	);
define_main_argument( hw_version	, AT_UINT	, &hw_version	);
define_main_argument( sw_model		, AT_UINT	, &sw_model	);
define_main_argument( sw_version	, AT_UINT	, &sw_version	);
define_main_argument( start_addr	, AT_UINT	, &start_addr	);
define_main_argument( erase_size	, AT_UINT	, &erase_size	);
define_main_argument( image_name	, AT_STRING	, &image_name	);

int mkusbimg( void )
{
	struct _image_header header;
	FILE *ifd;
	FILE *ofd;
	int filesize;
	int a;
	unsigned int readed;
	unsigned int crc;
	unsigned char buf[BUF_SIZE];
	int ret = 0;

	/*
	 * print verbose messate.
	 */
	dprintf( "input file     : %s\n", infile );
	dprintf( "output file    : %s\n", outfile );
	dprintf( "structure_size : 0x%08x\n", sizeof(struct _image_header) );
	dprintf( "vendor_id      : 0x%08x\n", vendor_id );
	dprintf( "product_id     : 0x%08x\n", product_id );
	dprintf( "hw_model       : 0x%08x\n", hw_model );
	dprintf( "hw_version     : 0x%08x\n", hw_version );
	dprintf( "start_addr     : 0x%08x\n", start_addr );
	dprintf( "erase_size     : 0x%08x\n", erase_size);
	dprintf( "data_offset    : 0x%08x\n", DATA_OFFSET );

	/*
	 * open input file and output file.
	 */
	ifd = fopen( infile, "rb" );
	if( ifd == NULL )
	{
		errprintf( "input file open error.\n" );
		return -1;
	}

	ofd = fopen( outfile, "wb" );
	if( ofd == NULL )
	{
		errprintf( "output file open error.\n" );
		fclose( ofd );
		return -1;
	}

	/*
	 * get input filesize.
	 */
	fseek( ifd, 0, SEEK_END );
	filesize = ftell( ifd );
	fseek( ifd, 0, SEEK_SET );

	dprintf( "data_size      : 0x%08x(%d)\n", filesize, filesize );

	/*
	 * reserve image header
	 * and write image body.
	 * additionally calculate crc.
	 */
	crc = 0xffffffff;
//	fwrite( buf, 1, DATA_OFFSET, ofd );
	fseek( ofd, DATA_OFFSET, SEEK_SET );
	for( a=0; a<filesize; )
	{
		readed = fread( buf, 1, BUF_SIZE, ifd ); 
		if( readed == 0 )
		{
			errprintf( "file read error.\n" );
			ret = -1;
			goto terminate;
		}
		
		crc = crc32( crc, buf, readed );

		if( fwrite( buf, 1, readed, ofd ) != readed )
		{
			errprintf( "file write error.\n" );
			ret = -1;
			goto terminate;
		}

		a += readed;
	}

	dprintf( "data_crc       : 0x%08x\n", crc );

	/*
	 * move filepointer to first and write image header.
	 */
	header.magic = htonl( IMG_MAGIC );
	header.structure_size = htonl( sizeof(struct _image_header) );
	header.vendor_id = htonl( vendor_id );
	header.product_id = htonl( product_id );
	header.hw_model = htonl( hw_model );
	header.hw_version = htonl( hw_version );
	header.start_addr = htonl( start_addr );
	header.erase_size = htonl( erase_size );
	header.data_offset = htonl( DATA_OFFSET );
	header.data_size = htonl( filesize );
	header.data_crc = htonl( crc );
	strncpy( header.name, image_name, H_NAME_SIZE );
	header.name[H_NAME_SIZE-1] = 0;

	memset( buf, 0, BUF_SIZE );
	memcpy( buf, &header, sizeof(header) );
	crc=crc32( 0xffffffff, buf+4, BUF_SIZE-4 );
	header.header_crc = htonl( crc );
	memcpy( buf, &header, 4 );

	fseek( ofd, 0, SEEK_SET );
	fwrite( buf, 1, BUF_SIZE, ofd );

	dprintf( "header_crc     : 0x%08x\n", crc );

terminate:
	/*
	 * finally, close file pointer.
	 */
	fclose( ifd );
	fclose( ofd );

	return ret;
}

int mkusbimg_old( void )
{
	struct _image_header_old header;
	FILE *ifd;
	FILE *ofd;
	int filesize;
	int a;
	unsigned int readed;
	unsigned int crc;
	unsigned char buf[BUF_SIZE];
	int ret = 0;

	/*
	 * print verbose messate.
	 */
	dprintf( "input file     : %s\n", infile );
	dprintf( "output file    : %s\n", outfile );
	dprintf( "structure_size : 0x%08x\n", sizeof(struct _image_header_old) );
	dprintf( "vendor_id      : 0x%08x\n", vendor_id );
	dprintf( "product_id     : 0x%08x\n", product_id );
	dprintf( "hw_model       : 0x%08x\n", hw_model );
	dprintf( "hw_version     : 0x%08x\n", hw_version );
	dprintf( "sw_model       : 0x%08x\n", sw_model );
	dprintf( "sw_version     : 0x%08x\n", sw_version);
	dprintf( "data_offset    : 0x%08x\n", DATA_OFFSET );

	/*
	 * open input file and output file.
	 */
	ifd = fopen( infile, "rb" );
	if( ifd == NULL )
	{
		errprintf( "input file open error.\n" );
		return -1;
	}

	ofd = fopen( outfile, "wb" );
	if( ofd == NULL )
	{
		errprintf( "output file open error.\n" );
		fclose( ofd );
		return -1;
	}

	/*
	 * get input filesize.
	 */
	fseek( ifd, 0, SEEK_END );
	filesize = ftell( ifd );
	fseek( ifd, 0, SEEK_SET );

	dprintf( "data_size      : 0x%08x(%d)\n", filesize, filesize );

	/*
	 * reserve image header
	 * and write image body.
	 * additionally calculate crc.
	 */
	crc = 0xffffffff;
//	fwrite( buf, 1, DATA_OFFSET, ofd );
	fseek( ofd, DATA_OFFSET, SEEK_SET );
	for( a=0; a<filesize; )
	{
		readed = fread( buf, 1, BUF_SIZE, ifd ); 
		if( readed == 0 )
		{
			errprintf( "file read error.\n" );
			ret = -1;
			goto terminate;
		}
		
		crc = crc32( crc, buf, readed );

		if( fwrite( buf, 1, readed, ofd ) != readed )
		{
			errprintf( "file write error.\n" );
			ret = -1;
			goto terminate;
		}

		a += readed;
	}

	dprintf( "data_crc       : 0x%08x\n", crc );

	/*
	 * move filepointer to first and write image header.
	 */
	header.magic = htonl( IMG_MAGIC );
	header.structure_size = htonl( sizeof(struct _image_header_old) );
	header.vendor_id = htonl( vendor_id );
	header.product_id = htonl( product_id );
	header.hw_model = htonl( hw_model );
	header.hw_version = htonl( hw_version );
	header.sw_model = htonl( sw_model );
	header.sw_version = htonl( sw_version );
	header.data_offset = htonl( DATA_OFFSET );
	header.data_size = htonl( filesize );
	header.data_crc = htonl( crc );

	memset( buf, 0, BUF_SIZE );
	memcpy( buf, &header, sizeof(header) );
	crc=crc32( 0xffffffff, buf+4, BUF_SIZE-4 );
	header.header_crc = htonl( crc );
	memcpy( buf, &header, 4 );

	fseek( ofd, 0, SEEK_SET );
	fwrite( buf, 1, BUF_SIZE, ofd );

	dprintf( "header_crc     : 0x%08x\n", crc );

terminate:
	/*
	 * finally, close file pointer.
	 */
	fclose( ifd );
	fclose( ofd );

	return ret;
}
