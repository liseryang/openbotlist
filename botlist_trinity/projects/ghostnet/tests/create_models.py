'''
 Berlin Brown
 -------------------------- COPYRIGHT_AND_LICENSE --
 Botlist contains an open source suite of software applications for 
 social bookmarking and collecting online news content for use on the web.  
 Multiple web front-ends exist for Django, Rails, and J2EE.  
 Users and remote agents are allowed to submit interesting articles.

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
	    * Neither the name of the Botnode.com (Berlin Brown) nor 
	    the names of its contributors may be used to endorse or promote 
	    products derived from this software without specific prior written permission.
	
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 -------------------------- END_COPYRIGHT_AND_LICENSE --
'''

import os
import sys

import datetime
import logging
import unittest

# Google App Engine includes
from google.appengine.ext import db

import random

from ghost_models.core_ghostnet_models import EntityLinks
from util.generate_unique_id import botlist_uuid

from business.rpc.remote_agents import \
	 remote_agent_proc, remote_agent_create

def create_entity_model():
	r = long( random.random() * 100000000000000000L )
	url = "http://www.google%s.com" % r
	uid = botlist_uuid("objid:%s" % url)
	link = EntityLinks(
		mainUrl = url,
		urlTitle = "The Google",
		urlDescription = "The Google Descr",
		keywords = "the google cool",
		hostname = "http://www.google.com",
		generatedObjId = uid,
		processCount = 0)
	db.put(link)
	return link
	
class CreateModelsTest(unittest.TestCase):

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
			 <url>http://www.google4_rpc.com</url>
			 <keywords>go google</keywords>
			 <descr>the google dot com</descr>
		   </type>
		   <type>
		     <title>The Title 2</title>
			 <url>http://www.google5_rpc.com</url>
			 <keywords>go google two</keywords>
			 <descr>the google dot com two</descr>
		   </type>
		 </typespayload>
	   </agentmsg>
 </rdf:RDF>'''
	
	def test_create_models(self):
		l = create_entity_model()
		assert l is not None

	def test_create_links_rpc(self):
		# Test the rpc parser and create
		data_arr = remote_agent_proc(self.types_payload)
		assert (data_arr is not None)
		self.assertEquals(2, len(data_arr))
		# Create a record
		remote_agent_create(data_arr)	
   
def suite():
	suite = unittest.TestSuite()
	suite.addTest(unittest.makeSuite(CreateModelsTest))
	return suite
	
# End of script
