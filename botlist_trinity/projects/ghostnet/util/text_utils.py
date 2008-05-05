"""
 Berlin Brown
 text_utils
 8/20/2007

 Updated: 2/10/2008
 Added source to format a unicode str to ascii

 References:
 See beautiful soup for HTML entity conversion.
 http://www.crummy.com/software/BeautifulSoup/documentation.html
"""

import sys
from soup.BeautifulSoup import *

def formatStrAscii(val):
	""" Filter and encode the line in the html documents
	@see crawlSingleURLForContent
	"""
	#TODO: analyze prev code.
	#return strval.decode('ascii', 'replace').encode('ascii', 'replace') 
	try:
		val = val.decode('utf8', 'replace')
		val = val.encode('ascii', 'replace') 		
		return val
	except UnicodeError, e:
		pass
	# Always return a value
	return ""

def formatHtmlEntities(content):
	""" Parse the document and convert the HTML (todo: XML) entities
	to the unicode characters"""
	return BeautifulStoneSoup(content,
							  convertEntities=BeautifulStoneSoup.HTML_ENTITIES).contents[0]

def shorten(str, max_len):
    """Shorten a given string to a smaller number of characters"""
    if str:
        if len(str) > max_len:            
            return str[0:max_len].strip()
        else:
            return str
        
# End of script
