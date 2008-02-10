"""
 Berlin Brown
 test_alltests.py
 
 8/16/2007
"""
import unittest
from test import test_support

from tests.test_textutils import TextUtilsTestCase

def test_main():
    test_support.run_unittest(
        TextUtilsTestCase)        

if __name__ == '__main__':
    print "running tests"
    test_main()
    print "done"