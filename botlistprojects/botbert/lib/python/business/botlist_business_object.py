"""
 Berlin Brown
 6/20/2007
 
  -------------------------- COPYRIGHT_AND_LICENSE --
 Botlist contains an open source suite of software applications for 
 social bookmarking and collecting online news content for use on the web.  
 Multiple web front-ends exist for Django, Rails, and J2EE.  
 Users and remote agents are allowed to submit interesting articles.

 Copyright (c) 2007, Botnode.com (Berlin Brown)
 http://www.opensource.org/licenses/bsd-license.php

 All rights reserved.

 Redistribution and use in source and binary forms, with or without modification, 
 are permitted provided that the following conditions are met:

	    * Redistributions of source code must retain the above copyright notice, 
	    this list of conditions and the following disclaimer.
	    * Redistributions in binary form must reproduce the above copyright notice, 
	    this list of conditions and the following disclaimer in the documentation 
	    and/or other materials provided with the distribution.
	    * Neither the name of the Botnode.com (Berlin Brown) nor 
	    the names of its contributors may be used to endorse or promote 
	    products derived from this software without specific prior written permission.
	
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 -------------------------- END_COPYRIGHT_AND_LICENSE --
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
