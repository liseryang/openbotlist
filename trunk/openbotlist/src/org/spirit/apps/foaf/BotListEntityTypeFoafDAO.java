/**
 * Berlin Brown
 * Nov 9, 2006
 */

package org.spirit.apps.foaf;

import java.io.Serializable;
import java.util.Calendar;
import java.util.List;

/**
 * This is class is used by botverse.
 * 
 * @author Berlin Brown
 * 
 */

public interface BotListEntityTypeFoafDAO {

	public List listEntityLinks(final String queryStr);
	public List pageEntityLinks(final String queryStr, final int page, final int pageSize);
	
}
