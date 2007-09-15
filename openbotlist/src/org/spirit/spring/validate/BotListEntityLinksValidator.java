/**
 * Berlin Brown
 * Nov 18, 2006
 */
package org.spirit.spring.validate;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.commons.validator.UrlValidator;
import org.spirit.form.BotListEntityLinksForm;
import org.spirit.util.text.KeywordProcessor;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;

/**
 * This is class is used by botverse.
 * @author Berlin Brown
 *
 */
public class BotListEntityLinksValidator implements Validator {
	
	private Log log = LogFactory.getLog(getClass());
	
	/**
	 * @see org.springframework.validation.Validator#supports(java.lang.Class)
	 */
	public boolean supports(Class post) {
		return BotListEntityLinksForm.class.isAssignableFrom(post);
	}	
	
	/**
	 * Check for a valid url entry.
	 */
	private boolean isValidUrl(String url) {
		String[] schemes = { "http","https" };
		UrlValidator urlValidator = new UrlValidator(schemes, UrlValidator.NO_FRAGMENTS);		    
		return urlValidator.isValid(url);
	}
	
	
	/**
	 * @see org.springframework.validation.Validator#validate(java.lang.Object, org.springframework.validation.Errors)
	 */
	public void validate(Object obj, Errors errors) {
		
		BotListEntityLinksForm form = (BotListEntityLinksForm) obj;		
		ValidationUtils.rejectIfEmptyOrWhitespace(errors,
				"urlTitle", "required", "* Title Field is required.");				
		ValidationUtils.rejectIfEmptyOrWhitespace(errors,
				"mainUrl", "required", "* Please submit a URL or use 'self'.");
		ValidationUtils.rejectIfEmptyOrWhitespace(errors,				
				"keywords", "required", "* Please enter keyword tags (space separated).");
		ValidationUtils.rejectIfEmptyOrWhitespace(errors,				
				"fullName", "required", "* Please enter a valid username (e.g botrover20).");
		ValidationUtils.rejectIfEmptyOrWhitespace(errors,				
				"userSolution", "required", "* Please add the following values.");	
		if (form != null) {
			if (!KeywordProcessor.validateFilterAlphaNumeric(form.getFullName())) {
				errors.reject("fullName", "* Please enter a valid username (for example: botrover20).");
			}
		}
		if ((form != null) && (form.getMainUrl() != null)) {			
			String url = form.getMainUrl();					
			// If url does not equal self and is not a valid url, flag an error
			if (!url.equalsIgnoreCase("self") && !this.isValidUrl(url)) {
				errors.reject("mainUrl", "* Please enter a valid url address (for example: http://www.url.com) or use 'self'");
			}
		}	
		if ((form != null) 
					&& (form.getUserSolution() != null)
					&& (form.getUserSolution() != null)) {				
				if (form.getPrevSolution().intValue() != form.getUserSolution().intValue()) {
					errors.reject("userSolution", "* Please add the following values.");
				}
		}	
				
	}

}
