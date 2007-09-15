/**
 * Berlin Brown
 * Nov 9, 2006
 */

package org.spirit.bean.impl;

import java.io.Serializable;
import java.util.List;

import org.spirit.bean.impl.base.BotListBeanBase;

/**
 * This is class is used by botverse.
 * 
 * @author Berlin Brown
 * 
 */

public class BotListCatLinkGroups extends BotListBeanBase implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 6509095735442509973L;
	private String categoryDescr;
	private String categoryColor;
	private String categoryName;
	private List terms;
	
	public String getCategoryColor() {
		return categoryColor;
	}
	public void setCategoryColor(String categoryColor) {
		this.categoryColor = categoryColor;
	}
	public String getCategoryDescr() {
		return categoryDescr;
	}
	public void setCategoryDescr(String categoryDescr) {
		this.categoryDescr = categoryDescr;
	}
	public String getCategoryName() {
		return categoryName;
	}
	public void setCategoryName(String categoryName) {
		this.categoryName = categoryName;
	}
	public List getTerms() {
		return terms;
	}
	public void setTerms(List terms) {
		this.terms = terms;
	}
	/**
	 * Use getCategoryTerm to also return the category name.
	 * 
	 * @return
	 */
	public String getCategoryTerm() {
		return categoryName;
	}	

}
