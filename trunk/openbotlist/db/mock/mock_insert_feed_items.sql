-- Berlin Brown
--
-- 2/2/2008

connect botlist_development;

INSERT INTO system_feed_items(main_url, url_title, url_description, url_source, process_count, created_on) 
		VALUES('http://www.reddit.com', 'The Reddit', 'the reddit', 'http://www.google.com', 0, NOW());

INSERT INTO system_feed_items(main_url, url_title, url_description, url_source, process_count, created_on) 
		VALUES('http://www.google.com', 'The Google', 'the google', 'http://www.google.com', 0, NOW());
		
INSERT INTO system_feed_items(main_url, url_title, url_description, url_source, process_count, created_on) 
		VALUES('http://www.yahoo.com', 'The Yahoo', 'the yahoo', 'http://www.yahoo.com', 0, NOW());
		
-- End of the script

