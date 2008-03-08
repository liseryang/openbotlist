#!/usr/bin/perl

############################################################
##
## Berlin Brown
## load_db.pl - run with perl 5 an greater
##
## setup the database
############################################################

$botlist_home = "/home/bbrown/maintools/tomcat55/webapps/botlist";
$spider_home ="/home/bbrown/workspace_omega/botlistprojects_beta/botspider/spider";
$laughing_man_home = "/home/bbrown/workspace_omega/botlistprojects_beta/laughingman";

print "INFO: Creating mock objects -> \n";

# Enter the spider directory and run the tests.
chdir "$spider_home/tests/haskell" || die "Can't change to spider home directory: $!\n";
system "make clean";
system "make build-all";
system "make tests";
system "make unit-tests";

# Enter the laughing man project home and run the tests.
chdir "$laughing_man_home" || die "Can't change to laughing man home directory: $!\n";
system "make clean";
system "make";
system "make tests";

print "INFO: Done\n";

############################################################
## End of File
############################################################
