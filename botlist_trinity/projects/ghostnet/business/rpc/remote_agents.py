'''
 Berlin Brown

 Example Server Request Setup - Initial Response (remote_agent_req):
 -----------------------------
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" >
	<agentmsg>
 		<botid>serverbot</botid>
 		<message>Hello my name is serverbot.  Would you like some cake?</message>
 		<status>200</status>
 		<requestid>{ Text(uniq_id) }</requestid>
 		<majorvers>0</majorvers>
 		<minorvers>0</minorvers>
 	</agentmsg>
</rdf:RDF>

 -----------------------------
 (*) Example Client Request (remote_agent_send):
 post key = types_payload
 -----------------------------
 <?xml version="1.0" encoding="UTF-8" ?>
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
		 </typespayload>
	   </agentmsg>
 </rdf:RDF>

 Example Server Response to Request (confirmation):
 -----------------------------
 <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" >
	  <message>Enjoy your cake</message>
</rdf:RDF>

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

__author__ = "Berlin Brown"
__version__ = "0.1"
__copyright__ = "Copyright (c) 2008 Berlin Brown"
__license__ = "NEW BSD"

import logging
from google.appengine.ext import db

from business.errors.botlist_errors import \
	 BotlistParseError, BotlistInvalidTypeError

from xml.dom.minidom import parse, parseString
from xml.parsers.expat import ExpatError

from ghost_models.rpc.agent_message import LinkType

from ghost_forms.core_forms import EntityLinksForm
from ghost_models.core_ghostnet_models import EntityLinks
from util.generate_unique_id import botlist_uuid

def remote_agent_proc(payload_data):
	try:
		payload_doc = parseString(payload_data)
	except ExpatError, e:
		raise BotlistParseError(("remote_agent_proc() - Could not parse type payload: %s" % e))
		
	if payload_doc is None:
		raise BotlistParseError("remote_agent_proc() - Could not parse type payload")
	
	# Get the typespayload data
	payload_node = payload_doc.getElementsByTagName("typespayload")[0]
	if payload_doc is None:
		raise BotlistParseError("remote_agent_proc() - Could not parse type payload")

	# Transform the data into a collection of link types
	types = payload_doc.getElementsByTagName("type")
	link_types = []
	for link_type in types:
		try:
			new_type = LinkType()
			new_type.urlTitle = link_type.getElementsByTagName("title")[0].firstChild.nodeValue 
			new_type.mainUrl = link_type.getElementsByTagName("url")[0].firstChild.nodeValue
			
			if link_type.getElementsByTagName("keywords") is not None: \
			   new_type.keywords = link_type.getElementsByTagName("keywords")[0].firstChild.nodeValue
			# Note: descr contains a CDATA element.
			#if link_type.getElementsByTagName("descr") is not None: \
			#   new_type.urlDescription = link_type.getElementsByTagName("descr")[0].firstChild.nodeValue
			new_type.urlDescription = "none"
			link_types.append(new_type)
		except Exception, e:
			logging.error(e)
			pass
		
	return link_types

def remote_agent_create(link_types):
	''' With the collection of LinkTypes, extract the data and
	create a django/db record'''
	if link_types is None:
		raise BotlistInvalidTypeError("remote_agent_create()")

	for link_type in link_types:
		link = EntityLinks(
			mainUrl = link_type.mainUrl,
			urlTitle = link_type.urlTitle,
			urlDescription = link_type.urlDescription,
			keywords = link_type.keywords,
			hostname = "http://www.google.com",
			generatedObjId = botlist_uuid("objid:%s" % link_type.mainUrl),
			processCount = 0)
		try:			
			db.put(link)
		except BadValueError, val_err:
			logging.error("remote_agent_create() - " % val_err)
		
# End of Script
