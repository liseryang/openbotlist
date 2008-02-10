"""
 Berlin Brown

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

import urllib2
from urlparse import urlparse

from business.entity_link_bom import EntityLinkHandler
from business.entity_link_bom import PROCESS_STATUS_CATEGORY
from sets import Set as set

from score_tags import ScoreTagHandler

MAX_ENTITY_LINKS = 40000

BOT_TERMS_SERVICE = "http://localhost:8080/botlist/spring/bots/bot_groups.html"
ROVER_USER_AGENT = "botlist services 0.1 - (simple client connect)"

def generateTopWordType(node, loc_terms_dict):
	"""Function to generate the top word category type"""
	url_title = node.urlTitle
	keywords = node.keywords
	
	str_merge = "%s %s" % (url_title, keywords)				
	str_merge = str_merge.lower()				
	score_handler = ScoreTagHandler()
	score_handler.terms_dict = loc_terms_dict
	score_handler.keywords = str_merge
	score_handler.resetGroupScores()
	top_group = score_handler.scoreTerms()
	return top_group

class BotlistProcessCategory:	
	def __init__(self):
		self.link_handler = EntityLinkHandler()
		# Data structure to hold the groups and their terms
		self.terms_dict = { }
		
	def init(self):		
		self.link_handler.connect()
		
	def shutdown(self):
		self.link_handler.closeConn()
		print "INFO: CLEANLY shutdown database connection"
		
	def reqURLData(self, requrl):
		opener = urllib2.build_opener()
		req = urllib2.Request(requrl)
		req.add_header('user-agent', ROVER_USER_AGENT)
		data = opener.open(req).read()
		return data

	def findTerms(self, category_group):
		""" Perform a request for the terms """
		term_url = "%s?categorytype=%s" % (BOT_TERMS_SERVICE, category_group)
		data = self.reqURLData(term_url)
		terms = data.split()
		self.terms_dict[category_group] = terms		
		
	def buildTermSet(self):
		""" Connect to the bots category service and collect all categories and terms """
		# Get the category list
		data = self.reqURLData(BOT_TERMS_SERVICE)
		all_groups = data.split()
		for group in all_groups:
			try:
				self.findTerms(group)
			except Exception, e:
				print e
				
	def processCategory(self):
		""" Cleanup the entity link system, clean keywords"""
		sql_where_clause = "where (process_count != %s)" % PROCESS_STATUS_CATEGORY
		data = self.link_handler.listEntityLinks(result_limit=MAX_ENTITY_LINKS, where_clause=sql_where_clause)
		for node in data:
			try:
				top_group = generateTopWordType(node, self.terms_dict)
				if top_group:					
					# Update the entity link to set the link group type
					self.link_handler.updateCategory(node, top_group, PROCESS_STATUS_CATEGORY)
			except Exception, e:
				print e
				
		# quick summary
		print "INFO: category links updated=%s" % self.link_handler.update_count

# End of the file
