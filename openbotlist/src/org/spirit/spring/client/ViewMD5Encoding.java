/**
 * Berlin Brown
 * Nov 21, 2006
 */
package org.spirit.spring.client;

import org.acegisecurity.providers.encoding.Md5PasswordEncoder;

/**
 * This is class is used by botverse.
 * @author Berlin Brown
 *
 */
public class ViewMD5Encoding {
	
	 public static void main(String[] args) throws Exception {
		 
	        System.out.println("running...");
	        if (args.length != 2) {
	        	System.out.println("Usage: ViewMD5Encoding -i <password>");
	        	return;
	        }
	        
	        Md5PasswordEncoder encode = new Md5PasswordEncoder();
	        String res = encode.encodePassword(args[1], null);
	        System.out.println("MD5 encoding=" + res);
	    }
}
