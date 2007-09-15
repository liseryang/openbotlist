/**
 * Berlin Brown
 * Nov 9, 2006
 */

package org.spirit.bean.impl;

import java.io.Serializable;

import org.spirit.bean.impl.base.BotListBeanBase;

/**
 * This is class is used by botverse.
 * 
 * @author Berlin Brown
 * 
 */

public class BotListCatGroupTerms extends BotListBeanBase implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 272009100785897212L;
	private String categoryTerm;
	private String categoryName;
	private BotListCatLinkGroups category;
	public String getCategoryName() {
		return categoryName;
	}
	public void setCategoryName(String categoryName) {
		this.categoryName = categoryName;
	}
	public String getCategoryTerm() {
		return categoryTerm;
	}
	public void setCategoryTerm(String categoryTerm) {
		this.categoryTerm = categoryTerm;
	}
	public BotListCatLinkGroups getCategory() {
		return category;
	}
	public void setCategory(BotListCatLinkGroups category) {
		this.category = category;
	}


}
