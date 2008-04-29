'''
 Berlin Brown
 ghost_views.ghostnet.link_views.index
'''

import datetime

from django.http import HttpResponseRedirect
from django.http import HttpResponse
from django.shortcuts import render_to_response
from google.appengine.api import users
from django.template import Context, loader

from ghost_forms.rpc.agent_message_forms import AgentMessageForm
from business.rpc.remote_agents import remote_agent_proc

def remote_agent_req(request):
	response = HttpResponse(mimetype='text/xml')
	tmpl = loader.get_template('rpc/remote_agent_req.xml')
	# Set the context variables
	c = Context({})
	response.write(tmpl.render(c))
	return response

def remote_agent_send(request):
	if request.method == 'POST':
		form = AgentMessageForm(request.POST)
		form_data = form.clean_data['types_payload']
		remote_agent_proc(form_data)
		return None
	else:
		response = HttpResponse(mimetype='text/xml')		
		tmpl = loader.get_template('rpc/remote_agent_req.xml')
		# Set the context variables
		c = Context({})
		response.write(tmpl.render(c))
		return response
	
# End of Script
