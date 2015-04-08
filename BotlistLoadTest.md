# Description #

During the development of Botlist, it became necessary to create a testing framework  that would crawl various pieces of the application and extract response/time data and other various pieces of information. Here is the source and executable of that framework. It is a java based tool and highly configurable.  It will not be as robust as grinder or other tools, but still useful for resting anyway.

# Cont #

The following is a simple java based system for testing the responses from a web servlet  or servlet engine like tomcat. Currently, it has minimal support for SSL/HTTPS connectivity, cookies, sessions,caching of responses, script file for request workflow.

Source is provided (see LoadTestManager.java) and totals only 2000 lines of java source. I would also suggest using this library along with a JVM languagelike JRuby or Jython.

# Usage #

Create a script to launch
(include the following libraries in your classpath, botlistloadtest.jar, ibatis-2.3.0.677.jar, jruby.jar, lucene-core-2.1.0.jar)

```
org.spirit.loadtest.LoadTestManager -f testclient.properties
```

See the Win32 example:
Launch load\_test.bat

Or, you change directory to the 'bin' directory to see a JRuby based load test example.

# Download #

http://openbotlist.googlecode.com/files/botloadtest_v01.zip