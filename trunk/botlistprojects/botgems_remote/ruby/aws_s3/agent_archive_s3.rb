########################################
# Rspec tests
# Author: Berlin Brown
# Date: 3/10/2008
#
# Rspec simple single test.  Modify this test
# to only test one unit.
# 
# Single test - no help
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

