#!/usr/bin/env python

'''
 Berlin Brown
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

import os
import sys
import unittest

# Add the parent directory, ghostnet to the sys path.
# We are assuming that google_appengine is also in the
# For example:
# -----------------------------
# PROJECT_HOME/google_appengine
# PROJECT_HOME/projects/ghostnet/tests

DIR_PATH = os.path.abspath(os.path.dirname(os.path.realpath(__file__)))
PROJECT_HOME = os.path.join(DIR_PATH, '..', '..', '..')

print("INFO: project_home=%s" % PROJECT_HOME)

EXTRA_PATHS = [
  DIR_PATH,
  os.path.join(PROJECT_HOME, 'projects', 'ghostnet'),
  os.path.join(PROJECT_HOME, 'google_appengine'),
  os.path.join(PROJECT_HOME, 'google_appengine', 'lib', 'django'),
  os.path.join(PROJECT_HOME, 'google_appengine', 'lib', 'webob'),
  os.path.join(PROJECT_HOME, 'google_appengine', 'lib', 'yaml', 'lib')
]
sys.path = EXTRA_PATHS + sys.path

# End of path setup

import datetime
import logging

# Google App Engine includes
from google.appengine.api import apiproxy_stub_map
from google.appengine.api import datastore_file_stub
from google.appengine.api import mail_stub
from google.appengine.api import user_service_stub 
from google.appengine.ext import db

APP_ID = 'ghostnet_tests'
DS_PATH = '/tmp/dev_ds_tests.db'
HIST_PATH = '/tmp/dev_ds_tests.hist'

apiproxy_stub_map.apiproxy.RegisterStub(
        'user',
        user_service_stub.UserServiceStub())

# From the dev_appserver source:
# ----------------------
#  datastore = datastore_file_stub.DatastoreFileStub(
#      app_id, datastore_path, history_path, require_indexes=require_indexes)
# ----------------------
apiproxy_stub_map.apiproxy.RegisterStub(
        'datastore_v3',
        datastore_file_stub.DatastoreFileStub('ghostnet',
                                              DS_PATH,
                                              HIST_PATH))
apiproxy_stub_map.apiproxy.RegisterStub(
        'mail',
        mail_stub.MailServiceStub())

# ----------------------
# Django Setups
# ----------------------

# A workaround to fix the partial initialization of Django before we are ready
from django.conf import settings
settings._target = None

os.environ['DJANGO_SETTINGS_MODULE'] = 'settings'

# Import various parts of Django.
import django.core.handlers.wsgi
import django.core.signals
import django.dispatch.dispatcher
import django.db

# --------------
# Tests includes
# --------------
from tests.create_models import suite as suite_create
from tests.read_models import suite as suite_read
from tests.agent_rpc_test import suite as suite_rpc
from tests.client.client_rpc_test import suite as suite_client_rpc

def run_test_suite():
        suite = unittest.TestSuite()
        suite.addTest(suite_create())
        suite.addTest(suite_read())
        suite.addTest(suite_rpc())
        suite.addTest(suite_client_rpc())
        runner = unittest.TextTestRunner()
        runner.run(suite)

# End of appengine setups for command-line test apps
        
if __name__ == '__main__':
        print "Running model create"    
        run_test_suite()
        print "Done"

# End of Script
