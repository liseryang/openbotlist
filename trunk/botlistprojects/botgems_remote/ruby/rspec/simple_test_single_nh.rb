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

end # End of module

# End of the script

