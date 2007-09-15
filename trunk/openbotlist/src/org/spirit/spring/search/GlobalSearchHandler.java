/**
 * Berlin Brown
 * Copyright (c) 2006 - 2007, Newspiritcompany.com
 *
 * May 13, 2007
 */
package org.spirit.spring.search;

import java.util.ArrayList;
import java.util.List;

import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.index.IndexReader;
import org.apache.lucene.queryParser.MultiFieldQueryParser;
import org.apache.lucene.search.Hits;
import org.apache.lucene.search.IndexSearcher;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.Searcher;
import org.spirit.bean.impl.BotListEntityLinks;

/**
 * This is class is used by botverse.
 * @author Berlin Brown
 *
 */
public class GlobalSearchHandler extends IndexSearchHandler {
		
	public static final String GLOBAL_URL = "url";
	public static final String GLOBAL_TITLE = "title";
	public static final String GLOBAL_CONTENT = "content";
	
	private String [] searchFields = { GLOBAL_CONTENT, GLOBAL_TITLE };
		
	private void setup() {
		this.setNormsField(GLOBAL_CONTENT);
		this.setSearchFields(searchFields);
	}
	
	public List search(String queryLine) throws Exception {
		
		this.setup();
		List res = new ArrayList();
		
		IndexReader reader = this.getNormsReader(this.getGlobalIndexDir());					
		Searcher searcher = new IndexSearcher(reader);
		Analyzer analyzer = new StandardAnalyzer();		
		String [] fields = this.getSearchFields();
		MultiFieldQueryParser parser = new MultiFieldQueryParser( fields, analyzer);
		String finalQuery = queryLine + this.getSearchPostfix();
		Query query = parser.parse(finalQuery);
		Hits hits = searcher.search(query);
		
		//for (int start = 0; start < hits.length(); start += this.hitsPerPage) {
		int start = 0;
		int end = Math.min(hits.length(), start + this.getHitsPerPage());
		for (int i = start; i < end; i++) {
			Document doc = hits.doc(i);			         		    	 	        
			String url = doc.get(GLOBAL_URL);
			String title = doc.get(GLOBAL_TITLE);
			String searchScore = "" + hits.score(i);
			BotListEntityLinks link = new BotListEntityLinks();
			// TODO: remove simple filter with something more robust
			boolean validLink = true;
			if (url != null && (url.toLowerCase().endsWith(".js") || url.toLowerCase().endsWith(".css")))
				validLink = false;
			if (validLink) {
				link.setMainUrl(url);
				link.setUrlTitle(title);
				link.setSearchScore(searchScore);
				res.add(link);
			}
		}	     
		return res;
	}	
}
