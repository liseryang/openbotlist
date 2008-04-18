##
## Berlin Brown
## 11/4/2006
##
## create_listing.rb
##

require 'java'
include Java

import org.spirit.form.ext.BotListMapEntityLink unless defined? BotListMapEntityLink

BotListPostListingForm = org.spirit.form.BotListPostListingForm unless defined? BotListPostListingForm
BotListPostListing = org.spirit.bean.impl.BotListPostListing unless defined? BotListPostListing
BotListCityListing = org.spirit.bean.impl.BotListCityListing unless defined? BotListCityListing
BotListSessionManager = org.spirit.util.BotListSessionManager unless defined? BotListSessionManager

Log = org.apache.commons.logging.Log unless defined? Log
LogFactory = org.apache.commons.logging.LogFactory unless defined? LogFactory

class ViewListingControllerRSS		
  def initialize(controller)
    @controller = controller
    @daohelper = @controller.entityLinksDao
  end    
   
  # Generate the view
  def getModel(request)
    
    # Audit the request
    @controller.auditLogPage(request, "botverse_rss.html")
        
    query = "from org.spirit.bean.impl.BotListEntityLinks as links order by links.id desc"
    postListings = @daohelper.pageEntityLinks(query, 0, 24)
    map = BotListMapEntityLink.new
    map['listings'] = postListings
    return map
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

