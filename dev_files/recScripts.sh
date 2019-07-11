
#record to new-file.wav 5 sec duration (from 0 - 5 seconds)
rec new-file.wav trim 0 5

#record MONO (1 channel) to new-file.wav 5 sec duration (from 0 - 5 seconds)
rec -c1 /home/pi/ThinkBioT/new-filetst.wav trim 0 10

#record MONO (1 channel) at 48kHZ to new-file.wav 5 sec duration (from 0 - 5 seconds)
rec -c1 -r 48000 /home/pi/ThinkBioT/new-filetst.wav trim 0 10

# new-file auto generates file names, restart loops
# silence syntax
# silence [−l] above-periods [duration threshold[d|%] [below-periods duration threshold[d|%]]
# This specifies that all silence will be trimmed until a noise that is 1% of the 
# sample value is heard for at least 0.1 second, and then trim all silence after 
# 5 seconds of silence is heard below the same 1% threshold.
rec -c1 -r 48000 record.wav silence 1 0.1 1% 1 5.0 1% : newfile : restart

#ThinkBiot Version
rec -c1 -r 48000 record.wav silence 1 0.1 1% 1 1.0 1% : newfile : restart
#Notes cannot specify file location, newfile will overwrite file names

#sinc = steep hpf of 80Hz
rec -c1 -r 48000 record.wav sinc 80 silence 1 0.1 1% 1 1.0 1% : newfile : restart

#timeout loops for 20 seconds
timeout 20 rec -c1 -r 48000 record.wav sinc 100 silence 1 0.1 1% 1 1.0 1% : newfile : restart

