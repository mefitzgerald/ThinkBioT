#!/bin/bash

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
mkdir -p converted

#loop through all files to be converted 
for i in *.mp3
do
	var1=$(exiftool -Title -charset UTF8  $i)
	#remove title
	secondString=""
	var2=${var1/Title : /$secondString}
	echo $var2
	#remove formal name
	dirname=${var2%%(*} 
	echo $dirname
	#echo tmp=${dirname%%(*}
	#make directory for converted file class (if not exists)
	mkdir -p "$dirname"
	
    sox "$i" "converted/$(basename -s .mp3 '$i').wav"
done