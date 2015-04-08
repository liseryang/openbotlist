# Project Diary #

**4/4/2008**

More on, what is Botlist?  As I work this tool more, I am starting to figure out what it actually should do?  It is a system for retrieving information.  In this case online content?  Botlist is about online content.  The content data files will always be freely available.  It can also be used for research.  Imagine having a million URLs and statistics associated with that data.

  1. Possible Feature: New GUI toolkit for offline browsing of botlist data and online browsing.  Tools for finding interesting things about the incoming data.
  1. I have neglected to work on the archive system.  But botlist data should be freely available as well as always available.

Botlist source code metrics and statistics.  Here is a set of reports and charts about the project.  They are run against the subversion repository with statsvn.

http://openbotlist.googlecode.com/svn/trunk/openbotlist/docs/media/metrics/set1_april/index.html

**2/18/2008**
**More New task list and priorities**

  1. Build a simple botlist IRC bot, entering new URLs, possibly seed items
  1. RDF specifications for messaging, URL types, foaf, social stats
  1. FOAF indexer
  1. Focus on search and archived dumps - there are two parts to a botlist UI, the front-end and the archived content.  The archived content could contain millions or billions of items.  Should be searchable.


**2/16/2008**

**New task list and priorities**

  1. Change feed item system to postgres / RabbitMQ
  1. Create self links with source as RDF document
  1. Clear older links
  1. Build social (reddit) stat system
  1. Possible crawler with erlang


**12/1/2007**

Added web analytics, statistics page content analysis

**11/14/2007**

Useful idiom in Scala for walking a directory tree, searching for a particular file.  This  code will get added to my botlist help document search system:


```
//
  // Utility for recursively walking directory tree
  // See:
  // override final def flatMap  [B](f : (A) => Iterable[B]) : List[B]
  class DocWalkFile(file: File) {  
	def children = new Iterable[File] {
    def elements = 
      if (file.isDirectory) file.listFiles.elements else Iterator.empty;
	}
	def andTree : Iterable[File] = (
      Seq.single(file) ++ children.flatMap(child => new DocWalkFile(child).andTree))
  }
  def listDocuments(dir: File): List[File] =
	(new DocWalkFile(dir)).andTree.toList filter (f => (f.isFile && f.getName.endsWith(".txt")))
	  
```

Based on code from here:

http://www.rosettacode.org/rosettacode/w/index.php?title=Walk_Directory_Tree

11/5/2007

This falls in the category of off-topic, but this is a bash script that actually works to count lines of source code (tested with cygwin); In this example, I am trying to find the number of TOTAL lines of C code.
```
find . -name '*.c' -exec cat {} \; | wc -l
```

10/29/2007
# Using Factor Language for Botlist Analysis #
> The Botlist data repository is pretty large right now.  There are over 400 thousand links.  I added 50 thousand over the weekend I will try to get to half a million by the end of the week and a million by the end of November.  It doesn't make sense to use some of the mainstream languages that are out there.  The Factor programming language is designed to be fast with speed and reliability in mind, so it would make an ideal tool to analyze the botlist URL data.  I want to look at basic utilities like map-reduce algorithms, fuzzy algorithms, decision tree analysis, and other statistics.  I have only a little code now, but here are some useful Factor notes that I had relearn:  (currently using Factor 0.90+ [the GIT repository](from.md)).
```
Actually launching Factor source with a bash script (0.90+ code):

#!/bin/sh
# 'factor' executable name changed from to 'f' to avoid conflicts
/home/downloads9/factor/f -e='"csvparser" run' -quiet -run=none
# End of Script

My Factor source directory structure:

TOPDIR/
  run.sh (the simple script from above)
  csvparser/
   csvparser-docs.factor
   csvparser-tests.factor
   csvparser.factor (actual factor source code)

Snippet of Factor Source:

: parse-document ( -- )
   "testcsv.txt" <file-reader> csv [ . ] each
   
MAIN: parse-document ;
```

> I know that looks basic, but there are a couple of things going on with that startup script.  First, it assumes that you have a directory structure as I described above.  The "-e" command line switch allows you to run a snippet of factor code at the command-line.  In our example; we want to run a module that has a "MAIN:" definition.  And so there is no confusion are some useful snippets (quoted directly from the Factor source):

  * foo/bar/bar.factor - the source file, defines words in the foo.bar vocabulary
  * foo/bar/bar-docs.factor - documentation, see Writing documentation
  * foo/bar/bar-tests.factor - unit tests, see Unit testing modules
  * foo/bar/summary.txt - a one-line description
  * foo/bar/tags.txt - a whitespace-separated list of tags which classify the vocabulary

Here is the documentation on Factor command-line usage:

```
-e=code This specifies a code snippet to evaluate. 
If you want Factor to exit immediately after, also specify -run=none. 
-run=vocab vocab is the name of a vocabulary with a MAIN: hook to run on startup, 
for example listener, ui or none. 
-no-user-init Inhibits the running of the .factor-rc file 
in the user&apos;s home directory on startup. 
-quiet If set, run-file and require will not print load messages. 
-script Equivalent to -quiet -run=none.
```


# Factor Resources #
  * http://factorcode.org/
  * http://factorcode.org/responder/help/

10/14/2007
> Made some more progress with the ebotlist, yaws, mnesia application including creating a make build file and deployment scripts for deploying the needed files to the yaws ebin, include, and view directories.  These are simple tasks but vital to being able to work with yaws.  In some respects, yaws has some similar traits with a J2EE application.  Especially in terms of separating the application objects (emulator beam files) away from the script server pages (yaws files).
```
The following yaws snippet (server side include) includes the following partial page
 	<erl>
		out(A) -> { yssi, "general/botverse_link_css.yaws" }.
	</erl>
I used the following code, below to return the links in my database

out(Args) ->
	botlist_find_links:find_links(),
	{ html, "Data Results" }.
```

> If you are interested, you can view the full source from the subversion repository.
http://octaned.googlecode.com/svn/trunk/octaned/apps/ebotlist/

> # Launching Yaws for local development #

> It isn't critical, but I had trouble working with the yaws interactive environment.  I would much prefer to launch yaws in daemon code and I am lazy.  Here are a set of alias definitions you can place in your bashrc file (note: you would have to copy exactly)
```
alias yaws='yaws --daemon --id myserver --mnesiadir '\''"/usr/local/var/yaws/db/Mnesia_botlist_nonode"'\'''

alias ykill='yaws --daemon --id myserver --stop'
alias ylogs='tail -n 800 -f /usr/local/var/log/yaws/report.log'
```

10/13/2007
> I am making good progress on converting parts of the botlist project to erlang through yaws and mnesia.  Both projects are amazing in terms of the features they; redundancy, truly concurrent and fast.  The buzz online about Mnesia has remarked that Mnesia doesn't handle large datasets over tens of millions of records.  My response to that is that future mnesia and erlang releases may resolve issue.  Plus, some would argue that MySQL doesn't handle large datasets.
> Here is in essence a simple "find" call with Mnsesia
```
find_links() ->
    F = fun() ->
		WP = mnesia:table_info(entity_links, wild_pattern),
		[EntityLink || EntityLink <- mnesia:match_object(WP)]
        end,
    case mnesia:transaction(F) of
        {atomic, Result}  -> {ok, Result};
        {aborted, Reason} -> {error, Reason}
    end.

```

> Look for project updates associated with the project (ebotlist, erlang botlist).

**Resources**

  * http://blogs.igalia.com (blog by efortunes creator, good yaws/mnesia example)
  * http://erlang.org/documentation/doc-5.0.1/lib/mnesia-3.9.2/doc/index.html