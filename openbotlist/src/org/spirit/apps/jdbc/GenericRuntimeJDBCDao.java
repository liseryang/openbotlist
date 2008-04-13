/* 
 * GenericRuntimeJDBCDaoI.java
 * Apr 12, 2008
 */
package org.spirit.apps.jdbc;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;

import javax.sql.DataSource;

import org.spirit.apps.system.SystemFeedItemsType;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

/**
 * Use the generic jdbc dao class to access the botlist application with spring jdbc template calls.
 * References:
 * [1] http://static.springframework.org/spring/docs/2.0.x/reference/jdbc.html  
 * @author bbrown
 */
public class GenericRuntimeJDBCDao implements IGenericRuntimeJDBCDao {
	
	private JdbcTemplate jdbcTemplate;

    public void setDataSource(DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
    }
    
    /**
     * Perform an insert or update jdbc SQL query.
     * 
     * <code>
     * Example SQL:
     * "insert into t_actor (first_name, surname) values (?, ?)"
     * </code>
     * @param update_sql
     * @param parm_values
     */
    public int jdbcUpdateInsert(final String update_sql, final Object[] parm_values) {
    	if (this.jdbcTemplate == null) {
    		return -1;
    	}
    	return this.jdbcTemplate.update(update_sql, parm_values);    
    }
    
    /**
     *   id
	 *	 main_url       
	 *	 url_title      
	 *	 url_description
	 *	 url_source     
	 *	 process_count  
	 *	 created_on     
	 *	 hostname       
	 *	 enum_proc_type 
     *
     * @param update_sql
     * @param feed_items
     * @return
     */
    public int jdbcInsertFeedItems(final String update_sql, final SystemFeedItemsType feed_items) {
    	if (this.jdbcTemplate == null) {
    		return -1;
    	}
    	final Object [] data = new Object[6];
    	data[0] = feed_items.getMainUrl();
    	data[1] = feed_items.getUrlTitle();
    	data[2] = feed_items.getUrlDescription();
    	data[3] = feed_items.getUrlSource();
    	data[4] = feed_items.getCreatedOn();
    	data[5] = feed_items.getHostname();    	
    	
    	return this.jdbcTemplate.update(update_sql, data);
    }
    
    /**
     * Perform an insert or update jdbc SQL query.
     * 
     * <code>
     * Example SQL:
     * select count(0) from t_accrual
     * </code>
     */
    public int jdbcQueryForInt(final String count_sql) {
    	if (this.jdbcTemplate == null) {
    		return -1;
    	}
    	int rowCount = this.jdbcTemplate.queryForInt(count_sql);
    	return rowCount;
    }
    
    /**
     * select first_name, surname from t_actor"
     * 
     * @param count_sql
     * @return
     */
    public Collection jdbcQuerySystemFeedItems(final String sql) {
    	if (this.jdbcTemplate == null) {
    		return new ArrayList();
    	}
    	Collection feed_items = this.jdbcTemplate.query(
    		    sql,
    		    new RowMapper() {
    		        public Object mapRow(ResultSet rs, int rowNum) throws SQLException {
    		        	SystemFeedItemsType feed_item = new SystemFeedItemsType();
    		        	feed_item.setId(new Long(rs.getLong("id")));
    		        	feed_item.setMainUrl(rs.getString("main_url"));    		        	
    		            return feed_item;
    		        }
    		    });
    	return feed_items;
    }
    
}
