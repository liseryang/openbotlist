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

public class BotListChildListLinks extends BotListBeanBase 
		implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -4320299522272098455L;
		private String keywords;
		private Long linkId;
		private String mainUrl;
		private String urlTitle;
		
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
		 * @return the linkId
		 */
		public Long getLinkId() {
			return linkId;
		}
		/**
		 * @param linkId the linkId to set
		 */
		public void setLinkId(Long linkId) {
			this.linkId = linkId;
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
