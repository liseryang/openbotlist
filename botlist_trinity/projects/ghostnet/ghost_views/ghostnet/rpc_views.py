'''
 Berlin Brown
 ghost_views.ghostnet.link_views.index
'''

import datetime
import logging

from django.http import HttpResponseRedirect
from django.http import HttpResponse
from django.shortcuts import render_to_response
from google.appengine.api import users
from django.template import Context, loader

from ghost_forms.rpc.agent_message_forms import AgentMessageForm
from business.rpc.remote_agents import remote_agent_proc, remote_agent_create

from util.text_utils import formatStrAscii

def remote_agent_req(request):
	response = HttpResponse(mimetype='text/xml')
	tmpl = loader.get_template('rpc/remote_agent_req.xml')
	# Set the context variables
	c = Context({})
	response.write(tmpl.render(c))
	return response

def remote_agent_send(request):
	if request.method == 'POST':
		# Clean up the types payload data
		form = AgentMessageForm(request.POST)
		form.is_valid()
		form_data = formatStrAscii(request['types_payload'])
		payload_data = remote_agent_proc(form_data)
		# Once we have a collection of payload types,
		# Commit that data to the database.
		remote_agent_create(payload_data)

		# Render the XML response for a rpc send
		response = HttpResponse(mimetype='text/xml')		
		tmpl = loader.get_template('rpc/remote_agent_send.xml')
		# Set the context variables
		c = Context({})
		response.write(tmpl.render(c))
		return response
	else:
		response = HttpResponse(mimetype='text/xml')		
		tmpl = loader.get_template('rpc/remote_agent_req.xml')
		# Set the context variables
		c = Context({})
		response.write(tmpl.render(c))
		return response
	
# End of Script
