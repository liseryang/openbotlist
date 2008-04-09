"""
 Berlin Brown
 test_alltests.py
 
 8/16/2007
"""
import unittest
from test import test_support

from tests.test_textutils import TextUtilsTestCase
from tests.test_parse_conf import ParseConfTestCase
from tests.test_database_conn import DBConnTestCase

def test_main():
    test_support.run_unittest(TextUtilsTestCase,
							  ParseConfTestCase,
							  DBConnTestCase)

if __name__ == '__main__':
    print "running tests"
    test_main()
    print "done"
