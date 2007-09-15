--
-- Create the database (openbotlist_)
--
create database openbotlist_development;
create database openbotlist_test;
create database openbotlist_production;

grant all on openbotlist_development.* to 'USER'@'localhost' identified by 'PASSWORD';
grant all on openbotlist_test.* to 'USER'@'localhost' identified by 'PASSWORD';
grant all on openbotlist_production.* to 'USER'@'localhost' identified by 'PASSWORD';

grant all on openbotlist_development.* to 'USER'@'*' identified by 'PASSWORD';
grant all on openbotlist_test.* to 'USER'@'*' identified by 'PASSWORD';
grant all on openbotlist_production.* to 'USER'@'*' identified by 'PASSWORD';

-- End of the File

