# Overview #

### Q. How was JRuby used with the Botlist project? ###

"JRuby is a Java implementation of the Ruby interpreter, being developed by the JRuby team.", From Wikipedia.

JRuby was used to build a lot of the business logic for the J2EE web code.  JRuby made it easy to create a light-weight web framework on top of Spring and Hibernate.  For example, the code below is used to build the main URL listing page.

http://openbotlist.googlecode.com/svn/trunk/openbotlist/WEB-INF/jsps/botverse/botverse.rb

### Q. How was Lift-Web and Scala used with the Botlist project? (for developers) ###

Botlist does not totally leverage the Java programming "language".  Other JVM languages like Scala, JRuby and Jython were used with this project.  The Lift-Web Scala based framework was used to build a piece on Botlist.  We used Lift-Web to create the "Pull" or receiving end of the offline application that transmits data to the web piece.  When the offline RSS crawler job is done crawling, another process is launched to send RSS data to the web piece.  That data is later displayed to the user. The Lift-Web piece receives the data.  Visit the Subversion URLs below to see some of the source code used to create those pages.

http://openbotlist.googlecode.com/svn/trunk/openbotlist/apps_src/scala/lift/agents/AgentUtil.scala
http://openbotlist.googlecode.com/svn/trunk/openbotlist/apps_src/scala/lift/agents/RemoteAgents.scala

You may also notice that we invoked some pre-existing Spring/Hibernate code from Scala.  The Scala code invokes the Spring based data access objects to persist data received from the remote crawling agent.

  * http://liftweb.net/index.php/Main_Page
  * http://www.scala-lang.org/