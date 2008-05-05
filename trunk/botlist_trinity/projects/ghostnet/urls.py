#!/usr/bin/env python
#
# Copyright 2008 Berlin Brown - botnode.com.

from django.conf.urls.defaults import *
from django.conf import settings

from ghost_views.ghostnet.link_views import index
from ghost_views.ghostnet.rpc_views import remote_agent_send,remote_agent_req

'''
 Current Directory Layout
 ------------------------
|-- foaf
|   |-- foaf.html
|   |-- foaf_confirm.html
|   +-- foaf_submit.html
|-- forums
|   |-- forumaddtopic.html
|   |-- forumaddtopic_confirm.html
|   |-- forums.html
|   |-- forumviewtopic.html
|   |-- topics.html
|   +-- viewforums.html
|-- ghostnet
|   |-- botverse.html
|   |-- botverse_calendar.html
|   |-- botverse_confirm.html
|   |-- botverse_submit.html
|   |-- index_base.html
|   |-- index_base_elems.html
|   |-- linkaddcomment.html
|   |-- linkaddcomment_confirm.html
|   |-- linkviewcomments.html
|   |-- rss
|   |   +-- botverse_rss.html
|   +-- text
|       |-- botverse_light.html
|       +-- botverse_text.html
|-- index.html
|-- listings
|   |-- citylist.html
|   |-- contactemail.html
|   |-- contactlisting.html
|   |-- create_listing.html
|   |-- createconfirm.html
|   |-- listings.html
|   |-- sections.html
|   +-- viewlisting.html
+-- pipes
    +-- pipes.html
'''

urlpatterns = patterns(
	'',
	(r'^$', 'ghost_views.ghostnet.link_views.index'),
	
	(r'^rpc/types/remote_agent_req$', 'ghost_views.ghostnet.rpc_views.remote_agent_req'),
	(r'^rpc/types/remote_agent_send$', 'ghost_views.ghostnet.rpc_views.remote_agent_send'),
	
	(r'^ghostnet/botverse_submit$', 'ghost_views.ghostnet.link_views.botverse_submit_view'),
	(r'^ghostnet/botverse_submit_post$', 'ghost_views.ghostnet.link_views.botverse_submit'),
    (r'^ghostnet/botverse_calendar$', 'ghost_views.ghostnet.link_views.default_error'),
    (r'^ghostnet/botverse_confirm$', 'ghost_views.ghostnet.link_views.default_error'),    
    (r'^ghostnet/index_base$', 'ghost_views.ghostnet.link_views.default_error'),
    (r'^ghostnet/index_base_elems$', 'ghost_views.ghostnet.link_views.default_error'),
    (r'^ghostnet/linkaddcomment$', 'ghost_views.ghostnet.link_views.default_error'),
    (r'^ghostnet/linkaddcomment_confirm$', 'ghost_views.ghostnet.link_views.default_error'),
	(r'^ghostnet/linkviewcomments$', 'ghost_views.ghostnet.link_views.default_error'),
    (r'^ghostnet/rss/botverse_rss$', 'ghost_views.ghostnet.link_views.default_error'),
	(r'^ghostnet/text/botverse_light$', 'ghost_views.ghostnet.link_views.default_error'),
	(r'^ghostnet/text/botverse_text$', 'ghost_views.ghostnet.link_views.default_error'),
	
    (r'^foaf/foaf$', 'ghost_views.ghostnet.link_views.default_error'),
    (r'^foaf/foaf_confirm$', 'ghost_views.ghostnet.link_views.default_error'),
    (r'^foaf/foaf_submit$', 'ghost_views.ghostnet.link_views.default_error'),
	
    (r'^forums/addtopic$', 'ghost_views.ghostnet.link_views.default_error'),
    (r'^forums/forumaddtopic_confirm$', 'ghost_views.ghostnet.link_views.default_error'),
    (r'^forums/forums$', 'ghost_views.ghostnet.link_views.default_error'),
    (r'^forums/forumviewtopic$', 'ghost_views.ghostnet.link_views.default_error'),
    (r'^forums/topics$', 'ghost_views.ghostnet.link_views.default_error'),
    (r'^forums/viewforums$', 'ghost_views.ghostnet.link_views.default_error'),
	
	(r'^listings/citylist$', 'ghost_views.ghostnet.link_views.default_error'),
	(r'^listings/contactemail$', 'ghost_views.ghostnet.link_views.default_error'),
	(r'^listings/contactlisting$', 'ghost_views.ghostnet.link_views.default_error'),
	(r'^listings/create_listing$', 'ghost_views.ghostnet.link_views.default_error'),
	(r'^listings/createconfirm$', 'ghost_views.ghostnet.link_views.default_error'),
	(r'^listings/listings$', 'ghost_views.ghostnet.link_views.default_error'),
	(r'^listings/sections$', 'ghost_views.ghostnet.link_views.default_error'),
	(r'^listings/viewlisting$', 'ghost_views.ghostnet.link_views.default_error'),
	
	(r'^pipes/pipes$', 'ghost_views.ghostnet.link_views.default_error')
)

# For local development, if debug is enabled, use the
# django static view server
if settings.DEBUG:
	urlpatterns += patterns('',
							(r'^company/(?P<path>.*)$',
							 'django.views.static.serve',
							 {'document_root': 'company'}),
    )


# End of Script
