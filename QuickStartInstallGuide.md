# Quick start setup #

Date: 2/6/2008

# Overview #

The botlist J2EE web frontend might be considered a medium sized web
application.  Make sure that you have a J2EE servlet container.  Tomcat 5.5+
is recommended but not required.  MySQL database server is required (expect a Postgres configuration in the future).
The java build tool Ant is also required for building the project.

**Test Environment and Recommended Configuration**
  * Mysql  Ver 14.12 Distrib 5.0.51a, for Win32 (ia32) (db server)
  * Ant 1.7.0 (java build tool)
  * Tomcat 5.5.26 (application server)
  * Java SDK java version "1.5.0\_11" (java compiler), 1.6 recommended
  * Operating systems: WinXP and Ubuntu Linux 7.10
  * All other libraries are provided in the subversion source or download

# Download from Google Code (Botlist J2EE front-end) #

![http://openbotlist.googlecode.com/svn/trunk/openbotlist/docs/media/screenshot_google_download.png](http://openbotlist.googlecode.com/svn/trunk/openbotlist/docs/media/screenshot_google_download.png)

There is an issue with hosting botlist on google-code.  Botlist includes 50+MB of libraries and other modules.  This is over google's upload limit and borders on the project limit.  This means that the libraries needed to run botlist are broken into various download modules.  (Especially the libraries needed for the botlist J2EE WEB-INF/lib directory).  To remedy this problem, you need to download all the libraries and manually place them in the BOTLIST\_WEBAPP\_HOME/WEB-INF/lib.  If any of the jar file libraries are missing then botlist may not function properly.

  1. Download botlist\_web\_072008.tar.gz - this download contains all of the Java source and JRuby source for the botlist web front-end.
  1. Download botlist\_webinf\_lib\_072008.tar.gz - this download includes the first set of jar libraries needed to run botlist.  Unzip the archive file and place all of the jar files in the BOTLIST\_WEBAPP\_HOME/WEB-INF/lib directory.
  1. Download botlist\_webinf\_lib\_set2.tar.gz - this download includes the second set of jar libraries needed to run botlist.  Unzip the archive file and place all of the jar files in the BOTLIST\_WEBAPP\_HOME/WEB-INF/lib directory.

If you receive any errors while running botlist, first check if you downloaded all the libraries needed to run the web application.

**As of 7/2008; the following downloads are required**:
(Note: you can also download the libraries from Subversion)

![http://openbotlist.googlecode.com/svn/trunk/openbotlist/docs/media/screenshot_web_inf.png](http://openbotlist.googlecode.com/svn/trunk/openbotlist/docs/media/screenshot_web_inf.png)

  * D1. http://openbotlist.googlecode.com/files/botlist_web_072008.tar.gz
  * D2. http://openbotlist.googlecode.com/files/botlist_webinf_lib_072008.tar.gz
  * D3. http://openbotlist.googlecode.com/files/botlist_webinf_lib_set2.tar.gz
  * Opt1. http://openbotlist.googlecode.com/files/webcrawler_agent.tar.gz
  * Opt2. http://openbotlist.googlecode.com/files/pushsync_agent.tar.gz

### Description of Downloads (as of 7/25/2008) ###

  * D1. **botlist\_web\_072008.tar.gz** - Botlist web front end.  This includes the majority of the web application.  It includes J2EE JSP web application (JSPs, Java source, etc).
  * D2. **botlist\_webinf\_lib\_072008.tar.gz** - Jar files for the WEB-INF/lib directory used to run the web application.
  * D3. **botlist\_webinf\_lib\_set2.tar.gz** - Jar files second set for the WEB-INF/lib directory used to run the web application.
  * Opt1. **webcrawler\_agent.tar.gz** - Optional application, offline RSS web crawler.  Can run this python based application on a remote machine.  Crawls RSS feeds and then stores
  * Opt2. **pushsync\_agent.tar.gz** - Optional application, offline tool for PUSHING/Transmitting data that has been crawled to the web application.

**Subversion WEB-INF/lib directory**

  * Svn1. http://openbotlist.googlecode.com/svn/trunk/openbotlist/WEB-INF/lib/

# Check out source from Subversion #

**As of 2/2/2008**

Checking out the botlist source is the recommended way to get build and run the
application.  If you have access to SVN, use this method but you should also be able to download and run the botlist application from the code.google.com botlist homepage.  In the future, regular releases and snapshots will be available, for now you can retrieve the latest source code.

```
I extracted tomcat to my home directory for development.

tomcat_home = ~/projects/tomcat/tomcat5526

cd ~/projects/tomcat/tomcat5526/webapps

svn co http://openbotlist.googlecode.com/svn/trunk/openbotlist

mv openbotlist botlist 

The project name is called openbotlist, it is best to change the directory
name to just botlist because of URI references to 'botlist' in the web
application.

```

# Run mysqld and setup the database #

Start the mysql daemon and create the databases.

  * mysqld  (leave the daemon running)
  * Open a new shell environment and cd to the tomcat botlist directory
  * example: cd ~/projects/tomcat/tomcat5526/webapps/botlist
  * cd db
  * mysql -uroot (enter the mysql shell)
  * source create\_database.sql;  (create the databases)
  * source create\_tables.sql; (create the tables)
  * source insert\_link\_groups.sql; (addtional step to setup link group table)

```
Example output:

Query OK, 1 row affected (0.00 sec)

Query OK, 1 row affected (0.00 sec)

Query OK, 1 row affected (0.00 sec)

Query OK, 1 row affected (0.00 sec)

mysql> source insert_link_groups.sql;

```

At this point, you have created the MySQL database.

# Build the project #

To build the project, you simply need to enter the botlist web app directory
and invoke the ant command.

  * cd the botlist web application directory
  * example: cd ~/projects/tomcat/tomcat5526/webapps/botlist
  * ant
  * ant tomcat.deploy  (this will copy the java class files to the WEB-INF dir)

```
Example output:

$ ant
Buildfile: build.xml

prepare:
    [mkdir] Created dir: c:\projects\tools\home\projects\tomcat\tomcat5526\webap
ps\botlist\build
    [mkdir] Created dir: c:\projects\tools\home\projects\tomcat\tomcat5526\webap
ps\botlist\build\classes
...
...
```

# Web application database configuration #

To configure the application, you need to set the database
parameters including username and password.

```
cp example_botlist_config.properties botlist_config.properties

Edit the botlist_config.properties file.

botlist.db.url=jdbc:mysql:///openbotlist_development
botlist.username=USER
botlist.password=PASSWORD

```

# Run tomcat and navigate to the botlist site #

At this point, launch the tomcat server.

  * example: cd ~/projects/tomcat/tomcat5526/bin
  * ./startup.sh
  * navigate your browser to: http://127.0.0.1:8080/botlist/

![http://openbotlist.googlecode.com/svn/wiki/imgs/botlist_snapshot_setup1.png](http://openbotlist.googlecode.com/svn/wiki/imgs/botlist_snapshot_setup1.png)

**Resources**

  * http://tomcat.apache.org/tomcat-5.5-doc/index.html
  * http://www.mysql.com/