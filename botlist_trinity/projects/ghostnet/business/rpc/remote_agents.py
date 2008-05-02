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
'''

__author__ = "Berlin Brown"
__version__ = "0.1"
__copyright__ = "Copyright (c) 2008 Berlin Brown"
__license__ = "NEW BSD"

from business.errors.botlist_errors import BotlistParseError

from xml.dom.minidom import parse, parseString
from xml.parsers.expat import ExpatError

from ghost_models.rpc.agent_message import LinkType

def remote_agent_proc(payload_data):
	payload_doc = None
	try:
		payload_doc = parseString(payload_data)
	except ExpatError, e:
		raise BotlistParseError("remote_agent_proc() - Could not parse type payload: %s" % e)
		
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
			new_type.keywords = link_type.getElementsByTagName("keywords")[0].firstChild.nodeValue
			new_type.urlDescription = link_type.getElementsByTagName("descr")[0].firstChild.nodeValue
			link_types.append(new_type)
		except Exception, e:
			print e
			pass
		
	return link_types
	
# End of Script
