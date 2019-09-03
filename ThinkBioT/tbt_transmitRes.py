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

sys.path.append('/home/pi/pyRockBlock')
print(sys.path)
import rockBlock
from rockBlock import rockBlockProtocol

def main():
    # Prepare database connector & cursor
    try:
        conn = sqlite3.connect('/home/pi/tbt_database')
    except Error:
        print(Error)
    c = conn.cursor()
    
    defSessionID = ('-1',)
    alert = 'chainsaw'

    # Set up rockblock
    # rb = rockBlock.rockBlock("/dev/ttyUSB0", self)
    
    #Get Session ID
    c.execute('SELECT MAX(SessionID) FROM TaskSession WHERE TransmittedTime =?', defSessionID)
    sessionID = c.fetchone()
    tx_sessionID = sessionID[0]
    print("Task session ID: " + str(tx_sessionID))
    
    #Get ACI
    c.execute('SELECT IndexTaskResult FROM AcousticIndexTasks WHERE IndexTaskType = ? AND SessionID = ?', ('Acoustic_Complexity_Index median', tx_sessionID,) )
    aci = c.fetchone()
    tx_aci = aci[0]
    print("Acoustic Complexity Index: " + tx_aci)
    
    #Get ADI
    c.execute('SELECT IndexTaskResult FROM AcousticIndexTasks WHERE IndexTaskType = ? AND SessionID = ?', ('Acoustic_Diversity_Index_NR main_value', tx_sessionID,) )
    adi = c.fetchone()
    tx_adi = adi[0]
    print("Acoustic Diversity Index: " + tx_adi)
    
    #Get AEI
    c.execute('SELECT IndexTaskResult FROM AcousticIndexTasks WHERE IndexTaskType = ? AND SessionID = ?', ('Acoustic_Evenness_Index main_value', tx_sessionID,) )
    aei = c.fetchone()
    tx_aei = aei[0]
    print("Acoustic Evenness Index: " + tx_aei)
    
    #Get BI
    c.execute('SELECT IndexTaskResult FROM AcousticIndexTasks WHERE IndexTaskType = ? AND SessionID = ?', ('Bio_acoustic_Index_NR main_value', tx_sessionID,) )
    bi = c.fetchone()
    tx_bi = bi[0]
    print("Bioacoustic Index: " + tx_bi)
    
    #Get ND
    c.execute('SELECT IndexTaskResult FROM AcousticIndexTasks WHERE IndexTaskType = ? AND SessionID = ?', ('Normalized_Difference_Sound_Index main_value', tx_sessionID,) )
    ndsi = c.fetchone()
    tx_ndsi = ndsi[0]
    print("Normalized Difference Sound Index: " + tx_ndsi)

    #Get Classes Count
    c.execute('SELECT COUNT ( DISTINCT ClassTaskResult ) FROM ClassTasks WHERE SessionID = ?', (tx_sessionID,))
    speciesCount = c.fetchone()
    tx_speciesCount = speciesCount[0]
    print("Classes Count: " + str(tx_speciesCount))
    
    #Get Samples Count
    c.execute('SELECT COUNT ( ClassTaskResult ) FROM ClassTasks WHERE SessionID = ?', (tx_sessionID,))
    samplesCount = c.fetchone()
    tx_samplesCount = samplesCount[0]
    print("Samples Count: " + str(tx_samplesCount))
    
    #Get Alert Count
    c.execute('SELECT COUNT ( ClassTaskResult ) FROM ClassTasks WHERE SessionID = ? AND ClassTaskResult = ? ', (tx_sessionID, alert,))
    alertCount = c.fetchone()
    tx_alertCount = alertCount[0]
    print("Alert Count: " + str(tx_alertCount))
    
    #Get latitude
    c.execute('SELECT TestLat FROM TaskSession WHERE SessionID = ?', (tx_sessionID,) )
    latitude = c.fetchone()
    tx_latitude = latitude[0]
    print("Latitude: " + tx_latitude)
    
    #Get longitude
    c.execute('SELECT TestLong FROM TaskSession WHERE SessionID = ?', (tx_sessionID,) )
    longitude = c.fetchone()
    tx_longitude = longitude[0]
    print("Longitude: " + tx_longitude)
    
    #Get elevation
    c.execute('SELECT TestElevation FROM TaskSession WHERE SessionID = ?', (tx_sessionID,) )
    elevation = c.fetchone()
    tx_elevation = elevation[0]
    print("Elevation: " + tx_elevation)
    
    # Tx format
    # datetime,field1,field2,field3,field4,field5,field6,field7,field8,latitude,longitude,elevation
    msg = datetime +"," + tx_aci +"," + tx_adi + ","
    + tx_aei + "," + tx_bi + "," + tx_ndsi + "," + tx_speciesCount + ","
    + tx_samplesCount + "," + tx_alertCount + "," + tx_latitude + "," + tx_longitude + "," + tx_elevation
    print(msg)
    #rb.sendMessage(msg)
    #rb.close()
        
def rockBlockTxStarted(self):
    print ("rockBlockTxStarted")
        
def rockBlockTxFailed(self):
    print ("rockBlockTxFailed")
        
def rockBlockTxSuccess(self,momsn):
    print ("rockBlockTxSuccess " + str(momsn))
    
    
if __name__ == "__main__":
    main()

