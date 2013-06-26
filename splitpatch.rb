#!/usr/local/bin/ruby 
#
# splitpatch is a simple script to split a patch up into multiple patch files.
# if the --hunks option is provided on the command line, each hunk gets its
# own patchfile.
#
# Copyright (C) 2007, Peter Hutterer <peter@cs.unisa.edu.au>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
#
# 
class Splitter
   def initialize(file)
       @filename = file
    end

    def validFile?
        return File.exist?(@filename) && File.readable?(@filename)
    end

    # Split the patchfile by files 
    def splitByFile
        outfile = nil
        stream = open(@filename)
        until (stream.eof?)
            line = stream.readline

            # we need to create a new file
            if (line =~ /--- .*/) == 0
                if (outfile) 
                    outfile.close_write
                end
                #find filename
                tokens = line.split(" ")
                tokens = tokens[1].split(":")
                tokens = tokens[0].split("/")
                filename = tokens[-1]
                filename << ".patch"
                if File.exists?(filename)
                    puts "File #{filename} already exists. Renaming patch."
                    appendix = 0
                    while File.exists?("#{filename}.#{appendix}")
                        appendix += 1
                    end
                    filename << ".#{appendix}"
                end
                outfile = open(filename, "w")
                outfile.write(line)
            else
                if outfile
                    outfile.write(line)
                end
            end
        end
    end

    def splitByHunk
        outfile = nil
        stream = open(@filename)
        filename = ""
        counter = 0
        header = ""
        until (stream.eof?)
            line = stream.readline

            # we need to create a new file
            if (line =~ /--- .*/) == 0
                #find filename
                tokens = line.split(" ")
                tokens = tokens[1].split(":")
                tokens = tokens[0].split("/")
                filename = tokens[-1]
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
                if File.exists?(hunkfilename)
                    puts "File #{hunkfilename} already exists. Renaming patch."
                    appendix = 0
                    while File.exists?("#{hunkfilename}.#{appendix}")
                        appendix += 1
                    end
                    hunkfilename << ".#{appendix}"
                end
                outfile = open(hunkfilename, "w")
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


if ARGV.length < 1 or ARGV.length > 2
    puts "Wrong parameter. Usage: splitpatch.rb [--hunks] <patchfile>"
    exit 1
elsif ARGV[0] == "--help"
    puts "splitpatch splits a patch that is supposed to patch multiple files"
    puts "into a set of patches."
    puts "Currently splits unified diff patches."
    puts "If the --hunk option is given, a new file is created for each hunk."
    exit 1
else
    s = Splitter.new(ARGV[-1])
    if s.validFile?
        if ARGV[0] == "--hunks"
            s.splitByHunk
        else
            s.splitByFile
        end
    else
        puts "File does not exist or is not readable"
    end
end



