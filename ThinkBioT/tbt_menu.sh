[ -z $BASH ] && { exec bash "$0" "$@" || exit; } 
#!/bin/bash
# 
## ----------------------------------
# Variables
# ----------------------------------
EDITOR=vim
PASSWD=/etc/passwd
RED='\033[0;41;30m'
STD='\033[0;0;39m'
REGEX_REAL='^[0-9]+([.][0-9]+)?$'
REGEX_INT='^[0-9]+$'
 
# ----------------------------------
# Functions
# ----------------------------------
pause(){
  read -p "Press [Enter] key to continue..." fackEnterKey
}

dbWriteErr(){
  read -p "Write to database failed, press [Enter] key to continue..." fackEnterKey
}

dbAudioSettingsSuccess(){
  echo "Settings updated sucessfully, returning to audio capture menu.."
  sleep 1
  show_menus
}

setSilenceDur(){
	echo "Please enter Classification Silence Duration"
	echo "Default Value: 0.1"
	read -p 'Must be in floating number format :' setSilenceDurVar
	# Check if real
	if ! [[ $setSilenceDurVar =~ $REGEX_REAL ]] ; then
		echo 'Please enter a real'
		pause
	else
		# Update database
		setSilenceDurCmd="UPDATE Settings
		SET Tr_Sil_dur = $setSilenceDurVar
		WHERE SettingActive = 1;"
		TBTsetSilenceDur=(`sqlite3 ~/tbt_database "$setSilenceDurCmd"`) && dbAudioSettingsSuccess || dbWriteErr
	fi
}

setSilenceDurPerc(){
	echo "Please enter Classification Silence Duration Percentage"
	echo "Default Value: 1"
	read -p 'Must be in int number format between 0-100 :' setSilenceDurVarPerc
	# Check if int
	if ! [[ $setSilenceDurVarPerc =~ $REGEX_INT ]] ; then
		echo 'Please enter a positive integer'
		pause
	else
		if [[ $setSilenceDurVarPerc -gt 100 ]] ; then
			echo 'Please select a value between 0-100'
			pause
		else
			# Update database
			setSilenceDurPercCmd="UPDATE Settings
			SET Tr_Sil_dur_perc = $setSilenceDurVarPerc
			WHERE SettingActive = 1;"
			TBTsetSilenceDurPerc=(`sqlite3 ~/tbt_database "$setSilenceDurPercCmd"`) && dbAudioSettingsSuccess || dbWriteErr
		fi
	fi
}

setSilenceBelowThreas(){
	echo "Please enter Classification Silence below threashold"
	echo "Default Value: 1.0"
	read -p 'Must be in floating number format :' setSilenceBelowThreasVar
	# Check if real
	if ! [[ $setSilenceBelowThreasVar =~ $REGEX_REAL ]] ; then
		echo 'Please enter a real'
		pause
	else
		# Update database
		setSilenceBelowThreasCmd="UPDATE Settings
		SET Tr_Sil_below_dur = $setSilenceBelowThreasVar
		WHERE SettingActive = 1;"
		TBTsetSilenceBelowThreas=(`sqlite3 ~/tbt_database "$setSilenceBelowThreasCmd"`) && dbAudioSettingsSuccess || dbWriteErr
	fi
}

setSilenceBelDurPerc(){
	echo "Please enter Classification Silence Below Duration Percentage"
	echo "Default Value: 1"
	read -p 'Must be in int number format between 0-100 :' setSilenceBelDurPercVar
	# Check if int
	if ! [[ $setSilenceBelDurPercVar =~ $REGEX_INT ]] ; then
		echo 'Please enter a positive integer'
		pause
	else
		if [[ $setSilenceBelDurPercVar -gt 100 ]] ; then
			echo 'Please select a value between 0-100'
			pause
		else
			# Update database
			setSilenceBelDurPercCmd="UPDATE Settings
			SET Tr_Sil_below_dur_perc = $setSilenceBelDurPercVar
			WHERE SettingActive = 1;"
			TBTsetSilenceBelDurPerc=(`sqlite3 ~/tbt_database "$setSilenceBelDurPercCmd"`) && dbAudioSettingsSuccess || dbWriteErr
		fi
	fi
}

setHpFilter(){
	echo "Please enter Classification High Pass Filter"
	echo "Default Value: 80"
	read -p 'Must be in int number format between 0-10000 :' setHpFilterVar
	# Check if int
	if ! [[ $setHpFilterVar =~ $REGEX_INT ]] ; then
		echo 'Please enter a positive integer'
		pause
	else
		if [[ $setHpFilterVar -gt 10000 ]] ; then
			echo 'Please select a value between 0-10000'
			pause
		else
			# Update database
			setHpFilterCmd="UPDATE Settings
			SET Tr_Hpfilter = $setHpFilterVar
			WHERE SettingActive = 1;"
			TBTsetHpFilter=(`sqlite3 ~/tbt_database "$setHpFilterCmd"`) && dbAudioSettingsSuccess || dbWriteErr
		fi
	fi
}

