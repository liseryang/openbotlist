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
package org.spirit.spring;

import java.util.Collection;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.spirit.bean.impl.BotListAdminMainBanner;
import org.spirit.contract.BotListContractManager;
import org.spirit.dao.BotListActiveMediaFeedsDAO;
import org.spirit.dao.BotListAdminMainBannerDAO;
import org.spirit.dao.BotListCityListingDAO;
import org.spirit.dao.BotListCoreSettings;
import org.spirit.dao.BotListCoreUsersDAO;
import org.spirit.dao.BotListEntityLinksDAO;
import org.spirit.dao.BotListMediaFeedsDAO;
import org.spirit.dao.BotListProfileSettingsDAO;
import org.spirit.dao.BotListSearchQueryFiltersDAO;
import org.spirit.dao.BotListUserSearchDAO;
import org.spirit.form.BotListUserSearchForm;
import org.spirit.spring.search.EntityLinkSearchHandler;
import org.spirit.spring.search.IndexSearchHandler;
import org.spirit.util.BotListCookieManager;
import org.spirit.util.BotListSessionManager;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

/**
 * This is class is used by botverse.
 * @author Berlin Brown
 *
 */
public class BotListIndexController extends SimpleFormController {
	
	private Log log = LogFactory.getLog(getClass());
	
	/**
	 * Default Result View.
	 */
	public static final String DEFAULT_RESULT_VIEW = "search/results";
	
	public static final String ERROR_RESULT_VIEW = "search/invalidsearch";
	
	public static final int MAX_HOME_LINKS = 10;
	
	/**
	 * City Listing.
	 */
	private BotListCityListingDAO cityListingDao = null;
	
	private BotListEntityLinksDAO entityLinksDao = null;
	
	private BotListUserSearchDAO userSearchDao = null;
	
	private BotListAdminMainBannerDAO adminMainBannerDao = null;
	
	private BotListCoreSettings coreSettings = null;
	
	private BotListMediaFeedsDAO mediaFeedsDao = null;
	
	private BotListActiveMediaFeedsDAO activeMediaFeedsDao = null;
	
	private BotListSearchQueryFiltersDAO searchQueryFiltersDao = null;
	
	private BotListCoreUsersDAO coreUsersDao = null;
	
	private BotListProfileSettingsDAO profileSettingsDao = null;
	
	/**
	 * Access the BotList Ruby DAO Handler.
	 */
	private BotListRubyDAOHandler handler;
	
	/**
	 * @return the handler
	 */
	public BotListRubyDAOHandler getHandler() {
		return handler;
	}


	/**
	 * @param handler the handler to set
	 */
	public void setHandler(BotListRubyDAOHandler handler) {
		this.handler = handler;
	}


	/**
	 * @return the cityListingDao
	 */
	public BotListCityListingDAO getCityListingDao() {
		return cityListingDao;
	}


	/**
	 * @param cityListingDao the cityListingDao to set
	 */
	public void setCityListingDao(BotListCityListingDAO cityListingDao) {
		this.cityListingDao = cityListingDao;
	}

	public String getResultView() {
		return DEFAULT_RESULT_VIEW;
	}
	
	public String getSeachErrorView() {
		return ERROR_RESULT_VIEW;
	}
	
	/**
	 * Default Database Search.
	 * @Deprecated	Deprecated
	 * @return
	 */
	private ModelAndView defaultDatabaseSearch(final HttpServletRequest request, final HttpServletResponse response,
			final Object command, final BindException errors) {
		final BotListUserSearchForm userSearch = (BotListUserSearchForm) command;
		if (userSearch.getSearchEntry() == null || (userSearch.getSearchEntry().length() == 0)) {
			return new ModelAndView(this.getSeachErrorView());
		}
		
		// Cache the last search term
		final HttpSession session = request.getSession(false);
		if (session != null) {
			session.setAttribute(BotListSessionManager.CURRENT_SEARCH_TERM, userSearch);
		}
		
		final List listings = this.getUserSearchDao().list(userSearch.getSearchEntry().trim());
		userSearch.setListings(listings);
		final ModelAndView mvc = new ModelAndView(getResultView());
		mvc.addObject("command", userSearch);
		return mvc;
	}
	
	private ModelAndView defaultIndexSearch(HttpServletRequest request,
			HttpServletResponse response, Object command, BindException errors) throws Exception {
		
		BotListUserSearchForm userSearch = (BotListUserSearchForm) command;
		if (userSearch.getSearchEntry() == null || (userSearch.getSearchEntry().length() == 0)) {
			return new ModelAndView(this.getSeachErrorView());
		}
		
		// Cache the last search term
		HttpSession session = request.getSession(false);
		if (session != null) {
			session.setAttribute(BotListSessionManager.CURRENT_SEARCH_TERM, userSearch);
		}		
		IndexSearchHandler searchHandler = new EntityLinkSearchHandler(); 
		searchHandler.setSettings(this.getApplicationContext());
		List searchResults = searchHandler.search(userSearch.getSearchEntry());
		userSearch.setListings(searchResults);
		ModelAndView mvc = new ModelAndView(getResultView());
		mvc.addObject("command", userSearch);
		return mvc;
	}
	
	protected ModelAndView processFormSubmission(HttpServletRequest request,
                HttpServletResponse response,
                Object command,
                BindException errors) throws Exception {
		
		return defaultIndexSearch(request, response, command, errors);		
	}
	
