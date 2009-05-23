#include <stdio.h>

#include "common.h"
#include "mkserialimg.h"
#include "crc32.h"
#include "main.h"
#include "args.h"

static char *model_name = "";

define_main_argument( model_name		, AT_STRING	, &model_name	);

int mkserialimg( void )
{
//	struct _serial_image_header header;
	struct DataHeader header;
	FILE *ifd;
	FILE *ofd;
	int filesize;
	int a;
	unsigned int readed;
	unsigned int crc;
	unsigned char buf[1024];
	int ret = 0;

	if( strlen(model_name)>30 )
	{
		errprintf( "model name is too long. max length is 30.\n" );
		return -1;
	}

	/*
	 * print verbose messate.
	 */
	dprintf( "input file     : %s\n", infile );
	dprintf( "output file    : %s\n", outfile );
	dprintf( "model_name     : \"%s\"\n", model_name );

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
	filesize = (filesize+1023)&~1023;

	dprintf( "data_size      : 0x%08x(%d)\n", filesize, filesize );

	memset( &header, 0x00, sizeof(header) );
	header.valid = 0x01;
	memcpy( header.model_name, model_name, strlen(model_name) );
	header.p_or_d = 0x01;
	header.da = 0xff;
	header.f_or_e = 0xff;
	header.size = htonl( filesize );
	header.dummy = 0xff;
	memset( buf, 0xff, 64 );
	memcpy( buf, &header, sizeof(header) );

	if( fwrite( buf, 1, 64, ofd ) != 64 )
	{
		errprintf( "write error.\n" );
		ret = -1;
		goto terminate;
	}

	for( a=0; a<filesize; a+=1024 )
	{
		readed = fread( buf, 1, 1024, ifd );
		if( readed == 0 )
		{
			ret = -1;
			errprintf( "read error.\n" );
			goto terminate;
		}
		if( readed != 1024 )
		{
			dprintf( "readed %d\n", (int)readed );
			memset( &buf[readed], 0, 1024-readed );
		}

		readed = fwrite( buf, 1, 1024, ofd );
		if( readed != 1024 )
		{
			ret = -1;
			errprintf( "write error.\n" );
			goto terminate;
		}
	}

terminate:
	fclose( ifd );
	fclose( ofd );

	return ret;
}
