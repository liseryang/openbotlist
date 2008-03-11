##################################################
### Notice Update: 8/14/2007
### Copyright 2007 Berlin Brown
### Copyright 2006-2007 Newspiritcompany.com
### 
### This SOURCE FILE is licensed to NEWSPIRITCOMPANY.COM.  Unless
### otherwise stated, use or distribution of this program 
### for commercial purpose is prohibited.
### 
### See LICENSE.BOTLIST for more information.
###
### The SOFTWARE PRODUCT and CODE are protected by copyright and 
### other intellectual property laws and treaties. 
###  
### Unless required by applicable law or agreed to in writing, software
### distributed  under the  License is distributed on an "AS IS" BASIS,
### WITHOUT  WARRANTIES OR CONDITIONS  OF ANY KIND, either  express  or
### implied.
##################################################

### Created: 3/10/2008
### foaf.rb

include_class 'org.spirit.form.BotListPostListingForm' unless defined? BotListPostListingForm
include_class 'org.spirit.form.BotListGenericPagingForm' unless defined? BotListGenericPagingForm
include_class 'org.spirit.bean.impl.BotListPostListing' unless defined? BotListPostListing
include_class 'org.spirit.bean.impl.BotListCityListing' unless defined? BotListCityListing

include_class 'org.spirit.contract.BotListContractManager' unless defined? BotListContractManager
include_class 'org.spirit.util.BotListSessionManager' unless defined? BotListSessionManager
include_class 'org.spirit.util.BotListCookieManager' unless defined? BotListCookieManager
include_class 'org.spirit.util.BotListConsts' unless defined? BotListConsts
include_class 'org.spirit.util.text.KeywordProcessor' unless defined? KeywordProcessor
include_class 'org.spirit.spring.validate.BotListGenericValidator' unless defined? BotListGenericValidator

include_class 'org.spirit.form.ext.BotListMapEntityLink' unless defined? BotListMapEntityLink

include_class 'org.apache.commons.logging.Log' unless defined? Log
include_class 'org.apache.commons.logging.LogFactory' unless defined? LogFactory
include_class('java.util.Calendar') { 'JCalendar' } unless defined? JCalendar

class BotverseController
		
  def initialize(controller)
    @controller = controller
    @daohelper = @controller.entityLinksDao
    @dao_banner = @controller.adminMainBannerDao
    @dao_settings = @controller.coreSettings
    @dao_active_feeds = @controller.activeMediaFeedsDao
  end
  
  # Generate the view
  def getModel(request)

    # Audit the request
    @controller.auditLogPage(request, "foaf.html")
        
    # Extract the banner headline to display
    banner = @dao_banner.readBanner('botverse')
    
    # Set the default generic validator    
    @controller.setValidator(BotListGenericValidator.new)
        
    userInfo = BotListContractManager::getUserInfo(request)
    map = BotListMapEntityLink.new    
    map['headline'] = banner.headline if !banner.nil?
    map['userInfo'] = userInfo
    return map
  end    
  def onSubmit(request, response, form, errors)
    return form
  end 
end

BotverseController.new($controller)

## End of Script ##

