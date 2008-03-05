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

print "INFO: Creating mock objects -> \n";

# Enter the spider directory and run the tests.
chdir "$spider_home/tests/haskell" || die "Can't change to spider home directory: $!\n";
system "make clean";
system "make build-all";
system "make tests";
system "make unit-tests";

print "INFO: Done\n";

############################################################
## End of File
############################################################
