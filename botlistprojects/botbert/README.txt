##
## Berlin Brown
## README.txt
##
 
 ---------------------------------------------
  For production python deployments
 ---------------------------------------------
 Copy 
 /home/[USERNAME]/workspace/BotlistProjects/botbert/build/botbert_python.zip
 
 To the following production directory
 
 /home/[USERNAME]/botlistprojects/botbert/lib
 
 ---------------------------------------------
 Specification and Functionality for BotBert:
 ---------------------------------------------
 
 Stage One:
 
  * Read the property file with settings (reader_properties.xml)
  
 Stage Two:
  
  * Scan the system_scan_feeds table for a list of feeds
 
 Stage Three:
 
  * Store all new data into system_feed_items, set process_count to zero
  
 Stage Four:
  
  * Check the entity_links table for existing content
  * Process a set number of item from feed_items and increase the proceess_count
 
 Stage Five:
   
   * Store in entity_links
 

 ---------------------------------------------
 Scala Examples and Futher Reading:
 ---------------------------------------------  
 
 http://www.scala-lang.org/docu/examples/files/random.html
 
 http://www.artima.com/scalazine/articles/steps.html
  