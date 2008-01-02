"""
Copyright (c) 2007, Botnode.com (Berlin Brown)
http://www.opensource.org/licenses/bsd-license.php

All rights reserved.

Redistribution and use in source and binary forms, with or without modification, 
are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice, 
    this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice, 
    this list of conditions and the following disclaimer in the documentation 
    and/or other materials provided with the distribution.
    * Neither the name of the Newspiritcompany.com (Berlin Brown) nor 
    the names of its contributors may be used to endorse or promote 
    products derived from this software without specific prior written permission.

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
__copyright__ = "Copyright (c) 2006-2008 Berlin Brown"
__license__ = "New BSD"

import sys
import time, datetime
import socket

from soup.BeautifulSoup import *
import urllib2
from urlparse import urlparse
from database.spiderdb import *

# Socket timeout in seconds
DEFAULT_REQUEST_TIMEOUT = 2
NO_COLS_SERVICE = 9
LINK_SET_INDICATOR = 20
URL_LINK_SERVICE = "http://localhost:8080/botlist/spring/pipes/botverse_pipes.html"
FF_USER_AGENT = "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6"

opener = None

def buildOpener():
	global opener
	if opener is None:
		opener = urllib2.build_opener()
	return opener

def connectLinkService(requrl):
	""" First, connect to the botlist URL service and extract
	the most recent list of links.  This will seed the
	botlist spider crawler."""
	opener = buildOpener()	
	req = urllib2.Request(requrl)
	req.add_header('user-agent', FF_USER_AGENT)
	link_data = opener.open(req).read()
	link_data = [ line.strip() for line in link_data.split('\n') ]
	link_data = filter(lambda (line):
					   (len(line) > 0) and (len(line.split('::|')) == NO_COLS_SERVICE),
					   link_data)
	content = [ col.split('::|') for col in link_data ]
	return content

def processSubLink(link_tag):
	"""Process each link, ensure that a 'href' value is available,
	also convert relative URIs to full URLs"""
	# TODO: BUG, currently ignoring all internal links (don't have http)
	link_val = link_tag['href']
	link = None
	# If URL found, ignore; if relative than attempt to build URL
	if link_val.lower().startswith('http'):
		link = link_val
	else:
		link = link_val
	return link

def validateSubLink(link_tag):
	if link_tag.has_key('href'):
		link_val = link_tag['href']
		if link_val.lower().startswith('http'):
			return 1
	else:
		return 0
	
def get_meta_content(meta_data_arr):
	""" Use with soup, in the following manner:
	<code>meta_data_keywords = soup.findAll('meta', {'name':'keywords'})
	meta_data_descr = soup.findAll('meta', {'name':'description'})</code>
	keywords = get_meta_content(meta_data_keywords)"""
	try:
		content_content = None
		if meta_data_arr and len(meta_data_arr) > 0:
			content_data = [el['content'] for el in meta_data_arr]
			if content_data and len(content_data) > 0:
				return content_data[0]			
	except:
		pass	
	return ""

def crawlSingleURL(link, idx, total_links):
	try:
		start = time.time()
		data = opener.open(link).read()
		soup = BeautifulSoup(data)
		meta_data_keywords = soup.findAll('meta', {'name':'keywords'})
		meta_data_descr = soup.findAll('meta', {'name':'description'})
		keywords = get_meta_content(meta_data_keywords)
		descr = get_meta_content(meta_data_descr)

		# Extract the title tag
		titleTag = None
		try:
			titleTag = soup.html.head.title
			titleTag = str(titleTag.string)
		except:
			titleTag = ""
			
		end = time.time()

		# Return the basic URL data structure
		field = URLField(link, titleTag, descr, keywords)
		field.populate()
		
		if ((idx % LINK_SET_INDICATOR) == 0):			
			sys.stdout.write("[%s/%s] " % (idx, total_links))

		# Exit crawl single URL with url field.
		# @return URLField
		return field
	except socket.timeout:
		print "ERR: timeout [%s/%s] " % (idx, total_links)
	except urllib2.URLError:
		print "ERR: timeout [%s/%s] " % (idx, total_links)
	except Exception, e:
		pass
	
def crawlBuildLinks(link_list):
	opener = buildOpener()
	""" Iterate through the list of links and collect links found
	on each page through the use of the beautiful soup lib."""
	total_links = 0
	total_links_tag = 0
	sub_links = None
	for link in link_list:
		try:
			data = opener.open(link).read()
			soup = BeautifulSoup(data)
			sub_links_tag = soup.findAll('a')
			total_links_tag = total_links_tag + len(sub_links_tag)			
			sub_links = [processSubLink(el) for el in sub_links_tag if validateSubLink(el)]
			
			# Filter out duplicates with set
			sub_links = set(sub_links)		
			total_links = total_links + len(sub_links)
		except Exception, e:
			print "ERR: %s" % e

	if total_links_tag != 0:
		valid_ratio =  float(total_links) / total_links_tag
		print "INFO: valid links ratio: %s, max=%s/%s" % (valid_ratio,
														  total_links,
														  total_links_tag)

	# Return an empty list or valid content
	if sub_links is None:
		return ([], total_links)
	else:
		return (sub_links, total_links)

class URLField:
	def __init__(self, url, title, descr, keywords):
		self.url = url
		self.title = title
		self.descr = descr
		self.keywords = keywords

		# Structure values for writing to data file
		self.url_len_u2 = 0
		self.title_len_u2 = 0
		self.descr_len_u2 = 0
		self.keywords_len_u2 = 0
		
	def populate(self):
		"""After fields have been set, populate rest of data"""
		if self.title is None: self.title = "" ;
		if self.descr is None: self.descr = "" ;
		if self.keywords is None: self.keywords = "" ;

		# Convert unicode to string
		self.url = self.url.encode('UTF-8')
		self.title = self.title.encode('UTF-8')
		self.descr = self.descr.encode('UTF-8')
		self.keywords = self.keywords.encode('UTF-8')
		
		self.url_len_u2 = len(self.url)
		self.title_len_u2 = len(self.title)
		self.descr_len_u2 = len(self.descr)
		self.keywords_len_u2 = len(self.keywords)
		
	def __str__(self):
		return "%s#%s %s" % (self.url, self.descr, self.title_len_u2)

class URLInfoPool:
	
	def __init__(self):
		self.url_pool = []
		
	def buildURLPool(self, link_list):
		links, total_links = crawlBuildLinks(link_list)
		for index, link_proc in enumerate(links):
			# DEBUG
			if index > 10:
				break			
			url_info = crawlSingleURL(link_proc, index, total_links)
			if url_info:
				self.url_pool.append(url_info)
	
if __name__ == '__main__':
	print "***"
	print "*** Spider Bot v%s" % __version__
	if len(sys.argv) != 2:
		print "usage: python spiritbot.py <database dir>"
		sys.exit(-1)
	
	now = time.localtime(time.time())
	print "*** database directory=%s" % sys.argv[1]
	print "*** %s" % time.asctime(now)
	start = time.time()
	socket.setdefaulttimeout(DEFAULT_REQUEST_TIMEOUT)
	
	data = connectLinkService(URL_LINK_SERVICE)
	link_list = [ line_set[0] for line_set in data ]

	# The URL Pool contains a collection of the url field data structures
	infoPool = URLInfoPool()
	infoPool.buildURLPool(link_list)
	create_database(sys.argv[1], infoPool)
	end = time.time()
	diff = end - start
	print "\n*** Done"
	print "*** spider bot processing time=%s" % diff
