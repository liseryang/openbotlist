"""
 Berlin Brown
 6/20/2007
 
 Email popular content
"""
__author__ = "Berlin Brown"
__version__ = "0.1"

import sys
import urllib
import urllib2
import datetime
import time
import smtplib

from business.entity_link_bom import EntityLinkHandler
from business.audit_log_bom import AuditLogHandler

EMAIL_LIST = [
	"bbrown@houston",
	"berlin.brown@gmail.com"	
]

MSG_ID_ATTEMPT_SEND = "000010"
MSG_ID_EMAIL_SENT = "000012"
LOG_LEVEL = "INFO"

#--------------------------------------
class EntityLinkEmailJob:
	def __init__(self):
		self.email_set = []
		self.link_data = None
		self.no_passed = -1
	
	def processEmailSet(self):
		str_link_data = self.buildLinkData()
		self.link_data = str_link_data
		
		# Set message audit
		auditLog = AuditLogHandler()
		auditLog.connect()
		auditLog.createAudit('EntityLinkEmailJob', MSG_ID_ATTEMPT_SEND, "sending email set", LOG_LEVEL, '')			
		self.no_passed = 0
		try:
			for email in self.email_set:	
				self.sendEmail(email)
		except Exception, err:
			print "ERR: send email set failed"
			print err
			
		# Process results and send the audit log
		email_sent_msg = "emails sent (%s)" % self.no_passed
		auditLog.createAudit('EntityLinkEmailJob', MSG_ID_EMAIL_SENT, email_sent_msg, LOG_LEVEL, '')
		auditLog.closeConn()
	
	def sendMailConnect(self, serverURL=None, sender='', to='', subject='', text=''):
		"""
		Usage:
		mail('somemailserver.com', 'me@example.com', 'someone@example.com', 'test', 'This is a test')
		"""
		headers = "From: %s\r\nTo: %s\r\nSubject: %s\r\n\r\n" % (sender, to, subject)
		message = headers + text
		mailServer = smtplib.SMTP(serverURL)
		mailServer.sendmail(sender, to, message)		
		mailServer.quit()
		self.no_passed = self.no_passed + 1
		
		
	def sendEmail(self, email_addr):
		self.sendMailConnect('localhost', 'webadmin@botspiritcompany.com',
				     email_addr, 'Recent Botlist Updates', self.link_data)
				
	def buildLinkData(self):		
		start_time = time.time()
		entity_handler = EntityLinkHandler()
		entity_handler.connect()
		link_data = entity_handler.listEntityLinks()
		
		str_buf_data = []		
		for link in link_data:
			try:				
				str_buf_data.append(link.mainUrl + "\n")
				str_buf_data.append(link.urlTitle + "\n\n")
			except Exception, e:
				print "ERROR: generic error while retrieving data"
				
		entity_handler.closeConn()
		end_time = time.time()			
		diff = end_time - start_time
		return ''.join(str_buf_data)
		
def createEmailPopular():
	email_handler = EntityLinkEmailJob()
	email_handler.email_set = EMAIL_LIST
	email_handler.processEmailSet()

def main():
	createEmailPopular()
			
if __name__ == '__main__':
	print "running"
	diff = 0; start_time = 0; end_time = 0	
	start_time = time.time()
	main()
	end_time = time.time()
		
	# Print simple summary
	diff = end_time - start_time
	print "completed in %s s" % diff
	print "press ENTER to continue"

# End of the File