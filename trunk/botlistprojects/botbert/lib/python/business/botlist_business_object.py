"""
 Berlin Brown
 6/20/2007
"""
__author__ = "Berlin Brown"
__version__ = "0.1"

import sys
import MySQLdb
import util.config_util as conf

#--------------------------------------
class BotlistBusinessObject:
    def __init__(self):
        # Load the configuration file with db settings.
        conf_type = conf.get_parse_config()
        self.conn = None
        self.username = conf_type.username
        self.passwd = conf_type.password
        self.db = conf_type.database
        self.hostname = conf_type.hostname
        self.update_count = 0
         
    def connect(self):
        try:
            self.conn = MySQLdb.connect(host=self.hostname,
                                        user=self.username, passwd=self.passwd, db=self.db)
            if self.conn is None:
                raise Exception("connect(): Could not make connection to database")
            
            print "INFO: opening connection"
            return
        except MySQLdb.OperationalError, message:
            errorMessage = "ERR %d:\n%s" % (message[0], message[1])
            print errorMessage
            sys.exit()
            return
        except Exception, e:
            print "ERR: business_object.connect() %s" % e
            raise Exception("connect(): Could not make connection to database")
        sys.exit()
        
    def closeConn(self):
        print "INFO: closing connection"
        if self.conn is None:
            print "ERR: Invalid connection, connection is not open."
            print "ERR: Check the database connection settings."
        else:
            self.conn.close()
            
    def createCursor(self, obj):
        try:
            pass
        except MySQLdb.OperationalError, message:
            errorMessage = "ERR %d:\n%s" % (message[0], message[1])
            return
 
# End of script
