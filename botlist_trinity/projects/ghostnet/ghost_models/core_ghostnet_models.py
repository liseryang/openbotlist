#!/usr/bin/env python
#
# Copyright 2008 Berlin Brown - botnode.com.

from google.appengine.ext import db

class EntityLinks(db.Model):
  author = db.UserProperty()
  message = db.StringProperty(multiline=True, required=True)
  date = db.DateTimeProperty(auto_now_add=True)

  id = db.IntegerProperty()
  main_url = db.StringProperty(required=True)
  url_title = db.StringProperty(required=True)
  url_description = db.StringProperty(required=True)
  keywords = db.StringProperty(required=True)
  views int(11) = db.IntegerProperty(required=True)
  created_on datetime    NOT NULL default '0000-00-00 00:00:00',
  rating int(11)         NOT NULL default '0',
  user_id int(11) = db.IntegerProperty(required=True)
  full_name = db.UserProperty()
  hostname = db.StringProperty(required=True)
  process_count = db.IntegerProperty(required=True)
  updated_on             datetime default '0000-00-00 00:00:00',
  link_type = db.StringProperty(required=True)
  bot_rating             decimal(5,2) default '0.00',
  generated_obj_id = db.StringProperty(required=True)
  user_up_votes = db.IntegerProperty(required=True)
  user_down_votes= db.IntegerProperty(required=True)
  links_ct= db.IntegerProperty(required=True)
  inbound_link_ct= db.IntegerProperty(required=True)
  outbound_links_ct= db.IntegerProperty(required=True)
  image_ct= db.IntegerProperty(required=True)
  meta_descr_len = db.IntegerProperty(required=True)
  meta_keywords_len = db.IntegerProperty(required=True)
  meta_descr_wct = db.IntegerProperty(required=True)
  meta_keywords_wct= db.IntegerProperty(required=True)
  geo_locations_ct = db.IntegerProperty(required=True)
  geo_locations_found = db.StringProperty(required=True)
  document_size = db.StringProperty(required=True)
  request_time  = db.StringProperty(required=True)
  object_id_status  = db.StringProperty(required=True)
  para_tag_ct = db.StringProperty(required=True)
    
class ActiveMediaFeeds(db.Model):
 message = db.StringProperty(multiline=True, required=True)
date = db.DateTimeProperty(auto_now_add=True)
  id           int(11) NOT NULL auto_increment,
  display_type char(1) NOT NULL default 'N',
  created_on   datetime NOT NULL default '0000-00-00 00:00:00',


class MediaFees(db.Model):
  id int(11)       NOT NULL auto_increment,
  image_filename   varchar(255) NOT NULL,
  media_url        varchar(255) NOT NULL,
  image_thumbnail  varchar(255) NOT NULL,
  media_title      varchar(255) NOT NULL,
  media_descr      text NOT NULL,
  media_type       char(1) NOT NULL default 'N',
  author           varchar(80) NOT NULL,
  rating           decimal(11,5) default NULL,
  rating_count     int(11) default '0',
  views            int(11) default '0',
  keywords         varchar(128) NOT NULL,
  orginal_imgurl   varchar(255) NOT NULL,
  process_count    int(11) default '0',
  system_id        int(11) default NULL,
  validity         int(11) default NULL,
  created_on       datetime NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (id),
  UNIQUE KEY media_url (media_url),
  KEY media_feeds_created_on_ndx (created_on)
);

CREATE TABLE admin_main_banner (
  id           int(11) NOT NULL auto_increment,
  headline     varchar(128) NOT NULL,
  enabled      char(1) NOT NULL default 'N',
  app_section  varchar(40) default NULL,
  created_on   datetime NOT NULL default '0000-00-00 00:00:00',
  

class AdminMainBanner(db.Model):
    id           int(11) NOT NULL auto_increment,
  headline     varchar(128) NOT NULL,
  enabled      char(1) NOT NULL default 'N',
  app_section  varchar(40) default NULL,
  created_on   datetime NOT NULL default '0000-00-00 00:00:00',

class SearchQueryFilters(db.Model):
   id            int(11) NOT NULL auto_increment,
  search_term   varchar(60) NOT NULL,
  description   varchar(128) NOT NULL,
  rating        int(11) NOT NULL,
  views         int(11) NOT NULL,
  user_name     varchar(50) NOT NULL,
  user_id       int(11) NOT NULL,
  created_on    datetime NOT NULL default '0000-00-00 00:00:00',

class CatGroupTerms(db.Model):
  id             int(11) NOT NULL auto_increment,
  category_name  varchar(20) NOT NULL,
  category_term  varchar(40) NOT NULL,
  created_on     datetime NOT NULL default '0000-00-00 00:00:00',

class CatLinkGroups(db.Model):
   category_name    varchar(20) NOT NULL,
  category_descr   varchar(80) NOT NULL,
  category_color   varchar(10) NOT NULL,
  created_on       datetime NOT NULL default '0000-00-00 00:00:00',

class ChildListLinks(db.Model):
	id 				int(11) NOT NULL auto_increment,
	link_id			int(11),   
  	main_url		varchar(255) NOT NULL unique,
  	url_title		varchar(128) NOT NULL,  
  	keywords		varchar(255),  
  	created_on		DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00',

class UserEntityLinks(db.Model):
  id             int(11) NOT NULL auto_increment,
  user_id        int(11) NOT NULL,
  link_id        int(11) NOT NULL,
  created_on     datetime NOT NULL default '0000-00-00 00:00:00',

# End of Script
