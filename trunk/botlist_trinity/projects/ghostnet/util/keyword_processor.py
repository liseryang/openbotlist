"""
 Berlin Brown
 Also see:
 http://effbot.org/zone/unicode-convert.htm
 http://docs.python.org/lib/re-syntax.html
"""
import string
import re

HTML_FILTER_DATA = [ "&#39;",
		"&quot;",
		"&amp;" ]

def filterNonAscii(value):
    if value:
        str = value.encode("utf-8", "ignore")    
        str = ''.join(re.compile('[ ,\'\.\?\!0-9a-zA-Z]+').findall(str))
        return str
    else:
        return None

def createKeywords(value):
    str = ''.join(re.compile('[ 0-9a-zA-Z]+').findall(value))
    return str.lower()

# End of the file
