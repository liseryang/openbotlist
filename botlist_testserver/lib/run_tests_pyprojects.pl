#!/usr/bin/perl

############################################################
##
## Berlin Brown
## load_db.pl - run with perl 5 an greater
##
## setup the database
############################################################

$projects_home ="/home/bbrown/workspace_omega/botlistprojects_beta";

print "INFO: Creating objects -> \n";

# Enter the directory and run the tests.
chdir "$projects_home/botbert" || die "Can't change to projects directory: $!\n";
system "./bin/bot_all_tests.sh";

print "INFO: Done\n";

############################################################
## End of File
############################################################
