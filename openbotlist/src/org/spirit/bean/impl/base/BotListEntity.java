/**
 * Berlin Brown
 * Dec 25, 2006
 */
package org.spirit.bean.impl.base;

import java.io.Serializable;
import java.util.Calendar;

/**
 * This is class is used by botverse.
 * @author Berlin Brown
 *
 */
public abstract class BotListEntity extends BotListBeanBase 
		implements Serializable { 
		
	private Calendar createdOn;
	private Calendar updatedOn;
	private Long id;	
	private String mainUrl;
	private String keywords;
	private String urlDescription;
	private String urlTitle;	
	
	public Calendar getUpdatedOn() {
		return updatedOn;
	}
	public void setUpdatedOn(Calendar updatedOn) {
		this.updatedOn = updatedOn;
	}
	/**
	 * @return the createdOn
	 */
	public Calendar getCreatedOn() {
		if (createdOn == null) {
			createdOn = Calendar.getInstance();
		}
		return createdOn;
	}
	/**
	 * @param createdOn the createdOn to set
	 */
	public void setCreatedOn(Calendar createdOn) {
		this.createdOn = createdOn;
	}
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	
	/**
	 * @return the keywords
	 */
	public String getKeywords() {
		return keywords;
	}
	/**
	 * @param keywords the keywords to set
	 */
	public void setKeywords(String keywords) {
		this.keywords = keywords;
	}
	/**
	 * @return the mainUrl
	 */
	public String getMainUrl() {
		return mainUrl;
	}
	/**
	 * @param mainUrl the mainUrl to set
	 */
	public void setMainUrl(String mainUrl) {
		this.mainUrl = mainUrl;
	}
	/**
	 * @return the urlDescription
	 */
	public String getUrlDescription() {
		return urlDescription;
	}
	/**
	 * @param urlDescription the urlDescription to set
	 */
	public void setUrlDescription(String urlDescription) {
		this.urlDescription = urlDescription;
	}
	/**
	 * @return the urlTitle
	 */
	public String getUrlTitle() {
		return urlTitle;
	}
	/**
	 * @param urlTitle the urlTitle to set
	 */
	public void setUrlTitle(String urlTitle) {
		this.urlTitle = urlTitle;
	}
	
}
