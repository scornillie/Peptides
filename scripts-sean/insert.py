#!/usr/bin/python2.6
import os
import sys
import sqlite3

dbpath = sys.argv[1]
tempname = sys.argv[2]
option = sys.argv[3]
column = sys.argv[4]
value = sys.argv[5]

print 'DB: Option sent:', option 
print 'DB: Temporal directory name =', tempname

### Connect to Database and check connection
db = sqlite3.connect(dbpath)
db.isolation_level = 'EXCLUSIVE'
db.execute('BEGIN EXCLUSIVE')
print "DB: Opened database succesfully";

### Insert data acording to argument
if option == 'init':
    print 'DB: Option selected:', option     
    db.execute("INSERT INTO data(temporal_name) VALUES (?)", [tempname]);
    print 'DB: New record inserted successfully'

elif option == 'update':
    print 'DB: Option selected:', option 
    print 'DB: column:', column
    print 'DB: value:', value
    db.execute("UPDATE data SET %s=? WHERE temporal_name=?" % (column,),(value,tempname,))
    print 'DB: Record updated successfully'

### Commit info to db
db.commit()

db.close()

print 'DB: Connection closed'
