# DEFINES 
#  __CYGWIN__ 	      --- CYWIN - automatically
# __MACOSX___	      --- Macos - not automatically
# REENTRANT           --- Reentrant library modules Linux
# _LARGEFILE64SOURCE  --- Large file Linux
#

all: ggrab sserver

GCC=g++ -ggdb -DREENTRANT -D_LARGEFILE64_SOURCE 


ggrab: ggrab.cpp list.cpp list.cpp cbuffer.cpp cbuffer.h tools.cpp tools.h Makefile
	$(GCC) ggrab.cpp list.cpp cbuffer.cpp tools.cpp -o ggrab -lpthread 

sserver: sserver.cpp sserver.h Makefile
	$(GCC) sserver.cpp -o sserver 
