# DEFINES 
#  __CYGWIN__ 	      --- CYWIN - automatically
# __MACOSX___	      --- Macos - not automatically
# REENTRANT           --- Reentrant library modules Linux
# _LARGEFILE64SOURCE  --- Large file Linux
#

PATH := $(hostprefix)/bin:$(PATH)
BUILDENV := \
	AR=$(target)-ar \
	AS=$(target)-as \
	CC=$(target)-gcc \
	CXX=$(target)-g++ \
	NM=$(target)-nm \
	RANLIB=$(target)-ranlib \
	CFLAGS="$(TARGET_CFLAGS)" \
	CXXFLAGS="$(TARGET_CFLAGS)" \
	LDFLAGS="$(TARGET_LDFLAGS)" \
	PKG_CONFIG_PATH=$(targetprefix)/lib/pkgconfig

AM_CPPFLAGS = -DREENTRANT -D_LARGEFILE64_SOURCE

bin_PROGRAMS = ggrab sserver

EXTRA_DIST = cbuffer.h list.h sserver.h tools.h pesstream.h

ggrab_SOURCES = cbuffer.cpp ggrab.cpp list.cpp tools.cpp pesstream.cpp
ggrab_LDADD = -lpthread -lnsl
sserver_SOURCES = sserver.cpp
