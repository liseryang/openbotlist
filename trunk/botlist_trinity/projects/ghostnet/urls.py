#!/usr/bin/env python
#
# Copyright 2008 Berlin Brown - botnode.com.

from django.conf.urls.defaults import *

urlpatterns = patterns('',
    (r'^$', 'views.index'),
    (r'^sign$', 'views.sign'),
)
