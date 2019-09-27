[ -z $BASH ] && { exec bash "$0" "$@" || exit; } 
#!/bin/bash
# 

# modes are
# 0 = Automnomous not active (Manual mode)
# 1 = Dawn Capture Mode
# 2 = Dusk Capture Mode
# 3 = TX Mode

cmd="SELECT * FROM Settings WHERE SettingActive = 1"
IFS=$'|'
TBT=(`sqlite3 ~/tbt_database "$cmd"`)
curr_mode="${TBT[15]}"

if [ $curr_mode == 0 ]
then
    echo "Manual mode, no cycle required"
    sh -c 'echo "tbt_startCycle Manual mode, no cycle required $(date)" >> /home/pi/ThinkBioT/tbt_log.txt'
else
    # allow 10 minutes for user to disable cycle if required
    echo "Sleep 10 minutes to allow for cycle disable"
    sleep 600
    echo "Activity resumed"
    
    # reload settings in case user reset mode
    cmd2="SELECT * FROM Settings WHERE SettingActive = 1"
    TBT2=(`sqlite3 ~/tbt_database "$cmd2"`)
    curr_mode="${TBT2[15]}"
    dawn_capture_time="${TBT2[3]}"
    dusk_capture_time="${TBT2[4]}"

    echo "curr_mode $curr_mode"
    # if current mode is DawnCapture
    if [ $curr_mode == 1 ]
    then
        echo "Start Dawn Audio Capture $(date)"
        sh -c 'echo "tbt_startCycle Start Dawn Audio Capture $(date)" >> /home/pi/ThinkBioT/tbt_log.txt'
        sh ~/ThinkBioT/AcousticIndices/arecord.sh
    # if current mode is DuskCapture mode
    elif [ $curr_mode == 2 ]
    then
        echo "Start Dawn Audio Capture $(date)"
        sh -c 'echo "tbt_startCycle Start Dawn Audio Capture $(date)" >> /home/pi/ThinkBioT/tbt_log.txt'
        sh ~/ThinkBioT/AcousticIndices/arecord.sh
    # if current mode is TX Mode mode
    elif [ $curr_mode == 3 ]
    then
        echo "Start Transmission $(date)"
        sh -c 'echo "tbt_startCycle Start Transmission $(date)" >> /home/pi/ThinkBioT/tbt_log.txt'    
        python ~/ThinkBioT/tbt_transmitRes.py 
        
    else
        # Else current mode is 0 (Manual)
        echo "Manual Mode active"
        sh -c 'echo "tbt_startCycle Manual Mode active no Cycle $(date)" >> /home/pi/ThinkBioT/tbt_log.txt'
    fi
fi
    