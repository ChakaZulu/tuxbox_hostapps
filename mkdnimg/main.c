#include <stdio.h>

#include "common.h"
#include "args.h"
#include "main.h"
#include "mkusbimg.h"
#include "mkserialimg.h"

static char	*make		= "";
int		debug		= 0;
char		*infile		= "";
char		*outfile	= "";

define_main_argument( debug		, AT_BOOLEAN	, &debug	);
define_main_argument( make		, AT_STRING	, &make		);
define_main_argument( infile		, AT_STRING	, &infile	);
define_main_argument( input		, AT_STRING	, &infile	);
define_main_argument( outfile		, AT_STRING	, &outfile	);
define_main_argument( output		, AT_STRING	, &outfile	);

int main( int argc, char *argv[] )
{
	int ret = 0;

	if( analize_args( argc, argv ) )
		return -1;

	if( !strcmp( "usbimg", make ) )
		ret = mkusbimg();
	else if( !strcmp( "usbimg_old", make ) )
		ret = mkusbimg_old();
	else if( !strcmp( "serialimg", make ) )
		ret = mkserialimg();
	else
		errprintf( "unknown option\n" );

	return ret;
}
