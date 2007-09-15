/**
 * Berlin Brown
 * Copyright (c) 2006 - 2007, Newspiritcompany.com
 *
 * May 13, 2007
 */
package org.spirit.spring.errors;

/**
 * This is class is used by botverse.
 * @author Berlin Brown
 *
 */
public class InvalidBusinessObjectException extends RuntimeException {

	/**
	 * 
	 */
	private static final long serialVersionUID = -2951448653231636406L;
	
	public InvalidBusinessObjectException() {
		super("ERR: Error attempting to create business object");
	}
	
	public InvalidBusinessObjectException(String msg) {
		super(msg);
	}
	
}
