# DEFINES 
#  __CYGWIN__ 	      --- CYWIN - automatically
# __MACOSX___	      --- Macos - not automatically
# REENTRANT           --- Reentrant library modules Linux
# _LARGEFILE64SOURCE  --- Large file Linux
#
# Solaris
# GG_LIBS= -lpthread -lnsl -lrt -lsocket
# LDFLAGS= -s
#
# CYGWIN
# GG_LIBS=-lpthread  
#
#

CPPFLAGS=-DREENTRANT -D_LARGEFILE64_SOURCE  -Wall -Wshadow -W

LDFLAGS=-static -ggdb 

INSTALL=/usr/bin/install 
DESTDIR=/usr/local 

TARGETS=ggrab sserver vlog 

GG_INCS=list.h tools.h cbuffer.h Makefile
GG_OBJS=list.o cbuffer.o tools.o ggrab.o 
GG_LIBS=-lpthread  

all: $(TARGETS) 




ggrab: $(GG_OBJS) 
	$(CXX) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) -o $@ $(GG_OBJS) $(GG_LIBS) 


sserver: sserver.o
	$(CXX) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) sserver.cpp -o $@ $(GG_LIBS) 

ggrab.o: $(GG_INCS)

list.o: $(GG_INCS)

tools.o: $(GG_INCS)

clean: 
	rm -f $(TARGETS) *.o *~ 

install: 
	install -m755 $(TARGETS) $(DESTDIR)/bin 

uninstall: 
	cd $(DESTDIR)/bin && rm -f $(TARGETS) 

