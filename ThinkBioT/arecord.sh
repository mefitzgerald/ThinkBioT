[ -z $BASH ] && { exec bash "$0" "$@" || exit; } 
#!/bin/bash
# to run use sh ./arecord.sh

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

cmd="SELECT * FROM Settings WHERE SettingActive = 1"
IFS=$'|'
TBT=(`sqlite3 ~/tbt_database "$cmd"`)

echo "Recording Settings"
curr_settingID="${TBT[0]}"
echo curr_settingID: $curr_settingID
gain_db="${TBT[14]}"
echo Gain: $gain_db
curr_mode="${TBT[15]}"
echo Current mode: $curr_mode

echo "Modes"
echo "0 = Automnomous not active (Manual mode)"
echo "1 = Dawn Capture Mode"
echo "2 = Dusk Capture Mode"
echo "3 = TX Mode"

# unix epoch time for file name
uniepoch=$(date +"%s")

#create TaskSession in Database
cmd="INSERT INTO TaskSession (TestLong, TestLat, TestElevation, TransmittedTime, SettingID) VALUES ('145.0', '-37.6', '416.6', '-1', $curr_settingID);"
TBT=(`sqlite3 ~/tbt_database "$cmd"`)	

#get most current sessionid 
cmd1="SELECT MAX(SessionID) FROM TaskSession;"
TBT1=(`sqlite3 ~/tbt_database "$cmd1"`)	
out="${TBT1[0]}"

#record wave file 
timeout 50 rec -V1 -c 1 -r 48000 $uniepoch.wav sinc 80 gain -l $gain_db
#move file
mv $uniepoch.wav ~/ThinkBioT/AcousticIndices/IAudioIn/$uniepoch.wav
filepath=IAudioIn/$uniepoch.wav
echo $filepath

#update log
sh -c 'echo "arecord Index audio sample captured $(date)" >> /home/pi/ThinkBioT/tbt_log.txt'

#start index calculation
python ~/ThinkBioT/AcousticIndices/tbt_indexprocess.py --indiciesfile $filepath --taskSessionId $out --epochtime $uniepoch
	

