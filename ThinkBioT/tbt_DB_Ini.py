import sqlite3

############### Settings ####################
#DB Name
DB_NAME = "./ThinkBioT/tbt_database"

#SQL File with Table Schema and Initialization Data
SQL_File_Name = "./ThinkBioT/tbt_dbSchema.sql"
##############################################

try:
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
	
except sqlite3.Error, e:

    print e
    sys.exit(1)
finally:
    if conn:
        #Close DB
		curs.close()
		conn.close()