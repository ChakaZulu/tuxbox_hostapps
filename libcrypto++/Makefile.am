lib_LTLIBRARIES = libcrypto++.la

libcrypto___la_SOURCES = \
	bio.cpp \
	evp.cpp \
	lib.cpp \
	rand.cpp \
	rsa.cpp \
	x509.cpp

libcrypto___la_LDFLAGS = -lcrypto

INCLUDES = -I$(top_builddir)/../apps -I$(top_builddir)/../apps/libcrypto++
AM_CXXFLAGS = -fno-rtti

mostlyclean-local:
	@rm -r *.cpp

$(libcrypto___la_SOURCES):
	@ln -s $(top_builddir)/../apps/libcrypto++/$@
