"""
 Berlin Brown
 6/20/2007
 
 business object model
"""
__author__ = "Berlin Brown"
__version__ = "0.1"

import MySQLdb
import cgi
import random
import util.keyword_processor as textutils

from botlist_business_object import BotlistBusinessObject

"""
------------------------------------------------
 Bean Definitions for Object Mapping
------------------------------------------------
"""

class AuditLog:
	def __init__(self):
		self.applicationName = None
		self.message = None
		self.logLevel = None
		self.sendTo = ''
		self.messageId = '000000'

#--------------------------------------
class AuditLogHandler(BotlistBusinessObject):
	
	def createAudit(self, app_name, msg_id, msg, log_level, send_to):
		audit_entry = AuditLog()
		audit_entry.applicationName = app_name
		audit_entry.messageId = msg_id
		audit_entry.message = msg
		audit_entry.logLevel = log_level
		audit_entry.sendTo = send_to
		self.createAuditEntry(audit_entry)
	
	def createAuditEntry(self, audit_entry):
		data = None
		try:
			cursor = self.conn.cursor()
			sql_set = []            
			sql_set.append("insert into system_audit_log ")
			sql_set.append("(application_name, message_id, message, log_level, send_to) ")	    
			sql_set.append("VALUES('%s', '%s', '%s', '%s', '%s')")
			sql_str = ''.join(sql_set)
			cursor.execute(sql_str %
                           (audit_entry.applicationName, audit_entry.messageId, audit_entry.message, audit_entry.logLevel, audit_entry.sendTo))
			cursor.close()
		except MySQLdb.OperationalError, message:
			errorMessage = "ERR %d:\n%s" % (message[0], message[1])
			print errorMessage
			return None

 # End of the file