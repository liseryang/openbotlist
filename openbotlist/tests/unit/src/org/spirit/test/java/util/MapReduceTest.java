/* 
 * EntityLinkTest.java
 * Aug 19, 2007
 */
package org.spirit.test.java.util;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import junit.framework.TestCase;

import org.spirit.util.BotListGenericUtils;

/**
 * @author bbrown
 */
public class MapReduceTest extends TestCase {
	
	protected void setUp() {	
	}
	protected void tearDown() {	
	}
	
	public void testMapReduce() {
		List allterms = new ArrayList();
		allterms.add("dog");
		allterms.add("cat");
		allterms.add("chicken");
		allterms.add("dog");
		final Set set = BotListGenericUtils.mapReduce(allterms, 8);
		System.out.println(set);
	}

}
