#!/usr/bin/env python
#
# Copyright 2008 Berlin Brown - botnode.com.

from google.appengine.ext import db

class EntityLinks(db.Model):
  mainUrl = db.StringProperty(required=True)
  urlTitle = db.StringProperty(required=True)
  urlDescription = db.StringProperty(required=True)
  keywords = db.StringProperty(required=True)
  # This is useful for storing a "created" date and time for a model instance.
  createdOn = db.DateTimeProperty(auto_now_add=True)
  # This is useful for tracking a "last modified" date and time for a model instance.
  updatedOn = db.DateTimeProperty(auto_now=True)
  fullName = db.UserProperty()
  hostname = db.StringProperty(required=True)
  processCount = db.IntegerProperty(required=True)
  linkType = db.StringProperty()
  generatedObjId = db.StringProperty(required=True)
  rating = db.IntegerProperty()
  views = db.IntegerProperty()
  botRating = db.FloatProperty()
  userUpVotes = db.IntegerProperty()
  userDownVotes= db.IntegerProperty()
  linksCt= db.IntegerProperty()
  inboundLinkCt= db.IntegerProperty()
  outboundLinksCt= db.IntegerProperty()
  imageCt = db.IntegerProperty()
  metaDescrLen = db.IntegerProperty()
  metaKeywordsLen = db.IntegerProperty()
  metaDescrWct = db.IntegerProperty()
  metaKeywordsWct= db.IntegerProperty()
  geoLocationsCt = db.IntegerProperty()
  geoLocationsFound = db.StringProperty()
  documentSize = db.StringProperty()
  requestTime  = db.StringProperty()
  objectIdStatus  = db.StringProperty()
  paraTagCt = db.StringProperty()
  
class ActiveMediaFeeds(db.Model):
  message = db.TextProperty(required=True)
  date = db.DateTimeProperty(auto_now_add=True)
  display_type = db.StringProperty()
  created_on = db.DateTimeProperty(auto_now_add=True)
  
class MediaFeeds(db.Model):
  image_filename   = db.StringProperty()
  media_url        = db.StringProperty()
  image_thumbnail  = db.StringProperty()
  media_title      = db.StringProperty()
  media_descr      = db.StringProperty()
  media_type       = db.StringProperty()
  author           = db.StringProperty()
  rating           = db.FloatProperty(required=False)
  rating_count     = db.IntegerProperty()
  views            = db.IntegerProperty()
  keywords         = db.StringProperty()
  orginal_imgurl   = db.StringProperty()
  process_count    = db.IntegerProperty()
  system_id        = db.IntegerProperty()
  validity         = db.IntegerProperty()
  created_on       = db.DateTimeProperty(auto_now_add=True)

class AdminMainBanner(db.Model):
  headline     = db.StringProperty()
  enabled      = db.StringProperty()
  app_section  = db.StringProperty()
  created_on   = db.DateTimeProperty(auto_now_add=True)

class SearchQueryFilters(db.Model):
  search_term   = db.StringProperty()
  description   = db.StringProperty()
  rating        = db.IntegerProperty()
  views         = db.IntegerProperty()
  user_name     = db.StringProperty()
  user_id       = db.IntegerProperty()
  created_on    = db.DateTimeProperty(auto_now_add=True)

class CatGroupTerms(db.Model):
  category_name  = db.StringProperty()
  category_term  = db.StringProperty()
  created_on     = db.DateTimeProperty(auto_now_add=True)

class CatLinkGroups(db.Model):
  category_name    = db.StringProperty()
  category_descr   = db.StringProperty()
  category_color   = db.StringProperty()
  created_on       = db.DateTimeProperty(auto_now_add=True)

class ChildListLinks(db.Model):
  link_id = db.IntegerProperty()
  main_url = db.StringProperty()
  url_title = db.StringProperty()
  keywords = db.StringProperty()
  created_on = db.DateTimeProperty(auto_now_add=True)

class UserEntityLinks(db.Model):
  user_id        = db.IntegerProperty()
  link_id        = db.IntegerProperty()
  created_on     = db.DateTimeProperty(auto_now_add=True)

# End of Script
