##
## Berlin Brown
## 11/4/2006
##
## create_listing.rb
##

class PipeControllerText
		
  def initialize(controller)
    @controller = controller
    @daohelper = @controller.entityLinksDao
  end    
  
  #
  # Generate the view
  def getModel(request)
    
    @controller.auditLogPage(request, "botverse_pipes.html")
        
    query = "from org.spirit.bean.impl.BotListEntityLinks as links order by links.createdOn desc"
    postListings = @daohelper.pageEntityLinks(query, 0, 40)
    return {
      'listings' => postListings
    }

  end
    
  # Processed when the form is submitted, 
  # see the controller 'processFormSubmission()' method
  def onSubmit(request, response, form, errors)      
    return form
  end
end

PipeControllerText.new($controller)

## End of Script ##

