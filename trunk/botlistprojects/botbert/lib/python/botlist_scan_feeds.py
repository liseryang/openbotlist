"""
 4/20/2007:
 Python version scala (botlist_scanfeeds)

 botlist_scanfeeds.scala
 Read RSS feeds based on list stored in database

 Stage One:
  * Read the property file with settings (reader_properties.xml)
 Stage Two:
  * Scan the system_scan_feeds table for a list of feeds
 Stage Three:
  * Store all new data into system_feed_items, set process_count to zero
 Stage Four:
  * Check the entity_links table for existing content
  * Process a set number of item from feed_items and increase the process_count
 Stage Five:
   * Store in entity_links
"""

import sys
import urllib
import urllib2
import socket
import datetime
import time
import cgi
import os
from xml.dom.minidom import parse, parseString

import util.text_utils as text_utils

from business.scan_feed_bom import ScanFeedHandler
__author__ = "Berlin Brown"
__version__ = "0.1"

#--------------------------------------

# Use the max description length to prevent insertion
# of article descriptions that are too long.
# Generally, large article descriptions range from 5k to 15k
MAX_DESCR_LEN = 3000

# Modify the limit of seeding feeds to poll
MAX_FEEDS_SCAN = 500

DEFAULT_REQUEST_TIMEOUT = 20

#--------------------------------------
class ItemBean:
        def __init__(self):
                self.title = None
                self.descr = None		
                self.link = None
                self.source = None
                self.channelURL = None
        def verify(self):
                """ Because we are inserting these values into the database,
                ensure that a zero length value is returned as opposed to null"""
                self.title = self.title and self.title or ''		
                self.descr = self.descr and self.descr or ''		
                self.link = self.link and self.link or ''
                self.channelURL =  self.channelURL and self.channelURL or ''
                
        def __str__(self):
                return "[title=%s]" % (self.title)
        
"""
------------------------------------------------
 Botlist Scan Feeds
------------------------------------------------
"""
class BotListScanFeeds:
        
        def __init__(self):
                self.feed_handler = ScanFeedHandler()
                self.feed_handler.connect()
                self.item_data = []
                self.feed_item_ctr = 0
                self.feed_passed = 0
                
                self.full_name_user = "botbert99"
                self.useragent = "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727; InfoPath.1)"  
                self.enable_proxy = "false"
                self.proxy_host = "the_proxy"
                self.proxy_port = "9999"
                self.update_delay = "20"
                self.debug_enabled = "true"
                self.append_file = "false"
                self.read_description = "false"
                self.split_url_line = "true"
                self.news_feed = "http://reddit.com/new.rss"
                self.use_feed_file = "true"
                self.feed_file = "newsfeeds.dat"
                self.maxFeedItems = 40
        
        def nodeValue(self, node):
                if node and node.firstChild:
                        res = node.firstChild.nodeValue
                        return res
                
        def parseItem(self, node, source, channelURL):
                title = node.getElementsByTagName("title")[0]
                descr = node.getElementsByTagName("description")[0]
                link = node.getElementsByTagName("link")[0]
                item = ItemBean()                
                # Transform this data into an object		
                item.title = self.nodeValue(title)
                item.descr = self.nodeValue(descr)		
                item.link = self.nodeValue(link)
                item.source = source
                if channelURL:
                        item.channelURL = channelURL
                self.item_data.append(item)

        def getChannelLink(self, doc):
                # Get the channel link
                linkElm = doc.getElementsByTagName("link")[0]
                if linkElm:
                        return self.nodeValue(linkElm)
                
        def parseXMLDoc(self, doc, source):
                # Get the channel link
                channelLinkURL = None
                try:
                        channelLinkURL = self.getChannelLink(doc)
                        if channelLinkURL:
                                channelLinkURL = channelLinkURL.strip()
                except: pass
                
                # Get the set of items
                channelNodeList = doc.getElementsByTagName("item")
                try:
                        for item in channelNodeList:
                                try:                                        
                                        self.parseItem(item, source, channelLinkURL)
                                        self.feed_item_ctr = self.feed_item_ctr + 1
                                except Exception, ex:
                                        print "ERROR: at parseXMLDoc(), parsing item"
                                        print ex
                                        
                except Exception, ignore:
                        print "WARN: error while processing item list"
                                
        def processData(self, urlString):
                try:
                        request = urllib2.Request(urlString) 
                        request.add_header('User-Agent', 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727; InfoPath.1)') 
                        opener = urllib2.build_opener()
                        data = opener.open(request).read()                        
                        doc = parseString(data)
                        self.parseXMLDoc(doc, urlString)
                except Exception, ex:
                        print "ERROR: at processData()"
                        print ex
                                        
        def hasEntityLink(self, link):
                """Stage Four, Check existing entity links for an already created link."""
                return self.feed_handler.hasEntityLink(link)

        def updateProcessCount(self, url):
              self.feed_handler.updateProcessCount(url)                  
        
        def createEntityLinks(self):
                """Stage Four and Five, check for existing link,
                if not found then create the entity link."""
                ctr = 0
                data = self.feed_handler.listSystemFeedItems()
                # Print total number of feed items to attempt to tranfer
                if data:
                        print "INFO: attempt feed items transfer=%s" % len(data)
                        
                for feed in data:
                        baseURL = feed.mainUrl
                        title = feed.urlTitle.strip()
                        descr = feed.urlDescription
                        hasLink = self.hasEntityLink(baseURL)
                        if not hasLink:
                                # Stage Five, create new entity link.                                
                                try:
                                        if len(title) > 4:
                                                # Before inserting, perform pre-processing cleanups on data
                                                feed.verify()
                                                self.feed_handler.updateInsertEntityProcessCount(baseURL, title,
                                                                                                 self.full_name_user, feed.channelURL)
                                                ctr = ctr + 1;
                                except Exception, ex_feed:
                                        print baseURL
                                        print ex_feed
                                        pass                                
                                if (ctr > self.maxFeedItems):
                                        print("WARN: max feed items reached (%s), exiting." % self.maxFeedItems)
                                        return
                        else:
                                pass
                                #print("WARN: entity link already exists")
                                
        def createItem(self, item):
                """Create a single feed item, used with (Stage Three)"""
                try:
                        self.feed_handler.createItem(item.link, item.title, item.descr,
                                                     item.source, item.channelURL)
                        self.feed_passed = self.feed_passed + 1
                except Exception, ex:                        
                        # Remove comment for detailed information on feed item created
                        #print ex
                        pass
        
        def initCreateFeedItem(self, item):
                """Before creating a feed item record, perform pre-processing operations
                to cleanup item before it is inserted"""
                text_utils.shorten(item.descr, MAX_DESCR_LEN)
                return item
                
        def createFeedItems(self):
                """Stage Three, store all new data into system_feed_items, 
                set process_count to zero."""
                for item in self.item_data:
                        self.initCreateFeedItem(item)
                        self.createItem(item)
                        
        def scanFeedList(self):
                """Stage Two, scan the feed list and get the URL to extract feed data."""        
                data = self.feed_handler.listScanFeeds()
                data = data[:MAX_FEEDS_SCAN]
                for idx, feed in enumerate(data):
                        print "feeds ... / [%s/%s] (%s docs:%s passed)" % (idx, len(data),self.feed_item_ctr, self.feed_passed)
                        try:
                                baseURL = feed.mainUrl
                                self.processData(baseURL)	
                                self.createFeedItems()
                        except Exception, ex:
                                print("ERR: failed to process data and create feed item=%s" % ex)
                print "done"
                        
        def closeConn(self):
                self.feed_handler.closeConn()
        
