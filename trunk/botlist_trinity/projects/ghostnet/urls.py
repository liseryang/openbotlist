#!/usr/bin/env python
#
# Copyright 2008 Berlin Brown - botnode.com.

from django.conf.urls.defaults import *
from django.conf import settings

urlpatterns = patterns('',
					   (r'^$', 'views.index'),
					   (r'^sign$', 'views.sign')
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
