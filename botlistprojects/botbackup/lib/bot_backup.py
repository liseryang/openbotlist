'''
 ************************************************
 Copyright 2006-2007. All Rights Reserved 
 Berlin Brown
 10/10/2007
 ************************************************
'''
__author__ = "Berlin Brown"
__version__ = "0.1"

import time
import sys
import os

from rsync import rsync

def action_rsync():
	print "INFO: performing rsync"	
	# rsync -avz -e ssh remoteuser@remotehost:/remote/dir /this/dir/ 
	args = [
		"rsync",
		"-avz",	
		"-e \"ssh -i /home/USER/sys/backup/FILE_KY\"",		
		"/home/USER/music.tar.gz",		
		"USER@india:/home/USER/BACKUP/music.tar.gz"
	]
	cmd_run = ' '.join(args)
	os.system(cmd_run)
	
	
def action_errhandler ():
	print "You selected an invalid operation"

gem_operations = {
		"rsync": action_rsync
	}

#================================================

def cleanup(home_dir):
	if home_dir:                
			pid_paths = [ home_dir, "/bin", "/bot_backup.pid" ]
			pid_file = ''.join(pid_paths)
			print "INFO: removing bot pid file=%s" % pid_file
			os.remove(pid_file)                
	else:
			print "WARN: invalid home directory, remove pid file failed"

def main():
	args = sys.argv
	if len(args) != 3:
		print "INFO: invalid arguments"
		print args
		return	
	action = args[1]
		
	# Run the operation
	gem_operations.get(action, action_errhandler)()	
	# Perform any system cleanups        
	if len(args) >= 3:
		cleanup(args[2])     

if __name__ == '__main__':
	print "INFO: launching backup"
	print "\n--------------------------------------------"
	print " botlist backup"        
	print " usage: <backup operation> <home directory>"
	print " backup operations: rsync"        
	print "--------------------------------------------"
	print "version (py %s)" % __version__
	start = time.time()
	main()
	end = time.time()
	diff = end - start
				
	print "INFO: done"
	print "completed %s seconds." % diff
	print "press ENTER to continue"
	
