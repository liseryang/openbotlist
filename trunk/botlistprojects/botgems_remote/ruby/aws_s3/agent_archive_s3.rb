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

module AwsS3

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
    def archive_objs_s3(filename)
      # Attempt to put object
      metadata = TreeMap.new
      metadata.put("my-meta", [ "none" ])
      s3obj = S3Object.new(str.getBytes, metadata)
      
      headers = TreeMap.new
      headers.put("x-amz-acl", [ "public-read" ])
      #headers.put("Content-Type", [ "text/plain" ])
      #headers.put("Content-Type", [ "text/xml" ])
      headers.put("Content-Type", [ "application/octet-stream" ])
      c = conn.put(bucket_name, "#{key_name}-pub", s3obj, headers)
      puts c.connection.getResponseMessage   
    end  
  end
end # End of Module

# End of the script

