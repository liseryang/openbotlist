"""
File: spiderdb.py

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

Description:

Save spider database format in big endian format (network format).

"""

__author__ = "Berlin Brown"
__copyright__ = "Copyright (c) 2006-2008 Berlin Brown"
__license__ = "New BSD"

import sys
import time, datetime
import socket

from soup.BeautifulSoup import *
import urllib2
from urlparse import urlparse
from database.spiderdb import *
from optparse import OptionParser
import glob

# Socket timeout in seconds
DEFAULT_REQUEST_TIMEOUT = 40
NO_COLS_SERVICE = 9
LINK_SET_INDICATOR = 20
#URL_LINK_SERVICE = "http://localhost:8080/botlist/spring/pipes/botverse_pipes.html"
URL_LINK_SERVICE="http://127.0.0.1:9080/testwebapp/data/data.jsp"
FF_USER_AGENT = "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6"

opener = None
def buildOpener():
	global opener
	if opener is None:
		opener = urllib2.build_opener()
	return opener

def convertStrAscii(strval):
	try:
		return strval.decode('ascii', 'replace').encode('ascii', 'replace') 
	except UnicodeError:
		pass

def validateSubLink(link_tag):
	if link_tag.has_key('href'):
		link_val = link_tag['href']
		if link_val.lower().startswith('http'):
			return 1
	else:
		return 0

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

class URLField:
	def __init__(self, url, title, descr, keywords):
		self.url = url
		self.title = title
		self.descr = descr
		self.keywords = keywords		
		self.full_content = None
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

		# Convert unicode to ascii string
		# TODO: add unicode support
		#*********************************
                #>>> a.encode('ascii', 'strict')  # the default, raise exception
		#>>> a.encode('ascii', 'ignore')  # turn to zero and continue 
                #>>> a.encode('ascii', 'replace') # replace with a readable error character
		#*********************************
		# TODO: use convertStrAscii
		self.url = self.url.encode('ascii', 'replace')
		self.title = self.title.encode('ascii', 'replace')
		self.descr = self.descr.encode('ascii', 'replace')
		self.keywords = self.keywords.encode('ascii', 'replace')
		
		self.url_len_u2 = len(self.url)
		self.title_len_u2 = len(self.title)
		self.descr_len_u2 = len(self.descr)
		self.keywords_len_u2 = len(self.keywords)
	
	def __str__(self):
		return "%s#%s %s" % (self.url, self.descr, self.title_len_u2)
