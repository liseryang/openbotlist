"""
 Berlin Brown 
 4/15/2008
"""
import unittest

import business.botlist_business_object as biz

class DBConnTestCase(unittest.TestCase):

    # Only use setUp() and tearDown() if necessary
    def setUp(self):
        """ code to execute in preparation for tests """
        pass

    def tearDown(self):
        """ code to execute to clean up after tests """
        pass

    def test_db_conn(self):
        biz_obj = biz.BotlistBusinessObject()
        biz_obj.connect()
        biz_obj.closeConn()
		
# End of script
