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

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Date;

/** Simple command-line based search demo. */
public class SearchHelpDocs {
	
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
		
		IndexReader reader = IndexReader.open(index);
		if (normsField != null)
			reader = new OneNormsReader(reader, normsField);

		Searcher searcher = new IndexSearcher(reader);
		Analyzer analyzer = new StandardAnalyzer();

		BufferedReader in = null;
		in = new BufferedReader(new InputStreamReader(System.in, "UTF-8"));
		
		String [] fields = { LUC_KEY_CONTENT, LUC_KEY_FULL_PATH };		
		MultiFieldQueryParser parser = new MultiFieldQueryParser( fields, analyzer);
		while (true) {
			// prompt the user			
			System.out.print("Query>>> "); System.out.flush();
			String line = in.readLine();
			if (line == null || line.length() == -1)
				break;
			Object obj = parser.parse(line);			
			Query query = parser.parse(line);
			System.out.println("Searching for: [" + line + "] query=" + query.toString(field));
			System.out.flush();
			Hits hits = searcher.search(query);
			if (repeat > 0) {                           // repeat & time as benchmark
				Date start = new Date();
				for (int i = 0; i < repeat; i++) {
					hits = searcher.search(query);
				}
				Date end = new Date();
				System.out.println("Time: "+(end.getTime()-start.getTime())+"ms");
			}

			System.out.println(hits.length() + " total matching documents");
			final int HITS_PER_PAGE = 10;
			for (int start = 0; start < hits.length(); start += HITS_PER_PAGE) {
				int end = Math.min(hits.length(), start + HITS_PER_PAGE);
				for (int i = start; i < end; i++) {

					System.out.println("doc=" + hits.id(i) + " score="+hits.score(i));

					Document doc = hits.doc(i);
					String path = doc.get(LUC_KEY_CONTENT);
					if (path != null) {						
						System.out.println((i+1) + ". " + path);
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