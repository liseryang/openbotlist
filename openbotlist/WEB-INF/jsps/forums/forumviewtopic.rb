##
## Berlin Brown
## 11/4/2006
##

include_class 'org.spirit.util.BotListSessionManager'
include_class 'org.spirit.contract.BotListContractManager'

class ViewCommentsController
		
  def initialize(controller)
    @controller = controller
    @daohelper = @controller.userCommentsDao
  end    
  
  # Get a view instance of the link the user clicked on
  def getViewLink(request)
    viewid = request.getParameter("viewid")
    if !viewid.nil? 
      newviewid = KeywordProcessor.filterAlphaNumeric(viewid)
    end
    return nil if newviewid.nil?
    newviewid.to_i()
  end

  def getModel(request)
    
    commentId = getViewLink(request)
    comment = @daohelper.readComment(commentId)
    userInfo = BotListContractManager::getUserInfo(request)
    return {
      'listing' => comment,
      'userInfo' => userInfo
    }
  end
   
  def onSubmit(request, response, form, errors)
    return form
  end
end

ViewCommentsController.new($controller)

## End of Script ##

