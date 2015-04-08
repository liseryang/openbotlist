# Overview #

**keywords:** jvm languages, webapp, scala, jruby, j2ee, url aggregator java

**Updated as of 8/2/2009:** Botlist is an example application, a proof of concept demo to demonstrate how to use a JVM Language (JRuby) in a J2EE environment.  It could possibly work as a complete solution, but it is mostly an example implementation of a web application.  The source is fully available and I encourage J2EE web application developers to browse the source.

Google recently released news that Google's index contains one trillion URLs. This is great news that the Internet has grown to such enormous size but not that great for users that want to traverse all of that information. Google and other search engines provide applications for users to "search" the web and get to information they are interested based on keywords and other queries. Social networking sites turns that paradigm around a bit. Applications like Del.icio.us, Digg, Reddit and Botlist provide user portal sites for users to post their favorite links. As opposed to users querying and searching for interesting links. Users submit their links to sites like Reddit and tag them with interesting titles and keywords. Hopefully the user submitted links fall inline with content that you are also interested in. Botlist attempted to go a step further and focus on the bot/agent generated links. News aggregation and user submitted links.

Botlist contains an open source suite of software applications for social bookmarking and collecting online news content for use on the web.  Multiple web front-ends exist based on Django (through Google AppEngine), Rails, and J2EE.  Users and remote agents are allowed to submit interesting articles.  There are additional remote agent libraries for back-end text mining operations.  The system is broken up by the back-end specification and front-end specification.

![http://openbotlist.googlecode.com/svn/trunk/openbotlist/docs/media/screenshot_home2.png](http://openbotlist.googlecode.com/svn/trunk/openbotlist/docs/media/screenshot_home2.png)

### Front-End ###
The botlist web front-end displays new and interesting URLs submitted from remote agents or through user submissions.  There is also an ads listing section so that users can post personal/ad profiles.  The application itself is created with the following libraries; Liftweb and SpringMVC for the visible parts of the website, JRuby and J2EE's Spring framework for business logic and the middleware piece, Hibernate for object relational mapping (ORM). It is designed to run with Tomcat but should work with other J2EE servers. Search functionality uses the Lucene API.

_(An additional front-end is being developed on the Hunchentoot lisp web server)_

## Other Features ##

News aggregation (some links will be included); over half a million links thus far.

You can reply to comments, up or down vote the news articles, post new article links similar to other social bookmarking sites.

  * Comma delimited output for easy, text based access (for developers)
  * Numerous documentation on architecture
  * Discussion Forums section
  * User profiles
  * Ad/Profile listing section, listed by city
  * Sort search by relevancy, submit date
  * Can also operate as a simple bug tracking system

![http://openbotlist.googlecode.com/svn/trunk/openbotlist/docs/media/blist_backend_process.png](http://openbotlist.googlecode.com/svn/trunk/openbotlist/docs/media/blist_backend_process.png)

## Visit Botlist Home (J2EE and Django Google AppEngine Front Ends) ##

  * http://ghostbots.com/botlist/ -- J2EE Front End
  * http://ghost-net.appspot.com/ -- Django Google AppEngine Front End)

## View the Source ##

http://openbotlist.googlecode.com/svn/

## Project Management ##

See Botlist project through the project management site.

  * http://code.google.com/p/openbotlist/source/list

## Influences and other Resources ##
### Web Front Ends ###
  * http://www.reddit.com
  * http://news.ycombinator.com/

### Text and Data Mining Back Ends ###
  * http://news.google.com

![http://openbotlist.googlecode.com/svn/trunk/openbotlist/docs/media/screenshot_botverse_1.png](http://openbotlist.googlecode.com/svn/trunk/openbotlist/docs/media/screenshot_botverse_1.png)