	private Collection findCityListings() {
		if (this.getCityListingDao() != null) {
			Collection cities = this.getCityListingDao().findCityListings();
			return cities;
		} else {
			return null;
		}
	}
		
	/**
	 * Get the home link list
	 */
	private List getHomeLinkList() {
		String queryStr = "from org.spirit.bean.impl.BotListEntityLinks as links order by links.createdOn desc";
		return this.getEntityLinksDao().pageEntityLinks(queryStr, 0, MAX_HOME_LINKS);
	}
	
	/**
	 * Get Search Topics Listings.
	 */
	private List getHotTopics() {
		List topics = null;
		if (this.searchQueryFiltersDao != null) {
			topics = this.searchQueryFiltersDao.listHotTopics(20);
		}
		return topics;
	}
	
	/**
	 * Get Media Entries Found 
	 */
	private List getMediaList() {
		List mediaList = null;
		if (this.getCoreSettings().isMediaEnabled()) {			
			mediaList = this.getActiveMediaFeedsDao().readActiveMediaList("H", 2);
		}
		return mediaList;
	}
	
	/**
	 * Call system utilities before loading the ruby objects. 
	 */
	private void jSystemInit(HttpServletRequest request) {
		// If user cooke is available, auto login.
		BotListCookieManager.systemGetUserCookieParams(request, this.getCoreUsersDao(), this.getProfileSettingsDao());		
	}
	
	
	/**
	 * @see org.springframework.web.servlet.mvc.AbstractController#handleRequestInternal(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	 */
	protected ModelAndView showForm(HttpServletRequest request, HttpServletResponse response, BindException errors) { 
		
		ModelAndView mvc = new ModelAndView("index");
		String headline = null;
		if (this.getAdminMainBannerDao() != null) {
			BotListAdminMainBanner banner = this.getAdminMainBannerDao().readBanner("botverse");
			if (banner != null)
				headline = banner.getHeadline();	
		}		
		// Open a session if it has already not been created.
		HttpSession session = request.getSession(false);
		if (session == null) {
			// Create new session.
			log.info("creating new session from index request");
			session = request.getSession(true);
		}
		
		jSystemInit(request);
		
		mvc.addObject("headline", headline);
		mvc.addObject("linkCount", new Long(this.getEntityLinksDao().getLinkCount()));		
		mvc.addObject("userInfo", BotListContractManager.getUserInfo(request));
					
		mvc.addObject("linklistings", this.getHomeLinkList());
		mvc.addObject("hotTopics", this.getHotTopics());
		
		// Display the video media list section
		mvc.addObject("mediaListEnabled", new Boolean(this.getCoreSettings().isMediaEnabled()));
		mvc.addObject("mediaList", this.getMediaList());
		
		mvc.addObject("command", new BotListUserSearchForm());
		
		// Perform an audit of this page.
		if (getHandler() != null) {
			getHandler().auditLogPage(request, "index.html");
		}		
		return mvc;
	}

	/**
	 * @return the entityLinksDao
	 */
	public BotListEntityLinksDAO getEntityLinksDao() {
		return entityLinksDao;
	}


	/**
	 * @param entityLinksDao the entityLinksDao to set
	 */
	public void setEntityLinksDao(BotListEntityLinksDAO entityLinksDao) {
		this.entityLinksDao = entityLinksDao;
	}


	/**
	 * @return the userSearchDao
	 */
	public BotListUserSearchDAO getUserSearchDao() {
		return userSearchDao;
	}


	/**
	 * @param userSearchDao the userSearchDao to set
	 */
	public void setUserSearchDao(BotListUserSearchDAO userSearchDao) {
		this.userSearchDao = userSearchDao;
	}


	public BotListAdminMainBannerDAO getAdminMainBannerDao() {
		return adminMainBannerDao;
	}


	public void setAdminMainBannerDao(BotListAdminMainBannerDAO adminMainBannerDao) {
		this.adminMainBannerDao = adminMainBannerDao;
	}


	public BotListCoreSettings getCoreSettings() {
		return coreSettings;
	}


	public void setCoreSettings(BotListCoreSettings coreSettings) {
		this.coreSettings = coreSettings;
	}


	public BotListActiveMediaFeedsDAO getActiveMediaFeedsDao() {
		return activeMediaFeedsDao;
	}


	public void setActiveMediaFeedsDao(
			BotListActiveMediaFeedsDAO activeMediaFeedsDao) {
		this.activeMediaFeedsDao = activeMediaFeedsDao;
	}


	public BotListMediaFeedsDAO getMediaFeedsDao() {
		return mediaFeedsDao;
	}


	public void setMediaFeedsDao(BotListMediaFeedsDAO mediaFeedsDao) {
		this.mediaFeedsDao = mediaFeedsDao;
	}


	public BotListSearchQueryFiltersDAO getSearchQueryFiltersDao() {
		return searchQueryFiltersDao;
	}


	public void setSearchQueryFiltersDao(BotListSearchQueryFiltersDAO searchQueryFiltersDao) {
		this.searchQueryFiltersDao = searchQueryFiltersDao;
	}


	public BotListCoreUsersDAO getCoreUsersDao() {
		return coreUsersDao;
	}


	public void setCoreUsersDao(BotListCoreUsersDAO coreUsersDao) {
		this.coreUsersDao = coreUsersDao;
	}


	public BotListProfileSettingsDAO getProfileSettingsDao() {
		return profileSettingsDao;
	}


	public void setProfileSettingsDao(BotListProfileSettingsDAO profileSettingsDao) {
		this.profileSettingsDao = profileSettingsDao;
	}

}
