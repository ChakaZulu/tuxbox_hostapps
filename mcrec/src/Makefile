SHELL = /bin/sh


subdirs = @subdirs@
top_srcdir = .
srcdir = .
prefix = /usr/local
exec_prefix = ${prefix}
bindir = $(exec_prefix)/bin
infodir = $(prefix)/info
libdir = $(prefix)/lib/gnudl
datadir= ${prefix}/share
mandir = $(prefix)/man/man1

CC = gcc
CXX = g++
CPPFLAGS = 
CFLAGS = $(CPPFLAGS) -g -O2
LDFLAGS = 
LIBS = -lpthread -lnsl 
INSTALL = /usr/bin/install -c

all: mcrec

Remuxer.o: Remuxer.cpp Remuxer.h
	$(CXX) -c Remuxer.cpp -o Remuxer.o -Wall $(OPT)

SigHandler.o: SigHandler.cpp SigHandler.h
	$(CXX) -c SigHandler.cpp -o SigHandler.o -Wall $(OPT)

StopWatch.o: StopWatch.cpp StopWatch.h
	$(CXX) -c StopWatch.cpp -o StopWatch.o -Wall $(OPT)

SongDB.o: SongDB.cpp SongDB.h
	$(CXX) -c SongDB.cpp -o SongDB.o -Wall $(OPT)

mcrec: mcrec.cpp Remuxer.o SigHandler.o StopWatch.o SongDB.o
	$(CXX) -c mcrec.cpp -Wall -o mcrec.o
	$(CXX) mcrec.o Remuxer.o SigHandler.o StopWatch.o SongDB.o -o mcrec -Wall $(LIBS)

dist: mcrec.cpp Remuxer.o SigHandler.o StopWatch.o SongDB.o
	$(CXX) -c mcrec.cpp -Wall -o mcrec.o $(OPT)
	$(CXX) mcrec.o Remuxer.o SigHandler.o StopWatch.o SongDB.o -o ../mcrec -Wall $(LIBS)
	strip ../mcrec

.PHONY : clean distclean
clean:
	-rm -f mcrec
	-rm -f *.o

distclean:
	-rm -f mcrec
	-rm -f *.o
	-rm -f Makefile config.status config.log config.h

