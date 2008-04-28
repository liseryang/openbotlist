#!/usr/bin/perl

############################################################
##
## Berlin Brown
## load_db.pl - run with perl 5 an greater
##
## setup the database
############################################################

$projects_home ="/home/bbrown/workspace_omega/botlist_trinity";

print "INFO: Creating objects -> \n";

# Enter the directory and run the tests.
chdir "$projects_home/projects/ghostnet" || die "Can't change to projects directory: $!\n";
system "python tests/run_all_tests.py";

print "INFO: Done\n";

############################################################
## End of File
############################################################
