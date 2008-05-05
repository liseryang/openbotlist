#!/usr/bin/env python
#
# Copyright 2008 Berlin Brown - botnode.com.
'''
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
from google.appengine.ext import db

class EntityLinks(db.Model):
  mainUrl = db.StringProperty(required=True)
  urlTitle = db.StringProperty(required=True)
  urlDescription = db.TextProperty(required=True)
  keywords = db.TextProperty(required=True)
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
