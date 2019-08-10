#!/bin/sh

# LICENSE:
# ThinkBioT is an Bioacoustic sensor framework for the collection, processing
# and satellite transmission of Bio-Taxa Classification and Acoustic Indicies data.
# Copyright (C) 2019  Marita Fitzgerald
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
# 
# SUPPORT:
# https://github.com/mefitzgerald/ThinkBioT/issues

# === INSTRUCTIONS ===
# to run use ./tbt_exif_example.sh or sh tbt_exif_example.sh or bash ./tbt_exif_example.sh

# === DEPENDECIES ===
# exiftool :download at https://www.sno.phy.queensu.ca/~phil/exiftool/
# sox : http://sox.sourceforge.net/

#make directory called Samples for converted files
mkdir -p Samples

#instanciate counter
counter=0

#loop through all files to be converted (if files are already in wav format simply change the code to *.wav in the line below
for i in *.mp3
do
	# exiftool reads metadata for more information view https://www.sno.phy.queensu.ca/~phil/exiftool/#running
	
	# Example 1 for sorting mp3's from xeno-canto into Species folders (uncomment next 5 lines)
	# var1=$(exiftool -s -s -s -Title -charset UTF8  $i)
	# dur=$(exiftool -s -s -s -n -Duration  $i)
	# dirname=${var1%%(*}
	# dirname=${dirname// /""}
	# dirname=${dirname,,}
	
	# Example 2 for sorting mp3's from xeno-canto into Family folders
	dirname=$(exiftool -s -s -s -Genre -charset UTF8  $i)
	dur=$(exiftool -s -s -s -n -Duration  $i)	
	
	# make directory for converted file class (if not exists)
	mkdir -p "Samples/$dirname"	
	
	if [ $dur > 5 ] # sample length greater than 5 seconds split into segments containing data peaks
	then
		sox -G "$i" -c 1 -r 48000 -b 24 "Samples/$dirname/$(basename -s .mp3 "$i").wav" silence 1 0.001 3% trim 0 5 : newfile : restart
	else
		#convert file to wav (mono 48000/24) without altering duration. For additional conversion options view http://sox.sourceforge.net/sox.html
		sox -G "$i" -c 1 -r 48000 -b 24 "Samples/$dirname/$(basename -s .mp3 "$i").wav" 
		echo $dur
	fi
	counter=`expr $counter + 1`
	echo samples processed: $counter
done

  

