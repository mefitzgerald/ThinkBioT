[ -z $BASH ] && { exec bash "$0" "$@" || exit; }
#!/bin/bash
# file: installThinkBioT.sh
#
# This script will install required software for ThinkBioT V1.
# It is recommended to run it in your home directory.
#

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
echo '|                   ThinkBioT Software Installation Script                      |'
echo '|                                                                              |'
echo '================================================================================'


# check if it is Jessie or Stretch
osInfo=$(cat /etc/os-release)
if [[ $osInfo == *"jessie"* || $osInfo == *"stretch"* ]] ; then
  isJessieOrStretch=true
else
  isJessieOrStretch=false
fi

# check git installed
if [ $ERR -eq 0 ]; then
  echo '>>> Install wittyPi'
  if hash git 2>/dev/null; then
	echo "Git is ready to go..."
  else
	echo "Git is missing, install it now..."
    apt-get install -y git || ((ERR++))
  fi
fi

# install ThinkBioT
if [ $ERR -eq 0 ]; then
  echo '>>> Install ThinkBioT'
  if [ -d "ThinkBioT" ]; then
    echo 'Seems ThinkBioT is installed already, skip this step.'
  else
    wget http://www.uugear.com/repo/WittyPi2/LATEST -O wittyPi.zip || ((ERR++))
    unzip ThinkBioT.zip -d ThinkBioT || ((ERR++))
    cd ThinkBioT
    chmod +x ThinkBioT.sh
    chmod +x daemon.sh
    chmod +x syncTime.sh
    chmod +x runScript.sh
    chmod +x extraTasks.sh
    sed -e "s#/home/pi/wittyPi#$DIR#g" init.sh >/etc/init.d/wittypi
    chmod +x /etc/init.d/wittypi
    update-rc.d wittypi defaults
    cd ..
    chown -R pi:pi wittyPi
    sleep 2
    rm wittyPi.zip
  fi
fi

echo
if [ $ERR -eq 0 ]; then
  echo '>>> All done. Please reboot your Pi :-)'
else
  echo '>>> Something went wrong. Please check the messages above :-('
fi
