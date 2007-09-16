##
## Berlin Brown
## 11/4/2006
##

include_class 'org.spirit.util.BotListSessionManager' unless defined? BotListSessionManager
include_class 'org.spirit.contract.BotListContractManager' unless defined? BotListContractManager
include_class 'org.spirit.spring.validate.BotListGenericValidator' unless defined? BotListGenericValidator

include_class 'org.apache.commons.logging.Log' unless defined? Log
include_class 'org.apache.commons.logging.LogFactory' unless defined? LogFactory

class ViewCommentsController
		
  def initialize(controller)
    @controller = controller
    @daohelper = @controller.userCommentsDao
    @daohelper_links = @controller.entityLinksDao
    @log = LogFactory::getLog("org.jruby")
  end    
  
  def nonLazyLoadLinks(comments)
    for comment in comments
      begin
        link = @daohelper_links.readLinkListing(comment.linkId)
        if !link.nil?
          comment.entityLink = link
        end
      rescue Exception => ex
        err_str = "Invalid non lazy load of comment entity links"
        puts err_str
        @log.error(err_str)  
      end
      
      # End of the for
    end
  end
  
  def getModel(request)        
    query = "from org.spirit.bean.impl.BotListUserComments as comments where comments.linkId is NOT NULL order by comments.id desc"
    comments = @daohelper.listLinkComments(query, 40)
    nonLazyLoadLinks(comments)
    userInfo = BotListContractManager::getUserInfo(request)
    
    # Audit the request
    @controller.auditLogPage(request, "comments/topics.html")      
    return {
      'listings' => comments,
      'userInfo' => userInfo
    }
  end
   
  def onSubmit(request, response, form, errors)
    @log.error("invalid request through submit form=topics")
    @controller.setValidator(BotListGenericValidator.new)
    return form
  end
end

ViewCommentsController.new($controller)
## End of Script ##