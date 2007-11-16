/* 
 * BotListGenericUtils.java
 * Nov 16, 2007
 */
package org.spirit.util;

import java.util.Comparator;
import java.util.Iterator;
import java.util.LinkedHashSet;
import java.util.Map;
import java.util.Set;
import java.util.SortedMap;
import java.util.TreeMap;

/**
 * @author bbrown
 */
public class BotListGenericUtils {

	/** inner class to sort map **/
	private static final class ValueComparator implements Comparator {
		private Map data = null;
		public ValueComparator(Map _data) {
			super();
			this.data = _data;
		}
		public int compare(Object o1, Object o2) {
			Integer e1;
			Integer e2;
			e1 = (Integer) this.data.get(o1);
			e2 = (Integer) this.data.get(o2);			
			int res = e1.compareTo(e2);			
			return -(res == 0 ? 1 : res);
		}
	}
	
	public static final Map sortMapByValue(Map inputMap) {
		SortedMap sortedMap = new TreeMap(new BotListGenericUtils.ValueComparator(inputMap));		
		sortedMap.putAll(inputMap);		
		return sortedMap;
	}

	/**
	 * Return a list of key value (instances of map) pairs.
	 * @param inputMap
	 * @return
	 */
	public static final Set keyValueSet(final Map inputMap, final int maxnum) {
		Set set = inputMap.entrySet();
		Set newset = new LinkedHashSet();		
		int i = 0;
		for (Iterator it = set.iterator(); it.hasNext(); i++) {
			newset.add(it.next());
			if (i >= (maxnum - 1)) break;
		}
		return newset;
	}
}
