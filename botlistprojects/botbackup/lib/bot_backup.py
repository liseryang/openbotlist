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
from bot_backupdata import read_datafile
from bot_zipdir import create_zip_file, get_basename

MAX_ARG_LEN = 5
ARG_IDX_FUNC = 1
ARG_IDX_TOPDIR = 2

public_ini = None

def action_rsync(backup_path):
	global public_ini
	print "INFO: performing rsync"
	backupBeanConf = process_config(public_ini)	
	print backupBeanConf

	zip_file = "%s.zip" % get_basename(backup_path)
	zip_full_path = os.path.join(backupBeanConf.working_dir, zip_file)	
	zip_res = create_zip_file(backup_path, zip_full_path)		
	print zip_res
	
	# Example rsync shell:
	# rsync -avz -e ssh remoteuser@remotehost:/remote/dir /this/dir/ 
	args = [
		backupBeanConf.application_name,
		backupBeanConf.default_args,	
		"-e \"ssh -i %s\"" % (backupBeanConf.priv_key_file),		
		zip_full_path,
		"%s@%s:%s" %
		(backupBeanConf.username,
		 backupBeanConf.hostname,
		 os.path.join(backupBeanConf.target_dir, zip_file))
	]
	cmd_run = ' '.join(args)
	os.system(cmd_run)
	
#================================================
def process_backups(backup_datafile):
	backup_recs = read_datafile(backup_datafile)
	for bean_rec in backup_recs:
		print "+ processing backup record=%s [%s]" % (bean_rec.backup_path, bean_rec.oper)
		if bean_rec.oper == "rsync":
			action_rsync(bean_rec.backup_path)
		else:
			action_errhandler
			
def gem_action_handler():
	process_backups("/home/bbrown/sys/backup/botbackup_files.dat")
		
def action_errhandler ():
	print "You selected an invalid operation"

gem_cmd_operations = {
	"backup": gem_action_handler
	}

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
	gem_cmd_operations.get(action, action_errhandler)()
	
	# Perform any system cleanups
	if len(args) >= 3:
		cleanup(sysargs[ARG_IDX_TOPDIR])

if __name__ == '__main__':
	print "INFO: launching backup"
	print "\n--------------------------------------------"
	print " botlist backup"        
	print " usage: bot_backup.py <backup operation> <home directory> -i /path/config-file.ini"
	print " backup operations: backup"        
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
