target = mkdnimg
objs = main.o args.o mkusbimg.o crc32.o mkserialimg.o
cc = gcc

all: $(target)

$(target): $(objs)
	$(cc) $(cflags) -o $@ $^

.c.o:
	$(cc) $(cflags) -c -o $@ $<

install: all
	install -d $(INSTALLDIR)
	install $(target) $(INSTALLDIR)

clean:
	rm -f $(target) $(objs)

dep:
	$(cc) $(cflags) -M $(objs:.o=.c) > .depend

ifneq ($(wildcard .depend),)
include .depend
endif