setClassGain(){
	echo "Please enter Classification Gain Level"
	echo "Default Value: 6"
	read -p 'Must be in int number format between 0-30 :' setClassGainVar
	# Check if int
	if ! [[ $setClassGainVar =~ $REGEX_INT ]] ; then
		echo 'Please enter a positive integer'
		pause
	else
		if [[ $setClassGainVar -gt 30 ]] ; then
			echo 'Please select a value between 0-30'
			pause
		else
			# Update database
			setClassGainCmd="UPDATE Settings
			SET Tr_Gain = $setClassGainVar
			WHERE SettingActive = 1;"
			TBTsetClassGain=(`sqlite3 ~/tbt_database "$setClassGainCmd"`) && dbAudioSettingsSuccess || dbWriteErr
		fi
	fi
}

setWavLength(){
	echo "Please enter Classification Sample wav length in seconds"
	echo "Default Value: 5"
	read -p 'Must be in int number format between 3-15 :' setWavLengthVar
	# Check if int
	if ! [[ $setWavLengthVar =~ $REGEX_INT ]] ; then
		echo 'Please enter a positive integer'
		pause
	else
		if [[ $setWavLengthVar -gt 15 ]] || [[ $setWavLengthVar -lt 3 ]]  ; then
			echo 'Please select a value between 3-15'
			pause
		else
			# Update database
			setWavLengthCmd="UPDATE Settings
			SET Tr_Wav_length = $setWavLengthVar
			WHERE SettingActive = 1;"
			TBTsetWavLength=(`sqlite3 ~/tbt_database "$setWavLengthCmd"`) && dbAudioSettingsSuccess || dbWriteErr
		fi
	fi
}
 
setTestLength(){
	echo "Please enter Classification Recording duration in seconds"
	echo "Default Value: 300"
	read -p 'Must be in int number format between 50-2400 :' setTestLengthVar
	# Check if int
	if ! [[ $setTestLengthVar =~ $REGEX_INT ]] ; then
		echo 'Please enter a positive integer'
		pause
	else
		if [[ $setTestLengthVar -gt 2400 ]] || [[ $setTestLengthVar -lt 50 ]]  ; then
			echo 'Please select a value between 50-2400'
			pause
		else
			# Update database
			setTestLengthCmd="UPDATE Settings
			SET Tr_Test_Length = $setTestLengthVar
			WHERE SettingActive = 1;"
			TBTsetTestLength=(`sqlite3 ~/tbt_database "$setTestLengthCmd"`) && dbAudioSettingsSuccess || dbWriteErr
		fi
	fi
}

setAiGain(){
	echo "Please enter Index Gain Level"
	echo "Default Value: 6"
	read -p 'Must be in int number format between 0-30 :' setAiGainVar
	# Check if int
	if ! [[ $setAiGainVar =~ $REGEX_INT ]] ; then
		echo 'Please enter a positive integer'
		pause
	else
		if [[ $setAiGainVar -gt 30 ]] ; then
			echo 'Please select a value between 0-30'
			pause
		else
			# Update database
			setAiGainCmd="UPDATE Settings
			SET Ai_Gain = $setAiGainVar
			WHERE SettingActive = 1;"
			TBTsetAiGain=(`sqlite3 ~/tbt_database "$setAiGainCmd"`) && dbAudioSettingsSuccess || dbWriteErr
		fi
	fi
}

# Start Auto Schedule
one(){
	# copy schedule script from ThinkBioT to wittyPi Folder
	sudo cp ~/ThinkBioT/schedule.wpi ~/wittyPi/schedule.wpi
	# run script to activate schedule
	echo "wittyPi updating..."
	sudo ~/wittyPi/runScript.sh
	# Update database
	cmdOne="UPDATE Settings
	SET CurrentMode = 1
	WHERE SettingActive = 1;"
	TBTOne=(`sqlite3 ~/tbt_database "$cmdOne"`) 
	echo "At restart data record/TX cycle will begin"
	pause
        show_menus
}

