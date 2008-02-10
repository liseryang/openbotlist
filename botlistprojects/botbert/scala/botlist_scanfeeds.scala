//
// 4/20/2007
// botlist_scanfeeds.scala
// Read RSS feeds based on list stored in database
//
// Stage One:
//  * Read the property file with settings (reader_properties.xml)
// Stage Two:
//  * Scan the system_scan_feeds table for a list of feeds
// Stage Three:
//  * Store all new data into system_feed_items, set process_count to zero
// Stage Four:
//  * Check the entity_links table for existing content
//  * Process a set number of item from feed_items and increase the process_count
// Stage Five:
//   * Store in entity_links

import scala.Console
import java.io._
import scala.xml._
import java.net._  
import org.jdom._
import org.jdom.{Document => JDocument}
import java.util.{Iterator => JIterator}
import org.jdom.input._
import scala.dbc._
import scala.dbc.Syntax._
import scala.dbc.statement._
import scala.dbc.statement.expression._
import scala.dbc.value._
import scala.dbc.syntax._
import syntax.Statement._
import scala.dbc.statement.{Select => DBCSelect}
import java.sql.{DriverManager, Connection, ResultSet, PreparedStatement, Statement, Date }
import DriverManager.{getConnection => connect}

import RichSQL._
import KeywordProcessor._

import java.util.Random

//------------------------------------------------
// Bean Definitions for Object Mapping
//------------------------------------------------

case class ScanFeed(main_url: String, url_title: String, url_description: String, url_source: String) {	
  val mainUrl = main_url
  val urlTitle = url_title
  val urlDescription = url_description
  val urlSource = url_source
}

case class FeedItem(main_url: String, url_title: String, url_description: String, url_source: String) {	
  val mainUrl = main_url	
  val urlTitle = url_title
  val urlDescription = url_description
  val urlSource = url_source
}

case class EntityLink(main_url: String, url_title: String, url_description: String) {	
  val mainUrl = main_url	
  val urlTitle = url_title
  val urlDescription = url_description
}

case class CountFeedItems(total: Int) {	
  val count = total
}

//------------------------------------------------
// End of Bean Definitions
//------------------------------------------------

/**
 * BotList Scan Feeds
 */
object BotListScanFeeds {
  	
  val full_name_user = "botbert99"

  val useragent = "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727; InfoPath.1)"  

  val enable_proxy = "false"
  val proxy_host = "the_proxy"
  val proxy_port = "9999"
  val update_delay = "20"
  val debug_enabled = "true"
  val append_file = "false"
  val read_description = "false"
  val split_url_line = "true"
  val news_feed = "http://reddit.com/new.rss"
  val use_feed_file = "true"
  val feed_file = "newsfeeds.dat"
  val maxFeedItems = 32

  val rand = new Random(System.currentTimeMillis())

  val nativeDriverClass = Class.forName("com.mysql.jdbc.Driver")
  val conn = connect("jdbc:mysql://localhost/botlist_development", "user", "PASSWORD")
   
  val valDefaultPropertyXML =
    <ReaderConfiguration>
      <settings>
      	<property name="enable.proxy" value={enable_proxy} />
        <property name="proxy.host" value={proxy_host} />
        <property name="proxy.port" value={proxy_port} />
        <property name="update.delay" value={update_delay} />
        <property name="debug.enabled" value={debug_enabled} />
        <property name="append.file" value={append_file} />
        <property name="read.description" value={read_description} />
        <property name="news.feed" value={news_feed} />
        <property name="use.feed.file" value={use_feed_file} />
        <property name="feed.file" value={feed_file} />
      </settings>
    </ReaderConfiguration>;
	
  def processData(urlString:String): List[(String, String, String)] = 
    try {
      val builder = new SAXBuilder()
      val doc = builder.build(new URL(urlString))
      val root = doc.getRootElement()
      val channel = root.getChild("channel")
      val items = channel.getChildren()
      val it = items.iterator
      var data = List[(String, String, String)]()
      while (it.hasNext) {
	val eItem = it.next.asInstanceOf[Element]
	if ("item" == eItem.getName()) {
	  val eTitle = eItem.getChild("title");
	  val eDescr = eItem.getChild("description");
	  val eLink = eItem.getChild("link");
	  data = (eTitle.getTextNormalize, 
		       eDescr.getTextNormalize, eLink.getTextNormalize) :: data
	}
      }
      data
    } catch {
      case ex:Exception => {
	Console.println("ERR: Could not process data feed")
	Console.println(ex)
	List()
      }
    }

  /**
   * Create a single feed item, used with (Stage Three)
   */
  def createItem(url: String, title: String, descr: String, source: String) {       
    val insertFeedItems = conn prepareStatement "insert into system_feed_items(main_url, url_title, url_description, url_source) values(?, ?, ?, ?)"
    try {
      
      // Use URL to check for malformed URLs
      val checkURL = new URL(url)
      if (title != null && title.length < 4) {
	throw new RuntimeException("Invalid URL Title")
      }      
      // Call the postfix operator '!' to execute
      insertFeedItems << url << title << descr << source <<!;
    } catch {
      case ex:Exception => {
	// Typically, a duplicate key error will be thrown here
	//Console.println("ERR: Unable to create feed item")
	//Console.println(ex)	
      }
    }
  }
    
