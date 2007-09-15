/**
 * Berlin Brown
 * Copyright (c) 2006 - 2007, Newspiritcompany.com
 *
 * Apr 10, 2007
 */
package org.spirit.spring.client;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Date;

import org.acegisecurity.providers.encoding.Md5PasswordEncoder;
import org.spirit.util.BotListUniqueId;

/**
 * This is class is used by botverse.
 * @author Berlin Brown
 *
 * Command line application to generate the insert statement
 * for creating a new user.
 */
public class GenerateUserDDL {
	
	private static final String DDL_LOG_FILE = "user_ddl.sql";
	private static final String NEWLINE = "\r\n";
	
	public static void writeDDL(final String line) {
		
		BufferedWriter ddlout = null;
		try {
			ddlout = new BufferedWriter(new FileWriter(DDL_LOG_FILE, true));
			ddlout.write(NEWLINE + "-------------------------------");
			ddlout.write("New User Insert Statement, Created At=" + new Date() + NEWLINE);
			ddlout.write(line);
			ddlout.write(NEWLINE);
			System.out.println("Done writing SQL User Insert Statement.");
		} catch(IOException e) {
			e.printStackTrace();
		} finally {
            if (ddlout != null) {            	
            	try {
            		ddlout.flush();
					ddlout.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
            }
        }             
	}
	
	public static void main(String[] args) throws Exception {
		 
        System.out.println("Generating User DDL");
        if (args.length != 3) {
        	System.out.println("Usage: GenerateUserDDL <user> <password> <email>");
        	return;
        }                
        
        Md5PasswordEncoder encode = new Md5PasswordEncoder();
        String userName = args[0];
        String password = args[1];
        String email = args[2];
        String dob = "1981-01-01";
        
        String account = "";
    	String active = "1";
    	
    	// Hash the password.
    	password = encode.encodePassword(password, null);
    	account =  BotListUniqueId.getUniqueId() + userName;
        StringBuffer buf = new StringBuffer();
        
        buf.append("insert into core_users(");
        buf.append("user_name, ");
        buf.append("user_password, ");
        buf.append("user_email, ");
        buf.append("date_of_birth, ");    	
        buf.append("account_number, ");
        buf.append("active_code, ");    	
        buf.append("last_login_success, ");
        buf.append("last_login_failure, ");
        buf.append("created_on, "); 
        buf.append("updated_on) VALUES(\n    ");
        
        // Add the actual values.
        buf.append("'" + userName + "', ");
        buf.append("'" + password + "', ");
        buf.append("'" + email + "', ");
        buf.append("'" + dob + "', ");
        buf.append("'" + account + "', ");
        buf.append("" + active + ", ");
        
        // Set the Four dates to NOW()
        // last_login_success, last_login_failure, created_on, updated_on
        buf.append("NOW(), NOW(), NOW(), NOW()");
        buf.append(");\n");
            	
        System.out.println("generating=");
        System.out.println(buf.toString());
    	writeDDL(buf.toString());                       
	}	
}
