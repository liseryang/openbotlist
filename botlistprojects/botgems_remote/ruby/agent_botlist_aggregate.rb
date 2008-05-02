########################################
# Berlin Brown
# jruby - agent_botlist_aggregate
# Aggregate a collection of RSS links
#
# Updated 2/10/2008 for new RDF remote process
#
# "In computer science, an intelligent agent (IA) is a software agent 
# that assists users and will act on their behalf, 
# in performing non-repetitive computer-related task, 
# in the sense of a "representative agent", 
# like an insurance agent or travel agent." -- wikipedia article [1]
#
# [1] http://en.wikipedia.org/wiki/Intelligent_agent#Intelligent_agents_in_computer_science
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

require 'java'
include Java
require 'rexml/document'
include REXML

require File.join(File.dirname(__FILE__), 'agent_utils')

import java.net.HttpURLConnection unless defined? HttpURLConnection
import com.ibatis.sqlmap.client.SqlMapClient unless defined? SqlMapClient
import com.ibatis.sqlmap.client.SqlMapClientBuilder unless defined? SqlMapClientBuilder
import com.ibatis.common.resources.Resources unless defined? Resources

import org.spirit.loadtest.LoadTestManager unless defined? LoadTestManager
import org.spirit.bean.impl.BotListSystemAuditLog unless defined? BotListSystemAuditLog

module Aggregate

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
      @payload_content = AgentUtils::DEFAULT_RDF_MSG     
    end
    
    def load_payload_doc()
      @payload_doc = Document.new(@payload_content)
    end
    
    def addMsgXMLHeader()
      # Add the initial header
      bot_id_e = Element.new("botid")
      msg_e = Element.new("message")
      status_e = Element.new("status")      
      bot_id_e.text = AgentUtils::BOT_AGENT_NAME
      msg_e.text = AgentUtils::CANNED_BOT_MSGS[rand(AgentUtils::CANNED_BOT_MSGS.size)]
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
      # Scan the feed items and build the remote payload
      feedItems = @sqlMapper.queryForList("selectAllFeedItems")
      buf = ""
      payload_elem = Element.new("typespayload")
      feedItems.each { |item|			
        AgentUtils::urlItemCleanup(item)
        if AgentUtils::verifyItem(item)
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
