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
import getopt

from bot_parse_ini import process_config, load_script
from rsync import rsync

MAX_ARG_LEN = 5
ARG_IDX_FUNC = 1
ARG_IDX_TOPDIR = 2

public_ini = None

def action_rsync():
	global public_ini
	print "INFO: performing rsync"
	backupBean = process_config(public_ini)
	print backupBean
	# Example rsync shell:
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
	sysargs = sys.argv
	if len(sysargs) != MAX_ARG_LEN:
		print "usage: bot_backup.py <backup operation> <home directory> -i /path/config-file.ini"
		print ' '.join(sysargs)
		return
	
	optlist, args = getopt.getopt(sysargs[3:], "i:")
	print "Args=", optlist, args
	print "usage: bot_backup.py <backup operation> <home directory> -i /path/config-file.ini"
	inpath = None
	for (option, value) in optlist:
		if option == '-i':
			inpath = value

	print "Config=", inpath	
	action = sysargs[ARG_IDX_FUNC]

	# Set the global ini path location
	global public_ini
	public_ini = load_script(inpath)
		
	# Run the operation
	gem_operations.get(action, action_errhandler)()
	
	# Perform any system cleanups
	if len(args) >= 3:
		cleanup(sysargs[ARG_IDX_TOPDIR])

if __name__ == '__main__':
	print "INFO: launching backup"
	print "\n--------------------------------------------"
	print " botlist backup"        
	print " usage: bot_backup.py <backup operation> <home directory> -i /path/config-file.ini"
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
	
# End of File
