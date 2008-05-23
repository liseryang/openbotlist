'''
 Berlin Brown
 ghost_views.ghostnet.link_views.index

 -------------------------- COPYRIGHT_AND_LICENSE --
 Botlist contains an open source suite of software applications for 
 social bookmarking and collecting online news content for use on the web.  
 Multiple web front-ends exist for Django, Rails, and J2EE.  
 Users and remote agents are allowed to submit interesting articles.

 Copyright (c) 2007, Botnode.com (Berlin Brown)
 http://www.opensource.org/licenses/bsd-license.php

 All rights reserved.

 Redistribution and use in source and binary forms, with or without modification, 
 are permitted provided that the following conditions are met:

	    * Redistributions of source code must retain the above copyright notice, 
	    this list of conditions and the following disclaimer.
	    * Redistributions in binary form must reproduce the above copyright notice, 
	    this list of conditions and the following disclaimer in the documentation 
	    and/or other materials provided with the distribution.
	    * Neither the name of the Botnode.com (Berlin Brown) nor 
	    the names of its contributors may be used to endorse or promote 
	    products derived from this software without specific prior written permission.
	
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 -------------------------- END_COPYRIGHT_AND_LICENSE --
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

def botverse_light(request):
	query = db.GqlQuery("SELECT * FROM EntityLinks")
	listings = query.fetch(20)
	return render_to_response('ghostnet/text/botverse_light.html', {
		'listings': listings
		})

def botverse_confirm(request):
	''' Index Page'''
	return render_to_response('ghostnet/botverse_confirm.html')

def botverse(request):
	''' Index Page'''
	query = db.GqlQuery("SELECT * FROM EntityLinks")
	listings = query.fetch(20)
	return render_to_response('ghostnet/botverse.html', {
		'listings': listings
		})

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
