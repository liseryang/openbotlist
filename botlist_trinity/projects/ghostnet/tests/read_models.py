'''
 Berlin Brown
'''

import os
import sys

import datetime
import logging
import unittest

# Google App Engine includes
from google.appengine.ext import db

import random

from ghost_models.core_ghostnet_models import EntityLinks
from util.generate_unique_id import botlist_uuid

class ReadModelsTest(unittest.TestCase):

	def test_read_entity(self):
		links = db.GqlQuery("SELECT * FROM EntityLinks")
		assert links is not None
		ct = links.count(20)
		assert (ct > 0)
		link = links[0]
		assert (link is not None)
		assert (link.mainUrl is not None)
   
	def read_all_models(self):
		read_entity_model()

def suite():
	suite = unittest.TestSuite()
	suite.addTest(unittest.makeSuite(ReadModelsTest))
	return suite
		
# End of Script
