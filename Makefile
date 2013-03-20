# ;
# Makefile:
#	wiringPi - Wiring Compatable library for the Raspberry Pi
#
#	Copyright (c) 2012 Gordon Henderson
#################################################################################
# This file is part of wiringPi:
#	https://projects.drogon.net/raspberry-pi/wiringpi/
#
#    wiringPi is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Lesser General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    wiringPi is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Lesser General Public License for more details.
#
#    You should have received a copy of the GNU Lesser General Public License
#    along with wiringPi.  If not, see <http://www.gnu.org/licenses/>.
#################################################################################

DYN_VERS_MAJ=1
DYN_VERS_MIN=0

VERSION=$(DYN_VERS_MAJ).$(DYN_VERS_MIN)
DESTDIR=/usr
PREFIX=/local

DEBUG	= -g -O0
#DEBUG	= -O2
CC	= gcc
INCLUDE	= -I.
CFLAGS	= $(DEBUG) -Wall $(INCLUDE) -Winline -pipe -fPIC

LDFLAGS	= -L/usr/local/lib
LDLIBS    = -lwiringPi -lpthread -lm

LIBS    =

# Should not alter anything below this line
###############################################################################

SRC	=	wiringPi.c \
		wiringPiSPI.c 						\
		bit_array.c test.c

#SRC_I2C	=	wiringPiI2C.c

OBJ	=	$(SRC:.c=.o)

#OBJ_I2C	=	$(SRC_I2C:.c=.o)

all:		$(DYNAMIC) test

static:		$(STATIC)

test:	test.o wiringPi.o wiringPiSPI.o bit_array.o
	@echo [link]
	@$(CC) -o $@ test.o wiringPi.o wiringPiSPI.o bit_array.o $(LDFLAGS) $(LDLIBS)

$(STATIC):	$(OBJ)
	@echo "[Link (Static)]"
	@ar rcs $(STATIC) $(OBJ)
	@ranlib $(STATIC)
#	@size   $(STATIC)

.c.o:
	@echo [Compile] $<
	@$(CC) -c $(CFLAGS) $< -o $@

.PHONEY:	clean
clean:
	rm -f $(OBJ) $(OBJ_I2C) *~ core tags Makefile.bak

.PHONEY:	tags
tags:	$(SRC)
	@echo [ctags]
	@ctags $(SRC)

.PHONEY:	depend
depend:
	makedepend -Y $(SRC) $(SRC_I2C)

# DO NOT DELETE

wiringPi.o: wiringPi.h
wiringPiSPI.o: wiringPiSPI.h
bit_array.o: bit_array.h
