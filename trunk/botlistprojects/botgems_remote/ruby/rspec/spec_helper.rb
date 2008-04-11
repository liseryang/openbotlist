###
### Author: Berlin Brown
### spec_helper.rb
### Date: 2/22/2008
### Description: RSpec, JRuby helper for setting up
### spring rspec tests for botlist
###
lib_path = File.expand_path("#{File.dirname(__FILE__)}/../../lib")
$LOAD_PATH.unshift lib_path unless $LOAD_PATH.include?(lib_path)

require 'spec'
require 'java'
include_class('java.lang.String') { 'JString' }
include_class('java.lang.System') { 'JSystem' }

# Have to manually find the spring config files
spring_config = File.expand_path("#{File.dirname(__FILE__)}/../../../../WEB-INF/botlistings-servlet.xml")
spring_util_config = File.expand_path("#{File.dirname(__FILE__)}/../../../../WEB-INF/spring-botlist-util.xml")

# The logs will get output here
JSystem.getProperties().put("catalina.base", "util")

# Ensure correct java type String for spring config filename array
# spring_conf_arr = Java::JavaClass.for_name("java.lang.String").new_array(2)

string_class = Java::JavaClass.for_name("java.lang.String")
spring_conf_arr = string_class.new_array(2)
spring_conf_arr[0] = Java.primitive_to_java("file://" + spring_config)
spring_conf_arr[1] = Java.primitive_to_java("file://" + spring_util_config)

#
# Spring specific includes
include_class "org.springframework.context.support.FileSystemXmlApplicationContext"
# Set the application context.  Use this in the rspec tests.
$context = FileSystemXmlApplicationContext.new(spring_conf_arr)

# End of File
