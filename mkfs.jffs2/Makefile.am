bin_PROGRAMS = mkfs.jffs2

mkfs_jffs2_SOURCES = mkfs.jffs2.c compr_zlib.c compr_rtime.c compr_lzari.c crc32.c compr.c compr_lzo.c \
	compr_lzma.c

mkfs_jffs2_LDADD = -lz ${libdir}/liblzma465.a

INCLUDES = -Iinclude -I${includedir}/lzma465
