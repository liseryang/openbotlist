##############################
# Berlin Brown
# jruby - bot_remote_sync
#
# Updated 2/10/2008 for new RDF remote process
# 
# Main module for pushing RSS data to the core botlist front end
# Use the command-line arguments to switch to'uploading to S3
#
# For local remoting tasks, the server must be running.
##############################

require 'java'
include Java

require 'optparse'
require 'ostruct'
require 'rexml/document'

include REXML

# Load the agent aggregate library (remoting library)
require File.join(File.dirname(__FILE__), 'agent_botlist_aggregate')
require File.join(File.dirname(__FILE__), 'agent_archive')

import java.net.HttpURLConnection unless defined? HttpURLConnection
import com.ibatis.sqlmap.client.SqlMapClient unless defined? SqlMapClient
import com.ibatis.sqlmap.client.SqlMapClientBuilder unless defined? SqlMapClientBuilder
import com.ibatis.common.resources.Resources unless defined? Resources
import org.spirit.loadtest.LoadTestManager unless defined? LoadTestManager
import org.spirit.bean.impl.BotListSystemAuditLog unless defined? BotListSystemAuditLog

USAGE_TEXT = <<EOF
 bot_remote_sync - vers 0.1 (botlist project)
 
 Usage: bot_remote_sync.rb READ_URL POST_URL [args]
 
 Available Actions:
 -a [--action] (agent_rss | agent_archive)
EOF

def parse_args()
  options = OpenStruct.new
  options.action = :none
  options.verbose = false
  opts = OptionParser.new do |opts|
    # Enumerate the available actions
    opts.on("-a", "--action ACTION", [:agent_rss, :agent_archive], 
            "Actions {agent_rss|agent_archive}.") do |s|
      options.action = s
    end
    opts.on("-v", "--verbose", "Display verbose output.") do |v|
      options.verbose = v
    end
    opts.on_tail("-h", "--help", USAGE_TEXT) do |h|
      puts opts
    end
  end # End do opts
  return [opts, options]
end # End of method

def agent_action_delegate(options, key_url, send_url)
  # Based on the command-line arguments, invoke an agent action
  if options.action == :agent_rss
    connect(key_url, send_url)
  elsif options.action == :agent_archive
    # Remote to the S3 system
    action_archive()
  else
    # Invalid action
    puts "ERR: Invalid action selection action=(#{options.action})"
    puts USAGE_TEXT
    exit
  end
end

def load_ibatis_sqlmap()
  reader = Resources.getResourceAsReader("conf/SqlMapConfig.xml")
  sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader)
  reader.close()
  return sqlMapper
end

def connect(key_url, send_url)
  puts "INFO: keyurl=#{key_url}"
  puts "INFO: syncurl=#{send_url}"
  sqlMapper = load_ibatis_sqlmap
  remoteSync = Aggregate::AgentBotlistRSS.new
  remoteSync.sqlMapper = sqlMapper
  remoteSync.load_payload_doc
  remoteSync.key_request_url = key_url
  remoteSync.remote_send_url = send_url
  remoteSync.addMsgXMLHeader
  remoteSync.scanFeeds
  response_serv = remoteSync.sendFeedItemData
  puts response_serv
end

def action_archive()
  sqlMapper = load_ibatis_sqlmap
  remoteSync = Aggregate::AgentBotlistArchive.new
  remoteSync.sqlMapper = sqlMapper
  remoteSync.scanFeeds
  response_serv = remoteSync.sendArchiveData
  puts response_serv
end

def main()
  if (ARGV.size < 3)
    puts USAGE_TEXT
    exit
  end
  opts_tupl = parse_args()
  opts = opts_tupl[0]  
  options = opts_tupl[1]
  begin
    opts.parse!(ARGV)
  rescue Exception => e
    puts e, "", opts
    exit
  end

  puts "INFO: Running bot remote process"
  start_time = Time.now  
  key_url = ARGV[0]
  send_url = ARGV[1]
  # Based on the command-line arguments, determine the correct action.
  agent_action_delegate(options, key_url, send_url)
  end_time = Time.now
  diff_time = end_time - start_time
  printf "processing remote sync in %.5f s\n", diff_time
  puts "INFO: Done"

end # End of Method

main()

# End of script
