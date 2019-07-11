[ -z $BASH ] && { exec bash "$0" "$@" || exit; }
#!/bin/bash
# file: installThinkBioT.sh
#
# This script will install required software for testInst V1.
# It is recommended to run it in your home directory.
# Command to download file;
# sudo wget -O installThinkBioT.sh https://github.com/mefitzgerald/ThinkBioT/raw/master/installThinkBioT.sh
# Command to run file
# sudo sh installThinkBioT.sh

# check if sudo is used
if [ "$(id -u)" != 0 ]; then
  echo 'Sorry, you need to run this script with sudo'
  exit 1
fi

# target directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/ThinkBioT"

# error counter
ERR=0

echo '================================================================================'
echo '|                                                                              |'
echo '|             ThinkBioT Software Installation Script                           |'
echo '|                                                                              |'
echo '================================================================================'


# install ThinkBioT
if [ $ERR -eq 0 ]; then
  echo '>>> Install ThinkBioT'
  #check if folder already exists
  if [ -d "ThinkBioT" ]; then
    echo 'Seems ThinkBioT is installed already, skip this step.'
  else
	# check git is installed
    if hash git 2>/dev/null; then
		echo "Git is ready to go..."
    else
        echo "Git is missing, install it now..."
        apt-get install -y git || ((ERR++))
    fi
	
	# get installtion files from github
	wget https://github.com/mefitzgerald/ThinkBioT/raw/master/ThinkBioT/tbtzip.zip -O tbtzip.zip || ((ERR++))
    # unzip files
	unzip tbtzip.zip -d ThinkBioT || ((ERR++))
	# move to directory files were unzipped to 
    cd ThinkBioT
	# make start file & database creation files executable
	chmod +x tbtStart.py || ((ERR++))
	chmod +x tbt_DB_Ini.py	|| ((ERR++))
	echo '>>> set soundBlaster as default audio device'
	# move .asoundrc audio settings file to home
	mv -i .asoundrc ~  || ((ERR++))
	# move asound configuration file
	mv -i asound.conf /etc/asound.conf || ((ERR++))
	# move service unit file to systemd file (-i confirms before over writing)
	mv -i tbt.service /lib/systemd/system/tbt.service || ((ERR++))
	echo '>>> enable service'
	# enable service to be started next boot
	systemctl enable tbt.service || ((ERR++))
	
	#setup sqlite database
	echo '>>> create ThinkBioT database'
	python3 tbt_DB_Ini.py
	sleep 1
	rm tbt_DB_Ini.py
	rm tbt_dbSchema.sql
	
	# Install packages
	echo '>>> Install dependencies'
	PACKAGES="sox python-pip"
	apt-get install $PACKAGES -y || ((ERR++))
	
	# Remove audio packages that interfere with ALSA 
	
	
	# set ownership of ThinkBioT to pi
	cd ..
	chown -R pi:pi ThinkBioT
    sleep 2
	# delete redundant zip file
	rm tbtzip.zip
  fi
fi

echo
if [ $ERR -eq 0 ]; then
  echo '>>> All done. Please reboot your Pi :-)'
else
  echo '>>> Something went wrong. Please check the messages above :-('
fi
