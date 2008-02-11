"""
 Berlin Brown
 Date: 2/2/2008
 Copyright: Public Domain

 Utility for checking if process is running.

 Versions:
 Should work with python 2.4+

 Use case includes:
 * If PID file found, read the contents
 * If PID file found or not found, also check the 'ps aux' status of the script
   to make sure that the script is not running.

 Additional FAQ:
 * What if the PID file gets created but does not get removed?
   + In this scenario, we need to issue a 'force' command.  But also,
   check the running process with the 'ps aux' command.

 Script/App Exit Codes:
 0 - Pass, sucess
 1 - catchall for general errors
 3 - Used for botlist purposes

 References:
 http://docs.python.org/lib/node536.html
"""

__author__ = "Berlin Brown"
__version__ = "0.1"
__copyright__ = "Copyright (c) 2006-2008 Berlin Brown"
__license__ = "Public Domain"

import sys
import os
from subprocess import Popen, call, PIPE

PROC_SCRIPT_NAME = "check_process.py"

SUCCESS_EXIT_CODE=0
ERR_PS_SCRIPT_RUNNING=3
ERR_PID_SCRIPT_RUNNING=4

def check_ps_cmd(script_name):
	try:
		p1 = Popen(["ps", "aux"], stdout=PIPE)
		p2 = Popen(["grep", script_name], stdin=p1.stdout, stdout=PIPE)
		output = p2.communicate()[0]
		return output		
	except Exception, e:
		print >>sys.stderr, "Execution failed:", e
		return None

def is_pid_running(full_cmd):
	try:
		p = Popen(full_cmd, shell=True, stdout=PIPE)
		output = p.communicate()[0]
		if output:
			# if something is there then we can return true
			return True
	except Exception, e:
		print >>sys.stderr, "Execution failed:", e
		return False
	# Final exit
	return False
	
def find_std_output(std_output, script_name):
	# split the ps aux output and check the parameters
	data = std_output.split()
	# first, ignore the current script and eliminate
	for i in data:
		if i.find(PROC_SCRIPT_NAME) > 0:
			return False
	# Begin search again, for the target script name
	for i in data:
		if i.find(script_name) > 0:
			return True		
	return False

def is_script_running(script_name):
	res = False
	std_output = check_ps_cmd(script_name)
	if std_output:
		std_output = std_output.split('\n')
		for curline in std_output:
			res = find_std_output(curline, script_name)			
	return res
			
def launch_process(full_cmd):
	try:
		retcode = call(full_cmd, shell=True)
		if retcode < 0:
			print >>sys.stderr, "Child was terminated by signal", -retcode
		else:
			print >>sys.stderr, "Child returned", retcode
		return retcode
	except OSError, e:
		print >>sys.stderr, "Execution failed:", e
		return -1

def main(args):	
	if len(args) < 3:
		return -1
	else:		
		# Arg - ID:1 = PID file to read
		pid_file = args[1]
		script_name = args[2]
		try:
			f = open(pid_file)
			data = f.readline()			
			pid = data.strip()
			cmd = "ps -p %s --no-heading" % pid
			res = is_pid_running(cmd)
			
			if res:
				return ERR_PID_SCRIPT_RUNNING
			else:
				# It isn't running, that is good.
				return SUCCESS_EXIT_CODE
			
		except Exception, e:
			# Something happened with the file
			print e
			print "Checking process list for command"
			res = is_script_running(script_name)
			# If script is running and file not found
			# exit, otherwise success
			if res ==  True:
				return ERR_PS_SCRIPT_RUNNING
			else:
				return SUCCESS_EXIT_CODE
			
	return -1

if __name__ == '__main__':
	res = main(sys.argv)
	sys.exit(res)
