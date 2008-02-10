"""
 Copyright (c) 2006-2007, Berlin Brown

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

 Module: gems.web.scan_url
"""

import time
import datetime

from soup.BeautifulSoup import *
import urllib2

import re
from urlparse import urlparse
import itertools
import socket
import threading

FF_USER_AGENT = "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6"

#-------------------------------------------------
class WebAnalysisModel:
	def __init__(self):
		"""Current Database fields for web analysis
		***********************************
		 generated_obj_id, user_up_votes, user_down_votes     
		 links_ct, inbound_link_ct, outbound_links_ct   
		 image_ct, meta_descr_len      
		 meta_keywords_len, meta_descr_wct, meta_keywords_wct   
		 geo_locations_ct, geo_locations_found 
		 document_size, request_time
		***********************************"""
		self.link_type = None
		self.generated_obj_id = None
		# (removed because of NULL)
		self.geo_locations_found = None		
		self.links_ct = 0
		self.inbound_link_ct = 0
		self.outbound_links_ct = 0 
		self.image_ct = 0		
		self.meta_descr_len = 0
		self.meta_keywords_len = 0
		self.meta_descr_wct = 0
		self.meta_keywords_wct = 0
		self.para_tag_ct = 0
		self.geo_locations_ct = 0		
		self.document_size = 0
		self.request_time = 0
		self.http_status_code = 0
		
	def __str__(self):
		data = [ "{ analysis-model: ",
				 " Link n=%s" % (self.links_ct),
				 " Image n=%s" % (self.image_ct), 
				 " Descr ln=%s" % (self.meta_descr_len),
				 " Keywords ln=%s" % (self.meta_keywords_len),
				 " Descr n=%s" % (self.meta_descr_len),
				 " P n=%s" % (self.para_tag_ct),
				 " Doc size=%s" % (self.document_size),
				 " Req time=%s" % (self.request_time),
				 " }"
				 ]
		return ''.join(data)
		
#-------------------------------------------------
# Page Extract Utilities
#-------------------------------------------------
def get_meta_content(meta_data_arr):
	try:
		content_content = None
		if meta_data_arr and len(meta_data_arr) > 0:
			content_keywords = [el['content'] for el in meta_data_arr]
			if content_keywords and len(content_keywords) > 0:
				return content_keywords[0]
	except:
		pass
			
def extractPageData(opener, url_str):
	"""Request a page through urllib2 libraries, through beautiful soup,
	extract the page content data including number links, imgs, etc"""
	req = None
	cur_time = datetime.datetime.now()
	status_code_res = 0
	model = WebAnalysisModel()
	try:
		start = time.clock()
		req = urllib2.Request(url_str)
		req.add_header('user-agent', FF_USER_AGENT)		
		data = opener.open(req).read()
		soup = BeautifulSoup(data)
		
		links = soup.findAll('a')
		imgs = soup.findAll('img')
		para = soup.findAll('p')
		meta_data_keywords = soup.findAll('meta', {'name':'keywords'})
		meta_data_descr = soup.findAll('meta', {'name':'description'})

		keywords = get_meta_content(meta_data_keywords)
		descr = get_meta_content(meta_data_descr)
		keywords_arr = [0, 0]
		descr_arr = [0, 0]
		if keywords:
			keywords_arr[0] = len(keywords)
			keywords_arr[1] = len(keywords.split(","))
		if descr:
			descr_arr[0] = len(descr)
			descr_arr[1] = len(descr.split(","))
		
		end = time.clock()
		response_time = int((end - start) * 1000.0)

		# Build a web content model
		model.links_ct = len(links)
		model.inbound_link_ct = 0
		model.outbound_links_ct = 0 
		model.image_ct = len(imgs)
		model.meta_keywords_len = keywords_arr[0]
		model.meta_descr_len = descr_arr[0]
		model.meta_keywords_wct = keywords_arr[1]
		model.meta_descr_wct = descr_arr[1]
		model.para_tag_ct = len(para)
		model.geo_locations_ct = 0 
		model.document_size = 0
		model.request_time = response_time
		status_code_res = 200
	except urllib2.HTTPError, e:
		print 'Error status code: ', e.code
		print "ERR [%s]:scan_url HTTPError: url=%s" % (cur_time, url_str)
		status_code_res = e.code
		print e
	except Exception, e:
		print "ERR [%s]:scan_url url=%s" % (cur_time, url_str)
		status_code_res = 500
		print e

	model.http_status_code = status_code_res
	# Return the final model state
	return model
		
# End of Script
