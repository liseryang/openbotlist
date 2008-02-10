#
# Berlin Brown
# jruby - bot_index search
#
require 'java'
include_class 'com.ibatis.sqlmap.client.SqlMapClient' unless defined? SqlMapClient
include_class 'com.ibatis.sqlmap.client.SqlMapClientBuilder' unless defined? SqlMapClientBuilder
include_class 'com.ibatis.common.resources.Resources' unless defined? Resources

include_class 'org.spirit.bean.impl.BotListSystemAuditLog' unless defined? BotListSystemAuditLog

include_class 'org.spirit.util.search.BotListBuildSearch' unless defined? BotListBuildSearch

def indexSearch(topDir)
	search = BotListBuildSearch.new(topDir)
	search.setSqlMapXML("conf/search/SqlMapConfig.xml")
	search.mkIndexDir()
	index_exists = search.indexDirExists()
	if index_exists
		# If it does exist, purge
		search.purgeIndexDir()
	else
		puts "ERR: Invalid Index Directory, exiting"
		return
	end	
	search.processEntityLinks
end

def main()
	
	if ARGV.size != 1
		puts "usage: bot_index_search.rb <index top dir>"
		puts "args=#{ARGV}"
		return 
	end
	
	puts "running"
	start_time = Time.now
		
	index_top_dir = ARGV[0]
	indexSearch(index_top_dir)		
		
	end_time = Time.now
	diff_time = end_time - start_time
	printf "processing index search in %.5f s\n", diff_time
	puts "done"	
end

main()

# End of script