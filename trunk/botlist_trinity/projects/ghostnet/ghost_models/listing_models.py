#!/usr/bin/env python
#
# Copyright 2008 Berlin Brown - botnode.com.

from google.appengine.ext import db

class CityListing(db.Model):
  author = db.UserProperty()
  message = db.StringProperty(multiline=True, required=True)
  date = db.DateTimeProperty(auto_now_add=True)

class PostSections(db.Model):
  author = db.UserProperty()
  message = db.StringProperty(multiline=True, required=True)
  date = db.DateTimeProperty(auto_now_add=True)

class PostListing(db.Model):
  author = db.UserProperty()
  message = db.StringProperty(multiline=True, required=True)
  date = db.DateTimeProperty(auto_now_add=True)

class PostImageMetadata(db.Model):
  author = db.UserProperty()
  message = db.StringProperty(multiline=True, required=True)
  date = db.DateTimeProperty(auto_now_add=True)

# End of Script