"""
------------------------------------------------
 Botlist Scan Feeds
------------------------------------------------
"""

def cleanup(home_dir):
        if home_dir:                
                pid_paths = [ home_dir, "/bin", "/botbert.pid" ]
                pid_file = ''.join(pid_paths)
                print "INFO: removing botscan pid file=%s" % pid_file
                os.remove(pid_file)                
        else:
                print "WARN: invalid home directory, remove pid file failed"

def main():        
        args = sys.argv        
        start = time.time()
        # Set the default timeout.        
        socket.setdefaulttimeout(DEFAULT_REQUEST_TIMEOUT)
        
        feeds = BotListScanFeeds()
        
        # Check for args that might contain -s=scan feed list and -e=create entity links
        for arg in args:
                print "Args[  %s]" % arg
                
        # Initiate stage two, scan feeds
        for arg in args:        
                # Check for scan feed flag
                if (arg == "-s"):
                        print "INFO: scan feed list flag enabled"
                        feeds.scanFeedList()
                        
        # Stage Four and Five, check for existing links and commit
        for arg in args:
                # Check for scan feed flag
                if (arg == "-e"):
                        # Check for the number associated with "entity-links
                        ctr = 0
                        try:
                                n_max = feeds.maxFeedItems
                                for arg in args:
                                        if arg == "-n":
                                                str_max = args[ctr + 1]
                                                n_max = int(str_max)
                                                feeds.maxFeedItems = n_max
                                                print "INFO: Setting max feed items=%s" % feeds.maxFeedItems
                                                break
                                        else:
                                                ctr = ctr + 1                                
                        except Exception, ne:
                                print "WARN: invalid max feed setting"
                                pass
                        
                        print "INFO: create entity links flag enabled"
                        feeds.createEntityLinks()        
                        
        feeds.closeConn()
        end = time.time()
        print "processed in=%s s" % ((end-start)/1000.0)
        
        # Perform any cleanups        
        if len(args) >= 4:
                cleanup(args[2])

if __name__ == '__main__':
        print "--------------------------------------------"
        print " botlist scan feeds"
        print " help:"
        print " -s =  perform scan on system feeds"
        print " -e =  perform entity link create"
        print " -n <max count> =  number of entity links to create"
        print "--------------------------------------------"
        print "version (py %s)" % __version__
        main()
        print "done (scan feeds)"
                
# End of the File
