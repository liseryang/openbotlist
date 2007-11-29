--
-- Berlin Brown
-- 11/28/2007
-- patch_link_analysis.sql
--
connect botlist_development;

--
-- Update the entity links table
-- to handle web analytical data
--
-- meta_descr_wct - Distinct words in description 
-- meta_keywords_wct - Distinct words in keywords
-- geo_locations_found - Listing of popular locations (cities, states, etc)

alter table entity_links ADD COLUMN generated_obj_id varchar(60) UNIQUE;

alter table entity_links ADD COLUMN user_up_votes int(11) DEFAULT 0;
alter table entity_links ADD COLUMN user_down_votes int(11) DEFAULT 0;

alter table entity_links ADD COLUMN links_ct int(11) DEFAULT 0;
alter table entity_links ADD COLUMN inbound_link_ct int(11) DEFAULT 0;
alter table entity_links ADD COLUMN outbound_links_ct int(11) DEFAULT 0;
alter table entity_links ADD COLUMN image_ct int(11) DEFAULT 0;

alter table entity_links ADD COLUMN meta_descr_len int(11) DEFAULT 0;
alter table entity_links ADD COLUMN meta_keywords_len int(11) DEFAULT 0;

alter table entity_links ADD COLUMN meta_descr_wct int(11) DEFAULT 0;
alter table entity_links ADD COLUMN meta_keywords_wct int(11) DEFAULT 0;
 
alter table entity_links ADD COLUMN geo_locations_ct int(11) DEFAULT 0;
alter table entity_links ADD COLUMN geo_locations_found varchar(128);
alter table entity_links ADD COLUMN document_size int(11) DEFAULT 0;
alter table entity_links ADD COLUMN request_time int(11) DEFAULT 0;

-- End of Script
