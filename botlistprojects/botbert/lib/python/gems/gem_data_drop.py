"""
 Berlin Brown
 10/20/2007
 
 Extract data from the entity links data
 into common delimited file.
"""
__author__ = "Berlin Brown"
__version__ = "0.1"

import sys
import urllib
import urllib2
import datetime
import time

from business.entity_link_bom import EntityLinkHandler
from business.audit_log_bom import AuditLogHandler

MAX_LINKS_PROCESS = 10

MSG_ID_DATA_DROP = "000015"
LOG_LEVEL = "INFO"

#--------------------------------------
class EntityLinkDataDropJob:
	
	def __init__(self):		
		self.no_passed = -1
	
	def processDataDrop(self, result_limit):
		self.buildLinkData(drop_result_limit = result_limit)
		
		# Set message audit
		auditLog = AuditLogHandler()
		auditLog.connect()					
		# Process results and send the audit log
		sent_msg = "data drop (%s)" % self.no_passed
		auditLog.createAudit('EntityLinkDataDropJob', MSG_ID_DATA_DROP, sent_msg, LOG_LEVEL, '')
		auditLog.closeConn()
			
	def buildLinkData(self, drop_result_limit=MAX_LINKS_PROCESS):
		try:
			
			# Open output data file
			fout = open("/home/bbrown/botlist_datadump.dat", "w")			
			start_time = time.time()
			entity_handler = EntityLinkHandler()
			entity_handler.connect()
			link_data = entity_handler.listEntityLinks(result_limit=drop_result_limit)
			for link in link_data:
				try:				
					fout.write("%s\t%s\t%s\n" % (link.mainUrl, link.urlTitle, link.keywords))
				except Exception, e:
					print "ERROR: generic error while retrieving data"
		finally:
			fout.close()
			entity_handler.closeConn()
			end_time = time.time()			
			diff = end_time - start_time
			
def runDataDrop(result_limit):
	handler = EntityLinkDataDropJob()
	handler.processDataDrop(MAX_LINKS_PROCESS)
	
def main():
	print "running data drop"
	diff = 0; start_time = 0; end_time = 0	
	start_time = time.time()
	runDataDrop(MAX_LINKS_PROCESS)
	end_time = time.time()
	
	# Print simple summary
	diff = end_time - start_time
	#print "completed in %s s" % diff
	#print "press ENTER to continue"
			
if __name__ == '__main__':	
	main()

# End of the File
