[ -z $BASH ] && { exec bash "$0" "$@" || exit; }
#!/bin/bash
# file: installThinkBioT.sh
#
# This script will install required software for testInst V1.
# It is recommended to run it in your home directory.
#

# check if sudo is used
if [ "$(id -u)" != 0 ]; then
  echo 'Sorry, you need to run this script with sudo'
  exit 1
fi

# target directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/testInst"

# error counter
ERR=0

echo '================================================================================'
echo '|                                                                              |'
echo '|             Test ThinkBioT Software Installation Script                      |'
echo '|                                                                              |'
echo '================================================================================'


# install ThinkBioT
if [ $ERR -eq 0 ]; then
  echo '>>> Install test ThinkBioT'
  #check if folder already exists
  if [ -d "testInst" ]; then
    echo 'Seems testInst is installed already, skip this step.'
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
	unzip tbtzip.zip -d testInst || ((ERR++))
	# move to directory files were unzipped to 
    cd testInst
	# make start file executable
	chmod +x tbtStart.py
	# copy service unit file to systemd file
	cp tbt.service /lib/systemd/system/tbt.service
	systemctl enable tbt.service
    sleep 2
	# delete redundant files
	rm tbt.service
	cd ..
	rm tbtzip.zip
  fi
fi

echo
if [ $ERR -eq 0 ]; then
  echo '>>> All done. Please reboot your Pi :-)'
else
  echo '>>> Something went wrong. Please check the messages above :-('
fi
