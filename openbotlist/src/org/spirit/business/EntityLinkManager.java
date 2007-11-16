/* 
 * EnityLinkManager.java
 * Nov 16, 2007
 */
package org.spirit.business;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.spirit.bean.impl.BotListEntityLinks;
import org.spirit.dao.BotListEntityLinksDAO;
import org.spirit.util.BotListGenericUtils;

/**
 * @author bbrown
 */
public class EntityLinkManager {

	/** 
	 * Return all links found in the last 24 hours.	 
	 */
	public static List readLinksForDay(final BotListEntityLinksDAO dao) {
		// Return current time.
		Calendar curCal = Calendar.getInstance();		
		curCal.add(Calendar.DATE, 0);
		return dao.readListingOnDate(curCal);
	}
	
	/**
	 * Map and Reduce all entity link keywords.
	 */
	public static Set mapReduceLinkKeywords(final BotListEntityLinksDAO dao) {
		List allterms = new ArrayList();
		List list = readLinksForDay(dao);
		for (Iterator it = list.iterator(); it.hasNext();) {
			BotListEntityLinks link = (BotListEntityLinks) it.next();
			final String keywords = link.getKeywords();
			final String[] words = keywords.split(" ");
			for (int i = 0; i < words.length; i++) {
				allterms.add(words[i]);
			}
		} // End of For				
		Map map = new HashMap();
		for (Iterator x2it = allterms.iterator(); x2it.hasNext();) {
			final String term = (String) x2it.next();
			if (term.length() == 0) continue;
			Integer ct = (Integer) map.get(term);
			if (ct == null) {
				map.put(term, new Integer(0));
			} else {
				map.put(term, new Integer(ct.intValue() + 1));
			} // End of if - else			
		} // End of the for						
		Map sortedMap = BotListGenericUtils.sortMapByValue(map);	
		return BotListGenericUtils.keyValueSet(sortedMap, 8);
	}
}
