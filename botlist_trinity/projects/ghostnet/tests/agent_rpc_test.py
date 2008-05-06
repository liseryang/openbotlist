'''
 Berlin Brown

 see http://www.djangoproject.com/documentation/testing/
'''

__author__ = "Berlin Brown"
__version__ = "0.1"
__copyright__ = "Copyright (c) 2008 Berlin Brown"
__license__ = "NEW BSD"

import os
import sys

import datetime
import unittest

# Google App Engine includes
from google.appengine.ext import db

import random
from business.rpc.remote_agents import \
	 remote_agent_proc, remote_agent_create
from business.errors.botlist_errors import BotlistParseError

from xml.parsers.expat import ExpatError
from xml.dom.minidom import parse, parseString

class AgentRpcTest(unittest.TestCase):

	def setUp(self):
		self.types_payload = '''<?xml version="1.0" encoding="UTF-8" ?>
 <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
	   <agentmsg>
		 <botid>botbert</botid>
 		 <message>We processed some cake</message>
 		 <status>200</status>
		 <typespayload>
		   <type>
		     <title>The Title</title>
			 <url>http://www.google4.com</url>
			 <keywords>go google</keywords>
			 <descr><![CDATA[ the google dot com]]></descr>
		   </type>
		   <type>
		     <title>The Title 2</title>
			 <url>http://www.google5.com</url>
			 <keywords>go google two</keywords>
			 <descr>the google dot com two</descr>
			 <descr><![CDATA[ the google dot com (TWO)]]></descr>
		   </type>
		 </typespayload>
	   </agentmsg>
 </rdf:RDF>'''
		
	def test_parse_raise_error(self):
		bad_data = "<?xml version='1.0' encoding='UTF-8' ?><data></d"
		f = lambda: parseString(bad_data)
		self.assertRaises(ExpatError, f)
		
	def test_parse_rpc_raise_error(self):
		bad_data = "<?xml version='1.0' encoding='UTF-8' ?><data></d"
		f = lambda: remote_agent_proc(bad_data)
		self.assertRaises(BotlistParseError, f)

	def test_parse_create_payload(self):
		# Test the rpc parser and create
		data_arr = remote_agent_proc(self.types_payload)
		assert (data_arr is not None)
		self.assertEquals(2, len(data_arr))
		# Create a record
		remote_agent_create(data_arr)		
		
	def test_parse_example_payload(self):
		'''Test parsing an example payload message'''
		payload_doc = parseString(self.types_payload)
		assert (payload_doc is not None)

		# Get the typespayload data
		payload_node = payload_doc.getElementsByTagName("typespayload")[0]
		assert (payload_node is not None)

		types = payload_doc.getElementsByTagName("type")
		self.assertEquals(2, len(types))
		url1 = types[0].getElementsByTagName("url")[0].firstChild.nodeValue
		
		# Test cdata extraction
		descr = types[0].getElementsByTagName("descr")[0].firstChild.nodeValue

		# Test the rpc parser
		data_arr = remote_agent_proc(self.types_payload)
		assert (data_arr is not None)
		self.assertEquals(2, len(data_arr))
	
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
