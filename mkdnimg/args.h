#ifndef _ARGS_H
#define _ARGS_H

#define AT_STRING	1
#define AT_BOOLEAN	2
#define AT_INT		3
#define AT_UINT		4

#ifndef TO_STRING
#define TO_STRING_1(x) #x
#define TO_STRING(x) TO_STRING_1(x)
#endif

#define define_main_argument(name,type,ptr)				\
static struct Arg_Desc _arg_desc_##name					\
	__attribute__((used,section("argument_struct"))) =		\
{									\
	TO_STRING(name),						\
	type,								\
	ptr								\
}

struct Arg_Desc
{
	char *what_to_get;
	int type;
	void *to_get;
};

extern struct Arg_Desc *argd;

extern int analize_args( int argc, char **argv );
extern void print_value( void );

#endif
