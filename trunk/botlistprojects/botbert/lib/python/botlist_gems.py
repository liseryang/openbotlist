"""
 Berlin Brown
 8/20/2007
 botlist_gems.py

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
"""

import time
import sys
import os

## Import modules from the gems package
from gems.botlist_sweep import BotlistSweepLinks
from gems.botlist_category import BotlistProcessCategory
from gems.gem_data_drop import EntityLinkDataDropJob
from gems.gem_web_analysis import EntityLinkWebAnalysisJob

__author__ = "Berlin Brown"
__version__ = "0.1"

"""
------------------------------------------------
 Botlist Gems
------------------------------------------------
"""
def action_data_drop():
	print "Extracting entity link data for CSV output (processing...)"
	maxLinesExport = 100000
	datadrop = EntityLinkDataDropJob()
	datadrop.processDataDrop(maxLinesExport)

def action_run_sweep():	
	sweepLinks = BotlistSweepLinks()
	sweepLinks.init()
	sweepLinks.sweep()
	sweepLinks.shutdown()

def action_run_web_analysis():
	print "Running web analysis job (processing...)"
	print "[link|descr updates]"
	web_analysis = EntityLinkWebAnalysisJob()
	web_analysis.init()
	web_analysis.processURLs()
	web_analysis.shutdown()

def action_run_object_id():
	""" Update the entity link object id, this should
	remain static and not be modified again"""
	
	print "Running object id job (processing...)"
	print "[genid updates]"
	web_analysis = EntityLinkWebAnalysisJob()
	web_analysis.init()
	web_analysis.processObjectId()
	web_analysis.shutdown()
	
def action_run_category():
	print "Setting category type for entity link (processing...)"
	processCategory = BotlistProcessCategory()
	processCategory.init()
	processCategory.buildTermSet()
	processCategory.processCategory()
	processCategory.shutdown()

def action_errhandler ():
	print "You selected an invalid operation"

gem_operations = {
		"sweep": action_run_sweep,
		"findcategory": action_run_category,
		"datadrop": action_data_drop,
		"objectid": action_run_object_id,
		"analyze": action_run_web_analysis
	}

def cleanup(home_dir):
	if home_dir:                
			pid_paths = [ home_dir, "/bin", "/botgems.pid" ]
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
		print "\n--------------------------------------------"
		print " botlist gems"        
		print " usage: <gem operation> <home directory>"
		print "----------------|"
		print " gem operations: <sweep> <findcategory> <datadrop>"
		print " + more options: <objectid> <analyze>"
		print "--------------------------------------------"
		print "version (py %s)" % __version__
		start = time.time()
		main()
		end = time.time()
		diff = end - start
				
		print "done"
		print "completed %s seconds." % diff
		print "press ENTER to continue"
				
# End of the File
