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

describe "Simple test <single test>" do
  before(:each) do
    @cur_sess_id = rand(1000000)

    @aws_access_key = "<INSERT KEY HERE>"
    @aws_secret_key = "<INSERT KEY HERE>"
    @key_name = "test-key"
  end

  it "Should do nothing, simple jruby rspec test" do
    puts "[!]"
  end
  
  it "Should connect to S3" do    
    conn = AWSAuthConnection.new(@aws_access_key, @aws_secret_key)
    generator = QueryStringAuthGenerator.new(@aws_access_key, @aws_secret_key)
  end

  it "Should create bucket in S3" do    
    conn = AWSAuthConnection.new(@aws_access_key, @aws_secret_key)
    generator = QueryStringAuthGenerator.new(@aws_access_key, @aws_secret_key)
    bucket_name = "#{@aws_access_key.downcase}-new-test-bucket"
    puts bucket_name
    if not conn.checkBucketExists(bucket_name)
      first_res = conn.createBucket bucket_name, AWSAuthConnection.LOCATION_DEFAULT, nil
      res = first_res.connection.getResponseMessage
      puts "INFO: #{res}"
    else
      puts "Bucket Exists"
    end
    
    # Attempt to list bucket
    objs = conn.listBucket(bucket_name, nil, nil, nil, nil).entries
    puts objs
    
    loc = conn.getBucketLocation(bucket_name).getLocation
    puts "Location: #{loc}"
    
    # Attempt to put object
    metadata = TreeMap.new
    metadata.put("my-meta", [ "none" ])
       
    str = java.lang.String.new("this is a test, public")
    s3obj = S3Object.new(str.getBytes, metadata)
    
    headers = TreeMap.new
    headers.put("x-amz-acl", [ "public-read" ])
    #headers.put("Content-Type", [ "text/plain" ])
    headers.put("Content-Type", [ "application/octet-stream" ])
    c = conn.put(bucket_name, "#{@key_name}-publicX", s3obj, headers)
    puts c.connection.getResponseMessage
    
    # We only want the http URL, set to insecure and then revert
    url_res = generator.makeBareInsecureURL(bucket_name, "#{@key_name}-publicX")
    puts url_res
    # List
    objs = conn.listBucket(bucket_name, nil, nil, nil, nil).entries
    puts objs
  end 
  
end # End of test

# End of the script

