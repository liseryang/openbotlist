#!/usr/bin/perl

############################################################
##
## Berlin Brown
## load_db.pl - run with perl 5 an greater
##
## setup the database
############################################################

$botlist_home = "/home/bbrown/maintools/tomcat55/webapps/botlist";
$misc_tests_home = "$botlist_home/tests/misc";

print "INFO: Running load test -> \n";

# Need to change to that test directory.
print "Running at $misc_tests_home \n";
chdir $misc_tests_home || die "Can't change to misc tests directory: $!\n";
system "ant -f build.xml run.loadtests.local";

print "INFO: Done\n";

############################################################
## End of File
############################################################
