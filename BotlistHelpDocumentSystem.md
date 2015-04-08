# Introduction #

This is a small utility for indexing developer help documents with Lucene.  And because some botlist documents have already been indexed, you can use it to search some of those example docs.

# Specification #

  * Index simple text based help documents, loaded from a input directory (placed in input\_docs directory)
  * Developer should be able to query documents through command-line interface
  * Developer shall be able to load a particular text help document through the command-line interface based on a search query term.

# Purpose #

Typically, a developer will put documentation last on their list of things to do.  They may go so far as to document their source, but they probably have neglected to create external documentation to help users or aid other developers that may maintain their project in the future.  This is especially true for open source projects.  I developed this very simple approach for dropping simple text files in a directory than with Lucene indexing to be searched later.  For example, I can create simple 5-10 line text documents to describe a particular piece of functionality:

```
Whatisbotlist.txt:

What is the purpose of botlist?

Botlist is an online news aggregation application.
```

Put this file in the input\_docs directory, re-index the directory and then I am able to search for fuzzy terms associated with documents as they are added.  (E.g. I might search 'purpose' in the example above.  As a side-note, this application and example were put together over the course of about 12 hours, only skimming the surface of how useful this approach can be to your project.  For example, you may a small utility around a web application or some other document management system.

# Usage #

There are two executable bash scripts located in the bin directory of the project; **bothelp.sh** and **helpindex.sh**.

Use 'bothelp.sh' to actually search for a particular term and 'helpindex.sh' to actually index the documents in the **runtime/input\_docs**:

```
 $ bin/bothelp.sh
 
Query>>>  Search Help System (Botlist Help Documents)
Query>>>  v0.1 [Nov14.2007]
Query>>>  At the prompt, enter search help term
Query>>>  Use :quit to exit command loop.
Query>>>  ===================
Query>>>String
```

# Short Description of the Source #

There are actually only two source files used to build this application; 200 lines of Scala source in the indexing application and 200 lines in the command-line tool.

The scala object's purpose is only to walk a particular directory finding help document files we are interested in (txt, java, ruby, python) files and then indexing the files using the Lucene classes:

# Walk a directory tree with Scala and Extract the Content #

```
 class DocWalkFile(file: File) {  
	def children = new Iterable[File] {
    def elements = 
      if (file.isDirectory) file.listFiles.elements else Iterator.empty;
	}
	def andTree : Iterable[File] = (
      Seq.single(file) ++ children.flatMap(child => new DocWalkFile(child).andTree))
  }
  def listDocuments(dir: File): List[File] =
	(new DocWalkFile(dir)).andTree.toList filter (f => (f.getName.endsWith(".java")))

```

# Read all the content in a file #
```
 class ContentReader(filename: String) {
    def readFile(): (String, String) = {
      val file = Source.fromFile(filename)
      var counted = file.getLines.counted
      val fileData = new StringBuilder()
      var title = ""
      counted.foreach { (line: String) =>
		if (counted.count == 0) {
	      //title = line.substring(6).trim()
		  title = "none"
		  fileData.append(line)
		} else { 
	      fileData.append(line)
		}
      }
      (title, fileData.toString())
    }
  } // End of Class //
```

# Index the help document content #
```
 def indexData(writer:IndexWriter, file: File) {
    val doc = new Document()
	
	// Read the content from the file
	val contentReader = new ContentReader(file.getAbsolutePath)
    val (title, content) = contentReader.readFile()

	// Extract data from the java File class
	val link = new DocumentLink(file.getAbsolutePath, file.getName,
							content, file.getAbsolutePath)

	// Index the doc create date also
	indexDocDateContent(doc, new Date(file.lastModified))

	// Index the document and data.
	Console.println(link.fullPath)
    doc.add(new Field(LUC_KEY_FULL_PATH, link.fullPath, Field.Store.YES, Field.Index.TOKENIZED))
    doc.add(new Field(LUC_KEY_FILE_NAME, link.filename, Field.Store.YES, Field.Index.TOKENIZED))
	doc.add(new Field(LUC_KEY_CONTENT, link.content, Field.Store.YES, Field.Index.TOKENIZED))
    doc.add(new Field(LUC_KEY_IDENTITY, link.id, Field.Store.YES, Field.Index.UN_TOKENIZED))
    writer.addDocument(doc)
  }
```

# Java source #

Actually, the java source is not that exciting.  It is a basic command loop; the user enters a particular string and takes that value to run against the index directory.  You can see the source here:

http://openbotlist.googlecode.com/svn/trunk/botlistprojects/botlistdocs/src/java/SearchHelpDocs.java

# Source and Application Download #

http://openbotlist.googlecode.com/files/botlistdocs.zip

The full source code can be found in this subversion repository:

http://openbotlist.googlecode.com/svn/trunk/botlistprojects/botlistdocs/

# Demo screenshots of typical usage #

As mentioned before, there are only a couple of steps involved to use this application and this doesn't differ too much from how you would normally use the Lucene library.  Create a document, index the document and search.  Here are some screenshots depicting some of the scenarios.

http://openbotlist.googlecode.com/svn/trunk/botlistprojects/botlistdocs/media/help3.PNG

http://openbotlist.googlecode.com/svn/trunk/botlistprojects/botlistdocs/media/help4.PNG

http://openbotlist.googlecode.com/svn/trunk/botlistprojects/botlistdocs/media/help5.PNG

http://openbotlist.googlecode.com/svn/trunk/botlistprojects/botlistdocs/media/help6.PNG

http://openbotlist.googlecode.com/svn/trunk/botlistprojects/botlistdocs/media/help7.PNG

# Source #

The full source code can be found in this subversion repository:

http://openbotlist.googlecode.com/svn/trunk/botlistprojects/botlistdocs/

# Author and Contact #

Berlin Brown (google it) - 11/14/2007