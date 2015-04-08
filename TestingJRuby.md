# Behavior testing with JRuby/Spring and Hibernate #

# Introduction #

Botlist wouldn't have been possible if it weren't for the "creative" testing used.  Most of the tests aren't low-level, component tests like unit tests (there are some but not many), but the majority of the tests are "behavior-driven" tests.  "By asking questions such as "What should this application do?" or "What should this part do?" For example, the Botverse section of Botlist lists a collection of links that are submitted by the user.  Here is a simple test that tests this particular functionality.  We only focus on the query needed to display the links.

```
def test()
    c = @ac.getBean("radController")
    # Run the standard botverse, entity links query
    dao = c.entityLinksDao
    query = "from org.spirit.bean.impl.BotListEntityLinks as links order by links.createdOn desc"    
    links = dao.pageEntityLinks(query, 0, 4)
    links.each { |eLink|
		puts eLink.urlTitle
    }
    sessFact = dao.sessionFactory
    logStatistics(sessFact)
    logQueryStatistics(sessFact, query)
  end
```

It is a little more complicated than that, but that is in essence some of the tests used.  In the future, I will go over the page request driven tests that actually request a page from from the server.


# Also see (jruby / hibernate source) #

  * [Base Statistics Test (ruby source)](http://openbotlist.googlecode.com/svn/trunk/openbotlist/tests/unit/ruby/BaseStatisticTest.rb)
  * [Use of Statistics Test (ruby source)](http://openbotlist.googlecode.com/svn/trunk/openbotlist/tests/unit/ruby/TestWithStatistics.rb)
  * [Full package with spring/hibernate configuration](http://openbotlist.googlecode.com/svn/trunk/openbotlist/tests/unit/)




