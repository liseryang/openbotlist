--
-- Berlin Brown
--
-- updated: 11/12/2006
--
-- connect to the
-- databatase
--
-- file: create_tables.sql
-- see insert_tables.sql

connect botlist_development;

---------------------------------
-- Create the user admin tables
---------------------------------
CREATE TABLE users (
	username VARCHAR(50) NOT NULL PRIMARY KEY,
	password VARCHAR(50) NOT NULL,
	enabled BIT NOT NULL
);

CREATE TABLE authorities (
	username VARCHAR(50) NOT NULL,
	authority VARCHAR(50) NOT NULL
);

ALTER TABLE authorities ADD CONSTRAINT fk_authorities_users foreign key (username) REFERENCES users(username);

-- End of Creating Admin Tables 
---------------------------------

--
-- User links is deprecated (not used, but deleting may cause issues)
CREATE TABLE user_links (
  id 				int(11) NOT NULL auto_increment,
  main_url			varchar(255) NOT NULL,
  url_title			varchar(128),
  url_description 	varchar(255),
  keywords			varchar(255),
  source			varchar(40),
  source_url		varchar(255),
  total_rating		int(11) DEFAULT 0,
  occurrence		int(11) DEFAULT 0,
  created_on		DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (id)
);

--
-- Keep a user log
CREATE TABLE user_visit_log (
	id 			int(11) NOT NULL auto_increment,	
	remote_host	varchar(30),
	host 		varchar(30),
	referer		varchar(255),
	user_agent	varchar(255),
	request_uri	varchar(255),
	request_page varchar(124),	
	created_on  DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00',
	PRIMARY KEY (id)
);


--
-- City listings
CREATE TABLE city_listing (
	id 				int(11) NOT NULL auto_increment,
	city_name		varchar(255) NOT NULL UNIQUE,
	created_on		DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00',
  	PRIMARY KEY (id)
);

--
-- PostSections
CREATE TABLE post_sections (
	id 				int(11) NOT NULL auto_increment,
	generated_id	varchar(255) NOT NULL UNIQUE,
	section_name	varchar(128) NOT NULL UNIQUE,
	created_on		DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00',
  	PRIMARY KEY (id)
);

--
-- Create a default post ad listing
-- A city has a post listing
CREATE TABLE post_listing (
  id 				int(11) NOT NULL auto_increment,
  city_id			int(11) NOT NULL,
  section_id		int(11) NOT NULL,
  category			varchar(128) NOT NULL,
  email				varchar(128) NOT NULL,  
  location			varchar(255),
  title				varchar(255) NOT NULL,
  main_url			varchar(255),
  keywords			varchar(255),
  message 			text NOT NULL,
  age				int(11) DEFAULT 0,
  created_on		DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00',  
  PRIMARY KEY (id),
  constraint fk_post_listing
			foreign key (city_id) references city_listing(id),
  constraint fk_post_section
  			foreign key (section_id) references post_sections(id)
);

--
-- Image Metadata associated with ad postings
-- typically, an ad listing could have 2 image uploads
CREATE TABLE post_image_metadata(
	id					int(11) NOT NULL auto_increment, 
	adlist_id			int(11) NOT NULL, 
	image_filename		varchar(255) NOT NULL UNIQUE,	
	image_filesize		int(11),
	image_originalname	varchar(255),
	created_on  		DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00',
	PRIMARY KEY (id),
	constraint fk_image_adlist
		foreign key (adlist_id) references post_listing(id)
);


-- Create the simple user blog
-- Users have user-links
-- The foreign key is attached to the 'has-a'
--
-- entity_links is currently associated with
--  'child_list_links' and 'user_comments'
CREATE TABLE entity_links (
  id 				int(11) NOT NULL auto_increment,
  main_url			varchar(255) NOT NULL unique,
  url_title			varchar(128) NOT NULL,
  url_description 	varchar(255),
  keywords			varchar(255),
  views				int(11) DEFAULT 0,
  rating 			int(11) NOT NULL DEFAULT 0,
  user_id			int(11), 
  full_name			varchar(128) NOT NULL,
  created_on		DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (id)
);

-- 
-- Sub links
-- created: 1/4/2007
CREATE TABLE child_list_links (
  	id 				int(11) NOT NULL auto_increment,
	link_id			int(11),   
  	main_url		varchar(255) NOT NULL unique,
  	url_title		varchar(128) NOT NULL,  
  	keywords		varchar(255),  
  	created_on		DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00',
	PRIMARY KEY (id),
	constraint fk_child_link
		foreign key (link_id) references entity_links(id)
);

--
-- Create the forum groups for the forum discussions
CREATE TABLE forum_group (
	id			int(11) NOT NULL auto_increment,
	city_id		int(11), 
	forum_name	varchar(255) NOT NULL UNIQUE,
	forum_descr	varchar(255),
	keywords	varchar(255),
	created_on  DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00',
	PRIMARY KEY (id)
);


