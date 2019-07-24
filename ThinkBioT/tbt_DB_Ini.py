import sqlite3

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

############### Settings ####################
#DB Name
DB_NAME = "../tbt_database"

#SQL File with Table Schema and Initialization Data
SQL_File_Name = "tbt_dbSchema.sql"
##############################################

#Read Table Schema into a Variable and remove all New Line Chars
TableSchema=""
with open(SQL_File_Name, 'r') as SchemaFile:
 TableSchema=SchemaFile.read().replace('\n', '')

#Connect or Create DB File
conn = sqlite3.connect(DB_NAME)
#Enable Foreign Keys
conn.execute("PRAGMA foreign_keys = 1")
curs = conn.cursor()

#Create Tables from SchemaFile
sqlite3.complete_statement(TableSchema)
curs.executescript(TableSchema)
curs.close()
conn.close()