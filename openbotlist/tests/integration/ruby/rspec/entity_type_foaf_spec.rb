#
# Copyright (c) 2007, Botnode.com (Berlin Brown)
# See LICENSE.BOTLIST for the most recent license updates.
#
# http://www.opensource.org/licenses/bsd-license.php
# 
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification, 
# are permitted provided that the following conditions are met:
#
#    * Redistributions of source code must retain the above copyright notice, 
#    this list of conditions and the following disclaimer.
#    * Redistributions in binary form must reproduce the above copyright notice, 
#    this list of conditions and the following disclaimer in the documentation 
#    and/or other materials provided with the distribution.
#    * Neither the name of the Newspiritcompany.com (Berlin Brown) nor 
#    the names of its contributors may be used to endorse or promote 
#    products derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
########################################
# Berlin Brown
# Date: 3/3/2008
# tests/integration/ruby/rspec
########################################

include_class 'java.text.SimpleDateFormat' unless defined? SimpleDateFormat
include_class "java.util.Calendar" unless defined? Calendar
include_class "org.spirit.bean.impl.BotListEntityTypeFoaf" unless defined? BotListEntityTypeFoaf

describe "For manipulating objects=" do  
  before(:each) do
    @ac = $context
    @rad_controller = @ac.getBean("radController")
    @cur_sess_id = rand(1000000)
  end

  it "Should manipulate the entity_type_foaf" do 
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

end
# End of File