# Disable Auto Schedule
two(){
	# run script to de-activate schedule
	echo "Opening witty pi mamager select 7,4 & 8"
	sudo ~/wittyPi/wittyPi.sh
	# Update database
	cmdTwo="UPDATE Settings
	SET CurrentMode = 0
	WHERE SettingActive = 1;"
	TBTTwo=(`sqlite3 ~/tbt_database "$cmdTwo"`)
	echo "Auto schedule deleted, Manual Mode enabled"
	pause	
        show_menus
}

# Recording settings
three(){	
	local continue_rec_settings = true
	while $continue_rec_settings
	do
		#Get settings from database
		cmdThree="SELECT * FROM Settings WHERE SettingActive = 1"
		IFS=$'|'
		TBTThree=(`sqlite3 ~/tbt_database "$cmdThree"`)
		Tr_Sil_dur="${TBT[6]}"
		Tr_Sil_dur_perc="${TBT[7]}"
		Tr_Sil_below_dur="${TBT[8]}"
		Tr_Sil_below_dur_perc="${TBT[9]}"
		Tr_Hpfilter="${TBT[10]}"
		Tr_Gain="${TBT[11]}"
		Tr_Wav_length="${TBT[12]}"
		Tr_Test_Length="${TBT[13]}"
		Ai_Gain="${TBT[14]}"
		clear
		echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"	
		echo "        AUDIO CAPTURE SETTINGS         "
		echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
		echo "1.  Set Silence_duration (Current Value: $Tr_Sil_dur)"
		echo "2.  Set Silence_duration_percent (Current Value: $Tr_Sil_dur_perc)"
		echo "3.  Set Silence_below_threashold (Current Value: $Tr_Sil_below_dur)"
		echo "4.  Set Silence_below_duration_percent (Current Value: $Tr_Sil_below_dur_perc)"
		echo "5.  Set High_pass_filter (Current Value: $Tr_Hpfilter)"
		echo "6.  Set Classification_Gain (Current Value: $Tr_Gain)"
		echo "7.  Set Wav_file_length (Current Value: $Tr_Wav_length)"
		echo "8.  Set Recording_period_duration (Current Value: $Tr_Test_Length)"
		echo "9.  Set Index_Gain (Current Value: $Ai_Gain)"
		echo "10. Return to main menu"
		echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
		local rec_choice
		read -p "Enter choice [ 1 - 10] " rec_choice
		case $rec_choice in
			1) setSilenceDur ;;			
			2) setSilenceDurPerc ;;
			3) setSilenceBelowThreas ;;
			4) setSilenceBelDurPerc;;
			5) setHpFilter ;;
			6) setClassGain ;;
			7) setWavLength ;;
			8) setTestLength ;;
			9) setAiGain ;;
			10) continue_rec_settings = false; break ;;			
			*) echo -e "${RED}Error...${STD}" && sleep 2
		esac
	done	
}

# Factory Reset
four(){
	#confirm && echo "resetdb"
	echo "Do you wish to reset ThinkBioT to factory settings?"
	echo "Enter 1 for Yes or 2 for No"
	select yn in "Yes" "No"; do
		case $yn in
			Yes ) sh ~/ThinkBioT/tbt_resetDb.sh; break;;
			No ) echo "Reset aborted"; exit;;
		esac
	done
        exit 0
}

# Manual Record&Process
five(){
	sh ~/ThinkBioT/AcousticIndices/arecord.sh
        exit 0
}

# Manual Manual Transmit
six(){
	python tbt_transmitRes.py	
        exit 0
}
 
# function to display menus
show_menus() {

	cmd="SELECT * FROM Settings WHERE SettingActive = 1"
	IFS=$'|'
	TBT=(`sqlite3 ~/tbt_database "$cmd"`)
	clear
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "               THINKBIOT MENU               "
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "        Current Operational Mode: ${TBT[15]}"
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "1. Enable Schedule Script & set Mode to 1"
	echo "2. Disable Schedule Script & set Mode to 0"
	echo "3. Audio Capture Settings"
	echo "4. Factory Reset"
	echo "5. Manual Record & Process"
	echo "6. Manual Satellite Transmit"
	echo "7. Exit"
}
# read input from the keyboard and take a action
read_options(){
	local choice
	read -p "Enter choice [ 1 - 7] " choice
	case $choice in
		1) one ;;
		2) two ;;
		3) three ;;
		4) four ;;
		5) five ;;
		6) six ;;
		7) exit 0;;
		*) echo -e "${RED}Error...${STD}" && sleep 2
	esac
}
 
# ----------------------------------------------
# Trap CTRL+C, CTRL+Z and quit singles
# ----------------------------------------------
trap '' SIGINT SIGQUIT SIGTSTP
 
# -----------------------------------
# Main logic - infinite loop
# ------------------------------------
while true
do
	show_menus
	read_options
done
