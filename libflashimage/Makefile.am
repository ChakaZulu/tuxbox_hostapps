lib_LTLIBRARIES = libflashimage.la

libflashimage_la_SOURCES = \
	flashimage.cpp \
	flashimagearchive.cpp

libflashimage_la_LIBADD = $(top_builddir)/libcrypto++/libcrypto++.la

INCLUDES = -I$(top_builddir)/../apps -I$(top_builddir)/../apps/libflashimage
AM_CXXFLAGS = -fno-rtti

$(top_builddir)/libcrypto++/libcrypto++.la:
	$(MAKE) -C $(top_builddir)/libcrypto++

mostlyclean-local:
	@rm -r *.cpp

$(libflashimage_la_SOURCES):
	@ln -s $(top_builddir)/../apps/libflashimage/$@
