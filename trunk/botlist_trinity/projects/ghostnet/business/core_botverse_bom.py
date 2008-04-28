'''
 Berlin Brown
 ghost_views.ghostnet.link_views.index
'''

import datetime

from google.appengine.ext import db
from google.appengine.api import users

from ghost_forms.core_forms import EntityLinksForm
from ghost_models.core_ghostnet_models import EntityLinks
from util.generate_unique_id import botlist_uuid

def create_entity_model(link_form):
	''' Utility method, marshall the data from the form into the
	entity link model and return the entity link model for the
	data store'''
	url = link_form.clean_data['main_url']
	link = EntityLinks(
		mainUrl = url,
		urlTitle = "The Google",
		urlDescription = "The Google Descr",
		keywords = "the google cool",
		hostname = "http://www.google.com",
		generatedObjId = botlist_uuid("objid:%s" % url),
		processCount = 0)
	return link

# End of Script
