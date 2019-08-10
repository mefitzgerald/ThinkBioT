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
# to run use ./tbt_csv_example.sh or sh tbt_csv_example.sh or bash ./tbt_csv_example.sh

# === DEPENDECIES ===
# sox : http://sox.sourceforge.net/

#make directory called Samples for converted files
mkdir -p Samples

#instanciate counter
counter=0

# reads in each lines fields eg for below the fields are " filename,fold,target,category,esc10,src_file,take "
# we only need filname and catagory so we only use $f1 & $f4

IFS=","
while read f1 f2 f3 f4 f5 f6 f7
do
	if [ $f4 == "rain" ] || [ $f4 == "wind" ] || [ $f4 == "rain" ] || [ $f4 == "thunderstorm" ] || [ $f4 == "crickets" ] || [ $f4 == "chainsaw" ] || [ $f4 == "dog" ]
	then 
		#make directory for converted file class (if not exists)
		mkdir -p "Samples/$f4"	
		#convert file to wav (mono 48000/24) without altering duration. For additional conversion options view http://sox.sourceforge.net/sox.html
		sox -G "$f1" -c 1 -r 48000 -b 24 "Samples/$f4/$(basename -s .wav "$f1").wav" 
		
		counter=`expr $counter + 1`
		echo samples $f4 processed: $counter
	fi
# csv file we are reading = esc50.csv (in same directory as the audio smaples)		
done < esc50.csv
