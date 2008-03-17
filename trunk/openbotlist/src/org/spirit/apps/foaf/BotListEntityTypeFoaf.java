/**
 * Berlin Brown
 * Nov 9, 2006
 */

package org.spirit.apps.foaf;

import java.io.Serializable;
import java.util.Date;

import org.spirit.bean.impl.base.BotListEntity;

/**
 * This is class is used by botverse.
 * 
 * Fields included from the Entity base class.
 * -------------------------- 
 *  String generatedUniqueId;    
 *	Calendar createdOn;
 *	Calendar updatedOn;
 *	Long id;	
 *	String mainUrl;
 *	String keywords;
 *	String urlDescription;
 *	String urlTitle;	
 *
 * @author Berlin Brown
 * 
 */
public class BotListEntityTypeFoaf extends BotListEntity implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -2800491702537719907L;	                            	        
	
	private String foafInterestDescr;
	private Long rating;
	private Long views;
	private Long userId;
	private String fullName;
	private String foafMbox;
	
	private Date dateOfBirth;
	private String friendSetUid;
	private String foafPageDocUrl;
	private String foafImg;
	private Long processCount;
	private String nickname;
	private String foafName;
	
	private Long requestTime;
	private String httpStatusCode;
	
	public String toString() {
		StringBuffer buf = new StringBuffer();
		buf.append("#BotListEntityTypeFoaf: mainUrl=" + this.getMainUrl() + " nickname=" + this.getNickname() + " title=" + this.getUrlTitle());
		return buf.toString();
	}
	
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
	public Long getViews() {
		return views;
	}
	public void setViews(Long views) {
		this.views = views;
	}
	public Long getUserId() {
		return userId;
	}
	public void setUserId(Long userId) {
		this.userId = userId;
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
	public String getFoafName() {
		return foafName;
	}
	public void setFoafName(String foafName) {
		this.foafName = foafName;
	}
	public Long getRequestTime() {
		return requestTime;
	}
	public void setRequestTime(Long requestTime) {
		this.requestTime = requestTime;
	}
	public String getHttpStatusCode() {
		return httpStatusCode;
	}
	public void setHttpStatusCode(String httpStatusCode) {
		this.httpStatusCode = httpStatusCode;
	}
	

}
