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

import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.index.FilterIndexReader;
import org.apache.lucene.index.IndexReader;
import org.apache.lucene.queryParser.MultiFieldQueryParser;
import org.apache.lucene.search.Hits;
import org.apache.lucene.search.IndexSearcher;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.Searcher;

import org.apache.lucene.search.Sort;
import org.apache.lucene.search.SortField;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Date;

/** Simple command-line based search demo. */
public class SearchHelpDocs {
	
    public static final int MAX_LINES_DISPLAY_CONTENT = 12;
    public static final int MAX_COLS_DISPLAY_CONTENT = 60;
    
    public static final int HITS_PER_PAGE = 5;    
    public static final String CMDLINE_PREFIX = "Query>>> ";
    
	private final static String LUC_KEY_FULL_PATH = "full_path";
	private final static String LUC_KEY_FILE_NAME = "file_name";
	private final static String LUC_KEY_CONTENT = "content";
	private final static String LUC_KEY_IDENTITY = "id";
	
	private static class OneNormsReader extends FilterIndexReader {
		private String field;

		public OneNormsReader(IndexReader in, String field) {
			super(in);
			this.field = field;
		}

		public byte[] norms(String field) throws IOException {
			return in.norms(this.field);
		}
	}

	private SearchHelpDocs() {}

	private static void printHelpInformation() {
	    System.out.println(CMDLINE_PREFIX + " Search Help System (Botlist Help Documents)");
	    System.out.println(CMDLINE_PREFIX + " v0.1 [Nov14.2007]");
	    System.out.println(CMDLINE_PREFIX + " At the prompt, enter search help term");	    
	    System.out.println(CMDLINE_PREFIX + " Use :quit to exit command loop.");
	    System.out.println(CMDLINE_PREFIX + " ===================");
	    System.out.flush();        
	}
	
	/**
	 * Default search, sort by score and date
	 */
	private static Sort createSort() throws Exception {
		Sort sort = new Sort();		
		SortField fields [] = {
			SortField.FIELD_SCORE,
			new SortField("yyyymmdd", SortField.STRING, true)
		};
		sort.setSort(fields);
		return sort;
	}
	
	/**
	 * Pretty print content; because of the size of our content in our help documentation,
	 * Only print N (E.g 12) number of lines and based on Y (E.g. 60) number of colummns.
	 */
	private static String prettyPrintContent(final String content) {
	    // Split by newlines, shorten, and then append back together.
	    StringBuffer buf = new StringBuffer();
	    String lines [] = content.split("\n");
	    final int maxLines = (lines.length > MAX_LINES_DISPLAY_CONTENT) ? MAX_LINES_DISPLAY_CONTENT : lines.length;
	    for (int i = 0; i < maxLines; i++) {
	        final String line = lines[i];
	        final int maxColLen = (line.length() > MAX_COLS_DISPLAY_CONTENT) ?  MAX_COLS_DISPLAY_CONTENT : line.length();
	        final String shortline = line.substring(0, maxColLen) + "\n";
	        buf.append(shortline);
	    }
	    return buf.toString();
	}
	
	/** Simple command-line based search demo. */
	public static void main(String[] args) throws Exception {
		
		String usage = "Usage: java SearchFiles index-dir";
		if (args.length != 1) {
			System.out.println(usage);
			System.exit(0);
		}
		String index = args[0];
		String field = LUC_KEY_CONTENT;
		String queries = null;
		int repeat = 0;
		boolean raw = false;
		String normsField = null;
		
		System.out.println("INFO: index-directory=" + index);
		IndexReader reader = IndexReader.open(index);
		if (normsField != null)
			reader = new OneNormsReader(reader, normsField);

		Searcher searcher = new IndexSearcher(reader);
		Analyzer analyzer = new StandardAnalyzer();

		BufferedReader in = null;
		in = new BufferedReader(new InputStreamReader(System.in, "UTF-8"));
		
		String [] fields = { LUC_KEY_CONTENT, LUC_KEY_FULL_PATH, LUC_KEY_FILE_NAME };		
		MultiFieldQueryParser parser = new MultiFieldQueryParser( fields, analyzer);
		
		printHelpInformation();		
		while (true) {
			// prompt the user			
			System.out.print(CMDLINE_PREFIX); System.out.flush();
			String line = in.readLine();
			if (line == null || line.length() < 0)
				break;
			if (line.trim().length() == 0) {
			    continue;
			}
			// Exit gracefully.
			if (line.trim().equalsIgnoreCase(":quit")) {
			    System.out.println("INFO: quit successful");
			    break;
			}
			
			// Modify for fuzzy query (E.g. ~0.58), also use wildcard postfix (*)
			line = line + "~";
			Object obj = parser.parse(line);			
			Query query = parser.parse(line);
			System.out.println(CMDLINE_PREFIX + "Searching for: [" + line + "] query=" + query.toString(field));
			System.out.flush();
			// Search and also add the sort element
			Hits hits = searcher.search(query, createSort());
			if (repeat > 0) {
				Date start = new Date();
				for (int i = 0; i < repeat; i++) {
					hits = searcher.search(query);
				}
				Date end = new Date();
				System.out.println(CMDLINE_PREFIX + "Time: "+(end.getTime()-start.getTime())+"ms");
			}
			System.out.println(hits.length() + " total matching documents");			
			for (int start = 0; start < hits.length(); start += HITS_PER_PAGE) {
				int end = Math.min(hits.length(), start + HITS_PER_PAGE);
				for (int i = start; i < end; i++) {

					System.out.println(CMDLINE_PREFIX + "doc=" + hits.id(i) + " score="+hits.score(i));
					
					// Ignore scores based on a certain threshold
					if (hits.score(i) < 0.09) continue;
					
					Document doc = hits.doc(i);
					String path = doc.get(LUC_KEY_CONTENT);
					if (path != null) {
					    // Attempt to pretty print help document information
					    System.out.println("\n == Help Document Found; docid=" + hits.id(i));
					    System.out.println("*************************");					    
						String fullpath = doc.get(LUC_KEY_FULL_PATH);
						String filename = doc.get(LUC_KEY_FILE_NAME);
						String content = doc.get(LUC_KEY_CONTENT);
						String id = doc.get(LUC_KEY_IDENTITY);
						if (filename != null) {
							System.out.println("   +Filename: " + doc.get(filename));
						}
						if (fullpath != null) {
							System.out.println("   +Path: " + doc.get(fullpath));
						}
						System.out.println("   id: " + id);
						System.out.println(" == Content:");
						System.out.println(prettyPrintContent(content));
						System.out.println("-------------------------");
						
						System.out.println();
					} else {
						System.out.println((i+1) + ". " + "No content for this document");
					}
				}
				if (queries != null)                      // non-interactive
					break;
				if (hits.length() > end) {
					System.out.print("more (y/n) ? ");
					line = in.readLine();
					if (line.length() == 0 || line.charAt(0) == 'n')
						break;
				}
			}
		}
		reader.close();
	}
}