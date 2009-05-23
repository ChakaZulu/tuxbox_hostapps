#include <stdio.h>

int main( int argc, char **argv )
{
	FILE *out, *in;
	int size;
	char buffer[65536];
	int a;
	size_t readed;
	int ret = 0;
	unsigned int bs=0x10000;

	while( argv[1][0] == '-' )
	{
		if( !strncmp(&argv[1][1],"bs",2) )
		{
			bs=strtoul(&argv[1][4],NULL,0);
			argv ++;
			argc --;
		}
		else
			break;
	}

	if( argc < 4 )
	{
		fprintf( stderr, "#> appendbin [-bs=block_size] appendto binfile size\n" );
		fprintf( stderr, "   size must be multiple of 65536...\n" );
		return -1;
	}
	out = fopen( *(argv+1), "ab" );
	if( out == NULL )
	{
		fprintf( stderr, "cannot open output file...(%s)\n", *(argv+1) );
		return -1;
	}

	in = fopen( *(argv+2), "rb" );
	if( in == NULL )
	{
		fprintf( stderr, "cannot open input file...(%s)\n", *(argv+2) );
		fclose( out );
		return -1;
	}

	size = strtoul( *(argv+3), NULL, 0 );

//	fprintf( stderr, "%d(0x%x) blocks\n", size, size );
	fseek( in, 0, SEEK_END );
	if( ftell(in) > size*bs )
	{
		fprintf( stderr, "Oops. file is too big.\n" );
		ret = -1;
		goto terminate;
	}
	fseek( in, 0, SEEK_SET );

	for( a=0; a<size; a++ )
	{
		readed = fread( buffer, 1, bs, in );

		if( readed )
			fwrite( buffer, 1, readed, out );
		if( readed < bs )
		{
			memset( buffer, 0xff, bs-readed );
			fwrite( buffer, 1, bs-readed, out );
		}
	}

terminate:
	fclose( in );
	fclose( out );

	return ret;
}
