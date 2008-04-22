#!/usr/bin/env python
#
# Copyright 2008 Berlin Brown - botnode.com.

from google.appengine.ext import db

class ForumGroup(db.Model):
  author = db.UserProperty()
  message = db.StringProperty(multiline=True, required=True)
  date = db.DateTimeProperty(auto_now_add=True)

  id			int(11) NOT NULL auto_increment,
  city_id		int(11), 
  forum_name	varchar(255) NOT NULL UNIQUE,
  forum_descr	varchar(255),
  keywords	varchar(255),
  created_on  DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00',

class UserComments(db.Model):
  author = db.UserProperty()
  message = db.StringProperty(multiline=True, required=True)
  date = db.DateTimeProperty(auto_now_add=True)

class LinkGroups(db.Model):
  author = db.UserProperty()
  message = db.StringProperty(multiline=True, required=True)
  date = db.DateTimeProperty(auto_now_add=True)

class GroupLinks(db.Model):
  author = db.UserProperty()
  message = db.StringProperty(multiline=True, required=True)
  date = db.DateTimeProperty(auto_now_add=True)

