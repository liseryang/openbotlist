//************************************************
//* Copyright (c) 2007 Newspiritcompany.com.  All Rights Reserved
//* 
//* Created On: 11/6/2007
//* 
//* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
//* "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
//* LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
//* A PARTICULAR PURPOSE ARE DISCLAIMED.
//* 
//* (see /LICENSE for more details)
//************************************************
//
// Author: Berlin Brown
// Description: Utility for indexing (source code in scala) developer help
// documents with Lucene.
//
// Specification:
// * Index simple text based help documents, loaded from a input directory
// * Developer should be able to query documents through command-line interface
// * Shall be able to load text help document in the command-line interface
//   based on a search query term.

import scala.Console
import scala.io.Source
import java.io._

import org.apache.lucene._
import org.apache.lucene.document._
import org.apache.lucene.index._
import org.apache.lucene.analysis.standard._
import org.apache.lucene.document.{Document => LucDocument}

object BotlistIndexDocuments {
   
  val LUC_KEY_FULL_PATH = "full_path"
  val LUC_KEY_FILE_NAME = "file_name"
  val LUC_KEY_CONTENT = "content"
  val LUC_KEY_IDENTITY = "id"
  
    //
  // Read the content file.  The first line should contain
  // a "#title summary" line and the rest of the document
  // will contain the "wiki" document.
  class ContentReader(filename: String) {
    def readFile(): (String, String) = {
      val file = Source.fromFile(filename)
      var counted = file.getLines.counted
      val fileData = new StringBuilder()
      var title = ""
      counted.foreach { (line: String) =>
		if (counted.count == 0) {
	      //title = line.substring(6).trim()
		  title = line
		} else { 
	      fileData.append(line)
		}
      }
      (title, fileData.toString())
    }
  } // End of Class //

  case class DocumentLink(abs_path: String, file: String, data: String,
						  unique_id:String) {
    val fullPath = abs_path
    val filename = file
	val content = data
    val id = unique_id
  }
  def indexData(writer:IndexWriter, file: File) {
    val doc = new LucDocument()
	
	// Read the content from the file
	val contentReader = new ContentReader(file.getAbsolutePath)
    val (title, content) = contentReader.readFile()

	// Extract data from the java File class
	val link = new DocumentLink(file.getAbsolutePath, file.getName,
							content, file.getAbsolutePath)
	
	// Index the document and data.
    doc.add(new Field(LUC_KEY_FULL_PATH, link.fullPath, 
					  Field.Store.YES, Field.Index.TOKENIZED))
    doc.add(new Field(LUC_KEY_FILE_NAME, link.filename, 
					  Field.Store.YES, Field.Index.TOKENIZED))
	doc.add(new Field(LUC_KEY_CONTENT, link.content, 
					  Field.Store.YES, Field.Index.TOKENIZED))
    doc.add(new Field(LUC_KEY_IDENTITY, link.id, 
					  Field.Store.YES, Field.Index.UN_TOKENIZED))
    writer.addDocument(doc)
  }
  
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
	(new DocWalkFile(dir)).andTree.toList filter (f => (f.getName.endsWith(".java") || f.getName.endsWith(".txt")))
	  
  def indexDocuments(index_dir: File, files: List[File]) {
    val writer = new IndexWriter(index_dir, new StandardAnalyzer(), true)
    for (val file <- files) {
      indexData(writer, file)
    }
  } 
  def main(args: Array[String]): Unit = {
    
    if (args.length != 2) {
      Console.println("usage: java BotlistIndexDocuments parent-index-dir input-doc-dir")
	  Console.println("\n")
	  Console.println("\nRun the BotlistIndexDocuments index tool on the provided index directory.")
	  Console.println("\nFor bug reporting instructions, please see:")
	  Console.println("<URL:http://code.google.com/p/openbotlist>.")
      return
    }

    Console.println("INFO: Indexing Document Data <standby> ...")
    val index = new File(args(0) + "/index")
	val doc_dir = new File(args(1)) 
    if (!index.exists()) {
      index.mkdir();
      Console.println("Creating index directory.")
    } else {
      Console.println("WARN: Index already exists (remove directory to continue)")
      Console.println("DIR: " + index.getAbsolutePath())
      //return
    }
	
	// Calculate the processing time to run application
    val timeStart = System.currentTimeMillis()
    indexDocuments(index, (listDocuments(doc_dir)))
    val timeEnd = System.currentTimeMillis()
    Console.println("Done...")
    Console.println("Completed processing in " + (timeEnd - timeStart) + " ms.")
  }
}

/// End of the file
