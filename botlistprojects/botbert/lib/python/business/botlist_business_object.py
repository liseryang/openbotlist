"""
 Berlin Brown
 6/20/2007
"""
__author__ = "Berlin Brown"
__version__ = "0.1"

import MySQLdb

#--------------------------------------
class BotlistBusinessObject:
    def __init__(self):
         self.conn = None
         self.username = "USER"
         self.passwd = "PASSWORD"
         self.db = "botlist_development"
         self.hostname = "localhost"
         self.update_count = 0
         
    def connect(self):
        try:
            self.conn = MySQLdb.connect(host=self.hostname,
                                   user=self.username, passwd=self.passwd, db=self.db )
            print "INFO: opening connection"
        except MySQLdb.OperationalError, message:
            errorMessage = "ERR %d:\n%s" % (message[0], message[1])
            return
    
    def closeConn(self):
        print "INFO: closing connection"
        self.conn.close()
        
    def createCursor(self, obj):
        try:
            pass
        except MySQLdb.OperationalError, message:
            errorMessage = "ERR %d:\n%s" % (message[0], message[1])
            return
 
# End of script
