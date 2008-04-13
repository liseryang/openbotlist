########################################
# Berlin Brown
########################################

require 'java'
include Java

module AgentUtils
  
  # Botrover99 is a capable agent
  BOT_AGENT_NAME = "botrover99"
  MAX_LEN_FIELD = 120
  DEFAULT_RDF_MSG = <<EOF
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
</rdf:RDF>
EOF
  
  CANNED_BOT_MSGS = [
                     "I enjoyed the cake.  It was good.",
                     "The cake was a little dry, but I ate it anyway.",
                     "I wish there was more cake around.",
                     "My life as a bot is difficult.",
                     "Do you know Chomsky?",
                     "Do you speak any japanese?",
                     "Work is fun, but baking a cake is even more fun. Mmm.",
                     "Cake and bot work go together.",
                     "I ate too much cake.  Do you have a toothbrush?"
                    ]

  def AgentUtils.shortenField(str_val)
    str = str_val[0, MAX_LEN_FIELD] if str_val.length > MAX_LEN_FIELD
    return str if !str.nil?
    return str_val
  end
  def AgentUtils.urlItemCleanup(item)
    return if item.nil?		
    # Cleanup url
    if !item.urlTitle.nil?
      item.urlTitle.gsub!("\,", "")
      item.urlTitle.gsub!(/\r\n?/, "")			
      item.urlTitle.strip!
      item.urlTitle = shortenField(item.urlTitle)
    end
    # Cleanup URL with encoded value
    item.mainUrl.gsub!("\,", "%2C") if !item.mainUrl.nil?
  end
  def AgentUtils.verifyItem(item)
    return false if item.nil?		
    return false if item.urlTitle.nil? or item.urlTitle.strip.empty?
    return false if item.mainUrl.nil? or item.mainUrl.strip.empty?		
    # Valid item, allow
    return true
  end
  
end # End of Module

# End of script
