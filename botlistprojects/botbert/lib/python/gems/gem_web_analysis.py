"""
 Berlin Brown
 10/20/2007

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
"""
__author__ = "Berlin Brown"
__version__ = "0.1"

import util.generate_unique_id as uuid

# Use category gem in order to build category data
from gems.botlist_category import BotlistProcessCategory
from gems.botlist_category import generateTopWordType

from business.entity_link_bom import EntityLinkHandler
from business.entity_link_bom import PROCESS_STATUS_ANALYTICS

from business.audit_log_bom import AuditLogHandler

import datetime
import gems.web.scan_url as scan_url

import urllib2

MAX_ENTITY_LINKS = 20000
MAX_ENTITY_LINKS_ANALYTICS = 1000
				
#-------------------------------------------------
class EntityLinkWebAnalysisJob:

	def __init__(self):
		self.passed_ct = -1
		self.link_handler = EntityLinkHandler()
			
	def init(self):		
		self.link_handler.connect()
		
	def shutdown(self):
		self.link_handler.closeConn()
		print "INFO: CLEANLY shutdown database connection"

	def processURLs(self):
		""" Iterate through the list of web URLs and set web information"""
		PROCESS_CT_ID = 3
		sql_where_clause = "where (process_count < %s)" % PROCESS_CT_ID
		max_links_proc = MAX_ENTITY_LINKS_ANALYTICS
		data = self.link_handler.listEntityLinks(result_limit=max_links_proc,
												 where_clause=sql_where_clause)
		opener = urllib2.build_opener()
		cur_time = datetime.datetime.now()
		print "INFO [%s]: requesting URL data MAX=%s" % (cur_time, max_links_proc)
		for node in data:
			try:				
				web_model = scan_url.extractPageData(opener, node.mainUrl)
				
				# Update the entity link to set web data analysis
				if web_model:
					self.link_handler.updateWebAnalytics(node,
														 web_model,
														 PROCESS_STATUS_ANALYTICS)
			except Exception, e:
				cur_time = datetime.datetime.now()
				print "ERR [%s]:processURLs url=%s" % (cur_time, node.mainUrl)
				print e

		# quick summary
		print "INFO: links updated=%s" % self.link_handler.update_count
		
	def processObjectId(self):
		""" Cleanup the entity link system, clean keywords"""

		print " setting object id with max entity link set:[%s]" % MAX_ENTITY_LINKS		
		PROCESS_CT_VERS = 1
		sql_where_clause = "where (object_id_status < %s)" % PROCESS_CT_VERS
		data = self.link_handler.listEntityLinks(result_limit=MAX_ENTITY_LINKS,
												 where_clause=sql_where_clause)
		for node in data:
			try:				
				web_analysis = scan_url.WebAnalysisModel()								
				uid_modifier = "objid:%s" % node.obj_id
				web_analysis.generated_obj_id = uuid.botlist_uuid(uid_modifier)			
				
				# Update the entity link to set the link group type
				self.link_handler.updateObjectId(node, web_analysis, PROCESS_CT_ID)
			except Exception, e:
				print e
				
		# quick summary
		print "INFO: category links updated=%s" % self.link_handler.update_count
		
# End of Script
