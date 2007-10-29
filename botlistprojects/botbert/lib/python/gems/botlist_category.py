"""
 Berlin Brown
"""

__author__ = "Berlin Brown"
__version__ = "0.1"

import urllib2
from urlparse import urlparse

from business.entity_link_bom import EntityLinkHandler
from sets import Set as set

from score_tags import ScoreTagHandler

MAX_ENTITY_LINKS = 40000

BOT_TERMS_SERVICE = "http://localhost:8080/botlist/spring/bots/bot_groups.html"
ROVER_USER_AGENT = "botlist services 0.1 - like Mozilla Firefox but better"

class BotlistProcessCategory:
	
	def __init__(self):
		self.link_handler = EntityLinkHandler()
		# Data structure to hold the groups and their terms
		self.terms_dict = { }
		
	def init(self):		
		self.link_handler.connect()
		
	def shutdown(self):
		self.link_handler.closeConn()
		
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
				
	def procesCategory(self):
		""" Cleanup the entity link system, clean keywords"""
		sql_where_clause = "where (process_count < 2)"
		data = self.link_handler.listEntityLinks(result_limit=MAX_ENTITY_LINKS, where_clause=sql_where_clause)
		for node in data:
			try:
				url_title = node.urlTitle
				keywords = node.keywords
				str_merge = "%s %s" % (url_title, keywords)				
				str_merge = str_merge.lower()
				
				score_handler = ScoreTagHandler()
				score_handler.terms_dict = self.terms_dict
				score_handler.keywords = str_merge
				score_handler.resetGroupScores()
				top_group = score_handler.scoreTerms()				
				if top_group:					
					# Update the entity link to set the link group type
					self.link_handler.updateCategory(node, top_group, 2)
			except Exception, e:
				print e
				
		# quick summary
		print "INFO: category links updated=%s" % self.link_handler.update_count

# End of the file