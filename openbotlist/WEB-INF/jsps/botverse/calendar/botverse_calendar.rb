##
## Berlin Brown
## 11/4/2006
##
## create_listing.rb
##

include_class 'org.spirit.form.BotListPostListingForm' unless defined? BotListPostListingForm
include_class 'org.spirit.form.BotListGenericPagingForm' unless defined? BotListGenericPagingForm
include_class 'org.spirit.bean.impl.BotListPostListing' unless defined? BotListPostListing
include_class 'org.spirit.bean.impl.BotListCityListing' unless defined? BotListCityListing

include_class 'org.spirit.util.BotListSessionManager' unless defined? BotListSessionManager
include_class 'org.spirit.util.BotListCookieManager' unless defined? BotListCookieManager
include_class 'org.spirit.util.BotListConsts' unless defined? BotListConsts
include_class 'org.spirit.contract.BotListContractManager' unless defined? BotListContractManager
 
include_class 'org.apache.commons.logging.Log' unless defined? Log
include_class 'org.apache.commons.logging.LogFactory' unless defined? LogFactory

include_class('java.util.Calendar') { 'JCalendar' } unless defined? JCalendar

class ViewListingController
		
  def initialize(controller)
    @controller = controller
    @daohelper = @controller.entityLinksDao
  end    

  # get page offset
  def getPageOffset(request)
    page = request.getParameter("offsetpage")
    if page != nil
      return page.to_i()
    end
  end
  
  # Generate the view
  def getModel(request)
    
    mostrecent_mode = false
    filterset = request.getParameter("filterset")
    nextPage = getPageOffset(request)
    if not nextPage
      nextPage = 0
    end
    
    if filterset == "mostrecent"
      mostrecent_mode = true
    end

    # Audit the request
    @controller.auditLogPage(request, "botverse_calendar.html")

    # For the calendar view, get stats for the last 7 days
    i = -6
    statMap = {}
    statMapDates = {}
    while i <= 0
      curCal = JCalendar::getInstance()
      curCal.add(JCalendar::DATE, i)      
      linksOnDate = @daohelper.readListingOnDate(curCal)      
      strId = "stats#{i + 6}"
      statMap[strId] = linksOnDate
      statMapDates[strId] = curCal
      i += 1
    end
    
    userInfo = BotListContractManager::getUserInfo(request)
    return {
      'userInfo' => userInfo,
      'linksOnDates' => statMap,
      'linksDates' => statMapDates,
      'filterset' => filterset
    }
  end
  
  #
  # Processed when the form is submitted, 
  # see the controller 'processFormSubmission()' method
  def onSubmit(request, response, form, errors)      
    return form
  end
end

ViewListingController.new($controller)

## End of Script ##

