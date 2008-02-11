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

SQL_PREFIX = "'"
SQL_SUFFIX = "', "
SQL_EMPTY = "'', "

MAX_BOT_RATING = 0

"""
------------------------------------------------
 Bean Definitions for Object Mapping
------------------------------------------------
"""

class ScanFeed:
	def __init__(self):
		self.mainUrl = None
		self.urlTitle = None
		self.urlDescription = None
		self.urlSource = None

class FeedItem:
	def __init__(self):
		self.mainUrl = None
		self.urlTitle = None
		self.urlDescription = None
		self.urlSource = None
		self.channelURL = None
    
	def verify(self):
		""" Because we are inserting these values into the database,
		ensure that a zero length value is returned as opposed to null"""
		self.channelURL =  self.channelURL and self.channelURL or ''
		self.channelURL = self.channelURL.strip()
		
class EntityLink:
	def __init__(self):
		self.mainUrl = None
		self.urlTitle = None
		self.urlDescription = None

class CountFeedItems:
	def __init__(self):
		self.count = None

#--------------------------------------
class ScanFeedHandler(BotlistBusinessObject):    
	
	def createItem(self, url, title, descr, source, hostname):
		try:
			sql_set = []
			sql_set.append("insert into system_feed_items(main_url, url_title, url_description, url_source, hostname) values(")
			sql_set.append(SQL_PREFIX + "%s" + SQL_SUFFIX)      # main_url
			sql_set.append(SQL_PREFIX + "%s" + SQL_SUFFIX)      # url_title
			sql_set.append(SQL_PREFIX + "%s" + SQL_SUFFIX)      # url_descr
			sql_set.append(SQL_PREFIX + "%s" + SQL_SUFFIX)      # url_source
			sql_set.append(SQL_PREFIX + "%s" + SQL_PREFIX)      # hostname
			sql_set.append(")")
			sql_str = ''.join(sql_set)            
			cursor = self.conn.cursor()            
			url_val = url.encode("utf-8").replace("'", "")
			title_val = title.encode("utf-8").replace("'", "")
			descr_val = descr.encode("utf-8").replace("'", "")
			source_val = source.encode("utf-8").replace("'", "")
			host_val = hostname.encode("utf-8").replace("'", "")
			cursor.execute(sql_str % (url_val, title_val, descr_val, source_val, host_val))
			cursor.close()
		except Exception, ex:
			# Typically a unique id exception            
			raise ex
	
	def updateInsertEntityProcessCount(self, link, title, user_name, hostname):
		""" Complete transfer by inserting into the entity link table
		for display to the user"""
		data = None
		try:
			cursor = self.conn.cursor()
			sql_set = []
			sql_set.append("update system_feed_items set process_count = 1 where main_url = '%s'")
			sql_str = ''.join(sql_set)
			cursor.execute(sql_str % link)
			sql_set = None
			
			# Filter title and keywords                        
			cleanTitle = textutils.filterNonAscii(title.encode('utf-8', 'ignore'))            
			keywordTitle = textutils.createKeywords(cleanTitle)        
			
			if MAX_BOT_RATING > 0:
				rnd_val = random.randint(1, MAX_BOT_RATING)
			else:
				rnd_val = 0
				
			sql_set2 = []
			sql_set2.append("insert into entity_links(main_url, url_title, full_name, keywords, rating, hostname, created_on) values(")
			sql_set2.append(SQL_PREFIX + "%s" + SQL_SUFFIX)     # main_url
			sql_set2.append(SQL_PREFIX + "%s" + SQL_SUFFIX)     # title  
			sql_set2.append(SQL_PREFIX + "%s" + SQL_SUFFIX)     # username
			sql_set2.append(SQL_PREFIX + "%s" + SQL_SUFFIX)     # keywords									
			sql_set2.append("%s,")                              # rating (currently set to random value)
			if hostname:
				sql_set2.append(SQL_PREFIX + "%s" + SQL_SUFFIX)	# hostname
			else:
				# Create a record with a NULL entry
				hostname = "NULL"
				sql_set2.append("%s,")     						# hostname
				
			sql_set2.append("NOW())")                           # created_on                            
			sql_str = ''.join(sql_set2)			
			cursor.execute(sql_str % (link, cleanTitle, user_name, keywordTitle, rnd_val, hostname))
			cursor.close()
		except MySQLdb.OperationalError, message:
			errorMessage = "ERR %d:\n%s" % (message[0], message[1])
			return 0
	
	def hasEntityLink(self, link):
		data = None
		try:
			cursor = self.conn.cursor()
			sql_set = []
			sql_set.append("select count(1) from entity_links where main_url = '%s'")
			sql_str = ''.join(sql_set)
			cursor.execute(sql_str % (link))
			data = cursor.fetchall()            
			cursor.close()
		except MySQLdb.OperationalError, message:
			errorMessage = "ERR %d:\n%s" % (message[0], message[1])
			print errorMessage
			return 0
		
		if data:
			if len(data) > 0:                
				return data[0][0]
			else:
				return 0
		else:
			return 0
	
	def listSystemFeedItems(self):
		"""System feed item articles have been inserted, now tranfer
		these items into the entity links table"""
		data = None
		try:
			cursor = self.conn.cursor()
			sql_set = []
			sql_set.append("select main_url, url_title, url_description, url_source, hostname from system_feed_items where process_count = 0 order by RAND()")
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
		for row in data:
			# FeedItem(rs,rs,rs,rs)
			feed_item = FeedItem()
			feed_item.mainUrl = cgi.escape(row[0])
			feed_item.urlTitle = cgi.escape(row[1])
			feed_item.urlDescription = cgi.escape(row[2])
			feed_item.urlSource = cgi.escape(row[3])
			if row[4]:
				feed_item.channelURL = cgi.escape(row[4])
				
			transform_data.append(feed_item)
			
		return transform_data
	
	def listScanFeeds(self):
		"""Return a list of ScanFeed items"""
		data = None
		try:
			cursor = self.conn.cursor()
			sql_set = []
			sql_set.append("select main_url, url_title, url_description, url_source from system_scan_feeds")            
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
			return None        
		
		# Transform into a list of simple objects
		transform_data = []
		for row in data:
			feed = ScanFeed()
			feed.mainUrl = cgi.escape(row[0])
			feed.urlTitle = cgi.escape(row[1])
			feed.urlDescription = cgi.escape(row[2])
			feed.urlSource = cgi.escape(row[3])
			transform_data.append(feed)
			
		return transform_data
	
 # End of the file