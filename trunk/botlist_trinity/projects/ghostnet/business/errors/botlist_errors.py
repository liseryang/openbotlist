'''
 Berlin Brown

 business.errors.botlist_errors
'''

__author__ = "Berlin Brown"
__version__ = "0.1"
__copyright__ = "Copyright (c) 2008 Berlin Brown"
__license__ = "NEW BSD"

class BotlistParseError(Exception):
	def __init__(self, value):
		self.value = ("ERR: |%s| parse-error: %s" % \
					  (self.__class__.__name__, value))
	def __str__(self):
		return repr(self.value)

# End of Script
