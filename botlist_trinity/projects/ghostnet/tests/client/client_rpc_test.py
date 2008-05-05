'''
 Berlin Brown

 References:
 [1] http://www.djangoproject.com/documentation/newforms/
  
'''
import unittest
from django.test.client import Client

from ghost_forms.rpc.agent_message_forms import \
     AgentMessageForm

class ClientRPCTest(unittest.TestCase): 
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
        # Every test needs a client.
        self.client = Client()
        
    def test_index_request(self):
        # Issue a GET request.
        response = self.client.get('/')
        # Check that the respose is 200 OK.
        self.failUnlessEqual(response.status_code, 200)

    def test_rpc_request(self):
        # Issue a GET request.
        response = self.client.get('/rpc/types/remote_agent_req')
        # Check that the respose is 200 OK.
        self.failUnlessEqual(response.status_code, 200)

    def test_rpc_forms(self):
        data = {'types_payload': self.types_payload}
        form = AgentMessageForm(data)
        bnd = form.is_bound
        v = form.is_valid()
        form.clean_data['types_payload']
        
def suite():
    suite = unittest.TestSuite()
    suite.addTest(unittest.makeSuite(ClientRPCTest))
    return suite
        
# End of Script
