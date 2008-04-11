########################################
# Rspec tests
# Author: Berlin Brown
# Date: 3/10/2008
########################################

import Java

import java.text.SimpleDateFormat
import java.util.Calendar

import org.spirit.bean.impl.BotListCoreUsers
import org.spirit.util.BotListUniqueId
import org.acegisecurity.providers.encoding.Md5PasswordEncoder
import org.spirit.bean.impl.BotListProfileSettings
import org.spirit.contract.BotListContractManager

import org.spirit.contract.BotListCoreUsersContract
import org.spirit.bean.impl.BotListEntityLinks
import org.spirit.bean.impl.BotListUserLink
import org.spirit.bean.impl.BotListPostListing
import org.spirit.bean.impl.BotListCityListing
import org.spirit.bean.impl.BotListUserVisitLog
import org.spirit.bean.impl.BotListUserComments
import org.spirit.bean.impl.BotListForumGroup
import org.spirit.bean.impl.BotListCoreUsers
import org.spirit.bean.impl.BotListCatGroupTerms
import org.spirit.bean.impl.BotListCatLinkGroups
import org.spirit.bean.impl.BotListProfileSettings
import org.spirit.bean.impl.BotListMediaFeeds
import org.spirit.bean.impl.BotListActiveMediaFeeds
import org.spirit.bean.impl.BotListUserLinks

describe "Creating simple mock objects=" do
  
  before(:each) do
    @ac = $context
    @rad_controller = @ac.getBean("radController")
    @cur_sess_id = rand(1000000)
  end

  it "Should create the entity links" do
    dao = @rad_controller.entityLinksDao
    mock_link = BotListEntityLinks.new
    mock_link.mainUrl = "http://www.google1.com"
    mock_link.fullName = "bot_tester"
    mock_link.urlTitle = "The Google"
    mock_link.keywords = "google cool man yea"
    mock_link.urlDescription = "google is the best yea man"
    mock_link.rating = 0
    dao.createLink(mock_link)
  end

  it "Should create the entity links (2)" do
    dao = @rad_controller.entityLinksDao
    mock_link = BotListEntityLinks.new
    mock_link.mainUrl = "http://www.google#{@cur_sess_id}.com"
    mock_link.fullName = "bot_tester"
    mock_link.urlTitle = "The Google#{@cur_sess_id}"
    mock_link.keywords = "google cool man yea second time sess#{@cur_sess_id}"
    mock_link.urlDescription = "google is the best yea man second time sess#{@cur_sess_id}"
    mock_link.rating = 0
    dao.createLink(mock_link)
  end
  
  it "Should create the user links" do

    df = SimpleDateFormat.new("mm/dd/yyyy")
    cal = Calendar.getInstance()
    cal.time = df.parse("1/1/1971")
    
  	dao = @rad_controller.userLinkDao
    mock_user = BotListCoreUsers.new
    mock_user.userName = "botlist_bob"
    mock_user.userEmail = "bbbbb@bbbbbb.com"
    mock_user.userUrl = "http://www.bbbbb.com"
    mock_user.userPassword = "abc123"
    mock_user.accountNumber = "342342323423"
    mock_user.dateOfBirth = cal

    begin
      sessionFactory = dao.getSessionFactory()
      hbm_session = sessionFactory.openSession()
      tx = hbm_session.beginTransaction()
      
      uid = BotListUniqueId.getUniqueId()
      uname = mock_user.userName
      
      encode = Md5PasswordEncoder.new
      pwd = encode.encodePassword(mock_user.userPassword, nil)
      
      mock_user.userPassword = pwd
      mock_user.accountNumber = "#{uid}00#{uname}"
      mock_user.activeCode = 1
      
      # Set the login timestamp values
      mock_user.lastLoginSuccess = Calendar.getInstance
      mock_user.lastLoginFailure = Calendar.getInstance
      mock_user.createdOn = Calendar.getInstance
      mock_user.updatedOn = Calendar.getInstance
      mock_user.secretquesCode = 0
      hbm_session.save(mock_user)
      tx.commit()
      
      # Also Create the profile
      DEFAULT_LINK_COLOR = '3838E5'

      tx = hbm_session.beginTransaction()
      settings = BotListProfileSettings.new
      settings.userId = mock_user.get_id
      settings.linkColor = DEFAULT_LINK_COLOR
      hbm_session.save(settings)
      tx.commit()
      
    rescue Exception => e
      tx.rollback()      
      raise e.message
    ensure
      hbm_session.close()
      # End of try - catch block
    end   
    
    # End of Method
  end 
    
  it "Should create the post listings" do
    dao = @rad_controller.postListingDao
    post = BotListPostListing.new
    post.email = "cool@cool.com"
    post.location = "everywhere"
    post.title = "This is fun"
    post.message = "Yep, that is pretty fun"
    post.cityId = 1
    post.sectionId = 4
    post.mainUrl = "http://www.google100.com"
    post.keywords = "yep fun this is"

    test_city_id = 1
    post_sect_id = 1
    begin
      sessionFactory = dao.getSessionFactory()
      hbm_session = sessionFactory.openSession()
      tx = hbm_session.beginTransaction()
      
      city = hbm_session.load("org.spirit.bean.impl.BotListCityListing", test_city_id, nil)
      post.cityId = test_city_id
      post.sectionId = post_sect_id = 1
      city.listings.add(post)
      
      #hbm_session.save(post)
      tx.commit()
      
    rescue Exception => e
      tx.rollback()      
      raise e.message
    ensure
      hbm_session.close()
      # End of try - catch block
    end   
  end

  it "Should create the entity_type_foaf" do 
    dao = @rad_controller.entityLinksDao
    mock_obj = BotListEntityTypeFoaf.new
    mock_obj.foafInterestDescr = ""
    mock_obj.rating = ""
    mock_obj.fullName = ""
    mock_obj.foafMbox = ""
    mock_obj.dateOfBirth = ""
    mock_obj.friendSetUid = ""
    mock_obj.foafPageDocUrl = ""
    mock_obj.foafImg = ""
    mock_obj.processCount = ""
    mock_obj.nickname = ""
  end
  
  it "Should test simple unit" do
    dao = @rad_controller.entityTypeFoafDao
    foaf = BotListFoaf::FoafHandler.new(dao, @log, "http://danbri.org/foaf.rdf")
    res = foaf.createFoaf
    sleep(1)
    # Launch another thread
    foaf_berlin = BotListFoaf::FoafHandler.new(dao, @log, "http://berlinbrown.livejournal.com/data/foaf")
    foaf_berlin.createFoaf
    # Delay so that the main thread does not exit
    sleep(7)
  end
  
  it "Should create the city listing" do
    dao = @rad_controller.cityListingDao
  end

  it "Should create the user visit log" do
    dao = @rad_controller.userVisitLogDao
  end    
  
  it "Should create the user comments" do
    dao = @rad_controller.userCommentsDao
  end
                  
  it "Should create the core users" do
    dao = @rad_controller.coreUsersDao
  end
    
  it "Should create the cat group terms" do
    dao = @rad_controller.catGroupTermsDao
  end
  
  it "Should create the cat link groups" do
    dao = @rad_controller.catLinkGroupsDao
  end
    
  it "Should create the media feeds" do
    dao = @rad_controller.mediaFeedsDao
  end
  
  it "Should create the active media feeds" do                                 
    dao = @rad_controller.activeMediaFeedsDao
  end
  
  it "Should create the user links" do
    dao = @rad_controller.userLinksDao
  end
  
  it "Should create the core settings" do
    #dao = @rad_controller.coreSettings
  end

end

