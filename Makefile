#!/usr/bin/make -f
#
#   Copyright
#
#	Copyright (C) 2014 Jari Aalto <jari.aalto@cante.net>
#
#   License
#
#       This program is free software; you can redistribute it and/or modify
#       it under the terms of the GNU General Public License as published by
#       the Free Software Foundation; either version 2 of the License, or
#       (at your option) any later version.
#
#       This program is distributed in the hope that it will be useful,
#       but WITHOUT ANY WARRANTY; without even the implied warranty of
#       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#       GNU General Public License for more details.
#
#       You should have received a copy of the GNU General Public License
#       along with this program. If not, see <http://www.gnu.org/licenses/>.
#
#   Description
#
#       A Ruby program. Nothing to compile

ifneq (,)
This makefile requires GNU Make.
endif

PACKAGE		= splitpatch
VERSION		=

DESTDIR		=
prefix		= /usr
exec_prefix	= $(prefix)
man_prefix	= $(prefix)/share
mandir		= $(man_prefix)/man
bindir		= $(exec_prefix)/bin
sharedir	= $(prefix)/share

BINDIR		= $(DESTDIR)$(bindir)
DOCDIR		= $(DESTDIR)$(sharedir)/doc

# 1 = regular, 5 = conf, 6 = games, 8 = daemons
MANDIR		= $(DESTDIR)$(mandir)
MANDIR1		= $(MANDIR)/man1

INSTALL		= /usr/bin/install
INSTALL_BIN	= $(INSTALL) -m 755
INSTALL_DATA	= $(INSTALL) -m 644
INSTALL_SUID	= $(INSTALL) -m 4755

SRCS		= $(PACKAGE).rb

all: doc

clean:
	# clean
	-rm -f *[#~] *.\#*
	$(MAKE) -C man $@

distclean: clean

realclean: clean

doc:
	$(MAKE) -C man all

install-man: doc
	# install-man
	$(INSTALL_BIN) -d $(MANDIR1)
	$(INSTALL_DATA) man/*.1 $(MANDIR1)

install-bin:
	# install-bin
	$(INSTALL_BIN) -d $(BINDIR)
	$(INSTALL_BIN) $(PACKAGE).rb $(BINDIR)/$(PACKAGE)

install: install-bin install-man

.PHONY: all doc
.PHONY: clean distclean realclean install install-bin install-man

# End of file
