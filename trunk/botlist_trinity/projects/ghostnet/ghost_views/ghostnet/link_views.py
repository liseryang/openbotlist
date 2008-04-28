'''
 Berlin Brown
 ghost_views.ghostnet.link_views.index
'''

import datetime

from google.appengine.ext import db
from django.http import HttpResponseRedirect
from django.shortcuts import render_to_response
from google.appengine.api import users

from ghost_forms.core_forms import EntityLinksForm
from ghost_models.core_ghostnet_models import EntityLinks
from util.generate_unique_id import botlist_uuid

from business.core_botverse_bom import create_entity_model

from xml.dom.minidom import parse, parseString

def botverse_submit(request):
	form = EntityLinksForm(request.POST)
	if form.is_valid():
		link = create_entity_model(form)
		if users.GetCurrentUser():
			link.fullName = users.GetCurrentUser()
		db.put(link)
	# return home
	return botverse_confirm(request)

def botverse_submit_view(request):
	form = EntityLinksForm()
	return render_to_response('ghostnet/botverse_submit.html', {
		'form': form
		})

def botverse_confirm(request):
	''' Index Page'''
	return render_to_response('ghostnet/botverse_confirm.html')

def botverse(request):
	''' Index Page'''
	return render_to_response('botverse.html', {})

def default_error(request):
	''' Generic Error Page '''
	return render_to_response('ghostnet/errorInvalidView.html')

def index(request):
	''' Index Page'''
	query = db.GqlQuery("SELECT * FROM EntityLinks")
	listings = query.fetch(20)
	return render_to_response('index.html', {
		'listings': listings
		})

	
# End of Script
