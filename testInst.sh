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
  if [ -d "testInst" ]; then
    echo 'Seems testInst is installed already, skip this step.'
  else

    sleep 2
  fi
fi

echo
if [ $ERR -eq 0 ]; then
  echo '>>> All done. Please reboot your Pi :-)'
else
  echo '>>> Something went wrong. Please check the messages above :-('
fi
