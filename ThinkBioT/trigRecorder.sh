[ -z $BASH ] && { exec bash "$0" "$@" || exit; }
#!/bin/bash
# file: trigRecorder.sh
#
# This script capture triggered audio files.

# timeout loops for 20 minutes
# -cl sets one channel recording
# -r sets bit rate of 48000
# record.wav specifys base file name and output file type 
# sinc 100 

# change working directory to target
cd /home/pi/ThinkBioT/ClassAudioFiles

# get info from db


# record
timeout 1200 rec -c1 -r 48000 record.wav sinc 80 silence 1 0.1 1% 1 1.0 1% : newfile : restart