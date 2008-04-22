#!/usr/bin/env python
#
# Copyright 2008 Berlin Brown - botnode.com.

from google.appengine.ext import db

class EntityTypeFoaf(db.Model):
  author = db.UserProperty()
  message = db.StringProperty(multiline=True, required=True)
  date = db.DateTimeProperty(auto_now_add=True)
