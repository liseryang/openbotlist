#!/usr/bin/env perl

############################################################
##
## Berlin Brown
## load_db.pl - run with perl 5 an greater
##
## setup the database
############################################################

$botlist_home = "/home/bbrown/maintools/tomcat55/webapps/botlist";
$user_name = "botlistfriend";
$user_access = "b80t1st";
$db_name = "openbotlist_test";

print "INFO: Dropping database tables -> \n";
system "mysql -u$user_name -p$user_access --force --silent $db_name < $botlist_home/db/drop_tables.sql";
print "INFO: Creating database tables -> \n";
system "mysql -u$user_name -p$user_access --force --silent $db_name < $botlist_home/db/create_tables.sql";
system "mysql -u$user_name -p$user_access --force --silent $db_name < $botlist_home/db/insert_sys_scan_feeds.sql";
print "INFO: done\n";

############################################################
## End of File
############################################################
