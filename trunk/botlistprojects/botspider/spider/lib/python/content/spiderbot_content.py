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

from soup.BeautifulSoup import *
from spiderbot_util import convertStrAscii
from spiderbot_util import ignoreHtmlEntity

def doc_ignore_content(soup):
	""" With beautiful soup's api, ignore content
	we are not interested in like comments"""
	
	# Attempt to extract script data
	strip_invalids = soup.findAll(text=lambda text:isinstance(text, Comment))
	[comment.extract() for comment in strip_invalids]

	# Remove SCRIPT and STYLE tags.
	[soup.script.extract() for script in soup("script")]
	[soup.style.extract() for style in soup("style")]
		
	# Only extract text content.
	txt_lst = soup.findAll(text=True)
	txt_lst = [ convertStrAscii(n) \
				for n in txt_lst if len(n.strip()) > 1 ]
	doc_str = '\n'.join(txt_lst)
	return doc_str

def clean_content(content):
	
	#*****************************************
	# Additional filters and cleanups
	#*****************************************		
	if content is not None:
		# Encode to simple ascii format.
		try:
			content = convertStrAscii(content)
			content = ignoreHtmlEntity(content)
			return content
		except UnicodeError, e:
			print e
			
	return ""
