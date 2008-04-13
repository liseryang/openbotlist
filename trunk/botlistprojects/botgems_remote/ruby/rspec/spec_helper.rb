###
### Author: Berlin Brown
### spec_helper.rb
### Date: 2/22/2008
### Description: RSpec, JRuby helper for setting up
### spring rspec tests for botlist
###

require 'spec'
require 'java'

include_class('java.lang.String') { 'JString' }
include_class('java.lang.System') { 'JSystem' }

# The logs will get output here
JSystem.getProperties().put("catalina.base", "util")

# End of File
