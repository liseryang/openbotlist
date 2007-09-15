##
## Berlin Brown
## 04/07/2007
##
## '../../WEB-INF/lib/ruby/web', 'web_core'
##

require 'java'

include_class 'org.spirit.util.BotListConsts' unless defined? BotListConsts
include_class 'org.spirit.util.BotListSessionManager' unless defined? BotListSessionManager
include_class 'org.spirit.util.text.KeywordProcessor' unless defined? KeywordProcessor
include_class 'org.spirit.util.BotListCookieManager' unless defined? BotListCookieManager

module BotListWebCore
  
  # Bot IDENTIFY
  BOT_IDENTIFY_ROVER = "botrover99"
  
  # Request parameters ( use BotListWebCore::REQUEST_X to get value )
  # Ruby and System Constants
  REQUEST_GET_CUR_ACTION = "curaction"
  REQUEST_GET_ACTION_ID = "actionid"
  REQUEST_GET_VIEW_ID = "viewid"

  # Cookie manager values
  COOKIE_USERNAME = "botlist_username"
  COOKIE_EMAIL = "botlist_email"
  
  # Session remote sync keys
  SESSION_REMOTE_SYNC_KEY = "session.remote_sync.key"

  # Get a request parameter, also check if the 
  # value is stored in session.
  def BotListWebCore.safeGetParameter(request, requestParam)
    if !request.nil?
      r_val = request.getParameter(requestParam)
      newval = KeywordProcessor::filterAlphaNumeric(r_val)
      return newval
    end
  end
  
  # Check if the user is logged in, using the cookie manager
  def BotListWebCore.userLoggedIn?(request)
    if !request.nil?
        userInfo = BotListContractManager::getUserInfo(request)
        if !userInfo.nil?
            return true
        end
    end
    return false
  end
  
  # Check for empty value from form members
  def BotListWebCore.valueEmpty?(member_value)
    res = (not (!member_value.nil? and !member_value.empty?))
    return res
  end
  
  # Ruby oriented cookie manager class for handling file persistent
  # cookies.
  class WebCookieManager    
    attr_accessor :username, :email
    def initialize(request)
      @username = nil
      @email = nil
      @login_status = nil
      self.loadDefaultValues(request)
    end
    
    # Load the core cookie values, eg: username
    def loadDefaultValues(request)
      cookieUsername = BotListCookieManager::getCookieParam(request, COOKIE_USERNAME)
      @username = cookieUsername if !cookieUsername.nil? and !cookieUsername.empty?

      cookieEmail = BotListCookieManager::getCookieParam(request, COOKIE_EMAIL)
      @email = cookieEmail if !cookieEmail.nil? and !cookieEmail.empty?
    end
    
    # If cookie is not set, persist the cookie.
    # If a cookie username exists and is different from the form object
    # reset the cookie.
    # (note: will update form object if cookie value available)
    # Return the username.
    def getCreateUsername(form, response)
      formUsername = form.fullName || ''
      if formUsername.empty?
        form.fullName = @username
      elsif @username != formUsername
        BotListCookieManager::setCookieParam(response, COOKIE_USERNAME, formUsername) if response
        @username = formUsername
      end
      @username
    end

    def getCreateEmail(form, response)
      formEmail = form.email || ''
      if formEmail.empty?
        form.email = @email
      elsif @email != formEmail
        BotListCookieManager::setCookieParam(response, COOKIE_EMAIL, formEmail) if response
        @email = formEmail
      end
      @email
    end

    # End of Class
  end

  # End of Module
end

