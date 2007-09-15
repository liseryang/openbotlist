--
-- Berlin Brown
--
-- updated: 3/24/2006
--

connect botlist_development;

--
-- Drop constraints first
--

ALTER TABLE users DROP FOREIGN KEY fk_authorities_users;

ALTER TABLE user_comments DROP FOREIGN KEY fk_forum_group_comments;
ALTER TABLE user_comments DROP FOREIGN KEY fk_post_listing_comments;
ALTER TABLE user_comments DROP FOREIGN KEY fk_link;

ALTER TABLE post_listing DROP FOREIGN KEY fk_post_listing;
ALTER TABLE post_listing DROP FOREIGN KEY fk_post_section;

ALTER TABLE doc_file_metadata DROP FOREIGN KEY fk_file_document;

ALTER TABLE post_image_metadata DROP FOREIGN KEY fk_image_adlist;

--
-- Drop foreign keys for core users
ALTER TABLE acl_manager		DROP FOREIGN KEY fk_acl_manager_acl;
ALTER TABLE acl_manager		DROP FOREIGN KEY fk_acl_manager_user;
ALTER TABLE group_manager 	DROP FOREIGN KEY fk_group_manager_group;
ALTER TABLE group_manager	DROP FOREIGN KEY fk_group_manager_user;

ALTER TABLE group_links			DROP FOREIGN KEY fk_group_links;
ALTER TABLE profile_settings	DROP FOREIGN KEY fk_profile_settings;

-- DROP TABLES
DROP TABLE if exists user_links;
DROP TABLE if exists user_visit_log;
DROP TABLE if exists city_listing;
DROP TABLE if exists post_sections;
DROP TABLE if exists post_listing;

DROP TABLE if exists entity_links;
DROP TABLE if exists forum_group;

DROP table if exists post_image_metadata;

-- ** The following will remain constant
-- DROP TABLE if exists entity_links;
-- DROP TABLE if exists child_list_links;

DROP TABLE if exists user_comments;

-- Document creation tables
DROP TABLE if exists doc_file;
DROP TABLE if exists doc_file_metadata;

-- User Tables
DROP TABLE if exists authorities;
DROP TABLE if exists users;

--
-- Core user tables
DROP table if exists core_users;


-- Drop the tables found in this user patch

DROP table if exists link_groups;
DROP table if exists group_links;
DROP table if exists profile_settings;

DROP table if exists acl_control;
DROP table if exists acl_manager;
DROP table if exists group_control;
DROP table if exists group_manager;

-- End of file