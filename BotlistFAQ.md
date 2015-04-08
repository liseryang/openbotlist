# Overview #

Google recently released news that Google's index contains one trillion URLs.  This is great news that the Internet has grown to such enormous size but not that great for users that want to traverse all of that information.  Google and other search engines provide applications for users to "search" the web and get to information they are interested based on keywords and other queries.  Social networking sites turns that paradigm around a bit.  Applications like Del.icio.us, Digg, Reddit and **Botlist** provide user portal sites for users to post their favorite links.  As opposed to users querying and searching for interesting links.  Users submit their links to sites like Reddit and tag them with interesting titles and keywords.  Hopefully the user submitted links fall inline with content that you are also interested in.  Botlist attempted to go a step further and focus on the bot/agent generated links.  News aggregation and user submitted links.

Botlist contains an open source suite of software applications for social bookmarking and collecting online news content for use on the web. Multiple web front-ends exist based on Django (through Google AppEngine), Rails, and J2EE. Users and remote agents are allowed to submit interesting articles. There are additional remote agent libraries for back-end text mining operations. The system is broken up by the back-end specification and front-end specification.

![http://openbotlist.googlecode.com/svn/trunk/openbotlist/docs/media/blist_backend_process.png](http://openbotlist.googlecode.com/svn/trunk/openbotlist/docs/media/blist_backend_process.png)

# Frequently Asked Questions #

### Q. What is Botlist? ###

_See the Overview section of this wiki entry?_

### Q. Botlist seems overly ambitious, how far along is the project? ###

Unfortunately?  Botlist is only at the alpha release stage.  Essentially, many critical bugs exist and many features are missing.  But, you can download the application and run it under a J2EE application/Servlet  container like Tomcat.  See the QuickStart Wiki guides for more information.  At present, Botlist works more as a proof of concept for your future project.

### Q. Tell more about the "Back-End", what about the bot/agent crawlers? ###

Conceptually, Botlist consists of two sub-systems;  The web front-ends (Django, J2EE, Lisp based) and the back-end that processes online web content like RSS feeds and then transmit the data to the web front-end to display for the users.

Currently, there is a working python based back-end agent for crawling RSS feeds and submitting the information to a web front-end.

**Subversion Source for Python based RSS crawler**

http://openbotlist.googlecode.com/svn/trunk/botlistprojects/botbert/

**Subversion Source for Haskell based Web crawler**

http://openbotlist.googlecode.com/svn/trunk/botlistprojects/botspider/

### Q. What are some keywords that you would associate with Botlist? ###

  * Reddit.com/Digg.com/News.google.com/Del.icio.us
  * News.YCombinator
  * Web/RSS Crawler
  * Social Bookmarking
  * News Aggregation
  * Alpha Release
  * Text Mining
  * Discussion Forum
  * Simple Bug Tracker
  * Craigslist / Ad Listings
  * Technologies (J2EE Front-End): JRuby, Spring, Hibernate, Python, Scala
  * Technologies (Back-End): Python, Scala, Haskell

### Q. Now that the source is released for Reddit?  Doesn't that make Botlist really "not" as useful? ###

Reddit is an interesting piece of software and influenced Botlist.  But, there are many differences (Botlist uses JRuby and the front-end is built with J2EE).  Basically, Botlist is different; maybe others could find the source code or application useful.  Also, some of the Botlist tools could leverage Reddit's source code.

http://code.reddit.com/

### Q. How was JRuby used with the Botlist project? (for developers) ###

"JRuby is a Java implementation of the Ruby interpreter, being developed by the JRuby team.", From Wikipedia.

JRuby was used to build a lot of the business logic for the J2EE web code.  JRuby made it easy to create a light-weight web framework on top of Spring and Hibernate.  For example, the code below is used to build the main URL listing page.

http://openbotlist.googlecode.com/svn/trunk/openbotlist/WEB-INF/jsps/botverse/botverse.rb

### Q. What are some other uses for Botlist? (for developers) ###

**Botlist contains the following applications:**

  * User submission site and news aggregation.
  * Discussion Forum
  * Ad Listing Site (unfinished, but meant to resemble Craigslist)
  * Storing of FOAF (Friend of a Friend) profiles
  * Simple Bug Tracking (light functionality)
  * Search system using data stored on Botlist
  * RSS/Web crawler

If you are developer, the code could be modified for some of these applications.
**Can also be used for the following:**
  * Improved bug tracker and possible wiki
  * Improved web crawler and text mining
  * Web analytics
  * 