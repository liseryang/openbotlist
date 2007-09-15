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

public class BotListActiveMediaFeeds extends BotListBeanBase implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 5206489903364824572L;
	private String displayType;
	private BotListMediaFeeds media;
	
	public String getDisplayType() {
		return displayType;
	}
	public void setDisplayType(String displayType) {
		this.displayType = displayType;
	}
	public BotListMediaFeeds getMedia() {
		return media;
	}
	public void setMedia(BotListMediaFeeds media) {
		this.media = media;
	}


}
