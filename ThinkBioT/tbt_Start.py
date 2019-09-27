#! /usr/local/bin/python3

"""
    LICENSE:
    ThinkBioT is an Bioacoustic sensor framework for the collection, processing
    and satellite transmission of Bio-Taxa Classification and Acoustic Indicies data.
    Copyright (C) 2019  Marita Fitzgerald
    
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

    SUPPORT:
    https://github.com/mefitzgerald/ThinkBioT/issues

"""

import os
import datetime

def main():
    # update log file
    f= open("/home/pi/ThinkBioT/tbt_log.txt","a+")
    f.write("tbt_Start Run at: " + str(datetime.datetime.now()) + "\n")
    f.close()
    os.system('sh /home/pi/ThinkBioT/tbt_startCycle.sh')
    
if __name__== "__main__":
  main()