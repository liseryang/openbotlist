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
########################################

require 'java'
include Java
require 'rexml/document'
include REXML

require File.join(File.dirname(__FILE__), 'agent_utils')

import com.ibatis.sqlmap.client.SqlMapClient unless defined? SqlMapClient
import com.ibatis.sqlmap.client.SqlMapClientBuilder unless defined? SqlMapClientBuilder
import com.ibatis.common.resources.Resources unless defined? Resources
import org.spirit.bean.impl.BotListSystemAuditLog unless defined? BotListSystemAuditLog

import java.sql.DriverManager

module Aggregate

  class AgentBotlistArchive
    
    attr_accessor :sqlMapper
    
    def initialize()		
      @sqlMapper = nil
      @feed_items = nil     
    end

    def scanFeeds()
      # Scan existing feed items and then archive them.
      # Save to the sqlite tmp database and remote to S3.
      java.lang.Class.forName("org.sqlite.JDBC")
      conn = DriverManager.getConnection("jdbc:sqlite:./rspec_test_movies1.db")
      stat = conn.createStatement
      begin 
        #rs = stat.executeUpdate("drop table feed_items if exists;")
        res = stat.executeUpdate("create table feed_items(main_url);")
      rescue Exception => e
        puts "ERR: Error creating archive table set, exiting"
        puts e
      end                   
      # Scan the feed items and buil
      feedItems = @sqlMapper.queryForList("selectFeedItems")
      feedItems.each { |item|			
        AgentUtils::urlItemCleanup(item)
        if AgentUtils::verifyItem(item)
          # S3 Archive the data
          res = stat.executeUpdate("insert into feed_items(main_url) values('#{item.mainUrl}');")
          puts item
        end
      }
      @feed_items = feedItems
      conn.close
    end
    
    def sendArchiveData()
      # Update the audit table to inform that the remote sync has completed
      log = BotListSystemAuditLog.new
      log.applicationName = "client_agent_archive"
      log.message = "archive client res=[bad]"
      log.logLevel = "INFO"
      log.messageId = "000052"
      log.sendTo = "botlist@botlist.com"
      begin
        res = sqlMapper.update("insertAuditLog", log)			
      rescue Exception => e1
        puts e1
      end
      return "pass"
    end # End of method

  end # End of Class

end # End of Module

# End of script
