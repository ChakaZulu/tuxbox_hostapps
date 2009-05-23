TARGET = appendbin
OBJS = main.o
SRCS = $(OBJS:.o=.c)

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $<

.c.o:
	$(CC) $(CFLAGS) -c -o $@ $<

install: all
	install -d $(INSTALLDIR)
	install $(TARGET) $(INSTALLDIR)

clean:
	rm -f $(TARGET) $(OBJS)

.depend dep:
	$(CC) -M $(SRCS) > .depend

ifneq ($(wildcard .depend),)
include .depend
endif
