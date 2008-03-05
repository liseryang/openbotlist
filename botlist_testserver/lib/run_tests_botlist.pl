#!/usr/bin/perl

############################################################
##
## Berlin Brown
## load_db.pl - run with perl 5 an greater
##
## setup the database
############################################################

$botlist_home = "/home/bbrown/maintools/tomcat55/webapps/botlist";
$integration_tests_home = "$botlist_home/tests/integration";

print "INFO: Creating mock objects -> \n";

# Need to change to that test directory.
print "Running at $integration_tests_home \n";
chdir $integration_tests_home || die "Can't change to integration tests directory: $!\n";
system "ant -f build.xml tests.ruby.rspec";
system "ant -f build.xml tests.scala.suite";

print "INFO: Done\n";

############################################################
## End of File
############################################################
