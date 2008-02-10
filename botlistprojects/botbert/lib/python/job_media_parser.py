"""
 Berlin Brown
 6/20/2007
"""
__author__ = "Berlin Brown"
__version__ = "0.1"

import sys
import urllib
import urllib2
import datetime
import time

from xml.dom.minidom import parse, parseString
from HTMLParser import HTMLParser

from business.media_bom import MediaHandler

MEDIA_URL = 'http://www.youtube.com/api2_rest'
DEFAULT_PER_PAGE = 30

MIN_RATING_CREATE = 3.4

#--------------------------------------
class MediaBean:
	def __init__(self):
		self.author = None
		self.title = None
		self.rating = -1
		self.rating_ct = None
		self.descr = None
		self.views = None
		self.keywords = None
		self.url = None
		self.thumbnail = None
		
	def verify(self):
		self.author = self.author and self.author or ''
		self.title = self.title and self.title or ''
		self.rating = self.rating and self.rating or -1
		self.rating_ct = self.rating_ct and self.rating_ct or -1
		self.descr = self.descr and self.descr or ''
		self.views = self.views and self.views or -1
		self.keywords = self.keywords and self.keywords or ''
		self.url = self.url and self.url or ''
		self.thumbnail = self.thumbnail and self.thumbnail or ''				
	
	def __str__(self):
		return "[title=%s, rating=%s, thumbnail=%s]" % (self.title, self.rating, self.thumbnail)
	
#--------------------------------------
class MediaFeedParser:
	def __init__(self):
		self.media_data = []
		self.media_created = 0
		
	def parseFeed(self, url):
		request=urllib2.Request(url) 
		request.add_header('User-Agent', 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727; InfoPath.1)') 
		opener = urllib2.build_opener()
		data = opener.open(request).read()
		return data
	
	def nodeValue(self, node):
		if node and node.firstChild:
			res = node.firstChild.nodeValue
			return res
		
	def parseMedia(self, node):
		author = node.getElementsByTagName("author")[0]
		title = node.getElementsByTagName("title")[0]
		rating = node.getElementsByTagName("rating_avg")[0]
		rating_ct = node.getElementsByTagName("rating_count")[0]
		descr = node.getElementsByTagName("description")[0]
		views = node.getElementsByTagName("view_count")[0]
		keywords = node.getElementsByTagName("tags")[0]
		url = node.getElementsByTagName("url")[0]
		thumbnail = node.getElementsByTagName("thumbnail_url")[0]
		
		media = MediaBean()
		# Transform this data into an object
		media.author = self.nodeValue(author)
		media.title = self.nodeValue(title)
		media.rating = self.nodeValue(rating)
		media.rating_ct = self.nodeValue(rating_ct)
		#media.descr = self.nodeValue(descr)
		media.descr = "no description"
		media.views = self.nodeValue(views)
		media.keywords = self.nodeValue(keywords)
		media.url = self.nodeValue(url)
		media.thumbnail = self.nodeValue(thumbnail)
		self.media_data.append(media)
		
	def parseXMLDoc(self, doc):
		rootNode = doc.documentElement
		videolistNode = rootNode.firstChild
		if videolistNode:
			videoList = videolistNode.getElementsByTagName("video")
			for video_item in videoList:
				self.parseMedia(video_item)
	
	def createMedia(self):
		ctr_passed = 0
		start_time = time.time()
		media_handler = MediaHandler()
		media_handler.connect()		
		for media in self.media_data:
			try:
				media.verify()
				if (media.rating and (float(media.rating) > MIN_RATING_CREATE)):					
					media_handler.createCursor(media)				
					ctr_passed = ctr_passed + 1
					self.media_created = self.media_created + 1
					
			except Exception, e:
				print "ERROR: generic error while retrieving data"
				# Generally errors include unique entry errors
				#print "ERROR: %s" % e
		media_handler.closeConn()
		end_time = time.time()
		
		# Print summary
		diff = end_time - start_time
		print "Total media created during run=%s" % ctr_passed		
		print "[created execution time in %s s]" % diff
		
	def parse(self, url):
		data = self.parseFeed(url)
		doc = parseString(data)
		self.parseXMLDoc(doc)

#--------------------------------------
def popularFeed(media_url, dev_id, time_range='day'):
	initialFeed = '%s?method=youtube.videos.list_popular&dev_id=%s&time_range=%s' % (media_url, dev_id, time_range)
	mediaParser = MediaFeedParser()
	mediaParser.parse(initialFeed)
	mediaParser.createMedia()

def mediaByTag(media_url, dev_id, tag, per_page=DEFAULT_PER_PAGE):
	initialFeed = '%s?method=youtube.videos.list_by_tag&dev_id=%s&tag=%s&page=1&per_page=%s' % (media_url, dev_id, tag, per_page)
	mediaParser = MediaFeedParser()
	mediaParser.parse(initialFeed)
	mediaParser.createMedia()
		
def readMediaTags(filename):
	f = open(filename, "r")
	try:	
		for line in f:
			if line.strip():
				print "Parsing tag=%s" % line.strip()
				mediaByTag(MEDIA_URL, "-YBj8wsdqcw", line.strip(), DEFAULT_PER_PAGE)
				print "done parsing tag=%s" % line
	except Exception, e:
		print "************************"
		print "ERROR while parsing media tags=%s" % e		
	f.close()

def createActiveMedia():
	media_handler = MediaHandler()
	media_handler.connect()
	media_handler.createActiveMedia()
	media_handler.closeConn()

def main():
	popularFeed(MEDIA_URL, "-YBj8wsdqcw", "week")
	popularFeed(MEDIA_URL, "-YBj8wsdqcw", "day")
	readMediaTags(sys.argv[1])
			
if __name__ == '__main__':
	print "running "
	diff = 0; start_time = 0; end_time = 0
	if len(sys.argv) != 2 and len(sys.argv) != 3:
		print "Usage: python %s (media tag file) or -a (create active feeds)" % sys.argv[0]
		print sys.argv
		print "press ENTER to continue"
		sys.exit()
	elif len(sys.argv) == 3 and sys.argv[2] == '-a':
		print "INFO: Setting active media"
		start_time = time.time()
		createActiveMedia()
		end_time = time.time()
	else:
		start_time = time.time()
		main()
		end_time = time.time()
		
	# Print simple summary
	diff = end_time - start_time
	print "completed in %s s" % diff
	print "press ENTER to continue"

# End of the File