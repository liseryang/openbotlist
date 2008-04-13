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

require 'rexml/document'
include REXML

# Load the agent aggregate library (remoting library)
require File.join(File.dirname(__FILE__), '../', 'agent_botlist_aggregate')
require File.join(File.dirname(__FILE__), '../', 'agent_archive')

import java.net.HttpURLConnection unless defined? HttpURLConnection
import com.ibatis.sqlmap.client.SqlMapClient unless defined? SqlMapClient
import com.ibatis.sqlmap.client.SqlMapClientBuilder unless defined? SqlMapClientBuilder
import com.ibatis.common.resources.Resources unless defined? Resources
import org.spirit.loadtest.LoadTestManager unless defined? LoadTestManager
import org.spirit.bean.impl.BotListSystemAuditLog unless defined? BotListSystemAuditLog


describe "Simple test <single test>" do
  before(:each) do
    @cur_sess_id = rand(1000000)
  end

  it "Should do nothing, simple jruby rspec test" do
    puts "[!]"
  end
    
  def load_ibatis_sqlmap()
    reader = Resources.getResourceAsReader("conf/SqlMapConfig_TEST.xml")
    sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader)
    reader.close()
    return sqlMapper
  end
  
  it "Should build a XML aggregate document" do
    key_url="http://127.0.0.1:8080/botlist/lift/pipes/types/remote_agent_req"
    send_url="http://127.0.0.1:8080/botlist/lift/pipes/types/remote_agent_send"
    sqlMapper = load_ibatis_sqlmap
    remoteSync = Aggregate::AgentBotlistRSS.new
    remoteSync.sqlMapper = sqlMapper
    remoteSync.load_payload_doc
    remoteSync.key_request_url = key_url
    remoteSync.remote_send_url = send_url
    remoteSync.addMsgXMLHeader
    remoteSync.scanFeeds
    puts remoteSync.payload_doc    
  end
      
end # End of module

# End of the script

