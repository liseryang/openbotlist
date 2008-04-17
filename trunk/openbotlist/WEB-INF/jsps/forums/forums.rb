##
## Berlin Brown
## 11/4/2006
##

require 'java'
include Java

import org.spirit.form.ext.BotListMapEntityLink unless defined? BotListMapEntityLink


BotListSessionManager = org.spirit.util.BotListSessionManager
BotListContractManager = org.spirit.contract.BotListContractManager

class ListingsController
		
  def initialize(controller)
    @controller = controller
    @daohelper = @controller.forumGroupDao
    @dao_entitylinks = @controller.entityLinksDao
  end    
  
  def getModel(request)
           
    query = "from org.spirit.bean.impl.BotListForumGroup as forums"
    forumListings = @daohelper.listForums(query)    
    forumCountMap = {}
    forumListings.each do |n|
      commentsCount = @dao_entitylinks.getLinkCommentCountByForum(n.get_id)
      fname = n.forumName
      forumCountMap[fname] = commentsCount
    end

    # Audit the request
    @controller.auditLogPage(request, "forums.html")   
    userInfo = BotListContractManager::getUserInfo(request)
    map = BotListMapEntityLink.new
    map['listings'] = forumListings
    map['userInfo'] = userInfo
    map['forumCountMap'] = forumCountMap
    return map
  end
  
  def onSubmit(request, response, form, errors)
    return form
  end
end

ListingsController.new($controller)

## End of Script ##

