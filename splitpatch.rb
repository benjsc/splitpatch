#!/usr/bin/env ruby
#
#   Copyright
#
#       Copyright (C) 2007 Peter Hutterer <peter@cs.unisa.edu.au>
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
#  Description
#
#       Splitpatch is a simple script to split a patch up into
#       multiple patch files. If the --hunks option is provided on the
#       command line, each hunk gets its own patchfile.

class Splitter
    def initialize(file)
       @filename = file
       @fullname = false
    end

    def fullname(opt)
       @fullname = opt
    end

    def validFile?
        return File.exist?(@filename) && File.readable?(@filename)
    end

    def createFile(filename)
        if File.exists?(filename)
            puts "File #{filename} already exists. Renaming patch."
            appendix = 0
            while File.exists?("#{filename}.#{appendix}")
                appendix += 1
            end
            filename << ".#{appendix}"
        end
        return open(filename, "w")
    end

    def getFilename(line)
        tokens = line.split(" ")
        tokens = tokens[1].split(":")
        tokens = tokens[0].split("/")
        if @fullname
            return tokens.join('-')
        else
            return tokens[-1]
        end
    end

    # Split the patchfile by files 
    def splitByFile
        legacy = false
        outfile = nil
        stream = open(@filename)
        until (stream.eof?)
            line = stream.readline

            # we need to create a new file
            if (line =~ /^Index: .*/) == 0
                # patch includes Index lines
                # drop into "legacy mode"
                legacy = true
                if (outfile)
                    outfile.close_write
                end
                filename = getFilename(line)
                filename << ".patch"
                outfile = createFile(filename)
                outfile.write(line)
            elsif (line =~ /--- .*/) == 0 and not legacy
                if (outfile) 
                    outfile.close_write
                end
                #find filename
                filename = getFilename(line)
                filename << ".patch"
                outfile = createFile(filename)
                outfile.write(line)
            else
                if outfile
                    outfile.write(line)
                end
            end
        end
    end

    def splitByHunk
        legacy = false
        outfile = nil
        stream = open(@filename)
        filename = ""
        counter = 0
        header = ""
        until (stream.eof?)
            line = stream.readline

            # we need to create a new file
            if (line =~ /^Index: .*/) == 0
                # patch includes Index lines
                # drop into "legacy mode"
                legacy = true
                filename = getFilename(line)
                header = line
                # remaining 3 lines of header
                for i in 0..2
                    line = stream.readline
                    header << line
                end
                counter = 0
            elsif (line =~ /--- .*/) == 0 and not legacy
                #find filename
                filename = getFilename(line)
                header = line
                # next line is header too
                line = stream.readline
                header << line
                counter = 0
            elsif (line =~ /@@ .* @@/) == 0
                if (outfile) 
                    outfile.close_write
                end
                hunkfilename = "#{filename}.#{counter}.patch"
                outfile = createFile(hunkfilename)
                counter += 1

                outfile.write(header)
                outfile.write(line)
            else
                if outfile
                    outfile.write(line)
                end
            end
        end
    end

end


########################     MAIN     ########################


if ARGV.length < 1 or ARGV.length > 3
    puts "Wrong parameter. Usage: splitpatch.rb [--fullname] [--hunks] <patchfile>"
    exit 1
elsif ARGV[0] == "--help"
    puts "splitpatch splits a patch that is supposed to patch multiple files"
    puts "into a set of patches."
    puts "Currently splits unified diff patches."
    puts "If the --hunk option is given, a new file is created for each hunk."
    puts "If the --fullname option is given, new files are named using the"
    puts "full path of the patch to avoid duplicates in large projects."
    exit 1
else
    s = Splitter.new(ARGV[-1])
    if s.validFile?
        if ARGV[0] == "--fullname" or ARGV[1] == "--fullname"
            s.fullname(true)
        end

        if ARGV[0] == "--hunks" or ARGV[1] == "--hunks"
            s.splitByHunk
        else
            s.splitByFile
        end
    else
        puts "File does not exist or is not readable"
    end
end



