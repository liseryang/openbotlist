/**
 * Berlin Brown
 * Nov 9, 2006
 */

package org.spirit.apps.foaf;

import java.util.Date;

import org.spirit.form.base.BotListBaseForm;

/**
 * This is class is used by botverse.
 * 
 * @author Berlin Brown
 * 
 */

public class BotListEntityTypeFoafForm extends BotListBaseForm {

	/**
	 * 
	 */
	private static final long serialVersionUID = -8997986929977823041L;
	
	private String foafInterestDescr;
	private Long rating;
	private String fullName;
	private String foafMbox;
	private Date dateOfBirth;
	private String friendSetUid;
	private String foafPageDocUrl;
	private String foafImg;
	private Long processCount;
	private String nickname;
	
	public String getFoafInterestDescr() {
		return foafInterestDescr;
	}
	public void setFoafInterestDescr(String foafInterestDescr) {
		this.foafInterestDescr = foafInterestDescr;
	}
	public Long getRating() {
		return rating;
	}
	public void setRating(Long rating) {
		this.rating = rating;
	}
	public String getFullName() {
		return fullName;
	}
	public void setFullName(String fullName) {
		this.fullName = fullName;
	}
	public String getFoafMbox() {
		return foafMbox;
	}
	public void setFoafMbox(String foafMbox) {
		this.foafMbox = foafMbox;
	}
	public Date getDateOfBirth() {
		return dateOfBirth;
	}
	public void setDateOfBirth(Date dateOfBirth) {
		this.dateOfBirth = dateOfBirth;
	}
	public String getFriendSetUid() {
		return friendSetUid;
	}
	public void setFriendSetUid(String friendSetUid) {
		this.friendSetUid = friendSetUid;
	}
	public String getFoafPageDocUrl() {
		return foafPageDocUrl;
	}
	public void setFoafPageDocUrl(String foafPageDocUrl) {
		this.foafPageDocUrl = foafPageDocUrl;
	}
	public String getFoafImg() {
		return foafImg;
	}
	public void setFoafImg(String foafImg) {
		this.foafImg = foafImg;
	}
	public Long getProcessCount() {
		return processCount;
	}
	public void setProcessCount(Long processCount) {
		this.processCount = processCount;
	}
	public String getNickname() {
		return nickname;
	}
	public void setNickname(String nickname) {
		this.nickname = nickname;
	}

}
