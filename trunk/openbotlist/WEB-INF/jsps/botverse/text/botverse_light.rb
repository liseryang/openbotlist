##
## Berlin Brown
## 11/4/2006
##
## create_listing.rb
##

class ViewLightController
		
  def initialize(controller)
    @controller = controller
    @daohelper = @controller.entityLinksDao
  end    
  
  def getModel(request)
    
    # Audit the request
    @controller.auditLogPage(request, "botverse_light.html")        
    query = "from org.spirit.bean.impl.BotListEntityLinks as links order by links.id desc"
    links = @daohelper.pageEntityLinks(query, 0, 40)
    return {
      'listings' => links
    }

  end
   
  # Processed when the form is submitted, 
  # see the controller 'processFormSubmission()' method
  def onSubmit(request, response, form, errors)      
    return form
  end
end

ViewLightController.new($controller)

## End of Script ##

