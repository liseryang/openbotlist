/* 
 * GenericRuntimeJDBCDaoI.java
 * Apr 12, 2008
 */
package org.spirit.apps.jdbc;

import java.util.Collection;

import javax.sql.DataSource;

/**
 * @author bbrown
 */
public interface IGenericRuntimeJDBCDao {

    public void setDataSource(DataSource dataSource);            
    public int jdbcUpdateInsert(final String update_sql, final Object[] parm_values);    
    public int jdbcQueryForInt(final String count_sql);
    public Collection jdbcQuerySystemFeedItems(final String sql);
    
}
