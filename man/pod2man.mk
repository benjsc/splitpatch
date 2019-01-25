# pod2man.mk -- Makefile portion to convert *.pod files to manual pages
#
#   Copyright information
#
#	Copyright (C) 2008-2013 Jari Aalto
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
# 	Convert *.pod files to manual pages. Write this to 'install'
# 	target:
#
#       install: build $(MANPAGE)

ifneq (,)
    This makefile requires GNU Make.
endif

# This variable *must* be set when calling
PACKAGE		?= package
RELEASE         ?= $(PACKAGE)

# Optional variables to set
MANSECT		?= 1

DATE_FMT = %Y-%m-%d
ifdef SOURCE_DATE_EPOCH
PODCENTER	?= $$(shell date -u -d "@$(SOURCE_DATE_EPOCH)" "+$(DATE_FMT)" 2>/dev/null || date -u -r "$(SOURCE_DATE_EPOCH)" "+$(DATE_FMT)" 2>/dev/null || date -u "+$(DATE_FMT)")
else
PODCENTER	?= $$(date "$(DATE_FMT)")
endif

# Directories
MANSRC		=
MANDEST		= $(MANSRC)

MANPOD		= $(MANSRC)$(PACKAGE).$(MANSECT).pod
MANPAGE		= $(MANDEST)$(PACKAGE).$(MANSECT)

POD2MAN		= pod2man
POD2MAN_FLAGS	= --utf8

makeman: $(MANPAGE)

$(MANPAGE): $(MANPOD)
	# make target - create manual page from a *.pod page
	podchecker $(MANPOD)
	LC_ALL=C $(POD2MAN) $(POD2MAN_FLAGS) \
		--center="$(PODCENTER)" \
		--name="$(PACKAGE)" \
		--section="$(MANSECT)" \
                --release="$(RELEASE)" \
		$(MANPOD) \
	        > $(MANPAGE) && \
	rm -f pod*.tmp

# End of of Makefile part
