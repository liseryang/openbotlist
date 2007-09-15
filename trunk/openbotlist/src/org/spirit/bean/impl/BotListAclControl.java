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

public class BotListAclControl extends BotListBeanBase implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -2431087416714266287L;
	private String controlName;
	private String shortDescr;
	private String longDescr;
	private String controlUid;
	/**
	 * @return the controlName
	 */
	public String getControlName() {
		return controlName;
	}
	/**
	 * @param controlName the controlName to set
	 */
	public void setControlName(String controlName) {
		this.controlName = controlName;
	}
	/**
	 * @return the controlUid
	 */
	public String getControlUid() {
		return controlUid;
	}
	/**
	 * @param controlUid the controlUid to set
	 */
	public void setControlUid(String controlUid) {
		this.controlUid = controlUid;
	}
	/**
	 * @return the longDescr
	 */
	public String getLongDescr() {
		return longDescr;
	}
	/**
	 * @param longDescr the longDescr to set
	 */
	public void setLongDescr(String longDescr) {
		this.longDescr = longDescr;
	}
	/**
	 * @return the shortDescr
	 */
	public String getShortDescr() {
		return shortDescr;
	}
	/**
	 * @param shortDescr the shortDescr to set
	 */
	public void setShortDescr(String shortDescr) {
		this.shortDescr = shortDescr;
	}


}
