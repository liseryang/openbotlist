##
## Berlin Brown
## 11/4/2006
## botverse.rb
## botverse - view link listings
##

include_class 'org.spirit.form.BotListPostListingForm' unless defined? BotListPostListingForm
include_class 'org.spirit.form.BotListGenericPagingForm' unless defined? BotListGenericPagingForm
include_class 'org.spirit.bean.impl.BotListPostListing' unless defined? BotListPostListing
include_class 'org.spirit.bean.impl.BotListCityListing' unless defined? BotListCityListing

include_class 'org.spirit.contract.BotListContractManager' unless defined? BotListContractManager
include_class 'org.spirit.util.BotListSessionManager' unless defined? BotListSessionManager
include_class 'org.spirit.util.BotListCookieManager' unless defined? BotListCookieManager
include_class 'org.spirit.util.BotListConsts' unless defined? BotListConsts
include_class 'org.spirit.util.text.KeywordProcessor' unless defined? KeywordProcessor
include_class 'org.spirit.spring.validate.BotListGenericValidator' unless defined? BotListGenericValidator

include_class 'org.spirit.form.ext.BotListMapEntityLink' unless defined? BotListMapEntityLink

include_class 'org.apache.commons.logging.Log' unless defined? Log
include_class 'org.apache.commons.logging.LogFactory' unless defined? LogFactory

class BotverseController
		
  def initialize(controller)
    @controller = controller
    @daohelper = @controller.entityLinksDao
    @dao_banner = @controller.adminMainBannerDao
    @dao_settings = @controller.coreSettings
    @dao_active_feeds = @controller.activeMediaFeedsDao
  end    

  # get page offset
  def getPageOffset(request)
    page = request.getParameter("offsetpage")
    if !page.nil?
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
    @controller.auditLogPage(request, "botverse.html")
    
    # Safe session create, botverse is a core application,
    # Create the session if not available
    BotListSessionManager.safeCreateSession(request)
    
    if mostrecent_mode
      query = "from org.spirit.bean.impl.BotListEntityLinks as links order by links.id desc"
    else
      query = "from org.spirit.bean.impl.BotListEntityLinks as links order by links.rating desc, links.id desc, links.views desc"
    end
    
    # Override any existing query for keytag search
    if filterset == "defkeytag"
       defkeytagid = request.getParameter("defkeytagid")
       defkeyfilter = KeywordProcessor.filterAlphaText(defkeytagid);
       query = "from org.spirit.bean.impl.BotListEntityLinks as links where links.keywords like '%#{defkeyfilter}%' order by links.createdOn desc"
    end
    postListings = @daohelper.pageEntityLinks(query, nextPage, BotListConsts::MAX_RESULTS_PAGE)    

    # Total count of links
    totalLinks = @daohelper.linkCount    
    totalPages = totalLinks / BotListConsts::MAX_RESULTS_PAGE
    pagingForm = BotListGenericPagingForm.new
    pagingForm.curPage = nextPage
    pagingForm.pageOffset = (nextPage * BotListConsts::MAX_RESULTS_PAGE)
    pagingForm.begin = nextPage - 1
    if pagingForm.begin < 0
      pagingForm.begin = 0
    end
    pagingForm.end = pagingForm.begin + 4
    if not filterset
      filterset = ""
    end
    
    # Extract the banner headline to display
    banner = @dao_banner.readBanner('botverse')
    
    # Set the default generic validator    
    @controller.setValidator(BotListGenericValidator.new)
    
    # Determine if media is enabled, also collect list
    mediaEnabled = @dao_settings.mediaEnabled
    mediaList = nil
    mediaList = @dao_active_feeds.readActiveMediaList('B', 3) if mediaEnabled
    
    userInfo = BotListContractManager::getUserInfo(request)
    map = BotListMapEntityLink.new    
    map['headline'] = banner.headline if !banner.nil?
    map['listings'] = postListings
    map['userInfo'] = userInfo
    map['pagingform'] = pagingForm
    map['filterset'] = filterset
    map['mediaListEnabled'] = mediaEnabled
    map['mediaList'] = mediaList
    return map
  end
  
  # Processed when the form is submitted, 
  # see the controller 'processFormSubmission()' method
  def onSubmit(request, response, form, errors)
    ratingId = form.ratingId
    ratingId = ratingId.to_i
    link = @daohelper.readLinkListing(ratingId)    
    if form.operation == 'upvote'
        link.rating = link.rating + 1
    elsif form.operation == 'downvote'
        link.rating = link.rating - 1
    end    
    @daohelper.createLink(link)
    return form
  end
end

BotverseController.new($controller)

## End of Script ##

