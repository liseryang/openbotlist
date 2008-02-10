"""
 Berlin Brown
 test of text utilities
 
 8/15/2007
"""
import unittest

import util.text_utils as text_utils

class TextUtilsTestCase(unittest.TestCase):

    # Only use setUp() and tearDown() if necessary
    def setUp(self):
        """ code to execute in preparation for tests """
        self.string_long = "0123  4 56,     this is a test    , hahahhaa testing  "
        self.string_short = "012hmm"
        self.string_empty = None

    def tearDown(self):
        """ code to execute to clean up after tests """
        pass

    def test_str_shorten(self): 
        res1 = text_utils.shorten(self.string_long, 5)
        res2 = text_utils.shorten(self.string_short, 10)
        res3 = text_utils.shorten(self.string_empty, 10)
        
        self.assertEqual(res1, "0123")
        self.assertEqual(res2, "012hmm")        
        self.failIf(res3)        
        
# End of script