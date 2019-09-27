#!/usr/bin/env python

"""
# LICENSE:
# ThinkBioT is an Bioacoustic sensor framework for the collection, processing
# and satellite transmission of Bio-Taxa Classification and Acoustic Indicies data.
# Copyright (C) 2019  Marita Fitzgerald
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
# 
# SUPPORT:
# https://github.com/mefitzgerald/ThinkBioT/issues
"""

import sqlite3
import sys
import time

sys.path.append('/home/pi/pyRockBlock')
import rockBlock
from rockBlock import rockBlockProtocol
 
class MoExample (rockBlockProtocol):
    
    def main(self):
      
        rb = rockBlock.rockBlock("/dev/ttyUSB0", self)
        msg = "1568702271,1568276766.67,149.081,1.571,0.655,4.761,0,9,1,,,,"
        rb.sendMessage(msg)      
        
	rb.close()
        
    def rockBlockTxStarted(self):
        print "rockBlockTxStarted"
        
    def rockBlockTxFailed(self):
        print "rockBlockTxFailed"
        
    def rockBlockTxSuccess(self,momsn):
        print "rockBlockTxSuccess " + str(momsn)
        
if __name__ == '__main__':
    MoExample().main()

