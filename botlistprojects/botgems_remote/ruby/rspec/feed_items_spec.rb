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

import java.sql.DriverManager

import com.ibatis.sqlmap.client.SqlMapClient
import com.ibatis.sqlmap.client.SqlMapClientBuilder
import com.ibatis.common.resources.Resources
import org.spirit.bean.impl.BotListFeedItems

describe "Simple test <single test>" do
  before(:each) do
    @cur_sess_id = rand(1000000)
  end

  it "Should do nothing, simple jruby rspec test" do
    puts "[!]"
  end

  it "Should create a temp sqlite database" do
    java.lang.Class.forName("org.sqlite.JDBC")
    conn = DriverManager.getConnection("jdbc:sqlite:./rspec_test_movies.db")
    stat = conn.createStatement()
  end
    
  it "Should read ALL feeds from ibatis" do
    reader = Resources.getResourceAsReader("conf/SqlMapConfig_TEST.xml")
    sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader)
    reader.close()
    
    items = BotListFeedItems.new
    items.rating = 0
    items.views = 100
    feedItems = sqlMapper.queryForList("selectAllFeedItems", items)
    feedItems.each { |item|
    }
  end # End

  it "Should read feeds from ibatis" do
    # Find the config file using ruby's join and expand path.x
    # file = File.join(File.dirname(__FILE__), '../../conf/SqlMapConfig.xml')
    # file = File.expand_path(file)
    # The config file resource is loaded based on the classpath loc
    reader = Resources.getResourceAsReader("conf/SqlMapConfig_TEST.xml")
    sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader)
    reader.close()
    
    items = BotListFeedItems.new
    items.rating = 0
    items.views = 100
    feedItems = sqlMapper.queryForList("selectFeedItems", items)
    feedItems.each { |item|
    }
  end # End
  
  it "Should read ALL feeds from ibatis, save to sqlite" do
    
    java.lang.Class.forName("org.sqlite.JDBC")
    conn = DriverManager.getConnection("jdbc:sqlite:./rspec_test_movies.db")
    stat = conn.createStatement
    begin 
      #rs = stat.executeUpdate("drop table feed_items if exists;")
      rs = stat.executeUpdate("create table feed_items(main_url);")
      puts "Result create table: #{rs}"
    rescue
      puts "Error creating table"
    end
      
    reader = Resources.getResourceAsReader("conf/SqlMapConfig_TEST.xml")
    sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader)
    reader.close()   
    items = BotListFeedItems.new
    items.rating = 0
    items.views = 100
    feedItems = sqlMapper.queryForList("selectAllFeedItems", items)
    feedItems.each { |item|
      rs = stat.executeUpdate("insert into feed_items(main_url) values('#{item.mainUrl}');")
      puts rs
    }
    
    # Also check data was found in the sqlite database
    rs = stat.executeQuery("select main_url from feed_items;")
    rs.next()
    puts "sqlite item: #{rs.getString(1)}"
    conn.close

  end # End of Test

end # End of module

# End of the script

