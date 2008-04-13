########################################
# Rspec tests
# Author: Berlin Brown
# Date: 3/10/2008
#
# Rspec simple single test.  Modify this test
# to only test one unit.
########################################

# Have to manually find the library files; example:
# spring_config = File.expand_path("#{File.dirname(__FILE__)}/../../../../WEB-INF/botlistings-servlet.xml")

describe "Creating simple mock objects <single test>" do
  before(:each) do
    @cur_sess_id = rand(1000000)
  end

  it "Should test simple unit" do
  end

  # End of module
end

