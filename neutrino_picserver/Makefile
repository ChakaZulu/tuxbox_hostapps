CFLAGS = -O3 -I. -g

picserver: picserver.o
	$(CC) -o picserver picserver.o -ljpeg -lpthread

picserver.o: picserver.c picv_client_server.h
	$(CC) $(CFLAGS) -c picserver.c

clean:
	rm -f picserver picserver.o
