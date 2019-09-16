[ -z $BASH ] && { exec bash "$0" "$@" || exit; }
#!/bin/bash
# to run use sh tbt_update.sh
#
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
#
# Get mode information

cmd="SELECT * FROM Settings WHERE SettingActive = 1"
IFS=$'|'
TBT=(`sqlite3 ~/tbt_database "$cmd"`)
curr_mode="${TBT[15]}"
dawn_capture_time="${TBT[3]}"
dusk_capture_time="${TBT[4]}"
	
# modes are
# 0 = Automnomous not active (Manual mode)
# 1 = Dawn Capture Mode
# 2 = Dusk Capture Mode
# 3 = TX Mode

# get date for log
currUnixEpoch=$(date +%s);

echo "In update script, current mode is: $curr_mode"
# if current mode is DawnCapture
if [ $curr_mode == 1 ]
then
	# if DuskCapture is not set (-1)
	echo dusk capture time: $dusk_capture_time
	if [[ $dusk_capture_time == "-1" ]]
	then
		# Else DuskCapture is inactive and next mode is therefore transmission
		cmd4="UPDATE Settings
		SET CurrentMode = 3
		WHERE SettingActive = 1;"
		TBT4=(`sqlite3 ~/tbt_database "$cmd4"`)	
		echo "Setting next mode to TX Mode, shutting down $(date)"
		sh -c 'echo "Setting next mode to TX Mode, shutting down $(date)" >> /home/pi/ThinkBioT/tbt_log.txt'
		sleep 4
		#sudo shutdown
	else
		#set next mode to DuskCapture
		cmd4="UPDATE Settings
		SET CurrentMode = 2
		WHERE SettingActive = 1;"
		TBT4=(`sqlite3 ~/tbt_database "$cmd4"`)	
		echo "Setting next mode to DuskCapture, shutting down $(date)"
		sh -c 'echo "Setting next mode to DuskCapture, shutting down $(date)"  >> /home/pi/ThinkBioT/tbt_log.txt'
		sleep 4
		#sudo shutdown
	fi
# if current mode is DuskCapture mode	
elif [ $curr_mode == 2 ]
then
	# Next mode is therefore transmission
	cmd4="UPDATE Settings
	SET CurrentMode = 3
	WHERE SettingActive = 1;"
	TBT4=(`sqlite3 ~/tbt_database "$cmd4"`)	
	echo "Setting next mode to TX Mode, shutting down $(date)"
	sh -c 'echo "Setting next mode to TX Mode, shutting down $(date)" >> /home/pi/ThinkBioT/tbt_log.txt'
	sleep 4
	#sudo shutdown
# if current mode is TX Mode mode
elif [ $curr_mode == 3 ]
then	
	# Next mode is therefore starting the loop again at DawnCapture Mode
	cmd4="UPDATE Settings SET CurrentMode = 1 WHERE SettingActive = 1;"
	TBT4=(`sqlite3 ~/tbt_database "$cmd4"`)	
    #Update database to confirm transmission 
    cmd5="UPDATE TaskSession SET TransmittedTime = currUnixEpoch WHERE SessionID = $1 "
	TBT5=(`sqlite3 ~/tbt_database "$cmd5"`)
	echo "Setting next mode to DawnCapture mode, shutting down $(date)"
	sh -c 'echo "Setting next mode to DawnCapture mode, shutting down $(date)" >> /home/pi/ThinkBioT/tbt_log.txt'
	sleep 4
	#sudo shutdown
else
	# Else current mode is 0 (Manual)
	echo "Manual Mode active $(date)"
    sh -c 'echo "Manual Mode active" $(date) >> /home/pi/ThinkBioT/tbt_log.txt'
fi	

#manual update if required
# sqlite3 ~/tbt_database 
# UPDATE Settings SET CurrentMode = 1 WHERE SettingActive = 1;