CREATE TABLE user_comments(
	id			int(11) NOT NULL auto_increment,  
	link_id		int(11),  
	adlist_id	int(11),  
	forum_id	int(11), 
	comment_id  int(11),
	user_id		int(11), 
	full_name	varchar(128) NOT NULL,
	email		varchar(80),
	subject		varchar(255),
	zipcode		varchar(20),
	main_url	varchar(255),
	keywords	varchar(255),
	message		TEXT NOT NULL,
	created_on  DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00',
	PRIMARY KEY (id),
	constraint fk_link
		foreign key (link_id) references entity_links(id),
	constraint fk_post_listing_comments
		foreign key (adlist_id) references post_listing(id),
	constraint fk_forum_group_comments
		foreign key (forum_id) references forum_group(id)
);



--
-- Group Links - Categorize links by group
-- Added: 4/7/2007
CREATE TABLE link_groups (
	id 				int(11) NOT NULL auto_increment,
	group_name		varchar(255) NOT NULL UNIQUE,
	generated_id	varchar(255) NOT NULL UNIQUE,
	created_on		DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00',
  	PRIMARY KEY (id)
);

CREATE TABLE group_links (
  id 				int(11) NOT NULL auto_increment,
  group_id			int(11) NOT NULL, 
  main_url			varchar(255) NOT NULL unique,
  url_title			varchar(128) NOT NULL,
  url_description 	varchar(255),
  keywords			varchar(255),
  views				int(11) DEFAULT 0,
  rating			int(11) DEFAULT 0,
  created_on	DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (id),
  constraint fk_group_links
			foreign key (group_id) references link_groups(id)
);

--
-- Core User Table
-- Added: 4/1/2007
CREATE TABLE core_users (
	id   			int(11) NOT NULL auto_increment,
	user_name 		VARCHAR(50) NOT NULL UNIQUE,
	user_password 	VARCHAR(128) NOT NULL,
	user_email 		VARCHAR(255) NOT NULL,
	user_url 		VARCHAR(255),
	location		VARCHAR(255),
	date_of_birth 	DATE NOT NULL DEFAULT '0000-00-00',
	experience_points 	int(11) DEFAULT 0,
	karma 				int(11)	DEFAULT 0,
	secretques_code TINYINT DEFAULT 0 NOT NULL,
	secret_answer 	VARCHAR(128),
	account_number 	VARCHAR(128) NOT NULL,
	active_code TINYINT DEFAULT 0,
	failed_attempts	int(11) DEFAULT 0,
	last_login_success DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00',
	last_login_failure DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00',
	created_on  DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00',
	updated_on  DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00',
	PRIMARY KEY (id)
);

--
-- Access Control List - List of access levels
CREATE TABLE acl_control (
 	id				int(11) NOT NULL auto_increment,
 	control_uid		VARCHAR(128) NOT NULL,
   	control_name 	VARCHAR(50) NOT NULL,
   	short_descr 	VARCHAR(50) NOT NULL,
	long_descr 		VARCHAR(255),
	created_on  	DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00',
	PRIMARY KEY (id)
);

--
-- Group Control List - List of groups
CREATE TABLE group_control (
	id 			int(11) NOT NULL auto_increment,
	group_uid 	VARCHAR(128) NOT NULL,
	group_name 	VARCHAR(50) NOT NULL,
	short_descr VARCHAR(50) NOT NULL,
	long_descr	VARCHAR(255),
	created_on  DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00',
	PRIMARY KEY (id)
);

CREATE TABLE acl_manager (
	id 			int(11) NOT NULL auto_increment,
	acl_id  	int(11) NOT NULL,
	user_id  	int(11) NOT NULL,       
	created_on  DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00',
	PRIMARY KEY (id),
	constraint fk_acl_manager_acl
			foreign key (acl_id) references acl_control(id),
	constraint fk_acl_manager_user
			foreign key (user_id) references core_users(id)
);

CREATE TABLE group_manager (
	id 			int(11) NOT NULL auto_increment,
   	group_id  	int(11) NOT NULL,
	user_id  	int(11) NOT NULL,
	created_on  DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00',
	PRIMARY KEY (id),
	constraint fk_group_manager_group
			foreign key (group_id) references group_control(id),
	constraint fk_group_manager_user
			foreign key (user_id) references core_users(id)
);

--
-- Profile Settings, profile settings associated with the core user
-- set link color to light blue: 3838E5
-- 4/16/2007
CREATE TABLE profile_settings (
	id 			int(11) NOT NULL auto_increment,
	user_id		int(11) NOT NULL UNIQUE,
	link_color	varchar(10) NOT NULL DEFAULT '3838E5',
	PRIMARY KEY (id),
	created_on  DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00',
	constraint fk_profile_settings
			foreign key (user_id) references core_users(id)
);

-- End of User Tables

-- End of file