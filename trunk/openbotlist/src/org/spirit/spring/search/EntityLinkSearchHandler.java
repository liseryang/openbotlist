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
import org.apache.lucene.search.Sort;
import org.apache.lucene.search.SortField;
import org.spirit.bean.impl.BotListEntityLinks;
import org.spirit.spring.errors.InvalidBusinessObjectException;

/**
 * This is class is used by botverse.
 * @author Berlin Brown
 *
 */
public class EntityLinkSearchHandler extends IndexSearchHandler {
	
	public List searchScore(String queryLine) throws Exception {
		return this.search(queryLine, null);
	}
	
	/**
	 * Default search, sort by score and date
	 */
	public List search(String queryLine) throws Exception {
		Sort sort = new Sort();		
		SortField fields [] = {
			SortField.FIELD_SCORE,
			new SortField("yyyymmdd", SortField.STRING, true)
		};
		sort.setSort(fields);
		return this.search(queryLine, sort);
	}
	
	public List search(String queryLine, Sort sort) throws Exception {

		List res = new ArrayList();
		IndexReader reader = this.getNormsReader(this.getIndexDir());			
		if (this.getEntityLinksDao() == null) {
			throw new InvalidBusinessObjectException("Invalid Search Handler (error with entity link DAO bean.");
		}
		Searcher searcher = new IndexSearcher(reader);
		Analyzer analyzer = new StandardAnalyzer();

		String [] fields = this.getSearchFields();
		MultiFieldQueryParser parser = new MultiFieldQueryParser( fields, analyzer);
		String finalQuery = queryLine + this.getSearchPostfix();
		Query query = parser.parse(finalQuery);
		
		Hits hits = null;
		if (sort != null)
			hits = searcher.search(query, sort);
		else
			hits = searcher.search(query);			
		
		//for (int start = 0; start < hits.length(); start += this.hitsPerPage) {
		int start = 0;
		int end = Math.min(hits.length(), start + this.getHitsPerPage());
		for (int i = start; i < end; i++) {
			Document doc = hits.doc(i);
			//String userName = doc.get(USER_NAME);
			//String title = doc.get(URL_TITLE);	         		    	 	        	
			String id = doc.get(IDENTITY);
			String searchScore = "" + hits.score(i);
			BotListEntityLinks link = this.getEntityLinksDao().readLinkListing(id);
			link.setSearchScore(searchScore);
			res.add(link);
		}	     
		return res;
	}	
}
