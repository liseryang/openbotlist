##
## Berlin Brown
## 08/07/2007
##
## entity_links.rb

require 'java'
require File.join(File.dirname(__FILE__), 'web_core') unless defined? BotListWebCore

include_class 'org.spirit.util.BotListConsts' unless defined? BotListConsts
include_class 'org.spirit.util.BotListSessionManager' unless defined? BotListSessionManager
include_class 'org.spirit.util.text.KeywordProcessor' unless defined? KeywordProcessor
include_class 'org.spirit.util.BotListCookieManager' unless defined? BotListCookieManager

include_class 'org.spirit.bean.impl.BotListEntityLinks' unless defined? BotListEntityLinks

module BotListLinksManager
  
  # Ruby oriented entity link manager for a collection of entity links.
  # see remotesync_send for more information.
  class EntityLinkGroup
    attr_accessor :remote_content, :line_data, :daohelper
    def initialize()
		# Remote content contains the string data from the remote client
		@remote_content = nil
		
		# The line by line data stored as a list
		@line_data = nil
		
		# Post processed data
		@formatted_data = nil
		@daohelper = nil
		
		# MIN length for url titles (if less than threshold, ignore)
		@MIN_TITLE_LEN = 3
    end
    
	def transformFormData(data_elem)
		mainUrl = data_elem[0]
		urlTitle = data_elem[1]	
		keywords = data_elem[2]
		
		listing = BotListEntityLinks.new		
		if BotListWebCore.valueEmpty?(urlTitle)
			return nil		
		end
		# Filter the title of non-ascii characters (TODO)
		listing.urlTitle = KeywordProcessor::filterNonAscii(urlTitle)
		listing.rating = 0
		listing.fullName = BotListWebCore::BOT_IDENTIFY_ROVER		
		
		# Check min length
		if !listing.urlTitle.nil? and listing.urlTitle.length <= @MIN_TITLE_LEN
			# Invalid entity
			return nil
		end
							
		if BotListWebCore.valueEmpty?(mainUrl)					
			return nil
		else
			listing.mainUrl = mainUrl
		end
		if keywords
			keywords = KeywordProcessor::createKeywords(keywords)
			listing.keywords = keywords
		end
	    return listing
	end
    
    # Commit the set of remote group links
    def createGroupLinks()
		commit_passed = 0
		begin
			sessionFactory = @daohelper.getSessionFactory()
			hbm_session = sessionFactory.openSession()			
			tx = hbm_session.beginTransaction()
			
			# Iterate over the formatted data elements and create record
			@formatted_data.each { |data_elem|				
				begin					
					linkObj = transformFormData(data_elem)
					if !linkObj.nil?						
						hbm_session.save(linkObj)
						commit_passed = commit_passed + 1						
					else												
						raise "Invalid link object (null or invalid url/title)"
						# End of if - valid link obj
					end				
				rescue Exception => e
					# On error, make sure to clear the session
					hbm_session.clear()
					
					#TODO: for the time being, ignore invalid url errors
					#puts e
				end
			}			
		rescue Exception => e2			
			puts e2
		ensure
			tx.commit()
			#tx.rollback()
			hbm_session.close() if !hbm_session.nil?
		end
		# End of method
		return commit_passed
    end
    
    def parse()
		@line_data = []
		@remote_content.each_line { |line|
			@line_data << line.strip		
		}
		# Parse the lined data to get a tuple [url, title, keywords]		
		@formatted_data = []		
		@line_data.each { |line|
			begin
				# Comma delimited
				url, title, keywords = line.chomp.split(/\s*\,\s*/)
				data_tuple = []				
				data_tuple[0] = url
				data_tuple[1] = title
				data_tuple[2] = keywords
				@formatted_data << data_tuple
			rescue
				puts "ERR(entity_links): invalid line format"
			end
		}
    end
    
    # End of Class
  end

  # End of Module
end

