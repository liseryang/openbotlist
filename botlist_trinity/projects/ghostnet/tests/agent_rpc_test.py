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

	def test_parse_example_payload(self):
		'''Test parsing an example payload message'''
		types_payload = '''<?xml version="1.0" encoding="UTF-8" ?>
 <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
	   <agentmsg>
		 <botid>botbert</botid>
 		 <message>We processed some cake</message>
 		 <status>200</status>
		 <typespayload>
		   <type>
		     <title>The Title</title>
			 <url>http://www.google1.com</url>
			 <keywords>go google</keywords>
			 <descr>the google dot com</descr>
		   </type>
		   <type>
		     <title>The Title 2</title>
			 <url>http://www.google2.com</url>
			 <keywords>go google two</keywords>
			 <descr>the google dot com two</descr>
		   </type>
		 </typespayload>
	   </agentmsg>
 </rdf:RDF>'''
		payload_doc = parseString(types_payload)
		assert (payload_doc is not None)

		# Get the typespayload data
		payload_node = payload_doc.getElementsByTagName("typespayload")[0]
		assert (payload_node is not None)

		types = payload_doc.getElementsByTagName("type")
		self.assertEquals(2, len(types))
		url1 = types[0].getElementsByTagName("url")[0].firstChild.nodeValue
		print url1
	
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
