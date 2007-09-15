##
## Berlin Brown
## 11/4/2006
##
## create_listing.rb
##

include_class 'org.spirit.util.BotListSessionManager' unless defined? BotListSessionManager
include_class 'org.spirit.util.BotListCookieManager' unless defined? BotListCookieManager
include_class 'org.spirit.contract.BotListContractManager' unless defined? BotListContractManager
include_class 'org.spirit.util.text.KeywordProcessor' unless defined? KeywordProcessor

class SectionController
		
  def initialize(controller)
    @controller = controller
    @daohelper = @controller.cityListingDao
    @daohelpersects = @controller.postSectionsDao
  end    
  
  def getModel(request)
  
    viewid = request.getParameter("city")
    if !viewid.nil? 
      newviewid = KeywordProcessor.filterAlphaNumeric(viewid)
    end
    return nil if newviewid.nil?
         
    # Audit the request
    @controller.auditLogPage(request, "sections.html")
    citybean = @daohelper.readCityListing(newviewid.to_i())  

    # 
    # Save the session parameter
    cur_session = request.getSession(false)
    if (cur_session == nil)
      cur_session = request.getSession()
    end
    
    cur_session.setAttribute(BotListSessionManager::CURRENT_CITY_SETTING, citybean)
   
    # Query the sections
    sections = @daohelpersects.listSections("from org.spirit.bean.impl.BotListPostSections", citybean)

    userInfo = BotListContractManager::getUserInfo(request)
    return {
      'city' => citybean,
      'sections' => sections,
      'userInfo' => userInfo
    }
  end
   
  def onSubmit(request, response, form, errors)
    return form
  end
end

SectionController.new($controller)

## End of Script ##

