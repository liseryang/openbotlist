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
  # Generate the view
  def getModel(request)  
    return {}
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

