/**
 * Berlin Brown
 * Copyright (c) 2006 - 2007, Newspiritcompany.com
 *
 * Jan 12, 2007
 */
package org.spirit.spring.util;

import javax.servlet.http.HttpServletRequest;

/**
 * The generic handler allows you to use any URI wildcard.
 * 
 * @author Berlin Brown
 *
 */
public class BotListGenericHandler {

	private String springServletContext = "";
	
	public BotListGenericHandler(String springContext) {
		this.springServletContext = springContext;
	}
	
	/**
	 * Get JSP Path Pos.
	 * i.e. extract 'mypath/file.html' from '/webapp/b/mypath/file.html'
	 */
	private int getJspPathPos(String uri, String contextPath) {
		
		// Example, /webapp/spring
		String target = contextPath + "/" + this.getSpringServletContext();		
		int len = target.length();
		return uri.startsWith(target) ? len : -1;		
	}
	
	/**
	 * This function is quite similar to the Jobster internal PathToViewController.
	 * Duplicated here so that the RAD module can be self contained.
	 */
	public String getViewNameFromServletPath(String servletPath, String uri, String contextPath) {

		String viewName = servletPath;
		int beg = 0, end = viewName.length();		
		if (end > 0 && viewName.charAt(0) == '/') {
			beg = 1;
		} else {
			// We are now assuming incoming servletPath is actually a full URL
			// beg = servletPath.lastIndexOf('/');
			if (getJspPathPos(uri, contextPath) != -1) {
				beg = getJspPathPos(uri, contextPath);
			}
		}
		
		int dot = viewName.lastIndexOf('.');
		if (dot >= 0) {
			end = dot;
		}
		viewName = viewName.substring(beg, end);		
		return viewName;

	}
	
	public String getDefaultViewNameFromRequest(HttpServletRequest request) {	
		return getViewNameFromServletPath(request.getRequestURI().substring(1),
				request.getRequestURI(), request.getContextPath());
	}

	/**
	 * @return the springServletContext
	 */
	public String getSpringServletContext() {
		return springServletContext;
	}

	/**
	 * @param springServletContext the springServletContext to set
	 */
	public void setSpringServletContext(String springServletContext) {
		this.springServletContext = springServletContext;
	}
	
	
}
