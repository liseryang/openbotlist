########################################
# Rspec tests
# Author: Berlin Brown
# Date: 3/10/2008
########################################

include_class 'org.spirit.bean.impl.BotListCoreUsers' unless defined? BotListCoreUsers
include_class 'org.spirit.util.BotListUniqueId' unless defined? BotListUniqueId
include_class 'org.acegisecurity.providers.encoding.Md5PasswordEncoder' unless defined? Md5PasswordEncoder
include_class 'org.spirit.bean.impl.BotListProfileSettings' unless defined? BotListProfileSettings
include_class 'org.spirit.contract.BotListContractManager' unless defined? BotListContractManager

include_class 'java.text.SimpleDateFormat' unless defined? SimpleDateFormat
include_class "java.util.Calendar" unless defined? Calendar

include_class "org.spirit.contract.BotListCoreUsersContract"
include_class "org.spirit.bean.impl.BotListEntityLinks"
include_class "org.spirit.bean.impl.BotListUserLink"
include_class "org.spirit.bean.impl.BotListPostListing"
include_class "org.spirit.bean.impl.BotListCityListing"
include_class "org.spirit.bean.impl.BotListUserVisitLog"
include_class "org.spirit.bean.impl.BotListUserComments"
include_class "org.spirit.bean.impl.BotListForumGroup"
include_class "org.spirit.bean.impl.BotListCoreUsers"
include_class "org.spirit.bean.impl.BotListCatGroupTerms"
include_class "org.spirit.bean.impl.BotListCatLinkGroups"
include_class "org.spirit.bean.impl.BotListProfileSettings"
include_class "org.spirit.bean.impl.BotListMediaFeeds"
include_class "org.spirit.bean.impl.BotListActiveMediaFeeds"
include_class "org.spirit.bean.impl.BotListUserLinks"

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

