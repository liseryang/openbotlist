'''
 Berlin Brown

 see http://www.djangoproject.com/documentation/testing/
'''

import os
import sys

import datetime
import unittest

# Google App Engine includes
from google.appengine.ext import db

import random
from business.rpc.remote_agents import remote_agent_proc

from xml.dom.minidom import parse, parseString

class AgentRpcTest(unittest.TestCase):

	def test_parse_form_data(self):
		bad_data = "<?xml version='1.0' encoding='UTF-8' ?><data></d"
		doc = None
		try:
			remote_agent_proc(bad_data)
		except Exception, e:
			print e
		assert (doc is None)
		
	def test_simple_xml_parse(self):
		good_data = "<?xml version='1.0' encoding='UTF-8' ?><data></data>"
		bad_data = "<?xml version='1.0' encoding='UTF-8' ?><data></d"
		doc = parseString(good_data)
		assert (doc is not None)

		doc = None
		try:
			doc = parseString(bad_data)
		except:
			pass	
		assert (doc is None)

def suite():
	suite = unittest.TestSuite()
	suite.addTest(unittest.makeSuite(AgentRpcTest))
	return suite
		
# End of Script
