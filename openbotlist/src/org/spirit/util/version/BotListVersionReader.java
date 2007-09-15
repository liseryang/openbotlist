/**
 * Berlin Brown
 * Dec 22, 2006
 */
package org.spirit.util.version;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.PropertyResourceBundle;
import java.util.ResourceBundle;

/**
 * This is class is used by botverse.
 * @author Berlin Brown
 *
 */
public class BotListVersionReader {
	
	public static final int MAJOR = 0;
	public static final int MINOR = 1;
	public static final int BUILD = 2;
	public static final int REV = 3;
	public static final int MILESTONE = 4;
	
	public static String readLogFile(String filename) throws IOException {
		BufferedReader in = new BufferedReader(new FileReader (filename));
		StringBuffer buf = new StringBuffer();
		try {
			String str;
			while ((str = in.readLine()) != null) {
				buf.append(str);
			}
		} finally {
			in.close();
		}
		return buf.toString().trim();
	}
	
	public static void writePropertyFile(PrintWriter out, String [] tuple) {
		// Write to the new property file
		out.println("# (dynamically generated, edit with caution)");
		out.println("versMajor=" + tuple[MAJOR]);
		out.println("versMinor=" + tuple[MINOR]);
		out.println("versBuild=" + tuple[BUILD]);
		out.println("versRev=" + tuple[REV]);
		out.println("versMilestone=" + tuple[MILESTONE]);			
		
	}
	
	public static void main(String [] args) throws Exception {
		
		if (args.length != 2) {
			System.out.println("usage: -f <Output Property File>");
			return;
		}
		  
		PropertyResourceBundle rb = (PropertyResourceBundle) ResourceBundle.getBundle("version");
		String major = rb.getString("versMajor").trim();
		String minor = rb.getString("versMinor").trim();
		String build = rb.getString("versBuild").trim();
		String revision = rb.getString("versRev").trim();
		String milestone = rb.getString("versMilestone").trim();
		
		// Read the svn version log file
		String svnrev = readLogFile("svnversion.log");
		
		// Read the input version file and write to
		// the class directory
		PrintWriter out = null;
		PrintWriter curOut = null;
		try {
			out = new PrintWriter(new BufferedWriter(
					   	new FileWriter(args[1])));
			curOut = new PrintWriter(new BufferedWriter(
				   	new FileWriter("version.properties")));
			
			// Increase the build number and write the
			// revision
			int buildVal = Integer.parseInt(build);
			buildVal++;
			build = "" + buildVal;
			revision = svnrev;
			
			writePropertyFile(out, new String [] {
					major, minor,
					build, revision, milestone,
			});
			writePropertyFile(curOut, new String [] {
					major, minor,
					build, revision, milestone,
			}); 
			
			System.out.println("done; wrote property file to =" + args[1]);
		} catch(IOException ex) {
			ex.printStackTrace();
		} finally {			
			if (out != null) {
				out.close();
			}
			if (curOut != null) {
				curOut.close();
			}
		
		}
		
	}
	
}
