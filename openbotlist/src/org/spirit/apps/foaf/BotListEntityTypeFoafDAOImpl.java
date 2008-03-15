/**
 * Berlin Brown
 * Nov 9, 2006
 */

package org.spirit.apps.foaf;

import java.util.List;

import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.springframework.orm.hibernate3.HibernateCallback;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

/**
 * This is class is used by botverse.
 * 
 * @author Berlin Brown
 * 
 */

public class BotListEntityTypeFoafDAOImpl 
		extends HibernateDaoSupport implements BotListEntityTypeFoafDAO {
	
	public static final int MAX_DAO_RESULTS = 400; 
	public static final int MAX_MAX_RESULTS = 2000;
	
	/**
	 * @see org.spirit.dao.BotListUserLinkDAO#createLink(org.spirit.bean.impl.BotListUserLink)
	 */
	public void createLink(BotListEntityTypeFoaf link) {
		getHibernateTemplate().saveOrUpdate(link);
	}
	
	/**
	 * @see org.spirit.dao.BotListEntityLinksDAO#listEntityLinks(java.lang.String)
	 */
	public List listEntityLinks(final String queryStr) {
		return getHibernateTemplate().executeFind(
				new HibernateCallback() {
					public Object doInHibernate(Session session) throws HibernateException {
						Query query = session.createQuery(queryStr);

						// Set the maximum results
						query.setMaxResults(MAX_DAO_RESULTS);
						List data = query.list();						
						return data;
					}
				});		
	}
	
	/**
	 * List the Entity Links including paging the results.
	 */
	public List pageEntityLinks(final String queryStr, final int page, final int pageSize) {
		return getHibernateTemplate().executeFind(
				new HibernateCallback() {
					public Object doInHibernate(Session session) throws HibernateException {
						Query query = session.createQuery(queryStr);
						
						// Set the maximum results
						query.setFirstResult(page * pageSize);						
						query.setMaxResults(pageSize);
						List data = query.list();						
						return data;
					}
				});		
	}
	
}
