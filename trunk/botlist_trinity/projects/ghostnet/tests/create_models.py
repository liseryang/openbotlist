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

def create_entity_model():
	r = long( random.random() * 100000000000000000L )
	url = "http://www.google%s.com" % r
	uid = botlist_uuid("objid:%s" % url)
	link = EntityLinks(
		mainUrl = url,
		urlTitle = "The Google",
		urlDescription = "The Google Descr",
		keywords = "the google cool",
		hostname = "http://www.google.com",
		generatedObjId = uid,
		processCount = 0)
	db.put(link)
	return link
	
class CreateModelsTest(unittest.TestCase):
	def test_create_modes(self):
		l = create_entity_model()
		assert l is not None
   
def suite():
	suite = unittest.TestSuite()
	suite.addTest(unittest.makeSuite(CreateModelsTest))
	return suite
	
# End of script
