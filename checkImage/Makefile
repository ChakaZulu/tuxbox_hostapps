# $Id: Makefile,v 1.3 2005/07/29 23:31:34 mogway Exp $
#
# Copyright (C) 2005 mogway <mogway@yadi.org>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
# Or, point your browser to http://www.gnu.org/copyleft/gpl.html
#
#

BINNAME			= checkImage
SRCS			= checkImage.c
INSTALLDIR		= /usr/local/bin
CC			= g++
STRIP			= strip
CFLAGS			= -Wall -O3 -I. -g
#CFLAGS			= -Wall -mcpu=823 -mmultiple -mstring -meabi -pipe -Os
LDFLAGS			= -g
OBJS 			= $(SRCS:%.c=%.o)
#OBJS 			= $(SRCS:%.cpp=%.o)
DISTFILES 		= $(SRCS)

all: $(BINNAME)

.c.o:
	$(CC) -c -I. $(CPPFLAGS) $(CFLAGS) $<

$(BINNAME): $(OBJS)
	$(CC) $(LDFLAGS) $(OBJS) $(LIBCRYPT) -o $@

install: $(BINNAME)
	$(STRIP) $(BINNAME)
	cp $(BINNAME) $(INSTALLDIR)/$(BINNAME)

uninstall:
	if [ -e $(INSTALLDIR)/$(BINNAME) ]; then rm $(INSTALLDIR)/$(BINNAME); fi

clean:
	rm -f $(BINNAME) *.o
