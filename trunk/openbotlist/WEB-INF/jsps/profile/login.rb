##
## Berlin Brown
## 4/10/2007
##

require 'java'
require File.join(File.dirname(__FILE__), '../../WEB-INF/lib/ruby/actions', 'core_users')
require File.join(File.dirname(__FILE__), '../../WEB-INF/lib/ruby/web', 'users')

include_class 'org.spirit.util.BotListSessionManager' unless defined? BotListSessionManager
include_class 'org.spirit.bean.impl.BotListCoreUsers' unless defined? BotListCoreUsers
include_class 'org.spirit.form.BotListCoreUsersForm' unless defined? BotListCoreUsersForm
include_class 'org.spirit.spring.validate.BotListCoreUsersLoginValidator' unless defined? BotListCoreUsersLoginValidator

class UserController
		
  def initialize(controller)
    @controller = controller
    @dao_user = @controller.coreUsersDao
    @dao_profile = @controller.profileSettingsDao
  end    
  
  def getModel(request)
    coreUserForm = BotListCoreUsersForm.new
    coreUserForm.viewName = nil
    # Also set the validator
    @controller.setValidator(BotListCoreUsersLoginValidator.new)
    return coreUserForm 
  end
   
  def onSubmit(request, response, form, errors)

    # Check the errors first.
    if errors.getErrorCount() > 0
      # Revert back to the entry screen
      form.viewName = "profile/login"
      return form
    end
    
    core_users = CoreUsersManager::CoreUsers.new
    begin
      core_users.authenticateUser(@dao_user, form)
    rescue Exception => e
      # On error return to login page
      err_msg = e.message
      errors.reject("userName", "Invalid Login: #{err_msg}")
      form.viewName = "profile/login"
      return form
    end

    # Commit the registered user to session
    web_users = CoreUsersWeb::CoreUsers.new
    web_users.request, web_users.response = request, response
    web_users.core_users = core_users
    web_users.marshallData(@dao_profile, core_users.user)

    form.viewName = "profile/loginconfirm"    
    if web_users.user.nil?
      raise "Invalid Core User Object, could not find user"
    end
    web_users.user.viewName = form.viewName
    return web_users.user
  end
end

UserController.new($controller)

## End of Script ##

