/**
 * Berlin Brown
 * Nov 9, 2006
 */

package org.spirit.apps.foaf;

import java.util.Calendar;
import java.util.Date;

import org.spirit.form.base.BotListBaseCalcVerify;
import org.spirit.form.base.BotListBaseForm;

/**
 * This is class is used by botverse.
 * 
 * @author Berlin Brown
 * 
 */

public class BotListEntityTypeFoafForm extends BotListBaseForm 
			implements BotListBaseCalcVerify {

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
	
	private Long firstInput;
	private Long secondInput;
	private Long solution;
	private Long userSolution;
	private Long prevSolution;
	
	private String mainUrl;	
	private Calendar createdOn;
	private String keywords;
	private String urlDescription;
	private String urlTitle;
	
	public Calendar getCreatedOn() {
		if (createdOn == null) {
			createdOn = Calendar.getInstance();
		}
		return createdOn;
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
	
	/**
	 * @return the firstInput
	 */
	public Long getFirstInput() {
		return firstInput;
	}

	/**
	 * @param firstInput the firstInput to set
	 */
	public void setFirstInput(Long firstInput) {
		this.firstInput = firstInput;
	}

	/**
	 * @return the prevSolution
	 */
	public Long getPrevSolution() {
		return prevSolution;
	}

	/**
	 * @param prevSolution the prevSolution to set
	 */
	public void setPrevSolution(Long prevSolution) {
		this.prevSolution = prevSolution;
	}

	/**
	 * @return the secondInput
	 */
	public Long getSecondInput() {
		return secondInput;
	}

	/**
	 * @param secondInput the secondInput to set
	 */
	public void setSecondInput(Long secondInput) {
		this.secondInput = secondInput;
	}

	/**
	 * @return the solution
	 */
	public Long getSolution() {
		return solution;
	}

	/**
	 * @param solution the solution to set
	 */
	public void setSolution(Long solution) {
		this.solution = solution;
	}

	/**
	 * @return the userSolution
	 */
	public Long getUserSolution() {
		return userSolution;
	}

	/**
	 * @param userSolution the userSolution to set
	 */
	public void setUserSolution(Long userSolution) {
		this.userSolution = userSolution;
	}

	public String getMainUrl() {
		return mainUrl;
	}

	public void setMainUrl(String mainUrl) {
		this.mainUrl = mainUrl;
	}

	public String getKeywords() {
		return keywords;
	}

	public void setKeywords(String keywords) {
		this.keywords = keywords;
	}

	public String getUrlDescription() {
		return urlDescription;
	}

	public void setUrlDescription(String urlDescription) {
		this.urlDescription = urlDescription;
	}

	public String getUrlTitle() {
		return urlTitle;
	}

	public void setUrlTitle(String urlTitle) {
		this.urlTitle = urlTitle;
	}
	
	
	

}
