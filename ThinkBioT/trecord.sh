[ -z $BASH ] && { exec bash "$0" "$@" || exit; } 
#!/bin/bash
# to run use sh trecord.sh

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

echo "Recording Settings"
curr_settingID="${TBT[0]}"
echo curr_settingID: $curr_settingID
dawn_capture_time="${TBT[3]}"
echo dawn_capture_time: $dawn_capture_time
dusk_capture_time="${TBT[4]}"
echo dusk_capture_time: $dusk_capture_time
Tr_Sil_dur="${TBT[6]}"
echo Triggered_Silence_duration: $Tr_Sil_dur
Tr_Sil_dur_perc="${TBT[7]}"
echo Triggered_Silence_duration_percent: $Tr_Sil_dur_perc
Tr_Sil_below_dur="${TBT[8]}"
echo Triggered_Silence_below_threashold_duration: $Tr_Sil_below_dur
Tr_Sil_below_dur_perc="${TBT[9]}"
echo Triggered_Silence_below_duration_percent: $Tr_Sil_below_dur_perc
Tr_Hpfilter="${TBT[10]}"
echo Triggered_High_pass_filter: $Tr_Hpfilter
Tr_Gain="${TBT[11]}"
echo Triggered_recording_Gain: $Tr_Gain
Tr_Wav_length="${TBT[12]}"
echo Triggered_Wavfile_length: $Tr_Wav_length
Tr_Test_Length="${TBT[13]}"
echo Triggered_Test_Length: $Tr_Test_Length
curr_mode="${TBT[15]}"
echo Current mode: $curr_mode
echo "Modes"
echo "0 = Automnomous not active (Manual mode)"
echo "1 = Dawn Capture Mode"
echo "2 = Dusk Capture Mode"
echo "3 = TX Mode"

# unix epoch time for file name
uniepoch=$(date +"%s")

# timeout sets recoding to time in seconds for 5 minutes
# timeout $Tr_Test_Length rec -V1 -c 1 -r 48000 raw.wav sinc $Tr_Hpfilter silence 1 $Tr_Sil_dur $Tr_Sil_dur_perc% 1 $Tr_Sil_below_dur $Tr_Sil_below_dur_perc% : newfile : restart gain −l $Tr_Gain
timeout 20 rec -V1 -c 1 -r 48000 raw.wav sinc $Tr_Hpfilter silence 1 $Tr_Sil_dur $Tr_Sil_dur_perc% 1 $Tr_Sil_below_dur $Tr_Sil_below_dur_perc% : newfile : restart gain −l $Tr_Gain
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
		if [ $(float_gt $soundlength $Tr_Wav_length) == 1 ] ; then
			echo "dur > $Tr_Wav_length, soundfile sucessfully split"
			# split all wav files into files of 5 second durations
			sox -V1 $i $uniepoch.wav trim 0 $Tr_Wav_length : newfile : restart		
		else
			echo "dur < $Tr_Wav_length soundfile discarded"
		fi
		#delete source file (all usable data has been split and renamed)
		rm $i
	done
fi

#create TaskSession in Database
cmd2="INSERT INTO TaskSession (TestLong, TestLat, TestElevation, TransmittedTime, SettingID) VALUES ('145.0', '-37.6', '416.6', NULL, $curr_settingID);"
TBT2=(`sqlite3 ~/tbt_database "$cmd2"`)		
#get most current sessionid 
cmd3="SELECT MAX(SessionID) FROM TaskSession;"
TBT3=(`sqlite3 ~/tbt_database "$cmd3"`)	
out="${TBT3[0]}"
	
#check if wavs exits to convert to spectrograms
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
	#start classification passing the SessionId to the classify script
	cd CModel
	python3 auto_classify_spect.py --taskSessionId $out --epochtime $uniepoch
else
# if no wavs exist to convert to spectrograms set next mode	
	sh ~/ThinkBioT/tbt_update.sh
fi

