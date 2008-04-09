#
# Berlin Brown
# jruby - bot_remote_sync
#
# Updated 2/10/2008 for new RDF remote process

require 'java'
require 'rexml/document'

require 'agent_botlist_aggregate'
include REXML

include_class 'java.net.HttpURLConnection' unless defined? HttpURLConnection
include_class 'com.ibatis.sqlmap.client.SqlMapClient' unless defined? SqlMapClient
include_class 'com.ibatis.sqlmap.client.SqlMapClientBuilder' unless defined? SqlMapClientBuilder
include_class 'com.ibatis.common.resources.Resources' unless defined? Resources

include_class 'org.spirit.loadtest.LoadTestManager' unless defined? LoadTestManager
include_class 'org.spirit.bean.impl.BotListSystemAuditLog' unless defined? BotListSystemAuditLog

def connect(key_url, send_url)
  puts "INFO: keyurl=#{key_url}"
  puts "INFO: syncurl=#{send_url}"
  reader = Resources.getResourceAsReader("conf/SqlMapConfig.xml")
  sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader)
  reader.close()
  
  remoteSync = RemoteSync.new
  remoteSync.sqlMapper = sqlMapper
  remoteSync.load_payload_doc
  remoteSync.key_request_url = key_url
  remoteSync.remote_send_url = send_url
  remoteSync.addMsgXMLHeader
  remoteSync.scanFeeds
  response_serv = remoteSync.sendFeedItemData
  puts response_serv
end

def main()	
  if ARGV.size != 2		
    puts "usage: bot_remote_sync.rb <key url> <post to url>"
    puts "args=#{ARGV}"
    return 
  end
  puts "*** Running bot remote process"
  start_time = Time.now
  
  key_url = ARGV[0]
  send_url = ARGV[1]	
  connect(key_url, send_url)
  end_time = Time.now
  diff_time = end_time - start_time
  printf "processing remote sync in %.5f s\n", diff_time
  puts "*** Done"

end # End of Method

main()

# End of script
