"""
 Berlin Brown
 6/20/2007
 
 business object model

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

PROCESS_STATUS_KEYWORDS = 1
PROCESS_STATUS_CATEGORY = 2
PROCESS_STATUS_ANALYTICS = 3

class EntityLink:
	def __init__(self):
		self.mainUrl = None
		self.urlTitle = None
		self.obj_id = None
		self.keywords = None
		self.urlDescription = None

#--------------------------------------
class EntityLinkHandler(BotlistBusinessObject):		
	
	def updateKeywords(self, link, new_keywords):
		try:
			cursor = self.conn.cursor()
			sql_set = []			
			query = "update entity_links set keywords ='%s', updated_on = NOW(), process_count = 1 where id = %s"
			sql_set.append(query)
			sql_str = ''.join(sql_set)
			cursor.execute(sql_str % (new_keywords, link.obj_id))
			cursor.close()
			self.update_count = self.update_count + 1
		except MySQLdb.OperationalError, message:
			errorMessage = "ERR %d:\n%s" % (message[0], message[1])
			print errorMessage
			return None
	
	def updateCategory(self, link, link_category, process_count):
		""" Update the entity link link_type"""
		try:
			cursor = self.conn.cursor()
			sql_set = []			
			query = "update entity_links set link_type ='%s', updated_on = NOW(), process_count = %s where id = %s"
			sql_set.append(query)
			sql_str = ''.join(sql_set)
			cursor.execute(sql_str % (link_category, process_count, link.obj_id))
			cursor.close()
			self.update_count = self.update_count + 1
		except MySQLdb.OperationalError, message:
			errorMessage = "ERR %d:\n%s" % (message[0], message[1])
			print errorMessage
			return None

	def updateWebAnalytics(self, link,
						   web_model,
						   process_id_status):
		""" Update with page analytic data"""
		try:
			cursor = self.conn.cursor()
			sql_set = []
			q = []
			#******************************
			# First, build the SQL string with parameter variables
			# then set the parameter values 
			#******************************
			q.append("update entity_links")
			q.append(" set links_ct = %s")         # (1)
			q.append(" ,image_ct = %s")            # (2)
			q.append(" ,meta_descr_len = %s")      # (3)
			q.append(" ,meta_keywords_len = %s")   # (4)
			q.append(" ,meta_descr_wct = %s")      # (5)
			q.append(" ,meta_keywords_wct = %s")   # (6)
			q.append(" ,document_size = %s")       # (7)
			q.append(" ,request_time = %s")        # (8)
			q.append(" ,para_tag_ct = %s")       # (9)
			q.append(" ,updated_on = NOW(), process_count = %s where id = %s")
			query = ''.join(q)
			sql_set.append(query)
			sql_str = ''.join(sql_set)
			cursor.execute(sql_str % (
				web_model.links_ct,
				web_model.image_ct,
				web_model.meta_descr_len,
				web_model.meta_keywords_len,
				web_model.meta_descr_wct,
				web_model.meta_keywords_wct,
				web_model.document_size,
				web_model.request_time,
				web_model.para_tag_ct,
				process_id_status,
				link.obj_id))
			cursor.close()
			self.update_count = self.update_count + 1
		except MySQLdb.OperationalError, message:
			errorMessage = "ERR %d:\n%s" % (message[0], message[1])
			print errorMessage
			return None			

	def updateObjectId(self, link, web_analysis, object_id_status):
		""" Update the entity link object ID.  Take care in making
		sure that this object id is not modified (static instance)
		(see gem_web_analysis for how web analytics is updated).
		"""
		try:
			cursor = self.conn.cursor()
			sql_set = []			
			query = "update entity_links set generated_obj_id ='%s', updated_on = NOW(), object_id_status = %s where id = %s"
			sql_set.append(query)
			sql_str = ''.join(sql_set)
			cursor.execute(sql_str % (web_analysis.generated_obj_id,
									  object_id_status, link.obj_id))
			cursor.close()
			self.update_count = self.update_count + 1
		except MySQLdb.OperationalError, message:
			errorMessage = "ERR %d:\n%s" % (message[0], message[1])
			print errorMessage
			return None
			
	def listEntityLinks(self, result_limit=10, where_clause=None):
		data = None
		try:
			cursor = self.conn.cursor()
			sql_set = []
			if where_clause:
				where_str = where_clause
			else:
				where_str = ""				
			query = "select main_url, url_title, id, keywords from entity_links %s order by created_on desc LIMIT 0, %s" % (where_clause, result_limit)
			sql_set.append(query)
			sql_str = ''.join(sql_set)
			cursor.execute(sql_str)
			data = cursor.fetchall() 
			self.fields = cursor.description                         
			cursor.close()
		except MySQLdb.OperationalError, message:
			errorMessage = "ERR %d:\n%s" % (message[0], message[1])
			print errorMessage
			return None        
		if not data:
			raise "ERR: No data returned during listSystemFeedItems() call (try to run a scan on feeds)."        
		transform_data = []
		errs_found = 0
		for row in data:
			try:
				link_item = EntityLink()
				link_item.mainUrl = cgi.escape(row[0])
				link_item.urlTitle = cgi.escape(row[1])
				link_item.obj_id = int(row[2])
				link_item.keywords = cgi.escape(row[3])
				transform_data.append(link_item)				
			except Exception, e:
				errs_found = errs_found + 1
				
		return transform_data

 # End of the file
