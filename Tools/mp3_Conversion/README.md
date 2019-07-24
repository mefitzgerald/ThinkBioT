### How to convert MP3 to WAV and Sort for Model Creation
This guide will result in wav files sorted into directories with their title names. 

##Steps
Download latest version of SOX and install.
Download libmad-0.dll and libmp3lame-0.dll. 
Add libmad-0.dll and libmp3lame-0.dll to the folder where SOX was installed to.
Download latest version of exiftool and install. https://www.sno.phy.queensu.ca/~phil/exiftool/index.html
Run the ThinkBiot bash script from inside the folder containing the mp3 files to be converted
sh tbt_mp32wav.sh

exiftool -Title -charset UTF8  Zosterops-luteus-107945.mp3
declare -x var3=373

declare -x varTitle = exiftool -Title -charset UTF8  Zosterops-luteus-107945.mp3

ModelName=`exiftool -q -ModelName FILE`

DirName=`exiftool -Title -charset UTF8  Zosterops-luteus-107945.mp3`
