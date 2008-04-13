########################################
# Rspec tests
# Author: Berlin Brown
# Date: 3/10/2008
#
# Rspec simple single test.  Modify this test
# to only test one unit.
# 
# Single test - no help
########################################

# Have to manually find the library files; example:
# require File.join(File.dirname(__FILE__), '../../../../WEB-INF/lib/ruby/web/foaf', 'edit_foaf')

include Java

# Load the agent aggregate library (remoting library)
require File.join(File.dirname(__FILE__), '../', 'agent_botlist_aggregate')
require File.join(File.dirname(__FILE__), '../', 'agent_archive')

describe "Simple test <single test>" do
  before(:each) do
    @cur_sess_id = rand(1000000)
  end

  it "Should do nothing, simple jruby rspec test" do
    puts "[!]"
  end  

end # End of module

# End of the script

