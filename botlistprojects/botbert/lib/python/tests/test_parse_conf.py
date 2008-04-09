"""
 Berlin Brown 
 8/15/2008
"""
import unittest
import util.text_utils as text_utils
import util.config_util as conf

class ParseConfTestCase(unittest.TestCase):

    # Only use setUp() and tearDown() if necessary
    def setUp(self):
        """ code to execute in preparation for tests """
        self.filename = "conf/remote_config.ini"

    def tearDown(self):
        """ code to execute to clean up after tests """
        pass

    def test_parse_conf(self):
        ini = conf.load_script(self.filename)
        conf_type = conf.process_config(ini)
    
        #self.assertEqual(conf_type.username, "USER")
        #self.assertEqual(conf_type.password, "PASSWORD")
        self.assertEqual(conf_type.database, "botlist_development")
        self.assertEqual(conf_type.hostname, "localhost")
        
# End of script
