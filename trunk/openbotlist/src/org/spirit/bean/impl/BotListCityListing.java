/**
 * Berlin Brown
 * Nov 9, 2006
 */

package org.spirit.bean.impl;

import java.io.Serializable;
import java.util.Calendar;
import java.util.List;

import org.spirit.bean.impl.base.BotListBeanBase;

/**
 * This is class is used by botverse.
 * 
 * @author Berlin Brown
 * 
 */

public class BotListCityListing extends BotListBeanBase  
		implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 125243403721134912L;
	private String cityName;
	private String cityCategory;
	private String stateAbbr;
	private Calendar createdOn;		

	private List listings;

	private Long count;

	/**
	 * @return the count
	 */
	public Long getCount() {
		if (count == null || (count.longValue() < 0)) {
			return new Long(0);
		}

		return count;
	}
	/**
	 * @param count the count to set
	 */
	public void setCount(Long count) {
		this.count = count;
	}
	/**
	 * @return the cityName
	 */
	public String getCityName() {
		return cityName;
	}
	/**
	 * @param cityName the cityName to set
	 */
	public void setCityName(String cityName) {
		this.cityName = cityName;
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
	public String getCityCategory() {
		return cityCategory;
	}
	public void setCityCategory(String cityCategory) {
		this.cityCategory = cityCategory;
	}
	public String getStateAbbr() {
		return stateAbbr;
	}
	public void setStateAbbr(String stateAbbr) {
		this.stateAbbr = stateAbbr;
	}		

}
