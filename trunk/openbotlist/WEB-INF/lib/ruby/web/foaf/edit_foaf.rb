##
## Berlin Brown
## 03/07/2008
##
## edit_foaf.rb
##
## '../../WEB-INF/lib/ruby/web', 'web_core'
##
## Also see:
## [1] http://www.ruby-doc.org/stdlib/libdoc/net/http/rdoc/index.html
##
## This module handles ruby oriented connect to a FOAF url, get the
## XML document, parse it and commit the data to the foaf table.
##

require 'java'
require 'net/http'
require 'uri'
require 'rexml/document'
include REXML

include_class 'java.text.SimpleDateFormat' unless defined? SimpleDateFormat
include_class "java.util.Calendar" unless defined? Calendar
		
include_class 'org.spirit.util.BotListConsts' unless defined? BotListConsts
include_class 'org.spirit.util.BotListSessionManager' unless defined? BotListSessionManager
include_class 'org.spirit.util.text.KeywordProcessor' unless defined? KeywordProcessor
include_class 'org.spirit.util.BotListCookieManager' unless defined? BotListCookieManager

include_class 'org.spirit.bean.impl.BotListCalculatorVerification' unless defined? BotListCalculatorVerification
include_class 'org.spirit.apps.foaf.BotListEntityTypeFoaf' unless defined? BotListEntityTypeFoaf

module BotListFoaf 

  # Set the user agent and make sure to include user and contact information
  USER_AGENT = "Botlist/20080316_0.0 (Ruby en-US), http://www.botnode.com, berlin.brown at gmail.com"
  
  #*************************************
  # BotListEntityTypeFoaf:
  #
  # Table schema for foaf submit
  # (as of 3/14/2008
  # ----------------
  # main_url - E.g. http://danbri.org/foaf.rdf
  # url_title - 
  # url_description - 
  # keywords - ?
  # generated_obj_id 
  # views - Default is zero
  #	rating - Default is zero
  # process_count - Default is zero
  #	nickname - <foaf:nick>danbri</foaf:nick>
  #	foaf_name - <foaf:name>Dan Brickley</foaf:name>
  # foaf_interest_descr - Interest data
  # foaf_mbox - <mbox rdf:resource="mailto:danbri@danbri.org"/>
  # foaf_page_doc_url - <foaf:page> -> <foaf:Document rdf:about="http://berlinbrown.livejournal.com/profile">
  # foaf_img - <foaf:img rdf:resource="http://rdfweb.org/people/danbri/2000/01/01/Image1.gif"/>     	
  # request_time - 
  # http_status_code - 200
  # date_of_birth - <foaf:dateOfBirth>1972-01-09</foaf:dateOfBirth>
  # ----------------
  class FoafDocument    
    # Create a foaf bean type based on the incoming XML document
    def transformFoafType(url, doc)
      foaf = BotListEntityTypeFoaf.new
      foaf.mainUrl = url
      foaf.generatedUniqueId = foaf.getGeneratedUniqueIdAuto
      foaf.foafMbox = ""
      foaf.foafInterestDescr = "programming"
      foaf.dateOfBirth =  Calendar.getInstance.time
      foaf.foafPageDocUrl = foaf.mainUrl
      begin
        doc.elements.each("//foaf:PersonalProfileDocument") { |profile_doc|
          foaf_page_doc_url = profile_doc.attributes['rdf:about']
          foaf.foafPageDocUrl = foaf_page_doc_url
        }
        doc.elements.each("//foaf:nick") { |nick|
          foaf.nickname = nick.text
          foaf.urlTitle = "#{foaf.nickname} at #{foaf.mainUrl}"
          foaf.urlDescription = foaf.urlTitle
          foaf.fullName = "botrover"
        }
        doc.elements.each("//foaf:name") { |name|
          foaf.foafName = name.text
        }
        doc.elements.each("//foaf:img") { |img|
          foaf.foafImg = img.text
        }
        doc.elements.each("//foaf:dateOfBirth") { |date_of_birth|          
        }
      rescue Exception => e
        # Raise error, you can't recover from an invalid URL
        raise e.message
      end
      return foaf
       # end of method
    end
  end

  class FoafHandler
    
    attr_accessor :foaf_type, :last_result    
    def initialize(dao, log, url)
      @dao = dao
      @log = log
      @url = url
      @foaf_thread = nil
      @xml_doc = nil
      @foaf_type = nil
      @last_result = nil
    end

    def getFoafDoc(url_val)
      begin
        url_pars = URI.parse(url_val)
        req = Net::HTTP::Get.new(url_pars.path, { "User-Agent" =>
                                   USER_AGENT})
        res = Net::HTTP.start(url_pars.host, url_pars.port) {|http|
          http.request(req)
        }
        return res.body
      rescue Exception => e
        @log.error(e)
        # Raise error, you can't recover from an invalid URL
        raise e.message
      end

      # end of method
    end

    # Save the foaf type
    def saveFoaf(foaf_type)
      @log.info "saveFoaf(): saving type=#{foaf_type}"
      # Get the bean from the DB as opposed to off the session table
      begin
        sessionFactory = @dao.getSessionFactory()
        hbm_session = sessionFactory.openSession()
        tx = hbm_session.beginTransaction()
        hbm_session.save(foaf_type)
        res = tx.commit()
        @last_result = res
        return res
      rescue Exception => e
        puts "Error - saveFoaf #{e}"
        @log.error "saveFoaf(): error #{e}"
        tx.rollback
        raise e.message
      ensure  
        hbm_session.close()
      end
      # End of the Method
    end

    # Launch the foaf handler thread, request the URL 
    # and then create the foaf record if it is valid.
    def createFoaf()
      @log.info "createFoaf(): Creating foaf #{@url}"
      #abort_on_exception will kill running threads, default = false
      #Thread.abort_on_exception = true
      @foaf_thread = Thread.new(@url) do |url|
        url_content = getFoafDoc(url)
        @xml_doc = Document.new(url_content)
        foaf_doc = FoafDocument.new
        @log.info "createFoaf(): about to transform foaf type"
        begin
          @foaf_type = foaf_doc.transformFoafType(@url, @xml_doc)
        rescue Exception => e
          @log.error e
        end
        res = saveFoaf(@foaf_type)
        @last_result = res
        @log.info "createFoaf(): exiting foaf thread with #{@last_result}"
      end
    end
    # End of Class
  end

  # End of Module
end

