#
# Berlin Brown
# jruby - bot_index search
# 8/20/2007

require 'java'

include_class 'org.spirit.util.search.BotListBuildSearch' unless defined? BotListBuildSearch
include_class 'org.spirit.util.search.EntityLinkSearchHandler' unless defined? EntityLinkSearchHandler
include_class 'org.apache.lucene.search.Sort' unless defined? Sort
include_class 'org.apache.lucene.search.SortField' unless defined? SortField

include_class("java.lang.reflect.Array") { "JArray" }

def performSearch(searchHandler, query_line)	
	# build a sort object
	#sortField = SortField.new("yyyymmdd", SortField::STRING, true)
	#sortField = Sort::RELEVANCE	
	sort = Sort.new()
	sortFields = JArray.newInstance(SortField, 2);
	sortFields[0] = SortField::FIELD_SCORE
	sortFields[1] = SortField.new("yyyymmdd", SortField::STRING, true)		
	sort.setSort(sortFields)
	
	results = searchHandler.search(query_line, sort)
	results.each { |result| 
		puts "(rel=#{result.score}) / (date=#{result.yyyymmdd}) [#{result.urlTitle}]"
	}
	return nil
end

def searchShell(topDir)
	searchHandler = EntityLinkSearchHandler.new
	searchHandler.indexDir = topDir
	print "search> "
	while query_line = STDIN.gets
		query_line.strip!
		if query_line == "q":
			puts "Exiting"
			return nil
		else
			# Launch the search query line
			performSearch(searchHandler, query_line)
		end
		print "search> "		
	end
end

def main()
	
	if ARGV.size != 1
		puts "usage: bot_index_search.rb <index top dir>"
		puts "args=#{ARGV}"
		return 
	end
	
	puts "-----------------------------"
	puts "running"
	puts "-----------------------------"
	puts "q to quit"	
	start_time = Time.now
		
	index_top_dir = ARGV[0]	
	searchShell(index_top_dir)
		
	end_time = Time.now
	diff_time = end_time - start_time
	printf "processing index search in %.5f s\n", diff_time
	puts "done"	
end

main()

# End of script