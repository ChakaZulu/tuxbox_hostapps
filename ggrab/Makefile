# DEFINES 
#  __CYGWIN__ 	      --- CYWIN - automatically
# __MACOSX___	      --- Macos - not automatically
# REENTRANT           --- Reentrant library modules Linux
# _LARGEFILE64SOURCE  --- Large file Linux
#

CPPFLAGS=-DREENTRANT -D_LARGEFILE64_SOURCE 
LDFLAGS=-static -s 

INSTALL=/usr/bin/install 
DESTDIR=/usr/local 

TARGETS=ggrab sserver vlog 

GG_INCS=list.h tools.h cbuffer.h
GG_OBJS=list.o cbuffer.o tools.o ggrab.o 
GG_LIBS=-lpthread 

all: $(TARGETS) 


ggrab: $(GG_OBJS) 
	$(CXX) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) -o $@ $(GG_OBJS) $(GG_LIBS) 


ggrab.o: $(GG_INCS)

list.o: $(GG_INCS)

tools.o: $(GG_INCS)

clean: 
	rm -f $(TARGETS) *.o *~ 

install: 
	install -m755 $(TARGETS) $(DESTDIR)/bin 

uninstall: 
	cd $(DESTDIR)/bin && rm -f $(TARGETS) 

