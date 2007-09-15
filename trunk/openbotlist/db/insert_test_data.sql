--
-- Berlin Brown
--
--
connect botlist_development;

INSERT INTO city_listing(city_name, created_on) VALUES('Atlanta', NOW());
INSERT INTO city_listing(city_name, created_on) VALUES('Austin', NOW());

INSERT INTO city_listing(city_name, created_on) VALUES('Dallas', NOW());
INSERT INTO city_listing(city_name, created_on) VALUES('Denver', NOW());
INSERT INTO city_listing(city_name, created_on) VALUES('Chicago', NOW());
INSERT INTO city_listing(city_name, created_on) VALUES('Houston', NOW());
INSERT INTO city_listing(city_name, created_on) VALUES('Miami', NOW());
INSERT INTO city_listing(city_name, created_on) VALUES('NewYork', NOW());
INSERT INTO city_listing(city_name, created_on) VALUES('Phoenix', NOW());
INSERT INTO city_listing(city_name, created_on) VALUES('Las Vegas', NOW());
INSERT INTO city_listing(city_name, created_on) VALUES('San Diego', NOW());
INSERT INTO city_listing(city_name, created_on) VALUES('SF', NOW());
INSERT INTO city_listing(city_name, created_on) VALUES('Seattle', NOW());
INSERT INTO city_listing(city_name, created_on) VALUES('Portland', NOW());

INSERT INTO city_listing(city_name, created_on) VALUES('Bangalore', NOW());
INSERT INTO city_listing(city_name, created_on) VALUES('Berlin', NOW());
INSERT INTO city_listing(city_name, created_on) VALUES('London', NOW());
INSERT INTO city_listing(city_name, created_on) VALUES('Tokyo', NOW());
INSERT INTO city_listing(city_name, created_on) VALUES('Other', NOW());

-- Update city listings, setting current set to 'MAJOR'
update city_listing set city_category = 'MAJOR';

--
-- Create the forums
INSERT INTO post_sections(generated_id, section_name, created_on) 
		VALUES('1fb6674f66ff9e617ec1313978513096', 'General Listings', NOW());

INSERT INTO post_sections(generated_id, section_name, created_on) 
		VALUES('9ce00803181d4611895ad3e764b2adb2', 'Personals', NOW());
		
INSERT INTO post_sections(generated_id, section_name, created_on) 
		VALUES('7ebc9a603519b9cdc277c2fc2d68d1a9', 'Resumes', NOW());
		
INSERT INTO post_sections(generated_id, section_name, created_on) 		
		VALUES('0b578fbfe97b317ded5ad929c2210b7d', 'Jobs', NOW());
		
INSERT INTO post_sections(generated_id, section_name, created_on) 		
		VALUES('cab4d3bd8e28cb03f17c12e5b322d6fb', 'For Sale', NOW());
		
INSERT INTO post_sections(generated_id, section_name, created_on) 		
		VALUES('effb06927b7bea46709d5d21c2465e04', 'Technology', NOW());

INSERT INTO post_sections(generated_id, section_name, created_on) 
		VALUES('9e876afb5e45a7f1d670ceceec3352a8', 'Events', NOW());

INSERT INTO post_sections(generated_id, section_name, created_on) 
		VALUES('c8ec2847bdac35595ffba82aa0f65fcbreviews', 'Reviews', NOW());

--
-- Insert the discussion forums
INSERT INTO forum_group(forum_name,
	forum_descr, keywords, created_on) 
	VALUES ('General Forum', 'General Forum', 'general forum forums chat', NOW());
	
INSERT INTO forum_group(forum_name,
	forum_descr, keywords, created_on) 
	VALUES ('Bugs and Feature Requests', 'Bugs and Feature Requests', 'bugs chat forums', NOW());

-- Insert example users
-- To encode the password, see the ViewMD5Encoding class

INSERT INTO users VALUES('berlinbrown','55bbf4f03036d6642f935c6a53795372', TRUE);

INSERT INTO authorities VALUES ('berlinbrown', 'ROLE_TELLER');
INSERT INTO authorities VALUES ('berlinbrown', 'ROLE_SUPERVISOR');

--
-- Insert new users (apr pwd)

insert into core_users(user_name, user_password, user_email, date_of_birth, account_number, active_code, last_login_success, last_login_failure, created_on, updated_on) VALUES(
    'botbob', 'c5084a613255f920e3be35e5366a94a8', 'botbob@bot.com', '1981-01-01', 'c3c18d19b5887570e74ef6cdce4b6abbbotbob', 1, NOW(), NOW(), NOW(), NOW());

insert into profile_settings(user_id, created_on) values(LAST_INSERT_ID(), NOW());

insert into core_users(user_name, user_password, user_email, date_of_birth, account_number, active_code, last_login_success, last_login_failure, created_on, updated_on) VALUES(
    'berlinbrown', 'c5084a613255f920e3be35e5366a94a8', 'berlinbrown_at_gmail.com', '1981-01-01', '68f150baab8c4439758bb33549ccd2a2berlinbrown', 1, NOW(), NOW(), NOW(), NOW());

insert into profile_settings(user_id, created_on) values(LAST_INSERT_ID(), NOW());

--
-- Insert Default Link Groups

insert into link_groups(group_name, generated_id, created_on) values('Info Articles', 'aaf9dfb546f650d5fa614156000info', NOW());			
insert into link_groups(group_name, generated_id, created_on) values('Media', 'fd50091908d57ab8b15db358000media', NOW());
insert into link_groups(group_name, generated_id, created_on) values('NSFW', '65ebdbd0e6a0a67c029000nsfw', NOW());



-- End of Insert Data