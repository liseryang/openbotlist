########################################
# Berlin Brown
# jruby - agent_botlist_aggregate
# Aggregate a collection of RSS links
#
# Updated 2/10/2008 for new RDF remote process
########################################

require 'java'
require 'rexml/document'
include REXML

include_class 'java.net.HttpURLConnection' unless defined? HttpURLConnection
include_class 'com.ibatis.sqlmap.client.SqlMapClient' unless defined? SqlMapClient
include_class 'com.ibatis.sqlmap.client.SqlMapClientBuilder' unless defined? SqlMapClientBuilder
include_class 'com.ibatis.common.resources.Resources' unless defined? Resources

include_class 'org.spirit.loadtest.LoadTestManager' unless defined? LoadTestManager
include_class 'org.spirit.bean.impl.BotListSystemAuditLog' unless defined? BotListSystemAuditLog

# Botrover99 is a capable agent
BOT_AGENT_NAME = "botrover99"
MAX_LEN_FIELD = 120
DEFAULT_RDF_MSG = <<EOF
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
</rdf:RDF>
EOF

module Aggregate
  
  CANNED_BOT_MSGS = [
                     "I enjoyed the cake.  It was good.",
                     "The cake was a little dry, but I ate it anyway.",
                     "I wish there was more cake around.",
                     "My life as a bot is difficult.",
                     "Do you know Chomsky?",
                     "Do you speak any japanese?",
                     "Work is fun, but baking a cake is even more fun. Mmm.",
                     "Cake and bot work go together.",
                     "I ate too much cake.  Do you have a toothbrush?"
                    ]

  class AgentBotlistRSS
    
    attr_accessor :key_request_url, :remote_send_url, :sqlMapper
    attr_reader :payload_doc
    
    def initialize()		
      @key_request_url = nil
      @remote_send_url = nil
      @send_data = nil
      @sqlMapper = nil
      @feed_items = nil
      
      # Init the payload message XML document
      @payload_doc = nil
      @payload_content = DEFAULT_RDF_MSG     
    end
    
    def load_payload_doc()
      @payload_doc = Document.new(@payload_content)
    end
    def shortenField(str_val)
      str = str_val[0, MAX_LEN_FIELD] if str_val.length > MAX_LEN_FIELD
      return str if !str.nil?
      return str_val
    end    
    def urlItemCleanup(item)
      return if item.nil?		
      # Cleanup url
      if !item.urlTitle.nil?
        item.urlTitle.gsub!("\,", "")
        item.urlTitle.gsub!(/\r\n?/, "")			
        item.urlTitle.strip!
        item.urlTitle = shortenField(item.urlTitle)
      end
      # Cleanup URL with encoded value
      item.mainUrl.gsub!("\,", "%2C") if !item.mainUrl.nil?
    end
    def verifyItem(item)
      return false if item.nil?		
      return false if item.urlTitle.nil? or item.urlTitle.strip.empty?
      return false if item.mainUrl.nil? or item.mainUrl.strip.empty?		
      # Valid item, allow
      return true
    end
    
    def addMsgXMLHeader()
      # Add the initial header
      bot_id_e = Element.new("botid")
      msg_e = Element.new("message")
      status_e = Element.new("status")
      
      bot_id_e.text = BOT_AGENT_NAME
      msg_e.text = @canned_bot_msgs[rand(@canned_bot_msgs.size)]
      status_e.text = "200"
      
      agent_msg = Element.new("agentmsg")
      agent_msg << bot_id_e
      agent_msg << msg_e
      agent_msg << status_e
      
      root = @payload_doc.root
      root << agent_msg
    end
    
    def createMsgTypeElem(item)
      # Take a feed item, convert to a XML eleent and 
      # add to the existing XML document.
      type_elem = Element.new("type")
      url_elem = Element.new("url")
      title_elem = Element.new("title")
      keywords_elem = Element.new("keywords")
      descr_elem = Element.new("descr")

      # Marshall the item content
      url_elem.text = item.mainUrl
      title_elem.text = item.urlTitle    
      keywords_elem.text = item.urlTitle
      descr_cdata = CData.new(item.urlDescription)
      # Add the description cdata content
      descr_elem << descr_cdata

      type_elem << url_elem
      type_elem << title_elem
      type_elem << keywords_elem
      type_elem << descr_elem
      return type_elem
    end

    def scanFeeds()
      # Scan the feed items and buil
      feedItems = @sqlMapper.queryForList("selectAllFeedItems")
      buf = ""
      payload_elem = Element.new("typespayload")
      feedItems.each { |item|			
        urlItemCleanup(item)
        if verifyItem(item)
          elem = createMsgTypeElem(item)
          formatted_data = "#{item.mainUrl},#{item.urlTitle},#{item.urlTitle}"
          buf << formatted_data << "\n"
          # Also, append to the payload
          payload_elem << elem
        end
      }
      # End of the method
      @send_data = buf
      @feed_items = feedItems
      # Append the payload data to the agent msg
      @payload_doc.elements.each("//agentmsg") { |msg|
        msg << payload_elem
      }
    end
    
    def sendFeedItemData()      
      # Connect for example: "http://localhost:8080/botlist/spring/pipes/remotesync.html"
      # And then post to http://localhost:8080/botlist/spring/pipes/remotesync_send.html
      connect_res = LoadTestManager.connectURL(@key_request_url, false)
      requestKey = connect_res[1]
            
      if @send_data.empty?
        puts "INFO: there are no feed items to send"
        return nil
      end	
      # Submit key and other link data
      reqestMap = {
        "types_payload" => "#{@payload_doc}"
      }      
      begin
        str_url = @remote_send_url
        url = LoadTestManager.getSSLURL(str_url)
        HttpURLConnection.setFollowRedirects(false)
        conn = url.openConnection()	
        post_res = LoadTestManager.postDataSSL(reqestMap, conn, url, str_url, false, true)

        # Update that we sent the content
        # Very optmistic case, update all records regardless if they were actual saved
        @feed_items.each { |item|
          begin
            res = sqlMapper.update("updateFeedItem", item)
          rescue Exception => e1
            puts e1
          end
        }			
        # Update the audit table to inform that the remote sync has completed
        serv_response = post_res[1]
        log = BotListSystemAuditLog.new
        log.applicationName = "client_remote_sync"
        log.message = "remote sync client res=[bad]"
        log.logLevel = "INFO"
        log.messageId = "000051"
        log.sendTo = "botlist@botlist.com"
        begin
          res = sqlMapper.update("insertAuditLog", log)			
        rescue Exception => e1
          puts e1
        end
        return serv_response
      rescue Exception => e
        puts e
        return "ERR"
      end
      return "ERR"
    end # End of method

  end # End of Class

end # End of Module

# End of script