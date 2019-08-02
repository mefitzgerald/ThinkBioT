#!/bin/sh
# to run use ./tbt_mp32wav.sh or sh tbt_mp32wav.sh or bash ./tbt_mp32wav.sh

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

#make directory for converted files
mkdir -p Samples

#instanciate counter
counter=0

#loop through all files to be converted 
for i in *.mp3
do
	# exiftool $i (reads all metadata to screen)
	var1=$(exiftool -s -s -s -Title -charset UTF8  $i)
	dur=$(exiftool -s -s -s -n -Duration  $i)
	#remove formal name
	dirname=${var1%%(*}
	dirname=${dirname// /""}
	dirname=${dirname,,}
	
	#make directory for converted file class (if not exists)
	mkdir -p "Samples/$dirname"	
	
	if [ $dur > 3 ] # sample length greater than 3 seconds split into segments containing data peaks
	then
		sox "$i" -c 1 -r 48000 "Samples/$dirname/$(basename -s .mp3 "$i").wav" silence 1 0.001 3% trim 0 3 : newfile : restart
	else
		#convert file to wav (mono 48000) without altering duration
		sox "$i" -c 1 -r 48000 "Samples/$dirname/$(basename -s .mp3 "$i").wav" 
		echo $dur
	fi
	counter=`expr $counter + 1`
	echo samples processed: $counter
done

  



