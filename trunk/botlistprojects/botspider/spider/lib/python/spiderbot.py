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

from soup.BeautifulSoup import *
import urllib2
from urlparse import urlparse

NO_COLS_SERVICE = 9
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

def crawlBuildLinks(link_list):
	opener = buildOpener()
	""" Iterate through the list of links and collect links found
	on each page through the use of the beautiful soup lib."""
	total_links = 0
	total_links_tag = 0
	for link in link_list:
		try:
			data = opener.open(link).read()
			soup = BeautifulSoup(data)
			sub_links_tag = soup.findAll('a')
			total_links_tag = total_links_tag + len(sub_links_tag)
			
			sub_links = [el['href'] for el in sub_links_tag]
			total_links = total_links + len(sub_links)
			#for n in sub_links:
			#	print n
		except Exception, e:
			print "ERR: %s" % e
			
	print total_links
	print total_links_tag
	
if __name__ == '__main__':
	print "***"
	print "*** Spider Bot"
	data = connectLinkService(URL_LINK_SERVICE)
	link_list = [ line_set[0] for line_set in data ]
	crawlBuildLinks(link_list)
	print "*** Done"
