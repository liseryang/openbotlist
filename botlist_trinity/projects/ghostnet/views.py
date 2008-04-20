#!/usr/bin/env python
#
# Copyright 2008 Berlin Brown - botnode.com.

import datetime

from django.http import HttpResponseRedirect
from django.shortcuts import render_to_response

from google.appengine.api import users

from models import Post
from forms import GuestbookForm

def index(request):
  query = Post.gql('ORDER BY date DESC')
  form = GuestbookForm()
  return render_to_response('index.html',
                            {'posts': query.fetch(20),
                             'form': form
                            }
                           )

def sign(request):
  form = GuestbookForm(request.POST)
  if form.is_valid():
    post = Post(message=form.clean_data['message'])
    if users.GetCurrentUser():
      post.author = users.GetCurrentUser()
  
    post.put()

  return HttpResponseRedirect('/')
