'''
 Berlin Brown
'''
import unittest
from django.test.client import Client

class ClientRPCTest(unittest.TestCase): 
    def setUp(self):
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

def suite():
    suite = unittest.TestSuite()
    suite.addTest(unittest.makeSuite(ClientRPCTest))
    return suite
        
# End of Script
