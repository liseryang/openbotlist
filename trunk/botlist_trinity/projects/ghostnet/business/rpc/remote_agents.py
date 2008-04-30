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

from xml.dom.minidom import parse, parseString

def remote_agent_proc(data):
	doc = parseString(data)
	return None
	
# End of Script
