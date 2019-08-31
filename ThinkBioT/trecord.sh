[ -z $BASH ] && { exec bash "$0" "$@" || exit; } 
#!/bin/bash
# to run use ./trecord.sh or sh ./trecord.sh or bash ./trecord.sh

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

#functions to compare float values
function float_gt() {
    perl -e "{if($1>$2){print 1} else {print 0}}"
}

function float_gt_et() {
    perl -e "{if($1>=$2){print 1} else {print 0}}"
}

cmd="SELECT * FROM Settings WHERE SettingActive = 1"
IFS=$'|'
TBT=(`sqlite3 ~/tbt_database "$cmd"`)

Tr_Sil_dur="${TBT[6]}"
# echo $Tr_Sil_dur
Tr_Sil_dur_perc="${TBT[7]}"
# echo $Tr_Sil_dur_perc
Tr_Sil_below_dur="${TBT[8]}"
# echo $Tr_Sil_below_dur
Tr_Sil_below_dur_perc="${TBT[9]}"
# echo $Tr_Sil_below_dur_perc
Tr_Hpfilter="${TBT[10]}"
# echo $Tr_Hpfilter

# unix epoch time for file name
uniepoch=$(date +"%s")

# timeout sets recoding to time in seconds for 10 seconds
timeout 10 rec -V1 -c 1 -r 48000 raw.wav sinc $Tr_Hpfilter silence 1 $Tr_Sil_dur $Tr_Sil_dur_perc% 1 $Tr_Sil_below_dur $Tr_Sil_below_dur_perc% : newfile : restart

#check wavs exist 
count=`ls -1 *.wav 2>/dev/null | wc -l`
echo "recorded $count files"
if [ $count != 0 ]
then 
	# split captured audio into 5 second files
	for i in *.wav;do
		# get duration of wav file in seconds
		soundlength=$(soxi -D $i)
		# filter out wav files shorter than 5 seconds
		if [ $(float_gt $soundlength 5) == 1 ] ; then
			echo "dur > 5, soundfile sucessfully split"
			# split all wav files into files of 5 second durations
			sox -V1 $i $uniepoch.wav trim 0 5 : newfile : restart		
		else
			echo "dur < 5 soundfile discarded"
		fi
		#delete source file (all usable data has been split and renamed)
		rm $i
	done
fi

#check wavs exist after split 
count=`ls -1 *.wav 2>/dev/null | wc -l`
if [ $count != 0 ]
then 

	# convert to spectrograms
	for file in *.wav;do
		# filter out tail end split files
		filelength=$(soxi -D $file)
		echo $file
		if [ $(float_gt_et $filelength 5) == 1 ] ; then
			outfile="${file%.*}.png"
			sox -V1 "$file" -n spectrogram -r -o "$outfile"
			mv "$outfile" ./CSpectrograms
			echo "spectrogram generated"
		fi
		rm $file
	done
fi

