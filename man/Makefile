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
#       Generate manual page form Perl POD file.

PACKAGE = splitpatch

all:
	$(MAKE) -f pod2man.mk PACKAGE=$(PACKAGE) makeman

clean:
	rm -f *.1

.PHONY: all

# End of file
