########################################
# Rspec tests
# Author: Berlin Brown
# Date: 3/10/2008
#
# Rspec simple single test.  Modify this test
# to only test one unit.
# 
# Single test - no help
#
# -------------------------- COPYRIGHT_AND_LICENSE --
# Botlist contains an open source suite of software applications for 
# social bookmarking and collecting online news content for use on the web.  
# Multiple web front-ends exist for Django, Rails, and J2EE.  
# Users and remote agents are allowed to submit interesting articles.
#
# Copyright (c) 2007, Botnode.com (Berlin Brown)
# http://www.opensource.org/licenses/bsd-license.php
#
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification, 
# are permitted provided that the following conditions are met:
#
#	    * Redistributions of source code must retain the above copyright notice, 
#	    this list of conditions and the following disclaimer.
#	    * Redistributions in binary form must reproduce the above copyright notice, 
#	    this list of conditions and the following disclaimer in the documentation 
#	    and/or other materials provided with the distribution.
#	    * Neither the name of the Botnode.com (Berlin Brown) nor 
#	    the names of its contributors may be used to endorse or promote 
#	    products derived from this software without specific prior written permission.
#	
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# -------------------------- END_COPYRIGHT_AND_LICENSE --
#
########################################

# Have to manually find the library files; example:
# require File.join(File.dirname(__FILE__), '../../../../WEB-INF/lib/ruby/web/foaf', 'edit_foaf')

require 'java'
include Java

import org.spirit.bean.impl.BotListFeedItems

import com.amazon.s3.AWSAuthConnection
import com.amazon.s3.CallingFormat;
import com.amazon.s3.QueryStringAuthGenerator
import com.amazon.s3.S3Object

import java.util.Map
import java.util.TreeMap

require File.join(File.dirname(__FILE__), '../', 'agent_utils')

module AwsS3
    
  def self.get_rss_payload_bin(sqlMapper)
    remoteSync = Aggregate::AgentBotlistRSS.new
    remoteSync.sqlMapper = sqlMapper
    remoteSync.load_payload_doc
    remoteSync.addMsgXMLHeader
    remoteSync.scanFeeds
    bin_data = AgentUtils::string_to_bytes(remoteSync.payload_doc)
    return bin_data
  end

  def self.put_public_object(conn, bin_data, key_name, mime_type)
    s3obj = S3Object.new(bin_data, nil)
    headers = TreeMap.new
    headers.put("x-amz-acl", [ "public-read" ])
    headers.put("Content-Type", [ mime_type ])
    res_conn = conn.put(bucket_name, "key_name", s3obj, headers)
    res = res_conn.connection.getResponseMessage
    return res
  end

  class ArchiveAwsS3    
    def initialize()
      @aws_access_key = "<INSERT KEY HERE>"
      @aws_secret_key = "<INSERT KEY HERE>"
      
      # Treating bucket like a directory (botlist_thearchive)    
      @bucket_name = "#{@aws_access_key.downcase}-botlist-thearc"
      @conn = nil
      @generator = nil
    end
    
    def connect
      conn = AWSAuthConnection.new(@aws_access_key, @aws_secret_key)
      generator = QueryStringAuthGenerator.new(@aws_access_key, @aws_secret_key)
    end
    
    def setup_create_bucket
      # Only call once,
      puts bucket_name
      if not conn.checkBucketExists(bucket_name)
        first_res = conn.createBucket bucket_name, AWSAuthConnection.LOCATION_DEFAULT, nil
        res = first_res.connection.getResponseMessage
        puts "INFO: #{res}"
      else
        puts "Bucket Exists"
      end
    end
    
    # Archive the SQL object and XML document to S3
    # @bin_data - binary data (bytes associated with the s3 upload)
    # @mime_type - request mime-type for s3 (default = "application/octet-stream")
    def archive_objs_s3(bin_data, mime_type)
      # Attempt to put object
      metadata = TreeMap.new
      metadata.put("my-meta", [ "none" ])
      s3obj = S3Object.new(str.getBytes, metadata)      
      headers = TreeMap.new
      headers.put("x-amz-acl", [ "public-read" ])
      #headers.put("Content-Type", [ "text/xml" ])
      headers.put("Content-Type", [ mime_type ])
      c = conn.put(bucket_name, "#{key_name}-pub", s3obj, headers)
      return c.connection.getResponseMessage
    end  
  end
end # End of Module

# End of the script

