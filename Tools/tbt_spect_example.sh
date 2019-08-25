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
# to run use ./tbt_spect_example.sh or sh tbt_spect_example.sh or bash ./tbt_spect_example.sh

# === DEPENDECIES ===
# sox : http://sox.sourceforge.net/

mkdir -p ../spectro-data
echo "location, label" >> model-labels.csv

curdir=$(pwd)
# for every folder in the current directory
for f in $curdir/*
do 
	# change to that folder
	[ -d $f ] && cd "$f" && echo Entering into $f
	className=${PWD##*/}
	# for every wavfile in the folder
	for i in *.wav
	do
		dur=$(exiftool -s -s -s -n -Duration  $i)
		#check file not empty
		if [ $dur > 4 ]
		then
			#make spectrogram
			echo $className
			outfile="${i%.*}.png"
			sox $i −n spectrogram −x 1024 −y 512 -r -o "$outfile"
			mv "$outfile" ../../spectro-data
			# please fill in your google cloud storage bucket path below and create a dictionary in the buckt called spectro-data
			# this script will not upload spectrograms, but needs the path name for the csv label file.
			bucket="gs://yourbucketname/spectro-data/"
			uri="$bucket$outfile"
			echo "$uri, $className" >> ../model-labels.csv
		fi
	done 
done

