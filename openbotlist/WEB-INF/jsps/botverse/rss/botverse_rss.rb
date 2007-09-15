##
## Berlin Brown
## 11/4/2006
##
## create_listing.rb
##

include_class 'org.spirit.form.BotListPostListingForm' unless defined? BotListPostListingForm
include_class 'org.spirit.bean.impl.BotListPostListing' unless defined? BotListPostListing
include_class 'org.spirit.bean.impl.BotListCityListing' unless defined? BotListCityListing
include_class 'org.spirit.util.BotListSessionManager' unless defined? BotListSessionManager

include_class 'org.apache.commons.logging.Log' unless defined? Log
include_class 'org.apache.commons.logging.LogFactory' unless defined? LogFactory

class ViewListingControllerRSS
		
  def initialize(controller)
    @controller = controller
    @daohelper = @controller.entityLinksDao
  end    
  
  #
  # Generate the view
  def getModel(request)
    
    # Audit the request
    @controller.auditLogPage(request, "botverse_rss.html")
        
    query = "from org.spirit.bean.impl.BotListEntityLinks as links order by links.createdOn desc"
    postListings = @daohelper.pageEntityLinks(query, 0, 24)
    return {
      'listings' => postListings
    }

  end
  
  #
  # Processed when the form is submitted, 
  # see the controller 'processFormSubmission()' method
  def onSubmit(request, response, form, errors)      
    return form
  end
end

ViewListingControllerRSS.new($controller)

## End of Script ##

