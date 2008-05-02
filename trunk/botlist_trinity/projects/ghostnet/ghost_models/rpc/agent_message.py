'''
 Berlin Brown

 see http://www.djangoproject.com/documentation/testing/

 ghost_models.rpc.agent_message.*
'''
__author__ = "Berlin Brown"
__version__ = "0.1"
__copyright__ = "Copyright (c) 2008 Berlin Brown"
__license__ = "NEW BSD"

class LinkType:
	def __init__(self):
		self.urlTitle = ""
		self.mainUrl = ""
		self.keywords = ""
		self.urlDescription = ""
		self.fullName = ""
		self.rating = 0
	def __str__(self):
		return self.urlTitle
# End of Script