  /**
   * Stage Four, Check existing entity links for an already created
   * link.
   */
  def hasEntityLink(link: String): boolean = {
    implicit val s: Statement = conn << ;
    for (val ctObj <- RichSQL.query("select count(1) from entity_links where main_url = '" + link + "'", rs => CountFeedItems(rs))) {
      if (ctObj.count > 0)
	return true
    }
    return false
  }

  def updateProcessCount(url: String) {
    val processCount = conn prepareStatement "update system_feed_items set process_count = 1 where main_url = ?"
    try {
      // Call the postfix operator '!' to execute
      processCount << url <<!;
    } catch {
      case ex:Exception => { 	 
	Console.println("ERR: failed to update process count=" + ex)	
      }
    }
  }

  /**
   * Stage Five, create new entity link.
   */
  def createEntityLinkRecord(url: String, title:String) {
    val insertEntityLink = conn prepareStatement "insert into entity_links(main_url, url_title, full_name, keywords, rating, created_on) values(?, ?, ?, ?, ?, NOW())"
    try {
      // We can get away with updating the process count, we can
      // reprocess in later iterations
      updateProcessCount(url)
      val cleanTitle = filterNonAscii(title)
      val keywordTitle = createKeywords(cleanTitle)
      // Call the postfix operator '!' to execute
      insertEntityLink << url << cleanTitle << full_name_user << keywordTitle << rand.nextInt(30) <<!;
    } catch {
      case ex:Exception => { 	 
	Console.println("ERR: failed to create entity link=" + ex)	
      }
    }
  }

  /**
   * Stage Four and Five, check and then create the entity link.
   */
  def createEntityLinks() {
    implicit val s: Statement = conn << ;
    var ctr = 0
    for (val feed <- query("select main_url, url_title, url_description, url_source from system_feed_items where process_count = 0 order by RAND()", rs => FeedItem(rs,rs,rs,rs))) {
      val baseURL = feed.mainUrl
      val title = feed.urlTitle
      val descr = feed.urlDescription
      // Check for already saved records
      val hasLink = hasEntityLink(baseURL)	
      if (!hasLink) {
	createEntityLinkRecord(baseURL, title)
	ctr = ctr + 1;
	if (ctr > maxFeedItems) { Console.println("WARN: max feed items reached (" + maxFeedItems + "), exiting."); return; }
      } else {
  	Console.println("WARN: entity link already exists=" + baseURL)
      }
    }
  }
 
  /**
   * Stage Three, store all new data into system_feed_items, 
   * set process_count to zero.
   */
  def createFeedItems(list: List[(String, String, String)]) {
    for (val item <- list) {
      createItem(item._3, item._1, item._2, "http://www.google.com")
    }
  }

  def saveXML(xml: Node, filename: String) = {
    val tmpFile = new File(filename + ".xml")
    val str = new FileWriter(tmpFile)
    str.write(xml.toString())
    str.close()
  }
	
  def loadXML(baseName: String):Node = {
    val file = new File(baseName + ".xml")
    Console.println("loading..." + file)
    val xml = XML.load(file.getAbsolutePath)	        
    xml
  }
       
  /**
   * Stage Two, scan the feed list and get the URL to extract
   * feed data.
   */
  def scanFeedList() {      
    implicit val s: Statement = conn << ;
    for (val feed <- RichSQL.query("select main_url,url_title, url_description, url_source from system_scan_feeds", 
				   rs => ScanFeed(rs,rs,rs,rs))) {
      val baseURL = feed.mainUrl
      try {
	Console.print("processing... / ")
	val res = processData(baseURL)	
	createFeedItems(res)
      } catch {
	case ex:Exception => {
	  Console.println("ERR: failed to process data and create feed item=" + ex)
	}
      }
      Console.println("done.")
    }
  }

  def main(args: Array[String]): Unit = {  	
  	
    Console.println(args(1))
    val tcur = System.currentTimeMillis  
    val tmpFile = new File(args(1) + "/reader_properties.xml")
    if (!tmpFile.exists) {
      Console.println("* Writing new reader properties XML configuration file")
      saveXML(valDefaultPropertyXML, args(1) + "/reader_properties")
    } else {
      Console.println("+ Not writing reader properties configure, already exists")
    }
    val nxml = loadXML(args(1) + "/reader_properties") 	
    // Connect
    val start = System.currentTimeMillis
    System.getProperties().put("proxySet", enable_proxy)
    System.getProperties().put("proxyHost", proxy_host)
    System.getProperties().put("proxyPort", proxy_port)
    System.getProperties().put("http.agent", useragent)
  	
  	// Check for args that might contain -s=scan feed list and -e=create entity links
  	for (val arg <- args) {
  		Console.println("Args[  " + arg + "]")
  	}
  	
    // Initiate stage two, scan feeds
    for (val arg <- args) {
    	// Check for scan feed flag
    	if (arg == "-s") {
    		Console.println("INFO: scan feed list flag enabled");
	    	scanFeedList()
	    }	    		   	
	}
	
	// Stage Four and Five, check for existing links and commit
	for (val arg <- args) {
		// Check for scan feed flag
    	if (arg == "-e") {
    		Console.println("INFO: create entity links flag enabled");
    		createEntityLinks
    	}
    }
        
	conn.close
    val end = System.currentTimeMillis
    Console.println("processed in=" + (end-start)/1000.0 + "s")
  }
}

