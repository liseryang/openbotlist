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
public class BotListAclManager extends BotListBeanBase implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -7052426993628713179L;
	private Long aclId;
	private Long userId;
	/**
	 * @return the aclId
	 */
	public Long getAclId() {
		return aclId;
	}
	/**
	 * @param aclId the aclId to set
	 */
	public void setAclId(Long aclId) {
		this.aclId = aclId;
	}
	/**
	 * @return the userId
	 */
	public Long getUserId() {
		return userId;
	}
	/**
	 * @param userId the userId to set
	 */
	public void setUserId(Long userId) {
		this.userId = userId;
	}

}
