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

 -------------------------- COPYRIGHT_AND_LICENSE --
 Botlist contains an open source suite of software applications for 
 social bookmarking and collecting online news content for use on the web.  
 Multiple web front-ends exist for Django, Rails, and J2EE.  
 Users and remote agents are allowed to submit interesting articles.

 Copyright (c) 2007, Botnode.com (Berlin Brown)
 http://www.opensource.org/licenses/bsd-license.php

 All rights reserved.

 Redistribution and use in source and binary forms, with or without modification, 
 are permitted provided that the following conditions are met:

	    * Redistributions of source code must retain the above copyright notice, 
	    this list of conditions and the following disclaimer.
	    * Redistributions in binary form must reproduce the above copyright notice, 
	    this list of conditions and the following disclaimer in the documentation 
	    and/or other materials provided with the distribution.
	    * Neither the name of the Botnode.com (Berlin Brown) nor 
	    the names of its contributors may be used to endorse or promote 
	    products derived from this software without specific prior written permission.
	
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 -------------------------- END_COPYRIGHT_AND_LICENSE --
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
