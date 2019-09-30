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
		sh -c 'echo "tbt_update Setting next mode to TX Mode, shutting down $(date)" >> /home/pi/ThinkBioT/tbt_log.txt'
		sleep 4
		sudo shutdown
	else
		#set next mode to DuskCapture
		cmd4="UPDATE Settings
		SET CurrentMode = 2
		WHERE SettingActive = 1;"
		TBT4=(`sqlite3 ~/tbt_database "$cmd4"`)	
		echo "Setting next mode to DuskCapture, shutting down $(date)"
		sh -c 'echo "tbt_update Setting next mode to DuskCapture, shutting down $(date)"  >> /home/pi/ThinkBioT/tbt_log.txt'
		sleep 4
		sudo shutdown
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
	sh -c 'echo "tbt_update Setting next mode to TX Mode, shutting down $(date)" >> /home/pi/ThinkBioT/tbt_log.txt'
	sleep 4
	sudo shutdown
# if current mode is TX Mode mode
elif [ $curr_mode == 3 ]
then 
    # If result args from tbt_transmit is 200 (ok)
    if [ $1 == 200 ]
        then
        # Get session ID
        cmd5="SELECT MAX(SessionID) FROM TaskSession WHERE TransmittedTime = '-1';"
        TBT5=(`sqlite3 ~/tbt_database "$cmd5"`)	
        sessionIdtoUpdate="${TBT5[0]}"       
        # Update Session in database to confirm transmission (not transmitted = -1, transmitted = unixepoch)
        cmd6="UPDATE TaskSession SET TransmittedTime = $(date +%s) WHERE SessionID = $sessionIdtoUpdate "
        TBT6=(`sqlite3 ~/tbt_database "$cmd6"`)
        echo "$sessionIdtoUpdate"
        echo "tbt_update Transmission Success, database TaskSession : $sessionIdtoUpdate uploaded $(date)"
        sh -c 'echo "tbt_update Transmission Success, database TaskSession : $sessionIdtoUpdate uploaded $(date)" >> /home/pi/ThinkBioT/tbt_log.txt'
        # Check if there are any taskSessions not uploaded
        checkCmd="SELECT MAX(SessionID) 
        FROM TaskSession 
        WHERE TransmittedTime = -1;"
		TBTCheckRes=(`sqlite3 ~/tbt_database "$checkCmd"`)	
        echo "TBTCheckRes:"
        echo "$TBTCheckRes"
        if [ -z "$TBTCheckRes" ] #check if result is null if so then...
        then  
            echo "tbt_update All sessions uploaded, Setting next mode to DawnCapture mode, shutting down $(date)"
            sh -c 'echo "tbt_update All sessions uploaded, tbt_update Setting next mode to DawnCapture mode, shutting down $(date)" >> /home/pi/ThinkBioT/tbt_log.txt'
            # Next mode is therefore starting the loop again at DawnCapture Mode
            cmd4="UPDATE Settings SET CurrentMode = 1 WHERE SettingActive = 1;"
            TBT4=(`sqlite3 ~/tbt_database "$cmd4"`)	           
            sleep 4
            sudo shutdown
        else
            #sleep for 5 minutes to let the capacitor charge build
            echo "Sleeping to charge modem"
            sleep 150
            echo "Beginning transmission of missed session"
            sh -c 'echo "tbt_update Beginning transmission of missed session $(date)"  >> /home/pi/ThinkBioT/tbt_log.txt'   
            python ~/ThinkBioT/tbt_transmitRes.py
        fi
    else
        echo "tbt_update Transmission Fail, database TaskSession not uploaded $(date)"
        sh -c 'echo "tbt_update Transmission Fail, database TaskSession not uploaded $(date)" >> /home/pi/ThinkBioT/tbt_log.txt'  
        # Next mode is therefore starting the loop again at DawnCapture Mode
        cmd4="UPDATE Settings SET CurrentMode = 1 WHERE SettingActive = 1;"
        TBT4=(`sqlite3 ~/tbt_database "$cmd4"`)	        
    fi
else
	# Else current mode is 0 (Manual)
	echo "Manual Mode active $(date)"
    sh -c 'echo "tbt_update Manual Mode active" $(date) >> /home/pi/ThinkBioT/tbt_log.txt'
fi	

#manual update if required
# sqlite3 ~/tbt_database 
# UPDATE Settings SET CurrentMode = 1 WHERE SettingActive = 1;