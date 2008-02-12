#
# Berlin Brown
# jruby - bot_remote_sync
# (deprecated approach for remoting)

require 'java'
include_class 'java.net.HttpURLConnection' unless defined? HttpURLConnection
include_class 'com.ibatis.sqlmap.client.SqlMapClient' unless defined? SqlMapClient
include_class 'com.ibatis.sqlmap.client.SqlMapClientBuilder' unless defined? SqlMapClientBuilder
include_class 'com.ibatis.common.resources.Resources' unless defined? Resources

include_class 'org.spirit.loadtest.LoadTestManager' unless defined? LoadTestManager

include_class 'org.spirit.bean.impl.BotListSystemAuditLog' unless defined? BotListSystemAuditLog

MAX_LEN_FIELD = 120

class RemoteSync
	attr_accessor :key_request_url, :remote_send_url, :sqlMapper
    def initialize()		
		@key_request_url = nil
		@remote_send_url = nil
		@send_data = nil
		@sqlMapper = nil
		@feed_items = nil
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
    
    def scanFeeds()
		feedItems = @sqlMapper.queryForList("selectAllFeedItems")
		buf = ""
		feedItems.each { |item|			
			urlItemCleanup(item)
			if verifyItem(item)
				formatted_data = "#{item.mainUrl},#{item.urlTitle},#{item.urlTitle}"
				buf << formatted_data << "\n"
			end
		}		
		# End of the method
		@send_data = buf
		@feed_items = feedItems
    end
    
    def sendFeedItemData()
		#
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
			"developerKey" => "none",
			"remoteData" => @send_data,
			"remoteSyncKey" => requestKey
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
			log.message = "remote sync client res=[#{serv_response}]"
			log.logLevel = "INFO"
			log.messageId = "000051"
			log.sendTo = "botlist@botlist.com"
			begin
				res = sqlMapper.update("insertAuditLog", log)			
			rescue Exception => e1
				puts e1
			end
			
		rescue Exception => e
			puts e
		end
		# End of method
    end
    
end

def connect(key_url, send_url)
	puts "INFO: keyurl=#{key_url}"
	puts "INFO: syncurl=#{send_url}"
	reader = Resources.getResourceAsReader("conf/SqlMapConfig.xml")
	sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader)
	reader.close()
		
	remoteSync = RemoteSync.new
	remoteSync.sqlMapper = sqlMapper
	remoteSync.key_request_url = key_url
	remoteSync.remote_send_url = send_url
	remoteSync.scanFeeds
	remoteSync.sendFeedItemData
end

def main()
	
	if ARGV.size != 2		
		puts "usage: bot_remote_sync.rb <key url> <post to url>"
		puts "args=#{ARGV}"
		return 
	end
	
	puts "running"
	start_time = Time.now
		
	key_url = ARGV[0]
	send_url = ARGV[1]
	
	connect(key_url, send_url)
	end_time = Time.now
	diff_time = end_time - start_time
	printf "processing remote sync in %.5f s\n", diff_time
	puts "done"	
end

main()

# End of script