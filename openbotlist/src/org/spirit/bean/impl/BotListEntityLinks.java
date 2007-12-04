/* 
 *** Notice Update: 8/14/2007
 *** Copyright 2007 Berlin Brown
 *** Copyright 2006-2007 Newspiritcompany.com
 *** 
 *** This SOURCE FILE is licensed to NEWSPIRITCOMPANY.COM.  Unless
 *** otherwise stated, use or distribution of this program 
 *** for commercial purpose is prohibited.
 *** 
 *** See LICENSE.BOTLIST for more information.
 ***
 *** The SOFTWARE PRODUCT and CODE are protected by copyright and 
 *** other intellectual property laws and treaties. 
 ***  
 *** Unless required by applicable law or agreed to in writing, software
 *** distributed  under the  License is distributed on an "AS IS" BASIS,
 *** WITHOUT  WARRANTIES OR CONDITIONS  OF ANY KIND, either  express  or
 *** implied.
 */

package org.spirit.bean.impl;

import java.io.Serializable;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.spirit.bean.impl.base.BotListBeanBase;
import org.spirit.servlet.bean.BotListConcatValue;
import org.spirit.util.text.TextUtils;

/**
 * This is class is used by botverse.
 * 
 * @author Berlin Brown
 * 
 */
public class BotListEntityLinks extends BotListBeanBase 
		implements Serializable {          
	/**
	 * 
	 */
	private static final long serialVersionUID = -2504255702163561930L;
	public static final int MAX_LEN_HOSTNAME = 40;
	
	private String mainUrl;

	private Calendar createdOn;
	private Date createdOnDate;
	private String keywords;
	private String urlDescription;
	private String urlTitle;
	private List listings;
	private Long commentsCount;
	private Long linkCount;	
	private Long views;
	private Long rating;	
	private String fullName;
	private Long userId;
	private String hostname;
	private String hostnameDisplay;
	private String hostnameDisplayUrl;

	private String searchScore;	
	private String coreUsername;	
	private String linkType;
	private BotListCatLinkGroups linkCategory;
	
	private String generatedUniqueId;
		
	private Long linksCt;
	private Long imageCt;
	private Long metaDescrLen;
	private Long metaKeywordsLen;		
	private Long paraTagCt;
	private Long documentSize;
	private Long requestTime;

	/**
	 * @return the views
	 */
	public Long getViews() {
		return views;
	}
	/**
	 * @param views the views to set
	 */
	public void setViews(Long views) {
		this.views = views;
	}
	/**
	 * @return the linkCount
	 */
	public Long getLinkCount() {
		if (linkCount == null || (linkCount.longValue() < 0)) {
			return new Long(0);
		}
		return linkCount;
	}
	/**
	 * @param linkCount the linkCount to set
	 */
	public void setLinkCount(Long linkCount) {
		this.linkCount = linkCount;
	}
	/**
	 * @return the commentsCount
	 */
	public Long getCommentsCount() {
		if (commentsCount == null || (commentsCount.longValue() < 0)) {
			return new Long(0); 
		}
		return commentsCount;
	}
	/**
	 * @param commentsCount the commentsCount to set
	 */
	public void setCommentsCount(Long commentsCount) {			
		this.commentsCount = commentsCount;
	}
	/**
	 * @return the listings
	 */
	public List getListings() {
		return listings;
	}
	/**
	 * @param listings the listings to set
	 */
	public void setListings(List listings) {
		this.listings = listings;
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
	/**
	 * @return the rating
	 */
	public Long getRating() {
		return rating;
	}
	/**
	 * @param rating the rating to set
	 */
	public void setRating(Long rating) {
		this.rating = rating;
	}
	/**
	 * @return the fullName
	 */
	public String getFullName() {
		return fullName;
	}
	/**
	 * @param fullName the fullName to set
	 */
	public void setFullName(String fullName) {
		this.fullName = fullName;
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
	/**
	 * @return the searchScore
	 */
	public String getSearchScore() {
		return searchScore;
	}
	/**
	 * @param searchScore the searchScore to set
	 */
	public void setSearchScore(String searchScore) {
		this.searchScore = searchScore;
	}
	public String getHostname() {
		return hostname;
	}
	public void setHostname(String hostname) {
		this.hostname = hostname;
	}
	/**
	 * Print the hostname, use the hostname field or create the hostname display
	 * from the main URL field.
	 * 
	 * @see org.spirit.test.java.bean.EntityLinkTest
	 * 
	 * @return
	 */
	public String getHostnameDisplay() {
		this.hostnameDisplay = "";
		String urlHostname = this.getHostname();
		if ((urlHostname != null) && (urlHostname.length() > 0)) {
			this.hostnameDisplay = urlHostname;
		} else {
			this.hostnameDisplay = TextUtils.getHTTPHostname(this.getMainUrl()); 
		}
		this.hostnameDisplay = BotListConcatValue.getMaxWord(this.hostnameDisplay, new Integer(MAX_LEN_HOSTNAME));
		return this.hostnameDisplay;
	}
	public String getHostnameDisplayUrl() {
		this.hostnameDisplayUrl = "";
		String urlHostname = this.getHostname();
		if ((urlHostname != null) && (urlHostname.length() > 0)) {
			this.hostnameDisplayUrl = urlHostname;
		} else {
			this.hostnameDisplayUrl = TextUtils.getHTTPHostname(this.getMainUrl()); 
		}		
		return this.hostnameDisplayUrl;
	}
	public Date getCreatedOnDate() {
		return createdOnDate;
	}
	public void setCreatedOnDate(Date createdOnDate) {
		this.createdOnDate = createdOnDate;
	}
	/**
	 * The core user name is the name associated with the
	 * profile user link.
	 * 
	 * @return
	 */
	public String getCoreUsername() {
		return coreUsername;
	}
	public void setCoreUsername(String coreUsername) {
		this.coreUsername = coreUsername;
	}
	public BotListCatLinkGroups getLinkCategory() {
		return linkCategory;
	}
	public void setLinkCategory(BotListCatLinkGroups linkCategory) {
		this.linkCategory = linkCategory;
	}
	public String getLinkType() {
		return linkType;
	}
	public void setLinkType(String linkType) {
		this.linkType = linkType;
	}
	public String getGeneratedUniqueId() {
		return generatedUniqueId;
	}
	public void setGeneratedUniqueId(String generatedUniqueId) {
		this.generatedUniqueId = generatedUniqueId;
	}
	public Long getImageCt() {
		return imageCt;
	}
	public void setImageCt(Long imageCt) {
		this.imageCt = imageCt;
	}
	public Long getLinksCt() {
		return linksCt;
	}
	public void setLinksCt(Long linksCt) {
		this.linksCt = linksCt;
	}
	public Long getMetaDescrLen() {
		return metaDescrLen;
	}
	public void setMetaDescrLen(Long metaDescrLen) {
		this.metaDescrLen = metaDescrLen;
	}
	public Long getParaTagCt() {
		return paraTagCt;
	}
	public void setParaTagCt(Long paraTagCt) {
		this.paraTagCt = paraTagCt;
	}
	public Long getRequestTime() {
		return requestTime;
	}
	public void setRequestTime(Long requestTime) {
		this.requestTime = requestTime;
	}
	public Long getDocumentSize() {
		return documentSize;
	}
	public void setDocumentSize(Long documentSize) {
		this.documentSize = documentSize;
	}
	public Long getMetaKeywordsLen() {
		return metaKeywordsLen;
	}
	public void setMetaKeywordsLen(Long metaKeywordsLen) {
		this.metaKeywordsLen = metaKeywordsLen;
	}	

}
