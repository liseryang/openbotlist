#!/usr/bin/env python
#
# Copyright 2008 Berlin Brown - botnode.com.

import os
import sys
import logging

# Google App Engine imports.
from google.appengine.ext.webapp import util

# A workaround to fix the partial initialization of Django before we are ready
from django.conf import settings
settings._target = None

os.environ['DJANGO_SETTINGS_MODULE'] = 'settings'

# Import various parts of Django.
import django.core.handlers.wsgi
import django.core.signals
import django.dispatch.dispatcher
import django.db

def log_exception(*args, **kwds):
 """Log the current exception.
 Invoked when a Django request raises an exception"""
 logging.exception("Exception in request:")

# Log errors
django.dispatch.dispatcher.connect(
   log_exception,
   django.core.signals.got_request_exception)

# Unregister the rollback event handler
django.dispatch.dispatcher.disconnect(
   django.db._rollback_on_exception,
   django.core.signals.got_request_exception)

def main():
  # Create a Django application for WSGI.
  application = django.core.handlers.wsgi.WSGIHandler()

  # Run the WSGI CGI handler with that application.
  util.run_wsgi_app(application)


if __name__ == '__main__':
  main()
