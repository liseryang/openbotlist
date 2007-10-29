"""
 Berlin Brown
 botlist_sweep.py
"""

__author__ = "Berlin Brown"
__version__ = "0.1"

from business.entity_link_bom import EntityLinkHandler
from process_stopwords import BOTLIST_STOP_WORDS
from sets import Set as set

MAX_ENTITY_LINKS = 50000

class BotlistSweepLinks:
	
	def __init__(self):
		self.link_handler = EntityLinkHandler()
		
	def init(self):		
		self.link_handler.connect()
		
	def shutdown(self):
		self.link_handler.closeConn()
		
	def filterStopwords(self, keywords):
		""" Find all of the stopwords and remove them"""
		res = []
		keywords_list = keywords.lower().split()
		res = list(set(keywords_list).difference(set(BOTLIST_STOP_WORDS)))
		
		# Return the new keyword string
		return " ".join(res)
	
	def sweep(self):
		""" Cleanup the entity link system, clean keywords"""
		sql_where_clause = "where (process_count = 0) and (full_name = 'botbert99' or full_name = 'botrover99')"
		data = self.link_handler.listEntityLinks(result_limit=MAX_ENTITY_LINKS, where_clause=sql_where_clause)
		for node in data:
			try:				
				new_keywords = self.filterStopwords(node.keywords)
				self.link_handler.updateKeywords(node, new_keywords)
			except Exception, e:
				print e

# End of the file